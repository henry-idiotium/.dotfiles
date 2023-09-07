local U = nihil.utils
local map_keys = U.keymap.map_keys
local unmap_keys = U.keymap.unmap_keys
local run = U.cmd.callbackRun

vim.g.mapleader = ' '

unmap_keys {
    -- arrow keys
    '<up>',
    '<down>',
    '<left>',
    '<right>',
    -- Escapse buffer
    '<s-z><s-z>',
    '<c-s-z>',
    -- surrounding (brackets) jump
    'zj',
    'zk',

    '<c-z>',
    '<c-f>',
    '<c-n>',
    '<c-p>',
    '<c-d>',
    '<c-u>',
    'gt',
    'g<s-t>',

    '<a-n>',
}

map_keys {
    -----------------------
    -- Editor
    ['<c-q>'] = { run 'QuitPromptIfLast', desc = 'Quit document savely' },
    { '<c-q>', '<c-c>', desc = 'Exit command mode', mode = 'c' },
    ['<c-s>'] = { run 'write', desc = 'Save document', mode = { 'n', 'i' } },
    ['<c-s-q>'] = { run 'QuitAllPromptIfLast', desc = 'Quit all documents savely' },

    ['<leader>h'] = { run 'nohl', desc = 'Turn off search highlight' },
    ['<a-z>'] = { run 'set wrap!', desc = 'Toggle text wrap' },

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

    ['<c-z>'] = { '<cmd>undo<cr>', desc = 'Undo document', mode = { 'n', 'i', 'v' } },
    ['<c-y>'] = { '<cmd>redo<cr>', desc = 'Redo document', mode = { 'n', 'i', 'v' } },

    ['o'] = { 'o<esc>0"_<s-d>', desc = 'New line after' },
    ['<s-o>'] = { '<s-o><esc>0"_<s-d>', desc = 'New line before' },

    ['<'] = { '<gv', desc = 'Outdent', mode = 'v' },
    ['>'] = { '>gv', desc = 'Indent', mode = 'v' },

    ['+'] = { '<c-a>', desc = 'Increment' },
    ['-'] = { '<c-x>', desc = 'Decrement' },

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

    -- Avoid copy on paste in Visual mode
    ['p'] = { '<s-p>', desc = 'Paste', mode = 'v' },

    ['x'] = { '"_x', desc = 'Void yank x' },

    -----------------------
    -- Maneuvering

    ['<c-k>'] = { '5k', desc = 'Go  5 lines', mode = { 'n', 'v' } },
    ['<c-j>'] = { '5j', desc = 'Go  5 lines', mode = { 'n', 'v' } },

    ['<s-h>'] = { '^', desc = 'Go to sol', mode = { 'n', 'v', 'o' } },
    ['<s-l>'] = { '$', desc = 'Go to eol', mode = { 'n', 'v', 'o' } },

    ['<tab>'] = { run 'tabnext', desc = 'Go to next tab' },
    ['<s-tab>'] = { run 'tabprevious', desc = 'Go to previous tab' },

    -----------------------
    -- Macros
    [','] = { '@@', desc = 'Run saved macro', remap = true },
    ['\\a'] = { 'gg<s-v><s-g>', desc = 'Select whole document' },

    -----------------------
    -- Void yanks
    [';'] = {
        mode = { 'n', 'v' },
        desc = 'Void yanks',
        ['d'] = { '"_d', desc = 'Void yank d' },
        ['c'] = { '"_c', desc = 'Void yank c' },
        ['x'] = { '"_x', desc = 'Void yank x' },
        ['s'] = { '"_s', desc = 'Void yank s' },
        ['<s-d>'] = { '"_<s-d>', desc = 'Void yank D' },
        ['<s-c>'] = { '"_<s-c>', desc = 'Void yank C' },
    },
}

if vim.g.vscode then
    local vscode_nvim_exist, vscode_nvim = pcall(require, 'vscode-neovim')
    if not vscode_nvim_exist then return end

    map_keys {
        ['<a-n>'] = { vscode_nvim.notify 'editor.action.addSelectionToNextFindMatch', noremap = false },
    }
end

return {}
