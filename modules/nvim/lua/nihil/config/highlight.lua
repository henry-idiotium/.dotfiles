vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'
vim.opt.termguicolors = true
vim.opt.winblend = 0
vim.opt.wildoptions = 'pum'
vim.opt.pumblend = 5
vim.opt.background = 'dark'

local api = vim.api

-- Highlight yanked text via the 'visual' highlight group
--api.nvim_set_hl(0, 'CursorLineNr', { bg = '#1a1b24', fg = '#84b9fa' })
api.nvim_create_autocmd('TextYankPost', {
    group = api.nvim_create_augroup('highlight_yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank {
            higroup = vim.g.vscode and 'IncSearch' or 'Visual',
            timeout = 250,
        }
    end,
})

return {}
