return {
    'neovim/nvim-lspconfig',
    config = function()
        local nvim_lsp = require 'lspconfig'
        local api = vim.api
        local helpers = require 'nihil.helpers.lsp'

        ---@diagnostic disable-next-line: unused-local
        local function on_attach(client, bufnr)
            -- helpers.auto_format.lsp(client, bufnr)
            -- helpers.user_cmds.toggle_auto_format(client, bufnr)
            -- helpers.user_cmds.toggle_diagnostic(client, bufnr)

            if vim.g.logging_level == 'debug' then
                local msg = string.format('Language server %s started!', client.name)
                vim.notify(msg, vim.log.levels.DEBUG, { title = 'Nvim-Lsp-Config' })
            end
        end

        ------------------
        --: Lsp kinds (icons)
        --
        -- NOTE: maybe useless ¯\_(ツ)_/¯
        ------

        local protocol = require 'vim.lsp.protocol'
        local item_kinds = helpers.LSP_ITEM_KINDS

        protocol.CompletionItemKind = {}
        for _, icon_kind in ipairs(item_kinds) do
            table.insert(protocol.CompletionItemKind, icon_kind)
        end

        ------------------
        --: Lsp settings
        ------

        -- Set up completion using nvim_cmp with LSP source
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
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
                            library = api.nvim_get_runtime_file('', true),
                            checkThirdParty = false,
                        },
                    },
                },
            },
        }

        --: Language settings
        for key, value in pairs(language_lsp_configs) do
            if type(value) == 'string' then
                nvim_lsp[value].setup { on_attach = on_attach, capabilities = capabilities }
            else
                nvim_lsp[key].setup(value)
            end
        end

        ------------------
        --: Neovim Lsp UI settings
        ------

        --: Diagnostic symbols in the sign column (gutter)
        local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
        for type, icon in pairs(signs) do
            local hl = 'DiagnosticSign' .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '', icon = icon })
        end

        vim.diagnostic.config {
            signs = true,
            severity_sort = true,
            update_in_insert = true,
            virtual_text = { spacing = 4, prefix = '●' },
            float = { source = 'always' }, -- Or 'if_many'
        }

        --: border
        -- local DOC_HANDLERS = {
        --     'diagnostic',
        --     'hover',
        -- }
        -- for _, handler in pairs(DOC_HANDLERS) do
        --     vim.lsp.handlers['textDocument/' .. handler] = vim.lsp.with(
        --         vim.lsp.handlers[handler],
        --         { border = 'rounded' }
        --     )
        -- end
    end,
}
