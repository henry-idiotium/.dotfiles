---@diagnostic disable: no-unknown
return {
    -- maneuvering throught files like the flash
    {
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
        dependencies = { 'folke/which-key.nvim', opts = function(_, opts) opts.defaults['<leader>h'] = { name = '+harpoon' } end },
        keys = {
            { ';h', function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end, desc = 'Harpoon list' },
            { '<leader>hp', function() require('harpoon'):list():prepend() end, desc = 'Harpoon prepend' },
            { '<leader>ha', function() require('harpoon'):list():add() end, desc = 'Harpoon add' },
            { '<c-a-]>', function() require('harpoon'):list():next() end, desc = 'Harpoon next' },
            { '<c-a-[>', function() require('harpoon'):list():prev() end, desc = 'Harpoon prev' },

            { '<c-a-h>', function() require('harpoon'):list():select(1) end, desc = 'Harpoon 1st entry' },
            { '<c-a-j>', function() require('harpoon'):list():select(2) end, desc = 'Harpoon 2nd entry' },
            { '<c-a-k>', function() require('harpoon'):list():select(3) end, desc = 'Harpoon 3rd entry' },
            { '<c-a-l>', function() require('harpoon'):list():select(4) end, desc = 'Harpoon 4th entry' },
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
                    vim.keymap.set('n', '<a-v>', function() harpoon.ui:select_menu_item { vsplit = true } end, opts)
                    vim.keymap.set('n', '<a-s>', function() harpoon.ui:select_menu_item { split = true } end, opts)
                    vim.keymap.set('n', '<c-t>', function() harpoon.ui:select_menu_item { tabedit = true } end, opts)
                end,
            }
        end,
    },

    -- fuzzy picker
    {
        'ibhagwan/fzf-lua',
        cmd = 'FzfLua',
        version = false,
        keys = {
            { '\\\\', '<cmd>FzfLua resume <cr>' },
            { ';b', '<cmd>FzfLua buffers <cr>', desc = 'Find Current Buffers' },
            { ';r', '<cmd>FzfLua live_grep <cr>', desc = 'Live Grep' },
            { ';t', '<cmd>FzfLua help_tags <cr>', desc = 'Search Help Tags' },
            { ';o', '<cmd>FzfLua lsp_document_symbols <cr>', desc = 'LSP Doc Symbols' },
            { ';O', '<cmd>FzfLua lsp_workspace_symbols <cr>', desc = 'LSP Workspace Symbols' },
            {
                '<c-e>',
                function()
                    require('fzf-lua').files {
                        winopts = {
                            title = '  ' .. vim.fn.getcwd():gsub(vim.env.HOME, '~') .. '  ',
                            title_pos = 'center',
                        },
                    }
                end,
                desc = 'Find files',
            },
        },

        opts = function()
            local path_format = 'path.filename_first'

            return {
                winopts = {
                    preview = {
                        title = true,
                        wrap = 'nowrap',
                        hidden = 'hidden',
                        title_pos = 'center',
                        vertical = 'down:40%',
                        horizontal = 'right:50%',
                        scrollchars = { '┃', '' },
                    },
                },
                keymap = {
                    builtin = {
                        ['<a-/>'] = 'toggle-help',
                        ['<a-p>'] = 'toggle-preview',
                        ['<c-u>'] = 'preview-up',
                        ['<c-d>'] = 'preview-down',
                        ['<a-z>'] = 'toggle-preview-wrap',
                    },
                },

                fzf_args = vim.env.FZF_DEFAULT_OPTS,

                -- PROVIDERS
                files = {
                    -- cmd = 'fd ' .. vim.env.FD_DEFAULT_OPTS .. ' --type f',
                    cmd = 'rg ' .. vim.env.RG_DEFAULT_OPTS,
                    formatter = path_format,
                    cwd_prompt = false,
                    prompt = ' Files❯ ',
                    winopts = { width = 0.5, preview = { layout = 'vertical' } },
                },
                lsp_finder = {
                    formatter = path_format,
                },
                live_grep = {
                    formatter = path_format,
                },
                grep = {
                    formatter = path_format,
                },
            }
        end,
    },

    -- file explorer
    {
        'nvim-neo-tree/neo-tree.nvim',

        cmd = 'Neotree',
        keys = {
            { ';s', '<cmd>Neotree reveal<cr>', desc = 'Explorer reveal current file (root dir)' },
            {
                'sf',
                function() require('neo-tree.command').execute { toggle = true, dir = vim.fn.getcwd() } end,
                desc = 'Explorer (Root Dir)',
            },
        },

        deactivate = function() vim.cmd [[Neotree close]] end,
        init = function()
            if vim.fn.argc(-1) == 1 then
                local stat = vim.uv.fs_stat(vim.fn.argv(0)) ---@diagnostic disable-line: param-type-mismatch
                if stat and stat.type == 'directory' then require 'neo-tree' end
            end
        end,

        opts = {
            sources = { 'filesystem', 'git_status' },
            source_selector = { winbar = true },
            hide_root_node = true,
            retain_hidden_root_indent = true, -- IF the root node is hidden, keep the indentation anyhow.
            popup_border_style = 'rounded',

            default_component_configs = {
                indent = { indent_size = 2, padding = 0 },
            },

            event_handlers = {
                {
                    event = 'neo_tree_popup_input_ready',
                    handler = function(args)
                        vim.cmd 'stopinsert'
                        vim.keymap.set('i', '<esc>', vim.cmd.stopinsert, { noremap = true, buffer = args.bufnr })
                    end,
                },
            },

            -- neo-tree neo-tree-popup
            use_default_mappings = false,
            window = {
                position = 'right',
                mappings = {
                    ['sf'] = 'close_window',
                    ['q'] = 'close_window',
                    ['<c-q>'] = 'close_window',
                    ['h'] = 'close_node',
                    ['l'] = 'open',
                    ['<cr>'] = 'open',
                    ['<2-leftmouse>'] = 'open',
                    ['<a-t>'] = 'open_tabnew',
                    ['<a-s>'] = 'open_split',
                    ['<a-v>'] = 'open_vsplit',
                    ['?'] = 'show_help',
                    ['<'] = 'prev_source',
                    ['>'] = 'next_source',
                    ['<esc>'] = 'cancel',
                    ['<s-r>'] = 'refresh',
                    ['z<s-c>'] = 'close_all_nodes',
                    ['z<s-o>'] = 'expand_all_nodes',

                    ['<a-n>'] = 'add',
                    ['<a-c>'] = 'copy',
                    ['<a-d>'] = 'delete',
                    ['<a-m>'] = 'move',
                    ['<a-i>'] = 'show_file_details',
                    ['<a-r>'] = 'rename',

                    ['<a-o>c'] = 'order_by_created',
                    ['<a-o>d'] = 'order_by_diagnostics',
                    ['<a-o>g'] = 'order_by_git_status',
                    ['<a-o>m'] = 'order_by_modified',
                    ['<a-o>n'] = 'order_by_name',
                    ['<a-o>s'] = 'order_by_size',
                    ['<a-o>t'] = 'order_by_type',

                    ----
                    -- ['A'] = 'add_directory',
                    -- ['C'] = 'close_node',
                    -- ['D'] = 'fuzzy_finder_directory',
                    -- ['P'] = 'toggle_preview',
                    -- ['S'] = 'open_split',
                    -- ['[g'] = 'prev_git_modified',
                    -- [']g'] = 'next_git_modified',
                    -- ['l'] = 'focus_preview',
                    -- ['e'] = 'toggle_auto_expand_width',
                    -- ['p'] = 'paste_from_clipboard',
                    -- ['x'] = 'cut_to_clipboard',
                    -- ['<c-y>'] = 'Copy Path to Clipboard',
                    -- ['<s-o>'] = 'Open with System Application',
                },
            },

            filesystem = {
                bind_to_cwd = false,
                hijack_netrw_behavior = 'open_current',
                follow_current_file = { enabled = false },
                use_libuv_file_watcher = true,
                window = {
                    mappings = {
                        ['<c-c>'] = 'clear_filter',
                        ['#'] = 'fuzzy_sorter',
                        ['/'] = 'fuzzy_finder',
                        ['<a-f>'] = 'filter_on_submit',
                        ['<a-h>'] = 'toggle_hidden',
                        ['<a-s-h>'] = 'navigate_up',
                    },
                },
            },
        },
    },

    -- git status hunks in linenumber buffer
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = { text = '│' },
                change = { text = '│' },
                delete = { text = '' },
                topdelete = { text = '' },
                changedelete = { text = '│' },
                untracked = { text = '│' },
            },
            on_attach = function(buffer)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc }) end

                map('n', ']h', gs.next_hunk, 'Next Hunk')
                map('n', '[h', gs.prev_hunk, 'Prev Hunk')

                map('n', '<leader>ghu', gs.undo_stage_hunk, 'Undo Stage Hunk')
                map('n', '<leader>ghp', gs.preview_hunk_inline, 'Preview Hunk Inline')
                map('n', '<leader>ghb', gs.toggle_current_line_blame, 'Toggle line blame')

                map({ 'n', 'v' }, '<leader>ghs', '<cmd>Gitsigns stage_hunk<cr>', 'Stage Hunk')
                map('n', '<leader>gh<s-s>', gs.stage_buffer, 'Stage Buffer')
                map({ 'n', 'v' }, '<leader>ghr', '<cmd>Gitsigns reset_hunk<cr>', 'Reset Hunk')
                map('n', '<leader>gh<s-r>', gs.reset_buffer, 'Reset Buffer')
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
                close_folds = 'zC',
                open_folds = 'zO',
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
        cmd = 'TodoTrouble',
        event = 'VeryLazy',
        keys = {
            { ']t', function() require('todo-comments').jump_next() end, desc = 'Next Todo Comment' },
            { '[t', function() require('todo-comments').jump_prev() end, desc = 'Previous Todo Comment' },
            { '<leader>xt', '<cmd>TodoTrouble<cr>', desc = 'Todo (Trouble)' },
            { '<leader>x<s-t>', '<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>', desc = 'Todo/Fix/Fixme (Trouble)' },
        },

        opts = {
            keywords = {
                TODO = { icon = '', color = 'todo' },
                REFAC = { icon = ' ', color = 'todo', alt = { 'REFACTOR', 'REFA' } },
                HACK = { icon = '', color = 'warning' },
                FIX = { icon = '', color = 'error', alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' } },
                WARN = { icon = '', color = 'warning', alt = { 'WARNING', 'XXX' } },
                PERF = { icon = '', color = 'test', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
                NOTE = { icon = '󰙏', color = 'hint', alt = { 'INFO' } },
                TEST = { icon = '', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
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

    -- highlight symbols on cursor
    {
        'RRethy/vim-illuminate',
        event = 'VeryLazy',
        lazy = false,

        keys = {
            { ']]', function() require('illuminate')['goto_next_reference'](false) end, desc = 'Next Reference' },
            { '[[', function() require('illuminate')['goto_prev_reference'](false) end, desc = 'Prev Reference' },
        },

        opts = {
            delay = 200,
            large_file_cutoff = 2000,
            large_file_overrides = { providers = { 'lsp' } },
            filetypes_denylist = { 'dirbuf', 'dirvish', 'fugitive', 'help' },
        },

        config = function(_, opts)
            require('illuminate').configure(opts)

            ---@param dir string
            local function map(key, dir, buffer)
                local action = 'goto_' .. dir .. '_reference'
                vim.keymap.set('n', key, function() require('illuminate')[action](false) end, {
                    desc = 'illuminate ' .. action,
                    buffer = buffer,
                })
            end

            map(']]', 'next')
            map('[[', 'prev')
            -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
            vim.api.nvim_create_autocmd('FileType', {
                callback = function()
                    local buffer = vim.api.nvim_get_current_buf()
                    map(']]', 'next', buffer)
                    map('[[', 'prev', buffer)
                end,
            })
        end,
    },

    -- improved ft
    {
        'backdround/improved-ft.nvim',
        event = 'VeryLazy',
        opts = {
            use_default_mappings = false,
            ignore_char_case = false,
            use_relative_repetition = true,
            use_relative_repetition_offsets = true,
        },
        config = function(_, opts)
            local ft = require 'improved-ft'
            ft.setup(opts)

            local function map(key, action, desc) vim.keymap.set({ 'n', 'x', 'o' }, key, action, { desc = desc, expr = true }) end
            map('f', ft.hop_forward_to_char, 'Hop forward to a given char')
            map('F', ft.hop_backward_to_char, 'Hop backward to a given char')
            map('t', ft.hop_forward_to_pre_char, 'Hop forward before a given char')
            map('T', ft.hop_backward_to_pre_char, 'Hop backward before a given char')
            map('<a-;>', ft.repeat_forward, 'Repeat hop forward to a last given char')
            map('<a-,>', ft.repeat_backward, 'Repeat hop backward to a last given char')
        end,
    },
}
