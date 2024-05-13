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

    { -- Meta comment gen
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

    { -- Comments
        'echasnovski/mini.comment',
        event = 'VeryLazy',
        opts = {
            options = {
                custom_commentstring = function()
                    return require('ts_context_commentstring.internal').calculate_commentstring() or vim.bo.commentstring
                end,
            },
        },
    },
    { -- Comment treesitter context
        'JoosepAlviste/nvim-ts-context-commentstring',
        opts = { enable_autocmd = false },
        lazy = true,
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
}
