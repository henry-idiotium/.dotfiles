local M = {}

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

return M
