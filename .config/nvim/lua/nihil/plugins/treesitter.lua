return {
    -- Automatically add closing tags for HTML and JSX
    { 'windwp/nvim-ts-autotag', lazy = true, opts = {} },

    { 'nvim-treesitter/playground', cmd = 'TSPlaygroundToggle' },

    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        lazy = false,
        dependencies = 'nvim-treesitter/nvim-treesitter-textobjects',

        cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
        keys = {
            { '<c-space>', desc = 'Increment Selection' },
            { '<bs>', desc = 'Decrement Selection', mode = 'x' },
        },

        init = function(plugin)
            -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
            -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
            -- no longer trigger the **nvim-treesitter** module to be loaded in time.
            -- Luckily, the only things that those plugins need are the custom queries, which we make available
            -- during startup.
            require('lazy.core.loader').add_to_rtp(plugin)
            require 'nvim-treesitter.query_predicates'
        end,

        opts = {
            highlight = { enable = true },
            indent = { enable = true },
            ensure_installed = {
                'astro',
                'cmake',
                'css',
                'fish',
                'gitignore',
                'go',
                'http',
                'rust',
                'scss',
                'sql',
                'jsonc',
                'vim',
                'regex',
                'lua',
                'bash',
                'markdown',
                'markdown_inline',
                -- 'cpp', 'graphql', 'java', 'php', 'svelte',
            },

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<C-space>',
                    node_incremental = '<C-space>',
                    scope_incremental = false,
                    node_decremental = '<bs>',
                },
            },
            textobjects = {
                move = {
                    enable = true,
                    goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer' },
                    goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer' },
                    goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer' },
                    goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer' },
                },
            },

            -- https://github.com/nvim-treesitter/playground#query-linter
            query_linter = {
                enable = true,
                use_virtual_text = true,
                lint_events = { 'BufWrite', 'CursorHold' },
            },

            playground = {
                enable = true,
                disable = {},
                updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
                persist_queries = true, -- Whether the query persists across vim sessions
                keybindings = {
                    toggle_query_editor = 'o',
                    toggle_hl_groups = 'i',
                    toggle_injected_languages = 't',
                    toggle_anonymous_nodes = 'a',
                    toggle_language_display = 'I',
                    focus_language = 'f',
                    unfocus_language = 'F',
                    update = 'R',
                    goto_node = '<cr>',
                    show_help = '?',
                },
            },
        },

        ---@param opts TSConfig
        config = function(_, opts)
            if type(opts.ensure_installed) == 'table' then
                ---@type table<string, boolean>
                local added = {}
                opts.ensure_installed = vim.tbl_filter(function(lang) ---@param lang string
                    if added[lang] then return false end
                    added[lang] = true
                    return true
                end, opts.ensure_installed) ---@diagnostic disable-line: param-type-mismatch
            end

            require('nvim-treesitter.configs').setup(opts)

            -- MDX
            vim.filetype.add {
                extension = {
                    mdx = 'mdx',
                },
            }
            vim.treesitter.language.register('markdown', 'mdx')
        end,
    },

    { -- Show context of the current function
        'nvim-treesitter/nvim-treesitter-context',
        lazy = true,
        enabled = true,
        opts = { mode = 'cursor', max_lines = 3 },
        keys = {
            { '<leader>ut', function() require('treesitter-context').toggle() end, desc = 'Toggle Treesitter Context' },
        },
    },
}
