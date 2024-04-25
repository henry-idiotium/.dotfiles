return {
    -- Automatically add closing tags for HTML and JSX
    { 'windwp/nvim-ts-autotag', lazy = true, config = true },

    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        lazy = false,
        dependencies = 'nvim-treesitter/nvim-treesitter-textobjects',

        opts = {
            indent = { enable = true },
            highlight = { enable = true },

            -- Automatically install missing parsers when entering buffer
            -- require `tree-sitter-cli` via cargo or npm
            auto_install = true,

            ensure_installed = { 'fish', 'lua', 'markdown', 'markdown_inline' },
            ignore_install = {}, -- List of parsers to ignore installing (or "all")

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<c-space>',
                    node_incremental = '<c-space>',
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
        },

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
}
