-- NOTE: Code in init.lua run before dirs: plugin, after
pcall(require, 'impatient')


-------------------------------------
-- Init global configurations
----------------

--- Global variable for nihil user
_G.nihil = {
    safe_quit_mode = vim.env.NVIM_SAFE_QUIT_MODE,
    --- Env about current os
    os = {
        darwin = vim.fn.has "macunix" == 1,
        linux  = vim.fn.has "unix" == 1 and vim.fn.has "wsl" == 0,
        wsl    = vim.fn.has "wsl" == 1,
        win    = vim.fn.has "win32" == 1,
    },

    user = {},  --- User configurations
    utils = {}, --- Utility
}


-------------------------------------
-- Load user configurations
----------------

--- User configurations
_G.config = {
    theme = 'catppuccin', --- Specify theme for user, default is "catppuccin".
    plugins = {},         --- User plugins.
    log_error = true,     --- Specify whether to log error or not.
}

pcall(require, 'config')

nihil.user = config
