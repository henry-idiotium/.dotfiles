---@diagnostic disable: no-unknown
return {
    { -- lsp servers
        'nvim-lspconfig',
        opts = function(_, opts) opts = vim.tbl_deep_extend('force', {}, opts, require 'nihil.lsp') end,
        init = function()
            local keys = require('lazyvim.plugins.lsp.keymaps').get()
            keys[#keys + 1] = {
                '🔥',
                function() require('fzf-lua').lsp_code_actions { winopts = { height = 0.4, width = 0.6 } } end,
                mode = { 'n', 'v' },
                desc = 'Code actions',
                has = 'codeAction',
            }
        end,
    },

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

    { -- Completion
        'nvim-cmp',
        opts = function(_, opts)
            local cmp = require 'cmp'

            opts.completion = {
                autocomplete = false,
                completeopt = 'menu,menuone,noinsert',
            }
            opts.window = {
                completion = { border = 'rounded' },
                documentation = { border = 'rounded' },
            }
            opts.experimental = { ghost_text = false }

            local cmp_select = { behavior = cmp.SelectBehavior.Select }
            local cmp_close = {
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }
            opts.mapping = cmp.mapping.preset.insert {
                ['<c-space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
                ['<c-u>'] = cmp.mapping.scroll_docs(-4),
                ['<c-d>'] = cmp.mapping.scroll_docs(4),
                ['<c-j>'] = cmp.mapping.select_next_item(cmp_select),
                ['<c-k>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<c-y>'] = cmp.mapping.confirm { select = true },
                ['<cr>'] = cmp.mapping.confirm { select = true },
                ['<c-q>'] = cmp_close,
                ['<c-e>'] = cmp_close,

                ['<c-g>'] = function() return cmp.visible_docs() and cmp.close_docs() or cmp.open_docs() end,
                ['<tab>'] = function(fallback)
                    local sm = require 'supermaven-nvim.completion_preview'
                    if not cmp.visible() and sm.has_suggestion() then
                        sm.on_accept_suggestion()
                    elseif cmp.visible() then
                        cmp.confirm { select = true }
                    else
                        fallback()
                    end
                end,
            }

            ---- Formatting
            local icons = LazyVim.config.icons.kinds
            opts.formatting = { ---@type cmp.FormattingConfig
                expandable_indicator = false,
                fields = { 'kind', 'abbr' },
                format = function(_, item)
                    item.kind = icons[item.kind] or ' ' -- icon
                    return item
                end,
            }

            ---- Order/Sorting
            local compare = cmp.config.compare
            local cmp_lsp_kind = require('cmp.types').lsp.CompletionItemKind
            local kind_priority = require('nihil.kinds').priority
            opts.sorting = { ---@type cmp.SortingConfig
                priority_weight = 1,
                comparators = {
                    compare.exact,
                    compare.offset,
                    compare.score,

                    ---@param entry1 cmp.Entry
                    ---@param entry2 cmp.Entry
                    function(entry1, entry2) -- kind priority
                        local kind1 = cmp_lsp_kind[entry1:get_kind()]
                        local kind2 = cmp_lsp_kind[entry2:get_kind()]
                        local prio1 = kind_priority[kind1]
                        local prio2 = kind_priority[kind2]
                        if not (prio1 and prio2) then return true end

                        local is_local = compare.locality(entry1, entry2)

                        local diff = prio2 - prio1
                        return is_local or (diff < 0 or not diff > 0 and nil)
                    end,

                    compare.offset,
                    compare.score,
                    compare.recently_used,
                    compare.kind,
                    compare.sort_text,
                },
            }
        end,
    },

    {
        'supermaven-inc/supermaven-nvim',
        event = 'VeryLazy',
        lazy = false,
        init = function() vim.g.supermaven_enabled = true end,
        keys = {
            { '<leader><leader>a', function() require('utils.toggle').var 'supermaven_enabled' end, desc = 'Toggle Smart Suggestion' },
        },
        opts = {
            disable_inline_completion = false,
            disable_keymaps = true,
            ignore_filetypes = {},
        },
    },

    {
        'justinsgithub/wezterm-types',
        lazy = true,
        dependencies = { 'lazydev.nvim', opts = function(_, opts) table.insert(opts.library, { path = 'wezterm-types', mods = { 'wezterm' } }) end },
        cond = function() return vim.fn.fnamemodify(vim.fn.expand '%', ':t') == 'wezterm.lua' end,
    },

    { -- Change case
        'johmsalas/text-case.nvim',
        keys = { 'cc', desc = 'Change Case' },
        opts = {
            default_keymappings_enabled = true,
            prefix = 'cc',
        },
    },
}
