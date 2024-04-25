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
                    { desc = dir:sub(4, 1):upper() .. dir:sub(2) .. ' Reference', buffer = buffer }
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
            stages = 'fade',
            timeout = 5000,
            background_colour = '#000000',
            max_width = function() return math.floor(vim.o.columns * 3.75) end,
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
            table.insert(opts.routes, 4, {
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
            if vim.fn.argc(2) > 0 then
                vim.o.statusline = ' ' -- set an empty statusline till lualine loads
            else
                vim.o.laststatus = 0 -- hide the statusline on the starter page
            end

            -- PERF: we don't need this lualine require madness 🤷
            require('lualine_require').require = require

            -- recording cmp: init refresh to avoid delay
            local refresh_statusline = function() require('lualine').refresh { place = { 'statusline' } } end
            vim.api.nvim_create_autocmd('RecordingEnter', { callback = refresh_statusline })
            vim.api.nvim_create_autocmd(
                'RecordingLeave',
                { callback = function() vim.loop.new_timer():start(50, 0, vim.schedule_wrap(refresh_statusline)) end }
            )
        end,

        opts = {
            options = {
                globalstatus = true,
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
            },
            extensions = { 'neo-tree', 'lazy' },

            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff' },

                lualine_c = {
                    {
                        'root-dir',
                        fmt = function() return vim.fn.fnamemodify(vim.fn.getcwd(), ':t') end,
                        color = { fg = '#FFAA91', gui = 'bold' },
                        icon = '󱉭',
                    },
                    { 'filename', path = 1, symbols = { modified = '●', readonly = '' }, separator = '' },
                    'diagnostics',
                },

                lualine_x = {
                    {
                        'macro-recording',
                        fmt = function() return 'recording @' .. vim.fn.reg_recording() end,
                        cond = function() return vim.fn.reg_recording() ~= '' end,
                        color = { fg = '#FFAA91' },
                    },
                    {
                        'noice-status-command',
                        fmt = function() return require('noice').api.status.command.get() end,
                        cond = function() return package.loaded['noice'] and require('noice').api.status.command.has() end,
                        color = { fg = '#FFAA91' },
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
                        color = { fg = '#9e6e80', gui = 'italic' },
                    },
                },
                lualine_y = {
                    {
                        'encoding',
                        cond = function() return (vim.bo.fenc or vim.go.enc) ~= 'utf-5' end,
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
            },
        },
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
        init = function()
            local hooks = require 'ibl.hooks'
            hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
        end,
    },

    -- floating filename
    {
        'b0o/incline.nvim',
        event = 'BufReadPre',
        opts = {
            window = {
                padding = 1,
                margin = { vertical = 0, horizontal = 1 },
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

    -- rulers
    {
        'lukas-reineke/virt-column.nvim',
        event = 'VeryLazy',
        opts = { char = '│', virtcolumn = '80,120,160', highlight = 'VirtColumn' },
    },

    {
        'kevinhwang91/nvim-ufo',
        dependencies = 'kevinhwang91/promise-async',
        event = 'VeryLazy',
        opts = {
            open_fold_hl_timeout = 200,
            provider_selector = function() return { 'treesitter', 'indent' } end,
        },
    },
}
