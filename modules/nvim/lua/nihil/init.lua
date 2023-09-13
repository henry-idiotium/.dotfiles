local lazy = require 'nihil.lazy'

-------------------------------------
-- Load configs and plugins using `Lazy.nvim`
local base_modules = {
    'base',
    'plugins',
    'config',
}
local vscode_modules = {
    'base',
    'config',
    'plugins.spider',
    'plugins.lightspeed',
    'plugins.surround',
}

lazy.setup(lazy.parse_modules(not vim.g.vscode and base_modules or vscode_modules), {
    install = { colorscheme = { 'catppuccin' } },
    checker = { enabled = true, notify = false },
    change_detection = { notify = false },
    ui = {
        border = 'rounded',
    },
})
