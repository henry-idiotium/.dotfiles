local M = {}
M.toggle = {}

---@param on_attach fun(client?: vim.lsp.Client, buffer: number)
function M.on_attach(on_attach)
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('nihil_lsp_attach', { clear = false }),
        callback = function(args)
            local buffer = args.buf ---@type number
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            on_attach(client, buffer)
        end,
    })
end

--- Toggle inlay hint
---@param buffer? number
---@param value? boolean
function M.toggle.inlay_hints(buffer, value)
    local filter = { bufnr = buffer }
    if value == nil then value = not vim.lsp.inlay_hint.is_enabled(filter) end
    vim.lsp.inlay_hint.enable(value, filter)
end

return M
