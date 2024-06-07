---@diagnostic disable: no-unknown
return {
    { -- Rose Pine
        'rose-pine/neovim',
        name = 'rose-pine',
        priority = 1000,
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
                IncSearch = { bg = 'highlight_med', fg = 'none' },
                CurSearch = { bg = 'highlight_low', fg = 'none', underline = true },
                Visual = { bg = '#343242' },
                Normal = { bg = 'none' },
                NormalFloat = { bg = 'none' },
                PmenuSel = { bg = 'highlight_low', fg = 'none' },

                TroubleNormal = { bg = 'none' },
                VirtColumn = { fg = 'base' },
                IlluminatedWordText = { bg = 'highlight_low' },
                IlluminatedWordRead = { bg = 'highlight_low' },
                IlluminatedWordWrite = { bg = 'highlight_low' },
                NeoTreeCursorLine = { bg = 'base', bold = true },

                CmpGhostText = { link = 'Comment', default = true },
                CmpItemAbbrDeprecated = { fg = 'muted', bg = 'none', strikethrough = true },
                CmpItemAbbrMatch = { fg = 'foam', bg = 'none', bold = true },
                CmpItemAbbrMatchFuzzy = { fg = 'foam', bg = 'none', bold = true },
                CmpItemMenu = { fg = 'rose', bg = 'none', italic = true },

                CmpItemKindSupermaven = { link = 'CmpGhostText', default = true },
            },
        },
    },

    { -- Catppuccin
        'catppuccin/nvim',
        name = 'catppuccin',
        priority = 1000,
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

    { -- Nightfox
        'EdenEast/nightfox.nvim',
        priority = 1000,
        opts = {
            options = {
                transparent = true,
                terminal_colors = true,
                styles = {
                    comments = 'italic',
                    conditionals = 'italic',
                    constants = 'italic,bold',
                    keywords = 'italic',
                },
            },
        },
    },
}
