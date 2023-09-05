return {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
        'MunifTanjim/nui.nvim',
        'nvim-lua/plenary.nvim',
    },
    keys = { { '<c-l><c-e>', '<cmd>Neotree toggle<cr>', desc = 'NeoTree' } },

    init = function()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
    end,

    config = function()
        vim.fn.sign_define('DiagnosticSignError', { icon = ' ', texthl = 'DiagnosticSignError' })
        vim.fn.sign_define('DiagnosticSignWarn', { icon = ' ', texthl = 'DiagnosticSignWarn' })
        vim.fn.sign_define('DiagnosticSignInfo', { icon = ' ', texthl = 'DiagnosticSignInfo' })
        vim.fn.sign_define('DiagnosticSignHint', { icon = '󰌵', texthl = 'DiagnosticSignHint' })

        require('neo-tree').setup {
            sort_by = 'case_sensitive',
            view = { width = 30 },
            renderer = { group_empty = true },
            filters = { dotfiles = false },
            filesystem = {
                filtered_items = {
                    visible = false, -- when true, they will just be displayed differently than normal items
                    hide_dotfiles = false,
                    hide_gitignored = false,
                    hide_hidden = true, -- only works on Windows for hidden files/directories
                    hide_by_pattern = { -- uses glob style patterns
                        '**/.eslint*',
                        '**/.prettier*',

                        '**/.editorconfig,next',
                        '**/.gitignore',
                        '**/.vscode',
                        '**/.next',
                        '**/.git',

                        '**/node_modules',
                        '**/obj',
                        '**/bin',
                        '**/public',
                        '**/dist',

                        '**/postcss.*',
                        '**/tsconfig*',
                        '**/package*',
                        '**/vite*',
                        '**/*lock*',

                        '**/index.html',
                    },
                },
            },
        }
    end,
}
