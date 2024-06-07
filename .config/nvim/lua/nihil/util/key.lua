---@diagnostic disable: no-unknown
local M = {}

---@param raw_opts ReolveRawKeymapOpts
function M.resolve_raw_keymap_opts(raw_opts)
    local opts = {} ---@type vim.keymap.set.Opts
    local lhs = raw_opts[1] ---@type string
    local rhs = raw_opts[2] ---@type string|function
    local mode = raw_opts.mode or 'n' ---@type string|string[]

    for key, value in pairs(raw_opts) do
        -- is string and skip key mode
        local cond = type(key) == 'string' and key ~= 'mode'
        opts[key] = cond and value or nil
    end

    return mode, lhs, rhs, opts
end

return M

---@class ReolveRawKeymapOpts : vim.keymap.set.Opts
---@field mode? string|string[]
---@field lhs? string
---@field rhs? string|function
