return {
    -- Automatically add closing tags for HTML and JSX
    { 'windwp/nvim-ts-autotag', lazy = true, config = true },

    { -- display typescript type
        'marilari88/twoslash-queries.nvim',
        ft = { 'typescript', 'typescriptreact' },
        keys = {
            {
                '<leader><leader>t',
                function()
                    Nihil.util.toggle.var 'twoslash_queries_is_enabled'
                    require('twoslash-queries')[vim.g.twoslash_queries_enabled and 'enable' or 'disable']()
                end,
                desc = 'Toggle twoslash-queries',
            },
        },
        init = function() vim.g.twoslash_queries_enabled = true end,
        opts = {
            multi_line = true, -- to print types in multi line mode
            is_enabled = false, -- to keep disabled at startup and enable it on request with the TwoslashQueriesEnable
            highlight = 'Statement', -- to set up a highlight group for the virtual text
        },
    },

    {
        'dmmulroy/ts-error-translator.nvim',
        ft = {
            'typescript',
            'typescriptreact',
            'javascript',
            'javascriptreact',
            'astro',
            'vue',
            'svelte',
        },
        opts = {
            auto_override_publish_diagnostics = true,
        },
    },
}
