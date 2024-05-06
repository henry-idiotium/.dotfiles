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

    {
        'johmsalas/text-case.nvim',
        keys = {
            { '<leader>cc', desc = 'Change Text Case', mode = { 'n', 'v' } },
            { '<leader>ccs', "<cmd>lua require('textcase').current_word('to_snake_case')<cr>", desc = 'to_snake_case' },
            { '<leader>ccd', "<cmd>lua require('textcase').current_word('to_dash_case')<cr>", desc = 'to-dash-case' },
            { '<leader>ccn', "<cmd>lua require('textcase').current_word('to_constant_case')<cr>", desc = 'TO_CONSTANT_CASE' },
            { '<leader>ccd', "<cmd>lua require('textcase').current_word('to_dot_case')<cr>", desc = 'to.dot.case' },
            { '<leader>cca', "<cmd>lua require('textcase').current_word('to_phrase_case')<cr>", desc = 'To phrase case' },
            { '<leader>ccc', "<cmd>lua require('textcase').current_word('to_camel_case')<cr>", desc = 'toCamelCase' },
            { '<leader>ccp', "<cmd>lua require('textcase').current_word('to_pascal_case')<cr>", desc = 'ToPascalCase' },
            { '<leader>cct', "<cmd>lua require('textcase').current_word('to_title_case')<cr>", desc = 'To Title Case' },
            { '<leader>ccf', "<cmd>lua require('textcase').current_word('to_path_case')<cr>", desc = 'to/path/case' },

            { '<leader>ccS', "<cmd>lua require('textcase').operator('to_snake_case')<cr>", desc = 'to_snake_case (operator)' },
            { '<leader>ccD', "<cmd>lua require('textcase').operator('to_dash_case')<cr>", desc = 'to-dash-case (operator)' },
            { '<leader>ccN', "<cmd>lua require('textcase').operator('to_constant_case')<cr>", desc = 'TO_CONSTANT_CASE (operator)' },
            { '<leader>ccD', "<cmd>lua require('textcase').operator('to_dot_case')<cr>", desc = 'to.dot.case (operator)' },
            { '<leader>ccA', "<cmd>lua require('textcase').operator('to_phrase_case')<cr>", desc = 'To phrase case (operator)' },
            { '<leader>ccC', "<cmd>lua require('textcase').operator('to_camel_case')<cr>", desc = 'toCamelCase (operator)' },
            { '<leader>ccP', "<cmd>lua require('textcase').operator('to_pascal_case')<cr>", desc = 'ToPascalCase (operator)' },
            { '<leader>ccT', "<cmd>lua require('textcase').operator('to_title_case')<cr>", desc = 'To Title Case (operator)' },
            { '<leader>ccF', "<cmd>lua require('textcase').operator('to_path_case')<cr>", desc = 'to/path/case (operator)' },

            { '<leader>ccs', "<cmd>lua require('textcase').visual('to_snake_case')<cr>", desc = 'to_snake_case', mode = 'v' },
            { '<leader>ccd', "<cmd>lua require('textcase').visual('to_dash_case')<cr>", desc = 'to-dash-case', mode = 'v' },
            { '<leader>ccn', "<cmd>lua require('textcase').visual('to_constant_case')<cr>", desc = 'TO_CONSTANT_CASE', mode = 'v' },
            { '<leader>ccd', "<cmd>lua require('textcase').visual('to_dot_case')<cr>", desc = 'to.dot.case', mode = 'v' },
            { '<leader>cca', "<cmd>lua require('textcase').visual('to_phrase_case')<cr>", desc = 'To phrase case', mode = 'v' },
            { '<leader>ccc', "<cmd>lua require('textcase').visual('to_camel_case')<cr>", desc = 'toCamelCase', mode = 'v' },
            { '<leader>ccp', "<cmd>lua require('textcase').visual('to_pascal_case')<cr>", desc = 'ToPascalCase', mode = 'v' },
            { '<leader>cct', "<cmd>lua require('textcase').visual('to_title_case')<cr>", desc = 'To Title Case', mode = 'v' },
            { '<leader>ccf', "<cmd>lua require('textcase').visual('to_path_case')<cr>", desc = 'to/path/case', mode = 'v' },
        },
        opts = {
            -- prefix = 'cr',
            default_keymappings_enabled = false,
            substitude_command_name = 'TextCaseSub',
        },
    },
}
