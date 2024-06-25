_G._debug = { count = 0 }
return {
    { -- better vim.ui
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
        opts = {
            input = {
                mappings = {
                    ['<esc>'] = 'Close',
                    ['<c-q>'] = 'Close',
                    ['<c-c>'] = 'Close',
                    ['<cr>'] = 'Confirm',
                    ['<c-j>'] = 'Confirm',
                    ['<c-o>'] = 'Confirm',
                    ['<c-h>'] = 'HistoryPrev',
                    ['<c-l>'] = 'HistoryNext',
                    ['<up>'] = 'HistoryPrev',
                    ['<down>'] = 'HistoryNext',
                },
            },
        },
        config = function(_, opts)
            opts.input.mappings = {
                n = opts.input.mappings,
                i = opts.input.mappings,
            }

            require('dressing').setup(opts)
        end,
    },

    { -- better vim.notify
        'rcarriga/nvim-notify',
        keys = {
            {
                '<leader>nc',
                function() require('notify').dismiss { silent = true, pending = true } end,
                desc = 'Dismiss All Notifications',
            },
        },
        opts = {
            render = 'wrapped-compact',
            stages = 'fade',
            timeout = 5000,
            background_colour = '#000000',
        },
    },

    { -- highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
        'noice.nvim',

        keys = {
            { '<leader>nh', '<cmd>NoiceHistory <cr>', desc = 'Noice History' },
            { '<leader>nl', '<cmd>NoiceLast <cr>', desc = 'Noice Last Message' },
            { '<leader>na', '<cmd>NoiceAll <cr>', desc = 'Noice History All' },
            { '<leader>nm', '<cmd>NoiceDismiss <cr>', desc = 'Noice Dismiss' },
        },

        opts = function(_, opts)
            local focused = true
            vim.api.nvim_create_autocmd('FocusGained', { callback = function() focused = true end })
            vim.api.nvim_create_autocmd('FocusLost', { callback = function() focused = false end })
            table.insert(opts.routes, {
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

            table.insert(opts.routes, {
                opts = { skip = true },
                filter = {
                    event = 'notify',
                    find = 'No information available',
                },
            })
            table.insert(opts.routes, { -- show messages in mini
                view = 'mini',
                filter = {
                    event = 'msg_show',
                    any = {
                        { find = '%d+L, %d+B' },
                        { find = '; after #%d+' },
                        { find = '; before #%d+' },
                        { find = '%d+ more' },
                        { find = '%d+ fewer' },
                        { find = '%d+ lines' },
                        { find = 'Already at' },
                        { find = 'Supermaven' },
                    },
                },
            })

            opts.presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = true,
                lsp_doc_border = true,
            }
            opts.commands = {
                all = { -- options for the message history that you get with `:Noice`
                    view = 'split',
                    opts = { enter = true, format = 'details' },
                    filter = {},
                },
            }

            opts.lsp.override = {
                ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                ['vim.lsp.util.stylize_markdown'] = true,
                ['cmp.entry.get_documentation'] = true,
            }
            opts.lsp.signature = {
                enabled = true,
                auto_open = { enabled = false },
            }
            opts.lsp.progress = {
                enabled = true,
                format = 'lsp_progress',
                format_done = 'lsp_progress_done',
                view = 'mini',
                -- throttle = 1000 / 30,
            }
        end,
    },

    { -- Statusline
        'lualine.nvim',
        init = function(self)
            _G._debug.count = _G._debug.count + 1
            if self then self.init() end

            -- recording cmp: init refresh to avoid delay
            local refresh_statusline = function() require('lualine').refresh { place = { 'statusline' } } end
            vim.api.nvim_create_autocmd('RecordingEnter', { callback = refresh_statusline })
            vim.api.nvim_create_autocmd('RecordingLeave', {
                callback = function() vim.loop.new_timer():start(50, 0, vim.schedule_wrap(refresh_statusline)) end,
            })
        end,

        opts = function(_, opts)
            opts.options.component_separators = { left = '', right = '' }
            opts.options.section_separators = { left = '', right = '' }

            table.insert(opts.sections.lualine_x, {
                -- word count
                function()
                    local wc = vim.fn.wordcount()
                    return wc.words .. 'w ' .. wc.chars .. 'c'
                end,
                cond = function() return vim.tbl_contains({ 'markdown', 'vimwiki', 'latex', 'text', 'tex' }, vim.bo.ft) end,
                color = { fg = '#9E6E80', gui = 'italic' },
            })

            opts.sections.lualine_y = {
                { 'encoding', cond = function() return (vim.bo.fenc or vim.go.enc) ~= 'utf-8' end },
                {
                    'fileformat',
                    symbols = { unix = 'LF', dos = 'CRLF', mac = 'CR' },
                    cond = function() return vim.bo.ff ~= 'unix' end,
                },
                'progress',
            }

            opts.sections.lualine_z = {
                'location',
            }
        end,
    },

    { -- Tabline
        'akinsho/bufferline.nvim',
        keys = {
            { '<tab>', '<cmd>BufferLineCycleNext <cr>', desc = 'Next Buffer' },
            { '<s-tab>', '<cmd>BufferLineCyclePrev <cr>', desc = 'Prev Buffer' },
            { '[b', '<cmd>BufferLineCyclePrev <cr>', desc = 'Prev Buffer' },
            { ']b', '<cmd>BufferLineCycleNext <cr>', desc = 'Next Buffer' },
        },
        opts = function(_, opts)
            opts.options.mode = 'tabs'
            opts.options.always_show_bufferline = false
            opts.options.show_buffer_close_icons = false
            opts.options.show_close_icon = false
            opts.options.show_tab_indicators = false
            opts.options.indicator = { style = 'underline' }
            opts.options.separator_style = { nil, nil }
        end,
    },

    { -- floating filename
        'b0o/incline.nvim',
        event = 'VeryLazy',
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

    { -- highlight hex colors
        'brenoprata10/nvim-highlight-colors',
        event = 'VeryLazy',
        lazy = false,
        keys = {
            { '<leader>uh', '<cmd>HighlightColors Toggle <cr>', desc = 'Toggle color highlight (HEX, RGB, etc.)' },
        },
        opts = {
            render = 'virtual', --- background | foreground | virtual
            virtual_symbol = '', -- requires `vitual` mode
            virtual_symbol_prefix = '',
            virtual_symbol_suffix = ' ',
            virtual_symbol_position = 'inline',

            enable_hex = true, ---Highlight hex colors, e.g. '#FFFFFF'
            enable_short_hex = true, ---Highlight short hex colors e.g. '#fff'
            enable_rgb = true, ---Highlight rgb colors, e.g. 'rgb(0 0 0)'
            enable_hsl = true, ---Highlight hsl colors, e.g. 'hsl(150deg 30% 40%)'
            enable_var_usage = true, ---Highlight CSS variables, e.g. 'var(--testing-color)'
            enable_named_colors = true, ---Highlight named colors, e.g. 'green'
            enable_tailwind = true, ---Highlight tailwind colors, e.g. 'bg-blue-500'

            ---Set custom colors
            ---Label must be properly escaped with '%' to adhere to `string.gmatch`
            --- :help string.gmatch
            custom_colors = {},

            -- Exclude filetypes or buftypes from highlighting e.g. 'exclude_buftypes = {'text'}'
            exclude_filetypes = { 'text' },
            exclude_buftypes = {},
        },
    },
}
