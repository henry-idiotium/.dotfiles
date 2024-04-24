---@diagnostic disable: duplicate-set-field, no-unknown, undefined-field, need-check-nil
return {
    -- highlight symbols on cursor
    {
        'RRethy/vim-illuminate',
        lazy = false,
        event = 'VeryLazy',

        keys = {
            { ']]', desc = 'Next Reference' },
            { '[[', desc = 'Prev Reference' },
        },

        opts = {
            delay = 200,
            large_file_cutoff = 2000,
            large_file_overrides = { providers = { 'lsp' } },
            filetypes_denylist = {
                'dirbuf',
                'dirvish',
                'fugitive',
                'help',
                'TelescopePrompt',
                'TelescopeResult',
            },
        },

        config = function(_, opts)
            require('illuminate').configure(opts)

            local function map(key, dir, buffer)
                vim.keymap.set(
                    'n',
                    key,
                    function() require('illuminate')['goto_' .. dir .. '_reference'](false) end,
                    { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. ' Reference', buffer = buffer }
                )
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

    -- Better `vim.notify`
    {
        'rcarriga/nvim-notify',
        lazy = false,
        event = 'VeryLazy',
        keys = {
            {
                '<leader>un',
                function() require('notify').dismiss { silent = true, pending = true } end,
                desc = 'Dismiss All Notifications',
            },
        },
        opts = {
            render = 'wrapped-compact',
            stages = 'static',
            timeout = 5000,
            max_height = function() return math.floor(vim.o.lines * 0.75) end,
            max_width = function() return math.floor(vim.o.columns * 0.75) end,
            on_open = function(win) vim.api.nvim_win_set_config(win, { zindex = 100 }) end,
        },
    },

    -- Better vim.ui
    {
        'stevearc/dressing.nvim',
        lazy = true,
        event = 'VeryLazy',
        init = function()
            vim.ui.select = function(...)
                require('lazy').load { plugins = { 'dressing.nvim' } }
                return vim.ui.select(...)
            end

            vim.ui.input = function(...)
                require('lazy').load { plugins = { 'dressing.nvim' } }
                return vim.ui.input(...)
            end
        end,

        opts = function()
            local mappings = {
                ['<esc>'] = 'Close',
                ['<c-q>'] = 'Close',
                ['<c-c>'] = 'Close',
                ['<cr>'] = 'Confirm',
                ['<c-o>'] = 'Confirm',
                ['<c-h>'] = 'HistoryPrev',
                ['<c-l>'] = 'HistoryNext',
                ['<up>'] = 'HistoryPrev',
                ['<down>'] = 'HistoryNext',
            }

            return {
                input = {
                    mappings = {
                        n = mappings,
                        i = mappings,
                    },
                },
            }
        end,
    },

    -- Highly experimental plugin that completely replaces the UI for
    -- messages, cmdline and the popupmenu.
    {
        'folke/noice.nvim',
        lazy = false,
        event = 'VeryLazy',
        dependencies = {
            'MunifTanjim/nui.nvim',
            -- Displays a popup with possible key bindings of the command you started typing
            { 'folke/which-key.nvim', opts = function(_, opts) opts.defaults['<leader>sn'] = { name = '+noice' } end },
        },
        keys = {
            { '<s-enter>', function() require('noice').redirect(vim.fn.getcmdline()) end, mode = 'c', desc = 'Redirect Cmdline' },
            { '<leader>snl', function() require('noice').cmd 'last' end, desc = 'Noice Last Message' },
            { '<leader>snh', function() require('noice').cmd 'history' end, desc = 'Noice History' },
            { '<leader>sna', function() require('noice').cmd 'all' end, desc = 'Noice All' },
            { '<leader>snd', function() require('noice').cmd 'dismiss' end, desc = 'Dismiss All' },
        },

        opts = {
            lsp = {
                override = {
                    ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                    ['vim.lsp.util.stylize_markdown'] = true,
                    ['cmp.entry.get_documentation'] = true,
                },
                signature = {
                    enabled = true,
                    auto_open = { enabled = false },
                },
            },

            routes = {
                {
                    view = 'mini',
                    filter = {
                        event = 'msg_show',
                        any = {
                            { find = '%d+L, %d+B' },
                            { find = '; after #%d+' },
                            { find = '; before #%d+' },
                        },
                    },
                },
                {
                    filter = { event = 'notify', find = 'No information available' },
                    opts = { skip = true },
                },
            },

            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = true,
                lsp_doc_border = true,
            },

            commands = {
                all = {
                    -- options for the message history that you get with `:Noice`
                    view = 'split',
                    opts = { enter = true, format = 'details' },
                    filter = {},
                },
            },
        },
        config = function(_, opts)
            local focused = true
            vim.api.nvim_create_autocmd('FocusGained', {
                callback = function() focused = true end,
            })
            vim.api.nvim_create_autocmd('FocusLost', {
                callback = function() focused = false end,
            })
            table.insert(opts.routes, 1, {
                filter = { cond = function() return not focused end },
                view = 'notify_send',
                opts = { stop = false },
            })

            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'markdown',
                callback = function(event)
                    vim.schedule(function() require('noice.text.markdown').keys(event.buf) end)
                end,
            })

            require('noice').setup(opts)
        end,
    },

    -- Statusline
    {
        'nvim-lualine/lualine.nvim',
        init = function()
            vim.g.lualine_laststatus = vim.o.laststatus
            if vim.fn.argc(-1) > 0 then
                vim.o.statusline = ' ' -- set an empty statusline till lualine loads
            else
                vim.o.laststatus = 0 -- hide the statusline on the starter page
            end
        end,

        opts = {
            options = {
                globalstatus = true,
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
            },
            extensions = { 'neo-tree', 'lazy' },
        },

        config = function(_, opts)
            local icons = require('nihil.plugins.lsp.config').lspconfig.diagnostics.signs.text

            opts.sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch' },

                lualine_c = {
                    {
                        'root-dir',
                        fmt = function() return vim.fn.fnamemodify(vim.fn.getcwd(), ':t') end,
                        color = { fg = '#FFAA88', gui = 'bold' },
                        icon = '󱉭',
                    },
                    { 'filename', path = 1, symbols = { modified = '●', readonly = '' }, separator = '' },
                    { 'diff' },
                },

                lualine_x = {
                    {
                        'macro-recording',
                        fmt = function() return 'recording @' .. vim.fn.reg_recording() end,
                        cond = function() return vim.fn.reg_recording() ~= '' end,
                        color = { fg = '#FFAA88' },
                    },
                    {
                        'noice-status-command',
                        fmt = function() return require('noice').api.status.command.get() end,
                        cond = function() return package.loaded['noice'] and require('noice').api.status.command.has() end,
                        color = { fg = '#FFAA88' },
                    },
                    {
                        'dap',
                        fmt = function() return '  ' .. require('dap').status() end,
                        cond = function() return package.loaded['dap'] and require('dap').status() ~= '' end,
                    },
                    {
                        'word-char-count',
                        function()
                            local wc = vim.fn.wordcount()
                            return wc['words'] .. ' words ' .. wc['chars'] .. ' chars'
                        end,
                        cond = function()
                            local count_ft = { 'markdown', 'vimwiki', 'latex', 'text', 'tex' }
                            return vim.tbl_contains(count_ft, vim.bo.ft)
                        end,
                        color = { fg = '#6e6e80', gui = 'italic' },
                    },
                },
                lualine_y = {
                    {
                        'encoding',
                        cond = function() return (vim.bo.fenc or vim.go.enc) ~= 'utf-8' end,
                    },
                    {
                        'fileformat',
                        symbols = { unix = 'LF', dos = 'CRLF', mac = 'CR' },
                        cond = function() return vim.bo.ff ~= 'unix' end,
                    },
                },
                lualine_z = {
                    { 'progress', separator = '' },
                    { 'location' },
                },
            }

            -- PERF: we don't need this lualine require madness 🤷
            require('lualine_require').require = require

            vim.o.laststatus = vim.g.lualine_laststatus

            local lualine = require 'lualine'
            lualine.setup(opts)

            -- recording cmp: init refresh to avoid delay
            local refresh_statusline = function() lualine.refresh { place = { 'statusline' } } end
            vim.api.nvim_create_autocmd('RecordingEnter', { callback = refresh_statusline })
            vim.api.nvim_create_autocmd(
                'RecordingLeave',
                { callback = function() vim.loop.new_timer():start(50, 0, vim.schedule_wrap(refresh_statusline)) end }
            )
        end,
    },

    -- indent guides for Neovim
    {
        'lukas-reineke/indent-blankline.nvim',
        priority = 500,
        event = 'VeryLazy',
        main = 'ibl',
        opts = {
            indent = { char = '│', tab_char = '│' },
            scope = { enabled = false },
            exclude = { filetypes = { 'help', 'Trouble', 'trouble', 'lazy', 'mason', 'notify' } },
        },
    },

    -- Active indent guide and indent text objects.
    {
        'echasnovski/mini.indentscope',
        version = false, -- wait till new 0.7.0 release to put it back on semver
        event = { 'VeryLazy', 'BufReadPost' },
        opts = { symbol = '│', options = { try_as_border = true } },
        init = function()
            vim.api.nvim_create_autocmd('FileType', {
                pattern = { 'help', 'Trouble', 'trouble', 'lazy', 'mason', 'notify' },
                callback = function() vim.b.miniindentscope_disable = true end,
            })
        end,
    },

    -- floating filename
    {
        'b0o/incline.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        event = { 'VeryLazy', 'BufReadPre' },
        name = 'incline',
        priority = 420,
        opts = {
            window = {
                padding = 0,
                margin = { vertical = 0, horizontal = 3 },
            },
            hide = { cursorline = true },
            render = function(props)
                local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
                local icon, color = require('nvim-web-devicons').get_icon_color(filename)

                if vim.bo[props.buf].modified then filename = filename .. '  ' end

                return { { icon, guifg = color }, '  ', filename }
            end,
        },
    },
}
