return {
    'neovim/nvim-lspconfig',
    ft = (require 'nihil.helpers.lsp' or {}).FILE_TYPES,
    event = 'VeryLazy',
    config = function()
        local helper = require 'nihil.helpers.lsp'
        local nvim_lsp = require 'lspconfig'

        -- Icons (LspKinds)
        require('vim.lsp.protocol').CompletionItemKind = vim.tbl_values(helper.LSP_ITEM_KINDS)

        -- Set up completion using nvim_cmp with LSP source
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        local on_attach = helper.on_attach
        local language_lsp_configs = {
            'flow',
            'tailwindcss',
            'cssls',
            'jsonls',
            'marksman',
            'pyright',
            eslint = {
                root_dir = nvim_lsp.util.root_pattern('yarn.lock', 'lerna.json', '.git'),
                on_attach = on_attach,
            },
            tsserver = {
                on_attach = on_attach,
                capabilities = capabilities,
                cmd = { 'typescript-language-server', '--stdio' },
                filetypes = {
                    'javascript',
                    'javascriptreact',
                    'javascript.tsx',
                    'typescript',
                    'typescriptreact',
                    'typescript.tsx',
                },
            },
            emmet_language_server = {
                on_attach = on_attach,
                capabilities = capabilities,
                filetypes = { 'html', 'css', 'sass', 'scss', 'less', 'typescriptreact', 'javascriptreact' },
                init_options = {
                    html = {
                        options = {
                            -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
                            ['bem.enabled'] = true,
                        },
                    },
                },
            },
            lua_ls = {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    Lua = {
                        -- Get the language server to recognize the `vim` global
                        diagnostics = { globals = { 'vim' } },
                        workspace = {
                            -- Make the server aware of Neovim runtime files
                            library = vim.api.nvim_get_runtime_file('', true),
                            checkThirdParty = false,
                        },
                    },
                },
            },
        }

        local default_config = { on_attach = on_attach, capabilities = capabilities }
        for key, value in pairs(language_lsp_configs) do
            local is_custom = type(value) ~= 'string'
            local name = is_custom and key or value
            local config = is_custom and value or default_config
            nvim_lsp[name].setup(config)
        end

        -- UI settings
        -- Diagnostic symbols in the sign column (gutter)
        local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
        for type, icon in pairs(signs) do
            local hl = 'DiagnosticSign' .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
        end

        vim.diagnostic.config {
            signs = true,
            severity_sort = true,
            update_in_insert = true,
            virtual_text = { spacing = 4, prefix = '●' },
            float = { source = 'always' }, -- Or 'if_many'
        }
    end,
}
