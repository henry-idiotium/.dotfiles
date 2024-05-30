return {
    -- Automatically add closing tags for HTML and JSX
    { 'windwp/nvim-ts-autotag', lazy = true, config = true },

    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        dependencies = 'nvim-treesitter/nvim-treesitter-textobjects',

        ---@type TSConfig
        opts = {
            indent = { enable = true },
            highlight = { enable = true },

            -- Automatically install missing parsers when entering buffer
            -- require `tree-sitter-cli` via cargo or npm
            auto_install = true,

            modules = {},
            sync_install = false,

            ignore_install = {}, -- List of parsers to ignore installing (or "all")
            ensure_installed = {
                'fish',
                'lua',
                'markdown',
                'markdown_inline',
            },

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

        init = function(plugin)
            -- PERF: Add nvim-treesitter queries to the rtp and it's custom query predicates early
            -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
            -- no longer trigger the `nvim-treesitter` module to be loaded in time.
            -- Luckily, the only things that those plugins need are the custom queries, which we make available
            -- during startup.
            require('lazy.core.loader').add_to_rtp(plugin)
            require 'nvim-treesitter.query_predicates'

            vim.filetype.add(Nihil.settings.filetype)
            for ft, ext in pairs(Nihil.settings.filetype.register) do
                vim.treesitter.language.register(ft, ext)
            end
        end,

        config = function(_, opts) require('nvim-treesitter.configs').setup(opts) end,
    },
}
