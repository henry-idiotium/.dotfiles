-- Highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank {
            higroup = 'Visual',
            timeout = 250,
        }
    end,
})

vim.api.nvim_create_autocmd({ 'FileType', 'BufReadPre', 'FileReadPre' }, {
    pattern = { 'help', 'qf' },
    callback = function()
        vim.cmd [[
            setlocal number
            setlocal nu
        ]]
    end,
})

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd('InsertLeave', {
    pattern = '*',
    command = 'set nopaste',
})

-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'json', 'jsonc', 'markdown' },
    callback = function() vim.opt.conceallevel = 0 end,
})
