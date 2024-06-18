---@diagnostic disable: no-unknown
return {
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        cmd = 'LazyDev',
        opts = {
            library = {
                { path = 'luvit-meta/library', words = { 'vim%.uv' } },
                { path = 'LazyVim', words = { 'LazyVim' } },
                { path = 'lazy.nvim', words = { 'LazyVim' } },
            },
        },
    },
    { 'Bilal2453/luvit-meta', lazy = true },

    { -- Delimiter pairs
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = {
            disable_in_visualblock = true,
        },
    },

    { -- Delimiter pairs surroundability
        'kylechui/nvim-surround',
        version = false,
        keys = {
            { 'sa', desc = 'Add Surround', mode = { 'v', 'n' } },
            { 'sc', desc = 'Delete Surround' },
            { 'sd', desc = 'Change Surround' },
        },
        opts = {
            keymaps = {
                visual = 'sa',
                change = 'sc',
                delete = 'sd',
                insert = false,
                insert_line = false,
                normal = false,
                normal_cur = false,
                normal_line = false,
                normal_cur_line = false,
                visual_line = false,
                change_line = false,
            },
        },
    },

    { -- Better FT
        'backdround/improved-ft.nvim',
        opts = {
            use_default_mappings = false,
            ignore_char_case = false,
            use_relative_repetition = true,
            use_relative_repetition_offsets = true,
        },
        keys = {
            { 'f', desc = 'Hop forward to a given char', mode = { 'n', 'x', 'o' } },
            { 'F', desc = 'Hop backward to a given char', mode = { 'n', 'x', 'o' } },
            { 't', desc = 'Hop forward before a given char', mode = { 'n', 'x', 'o' } },
            { 'T', desc = 'Hop backward before a given char', mode = { 'n', 'x', 'o' } },
            { '<a-p>', desc = 'Repeat hop forward to a last given char', mode = { 'n', 'x', 'o' } },
            { '<a-n>', desc = 'Repeat hop backward to a last given char', mode = { 'n', 'x', 'o' } },
        },
        config = function(_, opts)
            local ft = require 'improved-ft'
            ft.setup(opts)

            -- Keybinds have to be set after plugin setup!! WHAT?
            local function map(lhs, rhs) vim.keymap.set({ 'n', 'x', 'o' }, lhs, rhs, { expr = true }) end
            map('f', ft.hop_forward_to_char)
            map('F', ft.hop_backward_to_char)
            map('t', ft.hop_forward_to_pre_char)
            map('T', ft.hop_backward_to_pre_char)
            map('<a-p>', ft.repeat_forward)
            map('<a-n>', ft.repeat_backward)
        end,
    },

    { -- Meta comment gen
        'danymat/neogen',
        event = 'VeryLazy',
        opts = { snippet_engine = 'luasnip' },
        keys = {
            {
                '<leader>cg',
                function() require('neogen').generate {} end,
                desc = 'Neogen Comment',
                noremap = true,
                silent = true,
            },
        },
    },

    { -- ThePrimeagen's refactoring
        'ThePrimeagen/refactoring.nvim',
        dependencies = 'nvim-lua/plenary.nvim',
        opts = { show_success_message = true },
        keys = {
            {
                '<leader>cA',
                [[:lua require 'refactoring'.select_refactor() <cr>]],
                mode = { 'n', 'v' },
                desc = 'Refactoring Actions',
            },
        },
    },

    { -- Comment treesitter context
        'JoosepAlviste/nvim-ts-context-commentstring',
        opts = { enable_autocmd = false },
        lazy = true,
    },
    { -- Comments
        'numToStr/Comment.nvim',
        keys = {
            { 'gb', desc = 'Comment toggle blockwise' },
            { 'gbc', desc = 'Comment toggle current block' },
            { 'gc', desc = 'Comment toggle linewise' },
            { 'gcc', desc = 'Comment toggle current line' },
            { 'gb', mode = 'x', desc = 'Comment toggle blockwise (visual)' },
            { 'gc', mode = 'x', desc = 'Comment toggle linewise (visual)' },
        },
        opts = {
            padding = true, -- Add a space b/w comment and the line
            sticky = true, -- Whether the cursor should stay at its position

            mappings = { basic = true, extra = false },
            -- toggler = { line = 'gcc', block = 'gbc' }, -- LHS of toggle mappings in NORMAL mode
            -- opleader = { line = 'gc', block = 'gb' }, -- LHS of operator-pending mappings in NORMAL and VISUAL mode
            -- extra = { above = 'gcO', below = 'gco', eol = 'gcA' }, -- LHS of extra mappings

            pre_hook = function(ctx) return require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()(ctx) end,
        },
    },

    { -- Change case
        'johmsalas/text-case.nvim',
        keys = { 'cc' },
        opts = {
            default_keymappings_enabled = true,
            prefix = 'cc',
        },
    },
}
