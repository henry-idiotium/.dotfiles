return {
    {
        'echasnovski/mini.indentscope',
        opts = {
            draw = {
                animation = require('mini.indentscope').gen_animation.none(),
            },
            mappings = {},
        },
    },

    {
        'lukas-reineke/indent-blankline.nvim',
        opts = {
            scope = {
                enabled = true,
                show_start = false,
                show_end = false,
            },
        },
    },

    {
        'rcarriga/nvim-notify',
        opts = {
            timeout = 5000,
        },
    },

    { -- tab/buffer line
        'akinsho/bufferline.nvim',
        event = 'VeryLazy',
        keys = {
            { '<tab>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next tab' },
            { '<s-tab>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev tab' },
        },
        opts = {
            options = {
                mode = 'tabs',
                show_buffer_close_icons = false,
                show_close_icon = false,
            },
        },
    },

    { -- floating filename
        'b0o/incline.nvim',
        event = 'BufReadPre',
        priority = 1200,
        config = function()
            local colors = require 'catppuccin.palettes.mocha'
            require('incline').setup {
                window = { margin = { vertical = 0, horizontal = 1 } },
                hide = { cursorline = true },
                highlight = {
                    groups = {
                        InclineNormal = { guibg = colors.base, guifg = colors.text },
                        InclineNormalNC = { guibg = colors.crust, guifg = colors.overlay0 },
                    },
                },
                render = function(props)
                    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
                    if vim.bo[props.buf].modified then filename = '[+] ' .. filename end

                    local icon, color = require('nvim-web-devicons').get_icon_color(filename)
                    return { { icon, guifg = color }, { ' ' }, { filename } }
                end,
            }
        end,
    },

    {
        'folke/zen-mode.nvim',
        cmd = 'ZenMode',
        opts = {
            plugins = {
                gitsigns = true,
                tmux = true,
                kitty = { enabled = false, font = '+2' },
            },
        },
        keys = { { '<leader>z', '<cmd>ZenMode<cr>', desc = 'Zen Mode' } },
    },
}
