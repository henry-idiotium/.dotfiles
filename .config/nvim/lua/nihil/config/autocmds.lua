---@diagnostic disable: no-unknown
vim.cmd [[ autocmd BufNewFile,BufRead *.astro setfiletype astro ]]
vim.cmd [[ autocmd BufNewFile,BufRead Podfile setfiletype ruby ]]

local function augroup(name) return vim.api.nvim_create_augroup('nihil_' .. name, { clear = true }) end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
    group = augroup 'checktime',
    callback = function()
        if vim.o.buftype ~= 'nofile' then vim.cmd 'checktime' end
    end,
})

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

-- Wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd('FileType', {
    group = augroup 'wrap_spell',
    pattern = { 'gitcommit', 'markdown' },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- Turn ON conceallevel files
vim.api.nvim_create_autocmd({ 'FileType' }, {
    group = augroup 'content_concealment',
    pattern = { 'markdown' },
    callback = function() vim.opt_local.conceallevel = 2 end,
})

local exclude_filetypes = {
    'hgcommit',
    'gitcommit',
    'gitrebase',
    'svn',
    'qf',
    'help',
    'vim',
    'notify',
    'query',
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
        vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
    end,
})

-- go to prev cursor location when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
    group = augroup 'last_loc',
    callback = function(event)
        local buf = event.buf
        local has_mark, mark = pcall(vim.api.nvim_buf_get_mark, buf, '"')

        -- stylua: ignore
        if  vim.tbl_contains(exclude_filetypes, vim.bo.filetype)
            or vim.b[buf].last_loc
            or not has_mark
        then return end

        vim.b[buf].last_loc = true

        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
    end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    group = augroup 'auto_create_dirs_if_absent',
    callback = function(event)
        if event.match:match '^%w%w+:[\\/][\\/]' then return end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
    end,
})
