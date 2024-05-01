---@diagnostic disable: no-unknown
local function augroup(name) return vim.api.nvim_create_augroup('nihil_' .. name, { clear = true }) end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
    group = augroup 'checktime',
    callback = function() return vim.o.buftype ~= 'nofile' and vim.cmd 'checktime' end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
    group = augroup 'highlight_yank',
    callback = function()
        vim.highlight.on_yank {
            higroup = 'Visual',
            timeout = 250,
        }
    end,
})

-- Wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd('FileType', {
    group = augroup 'content_wrap',
    pattern = {
        'gitcommit',
        'markdown',
        'noice',
        'typescriptreact',
        'javascriptreact',
    },
    command = 'setlocal wrap',
})

-- content concealment
vim.api.nvim_create_autocmd('FileType', {
    group = augroup 'content_concealment',
    pattern = { 'markdown' },
    command = 'setlocal conceallevel=2',
})

local exclude_filetypes = {
    'qf',
    'vim',
    'help',
    'hgcommit',
    'gitcommit',
    'gitrebase',
    'svn',
    'netrw',
    'notify',
    'query',
    'lazy',
    'lspinfo',
    'checkhealth',
    'spectre_panel',
    'startuptime',
    'neotest-output',
    'neotest-summary',
    'neotest-output-panel',
    'PlenaryTestPopup',
    'Trouble',
}

-- Easy closing
vim.api.nvim_create_autocmd('FileType', {
    group = augroup 'easy_closing',
    pattern = exclude_filetypes,
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        local function map(m, lhs) vim.keymap.set(m, lhs, '<cmd>close<cr>', { buffer = event.buf, silent = true }) end
        map('n', 'q')
        map('n', '<c-q>')
    end,
})

-- go to previous cursor location
vim.api.nvim_create_autocmd('BufReadPost', {
    group = augroup 'last_loc',
    callback = function(event)
        if vim.tbl_contains(exclude_filetypes, vim.bo.filetype) then return end

        local buf = event.buf
        local has_mark, mark = pcall(vim.api.nvim_buf_get_mark, buf, '"')
        if vim.b[buf].last_loc or not has_mark then return end

        vim.b[buf].last_loc = true
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
    end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    group = augroup 'auto_create_interm_absent_dirs',
    callback = function(event)
        if event.match:match '^%w%w+:[\\/][\\/]' then return end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
    end,
})

-- Set filetypes
local function ft_pattern(pattern, ft) vim.cmd(' autocmd BufNewFile,BufRead ' .. pattern .. ' setfiletype ' .. ft) end
ft_pattern('*.astro', 'astro')
ft_pattern('Podfile', 'ruby')
