---@diagnostic disable: no-unknown, missing-fields, duplicate-set-field
return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'williamboman/mason.nvim', opts = { ui = { border = 'rounded' } } },
            'williamboman/mason-lspconfig.nvim',
            'hrsh7th/cmp-nvim-lsp',
        },

        config = function()
            local cmp_lsp = require 'cmp_nvim_lsp'
            local opts = Nihil.config.lspconfig

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
                    function(server)
                        require('lspconfig')[server].setup(vim.tbl_deep_extend('force', {
                            capabilities = capabilities,
                        }, opts.servers[server] or {}))
                    end,
                },
            }

            ---- Setup keymaps
            local function attach_keymaps(_, buffer)
                for _, raw_map_opts in pairs(opts.keymaps) do
                    local mode, lhs, rhs, map_opts = Nihil.util.keymap.resolve_raw_options(raw_map_opts)
                    map_opts.buffer = buffer
                    map_opts.silent = true
                    vim.keymap.set(mode, lhs, rhs, map_opts)
                end
            end

            Nihil.util.lsp.on_attach(attach_keymaps)

            local register_capability = vim.lsp.handlers['client/registerCapability']
            vim.lsp.handlers['client/registerCapability'] = function(err, res, ctx)
                local ret = register_capability(err, res, ctx)
                local buffer = vim.api.nvim_get_current_buf()
                local client = vim.lsp.get_client_by_id(ctx.client_id)
                attach_keymaps(client, buffer)
                return ret
            end

            ---- Setup diagnostic
            vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
            -- diagnostics signs
            for severity, icon in pairs(opts.diagnostics.signs.text) do
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
