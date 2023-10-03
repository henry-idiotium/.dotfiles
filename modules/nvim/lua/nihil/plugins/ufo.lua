--- Code folding helper
return {
    'kevinhwang91/nvim-ufo',
    event = 'VeryLazy',
    dependencies = { 'kevinhwang91/promise-async' },
    init = function()
        vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
        -- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep:│,foldclose:]]
        vim.o.foldcolumn = '0' -- '0' is not bad
        vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
    end,
    config = function()
        local ufo = require 'ufo'
        nihil.utils.keymap.map_keys({
            ['<s-o>'] = { ufo.openAllFolds, desc = 'Open all folds' },
            ['<s-c>'] = { ufo.closeAllFolds, desc = 'Close all folds' },
            ['m'] = { ufo.closeFoldsWith, desc = 'Close folds with' },
        }, { prefix = 'z' })
        ufo.setup {}
    end,
}
