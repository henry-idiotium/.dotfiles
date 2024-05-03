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
    kinds = {
        Array = ' ',
        Boolean = '󰨙 ',
        Class = ' ',
        Codeium = '󰘦 ',
        Color = ' ',
        Control = ' ',
        Collapsed = ' ',
        Constant = '󰏿 ',
        Constructor = ' ',
        Copilot = ' ',
        Enum = ' ',
        EnumMember = ' ',
        Event = ' ',
        Field = ' ',
        File = ' ',
        Folder = ' ',
        Function = '󰊕 ',
        Interface = ' ',
        Key = ' ',
        Keyword = ' ',
        Method = '󰊕 ',
        Module = ' ',
        Namespace = '󰦮 ',
        Null = ' ',
        Number = '󰎠 ',
        Object = ' ',
        Operator = ' ',
        Package = ' ',
        Property = ' ',
        Reference = ' ',
        Snippet = ' ',
        String = ' ',
        Struct = '󰆼 ',
        TabNine = '󰏚 ',
        Text = ' ',
        TypeParameter = ' ',
        Unit = ' ',
        Value = ' ',
        Variable = '󰀫 ',
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
        jsonls = {},
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

    keymaps = {
        { 'gd', '<cmd>FzfLua lsp_finder<cr>', desc = 'Goto Definition' },
        { 'g<s-d>', '<cmd>FzfLua lsp_declarations<cr>', desc = 'Goto declaration' },
        { 'gr', '<cmd>FzfLua lsp_references<cr>', desc = 'Goto/listing references' },
        { 'gi', '<cmd>FzfLua lsp_implementations<cr>', desc = 'Goto Implementation' },

        { '<s-k>', vim.lsp.buf.hover, desc = 'Hover/Show definition' },
        { '<c-k>', vim.lsp.buf.signature_help, mode = 'i', desc = 'Show signature' },
        { 'gk', vim.lsp.buf.signature_help, desc = 'Show signature' },

        { '<leader>cl', '<cmd>LspInfo<cr>', desc = 'Lsp Info' },
        { '<leader>cr', vim.lsp.buf.rename, desc = 'Rename symbol' },
        { '<leader>cd', vim.diagnostic.open_float, desc = 'Open diagnostics' },
        { '<leader>ca', '<cmd>FzfLua lsp_code_actions<cr>', mode = { 'n', 'v' }, desc = 'Code actions' },

        -- { '<leader>tli', function() require('nihil.util.lsp').toggle.inlay_hints() end, desc = 'Inlay Hints' },
    },
}

--- Formatting (Conform)
M.conform = {
    format_on_save = { timeout_ms = 3000, lsp_fallback = false, async = false },
    mason_tools = {
        'prettierd',
        'black',
        'stylua',
    },
}

local prettier_fmt = { 'prettierd', 'prettier' }
---@type table<string, conform.FiletypeFormatter>
M.conform.formatters_by_ft = {
    lua = { 'stylua' },
    go = { 'goimports', 'gofmt' },
    rust = { 'rustfmt' },
    python = { 'isort', 'black' },
    fish = { 'fish_indent' },
    markdown = prettier_fmt,
    typescript = prettier_fmt,
    typescriptreact = prettier_fmt,
    javascript = prettier_fmt,
    javascriptreact = prettier_fmt,
    json = prettier_fmt,
    html = prettier_fmt,
    css = prettier_fmt,
    ['_'] = { 'trim_whitespace' },
}

_G.Nihil.settings = M
return M