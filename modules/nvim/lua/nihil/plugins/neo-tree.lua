return {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
        'MunifTanjim/nui.nvim',
        'nvim-lua/plenary.nvim',
    },
    keys = { { '<c-p><c-s>', '<cmd>Neotree toggle<cr>', desc = 'NeoTree' } },

    init = function()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
    end,

    opts = {
        popup_border_style = 'rounded',
        enable_git_status = true,
        enable_diagnostics = true,
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

        window = {
            position = 'right',
            width = 40,
            mapping_options = { noremap = true, nowait = true },
            mappings = {
                ['<s-o>'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = '<c-o>' } },
                ['<s-o>c'] = { 'order_by_created', nowait = false },
                ['<s-o>d'] = { 'order_by_diagnostics', nowait = false },
                ['<s-o>g'] = { 'order_by_git_status', nowait = false },
                ['<s-o>m'] = { 'order_by_modified', nowait = false },
                ['<s-o>n'] = { 'order_by_name', nowait = false },
                ['<s-o>s'] = { 'order_by_size', nowait = false },
                ['<s-o>t'] = { 'order_by_type', nowait = false },
                ['<c-p><c-e>'] = 'toggle_hidden',
                ['o'] = 'open',
                ['<c-o>'] = 'open_tabnew',

                -- unmap
                ['<2-leftmouse>'] = 'none',
                ['<s-h>'] = 'none',
                ['w'] = 'none',
                ['oc'] = 'none',
                ['od'] = 'none',
                ['og'] = 'none',
                ['om'] = 'none',
                ['on'] = 'none',
                ['os'] = 'none',
                ['ot'] = 'none',
            },
        },
    },
}
