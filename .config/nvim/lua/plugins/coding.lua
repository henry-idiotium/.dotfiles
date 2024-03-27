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

    { -- Better increase/descrease
        'monaqa/dial.nvim',
        keys = {
            { '+', function() return require('dial.map').inc_normal() end, expr = true, desc = 'Increment' },
            { '-', function() return require('dial.map').dec_normal() end, expr = true, desc = 'Decrement' },
        },
        config = function()
            local augend = require 'dial.augend'
            require('dial.config').augends:register_group {
                default = {
                    augend.integer.alias.decimal,
                    augend.integer.alias.hex,
                    augend.date.alias['%Y/%m/%d'],
                    augend.constant.alias.bool,
                    augend.semver.alias.semver,
                    augend.constant.new { elements = { 'let', 'const' } },
                },
            }
        end,
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
        dependencies = { 'hrsh7th/cmp-emoji' },
        opts = function(_, opts)
            table.insert(opts.sources, { name = 'emoji' })

            local cmp = require 'cmp'
            opts.mapping = cmp.mapping.preset.insert {
                ['<c-j>'] = cmp.mapping(function(fallback) return cmp.visible() and cmp.select_next_item() or fallback() end, { 'i', 's' }),
                ['<c-k>'] = cmp.mapping(function(fallback) return cmp.visible() and cmp.select_prev_item() or fallback() end, { 'i', 's' }),
                ['<c-d>'] = cmp.mapping.scroll_docs(-4),
                ['<c-u>'] = cmp.mapping.scroll_docs(4),
                ['<c-space>'] = cmp.mapping.complete(),
                ['<c-e>'] = cmp.mapping.close(),
                ['<cr>'] = cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                },
                ['<tab>'] = cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                },
            }

            opts.window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            }
        end,
    },
}
