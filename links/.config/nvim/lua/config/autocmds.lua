---@diagnostic disable: no-unknown
vim.cmd [[ autocmd BufNewFile,BufRead *.astro setfiletype astro ]]
vim.cmd [[ autocmd BufNewFile,BufRead Podfile setfiletype ruby ]]

local function augroup(name) return vim.api.nvim_create_augroup(name, { clear = true }) end

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

-- close with q
vim.api.nvim_create_autocmd('FileType', {
    group = augroup 'CloseWithCtrlQ',
    pattern = {
        'netrw',
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set('n', '<c-q>', '<cmd>close<cr>', { buffer = event.buf, silent = true })
    end,
})
