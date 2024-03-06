local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
} end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
    spec = {
        -- add LazyVim and import its plugins
        {
            'LazyVim/LazyVim',
            import = 'lazyvim.plugins',
            opts = {
                colorscheme = 'catppuccin',
                news = {
                    lazyvim = true,
                    neovim = true,
                },
            },
        },
        { import = 'lazyvim.plugins.extras.linting.eslint' },
        { import = 'lazyvim.plugins.extras.formatting.prettier' },
        { import = 'lazyvim.plugins.extras.lang.typescript' },
        { import = 'lazyvim.plugins.extras.lang.json' },
        -- { import = 'lazyvim.plugins.extras.lang.markdown' },
        { import = 'lazyvim.plugins.extras.lang.rust' },
        { import = 'lazyvim.plugins.extras.lang.tailwind' },
        { import = 'lazyvim.plugins.extras.util.mini-hipatterns' },
        -- { import = "lazyvim.plugins.extras.dap.core" },
        -- { import = "lazyvim.plugins.extras.vscode" },
        -- { import = "lazyvim.plugins.extras.test.core" },
        -- { import = "lazyvim.plugins.extras.coding.yanky" },
        -- { import = "lazyvim.plugins.extras.editor.mini-files" },
        -- { import = "lazyvim.plugins.extras.util.project" },
        { import = 'plugins' },
    },
    defaults = {
        lazy = false,
        version = false, -- always use the latest git commit
        keymaps = false,
    },
    checker = { enabled = true }, -- automatically check for plugin updates
    performance = {
        cache = {
            enabled = true,
            -- disable_events = {},
        },
        rtp = {
            -- disable some rtp plugins
            disabled_plugins = {
                'gzip',
                -- "matchit",
                -- "matchparen",
                -- "netrwPlugin",
                'tarPlugin',
                'tohtml',
                'tutor',
                'zipPlugin',
            },
        },
    },
}
