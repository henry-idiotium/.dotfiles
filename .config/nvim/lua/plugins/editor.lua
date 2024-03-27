return {
    {
        'nvim-neo-tree/neo-tree.nvim',
        keys = {
            {
                'se',
                function() require('neo-tree.command').execute { toggle = true, dir = vim.uv.cwd() } end,
                desc = 'Tree Explorer',
            },
            {
                'sg',
                function() require('neo-tree.command').execute { source = 'git_status', toggle = true } end,
                desc = 'Git Explorer',
            },
            { '<leader>e', false },
            { '<leader><s-e>', false },
            { '<leader>fe', false },
            { '<leader>f<s-e>', false },
            { '<leader>be', false },
            { '<leader>ge', false },
        },
        opts = function(_, opts)
            opts = vim.tbl_extend('force', opts, {
                popup_border_style = 'rounded',
                enable_git_status = true,
                sort_by = 'case_sensitive',
                view = { width = 30 },
                renderer = { group_empty = true },
                filters = { dotfiles = false },
                use_default_mappings = false,

                default_component_configs = {
                    indent = { indent_size = 3, padding = 1 },
                    file_size = { enabled = false },
                    type = { enabled = true },
                },

                window = {
                    position = 'right',
                    mapping_options = { noremap = true, nowait = true },
                    mappings = {
                        ['?'] = 'show_help',
                        ['<esc>'] = 'cancel',
                        ['q'] = 'close_window',
                        ['<c-q>'] = 'close_window',

                        ['<s-r>'] = { 'refresh', nowait = false },
                        ['n'] = 'add',
                        ['m'] = 'move',
                        ['r'] = 'rename',
                        ['d'] = 'delete',
                        ['h'] = 'close_node',
                        ['o'] = 'open',
                        ['l'] = 'open',
                        ['<c-l>'] = 'open',
                        ['<c-a-o>'] = 'open_tabnew',
                        ['<c-a-l>'] = 'open_tabnew',

                        ['<cr>'] = 'open_drop',

                        ['zc'] = 'close_all_nodes',
                        ['zo'] = 'expand_all_nodes',
                        ['<c-s>'] = 'open_split',
                        ['<c-v>'] = 'open_vsplit',

                        ['i'] = 'show_file_details',

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
                },

                filesystem = {
                    filtered_items = {
                        visible = false, -- when true, they will just be displayed differently than normal items
                        hide_dotfiles = false,
                        hide_gitignored = false,
                        hide_hidden = true,
                        hide_by_pattern = {
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
            })

            return opts
        end,
    },

    {
        'dinhhuy258/git.nvim',
        event = 'BufReadPre',
        opts = {
            keymaps = {
                blame = '<leader>gb', -- Open blame window
                browse = '<leader>go', -- Open file/folder in git repository
            },
        },
    },

    {
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local harpoon = require 'harpoon'

            harpoon:setup {
                settings = {
                    save_on_toggle = true,
                    sync_on_ui_close = true,
                    key = function() return vim.loop.cwd() or '' end,
                },
            }

            harpoon:extend {
                UI_CREATE = function(cx)
                    local opts = { buffer = cx.bufnr }

                    vim.keymap.set({ 'n', 'i' }, '<c-q>', function() harpoon.ui:close_menu() end, opts)
                    vim.keymap.set('n', '<c-l>', function() harpoon.ui:select_menu_item {} end, opts)
                    vim.keymap.set('n', '<c-v>', function() harpoon.ui:select_menu_item { vsplit = true } end, opts)
                    vim.keymap.set('n', '<c-x>', function() harpoon.ui:select_menu_item { split = true } end, opts)
                    vim.keymap.set('n', '<c-t>', function() harpoon.ui:select_menu_item { tabedit = true } end, opts)
                end,
            }

            vim.keymap.set('n', '<leader>hp', function() harpoon:list():prepend() end)
            vim.keymap.set('n', '<leader>ha', function() harpoon:list():append() end)
            vim.keymap.set('n', '<c-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
            vim.keymap.set('n', '<c-a-.>', function() harpoon:list():next() end)
            vim.keymap.set('n', '<c-a-,>', function() harpoon:list():prev() end)

            vim.keymap.set('n', '<c-a-u>', function() harpoon:list():select(1) end)
            vim.keymap.set('n', '<c-a-i>', function() harpoon:list():select(2) end)
            vim.keymap.set('n', '<c-a-o>', function() harpoon:list():select(3) end)
            vim.keymap.set('n', '<c-a-p>', function() harpoon:list():select(4) end)
        end,
    },

    {
        'telescope.nvim',
        dependencies = {
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
            'nvim-telescope/telescope-file-browser.nvim',
        },
        keys = {
            {
                '\\\\',
                function() require('telescope.builtin').buffers() end,
                desc = 'Lists open buffers',
            },
            {
                ';;',
                require('telescope.builtin').resume,
                desc = 'Resume the previous telescope picker',
            },
            {
                ';f',
                function()
                    require('telescope.builtin').find_files {
                        no_ignore = false,
                        hidden = true,
                    }
                end,
                desc = 'Lists files in your current working directory, respects .gitignore',
            },
            {
                ';r',
                function()
                    require('telescope.builtin').live_grep {
                        additional_args = { '--hidden' },
                    }
                end,
                desc = 'Search for a string in your current working directory and get results live as you type, respects .gitignore',
            },
            {
                ';t',
                function() require('telescope.builtin').help_tags() end,
                desc = 'Lists available help tags and opens a new window with the relevant help info on <cr>',
            },
            {
                ';p',
                function() require('telescope.builtin').diagnostics() end,
                desc = 'Lists Diagnostics for all open buffers or a specific buffer',
            },
            {
                ';s',
                function() require('telescope.builtin').treesitter() end,
                desc = 'Lists Function names, variables, from Treesitter',
            },
            {
                'sf',
                function()
                    local function telescope_buffer_dir() return vim.fn.expand '%:p:h' end

                    require('telescope').extensions.file_browser.file_browser {
                        path = '%:p:h',
                        cwd = telescope_buffer_dir(),
                        respect_gitignore = false,
                        hidden = true,
                        grouped = true,
                        previewer = false,
                        initial_mode = 'normal',
                        layout_config = { height = 40 },
                    }
                end,
                desc = 'Open File Browser with the path of the current buffer',
            },
        },

        config = function(_, opts)
            local telescope = require 'telescope'
            local actions = require 'telescope.actions'
            local layout = require 'telescope.actions.layout'
            local fb_actions = require('telescope').extensions.file_browser.actions

            opts.defaults = vim.tbl_deep_extend('force', opts.defaults, {
                wrap_results = true,
                layout_strategy = 'horizontal',
                layout_config = { prompt_position = 'top' },
                winblend = 0,

                selection_strategy = 'reset',
                sorting_strategy = 'ascending',

                path_display = { 'tail' },
                dynamic_preview_title = true,

                mappings = {
                    n = {
                        ['<c-q>'] = actions.close,
                        ['q'] = actions.close,
                        ['l'] = actions.select_default,
                        ['<c-l>'] = actions.select_default,
                        ['<c-a-l>'] = actions.select_tab,
                        ['<c-j>'] = actions.move_selection_next,
                        ['<c-k>'] = actions.move_selection_previous,
                        ['<c-p>'] = layout.toggle_preview,
                        ['<esc>'] = false,
                    },
                    i = {
                        ['<c-q>'] = actions.close,
                        ['<c-l>'] = actions.select_default,
                        ['<c-a-l>'] = actions.select_tab,
                        ['<c-j>'] = actions.move_selection_next,
                        ['<c-k>'] = actions.move_selection_previous,
                        ['<c-p>'] = layout.toggle_preview,
                    },
                },
            })
            opts.pickers = {
                diagnostics = {
                    theme = 'ivy',
                    initial_mode = 'normal',
                    layout_config = {
                        preview_cutoff = 9999,
                    },
                },
            }
            opts.extensions = {
                file_browser = {
                    theme = 'dropdown',
                    hijack_netrw = true, -- disables netrw and use telescope-file-browser in its place
                    mappings = {
                        ['n'] = {
                            ['<s-n>'] = fb_actions.create,
                            ['h'] = fb_actions.goto_parent_dir,
                            ['/'] = function() vim.cmd 'startinsert' end,
                        },
                    },
                },
            }
            telescope.setup(opts)
            require('telescope').load_extension 'fzf'
            require('telescope').load_extension 'file_browser'
        end,
    },
}
