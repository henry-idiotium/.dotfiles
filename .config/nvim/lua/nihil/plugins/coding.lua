--- Editor plugins but leaning on more editing aspect
---@diagnostic disable: no-unknown
return {
    -- delimiter pairs
    { 'echasnovski/mini.pairs', event = 'VeryLazy', opts = {} }, -- auto delimiter closing pairs
    {
        'echasnovski/mini.surround',
        version = false,
        opts = {
            highlight_duration = 0,
            mappings = {
                add = '<s-s>',
                delete = 'ds',
                replace = 'sc',
                find = '',
                find_left = '',
                highlight = '',
                suffix_last = '',
                suffix_next = '',
                update_n_lines = '',
            },
            n_lines = 40, -- Number of lines within which surrounding is searched
            respect_selection_type = false,
            silent = false,
        },
    },

    { -- meta comment gen
        'danymat/neogen',
        enabled = false,
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

    { -- ThePrimeagen's refactoring
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
            },
        },
        opts = { show_success_message = true },
    },

    -- comments
    {
        'JoosepAlviste/nvim-ts-context-commentstring',
        opts = { enable_autocmd = false },
        lazy = true,
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
