return {
    'numToStr/Comment.nvim', dependencies = 'JoosepAlviste/nvim-ts-context-commentstring',
    opts = {
        ---Add a space b/w comment and the line
        padding = true,
        ---Whether the cursor should stay at its position
        sticky = true,
        ---Lines to be ignored while (un)comment
        ignore = nil,
        ---LHS of toggle mappings in NORMAL mode
        toggler = { line = 'gcc', block = 'gbc', },
        ---LHS of operator-pending mappings in NORMAL and VISUAL mode
        opleader = { line = 'gc', block = 'gb', },
        ---LHS of extra mappings
        extra = { above = 'gcO', below = 'gco', eol = 'gcA', },
        ---Enable keybindings
        --- If given `false` then the plugin won't create any mappings
        mappings = {
            ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
            basic = true,
            ---Extra mapping; `gco`, `gcO`, `gcA`
            extra = true,
        },
    }
}
