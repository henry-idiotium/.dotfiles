return {
    { 'echasnovski/mini.bracketed', enabled = false },
    { 'echasnovski/mini.surround', enabled = false },

    { 'kylechui/nvim-surround', event = 'VeryLazy', config = true },

    {
        'abecodes/tabout.nvim',
        keys = {
            { '<tab>', '<Plug>(Tabout)', mode = 'i', remap = true, desc = 'Tabout forward' },
            { '<s-tab>', '<Plug>(TaboutBack)', mode = 'i', remap = true, desc = 'Tabout backward' },
        },
        opts = {
            tabkey = '<tab>',
            backwards_tabkey = '<s-tab>',
            act_as_tab = true,
            act_as_shift_tab = true,
            enable_backwards = true,
            completion = true, -- if the tabkey is used in a completion pum
            tabouts = {
                { open = "'", close = "'" },
                { open = '"', close = '"' },
                { open = '`', close = '`' },
                { open = '<', close = '>' },
                { open = '(', close = ')' },
                { open = '[', close = ']' },
                { open = '{', close = '}' },
            },
            ignore_beginning = true, -- if the cursor is at the beginning of a filled element it will rather tab out than shift the content
            exclude = {}, -- tabout will ignore these filetypes
        },
    },

    {
        'chrisgrieser/nvim-spider',
        lazy = true,
        keys = {
            { ',w', '<cmd>lua require "spider" .motion "w" <cr>', silent = true, mode = { 'n', 'o', 'x' }, desc = 'Spider w' },
            { ',e', '<cmd>lua require "spider" .motion "e" <cr>', silent = true, mode = { 'n', 'o', 'x' }, desc = 'Spider e' },
            { ',b', '<cmd>lua require "spider" .motion "b" <cr>', silent = true, mode = { 'n', 'o', 'x' }, desc = 'Spider b' },
            { ',ge', '<cmd>lua require "spider" .motion "ge" <cr>', silent = true, mode = { 'n', 'o', 'x' }, desc = 'Spider ge' },
        },
    },

    {
        'folke/flash.nvim',
        keys = {
            { 's', mode = { 'n', 'x', 'o' }, false },
            { '<s-s>', mode = { 'n', 'x', 'o' }, false },
            { '<s-r>', mode = { 'x', 'o' }, false },
            { 'r', mode = 'o', false },
            { '<c-s>', mode = 'c', false },
            {
                'f',
                function()
                    require('flash').jump {
                        search = { multi_window = true },
                    }
                end,
                mode = { 'n', 'o', 'x' },
                desc = 'Flash jump',
            },
        },
        opts = {
            modes = {
                search = { enabled = false },
                char = {
                    jump_labels = true,
                    keys = {},
                },
            },
        },
    },

    {
        'simrat39/symbols-outline.nvim',
        keys = { { '<leader>cs', '<cmd>SymbolsOutline<cr>', desc = 'Symbols Outline' } },
        cmd = 'SymbolsOutline',
        opts = {
            position = 'right',
        },
    },

    {
        'nvim-cmp',
        opts = function(_, opts)
            table.insert(opts.sources, { name = 'marksman' })

            local cmp = require 'cmp'
            local cmp_select = { behavior = cmp.SelectBehavior.Select }
            opts.mapping = cmp.mapping.preset.insert {
                ['<c-j>'] = cmp.mapping.select_next_item(cmp_select),
                ['<c-k>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<c-d>'] = cmp.mapping.scroll_docs(-5),
                ['<c-u>'] = cmp.mapping.scroll_docs(5),
                ['<c-y>'] = cmp.mapping.confirm { select = true },
                ['<c-space>'] = cmp.mapping.complete(),
                ['<c-e>'] = cmp.mapping.close(),
                ['<tab>'] = nil,
            }

            local window_border = cmp.config.window.bordered()
            opts.window = {
                completion = window_border,
                documentation = window_border,
            }
        end,
    },

    {
        'ThePrimeagen/refactoring.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
        },
        keys = {
            { '<leader>rr', function() require('refactoring').select_refactor() end, desc = 'Refactoring actions' },
        },
        config = function() require('refactoring').setup() end,
    },
}
