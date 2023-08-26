nihil.utils.plugin.theme_setup('nightfox', {
    options = {
        transparent = true,
        terminal_colors = true,
        --dim_inactive = true,
        styles = { -- Style to be applied to different syntax groups (:help attr-list)
            comments = 'italic',
            functions = 'italic',
            constants = 'italic',
            types = 'bold',
        },
    },
})
