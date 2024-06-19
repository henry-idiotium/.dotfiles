---@diagnostic disable: no-unknown
return {
    { -- Completion
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        version = false,
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-cmdline',
            'saadparwaiz1/cmp_luasnip',
            'L3MON4D3/LuaSnip',
            {
                'rafamadriz/friendly-snippets',
                config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
            },
            {
                'roobert/tailwindcss-colorizer-cmp.nvim',
                opts = { color_square_width = 2 },
            },
        },
        opts = {
            completion = {
                autocomplete = false,
                completeopt = 'menu,menuone,noinsert',
            },
            snippet = {
                expand = function(args) require('luasnip').lsp_expand(args.body) end,
            },
            window = {
                completion = { border = 'rounded' },
                documentation = { border = 'rounded' },
            },
            experimental = {
                ghost_text = false,
            },
        },

        config = function(_, opts)
            local cmp = require 'cmp'

            ---- Sources
            opts.sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            }, {
                { name = 'buffer' },
                { name = 'path' },
            })
            table.insert(opts.sources, { name = 'lazydev', group_index = 0 })

            ---- Keybinds
            local cmp_select = { behavior = cmp.SelectBehavior.Select }
            local cmp_close = {
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }
            opts.mapping = cmp.mapping.preset.insert {
                ['<c-space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
                ['<c-j>'] = cmp.mapping.select_next_item(cmp_select),
                ['<c-k>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<c-y>'] = cmp.mapping.confirm { select = true },
                ['<cr>'] = cmp.mapping.confirm { select = true },
                ['<c-q>'] = cmp_close,
                ['<c-e>'] = cmp_close,

                ['<c-g>'] = function() return cmp.visible_docs() and cmp.close_docs() or cmp.open_docs() end,
                ['<tab>'] = function(fallback)
                    local sm = require 'supermaven-nvim.completion_preview'
                    local ls = require 'luasnip'

                    if not cmp.visible() and sm.has_suggestion() then
                        sm.on_accept_suggestion()
                    elseif cmp.visible() then
                        if ls.expandable() then
                            ls.expand()
                        else
                            cmp.confirm { select = true }
                        end
                    else
                        fallback()
                    end
                end,
            }

            ---- UI, Icon
            local kinds = Nihil.config.icons.kinds
            opts.formatting = { ---@type cmp.FormattingConfig
                expandable_indicator = false,
                fields = { 'kind', 'abbr' },
                format = function(entry, item)
                    local tw = require('tailwindcss-colorizer-cmp').formatter(entry, item)
                    if tw.kind == 'XX' then return tw end

                    item.kind = kinds[item.kind].icon or '' -- icon
                    return item
                end,
            }

            ---- Order/Sorting
            local compare = cmp.config.compare
            local cmp_lsp_kind = require('cmp.types').lsp.CompletionItemKind
            opts.sorting = { ---@type cmp.SortingConfig
                priority_weight = 1,
                comparators = {
                    compare.exact,
                    compare.offset,
                    compare.score,

                    function(entry1, entry2) -- kind priority
                        local kind1 = cmp_lsp_kind[entry1:get_kind()]
                        local kind2 = cmp_lsp_kind[entry2:get_kind()]
                        local prio1 = kinds[kind1].priority
                        local prio2 = kinds[kind2].priority

                        local is_local = compare.locality(entry1, entry2)

                        local diff = prio2 - prio1
                        -- d < 0 -> true;  d > 0 -> false;  d * -> nil
                        return is_local or (diff < 0 or not (diff > 0) and nil)
                    end,

                    compare.offset,
                    compare.score,
                    compare.recently_used,
                    compare.kind,
                    compare.sort_text,
                },
            }

            cmp.setup(opts)
        end,
    },

    {
        'supermaven-inc/supermaven-nvim',
        event = 'VeryLazy',
        lazy = false,
        init = function() vim.g.supermaven_enabled = true end,
        keys = {
            {
                '<leader>ua',
                function()
                    vim.g.supermaven_enabled = not vim.g.supermaven_enabled
                    if vim.g.supermaven_enabled then
                        vim.cmd.SupermavenStart()
                        Nihil.log.info 'Enabled Supermaven'
                    else
                        vim.cmd.SupermavenStop()
                        Nihil.log.warn 'Disabled Supermaven'
                    end
                end,
                desc = 'Toggle Smart Suggestion',
            },
        },
        opts = {
            disable_inline_completion = false,
            disable_keymaps = true,
            ignore_filetypes = {},
        },
    },
}
