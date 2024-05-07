--- Editor plugins but leaning on more editing aspect
---@diagnostic disable: no-unknown
return {
    -- delimiter pairs
    { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },
    {
        'kylechui/nvim-surround',
        version = '*',
        keys = {
            { 'S', desc = 'Surround Visual' },
            { 'ds', desc = 'Surround Delete' },
            { 'cs', desc = 'Surround Change' },
        },
        opts = {
            keymaps = {
                visual = 'S',
                delete = 'ds',
                change = 'cs',
            },
        },
        config = function(_, opts)
            -- disable actions
            for _, action in pairs { 'visual_line', 'change_line', 'insert', 'insert_line', 'normal', 'normal_cur', 'normal_line', 'normal_cur_line' } do
                opts.keymaps[action] = false
            end

            require('nvim-surround').setup(opts)
        end,
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
