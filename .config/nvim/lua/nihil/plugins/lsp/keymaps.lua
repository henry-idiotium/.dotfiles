local M = {}

function M.on_attach(_, buffer)
    local map = function(modes, lhs, rhs, extra_opts) vim.keymap.set(modes, lhs, rhs, vim.tbl_extend('force', { buffer = buffer }, extra_opts or {})) end

    map('n', 'gd', '<cmd>FzfLua lsp_definitions<cr>', { desc = 'Goto Definition' })
    map('n', 'g<s-d>', '<cmd>FzfLua lsp_declarations<cr>', { desc = 'Goto declaration' })
    map('n', 'gr', '<cmd>FzfLua lsp_references<cr>', { desc = 'Goto/listing references' })
    map('n', 'gi', '<cmd>FzfLua lsp_implementations<cr>', { desc = 'Goto Implementation' })

    map('n', '<s-k>', vim.lsp.buf.hover, { desc = 'Hover/Show definition' })
    map('i', '<c-k>', vim.lsp.buf.signature_help, { desc = 'Show signature' })
    map('n', 'gk', vim.lsp.buf.signature_help, { desc = 'Show signature' })

    map('n', '<leader>cl', '<cmd>LspInfo<cr>', { desc = 'Lsp Info' })
    map('n', '<leader>cr', vim.lsp.buf.rename, { desc = 'Rename symbol' })
    map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Open diagnostics' })
    map({ 'n', 'v' }, '<leader>ca', '<cmd>FzfLua lsp_code_actions<cr>', { desc = 'Code actions' })

    map('n', '<leader>tli', require('nihil.util.lsp').toggle.inlay_hints, { desc = 'Toggle inlay hints' })
end

return M
