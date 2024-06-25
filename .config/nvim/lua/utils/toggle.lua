local M = {}

---@param var string
---@param values? {[1]:any, [2]:any}
---@param scope? 'g'|'b'|'w'|'t'|'v' default: 'g'
function M.var(var, values, scope)
    scope = scope or 'g'
    local old_val = vim[scope][var]

    if values then
        vim[scope][var] = (old_val == values[1]) and values[2] or values[1]
        return LazyVim.info(string.format('Set %s to %s', var, vim[scope][var]), { title = 'Option' })
    end

    vim[scope][var] = not old_val
    LazyVim.info((vim[scope][var] and 'Enabled ' or 'Disabled ') .. var, { title = 'Option' })
end

return M
