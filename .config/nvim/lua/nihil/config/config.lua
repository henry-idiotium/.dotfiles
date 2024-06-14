---@diagnostic disable: missing-fields, no-unknown
local M = {}

M.colorscheme = 'rose-pine'

--stylua: ignore
M.minimal_mode_enabled =
    vim.env.NVIM_MINIMAL_MODE ~= nil
    or vim.env.TMUX_POPUP ~= nil 

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
    --NOTE: NO order `as written in source` in lua
    kinds = {
        Variable = { '', 100 },
        Reference = { '', 95 },
        Constant = { '', 90 },
        Interface = { '', 90 },
        TypeParameter = { '', 90 },
        Function = { '', 85 },
        Field = { '', 85 },
        Method = { '', 85 },
        Class = { '', 85 },
        Property = { '', 80 },
        Enum = { '', 75 },
        EnumMember = { '', 75 },
        Constructor = { '', 75 },
        Struct = { '', 70 },
        Module = { '', 70 },

        Color = { '', 60 },
        Unit = { '', 60 },
        Value = { '', 60 },
        File = { '', 55 },
        Folder = { '', 55 },
        Event = { '', 40 },
        Operator = { '', 40 },
        Keyword = { '', 30 },

        Supermaven = { ' ', 20 },
        Codeium = { '󰘦 ', 20 },
        TabNine = { '󰏚 ', 20 },
        Copilot = { ' ', 20 },

        Snippet = { ' ', 15 },
        Text = { '', 0 },
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
        emmet_ls = {},
        html = {},
        gopls = {},
        pyright = {},
        prismals = {},
        tailwindcss = {},

        markdown_oxide = {
            workspace = {
                didChangeWatchedFiles = {
                    dynamicRegistration = true,
                },
            },
        },

        tsserver = {
            single_file_support = false,
            root_dir = function(...) return require('lspconfig.util').root_pattern('tsconfig.json', 'jsconfig.json', 'package.json', '.git')(...) end,
            init_options = {
                preferences = {
                    importModuleSpecifierPreference = 'non-relative',
                },
            },
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
                    validate = true,
                    schemaStore = {
                        enable = false, -- Must disable built-in schemaStore support to use schemas from SchemaStore.nvim plugin
                        url = '', -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
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
                    format = { enable = true },
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
        { 'gd', '<cmd>Trouble lsp_definitions <cr>', desc = 'Goto Definition' },
        { 'gD', '<cmd>Trouble lsp_declarations <cr>', desc = 'Goto Declaration' },
        { 'gr', '<cmd>Trouble lsp_references <cr>', desc = 'Goto Reference' },
        { 'gi', '<cmd>Trouble lsp_implementations <cr>', desc = 'Goto Implementation' },

        { 'K', vim.lsp.buf.hover, desc = 'Show Definition' },
        { '<c-k>', vim.lsp.buf.signature_help, mode = 'i', desc = 'Show Signature (this is my keymap)' },
        { 'gk', vim.lsp.buf.signature_help, desc = 'Show Signature' },

        { '<leader>cr', vim.lsp.buf.rename, desc = 'Rename Symbol' },
        { '<leader>cd', vim.diagnostic.open_float, desc = 'Open Diagnostics' },
        { '<leader>ca', '<cmd>FzfLua lsp_code_actions<cr>', mode = { 'n', 'v' }, desc = 'Code actions' },
    },
}

--- Formatting (Conform)
-----@type conform.setupOpts
M.conform = {
    format_on_save = { timeout_ms = 3000, lsp_fallback = false, async = false },
    mason_ensure_installed = {
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
    mdx = prettier_fmt,
    typescript = prettier_fmt,
    typescriptreact = prettier_fmt,
    javascript = prettier_fmt,
    javascriptreact = prettier_fmt,
    html = prettier_fmt,
    css = prettier_fmt,
    less = prettier_fmt,
    scss = prettier_fmt,
    json = prettier_fmt,
    jsonc = prettier_fmt,
    yaml = prettier_fmt,
    prisma = prettier_fmt,
    ['_'] = { 'trim_whitespace' },
}

M.excluded_filetypes = {
    'PlenaryTestPopup',
    'neotest-output-panel',
    'neotest-output',
    'neotest-summary',
    'neo-tree-popup',
    'no-neck-pain',
    'spectre_panel',
    'startuptime',
    'checkhealth',
    'tsplayground',
    'Trouble',
    'lspinfo',
    'lazy',
    'gitrebase',
    'gitcommit',
    'hgcommit',
    'notify',
    'query',
    'netrw',
    'text',
    'help',
    'svn',
    'vim',
    'qf',

    'tmux-harpoon',
}

--- vim filetype settings
M.filetype = {
    ---@type vim.filetype.add.filetypes
    vim = {
        pattern = {
            ['.env.*'] = 'conf',
        },
        filename = {
            ['.env'] = 'conf',
            ['.ignore'] = 'gitignore',
            ['Podfile'] = 'ruby',
            [vim.env.TMUX_HARPOON_CACHE_FILE] = 'tmux-harpoon',
        },
        extension = {
            mdx = 'mdx',
            astro = 'astro',
            tmux = 'tmux',
            prisma = function(_, buf)
                vim.b[buf].comment_string = '// %s'
                return 'prisma'
            end,
        },
    },

    treesitter = {
        -- Register a parser named {lang} to be used for {filetype}(s).
        register = {
            markdown = 'mdx',
            conf = 'tmux-harpoon',
        },
    },

    devicon = {
        override = { -- by filetype
            -- zsh = { icon = '', color = '#428850', cterm_color = '65', name = 'Zsh', },
        },
        override_by_filename = {
            -- ['.gitignore'] = { icon = '', color = '#f1502f', name = 'Gitignore', },
        },
        override_by_extension = {
            -- ['log'] = { icon = '', color = '#81e043', name = 'Log' },
        },
    },
}

-- Don't know where to put this
vim.filetype.add(M.filetype.vim)
for lang, ft in pairs(M.filetype.treesitter.register) do
    vim.treesitter.language.register(lang, ft)
end

vim.treesitter.language.register('conf', 'tmux-harpoon')

return M
