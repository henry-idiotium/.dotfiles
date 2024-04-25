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
            local has_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
            local lsp_util = require 'nihil.util.lsp'
            local options = require 'nihil.plugins.lsp.config'
            local lsp_opts = options.lspconfig

            local capabilities = vim.tbl_deep_extend(
                'force',
                {},
                vim.lsp.protocol.make_client_capabilities(),
                has_cmp and cmp_lsp.default_capabilities() or {},
                lsp_opts.capabilities or {}
            )

            require('mason').setup { ui = { border = 'rounded' } }
            require('mason-tool-installer').setup(options.mason_tool)
            require('mason-lspconfig').setup(vim.tbl_deep_extend('force', {}, options.mason_lspconfig, {
                handlers = {
                    function(server)
                        local server_opts = lsp_opts.servers[server] or {}
                        require('lspconfig')[server].setup(vim.tbl_deep_extend('force', {}, server_opts, {
                            capabilities = vim.deepcopy(capabilities),
                        }))
                    end,
                },
            }))

            ---- Setup keymaps
            lsp_util.on_attach(function(client, buffer) require('nihil.plugins.lsp.keymaps').on_attach(client, buffer) end)

            ---- Setup diagnostic
            vim.diagnostic.config(vim.deepcopy(lsp_opts.diagnostics))

            local diagnostic_opts = lsp_opts.diagnostics
            local register_capability = vim.lsp.handlers['client/registerCapability']
            vim.lsp.handlers['client/registerCapability'] = function(err, res, ctx)
                local ret = register_capability(err, res, ctx)
                local buffer = vim.api.nvim_get_current_buf()
                local client = vim.lsp.get_client_by_id(ctx.client_id)
                require('nihil.plugins.lsp.keymaps').on_attach(client, buffer)
                return ret
            end

            -- inlay hints
            if lsp_opts.inlay_hints.enabled then
                lsp_util.on_attach(function(client, buffer)
                    if client.supports_method 'textDocument/inlayHint' then lsp_util.toggle.inlay_hints(buffer, true) end
                end)
            end

            -- diagnostics signs
            for severity, icon in pairs(diagnostic_opts.signs.text) do
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
}
