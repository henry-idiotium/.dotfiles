nihil.utils.plugin.theme_setup('tokyonight', {
    style = 'moon', --: storm, moon, night, day
    transparent = true, --: Enable this to disable setting the background color
    terminal_colors = true, --: Configure the colors used when opening a `:terminal` in Neovim
    styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = { italic = true },
        variables = {},
        --: Background styles. Can be "dark", "transparent" or "normal"
        sidebars = 'transparent', --: Style for sidebars
        floats = 'transparent', --: Style for floating windows
    },
    sidebars = { 'qf', 'help', 'terminal', 'packer' },
    hide_inactive_statusline = true,
    dim_inactive = true,
    lualine_bold = true,
    on_highlights = function(hl, _)
        hl.String = { fg = "#7dc785" }
    end,
})
