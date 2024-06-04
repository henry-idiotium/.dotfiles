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
                ['<leader>i'] = { name = '+provider/info' },
                ['<leader>x'] = { name = '+diagnostics/quickfix' },
                ['<leader>b'] = { name = '+buffer' },
                ['<leader><tab>'] = { name = '+tab' },
                ['<leader>c'] = { name = '+code' },
                ['<leader>q'] = { name = '+quit' },
                ['<leader>g'] = { name = '+git' },
                ['<leader>gh'] = { name = '+hunks' },
                ['<leader>s'] = { name = '+search' },
                ['<leader>t'] = { name = '+toggle' },
                ['<leader>u'] = { name = '+ui' },
                ['<leader>un'] = { name = '+notifications' },
                ['<leader>!'] = { name = '+shell' },
            },
        },
        config = function(_, opts)
            local wk = require 'which-key'
            wk.setup(opts)
            wk.register(opts.defaults)
        end,
    },
}
