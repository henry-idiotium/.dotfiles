---@diagnostic disable: no-unknown
return {
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        priority = 1000,
        enabled = true,
        init = function()
            vim.opt.winblend = 0
            vim.opt.pumblend = 0

            vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
            vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })

            vim.cmd.colorscheme 'rose-pine-main'
        end,
        opts = {
            variant = 'auto', -- auto, main, moon, or dawn
            dark_variant = 'main', -- main, moon, or dawn
            dim_inactive_windows = false,
            extend_background_behind_borders = true,

            enable = { terminal = true, migrations = true },

            styles = {
                bold = true,
                italic = true,
                transparency = true,
            },

            groups = {},
            highlight_groups = {
                Comment = { fg = 'muted' },
                VertSplit = { fg = 'muted', bg = 'muted' },
            },
        },
    },

    {
        'catppuccin/nvim',
        name = 'catppuccin',
        priority = 1000,
        enabled = false,
        init = function()
            vim.cmd.colorscheme 'catppuccin'
        end,
        opts = {
            flavour = 'mocha', -- latte, frappe, macchiato, mocha
            transparent_background = true,
            term_colors = true,
            styles = {
                comments = { 'italic' },
                conditionals = { 'italic' },
                types = { 'bold' },
            },
        },
    },
}
