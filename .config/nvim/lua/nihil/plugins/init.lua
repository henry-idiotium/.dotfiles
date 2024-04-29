---@diagnostic disable: no-unknown
return {
    { 'nvim-lua/plenary.nvim', lazy = true },
    { 'nvim-tree/nvim-web-devicons', event = 'VeryLazy', lazy = true }, -- icons
    { 'MunifTanjim/nui.nvim', event = 'VeryLazy', lazy = true }, -- ui components

    -- brainrot
    { 'eandrju/cellular-automaton.nvim', cmd = 'CellularAutomaton', lazy = true },

    -- measure startuptime
    {
        'dstein64/vim-startuptime',
        cmd = 'StartupTime',
        config = function() vim.g.startuptime_tries = 10 end,
    },

    -- keymaps helper
    {
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
                ['<leader>o'] = { name = '+open' },
                ['<leader>x'] = { name = '+diagnostics/quickfix' },
                ['<leader>b'] = { name = '+buffer' },
                ['<leader>c'] = { name = '+code' },
                ['<leader>f'] = { name = '+file/find' },
                ['<leader>q'] = { name = '+quit/session' },
                ['<leader>u'] = { name = '+ui' },
                ['<leader>g'] = { name = '+git' },
                ['<leader>gh'] = { name = '+hunks', _ = 'which_key_ignore' },
                ['<leader>s'] = { name = '+search' },
                ['<leader>sn'] = { name = '+noice' },
                ['<leader>t'] = { name = '+toggle' },
                ['<leader>tl'] = { name = '+lsp', _ = 'which_key_ignore' },
            },
        },

        config = function(_, opts)
            local wk = require 'which-key'
            wk.setup(opts)
            wk.register(opts.defaults)
        end,
    },
}
