return {
    {
        'folke/which-key.nvim',
        opts = function(_, opts) opts.window = { border = 'single' } end,
    },

    {
        'echasnovski/mini.indentscope',
        opts = {
            draw = { animation = require('mini.indentscope').gen_animation.none() },
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
        priority = 420,
        config = function()
            require('incline').setup {
                window = { margin = { vertical = 0, horizontal = 1 } },
                hide = { cursorline = true },
                render = function(props)
                    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
                    local icon, color = require('nvim-web-devicons').get_icon_color(filename)

                    if vim.bo[props.buf].modified then filename = filename .. ' ' end

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
            },
        },
        keys = { { '<leader>z', '<cmd>ZenMode<cr>', desc = 'Zen Mode' } },
    },

    { -- messages, cmdline and the popupmenu
        'folke/noice.nvim',
        opts = function(_, opts)
            table.insert(opts.routes, {
                filter = {
                    event = 'notify',
                    find = 'No information available',
                },
                opts = { skip = true },
            })
            local focused = true
            vim.api.nvim_create_autocmd('FocusGained', {
                callback = function() focused = true end,
            })
            vim.api.nvim_create_autocmd('FocusLost', {
                callback = function() focused = false end,
            })
            table.insert(opts.routes, 1, {
                filter = {
                    cond = function() return not focused end,
                },
                view = 'notify_send',
                opts = { stop = false },
            })

            opts.commands = {
                all = {
                    -- options for the message history that you get with `:Noice`
                    view = 'split',
                    opts = { enter = true, format = 'details' },
                    filter = {},
                },
            }

            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'markdown',
                callback = function(event)
                    vim.schedule(function() require('noice.text.markdown').keys(event.buf) end)
                end,
            })

            opts.presets.lsp_doc_border = true
        end,
    },
}
