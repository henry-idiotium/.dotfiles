---@diagnostic disable: no-unknown
local M = {}

local skip = {
    mode = true,
    lhs = true,
    rhs = true,
}

---@param raw ResolveRawKeymapOptions
function M.resolve_raw_options(raw)
    local opts = {} ---@type vim.keymap.set.Opts
    local lhs = raw[1]
    local rhs = raw[2]

    raw.mode = raw.mode or 'n'
    local modes = type(raw.mode) == 'table' and raw.mode or { raw.mode }

    for k, v in pairs(raw) do
        if type(k) ~= 'number' and not skip[k] then opts[k] = v end
    end

    return modes, lhs, rhs, opts
end

return M

---@class ResolveRawKeymapOptions : vim.keymap.set.Opts
---@field [1] string
---@field [2] string|function
---@field mode? string|string[]
