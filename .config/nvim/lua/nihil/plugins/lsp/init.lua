---@diagnostic disable: no-unknown, missing-fields, duplicate-set-field
return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',
            { 'hrsh7th/nvim-cmp', version = false, event = 'InsertEnter' },
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'j-hui/fidget.nvim',
            'stevearc/conform.nvim',
            { 'folke/neodev.nvim', opts = {} },
            { 'folke/neoconf.nvim', dependencies = { 'nvim-lspconfig' }, cmd = 'Neoconf', opts = {} },
        },

        config = function()
            local cmp = require 'cmp'
            local has_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
            local lsp_utils = require 'nihil.plugins.lsp.utils'
            local options = require 'nihil.plugins.lsp.options'
            local lsp_opts = options.lspconfig

            local capabilities = vim.tbl_deep_extend(
                'force',
                {},
                vim.lsp.protocol.make_client_capabilities(),
                has_cmp and cmp_lsp.default_capabilities() or {},
                lsp_opts.capabilities or {}
            )

            require('mason').setup { ui = { border = options.ui.border } }
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
            lsp_utils.on_attach(function(client, buffer) require('nihil.plugins.lsp.keymaps').on_attach(client, buffer) end)

            ---- Setting lsp UI
            vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = options.ui.border })
            vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.hover, { border = options.ui.border })

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

            -- -- inlay hints
            -- if lsp_opts.inlay_hints.enabled then
            --     lsp_utils.on_attach(function(client, buffer)
            --         if client.supports_method 'textDocument/inlayHint' then lsp_utils.toggle.inlay_hints(buffer, true) end
            --     end)
            -- end

            -- code lens
            if lsp_opts.codelens.enabled and vim.lsp.codelens then
                lsp_utils.on_attach(function(client, buffer)
                    if client.supports_method 'textDocument/codeLens' then
                        vim.lsp.codelens.refresh()
                        vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
                            buffer = buffer,
                            callback = vim.lsp.codelens.refresh,
                        })
                    end
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
                }),
                window = {
                    completion = { border = options.ui.border },
                    documentation = { border = options.ui.border },
                },

                completion = { completeopt = 'menu,menuone,noinsert' },
                experimental = {
                    ghost_text = {
                        hl_group = 'CmpGhostText',
                    },
                },
                sorting = cmp_default.sorting,
            }

            vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true })
        end,
    },

    {
        'stevearc/conform.nvim',
        event = { 'BufWritePre' },
        lazy = true,

        cmd = { 'ConformInfo' },
        keys = {
            {
                '<a-s-f>',
                function() require('conform').format(require('nihil.plugins.lsp.options').conform.format_on_save) end,
                mode = { 'i', 'n', 'v' },
                desc = 'Format buffer',
            },
            {
                '<leader>cf',
                function() require('conform').format(require('nihil.plugins.lsp.options').conform.format_on_save) end,
                mode = { 'n', 'v' },
                desc = 'Format buffer',
            },

            { '<leader>tf', '<cmd>ToggleAutoFormat<cr>', mode = { 'n', 'v' }, desc = 'Toggle Auto Format Globally' },
            { '<leader>t<s-f>', '<cmd>ToggleAutoFormat!<cr>', mode = { 'n', 'v' }, desc = 'Toggle Auto Format Locally' },
        },

        init = function()
            vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"

            vim.api.nvim_create_user_command('ToggleAutoFormat', function(arg)
                if arg.bang then
                    vim.b.disable_autoformat = not vim.b.disable_autoformat and true or nil
                else
                    vim.g.disable_autoformat = not vim.g.disable_autoformat and true or nil
                end

                vim.notify('- [' .. (vim.g.disable_autoformat and ' ' or 'x') .. '] global auto format', vim.log.levels.INFO)
                vim.notify('- [' .. (vim.b.disable_autoformat and ' ' or 'x') .. '] local auto format', vim.log.levels.INFO)
            end, {
                desc = 'Toggle Auto Format (global)',
                bang = true,
            })
        end,

        opts = require('nihil.plugins.lsp.options').conform,

        config = function(_, opts)
            require('conform').setup(vim.tbl_deep_extend('force', opts, {
                format_on_save = function(bufnr)
                    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
                    return opts.format_on_save
                end,
            }))
        end,
    },
}
