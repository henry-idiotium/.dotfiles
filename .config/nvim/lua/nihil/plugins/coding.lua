---@diagnostic disable: no-unknown
return {
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
        opts = { position = 'right' },
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

    -- auto pairs closing blocks
    { 'echasnovski/mini.pairs', event = 'VeryLazy', opts = {} },

    -- comments
    {
        'JoosepAlviste/nvim-ts-context-commentstring',
        lazy = true,
        opts = { enable_autocmd = false },
    },
    {
        'echasnovski/mini.comment',
        event = 'VeryLazy',
        opts = {
            options = {
                custom_commentstring = function() return require('ts_context_commentstring.internal').calculate_commentstring() or vim.bo.commentstring end,
            },
        },
    },
}
