local M = {}

function M.on_attach(_, buffer)
    local map = function(modes, lhs, rhs, extra_opts) vim.keymap.set(modes, lhs, rhs, vim.tbl_extend('force', { buffer = buffer }, extra_opts or {})) end

    map('n', 'gd', function() require('telescope.builtin').lsp_definitions { reuse_win = false } end, { desc = 'Goto Definition' })
    map('n', 'g<s-d>', vim.lsp.buf.declaration, { desc = 'Goto declaration' })
    map('n', 'gr', vim.lsp.buf.references, { desc = 'Goto/show references' })
    map('n', 'gr', '<cmd>Telescope lsp_references<cr>', { desc = 'References in telescope' })
    map('n', 'g<s-i>', function() require('telescope.builtin').lsp_implementations { reuse_win = true } end, { desc = 'Goto Implementation' })
    map('n', 'gy', function() require('telescope.builtin').lsp_type_definitions { reuse_win = true } end, { desc = 'Goto T[y]pe Definition' })

    map('n', '<s-k>', vim.lsp.buf.hover, { desc = 'Hover/Show definition' })
    map('i', '<c-k>', vim.lsp.buf.signature_help, { desc = 'Show signature' })
    map('n', 'gk', vim.lsp.buf.signature_help, { desc = 'Show signature' })

    -- code actions
    map('n', '<leader>cl', '<cmd>LspInfo<cr>', { desc = 'Lsp Info' })
    map('n', '<leader>cr', vim.lsp.buf.rename, { desc = 'Rename symbol' })
    map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Open diagnostics' })
    map('n', '<leader>cws', vim.lsp.buf.workspace_symbol, { desc = 'List workspace symmbols' })
    map({ 'n', 'v' }, '<leader>cc', vim.lsp.codelens.run, { desc = 'Run codelens' })
    map('n', '<leader>c<s-c>', vim.lsp.codelens.refresh, { desc = 'Refresh & Display Codelens' })
    map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code actions' })
    map('n', '<leader>c<s-a>', function() vim.lsp.buf.code_action { context = { only = { 'source' }, diagnostics = {} } } end, { desc = 'Code actions' })

    -- map('n', '<leader>tih', require('nihil.plugins.lsp.utils').toggle.inlay_hints, { desc = 'Toggle inlay hints' })
end

return M
