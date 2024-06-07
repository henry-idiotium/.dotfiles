---@diagnostic disable: no-unknown
return {
    -- basic ui plugins
    { 'nvim-lua/plenary.nvim', lazy = true }, -- popup
    { 'MunifTanjim/nui.nvim', event = 'VeryLazy', lazy = true }, -- ui components
    { 'nvim-tree/nvim-web-devicons', event = 'VeryLazy', lazy = true },

    -- brainrot
    { 'eandrju/cellular-automaton.nvim', cmd = 'CellularAutomaton', lazy = true },

    { -- measure startuptime
        'dstein64/vim-startuptime',
        cmd = 'StartupTime',
        config = function() vim.g.startuptime_tries = 10 end,
    },

    { -- keymaps helper
        'folke/which-key.nvim',
        event = 'VeryLazy',
        opts = {
            window = { border = 'single' },
            defaults = {
                mode = { 'n', 'v' },
                ['g'] = { name = '+goto' },
                ['z'] = { name = '+fold' },
                [']'] = { name = '+next' },
                ['['] = { name = '+prev' },
                ['<leader>m'] = { name = '+menu' },
                ['<leader>x'] = { name = '+diagnostics/quickfix' },
                ['<leader>b'] = { name = '+buffer' },
                ['<leader>c'] = { name = '+code' },
                ['<leader>g'] = { name = '+git' },
                ['<leader>gh'] = { name = '+hunks' },
                ['<leader>s'] = { name = '+search' },
                ['<leader>u'] = { name = '+ui' },
                ['<leader>n'] = { name = '+notify' },
                ['<leader>!'] = { name = '+shell' },
                ['<leader><tab>'] = { name = '+tab' },
                ['<leader><leader>'] = { name = '+toggle' },
            },
        },
        config = function(_, opts)
            local wk = require 'which-key'
            wk.setup(opts)
            wk.register(opts.defaults)
        end,
    },
}
