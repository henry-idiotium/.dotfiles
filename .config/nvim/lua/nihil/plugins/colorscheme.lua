---@diagnostic disable: no-unknown
return {
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        event = 'VeryLazy',
        init = function() vim.cmd.colorscheme 'rose-pine-main' end,
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

            ---@type table<string, vim.api.keyset.highlight>
            highlight_groups = {
                Comment = { fg = 'muted' },
                Folded = { bg = 'base' },
                VertSplit = { fg = 'overlay', bg = 'muted' },
                Search = { bg = 'highlight_med', fg = 'none' },
                CurSearch = { bg = 'highlight_med', fg = 'none' },
                IncSearch = { bg = 'highlight_med', fg = 'none' },
                Visual = { bg = '#343242' },
                Normal = { bg = 'none' },
                NormalFloat = { bg = 'none' },

                -- others
                TroubleNormal = { bg = 'none' },
                CmpGhostText = { link = 'Comment', default = true },
                VirtColumn = { fg = 'base' },
                IlluminatedWordText = { bg = 'highlight_low' },
                IlluminatedWordRead = { bg = 'highlight_low' },
                IlluminatedWordWrite = { bg = 'highlight_low' },
                NeoTreeCursorLine = { bg = 'base', bold = true },
            },
        },
    },
}
