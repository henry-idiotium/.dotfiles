---@diagnostic disable: no-unknown
return {
    { -- Completion
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        version = false,
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
                -- ghost_text = { hl_group = 'CmpGhostText' },
                ghost_text = false,
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
                ['<c-space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
                ['<c-j>'] = cmp.mapping.select_next_item(cmp_select),
                ['<c-k>'] = cmp.mapping.select_prev_item(cmp_select),
                -- ['<tab>'] = cmp.mapping.confirm { select = true },
                ['<c-y>'] = cmp.mapping.confirm { select = true },
                ['<cr>'] = cmp.mapping.confirm { select = true },

                ['<c-e>'] = {
                    i = cmp.mapping.abort(),
                    c = cmp.mapping.close(),
                },
                ['<c-g>'] = function() return cmp.visible_docs() and cmp.close_docs() or cmp.open_docs() end,
                ['<tab>'] = function()
                    local sm = require 'supermaven-nvim.completion_preview'
                    local ls = require 'luasnip'

                    if ls.expandable() then
                        ls.expand()
                    elseif sm.has_suggestion() then
                        sm.on_accept_suggestion()
                    else
                        cmp.confirm { select = true }
                    end
                end,
            }

            ---- Sources
            opts.sources = cmp.config.sources({
                { name = 'nvim_lsp', priority = 10000 },
                { name = 'supermaven' },
                { name = 'luasnip', priority = 0 },
            }, {
                { name = 'buffer', priority = 8 },
                { name = 'path', priority = 5 },
            })

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

    {
        'supermaven-inc/supermaven-nvim',
        event = 'VeryLazy',
        opts = {
            disable_inline_completion = false,
            disable_keymaps = true,

            color = {
                suggestion_color = '#ffffff',
                cterm = 200,
            },

            ignore_filetypes = {
                cpp = true,
            },
        },
    },
}
