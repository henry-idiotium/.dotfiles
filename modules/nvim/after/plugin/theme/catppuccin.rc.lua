nihil.utils.plugin.theme_require('catppuccin', function(cat)
    local mocha_colors       = require 'catppuccin.palettes'.get_palette 'mocha'
    local override_highlight = nihil.utils.highlight.add_on_colorscheme

    cat.setup {
        flavour = 'mocha', -- latte, frappe, macchiato, mocha
        transparent_background = true,
        term_colors = true,
        integrations = { --: For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
            cmp = true,
            gitsigns = true,
            nvimtree = true,
            telescope = true,
            notify = true,
            which_key = true,
            fidget = true,
        },
        dim_inactive = { enabled = false, percentage = 0.3, shade = 'dark', },
        styles = {
            comments = {},
            conditionals = { 'bold' },
            loops = {},
            functions = {},
            booleans = {},
            types = { 'bold' },
            properties = {},
        },

        highlight_overrides = {
            all = function(C)
                return {
                    TabLineSel = { fg = C.text, bg = C.base, style = { 'italic', 'bold' } },
                    TabLine = { bg = C.crust },
                    CmpBorder = { fg = C.surface2 },
                    Pmenu = { bg = C.none },
                    TelescopeBorder = { link = 'FloatBorder' },
                }
            end,
        },

        navic = { enabled = true, custom_bg = 'NONE', },
    }

    --: Due to unable to override some of the highlight (diagnostic undercurl, or folded bg)
    --: with catppuccin provided-method, this the alt way of override it.
    override_highlight {
        --: Override diagnostic highlights
        DiagnosticUnderlineHint      = { undercurl = true, sp = mocha_colors.teal },
        LspDiagnosticsUnderlineHint  = { undercurl = true, sp = mocha_colors.teal },
        DiagnosticUnderlineWarn      = { undercurl = true, sp = mocha_colors.yellow },
        LspDiagnosticsUnderlineWarn  = { undercurl = true, sp = mocha_colors.yellow },
        DiagnosticUnderlineError     = { undercurl = true, sp = mocha_colors.red },
        LspDiagnosticsUnderlineError = { undercurl = true, sp = mocha_colors.red },

        Folded                       = { bg = mocha_colors.base },
        Visual                       = { bg = mocha_colors.surface0 },
    }
end)
