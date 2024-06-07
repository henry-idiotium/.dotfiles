---@diagnostic disable: no-unknown, missing-fields, duplicate-set-field
return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'williamboman/mason.nvim', opts = { ui = { border = 'rounded' } } },
            'williamboman/mason-lspconfig.nvim',

            { 'folke/neodev.nvim', event = 'VeryLazy', config = true },
            { 'folke/neoconf.nvim', event = 'VeryLazy', cmd = 'Neoconf', config = true },

            'hrsh7th/cmp-nvim-lsp',
        },

        config = function()
            local cmp_lsp = require 'cmp_nvim_lsp'
            local opts = Nihil.settings.lspconfig

            local capabilities = vim.tbl_deep_extend('force', {
                textDocument = {
                    foldingRange = {
                        dynamicRegistration = false,
                        lineFoldingOnly = true,
                    },
                },
            }, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())

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
                for _, raw_map_opts in pairs(opts.keymaps) do
                    local mode, lhs, rhs, map_opts = Nihil.utils.key.resolve_raw_keymap_opts(raw_map_opts)
                    map_opts.buffer = buffer
                    map_opts.silent = true
                    vim.keymap.set(mode, lhs, rhs, map_opts)
                end
            end

            Nihil.utils.lsp.on_attach(attach_keymaps)

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
                Nihil.utils.lsp.on_attach(function(client, buffer)
                    if client.supports_method 'textDocument/inlayHint' then Nihil.utils.lsp.toggle.inlay_hints(buffer, true) end
                end)
            end

            -- diagnostics signs
            for severity, icon in pairs(diag_opts.signs.text) do
                local name = vim.diagnostic.severity[severity]:lower():gsub('^%l', string.upper)
                name = 'DiagnosticSign' .. name
                vim.fn.sign_define(name, { text = icon, texthl = name, numhl = '' })
            end
        end,
    },

    { -- Yaml, JSON schema support
        'b0o/SchemaStore.nvim',
        lazy = true,
        version = false,
    },
}
