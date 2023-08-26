local map_keys = nihil.utils.keymap.map_schema

local api = vim.api

-- helper filetypes
local helper_filetypes = { 'help', 'qf' }
api.nvim_create_autocmd({ 'FileType', 'BufReadPre', 'FileReadPre' }, {
    pattern = helper_filetypes,
    callback = function()
        pcall(vim.cmd, [[
            setlocal number
            setlocal nu
        ]])
    end
})

api.nvim_create_autocmd({ 'FileType', 'BufReadPre', 'FileReadPre' }, {
    pattern = {
        'typescriptreact',
        'javascriptreact',
        'typescript',
        'javascript',
        'markdown',
        'json',
    },
    callback = function()
        pcall(vim.cmd, [[
            set shiftwidth=2
			set tabstop=2
        ]])
    end
})
