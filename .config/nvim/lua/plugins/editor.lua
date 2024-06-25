---@diagnostic disable: no-unknown, missing-fields, missing-parameter
return {
    { -- Maneuvering throught files like the flash
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
        dependencies = { 'folke/which-key.nvim', opts = function(_, opts) opts.defaults['<leader>h'] = { name = '+harpoon' } end },
        keys = {
            { ';hh', function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end, desc = 'Harpoon list' },
            { ';hp', function() require('harpoon'):list():prepend() end, desc = 'Harpoon prepend' },
            { ';ha', function() require('harpoon'):list():add() end, desc = 'Harpoon add' },
            { '<c-a-]>', function() require('harpoon'):list():next() end, desc = 'Harpoon next' },
            { '<c-a-[>', function() require('harpoon'):list():prev() end, desc = 'Harpoon prev' },

            { '<a-s-u>', function() require('harpoon'):list():select(1) end, desc = 'Harpoon 1st entry' },
            { '<a-s-i>', function() require('harpoon'):list():select(2) end, desc = 'Harpoon 2nd entry' },
            { '<a-s-o>', function() require('harpoon'):list():select(3) end, desc = 'Harpoon 3rd entry' },
            { '<a-s-p>', function() require('harpoon'):list():select(4) end, desc = 'Harpoon 4th entry' },
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

    {
        'folke/flash.nvim',
        event = 'VeryLazy',
        vscode = true,
        ---@type Flash.Config
        opts = {
            modes = {
                char = {
                    jump_labels = true,
                },
            },
            search = {
                multi_window = false,
                wrap = true,
                mode = 'fuzzy',
            },
        },
        keys = function()
            return {
                { 'f', function() require('flash').jump { forward = true, continue = true } end, mode = { 'n', 'x', 'o' }, desc = 'Flash' },
                { 'F', function() require('flash').jump { forward = false, continue = true } end, mode = { 'n', 'x', 'o' }, desc = 'Flash' },
                { '<c-s>', function() require('flash').toggle() end, mode = { 'c' }, desc = 'Toggle Flash Search' },
            }
        end,
    },

    { -- Fuzzy picker
        'ibhagwan/fzf-lua',
        opts = function(_, opts)
            --BUG: 993fce4 make any `accept` binds from FZF_DEFAULT_OPTS unable to work normally.
            --NOTE: TEMPORARY FIX ONLY. Replacing `ctrl-l:accept` is still kinda hard coded.
            opts.fzf_args = vim.env.FZF_DEFAULT_OPTS:gsub('ctrl%-l:accept,', '')

            opts.keymap = {
                fzf = { ['ctrl-l'] = 'accept' },
                builtin = {
                    ['<a-/>'] = 'toggle-help',
                    ['<a-p>'] = 'toggle-preview',
                    ['<c-u>'] = 'preview-up',
                    ['<c-d>'] = 'preview-down',
                    ['<a-z>'] = 'toggle-preview-wrap',
                },
            }

            opts.winopts = { preview = { wrap = 'nowrap', hidden = 'hidden' } }

            -- PROVIDERS
            opts.live_grep = { formatter = 'path.filename_first' }
            opts.grep = { formatter = 'path.filename_first' }

            opts.files = {
                -- cmd = 'fd --type f --no-require-git ' .. vim.env.FD_DEFAULT_OPTS,
                cmd = 'rg --no-require-git --follow --hidden --files --sortr modified',
                formatter = 'path.filename_first',
                cwd_prompt = false,
                winopts = {
                    width = 0.6,
                    preview = { layout = 'vertical' },
                },
                actions = {
                    ['ctrl-g'] = false,
                    ['alt-h'] = { function() return require('fzf-lua.actions').toggle_ignore() end },
                },
            }

            if vim.env.GLOBAL_IGNORE_FILE then opts.files.cmd = opts.files.cmd .. ' --ignore-file ' .. vim.env.GLOBAL_IGNORE_FILE end
        end,
        dependencies = { 'which-key.nvim', opts = function(_, opts) opts.defaults[';x'] = { name = '+extras' } end },
        keys = function()
            local function symbols_filter(entry, ctx)
                if ctx.symbols_filter == nil then ctx.symbols_filter = LazyVim.config.get_kind_filter(ctx.bufnr) or false end
                if ctx.symbols_filter == false then return true end
                return vim.tbl_contains(ctx.symbols_filter, entry.kind)
            end

            return {
                { '\\\\', '<cmd>FzfLua resume <cr>' },
                {
                    '<c-e>',
                    function() require('fzf-lua').files { winopts = { title_pos = 'center', title = vim.g.nihil_pretty_pwd } } end,
                    desc = 'Find files',
                },
                { ';b', '<cmd>FzfLua buffers sort_mru=true sort_lastused=true <cr>', desc = 'Find Buffer' },
                { ';r', LazyVim.pick('live_grep', { root = false }), desc = 'Grep (cwd)' },
                { ';R', LazyVim.pick 'live_grep', desc = 'Grep' },
                { ';w', LazyVim.pick('grep_cword', { root = false }), desc = 'Word (cwd)' },
                { ';W', LazyVim.pick 'grep_cword', desc = 'Word (Root Dir)' },
                { ';w', LazyVim.pick('grep_visual', { root = false }), mode = 'v', desc = 'Selection (cwd)' },
                { ';W', LazyVim.pick 'grep_visual', mode = 'v', desc = 'Selection (Root Dir)' },
                { ';xc', LazyVim.pick 'colorschemes', desc = 'Colorscheme with Preview' },
                { ';xb', '<cmd>FzfLua grep_curbuf <cr>', desc = 'Buffer' },

                { ';:', '<cmd>FzfLua commands <cr>', desc = 'Commands' },
                { ';t', '<cmd>FzfLua help_tags <cr>', desc = 'Search Help Tags' },
                { ';xh', '<cmd>FzfLua highlights <cr>', desc = 'Search Help Tags' },
                { ';xl', '<cmd>FzfLua loclist <cr>', desc = 'Location List' },
                { ';xq', '<cmd>FzfLua quickfix <cr>', desc = 'Location List' },
                { ';xk', '<cmd>FzfLua keymaps <cr>', desc = 'Location List' },

                { ';o', '<cmd>FzfLua lsp_document_symbols <cr>', desc = 'Search Document Symbols' },
                { ';O', '<cmd>FzfLua lsp_workspace_symbols <cr>', desc = 'Search Workspace Symbols' },
                { ';d', '<cmd>FzfLua diagnostics_document<cr>', desc = 'Document Diagnostics' },
                { ';D', '<cmd>FzfLua diagnostics_workspace<cr>', desc = 'Workspace Diagnostics' },
                { ';s', function() require('fzf-lua').lsp_document_symbols { regex_filter = symbols_filter } end, desc = 'Goto Symbol' },
                { ';S', function() require('fzf-lua').lsp_live_workspace_symbols { regex_filter = symbols_filter } end, desc = 'Goto Symbol (Workspace)' },

                { ';g', '<cmd>FzfLua git_files <cr>', desc = 'Find Files (git-files)' },
                { ';e', LazyVim.pick('oldfiles', { cwd = vim.uv.cwd() }), desc = 'Recent (cwd)' },
                { ';E', '<cmd>FzfLua oldfiles <cr>', desc = 'Recent' },
            }
        end,
    },

    { -- File explorer
        'nvim-neo-tree/neo-tree.nvim',

        keys = function()
            return {
                { 'ss', '<cmd>execute "Neotree reveal " . g:nihil_neotree_position <cr>', desc = 'File Explorer Reveal Current File' },
                { ';f', '<cmd>execute "Neotree filesystem " . g:nihil_neotree_position <cr>', desc = 'File Explorer Reveal Current File' },
                { 'sf', '<cmd>execute "Neotree toggle " . g:nihil_neotree_position <cr>', desc = 'File Explorer' },
                { 'sF', '<cmd>Neotree current <cr>', desc = 'File Explorer (Full)' },
                {
                    '<leader><leader>n',
                    function() require('utils.toggle').var('nihil_neotree_position', { 'right', 'float' }) end,
                    desc = 'Change File Explorer Position',
                },
            }
        end,

        opts = {
            sources = { 'filesystem', 'git_status' },
            source_selector = { winbar = true },
            hide_root_node = true,
            show_path = 'relative',
            retain_hidden_root_indent = true, -- IF the root node is hidden, keep the indentation anyhow.
            popup_border_style = 'rounded',

            default_component_configs = {
                git_status = { symbols = { unstaged = '󰄱', staged = '󰱒' } },
                indent = {
                    with_expanders = false,
                    with_markers = true,
                    indent_size = 2,
                    padding = 0,
                },
            },

            commands = {
                open_with_file_explorer = function(state) pcall(vim.ui.open, state.tree:get_node().path) end,

                -- https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/370#discussioncomment-4144005
                path_copy_selector = function(state)
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

                    local options = vim.tbl_filter(function(val) return not options_map[val] or options_map[val] ~= '' end, vim.tbl_keys(options_map))
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

                open_without_losing_focus = function(state)
                    local node = state.tree:get_node()
                    if require('neo-tree.utils').is_expandable(node) then
                        state.commands['toggle_node'](state)
                    else
                        state.commands['open'](state)
                        vim.cmd 'Neotree reveal'
                    end
                end,

                better_open = function(state)
                    local node = state.tree:get_node()
                    if node.type == 'directory' then
                        if not node:is_expanded() then
                            require('neo-tree.sources.filesystem').toggle_directory(state, node)
                        elseif node:has_children() then
                            require('neo-tree.ui.renderer').focus_node(state, node:get_child_ids()[1])
                        end
                    else
                        state.commands['open'](state)
                    end
                end,
            },

            -- neo-tree neo-tree-popup
            use_default_mappings = false,
            window = {
                mappings = {
                    ['?'] = 'show_help',
                    ['sf'] = 'close_window',
                    ['q'] = 'close_window',
                    ['<c-q>'] = 'close_window',
                    ['<esc>'] = 'cancel',
                    ['R'] = 'refresh',
                    ['<'] = 'prev_source',
                    ['>'] = 'next_source',

                    ['h'] = 'close_node',
                    ['l'] = 'better_open',
                    ['o'] = 'open_without_losing_focus',
                    ['<cr>'] = 'open',
                    ['t'] = 'open_tabnew',
                    ['<a-s>'] = 'open_split',
                    ['<a-v>'] = 'open_vsplit',
                    ['z<s-c>'] = 'close_all_nodes',
                    ['z<s-o>'] = 'expand_all_nodes',

                    ['<a-i>'] = 'show_file_details',
                    ['<a-y>'] = 'path_copy_selector',
                    ['<c-a-o>'] = 'open_with_file_explorer',

                    ['<a-o>c'] = 'order_by_created',
                    ['<a-o>d'] = 'order_by_diagnostics',
                    ['<a-o>g'] = 'order_by_git_status',
                    ['<a-o>m'] = 'order_by_modified',
                    ['<a-o>n'] = 'order_by_name',
                    ['<a-o>s'] = 'order_by_size',
                    ['<a-o>t'] = 'order_by_type',
                },
            },

            filesystem = {
                bind_to_cwd = true,
                hijack_netrw_behavior = 'open_current',
                follow_current_file = { enabled = false },
                use_libuv_file_watcher = true,
                window = {
                    mappings = {
                        -- none, relative, absolute
                        ['<a-n>'] = { 'add', nowait = true, config = { show_path = 'relative' } },
                        ['<a-c>'] = { 'copy', nowait = true, config = { show_path = 'relative' } },
                        ['<a-m>'] = { 'move', nowait = true, config = { show_path = 'relative' } },
                        ['<a-d>'] = 'delete',
                        ['<a-r>'] = 'rename',

                        ['<a-p>'] = 'paste_from_clipboard',
                        ['<a-x>'] = 'cut_to_clipboard',

                        ['<a-f>'] = 'filter_on_submit',
                        ['<a-h>'] = 'toggle_hidden',

                        ['H'] = 'navigate_up',
                        ['.'] = 'set_root',

                        -- ['/'] = 'fuzzy_finder',
                        -- ['#'] = 'fuzzy_sorter',
                        -- ['<c-c>'] = 'clear_filter',
                        -- ['A'] = 'add_directory',
                        -- ['D'] = 'fuzzy_finder_directory',
                    },
                },
            },
        },
    },

    { -- Git status in line number
        'gitsigns.nvim',
        opts = function(_, opts)
            opts.signs = {
                add = { text = '│' },
                change = { text = '│' },
                delete = { text = '' },
                topdelete = { text = '' },
                changedelete = { text = '│' },
                untracked = { text = '│' },
            }

            opts.on_attach = function(buffer)
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
            end
        end,
    },

    { -- Easy location list
        'folke/trouble.nvim',

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
            { '<leader>xx', '<cmd>Trouble diagnostics toggle <cr>', desc = 'Diagnostics (Trouble)' },
            { '<leader>xl', '<cmd>Trouble loclist toggle <cr>', desc = 'Location List (Trouble)' },
            { '<leader>xq', '<cmd>Trouble quickfix toggle <cr>', desc = 'Quickfix List (Trouble)' },
            { '<leader>cs', '<cmd>Trouble symbols toggle focus=false <cr>', desc = 'Symbols (Trouble)' },
            {
                '[q',
                function()
                    if require('trouble').is_open() then
                        require('trouble').prev { skip_groups = true, jump = true }
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

    -- { -- Highlight symbols on cursor
    --     'RRethy/vim-illuminate',
    --
    --     keys = {
    --         { ']]', function() require('illuminate')['goto_next_reference'](false) end, desc = 'Next Reference' },
    --         { '[[', function() require('illuminate')['goto_prev_reference'](false) end, desc = 'Prev Reference' },
    --     },
    --
    --     opts = {
    --         delay = 200,
    --         large_file_cutoff = 2000,
    --         large_file_overrides = { providers = { 'lsp' } },
    --         filetypes_denylist = { 'dirbuf', 'dirvish', 'fugitive', 'help' },
    --     },
    --
    --     config = function(_, opts)
    --         require('illuminate').configure(opts)
    --
    --         local function map(key, dir, buffer)
    --             vim.keymap.set('n', key, function() require('illuminate')['goto_next_reference'](false) end, {
    --                 desc = 'Illuminate ' .. dir .. ' Reference',
    --                 buffer = buffer,
    --             })
    --         end
    --
    --         -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
    --         vim.api.nvim_create_autocmd('FileType', {
    --             callback = function()
    --                 local buffer = vim.api.nvim_get_current_buf()
    --                 map(']]', 'next', buffer)
    --                 map('[[', 'prev', buffer)
    --             end,
    --         })
    --     end,
    -- },

    { -- VSCode like folding
        'kevinhwang91/nvim-ufo',
        dependencies = 'kevinhwang91/promise-async',
        event = 'BufReadPost',
        opts = { open_fold_hl_timeout = 0 },
    },
}
