---@diagnostic disable: no-unknown
return {
    { -- Maneuvering throught files like the flash
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
        dependencies = { 'folke/which-key.nvim', opts = function(_, opts) opts.defaults['<leader>h'] = { name = '+harpoon' } end },
        keys = {
            { ';h', function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end, desc = 'Harpoon list' },
            { '<leader>hp', function() require('harpoon'):list():prepend() end, desc = 'Harpoon prepend' },
            { '<leader>ha', function() require('harpoon'):list():add() end, desc = 'Harpoon add' },
            { '<c-a-]>', function() require('harpoon'):list():next() end, desc = 'Harpoon next' },
            { '<c-a-[>', function() require('harpoon'):list():prev() end, desc = 'Harpoon prev' },

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
                    vim.keymap.set('n', 'v', function() harpoon.ui:select_menu_item { vsplit = true } end, opts)
                    vim.keymap.set('n', 's', function() harpoon.ui:select_menu_item { split = true } end, opts)
                    vim.keymap.set('n', 't', function() harpoon.ui:select_menu_item { tabedit = true } end, opts)
                end,
            }
        end,
    },

    { -- Fuzzy picker
        'ibhagwan/fzf-lua',
        cmd = 'FzfLua',
        version = false,
        keys = {
            { '\\\\', '<cmd>FzfLua resume <cr>' },
            { ';b', '<cmd>FzfLua buffers <cr>', desc = 'Find Current Buffers' },
            { ';r', '<cmd>FzfLua live_grep <cr>', desc = 'Grep' },
            { ';c', '<cmd>FzfLua colorschemes <cr>', desc = 'Colorschemes' },
            { ';R', '<cmd>FzfLua grep_cWORD <cr>', desc = 'Grep word' },
            { ';r', '<cmd>FzfLua grep_visual <cr>', desc = 'Grep', mode = 'v' },
            { ';t', '<cmd>FzfLua help_tags <cr>', desc = 'Search Help Tags' },
            { ';o', '<cmd>FzfLua lsp_document_symbols <cr>', desc = 'Document Symbols' },
            { ';O', '<cmd>FzfLua lsp_workspace_symbols <cr>', desc = 'Workspace Symbols' },
            {
                '<c-e>',
                function()
                    require('fzf-lua').files {
                        winopts = {
                            title = string.format('  %s  ', vim.fn.getcwd():gsub(vim.env.HOME, '~')),
                            title_pos = 'center',
                        },
                    }
                end,
                desc = 'Find files',
            },
        },

        opts = {
            width = 0.8,
            height = 0.8,
            sort_lastused = true,

            winopts = {
                preview = {
                    wrap = 'nowrap',
                    hidden = 'hidden',
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
            lsp_finder = {},
            live_grep = {},
            grep = {},
            files = {
                -- cmd = 'fd --type f --no-require-git ' .. vim.env.FD_DEFAULT_OPTS,
                cmd = 'rg --no-require-git ' .. vim.env.RG_DEFAULT_OPTS,
                cwd_prompt = false,
                prompt = ' Files❯ ',
                actions = {
                    ['ctrl-g'] = false,
                },
                winopts = {
                    width = 0.6,
                    preview = { layout = 'vertical' },
                },
            },
        },

        config = function(_, opts)
            local actions = require 'fzf-lua.actions'
            local path_format = 'path.filename_first'

            opts.lsp_finder.formatter = path_format
            opts.live_grep.formatter = path_format
            opts.grep.formatter = path_format

            opts.files.formatter = path_format
            opts.files.actions['alt-h'] = { actions.toggle_ignore }

            require('fzf-lua').setup(opts)
        end,
    },

    { -- File explorer
        'nvim-neo-tree/neo-tree.nvim',

        cmd = 'Neotree',
        keys = {
            { ';s', '<cmd>Neotree reveal<cr>', desc = 'File Explorer Reveal Current File' },
            { 'sf', '<cmd>Neotree toggle right<cr>', desc = 'File Explorer' },
            { 'sF', '<cmd>Neotree float<cr>', desc = 'File Explorer (Popup)' },
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
            show_path = 'relative',
            retain_hidden_root_indent = true, -- IF the root node is hidden, keep the indentation anyhow.
            popup_border_style = 'rounded',

            default_component_configs = {
                indent = {
                    with_markers = false,
                    indent_size = 2,
                    padding = 0,
                },
            },

            -- neo-tree neo-tree-popup
            use_default_mappings = false,
            window = {
                width = 30,
                position = 'right',
                mappings = {
                    ['sf'] = 'close_window',
                    ['q'] = 'close_window',
                    ['<c-q>'] = 'close_window',
                    ['h'] = 'close_node',
                    ['l'] = 'open',
                    ['<cr>'] = 'open',
                    ['t'] = 'open_tabnew',
                    ['<a-s>'] = 'open_split',
                    ['<a-v>'] = 'open_vsplit',
                    ['?'] = 'show_help',
                    ['<'] = 'prev_source',
                    ['>'] = 'next_source',
                    ['<esc>'] = 'cancel',
                    ['<s-r>'] = 'refresh',
                    ['z<s-c>'] = 'close_all_nodes',
                    ['z<s-o>'] = 'expand_all_nodes',

                    -- none, relative, absolute
                    ['<a-n>'] = { 'add', nowait = true, config = { show_path = 'relative' } },
                    ['<a-c>'] = { 'copy', nowait = true, config = { show_path = 'relative' } },
                    ['<a-m>'] = { 'move', nowait = true, config = { show_path = 'relative' } },
                    ['<a-d>'] = 'delete',
                    ['<a-i>'] = 'show_file_details',
                    ['<a-r>'] = 'rename',

                    ['<a-s-o>'] = {
                        function(state) vim.ui.open(state.tree:get_node().path) end,
                        desc = 'Open w/ system explorer',
                    },

                    -- https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/370#discussioncomment-4144005
                    ['<a-y>'] = {
                        function(state)
                            local node = state.tree:get_node()
                            local filepath = node:get_id()
                            local filename = node.name
                            local modify = vim.fn.fnamemodify

                            local options_map = {
                                ['Extension of the filename'] = modify(filename, ':e'),
                                ['File path URI'] = vim.uri_from_fname(filepath),
                                ['Absolute path'] = filepath,
                                ['Path relative to HOME'] = modify(filepath, ':~'),
                                ['Filename without extention'] = modify(filename, ':r'),
                                ['Filename'] = filename,
                                ['Path relative to CWD'] = modify(filepath, ':.'),
                            }

                            local options = vim.tbl_filter(
                                function(val) return not options_map[val] or options_map[val] ~= '' end,
                                vim.tbl_keys(options_map)
                            )
                            if vim.tbl_isempty(options) then
                                vim.notify('No values to copy', vim.log.levels.WARN)
                                return
                            end

                            vim.ui.select(options, {
                                prompt = 'Choose to copy to clipboard:',
                                format_item = function(item) return ('%s  (%s)'):format(item, options_map[item]) end,
                            }, function(choice)
                                local result = options_map[choice]
                                if result then vim.fn.setreg('+', result) end
                            end)
                        end,
                        desc = 'Path Copy Selctor (System Clipboard)',
                    },

                    ['<a-o>c'] = 'order_by_created',
                    ['<a-o>d'] = 'order_by_diagnostics',
                    ['<a-o>g'] = 'order_by_git_status',
                    ['<a-o>m'] = 'order_by_modified',
                    ['<a-o>n'] = 'order_by_name',
                    ['<a-o>s'] = 'order_by_size',
                    ['<a-o>t'] = 'order_by_type',

                    ----
                    -- ['A'] = 'add_directory',
                    -- ['D'] = 'fuzzy_finder_directory',
                    -- ['P'] = 'toggle_preview',
                    -- ['S'] = 'open_split',
                    -- ['[g'] = 'prev_git_modified',
                    -- [']g'] = 'next_git_modified',
                    -- ['l'] = 'focus_preview',
                    -- ['e'] = 'toggle_auto_expand_width',
                    -- ['p'] = 'paste_from_clipboard',
                    -- ['x'] = 'cut_to_clipboard',
                },
            },

            filesystem = {
                bind_to_cwd = true,
                hijack_netrw_behavior = 'open_current',
                follow_current_file = { enabled = false },
                use_libuv_file_watcher = true,
                window = {
                    mappings = {
                        ['<c-c>'] = 'clear_filter',
                        ['#'] = 'fuzzy_sorter',
                        ['/'] = 'fuzzy_finder',
                        ['<a-f>'] = 'filter_on_submit',
                        ['<c-h>'] = 'toggle_hidden',
                        -- ['H'] = 'navigate_up',
                        -- ['.'] = 'set_root',
                    },
                },
            },
        },
    },

    { -- Git status in line number
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

    { -- Easy location list
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

    { -- Highlight symbols on cursor
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

    {
        'kevinhwang91/nvim-ufo',
        dependencies = 'kevinhwang91/promise-async',
        event = 'VeryLazy',
        opts = { open_fold_hl_timeout = 0 },
    },
}
