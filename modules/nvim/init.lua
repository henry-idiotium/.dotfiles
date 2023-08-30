require 'nihil'

-- vim.api.nvim_set_keymap('n', '<leader>[]', ':echo "foooooooo"<cr>', { mode = 'n' })

-- local run = nihil.utils.cmd.callbackRun

--[[ nihil.utils.keymap.map_keys {
    ['<leader>['] = {
        desc = 'TEST leader first',
        { 'f', ':echo "work 1"<cr>', desc = 'is fooo 1' },
        { 'j', ':echo "work 2"<cr>', desc = 'is fooo 2' },
        f = { ':echo "work 3"<cr>', desc = 'is fooo 3', mode = 'v' },
        j = { ':echo "work 4"<cr>', desc = 'is fooo 4' },
    },
    ['<leader>]'] = {
        desc = 'TEST leader second',
        { '<c-l>', ':echo "work 5"<cr>', desc = 'is fooo 5' },
        ['<c-f>'] = { ':echo "work 6"<cr>', desc = 'is fooo 6' },
        ['<c-l>'] = { ':echo "work 7"<cr>', desc = 'is fooo 7' },
        ['<c-o>'] = {
            desc = 'ctrl + o hierarchy',
            ['<c-f>'] = { ':echo "work 8"<cr>', desc = 'is fooo 8' },
            ['<c-q>'] = { ':echo "work 9"<cr>', desc = 'is fooo 9' },
        },
        ['<c-l><c-l>'] = { run 'echo "easy to break function"', desc = 'scream' },
    },
} ]]
