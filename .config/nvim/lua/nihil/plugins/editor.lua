---@diagnostic disable: no-unknown
return {
    -- maneuvering throught files like the flash
    {
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'folke/which-key.nvim', opts = function(_, opts) opts.defaults['<leader>h'] = { name = '+harpoon' } end },
        },
        keys = {
            { '<c-e>', function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end, desc = 'Harpoon list' },
            { '<leader>hp', function() require('harpoon'):list():prepend() end, desc = 'Harpoon prepend' },
            { '<leader>ha', function() require('harpoon'):list():add() end, desc = 'Harpoon add' },
            { '<a-}>', function() require('harpoon'):list():next() end, desc = 'Harpoon next' },
            { '<a-{>', function() require('harpoon'):list():prev() end, desc = 'Harpoon prev' },

            { '<c-a-u>', function() require('harpoon'):list():select(1) end, desc = 'Harpoon 1st entry' },
            { '<c-a-i>', function() require('harpoon'):list():select(2) end, desc = 'Harpoon 2nd entry' },
            { '<c-a-o>', function() require('harpoon'):list():select(3) end, desc = 'Harpoon 3rd entry' },
            { '<c-a-p>', function() require('harpoon'):list():select(4) end, desc = 'Harpoon 4th entry' },
        },
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
        end,
    },

    -- fuzzy picker
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
            'nvim-telescope/telescope-file-browser.nvim',
        },
        cmd = 'Telescope',
        keys = {
            { '\\\\', '<cmd>Telescope resume<cr>' },
            { ';b', '<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>' },
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
                desc = 'Open Current Buffer File Browser',
            },
        },

        opts = {
            defaults = {
                wrap_results = true,
                layout_strategy = 'horizontal',
                layout_config = { prompt_position = 'top' },
                winblend = 0,

                selection_strategy = 'reset',
                sorting_strategy = 'ascending',

                path_display = { 'tail' },
                dynamic_preview_title = true,
            },
            pickers = {
                find_files = {
                    no_ignore = false,
                    hidden = true,
                    path_display = { 'absolute' },
                    previewer = false,
                    respect_gitignore = false,
                },
                live_grep = { additional_args = { '--hidden' } },
                diagnostics = {
                    theme = 'ivy',
                    initial_mode = 'normal',
                    layout_config = {
                        preview_cutoff = 9999,
                    },
                },
            },
        },

        config = function(_, opts)
            local telescope = require 'telescope'
            local actions = require 'telescope.actions'
            local layout = require 'telescope.actions.layout'

            local mappings = {
                ['<c-q>'] = actions.close,
                ['<c-l>'] = actions.select_default,
                ['<c-a-l>'] = actions.select_tab,
                ['<c-j>'] = actions.move_selection_next,
                ['<c-k>'] = actions.move_selection_previous,
                ['<c-p>'] = layout.toggle_preview,

                ['<c-t>'] = function(...) return require('trouble.providers.telescope').open_with_trouble(...) end,
                ['<a-t>'] = function(...) return require('trouble.providers.telescope').open_selected_with_trouble(...) end,
            }
            opts.defaults.mappings = {
                i = vim.tbl_extend('force', mappings, {}),
                n = vim.tbl_extend('force', mappings, {
                    ['q'] = actions.close,
                    ['l'] = actions.select_default,
                }),
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

    -- git helpers
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

    -- git status hunks in linenumber buffer
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = { text = '▎' },
                change = { text = '▎' },
                delete = { text = '' },
                topdelete = { text = '' },
                changedelete = { text = '▎' },
                untracked = { text = '▎' },
            },
            on_attach = function(buffer)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc }) end

                map('n', ']h', gs.next_hunk, 'Next Hunk')
                map('n', '[h', gs.prev_hunk, 'Prev Hunk')

                map('n', '<leader>ghu', gs.undo_stage_hunk, 'Undo Stage Hunk')
                map('n', '<leader>ghp', gs.preview_hunk_inline, 'Preview Hunk Inline')
                map('n', '<leader>ghb', function() gs.blame_line { full = true } end, 'Blame Line')

                map({ 'n', 'v' }, '<leader>ghs', ':Gitsigns stage_hunk<CR>', 'Stage Hunk')
                map('n', '<leader>gh<s-s>', gs.stage_buffer, 'Stage Buffer')
                map({ 'n', 'v' }, '<leader>ghr', ':Gitsigns reset_hunk<CR>', 'Reset Hunk')
                map('n', '<leader>gh<s-r>', gs.reset_buffer, 'Reset Buffer')

                map('n', '<leader>ghd', gs.diffthis, 'Diff This')
                map('n', '<leader>gh<s-d>', function() gs.diffthis '~' end, 'Diff This ~')

                map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'GitSigns Select Hunk')
            end,
        },
    },

    -- easy location list
    {
        'folke/trouble.nvim',
        cmd = { 'TroubleToggle', 'Trouble' },
        opts = {
            use_diagnostic_signs = true,
            height = 6,
            padding = false,
            action_keys = {
                close = '<c-q>',
                close_folds = 'zC', -- close all folds
                open_folds = 'zO', -- open all folds
            },
        },
        keys = {
            { '<leader>xx', '<cmd>TroubleToggle document_diagnostics<cr>', desc = 'Document Diagnostics (Trouble)' },
            { '<leader>x<s-x>', '<cmd>TroubleToggle workspace_diagnostics<cr>', desc = 'Workspace Diagnostics (Trouble)' },
            { '<leader>x<s-l>', '<cmd>TroubleToggle loclist<cr>', desc = 'Location List (Trouble)' },
            { '<leader>x<s-q>', '<cmd>TroubleToggle quickfix<cr>', desc = 'Quickfix List (Trouble)' },
            {
                '[q',
                function()
                    if require('trouble').is_open() then
                        require('trouble').previous { skip_groups = true, jump = true }
                    else
                        local ok, err = pcall(vim.cmd.cprev)
                        if not ok then vim.notify(err or 'Trouble error', vim.log.levels.ERROR) end
                    end
                end,
                desc = 'Previous Trouble/Quickfix Item',
            },
            {
                ']q',
                function()
                    if require('trouble').is_open() then
                        require('trouble').next { skip_groups = true, jump = true }
                    else
                        local ok, err = pcall(vim.cmd.cnext)
                        if not ok then vim.notify(err or 'Trouble error', vim.log.levels.ERROR) end
                    end
                end,
                desc = 'Next Trouble/Quickfix Item',
            },
        },
    },

    -- highlighted commentes
    {
        'folke/todo-comments.nvim',
        cmd = { 'TodoTrouble', 'TodoTelescope' },
        lazy = false,
        event = 'VeryLazy',
        keys = {
            { ']t', function() require('todo-comments').jump_next() end, desc = 'Next Todo Comment' },
            { '[t', function() require('todo-comments').jump_prev() end, desc = 'Previous Todo Comment' },
            { '<leader>xt', '<cmd>TodoTrouble<cr>', desc = 'Todo (Trouble)' },
            { '<leader>x<s-t>', '<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>', desc = 'Todo/Fix/Fixme (Trouble)' },
            { '<leader>st', '<cmd>TodoTelescope<cr>', desc = 'Todo' },
            { '<leader>s<s-t>', '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>', desc = 'Todo/Fix/Fixme' },
        },

        opts = {
            keywords = {
                TODO = { icon = '✨', color = 'todo' }, -- 
                REFAC = { icon = '👺', color = 'todo', alt = { 'REFACTOR', 'REFA' } },
                HACK = { icon = '🔥', color = 'warning' }, -- 
                FIX = { icon = '👹', color = 'error', alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' } }, -- 
                WARN = { icon = '🙀', color = 'warning', alt = { 'WARNING', 'XXX' } }, -- 
                PERF = { icon = '🚀', color = 'test', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } }, -- 
                NOTE = { icon = '🔖', color = 'hint', alt = { 'INFO' } }, -- 󰙏
                TEST = { icon = '🧪', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } }, -- 
            },
            colors = {
                todo = { 'DiagnosticOk', '#25EBA2' },
                info = { 'DiagnosticInfo', '#2563EB' },
                hint = { 'DiagnosticHint', '#10B981' },
                test = { 'DiagnosticHint', '#C4A7E7' },
                error = { 'DiagnosticError', 'ErrorMsg', '#DC2626' },
                warning = { 'DiagnosticWarn', 'WarningMsg', '#FBBF24' },
                default = { 'Identifier', '#7C3AED' },
            },
        },
    },

    -- zen-ing
    {
        'folke/zen-mode.nvim',
        cmd = 'ZenMode',
        keys = { { '<leader>tz', '<cmd>ZenMode<cr>', desc = 'Toggle Zen Mode' } },
        opts = {
            plugins = {
                gitsigns = true,
                tmux = true,
            },
        },
    },

    -- highlight text
    {
        'echasnovski/mini.hipatterns',
        event = { 'BufReadPre', 'VeryLazy' },
        config = true,
    },
}
