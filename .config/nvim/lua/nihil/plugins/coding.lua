---@diagnostic disable: no-unknown
return {
    -- better surround
    { 'kylechui/nvim-surround', event = 'VeryLazy', config = true },

    {
        'ThePrimeagen/refactoring.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
            { 'folke/which-key.nvim', opts = function(_, opts) opts.defaults['<leader>r'] = { name = '+refactoring' } end },
        },
        keys = {
            { '<leader>rr', function() require('refactoring').select_refactor { show_success_message = true } end, desc = 'Refactoring actions' },
        },
        config = function() require('refactoring').setup { show_success_message = true } end,
    },

    -- auto pairs closing blocks
    { 'echasnovski/mini.pairs', event = 'VeryLazy', config = true },

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
