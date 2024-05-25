---@diagnostic disable: no-unknown
local function augroup(name) return vim.api.nvim_create_augroup('nihil_' .. name, { clear = true }) end

-- Set filetypes
for ft, pattern in pairs(Nihil.settings.autocmd.ft_pattern) do
    vim.cmd('autocmd BufNewFile,BufRead ' .. pattern .. ' setfiletype ' .. ft)
end

-- Set commentstring
for ft, cmnt_str in pairs(Nihil.settings.autocmd.ft_cmnt_str) do
    vim.cmd('autocmd FileType ' .. ft .. ' setlocal commentstring=' .. cmnt_str)
end

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

-- spell
vim.api.nvim_create_autocmd('FileType', {
    group = augroup 'content_spell',
    callback = function() vim.opt_local.spell = true end,
    pattern = {
        'markdown',
    },
})

-- wrap
vim.api.nvim_create_autocmd('FileType', {
    group = augroup 'content_wrap',
    callback = function() vim.opt_local.wrap = true end,
    pattern = {
        'gitcommit',
        'markdown',
        'noice',
        'typescriptreact',
        'javascriptreact',
    },
})

-- content concealment
vim.api.nvim_create_autocmd('FileType', {
    group = augroup 'content_concealment',
    callback = function() vim.opt_local.conceallevel = 2 end,
    pattern = {
        'markdown',
        'notify',
    },
})

-- Easy closing
vim.api.nvim_create_autocmd('FileType', {
    group = augroup 'easy_closing',
    pattern = Nihil.settings.minimal_plugins_filetypes,
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
        if vim.tbl_contains(Nihil.settings.minimal_plugins_filetypes, vim.bo.filetype) then return end

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
    group = augroup 'auto_create_intermediate_absent_dirs',
    callback = function(event)
        if event.match:match '^%w%w+:[\\/][\\/]' then return end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
    end,
})

-- NOTE: FIX bun hot/watch reload BUG in nvim
-- https://github.com/oven-sh/bun/issues/8520#issuecomment-2002325950
vim.api.nvim_create_autocmd('FileType', {
    group = augroup 'bugfix_bun_hot_reload',
    pattern = { 'javascript', 'typescript' },
    command = 'setlocal backupcopy=yes',
})
