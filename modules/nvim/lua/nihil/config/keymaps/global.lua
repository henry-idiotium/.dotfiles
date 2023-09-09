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
    ['<c-s>'] = { run 'write', desc = 'Save document', mode = { 'n', 'i' } },

    ['<leader>h'] = { run 'nohl', desc = 'Turn off search highlight' },

    -----------------------
    -- Editability
    ['<c-z>'] = { '<cmd>undo<cr>', desc = 'Undo document', mode = { 'n', 'i', 'v' } },
    ['<c-y>'] = { '<cmd>redo<cr>', desc = 'Redo document', mode = { 'n', 'i', 'v' } },

    ['o'] = { 'o<esc>', desc = 'New line after' },
    ['<s-o>'] = { '<s-o><esc>', desc = 'New line before' },

    ['<'] = { '<gv', desc = 'Outdent', mode = 'v' },
    ['>'] = { '>gv', desc = 'Indent', mode = 'v' },

    ['+'] = { '<c-a>', desc = 'Increment' },
    ['-'] = { '<c-x>', desc = 'Decrement' },

    -- Avoid copy on paste in Visual mode
    ['p'] = { '<s-p>', desc = 'Paste', mode = 'v' },

    ['x'] = { '"_x', desc = 'Void yank x' },

    -----------------------
    -- Maneuvering
    ['<s-h>'] = { '^', desc = 'Go to sol', mode = { 'n', 'v', 'o' } },
    ['<s-l>'] = { '$', desc = 'Go to eol', mode = { 'n', 'v', 'o' } },

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


-- Find and replace/delete selected/under-cusor characters
--NOTE: use vanilla to avoid neovim api bug
vim.cmd [[
    nmap cg* *<s-n>"_cgn
    vmap cg  *<s-n>"_cgn
    nmap dg* *<s-n>"_dgn
    vmap dg  *<s-n>"_dgn
]]

return {}
