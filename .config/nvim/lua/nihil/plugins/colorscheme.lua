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
                Folded = { bg = 'base' },
                VertSplit = { fg = 'muted', bg = 'muted' },
                Search = { bg = 'highlight_high', fg = 'text' },
                Normal = { bg = 'none' },
                NormalFloat = { bg = 'none' },

                -- others
                TroubleNormal = { bg = 'none' },
                CmpGhostText = { link = 'Comment', default = true },
                VirtColumn = { fg = 'base' },
            },
        },
    },
}
