---@diagnostic disable: no-unknown
local M = {}

---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.option(option, silent, values)
    if values then
        vim.opt_local[option] = (vim.opt_local[option]:get() == values[1]) and values[2] or values[1]
        return Nihil.log.info('Set ' .. option .. ' to ' .. vim.opt_local[option]:get(), { title = 'Option' })
    end

    vim.opt_local[option] = not vim.opt_local[option]:get()
    if not silent then
        if vim.opt_local[option]:get() then
            Nihil.log.info('Enabled ' .. option, { title = 'Option' })
        else
            Nihil.log.warn('Disabled ' .. option, { title = 'Option' })
        end
    end
end

---@param values? {[1]:any, [2]:any}
---@param scope? 'g'|'b'|'w'|'t'|'v' default: 'g'
function M.var(name, values, scope)
    scope = scope or 'g'
    local old_val = vim[scope][name]

    if values then
        vim[scope][name] = (old_val == values[1]) and values[2] or values[1]
        return Nihil.log.info('Set ' .. name .. ' to ' .. vim[scope][name], { title = 'Option' })
    end

    vim[scope][name] = not old_val
end

function M.diagnostics()
    local enabled = not vim.diagnostic.is_enabled()
    vim.diagnostic.enable(enabled)

    local msg = (enabled and 'Enabled' or 'Disabled') .. ' diagnostics'
    local lvl = enabled and 'info' or 'warn'
    Nihil.log[lvl](msg, { title = 'Diagnostics' })
end

---@param buf? number
---@param value? boolean
function M.inlay_hints(buf, value)
    local ih = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
    if type(ih) == 'function' then
        ih(buf, value)
    elseif type(ih) == 'table' and ih.enable then
        if value == nil then value = not ih.is_enabled { bufnr = buf or 0 } end
        ih.enable(value, { bufnr = buf })
    end
end

return M
