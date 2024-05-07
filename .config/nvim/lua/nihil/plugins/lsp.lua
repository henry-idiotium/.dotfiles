---@diagnostic disable: no-unknown, missing-fields, duplicate-set-field
return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'williamboman/mason.nvim', opts = { ui = { border = 'rounded' } } },
            'williamboman/mason-lspconfig.nvim',

            { 'folke/neodev.nvim', event = 'VeryLazy', config = true },
            { 'folke/neoconf.nvim', event = 'VeryLazy', cmd = 'Neoconf', config = true },

            { 'hrsh7th/nvim-cmp', version = false, event = 'InsertEnter' },
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'saadparwaiz1/cmp_luasnip',

            'L3MON4D3/LuaSnip',

            { 'onsails/lspkind.nvim', event = 'VeryLazy', lazy = true },
        },

        config = function()
            local cmp = require 'cmp'
            local cmp_lsp = require 'cmp_nvim_lsp'
            local opts = Nihil.settings.lspconfig
            local utils = Nihil.utils

            -- stylua: ignore
            local capabilities = vim.tbl_deep_extend('force', {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_lsp.default_capabilities()
            )

            require('lspconfig.ui.windows').default_options.border = 'single'
            require('mason-lspconfig').setup {
                ensure_installed = vim.tbl_keys(opts.servers),
                handlers = {
                    function(server_name)
                        require('lspconfig')[server_name].setup(vim.tbl_deep_extend('force', {}, opts.servers[server_name], {
                            capabilities = capabilities,
                        }))
                    end,
                },
            }

            ---- Setup keymaps
            local function attach_keymaps(_, buffer)
                for _, value in pairs(opts.keymaps) do
                    local args = utils.key.resolve_opts(value)
                    args.opts.buffer = buffer
                    args.opts.silent = true
                    vim.keymap.set(args.mode, args.lhs, args.rhs, args.opts)
                end
            end

            utils.lsp.on_attach(attach_keymaps)

            ---- Setup diagnostic
            local diag_opts = opts.diagnostics
            local register_capability = vim.lsp.handlers['client/registerCapability']

            vim.lsp.handlers['client/registerCapability'] = function(err, res, ctx)
                local ret = register_capability(err, res, ctx)
                local buffer = vim.api.nvim_get_current_buf()
                local client = vim.lsp.get_client_by_id(ctx.client_id)
                attach_keymaps(client, buffer)
                return ret
            end

            vim.diagnostic.config(diag_opts)

            -- inlay hints
            if opts.inlay_hints.enabled then
                utils.lsp.on_attach(function(client, buffer)
                    if client.supports_method 'textDocument/inlayHint' then utils.lsp.toggle.inlay_hints(buffer, true) end
                end)
            end

            -- diagnostics signs
            for severity, icon in pairs(diag_opts.signs.text) do
                local name = vim.diagnostic.severity[severity]:lower():gsub('^%l', string.upper)
                name = 'DiagnosticSign' .. name
                vim.fn.sign_define(name, { text = icon, texthl = name, numhl = '' })
            end

            ---- Setup completion
            local cmp_select = { behavior = cmp.SelectBehavior.Select }
            local compare = cmp.config.compare
            local lspkind = require 'lspkind'
            local cmp_types = require 'cmp.types'
            cmp.setup {
                mapping = cmp.mapping.preset.insert {
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
                },

                snippet = {
                    expand = function(args) require('luasnip').lsp_expand(args.body) end,
                },

                sources = cmp.config.sources {
                    { name = 'nvim_lsp' },
                    { name = 'buffer' },
                    { name = 'luasnip' },
                    { name = 'path' },
                },

                formatting = {
                    fields = { 'kind', 'abbr', 'menu' },
                    format = function(entry, item)
                        local kind = lspkind.cmp_format { mode = 'symbol_text', maxwidth = 50 }(entry, item)
                        local strings = vim.split(kind.kind, '%s', { trimempty = true })
                        kind.kind = (strings[1] or '') .. ' '
                        kind.menu = strings[2] or ''
                        return kind
                    end,
                },

                window = {
                    completion = { border = 'rounded' },
                    documentation = { border = 'rounded' },
                },

                completion = { completeopt = 'menu,menuone,noinsert' },

                experimental = {
                    ghost_text = { hl_group = 'CmpGhostText' },
                },

                sorting = {
                    comparators = {
                        compare.locality,
                        compare.recently_used,

                        function(entry1, entry2)
                            local kind1 = entry1:get_kind()
                            local kind2 = entry2:get_kind()
                            if kind1 ~= kind2 then
                                if kind1 == cmp_types.lsp.CompletionItemKind.Snippet then return false end
                                if kind2 == cmp_types.lsp.CompletionItemKind.Snippet then return true end
                                local diff = kind1 - kind2
                                return not diff == 0 and diff < 0 or nil
                            end
                        end,

                        compare.exact,
                        compare.offset,
                        compare.score,
                        -- function(entry1, entry2)
                        --     local _, entry1_under = entry1.completion_item.label:find '^_+'
                        --     local _, entry2_under = entry2.completion_item.label:find '^_+'
                        --
                        --     entry1_under = entry1_under or 0
                        --     entry2_under = entry2_under or 0
                        --
                        --     return not entry1_under == entry2_under and entry1_under > entry2_under or nil
                        -- end,
                        compare.locality,
                        compare.recently_used,
                        compare.kind,
                        compare.sort_text,
                        compare.order,
                    },
                },
            }
        end,
    },

    { -- Yaml, JSON schema support
        'b0o/SchemaStore.nvim',
        lazy = true,
        version = false,
    },
}
