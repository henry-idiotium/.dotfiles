---@diagnostic disable: no-unknown
return {
    { 'kylechui/nvim-surround', event = 'VeryLazy', config = true }, -- better surround
    { 'echasnovski/mini.pairs', event = 'VeryLazy', config = true }, -- auto pairs closing blocks

    {
        'danymat/neogen',
        event = 'VeryLazy',
        opts = { snippet_engine = 'luasnip' },
        keys = {
            {
                '<leader>cg',
                function() require('neogen').generate {} end,
                desc = 'Neogen Comment',
            },
        },
    },

    -- ThePrimeagen's refactoring
    {
        'ThePrimeagen/refactoring.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
            { 'folke/which-key.nvim', opts = function(_, opts) opts.defaults['<leader>r'] = { name = '+refactoring' } end },
        },
        keys = {
            {
                '<leader>rr',
                function()
                    require('refactoring').select_refactor {
                        show_success_message = true,
                    }
                end,
                mode = { 'n', 'v' },
                desc = 'Refactoring actions',
                noremap = true,
                silent = true,
                expr = false,
            },
        },
        opts = { show_success_message = true },
    },

    -- comments
    { 'JoosepAlviste/nvim-ts-context-commentstring', lazy = true, opts = { enable_autocmd = false } },
    {
        'numToStr/Comment.nvim',
        lazy = false,
        opts = {
            padding = false,
            sticky = true,
            -- `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
            mappings = { basic = true, extra = false },
            pre_hook = function() return require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook() end,
        },
    },
}