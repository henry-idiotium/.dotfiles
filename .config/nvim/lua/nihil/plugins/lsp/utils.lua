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

-- M.toggle = {}
--
-- --- Toggle inlay hint
-- ---@param buffer? number
-- ---@param value? boolean
-- function M.toggle.inlay_hints(buffer, value)
--     local ih = vim.lsp.inlay_hint
--     if value == nil then value = not ih.is_enabled(buffer) end
--     ih.enable(value, { buffer = buffer })
-- end

return M
