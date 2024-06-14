---@diagnostic disable: missing-fields, no-unknown
-- Global
_G.Nihil = {
    debug = {},
    log = {}, ---@type table<NotifyLevel, fun(msg: string, opts?: table): nil>
}

for _, l in ipairs { 'trace', 'debug', 'info', 'warn', 'error', 'off' } do
    Nihil.log[l] = function(msg, opts) vim.notify(msg, vim.log.levels[l:upper()], opts) end
end

-- Imports
require 'nihil.util'
require 'nihil.config'

-- Initialize lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        '--branch=stable',
        'https://github.com/folke/lazy.nvim.git',
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
    ---@type LazySpec
    spec = {
        import = 'nihil.lazy',
        enabled = not Nihil.config.minimal_mode_enabled,
    },
    change_detection = { notify = false },
    performance = {
        cache = { enabled = true },
        rtp = {
            disabled_plugins = {
                'gzip',
                'matchit',
                'matchparen',
                'netrwPlugin',
                'tarPlugin',
                'tohtml',
                'tutor',
                'zipPlugin',
            },
        },
    },
    ui = {
        border = 'rounded',
        backdrop = 0,
    },
}

if not Nihil.config.minimal_mode_enabled then vim.cmd.colorscheme(Nihil.config.colorscheme or 'wildcharm') end
