---@diagnostic disable: no-unknown
return {
    { -- Rose Pine
        'rose-pine/neovim',
        name = 'rose-pine',
        event = 'VeryLazy',
        enabled = true,
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
            },
        },
    },

    { -- Catppuccin
        'catppuccin/nvim',
        name = 'catppuccin',
        event = 'VeryLazy',
        enabled = false,
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

    { -- Tokyonight
        'folke/tokyonight.nvim',
        event = 'VeryLazy',
        enabled = false,
        opts = {
            style = 'moon', -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
            transparent = true, -- Enable this to disable setting the background color
            terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
            styles = {
                -- Background styles. Can be "dark", "transparent" or "normal"
                sidebars = 'transparent',
                floats = 'transparent',

                comments = { italic = true },
                keywords = { italic = true, bold = true },
                functions = { italic = true },
                variables = {},
            },
        },
    },

    { -- Kanagawa
        'rebelot/kanagawa.nvim',
        event = 'VeryLazy',
        enabled = false,
        opts = {
            theme = 'wave', -- Load "wave" theme when 'background' option is not set
            compile = true, -- enable compiling the colorscheme
            undercurl = true, -- enable undercurls
            commentStyle = { italic = true },
            keywordStyle = { italic = true },
            statementStyle = { bold = true },
            transparent = true, -- do not set background color
            terminalColors = true, -- define vim.g.terminal_color_{0,17}
            colors = { -- add/modify theme and palette colors
                theme = {
                    all = {
                        ui = { bg_gutter = 'none' },
                    },
                },
            },
        },
    },

    { -- Nightfox
        'EdenEast/nightfox.nvim',
        event = 'VeryLazy',
        enabled = false,
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

    { -- Nordic
        'AlexvZyl/nordic.nvim',
        event = 'VeryLazy',
        enabled = false,
        opts = {
            bold_keywords = true,
            italic_comments = true,
            transparent_bg = true,
            reduced_blue = true,
            override = {},
            -- Cursorline options.  Also includes visual/selection.
            cursorline = {
                bold = false,
                bold_number = true,
                theme = 'dark',
                blend = 0,
            },
        },
    },
}
