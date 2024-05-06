---@diagnostic disable: no-unknown, missing-fields, duplicate-set-field
return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',

            { 'folke/neodev.nvim', config = true },
            { 'folke/neoconf.nvim', dependencies = { 'nvim-lspconfig' }, cmd = 'Neoconf', config = true },

            {
                'hrsh7th/nvim-cmp',
                version = false,
                event = 'InsertEnter',
                dependencies = {
                    'hrsh7th/cmp-path',
                    'hrsh7th/cmp-cmdline',
                    'hrsh7th/cmp-nvim-lsp',
                    'hrsh7th/cmp-buffer',
                    'L3MON4D3/LuaSnip',
                    'saadparwaiz1/cmp_luasnip',
                },
            },
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
            require('mason').setup { ui = { border = 'rounded' } }
            require('mason-lspconfig').setup {
                ensure_installed = vim.tbl_keys(opts.servers),
                handlers = {
                    function(server)
                        local server_opts = vim.deepcopy(opts.servers[server] or {})
                        server_opts.capabilities = capabilities
                        require('lspconfig')[server].setup(server_opts)
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
            local cmp_default = require 'cmp.config.default'()
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
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                }, {
                    { name = 'buffer' },
                    { name = 'markman' },
                    { name = 'path' },
                }),

                window = {
                    completion = { border = 'rounded' },
                    documentation = { border = 'rounded' },
                },

                completion = { completeopt = 'menu,menuone,noinsert' },
                experimental = {
                    ghost_text = {
                        hl_group = 'CmpGhostText',
                    },
                },
                sorting = cmp_default.sorting,
            }
        end,
    },

    { -- Yaml, JSON schema support
        'b0o/SchemaStore.nvim',
        lazy = true,
        version = false,
    },
}
