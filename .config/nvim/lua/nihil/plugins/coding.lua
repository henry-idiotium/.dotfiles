--- Editor plugins but leaning on more editing aspect
---@diagnostic disable: no-unknown
return {
    -- Delimiter pairs
    { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },
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
            { '<a-;>', desc = 'Repeat hop forward to a last given char', mode = { 'n', 'x', 'o' } },
            { '<a-,>', desc = 'Repeat hop backward to a last given char', mode = { 'n', 'x', 'o' } },
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
            map('<a-;>', ft.repeat_forward)
            map('<a-,>', ft.repeat_backward)
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

    { -- Completion
        'hrsh7th/nvim-cmp',
        version = false,
        event = 'InsertEnter',
        dependencies = {
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'saadparwaiz1/cmp_luasnip',
            'L3MON4D3/LuaSnip',
            {
                'rafamadriz/friendly-snippets',
                config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
            },
        },
        opts = {
            snippet = {
                expand = function(args) require('luasnip').lsp_expand(args.body) end,
            },
            window = {
                completion = { border = 'rounded' },
                documentation = { border = 'rounded' },
            },
            completion = { completeopt = 'menu,menuone,noinsert' },
            experimental = {
                ghost_text = { hl_group = 'CmpGhostText' },
            },
        },

        config = function(_, opts)
            local cmp = require 'cmp'

            ---- UI, Icon
            local icons = Nihil.settings.icons.kinds
            opts.formatting = { ---@type cmp.FormattingConfig
                expandable_indicator = false,
                fields = { 'kind', 'abbr', 'menu' },
                format = function(_, item)
                    item.menu = item.menu or item.kind or ''
                    if icons[item.kind] then item.kind = icons[item.kind] end
                    return item
                end,
            }

            ---- Keybinds
            local cmp_select = { behavior = cmp.SelectBehavior.Select }
            opts.mapping = cmp.mapping.preset.insert {
                ['<c-space>'] = cmp.mapping.complete(),
                ['<c-j>'] = cmp.mapping.select_next_item(cmp_select),
                ['<c-k>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<tab>'] = cmp.mapping.confirm { select = true },
                ['<c-y>'] = cmp.mapping.confirm { select = true },
                ['<cr>'] = cmp.mapping.confirm { select = true },
                ['<c-e>'] = cmp.mapping.abort(),
            }

            ---- Sources
            opts.sources = cmp.config.sources {
                { name = 'nvim_lsp', priority = 10000 },
                { name = 'buffer', priority = 8 },
                { name = 'luasnip', priority = 0 },
                { name = 'path', priority = 5 },
            }

            ---- Order/Sorting
            local compare = cmp.config.compare
            local cmp_lsp_kind = require('cmp.types').lsp.CompletionItemKind
            local kinds_priority = Nihil.settings.kinds.priority
            opts.sorting = { ---@type cmp.SortingConfig
                priority_weight = 1,
                comparators = {
                    function(entry1, entry2) -- kind priority
                        local prio1 = kinds_priority[cmp_lsp_kind[entry1:get_kind()]]
                        local prio2 = kinds_priority[cmp_lsp_kind[entry2:get_kind()]]
                        if not (prio1 or prio2) and prio1 == prio2 then return end
                        local diff = prio1 - prio2
                        return diff > 0
                    end,

                    compare.locality,
                    compare.recently_used,
                    compare.order,
                    compare.kind,
                    compare.sort_text,
                },
            }

            cmp.setup(opts)
        end,
    },

    { -- symbols outline
        'hedyhli/outline.nvim',
        keys = { { '<leader>cs', '<cmd>Outline<cr>', desc = 'Symbols Outline' } },
        cmd = { 'Outline', 'OutlineOpen' },
        opts = {
            outline_window = {
                position = 'right',
            },
            keymaps = {
                -- show_help = '?',
                -- peek_location = 'o',
                -- restore_location = '<c-g>',
                -- hover_symbol = '<c-space>',
                -- rename_symbol = 'r',
                -- code_actions = 'a',

                close = { '<esc>', 'q', '<c-q>' },
                goto_location = { '<cr>', '<c-l>', 'l' },
                goto_and_close = '<s-cr>',
                toggle_preview = 'K',
                fold = { 'h', 'zc' },
                unfold = 'zo',
                fold_toggle = 'zm',
                fold_toggle_all = 'zM',
                fold_all = 'zC',
                unfold_all = 'zO',
                fold_reset = 'zr',
                down_and_jump = '<c-j>',
                up_and_jump = '<c-k>',
            },
        },
    },

    { -- display typescript type
        'marilari88/twoslash-queries.nvim',
        ft = { 'typescript', 'javascript' },
        cmd = {
            'TwoslashQueriesEnable',
            'TwoslashQueriesDisable',
            'TwoslashQueriesInspect',
            'TwoslashQueriesRemove',
        },
        opts = {
            multi_line = true, -- to print types in multi line mode
            is_enabled = false, -- to keep disabled at startup and enable it on request with the TwoslashQueriesEnable
            highlight = 'Type', -- to set up a highlight group for the virtual text
        },
    },
}
