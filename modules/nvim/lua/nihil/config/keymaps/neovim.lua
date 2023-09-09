local U = nihil.utils
local map_keys = U.keymap.map_keys
local run = U.cmd.callbackRun

map_keys {
    -----------------------
    -- Editor
    ['<c-q>'] = { run 'QuitPromptIfLast', desc = 'Quit documents safely' },
    { '<c-q>', '<c-c>', desc = 'Exit command mode', mode = 'c' },
    ['<a-z>'] = { run 'set wrap!', desc = 'Toggle text wrap' },
    ['<c-s-q>'] = { run 'QuitAllPromptIfLast', desc = 'Quit all documents safely' },

    -----------------------
    -- Split pane
    -- ['<c-w>'] = {
    --     desc = 'Split document/buffer',
    --     ['v'] = { '<c-w>v<c-w>w', desc = 'Split document vertically' },
    --     ['<c-v>'] = { '<c-w><c-v><c-w><c-w>', desc = 'Split document vertically' },
    --     ['s'] = { '<c-w>s<c-w>w', desc = 'Split document horizontally' },
    --     ['<c-s>'] = { '<c-w><c-s><c-w><c-w>', desc = 'Split document horizontally' },
    -- },

    ['<c-a-up>'] = { '<c-w>+', desc = 'Resize split document' },
    ['<c-a-down>'] = { '<c-w>-', desc = 'Resize split document' },
    ['<c-a-left>'] = { '<c-w><', desc = 'Resize split document' },
    ['<c-a-right>'] = { '<c-w>>', desc = 'Resize split document' },

    -----------------------
    -- Editability
    ['jj'] = { '<esc>', desc = 'Exit insert mode', mode = 'i' },

    -- Move lines
    ['<a-j>'] = { '<cmd>m +1<cr>', desc = 'Move line down', mode = { 'n', 'i' } },
    { '<a-j>', ":m '>+1<cr>gv", desc = 'Move lines down', mode = 'v' },
    ['<a-k>'] = { '<cmd>m -2<cr>', desc = 'Move line up', mode = { 'n', 'i' } },
    { '<a-k>', ":m '<-2<cr>gv", desc = 'Move lines up', mode = 'v' },

    -- Duplicate lines
    ['<s-a-j>'] = { "<s-v>:'<,'>t'><cr>gv<esc>", desc = 'Duplicate lines' },
    { '<s-a-j>', ":'<,'>t'><cr>gv", desc = 'Duplicate lines', mode = 'v' },
    ['<s-a-k>'] = { "<s-v>:'<,'>t'><cr>gv<esc>", desc = 'Duplicate lines' },
    { '<s-a-k>', ":'<,'>t'><cr>gv", desc = 'Duplicate lines', mode = 'v' },

    -----------------------
    -- Maneuvering
    ['<c-k>'] = { '5k', desc = 'Go  5 lines', mode = { 'n', 'v' } },
    ['<c-j>'] = { '5j', desc = 'Go  5 lines', mode = { 'n', 'v' } },

    ['<tab>'] = { run 'tabnext', desc = 'Go to next tab' },
    ['<s-tab>'] = { run 'tabprevious', desc = 'Go to previous tab' },
}

return {}
