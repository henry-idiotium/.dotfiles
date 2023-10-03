return {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        'MunifTanjim/nui.nvim',
    },
    keys = {
        { '<c-p><c-s>', '<cmd>Neotree toggle<cr>', desc = 'NeoTree toggle' },
        { '<c-p><c-o>', '<cmd>Neotree reveal<cr>', desc = 'NeoTree reveal' },
    },

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
        use_default_mappings = false,

        window = {
            position = 'right', -- float, left, right
            width = 40,
            mapping_options = { noremap = true, nowait = true },
            mappings = {
                ['<bs>'] = { 'navigate_up', nowait = false },
                ['.'] = { 'set_root', nowait = false },
                ['?'] = 'show_help',
                ['/'] = 'fuzzy_finder',
                ['<esc>'] = 'cancel',
                ['q'] = 'cancel',
                ['<c-q>'] = 'close_window',

                ['<s-r>'] = { 'refresh', nowait = false },
                ['n'] = 'add',
                ['m'] = 'move',
                ['r'] = 'rename',
                ['d'] = 'delete',
                ['o'] = 'open',
                ['l'] = 'open',
                ['h'] = 'close_node',
                ['<c-o>'] = 'open_tabnew',
                ['<c-l>'] = 'open_tabnew',

                ['<cr>'] = 'open_drop',

                ['z'] = 'close_all_nodes',
                ['<s-z>'] = 'expand_all_nodes',
                ['<s-s>'] = 'open_split',
                ['s'] = 'open_vsplit',

                ['<'] = 'prev_source',
                ['>'] = 'next_source',
                ['i'] = 'show_file_details',

                ['p'] = 'focus_preview',
                ['P'] = 'toggle_preview',
                ['<s-h>'] = 'toggle_hidden',

                ['<s-o>'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = '<c-o>' } },
                ['<s-o>c'] = { 'order_by_created', nowait = false },
                ['<s-o>d'] = { 'order_by_diagnostics', nowait = false },
                ['<s-o>g'] = { 'order_by_git_status', nowait = false },
                ['<s-o>m'] = { 'order_by_modified', nowait = false },
                ['<s-o>n'] = { 'order_by_name', nowait = false },
                ['<s-o>s'] = { 'order_by_size', nowait = false },
                ['<s-o>t'] = { 'order_by_type', nowait = false },
            },

            fuzzy_finder_mappings = {
                -- ['<c-o>'] = 'open',
                -- ['<c-l>'] = 'open',
                ['<down>'] = 'move_cursor_down',
                ['<up>'] = 'move_cursor_up',
                ['<c-j>'] = 'move_cursor_down',
                ['<c-k>'] = 'move_cursor_up',
            },
        },

        buffers = {
            follow_current_file = { enabled = true, leave_dirs_open = false },
            group_empty_dirs = false,
            show_unloaded = true,
            window = {
                mappings = {
                    ['bd'] = 'buffer_delete',
                    ['<bs>'] = 'navigate_up',
                    ['.'] = 'set_root',
                    ['<s-h>'] = 'toggle_hidden',
                    ['<c-q>'] = 'clear_filter',
                    -- ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
                    -- ['oc'] = { 'order_by_created', nowait = false },
                    -- ['od'] = { 'order_by_diagnostics', nowait = false },
                    -- ['om'] = { 'order_by_modified', nowait = false },
                    -- ['on'] = { 'order_by_name', nowait = false },
                    -- ['os'] = { 'order_by_size', nowait = false },
                    -- ['ot'] = { 'order_by_type', nowait = false },
                },
            },
        },
        git_status = {
            window = {
                position = 'float',
                mappings = {
                    ['<s-a>'] = 'git_add_all',
                    ['gu'] = 'git_unstage_file',
                    ['ga'] = 'git_add_file',
                    ['gr'] = 'git_revert_file',
                    ['gc'] = 'git_commit',
                    ['gp'] = 'git_push',
                    ['gg'] = 'git_commit_and_push',
                    ['<s-h>'] = 'toggle_hidden',
                    -- ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
                    -- ['oc'] = { 'order_by_created', nowait = false },
                    -- ['od'] = { 'order_by_diagnostics', nowait = false },
                    -- ['om'] = { 'order_by_modified', nowait = false },
                    -- ['on'] = { 'order_by_name', nowait = false },
                    -- ['os'] = { 'order_by_size', nowait = false },
                    -- ['ot'] = { 'order_by_type', nowait = false },
                },
            },
        },

        filesystem = {
            filtered_items = {
                visible = false, -- when true, they will just be displayed differently than normal items
                hide_dotfiles = false,
                hide_gitignored = false,
                hide_hidden = true, -- only works on Windows for hidden files/directories
                hide_by_pattern = { -- uses glob style patterns
                    '**/.eslint*',
                    '**/.prettier*',

                    '**/.editorconfig',
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

        default_component_configs = {
            indent = {
                indent_size = 3,
                padding = 1, -- extra padding on left hand side
            },
            file_size = { enabled = false },
            type = { enabled = true },
        },
    },
}
