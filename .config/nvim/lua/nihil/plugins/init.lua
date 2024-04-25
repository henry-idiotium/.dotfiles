---@diagnostic disable: no-unknown
return {
    { 'nvim-lua/plenary.nvim', name = 'plenary', lazy = true },
    { 'nvim-tree/nvim-web-devicons', event = 'VeryLazy', lazy = true }, -- icons
    { 'MunifTanjim/nui.nvim', event = 'VeryLazy', lazy = true }, -- ui components

    -- brainrot
    { 'eandrju/cellular-automaton.nvim', lazy = true },

    -- measure startuptime
    {
        'dstein64/vim-startuptime',
        cmd = 'StartupTime',
        config = function() vim.g.startuptime_tries = 10 end,
    },

    -- Session management. This saves your session in the background,
    -- keeping track of open buffers, window arrangement, and more.
    -- You can restore sessions when returning through the dashboard.
    {
        'folke/persistence.nvim',
        event = 'BufReadPre',
        opts = { options = vim.opt.sessionoptions:get() },
        keys = {
            { '<leader>qs', function() require('persistence').load() end, desc = 'Restore Session' },
            { '<leader>ql', function() require('persistence').load { last = true } end, desc = 'Restore Last Session' },
            { '<leader>qd', function() require('persistence').stop() end, desc = "Don't Save Current Session" },
        },
    },

    -- keymaps helper
    {
        'folke/which-key.nvim',
        priority = 1000,
        event = 'VeryLazy',

        opts = {
            window = { border = 'single' },

            defaults = {
                mode = { 'n', 'v' },
                ['g'] = { name = '+goto' },
                ['z'] = { name = '+fold' },
                [']'] = { name = '+next' },
                ['['] = { name = '+prev' },
                ['<leader>o'] = { name = '+open' },
                ['<leader>x'] = { name = '+diagnostics/quickfix' },
                ['<leader>b'] = { name = '+buffer' },
                ['<leader>c'] = { name = '+code' },
                ['<leader>f'] = { name = '+file/find' },
                ['<leader>q'] = { name = '+quit/session' },
                ['<leader>u'] = { name = '+ui' },
                ['<leader>g'] = { name = '+git' },
                ['<leader>gh'] = { name = '+hunks' },
                ['<leader>s'] = { name = '+search' },
                ['<leader>sw'] = { name = '+workspace' },
                ['<leader><tab>'] = { name = '+tab' },
                ['<leader>t'] = { name = '+toggle' },
                ['<leader>tl'] = { name = '+lsp' },
            },
        },

        config = function(_, opts)
            local wk = require 'which-key'
            wk.setup(opts)
            wk.register(opts.defaults)
        end,
    },
}
