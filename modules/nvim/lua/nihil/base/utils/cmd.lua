local M = {}

--- Return a callback that execute vim command.
---@param cmd string
function M.callbackRun(cmd)
    return function() vim.cmd(cmd) end
end

nihil.utils.cmd = M

return {}
