return {
    { 'nvim-neo-tree/neo-tree.nvim', enabled = false },

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
