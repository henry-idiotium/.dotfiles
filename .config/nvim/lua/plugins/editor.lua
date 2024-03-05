return {
    { 'nvim-neo-tree/neo-tree.nvim', enabled = false },
    { 'folke/flash.nvim', enabled = false },

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
            { '\\\\', '<cmd>Telescope buffers<cr>', desc = 'Lists open buffers' },
            { '<c-l><c-l>', '<cmd>Telescope resume<cr>', desc = 'Open previous telescope action' },
            { '<c-e>', '<cmd>Telescope find_files<cr>', desc = 'Find files in workspace' },
            { '<c-f>', '<cmd>Telescope current_buffer_fuzzy_find<cr>', desc = 'Search words in active document/buffer' },
            { '<c-a-f>', '<cmd>Telescope live_grep<cr>', desc = 'Search words in workspace' },
            { '<c-l><c-s>', '<cmd>Telescope file_browser<cr>', desc = 'Find files in workspace' },
            { '<c-l><c-j>', function() require('telescope').extensions.file_browser.file_browser { path = '%:p:h' } end },
        },
        config = function(_, opts)
            local actions = require 'telescope.actions'
            local layout = require 'telescope.actions.layout'
            local fb_actions = require('telescope').extensions.file_browser.actions

            require('telescope').setup {
                defaults = vim.tbl_deep_extend('force', opts.defaults, {
                    wrap_results = false,
                    layout_strategy = 'horizontal',
                    layout_config = { prompt_position = 'top' },
                    sorting_strategy = 'ascending',
                    winblend = 0,
                    mappings = {
                        n = {
                            ['<c-q>'] = actions.close,
                            ['q'] = actions.close,
                            ['l'] = actions.select_default,
                            ['<c-l>'] = actions.select_tab,
                            ['<c-p>'] = layout.toggle_preview,
                            ['<c-j>'] = actions.move_selection_next,
                            ['<c-k>'] = actions.move_selection_previous,
                            ['<esc>'] = false,
                        },
                        i = {
                            ['<c-l>'] = actions.select_default,
                            ['<c-a-l>'] = actions.select_tab,
                            ['<c-j>'] = actions.move_selection_next,
                            ['<c-k>'] = actions.move_selection_previous,
                            ['<c-p>'] = layout.toggle_preview,
                            ['<c-q>'] = actions.close,
                        },
                    },
                }),
                pickers = {
                    live_grep = { additional_args = { '--hidden' } },
                    diagnostics = { initial_mode = 'normal' },
                    find_files = {
                        theme = 'dropdown',
                        cwd = vim.loop.cwd(),
                        no_ignore = false,
                        hidden = true,
                        path_display = { 'tail' },
                    },
                    current_buffer_fuzzy_find = {
                        theme = 'dropdown',
                        previewer = false,
                        skip_empty_lines = true,
                    },
                },
                extensions = {
                    file_browser = {
                        cwd = vim.fn.expand '%:p:h',
                        theme = 'dropdown',
                        initial_mode = 'normal',
                        hijack_netrw = true, --: Disables netrw and use telescope-file-browser in its place
                        hidden = true,
                        grouped = true,
                        previewer = false,
                        hide_parent_dir = true,
                        use_fd = false,
                        git_status = false,
                        respect_gitignore = false,
                        mappings = {
                            ['n'] = {
                                ['<s-n>'] = fb_actions.create,
                                ['h'] = fb_actions.goto_parent_dir,
                                ['/'] = function() vim.cmd 'startinsert' end,
                                ['dd'] = fb_actions.remove,
                                ['<c-s-h>'] = fb_actions.toggle_hidden,
                            },
                        },
                    },
                },
            }

            require('telescope').load_extension 'fzf'
            require('telescope').load_extension 'file_browser'
        end,
    },
}
