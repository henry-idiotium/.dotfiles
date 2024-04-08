---@diagnostic disable: no-unknown
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

            vim.keymap.set('n', '<leader>hp', function() harpoon:list():prepend() end, { desc = 'Harpoon prepend' })
            vim.keymap.set('n', '<leader>ha', function() harpoon:list():add() end, { desc = 'Harpoon add' })
            vim.keymap.set('n', '<c-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon list' })
            vim.keymap.set('n', '<c-a-]>', function() harpoon:list():next() end, { desc = 'Harpoon next' })
            vim.keymap.set('n', '<c-a-[>', function() harpoon:list():prev() end, { desc = 'Harpoon prev' })

            vim.keymap.set('n', '<c-a-u>', function() harpoon:list():select(1) end, { desc = 'Harpoon 1st entry' })
            vim.keymap.set('n', '<c-a-i>', function() harpoon:list():select(2) end, { desc = 'Harpoon 2nd entry' })
            vim.keymap.set('n', '<c-a-o>', function() harpoon:list():select(3) end, { desc = 'Harpoon 3rd entry' })
            vim.keymap.set('n', '<c-a-p>', function() harpoon:list():select(4) end, { desc = 'Harpoon 4th entry' })
        end,
    },

    {
        'telescope.nvim',
        dependencies = {
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
            'nvim-telescope/telescope-file-browser.nvim',
        },
        keys = {
            { '\\\\', '<cmd>Telescope buffers<cr>' },
            { ';;', '<cmd>Telescope resume<cr>' },
            { ';f', '<cmd>Telescope find_files<cr>' },
            { ';r', '<cmd>Telescope live_grep<cr>' },
            { ';t', '<cmd>Telescope help_tags<cr>' },
            { ';d', '<cmd>Telescope diagnostics<cr>' },
            { ';o', '<cmd>Telescope treesitter<cr>' },
            {
                'sf',
                function()
                    local function telescope_buffer_dir() return vim.fn.expand '%:p:h' end
                    require('telescope').extensions.file_browser.file_browser {
                        cwd = telescope_buffer_dir(),
                    }
                end,
                desc = 'Open File Browser with the path of the current buffer',
            },
        },

        config = function(_, opts)
            local telescope = require 'telescope'
            local actions = require 'telescope.actions'
            local layout = require 'telescope.actions.layout'

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
                find_files = { no_ignore = false, hidden = true },
                live_grep = {
                    additional_args = { '--hidden' },
                },
                diagnostics = {
                    theme = 'ivy',
                    initial_mode = 'normal',
                    layout_config = {
                        preview_cutoff = 9999,
                    },
                },
            }

            local fb_actions = require('telescope').extensions.file_browser.actions
            opts.extensions = {
                file_browser = {
                    theme = 'dropdown',
                    hijack_netrw = true, -- disables netrw and use telescope-file-browser in its place

                    path = '%:p:h',
                    respect_gitignore = false,
                    hidden = true,
                    grouped = true,
                    previewer = false,
                    initial_mode = 'normal',
                    layout_config = { height = 40 },

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
