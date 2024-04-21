---@diagnostic disable: no-unknown, missing-fields
local M = {}

M.ui = {
    border = 'rounded',
}

---- LspConfig
M.lspconfig = {
    inlay_hints = { enabled = true },
    codelens = { enabled = true },

    ---@type vim.diagnostic.Opts
    diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
            spacing = 4,
            source = 'if_many',
            prefix = '●',
        },
        severity_sort = true,
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = ' ',
                [vim.diagnostic.severity.WARN] = ' ',
                [vim.diagnostic.severity.HINT] = ' ',
                [vim.diagnostic.severity.INFO] = ' ',
            },
        },
        float = {
            focusable = false,
            style = 'minimal',
            border = 'rounded',
            source = 'if_many',
            header = '',
            prefix = '',
        },
    },
    capabilities = {}, -- add any global capabilities here

    ---@type lspconfig.options
    servers = {
        cssls = {
            settings = {
                css = { validate = true, lint = { unknownAtRules = 'ignore' } },
                scss = { validate = true, lint = { unknownAtRules = 'ignore' } },
                less = { validate = true, lint = { unknownAtRules = 'ignore' } },
            },
        },
        tailwindcss = {
            root_dir = function(...)
                return require('lspconfig.util').root_pattern '.git'(...)
            end,
        },
        tsserver = {
            single_file_support = false,
            root_dir = function(...)
                return require('lspconfig.util').root_pattern '.git'(...)
            end,
            settings = {
                typescript = {
                    inlayHints = {
                        includeInlayParameterNameHints = 'literal',
                        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = false,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayEnumMemberValueHints = true,
                    },
                },
                javascript = {
                    inlayHints = {
                        includeInlayParameterNameHints = 'all',
                        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayEnumMemberValueHints = true,
                    },
                },
            },
        },
        html = {},
        yamlls = {
            settings = {
                yaml = {
                    keyOrdering = false,
                },
            },
        },
        lua_ls = {
            -- enabled = false,
            single_file_support = true,
            settings = {
                Lua = {
                    runtime = { version = 'Lua 5.4' },
                    workspace = { checkThirdParty = false },
                    doc = { privateName = { '^_' } },
                    type = { castNumberToInteger = true },
                    completion = {
                        workspaceWord = true,
                        callSnippet = 'Both',
                    },
                    hint = {
                        enable = true,
                        setType = false,
                        paramType = true,
                        paramName = 'Disable',
                        semicolon = 'Disable',
                        arrayIndex = 'Disable',
                    },
                    diagnostics = {
                        disable = { 'incomplete-signature-doc', 'trailing-space' },
                        -- enable = false,
                        groupSeverity = {
                            strong = 'Warning',
                            strict = 'Warning',
                        },
                        groupFileStatus = {
                            ['ambiguity'] = 'Opened',
                            ['await'] = 'Opened',
                            ['codestyle'] = 'None',
                            ['duplicate'] = 'Opened',
                            ['global'] = 'Opened',
                            ['luadoc'] = 'Opened',
                            ['redefined'] = 'Opened',
                            ['strict'] = 'Opened',
                            ['strong'] = 'Opened',
                            ['type-check'] = 'Opened',
                            ['unbalanced'] = 'Opened',
                            ['unused'] = 'Opened',
                        },
                        unusedLocalExclude = { '_*' },
                        globals = { 'vim', 'it', 'describe', 'before_each', 'after_each' },
                    },
                },
            },
        },
    },

    ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
    setup = {},
}

---- Mason for tools like formatter, lint, dap
M.mason_tool = {
    ensure_installed = {
        'prettierd',
        'black',
        'stylua',
    },
}

---- Mason for LspConfig
M.mason_lspconfig = {
    ensure_installed = {
        'lua_ls',
        'rust_analyzer',
        'gopls',
        'tsserver',
        'pyright',
        'jsonls',
        'yamlls',
    },
    handlers = {},
}

---- Conform (formatting)
local prettier_fmt = { 'prettierd', 'prettier' }

M.conform = {
    ---@type table<string, conform.FiletypeFormatter>
    formatters_by_ft = {
        lua = { 'stylua' },
        go = { 'goimports', 'gofmt' },
        rust = { 'rustfmt' },
        typescript = prettier_fmt,
        typescriptreact = prettier_fmt,
        javascript = prettier_fmt,
        javascriptreact = prettier_fmt,
        json = prettier_fmt,
        html = prettier_fmt,
        css = prettier_fmt,
        python = { 'isort', 'black' },
        ['_'] = { 'trim_whitespace' },
    },
    format_on_save = { timeout_ms = 3000, lsp_fallback = false, async = false },
}

return M
