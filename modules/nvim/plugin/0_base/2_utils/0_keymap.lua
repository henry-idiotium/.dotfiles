local M = {}


local DEFAULT_OPTIONS = {
    desc    = nil,
    buffer  = nil,
    silent  = true,
    noremap = true,
    nowait  = false,
    remap   = false,
    expr    = false,
}
local function extract_keymap_options(tbl, default_options)
    local def_opts = default_options or DEFAULT_OPTIONS
    local opts     = {}
    opts.desc      = tbl.desc or def_opts.desc
    opts.buffer    = tbl.buffer or def_opts.buffer
    opts.silent    = tbl.silent or def_opts.silent
    opts.noremap   = tbl.noremap or def_opts.noremap
    opts.nowait    = tbl.nowait or def_opts.norewait
    opts.remap     = tbl.remap or def_opts.remap
    opts.expr      = tbl.expr or def_opts.expr
    return opts
end


--- Map key
---@param mode  string|table
---@param lhs   string
---@param rhs   string|table
---@param opts  table
function M.map(mode, lhs, rhs, opts)
    opts = opts or {}
    mode = mode or { 'n' }

    -- if `mode` is something like 'ni', then split them into table
    if type(mode) == 'string' then
        mode = nihil.utils.str.split(mode, '')
    end

    -- set keymap in safe mode, then log the error ones
    local success, _ = pcall(vim.keymap.set, mode, lhs, rhs, opts)
    if not success then
        if nihil.user.log_error then
            print('[ERROR] Keymap: ' .. opts.desc
                .. '\n    MODE: ' .. mode
                .. '\n    LHS:  ' .. lhs)
            print '\n\n'
        end
    end
end

--- Unmap the keymaps with schema-like structure. Specifically, the schema will
--- map to the <NOP>.
---@param schema table
function M.unmap_schema(schema)
    for _, sm in ipairs(schema) do
        local is_tbl = type(sm) == 'table'
        local key    = is_tbl and sm[1] or sm
        local mode   = is_tbl and (sm.mode or '') or ''

        pcall(vim.keymap.set, mode, key, '')
    end
end

--- Map keymaps with schema-like structure.
---@param schema table
function M.map_schema(schema)
    for _, sm in ipairs(schema) do
        local mode = sm.mode
        local lhs  = sm[1]
        local rhs  = sm[2]
        local opts = extract_keymap_options(sm)

        M.map(mode, lhs, rhs, opts)
    end
end

--- Map keymaps into a group settings with schema-like structure.
---@param group_opts  table
---@param schema      table
function M.map_schema_group(group_opts, schema)
    if group_opts.enable == false then return end

    local prefix = group_opts.prefix or ''

    -- Register group into `which key`
    if group_opts.name then
        local wk_present, which_key = pcall(require, 'which-key')
        if wk_present then
            which_key.register({
                [prefix] = { name = '+' .. group_opts.name }
            }, {})
        end
    end

    for _, child_schema in pairs(schema) do
        if child_schema.enable == false then goto continue end

        local mode = child_schema.mode or group_opts.mode
        local lhs  = prefix .. child_schema[1]
        local rhs  = child_schema[2]
        local opts = extract_keymap_options(child_schema, group_opts)

        M.map(mode, lhs, rhs, opts)

        ::continue::
    end
end

nihil.utils.keymap = M
