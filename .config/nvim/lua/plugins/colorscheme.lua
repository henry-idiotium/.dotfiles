return {
    { 'folke/tokyonight.nvim', enabled = false },
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
        },
    },
}
