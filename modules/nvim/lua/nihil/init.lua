---@diagnostic disable: undefined-field

-------------------------------------
-- Init global configurations

--- Global variable for nihil user
_G.nihil = {
    safe_quit_mode = vim.env.NVIM_SAFE_QUIT_MODE,
    --- Env about current os
    os = {
        darwin = vim.fn.has 'macunix' == 1,
        linux  = vim.fn.has 'unix' == 1 and vim.fn.has 'wsl' == 0,
        wsl    = vim.fn.has 'wsl' == 1,
        win    = vim.fn.has 'win32' == 1,
    },

    utils = {},  --- Utility function modules
}


-------------------------------------
-- Load configs and plugins using `Lazy.nvim`

-- Init Lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git', 'clone', 'https://github.com/folke/lazy.nvim.git',
        '--filter=blob:none',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = ' ' --note: required for lazy.nvim to work poperly


--NOTE: EDIT is done here.
--      prefix is added after.
local modules = {
    'extends',
    'utils',

    -- Plugins run first
    'plugins.before',
    'plugins.before.lsp',
    'plugins.before.themes',

    -- Plugins run after
    'plugins.after',

    --remark: some plugins is used in config, so it called last.
    'config',
}

local options = {
    install = { colorscheme = { 'catppuccin' }, },
    checker = { enabled = true, notify = true, },
    change_detection = { notify = true, },
}

require 'lazy'.setup((function()
    local res = {}
    local prefix = 'nihil.' -- base

    for _, module in ipairs(modules) do
        table.insert(res, { import = prefix .. module })
    end

    return res
end)(), options)

-- load colorscheme after load all plugins
vim.cmd.colorscheme 'catppuccin'
