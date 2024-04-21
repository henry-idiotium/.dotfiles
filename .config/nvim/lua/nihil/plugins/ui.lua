---@diagnostic disable: duplicate-set-field, no-unknown
return {
    { 'nvim-tree/nvim-web-devicons', lazy = true }, -- icons
    { 'MunifTanjim/nui.nvim', lazy = true }, -- ui components

    -- Better `vim.notify`
    {
        'rcarriga/nvim-notify',
        lazy = false,
        event = 'VeryLazy',
        dependencies = 'folke/noice.nvim',
        keys = {
            { '<leader>un', function() require('notify').dismiss { silent = true, pending = true } end, desc = 'Dismiss All Notifications' },
        },
        opts = {
            render = 'compact',
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
    },

    -- Highly experimental plugin that completely replaces the UI for
    -- messages, cmdline and the popupmenu.
    {
        'folke/noice.nvim',
        dependencies = {
            'MunifTanjim/nui.nvim',

            -- Displays a popup with possible key bindings of the command you started typing
            { 'folke/which-key.nvim', opts = function(_, opts) opts.defaults['<leader>sn'] = { name = '+noice' } end },
        },
        lazy = false,
        event = 'VeryLazy',
        keys = {
            { '<s-enter>', function() require('noice').redirect(vim.fn.getcmdline()) end, mode = 'c', desc = 'Redirect Cmdline' },
            { '<leader>snl', function() require('noice').cmd 'last' end, desc = 'Noice Last Message' },
            { '<leader>snh', function() require('noice').cmd 'history' end, desc = 'Noice History' },
            { '<leader>sna', function() require('noice').cmd 'all' end, desc = 'Noice All' },
            { '<leader>snd', function() require('noice').cmd 'dismiss' end, desc = 'Dismiss All' },
            {
                '<c-f>',
                function()
                    if not require('noice.lsp').scroll(4) then return '<c-f>' end
                end,
                silent = true,
                expr = true,
                desc = 'Scroll Forward',
                mode = { 'i', 'n', 's' },
            },
            {
                '<c-b>',
                function()
                    if not require('noice.lsp').scroll(-4) then return '<c-b>' end
                end,
                silent = true,
                expr = true,
                desc = 'Scroll Backward',
                mode = { 'i', 'n', 's' },
            },
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

            ---@type NoiceConfigViews
            views = {
                hover = {
                    border = { style = 'rounded' },
                    size = { max_width = 80 },
                },
            },
            routes = {
                {
                    filter = {
                        event = 'msg_show',
                        any = {
                            { find = '%d+L, %d+B' },
                            { find = '; after #%d+' },
                            { find = '; before #%d+' },
                        },
                    },
                    view = 'mini',
                },
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = true,
            },
        },
    },

    -- Scroll bar
    {
        'lewis6991/satellite.nvim',
        event = 'VeryLazy',
        opts = {
            current_only = true,
            winblend = 0,
        },
        config = function(_, opts)
            vim.api.nvim_set_hl(0, 'SatelliteBar', { bg = '#1F1F26', blend = 10 })
            require('satellite').setup(opts)
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

        opts = function()
            -- PERF: we don't need this lualine require madness 🤷
            local lualine_require = require 'lualine_require'
            lualine_require.require = require

            ---@type table<vim.diagnostic.Severity, string>
            local icons = require('nihil.plugins.lsp.options').lspconfig.diagnostics.signs.text

            vim.o.laststatus = vim.g.lualine_laststatus

            return {
                options = {
                    theme = 'auto',
                    icons_enabled = true,
                    globalstatus = true,
                    disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'starter' } },
                },

                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch' },

                    lualine_c = {
                        {
                            function() return vim.fn.fnamemodify(vim.fn.getcwd(), ':t') end,
                            icon = '󱉭 ',
                            color = { fg = '#FFAA88', gui = 'italic,bold' },
                        },
                        { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 } },
                        {
                            'filename',
                            file_status = true,
                            path = 1,
                            symbols = { modified = '●', readonly = '', unnamed = '[void]' },
                        },
                    },

                    lualine_x = {
                        {
                            function() return require('noice').api.status.command.get() end,
                            cond = function() return package.loaded['noice'] and require('noice').api.status.command.has() end,
                        },
                        {
                            function() return require('noice').api.status.mode.get() end,
                            cond = function() return package.loaded['noice'] and require('noice').api.status.mode.has() end,
                        },
                        {
                            function() return '  ' .. require('dap').status() end,
                            cond = function() return package.loaded['dap'] and require('dap').status() ~= '' end,
                        },

                        {
                            'diagnostics',
                            symbols = {
                                error = icons[vim.diagnostic.severity.ERROR],
                                warn = icons[vim.diagnostic.severity.WARN],
                                info = icons[vim.diagnostic.severity.INFO],
                                hint = icons[vim.diagnostic.severity.HINT],
                            },
                        },

                        {
                            'diff',
                            symbols = {
                                added = ' ',
                                modified = ' ',
                                removed = ' ',
                            },
                            source = function()
                                local gitsigns = vim.b.gitsigns_status_dict
                                if gitsigns then
                                    return {
                                        added = gitsigns.added,
                                        modified = gitsigns.changed,
                                        removed = gitsigns.removed,
                                    }
                                end
                            end,
                        },
                    },
                    lualine_y = {
                        'encoding',
                        { 'fileformat', separator = '', padding = { left = 1, right = 2 } },
                    },
                    lualine_z = {
                        { 'location', separator = ' ', padding = { left = 1, right = 0 } },
                        { 'progress', padding = { left = 0, right = 1 } },
                    },
                },
                extensions = { 'neo-tree', 'lazy' },
            }
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
        event = 'VeryLazy',
        event = 'BufReadPost',
        opts = { symbol = '│', options = { try_as_border = true } },
        init = function()
            vim.api.nvim_create_autocmd('FileType', {
                pattern = { 'help', 'Trouble', 'trouble', 'lazy', 'mason', 'notify' },
                callback = function() vim.b.miniindentscope_disable = true end,
            })
        end,
    },
}
