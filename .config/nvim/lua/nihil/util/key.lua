local M = {}

---@param raw_opts table<string|number,any>
---@return { mode:string, lhs:string, rhs: string|function, opts: table<string,any> }
function M.resolve_opts(raw_opts)
    local args = {}
    args.opts = {} ---@type table<string|number,any>
    args.lhs = raw_opts[1] ---@type string
    args.rhs = raw_opts[2] ---@type string|function
    args.mode = raw_opts.mode or 'n' ---@type string

    for key, value in pairs(raw_opts) do
        -- is string and skip key mode
        local cond = type(key) == 'string' and key ~= 'mode'
        args.opts[key] = cond and value or nil
    end

    return args
end

return M
