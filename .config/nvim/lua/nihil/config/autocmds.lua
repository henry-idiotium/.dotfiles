---@diagnostic disable: no-unknown
local function augroup(name) return vim.api.nvim_create_augroup('nihil_' .. name, { clear = true }) end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
    group = augroup 'checktime',
    callback = function()
        if vim.o.buftype ~= 'nofile' then vim.cmd.checktime() end
    end,
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
    pattern = { '*.txt', '*.tex', '*.typ', 'gitcommit', 'markdown' },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- concealment
vim.api.nvim_create_autocmd('FileType', {
    group = augroup 'content_concealment',
    command = 'setlocal conceallevel=3',
    pattern = {
        'markdown',
        'notify',
    },
})

-- wrap
vim.api.nvim_create_autocmd('FileType', {
    group = augroup 'content_wrap',
    command = 'setlocal wrap',
    pattern = {
        'typescriptreact',
        'javascriptreact',
        'gitcommit',
    },
})

-- Easy closing
vim.api.nvim_create_autocmd('FileType', {
    group = augroup 'easy_closing',
    pattern = Nihil.config.excluded_filetypes,
    callback = function(e)
        local buf = e.buf
        vim.bo[e.buf].buflisted = false
        local function map(l) vim.keymap.set('n', l, '<cmd>close<cr>', { buffer = buf, silent = true }) end
        map '<c-q>'
        map 'q'
    end,
})

-- go to previous cursor location
vim.api.nvim_create_autocmd('BufReadPost', {
    group = augroup 'last_loc',
    callback = function(event)
        if vim.tbl_contains(Nihil.config.excluded_filetypes, vim.bo.filetype) then return end

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

-- Settings for the greatest script of all time
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('nihil_greatest_script_settings', { clear = true }),
    pattern = 'tmux-harpoon', -- in config.filetype
    callback = function(e)
        vim.opt.showmode = false
        vim.opt.ruler = false
        vim.opt.laststatus = 0
        vim.opt.showcmd = false

        local function map(m, l, r) vim.keymap.set(m, l, r, { buffer = e.buf, silent = true }) end
        map('n', '<c-q>', '<cmd>quit <cr>')
        map('n', '<c-s>', '<cmd>write | quit <cr>')
    end,
})
