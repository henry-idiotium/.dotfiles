return {
    'numToStr/Comment.nvim',
    dependencies = 'JoosepAlviste/nvim-ts-context-commentstring',
    opts = {
        padding = true, ---Add a space b/w comment and the line
        sticky = true, ---Whether the cursor should stay at its position
        ignore = nil, ---Lines to be ignored while (un)comment
        toggler = { line = 'gcc', block = 'gbc' }, ---LHS of toggle mappings in NORMAL mode
        opleader = { line = 'gc', block = 'gb' }, ---LHS of operator-pending mappings in NORMAL and VISUAL mode
        extra = { above = 'gcO', below = 'gco', eol = 'gcA' }, ---LHS of extra mappings
        --- If given `false` then the plugin won't create any mappings -Enable keybindings
        mappings = {
            basic = true, ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
            extra = true, ---Extra mapping; `gco`, `gcO`, `gcA`
        },
    },
}
