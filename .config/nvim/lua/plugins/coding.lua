---@diagnostic disable: no-unknown
return {
    { 'echasnovski/mini.bracketed', enabled = false },
    { 'echasnovski/mini.surround', enabled = false },
    { 'folke/flash.nvim', enabled = false },

    { 'kylechui/nvim-surround', event = 'VeryLazy', config = true },

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
            local cmp_select = { behavior = cmp.SelectBehavior.Insert }
            opts.mapping = cmp.mapping.preset.insert {
                ['<c-j>'] = cmp.mapping.select_next_item(cmp_select),
                ['<c-k>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<c-d>'] = cmp.mapping.scroll_docs(-4),
                ['<c-u>'] = cmp.mapping.scroll_docs(4),
                ['<tab>'] = cmp.mapping.confirm { select = true },
                ['<c-space>'] = cmp.mapping.complete(),
                ['<c-e>'] = function() return cmp.visible() and cmp.abort() end,
            }

            local window_border = { border = 'rounded' }
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
            { '<leader>rr', function() require('refactoring').select_refactor { show_success_message = true } end, desc = 'Refactoring actions' },
        },
        config = function() require('refactoring').setup { show_success_message = true } end,
    },
}
