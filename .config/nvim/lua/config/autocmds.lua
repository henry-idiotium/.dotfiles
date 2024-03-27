vim.cmd [[ autocmd BufNewFile,BufRead *.astro setfiletype astro ]]
vim.cmd [[ autocmd BufNewFile,BufRead Podfile setfiletype ruby ]]

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
