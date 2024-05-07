---@diagnostic disable: missing-fields
local M = {}

--- Icons used by plugins
M.icons = {
    misc = {
        dots = '󰇘',
    },
    dap = {
        Stopped = { '󰁕 ', 'DiagnosticWarn', 'DapStoppedLine' },
        Breakpoint = ' ',
        BreakpointCondition = ' ',
        BreakpointRejected = { ' ', 'DiagnosticError' },
        LogPoint = '.>',
    },
    diagnostics = {
        error = ' ',
        warn = ' ',
        hint = ' ',
        info = ' ',
    },
    git = {
        added = ' ',
        modified = ' ',
        removed = ' ',
    },
}

--- Lsp Config
M.lspconfig = {
    inlay_hints = { enabled = false },
    codelens = { enabled = false },

    ---@type vim.diagnostic.Opts
    diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, source = 'if_many' },
        severity_sort = true,
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = M.icons.diagnostics.error,
                [vim.diagnostic.severity.WARN] = M.icons.diagnostics.warn,
                [vim.diagnostic.severity.HINT] = M.icons.diagnostics.hint,
                [vim.diagnostic.severity.INFO] = M.icons.diagnostics.info,
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
        rust_analyzer = {},
        tailwindcss = {},
        emmet_ls = {},
        html = {},
        gopls = {},
        pyright = {},

        tsserver = {
            single_file_support = false,
            root_dir = function(...) return require('lspconfig.util').root_pattern('tsconfig.json', 'jsconfig.json', 'package.json', '.git')(...) end,
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
        cssls = {
            settings = {
                css = { validate = true, lint = { unknownAtRules = 'ignore' } },
                scss = { validate = true, lint = { unknownAtRules = 'ignore' } },
                less = { validate = true, lint = { unknownAtRules = 'ignore' } },
            },
        },

        yamlls = {
            -- Have to add this for yamlls to understand that we support line folding
            capabilities = {
                textDocument = {
                    foldingRange = {
                        dynamicRegistration = false,
                        lineFoldingOnly = true,
                    },
                },
            },
            -- lazy-load schemastore when needed
            on_new_config = function(new_config)
                new_config.settings.yaml.schemas = vim.tbl_deep_extend('force', new_config.settings.yaml.schemas or {}, require('schemastore').yaml.schemas())
            end,
            settings = {
                redhat = { telemetry = { enabled = false } },
                yaml = {
                    keyOrdering = false,
                    format = {
                        enable = true,
                    },
                    validate = true,
                    schemaStore = {
                        -- Must disable built-in schemaStore support to use
                        -- schemas from SchemaStore.nvim plugin
                        enable = false,
                        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                        url = '',
                    },
                },
            },
        },
        jsonls = {
            -- lazy-load schemastore when needed
            on_new_config = function(new_config)
                new_config.settings.json.schemas = new_config.settings.json.schemas or {}
                vim.list_extend(new_config.settings.json.schemas, require('schemastore').json.schemas())
            end,
            settings = {
                json = {
                    format = {
                        enable = true,
                    },
                    validate = { enable = true },
                },
            },
        },

        lua_ls = {
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

    keymaps = {
        { 'gd', '<cmd>FzfLua lsp_finder<cr>', desc = 'Goto Definition' },
        { 'g<s-d>', '<cmd>FzfLua lsp_declarations<cr>', desc = 'Goto declaration' },
        { 'gr', '<cmd>FzfLua lsp_references<cr>', desc = 'Goto/listing references' },
        { 'gi', '<cmd>FzfLua lsp_implementations<cr>', desc = 'Goto Implementation' },

        { '<s-k>', vim.lsp.buf.hover, desc = 'Hover/Show definition' },
        { '<c-k>', vim.lsp.buf.signature_help, mode = 'i', desc = 'Show signature' },
        { 'gk', vim.lsp.buf.signature_help, desc = 'Show signature' },

        { '<leader>cr', vim.lsp.buf.rename, desc = 'Rename symbol' },
        { '<leader>cd', vim.diagnostic.open_float, desc = 'Open diagnostics' },
        { '<leader>ca', '<cmd>FzfLua lsp_code_actions<cr>', mode = { 'n', 'v' }, desc = 'Code actions' },

        -- { '<leader>tli', function() require('nihil.util.lsp').toggle.inlay_hints() end, desc = 'Inlay Hints' },
    },
}

--- Formatting (Conform)
M.conform = {
    format_on_save = { timeout_ms = 3000, lsp_fallback = false, async = false },

    mason_ensure_installed = {
        'prettierd',
        'black',
        'stylua',
    },

    ---@type table<string, conform.FiletypeFormatter>
    formatters_by_ft = {
        lua = { 'stylua' },
        go = { 'goimports', 'gofmt' },
        rust = { 'rustfmt' },
        python = { 'isort', 'black' },
        fish = { 'fish_indent' },
        markdown = { 'prettierd' },
        typescript = { 'prettierd' },
        typescriptreact = { 'prettierd' },
        javascript = { 'prettierd' },
        javascriptreact = { 'prettierd' },
        json = { 'prettierd' },
        html = { 'prettierd' },
        css = { 'prettierd' },
        ['_'] = { 'trim_whitespace' },
    },
}

--- Exclude filetypes
M.minimal_plugins_filetypes = {
    'PlenaryTestPopup',
    'neotest-output-panel',
    'neotest-output',
    'no-neck-pain',
    'neotest-summary',
    'spectre_panel',
    'startuptime',
    'checkhealth',
    'Trouble',
    'lspinfo',
    'lazy',
    'gitrebase',
    'gitcommit',
    'hgcommit',
    'notify',
    'query',
    'netrw',
    'vim',
    'help',
    'svn',
    'qf',
}

_G.Nihil.settings = M
return M
