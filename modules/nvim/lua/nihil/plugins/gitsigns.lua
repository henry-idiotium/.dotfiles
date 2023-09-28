return {
    'lewis6991/gitsigns.nvim',
    opts = {
        signs = {
            add = { text = '│' },
            change = { text = '│' },
            delete = { text = '_' },
            topdelete = { text = '‾' },
            changedelete = { text = '~' },
            untracked = { text = '│' },
        },
        current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    },
}
