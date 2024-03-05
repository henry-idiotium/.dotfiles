return {
    {
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
            underlines = {
                errors = { 'undercurl' },
                hints = { 'undercurl' },
                warnings = { 'undercurl' },
                information = { 'undercurl' },
            },

            highlight_overrides = {
                all = function(C)
                    return {
                        TabLineSel = { fg = C.text, bg = C.base, style = { 'italic', 'bold' } },
                        TabLine = { bg = C.crust },
                        CmpBorder = { fg = C.surface2 },
                        Pmenu = { bg = C.none },
                        TelescopeBorder = { link = 'FloatBorder' },

                        Folded = { bg = C.crust },
                        Visual = { bg = C.base },
                    }
                end,
            },
        },
    },
}
