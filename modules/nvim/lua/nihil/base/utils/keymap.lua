---@diagnostic disable: inject-field, assign-type-mismatch, duplicate-doc-field, undefined-doc-name, duplicate-doc-alias
local M = {}

---@type MapKeyBuiltInOption
local OPTION_MASKS = { desc = 'desc', buffer = 'buffer', silent = true, noremap = true, nowait = true, remap = true, expr = true }

--
---@type MapKeyOption
local DEFAULT_MAPKEY_OPTIONS = {
    mode = 'n',
    desc = nil,
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = false,
    remap = false,
    expr = false,
}

local function extract_mapkey_options(tbl, def_opts)
    if type(tbl) ~= 'table' then tbl = {} end
    if type(def_opts) ~= 'table' then
        def_opts = def_opts or {}
        if vim.tbl_isempty(def_opts) then def_opts = DEFAULT_MAPKEY_OPTIONS end
    end

    return {
        mode = tbl.mode or def_opts.mode,
        desc = tbl.desc or def_opts.desc,
        buffer = tbl.buffer or def_opts.buffer,
        silent = tbl.silent or def_opts.silent,
        noremap = tbl.noremap or def_opts.noremap,
        nowait = tbl.nowait or def_opts.nowait,
        remap = tbl.remap or def_opts.remap,
        expr = tbl.expr or def_opts.expr,
    }
end

--- Mapings keys using `which-key`
---
--- > **NOTE**: keymaps have to be `string` for `map_keys` to work as expected
---
---@param _schema MapKeyFuncSchema
---@param _opts?  MapKeyFuncOptions
function M.map_keys(_schema, _opts)
    _opts = _opts or {}

    local wk_exist, wk = pcall(require, 'which-key')
    if not wk_exist and vim.log.levels.DEBUG then print '"Which-Key" not installed!' end

    local top_level_opts = extract_mapkey_options(_opts)

    ---Recursive mapping
    local function set_mapping(schema, prefix, sub_level_opts)
        if not prefix then prefix = '' end
        if top_level_opts then sub_level_opts = extract_mapkey_options(sub_level_opts, top_level_opts) end

        for keymap, sub_schema in pairs(schema) do
            -- keyname is matching options name
            if OPTION_MASKS[keymap] then goto continue end

            local opts = extract_mapkey_options(sub_schema, sub_level_opts) ---@type MapKeyBuiltInOption
            local mode = opts.mode
            local lhs = ''
            local rhs = ''

            -- key-as-index schema
            if type(keymap) == 'number' and type(sub_schema) == 'table' then
                lhs = prefix .. sub_schema[1]
                rhs = sub_schema[2]
            end

            -- key-as-name schema
            if type(keymap) == 'string' then
                local sub_schema_type = type(sub_schema)

                if sub_schema_type ~= 'table' then
                    lhs = prefix .. keymap
                    rhs = sub_schema
                else
                    -- if sub schema is a `hierarchy schema`
                    if type(sub_schema[1]) ~= 'string' and type(sub_schema[1]) ~= 'function' then
                        local next_keymap = prefix .. keymap
                        if wk_exist then wk.register({ [next_keymap] = { name = opts.desc } }, {}) end

                        set_mapping(sub_schema, next_keymap, opts)
                        goto continue -- escape current loop
                    end

                    -- if sub schema is mapable
                    lhs = prefix .. keymap
                    rhs = sub_schema[1]
                end
            end

            -- remove external key from options
            opts.mode = nil

            -- safely map key
            local map_succeeded, _ = pcall(vim.keymap.set, mode, lhs, rhs, opts)
            if not map_succeeded and vim.log.levels.DEBUG then
                print '\n[ERROR] Bad keymap: '
                print('        DESC: ' .. tostring(opts.desc))
                print('        MODE: ' .. tostring(mode))
                print('        LHS:  ' .. tostring(lhs))
                print('        RHS:  ' .. tostring(rhs))
                print '\n'
            end

            ::continue::
        end
    end

    set_mapping(_schema, _opts.prefix)
end

--- Unmap the keymaps with schema-like structure.
---@param keys_to_disable (string | { [1]: string, mode: Keymap_Modes | nil })[]
function M.unmap_keys(keys_to_disable)
    for _, args in ipairs(keys_to_disable) do
        local is_tbl = type(args) == 'table'
        local key = is_tbl and args[1] or args
        local mode = is_tbl and (args.mode or '') or ''

        pcall(vim.keymap.set, mode, key, '')
        pcall(vim.keymap.del, mode, key)
    end
end

nihil.utils.keymap = M

return {}

--#region Type definitions

---@class MapKeyFuncOptions : MapKeyOption
---@field prefix? string

---@class MapKeyFuncSchema
---@field [number]        SubMapKeySchemaKeyAsIndex
---@field [string]        SubMapKeySchemaKeyAsName
---@field [string|number] MapKeyFuncSchema | MapKeyAction

---@class SubMapKeySchemaKeyAsName : MapKeyOption
---@field [1] MapKeyAction  Right hand side
---@field [number] Never

---@class SubMapKeySchemaKeyAsIndex : MapKeyOption
---@field [1] string         Left hand side
---@field [2] MapKeyAction  Right hand side
---@field [number] Never

---@class MapKeyOption: MapKeyBuiltInOption
---@field mode? MapKeyMode | MapKeyMode[]

---@class MapKeyBuiltInOption
---@field desc?    string
---@field silent?  boolean
---@field noremap? boolean
---@field nowait?  boolean
---@field remap?   boolean
---@field expr?    boolean
---@field buffer?  any

---@diagnostic disable-next-line: duplicate-doc-alias
---@alias MapKeyMode
---| ''
---| 'n'
---| 'v'
---| 'i'
---| 'o'
---| 'c'

--- Remark: hacky workarround for negated all type (similiar to `never` in TS)
---@alias Never __never__

---@alias MapKeyAction
---| string
---| function

--#endregion
