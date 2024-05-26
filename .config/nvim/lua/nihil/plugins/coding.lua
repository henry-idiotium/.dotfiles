--- Editor plugins but leaning on more editing aspect
---@diagnostic disable: no-unknown
return {
    -- Delimiter pairs
    { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },
    { -- Delimiter pairs surroundability
        'kylechui/nvim-surround',
        version = '*',
        keys = {
            { 'S', desc = 'Surround Visual', mode = 'v' },
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
            for _, action in pairs {
                'visual_line',
                'change_line',
                'insert',
                'insert_line',
                'normal',
                'normal_cur',
                'normal_line',
                'normal_cur_line',
            } do
                opts.keymaps[action] = false
            end

            require('nvim-surround').setup(opts)
        end,
    },

    { -- Better FT
        'backdround/improved-ft.nvim',
        event = 'VeryLazy',
        opts = {
            use_default_mappings = false,
            ignore_char_case = false,
            use_relative_repetition = true,
            use_relative_repetition_offsets = true,
        },
        config = function(_, opts)
            local ft = require 'improved-ft'
            ft.setup(opts)

            local function map(key, action, desc) vim.keymap.set({ 'n', 'x', 'o' }, key, action, { desc = desc, expr = true }) end
            map('f', ft.hop_forward_to_char, 'Hop forward to a given char')
            map('F', ft.hop_backward_to_char, 'Hop backward to a given char')
            map('t', ft.hop_forward_to_pre_char, 'Hop forward before a given char')
            map('T', ft.hop_backward_to_pre_char, 'Hop backward before a given char')
            map('<a-;>', ft.repeat_forward, 'Repeat hop forward to a last given char')
            map('<a-,>', ft.repeat_backward, 'Repeat hop backward to a last given char')
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

            local cmp_select = { behavior = cmp.SelectBehavior.Select }
            opts.mapping = cmp.mapping.preset.insert {
                ['<c-space>'] = cmp.mapping.complete(),
                ['<c-j>'] = cmp.mapping.select_next_item(cmp_select),
                ['<c-k>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<tab>'] = cmp.mapping.confirm { select = true },
                ['<c-y>'] = cmp.mapping.confirm { select = true },
                ['<cr>'] = cmp.mapping.confirm { select = true },
                ['<c-e>'] = function(fallback)
                    if not cmp.visible() then return end
                    cmp.abort()
                    fallback()
                end,
            }

            opts.sources = cmp.config.sources {
                { name = 'nvim_lsp' },
                { name = 'buffer' },
                { name = 'luasnip' },
                { name = 'path' },
            }

            local icons = Nihil.settings.icons.kinds
            ---@type cmp.FormattingConfig
            opts.formatting = {
                expandable_indicator = false,
                fields = { 'kind', 'abbr', 'menu' },
                format = function(_, item)
                    item.menu = item.menu or item.kind or ''
                    if icons[item.kind] then item.kind = icons[item.kind] end
                    return item
                end,
            }

            local compare = cmp.config.compare
            local cmp_types = require 'cmp.types'
            opts.sorting = {
                comparators = {
                    compare.exact,
                    compare.offset,
                    compare.score,

                    function(entry1, entry2)
                        local kind1 = entry1:get_kind()
                        local kind2 = entry2:get_kind()
                        if kind1 == kind2 then return end

                        if kind1 == cmp_types.lsp.CompletionItemKind.Snippet then return false end
                        if kind2 == cmp_types.lsp.CompletionItemKind.Snippet then return true end

                        local diff = kind1 - kind2
                        return diff == 0 and nil or diff < 0
                    end,

                    compare.locality,
                    compare.recently_used,
                    compare.locality,
                    compare.recently_used,
                    compare.kind,
                    compare.sort_text,
                    compare.order,
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
                goto_location = '<cr>',
                goto_and_close = '<s-cr>',
                toggle_preview = 'K',
                fold = { 'h', 'zc' },
                unfold = { 'l', 'zo' },
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
