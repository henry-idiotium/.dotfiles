local kb             = nihil.utils.keymap
local map_keys       = kb.map_schema
local map_group_keys = kb.map_schema_group
local unmap_keys     = kb.unmap_schema


vim.g.mapleader = ' '

local function run(cmd) return function() vim.cmd(cmd) end end

unmap_keys {
    '<c-z>', '<c-f>', '<c-n>', '<c-p>',
    'gt', 'g<s-t>',
    's',
    'zj', 'zk',   -- surrounding jump
    '<s-z><s-z>', -- Escapse buffer
    '<c-s-z>',
    '<c-d>', '<c-u>',
    '<up>', '<down>', '<left>', '<right>', -- arrow keys
}

-- editor
map_keys {
    { '<c-q>',     '<c-c>',                   desc = 'Exit command mode',        mode = 'c' },
    { '<c-q>',     run 'QuitPromptIfLast',    desc = 'Quit document savely' },
    { '<c-s>',     run 'write',               desc = 'Save document',            mode = 'ni' },
    { '<c-s-q>',   run 'QuitAllPromptIfLast', desc = 'Quit all documents savely' },

    { '<leader>h', run 'nohl',                desc = 'Turn off search highlight' },
    { '<a-z>',     run 'set wrap!',           desc = 'Toggle text wrap', },
}

-- Split pane
map_keys {
    { '<c-w>v',      '<c-w>v<c-w>w',         desc = 'Split document vertically' },
    { '<c-w><c-v>',  '<c-w><c-v><c-w><c-w>', desc = 'Split document vertically' },
    { '<c-w>s',      '<c-w>s<c-w>w',         desc = 'Split document horizontally' },
    { '<c-w><c-s>',  '<c-w><c-s><c-w><c-w>', desc = 'Split document horizontally' },

    { '<c-a-up>',    '<c-w>+',               desc = 'Resize split document' },
    { '<c-a-down>',  '<c-w>-',               desc = 'Resize split document' },
    { '<c-a-left>',  '<c-w><',               desc = 'Resize split document' },
    { '<c-a-right>', '<c-w>>',               desc = 'Resize split document' },
}

-- editability
map_keys {
    { 'jj',      '<esc>',                     desc = 'Exit insert mode', mode = 'i' },

    { '<c-z>',   '<cmd>undo<cr>',             desc = 'Undo document',    mode = 'niv' },
    { '<c-y>',   '<cmd>redo<cr>',             desc = 'Redo document',    mode = 'niv' },

    { 'o',       'o<esc>0"_<s-d>',            desc = 'New line after' },
    { '<s-o>',   '<s-o><esc>0"_<s-d>',        desc = 'New line before' },

    { '<',       '<gv',                       desc = 'Outdent',          mode = 'v' },
    { '>',       '>gv',                       desc = 'Indent',           mode = 'v' },

    { '+',       '<c-a>',                     desc = 'Increment' },
    { '-',       '<c-x>',                     desc = 'Decrement' },

    -- Move/copy lines
    { '<a-j>',   '<cmd>m +1<cr>',             desc = 'Move line down',   mode = 'ni' },
    { '<a-k>',   '<cmd>m -2<cr>',             desc = 'Move line up',     mode = 'ni' },
    { '<a-j>',   ":m '>+1<cr>gv",             desc = 'Move lines down',  mode = 'v' },
    { '<a-k>',   ":m '<-2<cr>gv",             desc = 'Move lines up',    mode = 'v' },
    { '<s-a-j>', "<s-v>:'<,'>t'><cr>gv<esc>", desc = 'Duplicate lines' },
    { '<s-a-j>', ":'<,'>t'><cr>gv",           desc = 'Duplicate lines',  mode = 'v' },

    -- Avoid copy on paste in Visual mode
    { 'p',       '<s-p>',                     desc = 'Paste',            mode = 'v' },

    { 'x',       '"_x',                       desc = 'Void yank x' },
}


-- Maneuvering
map_keys {
    { '<c-j>',   '5j',              desc = 'Go down 5 lines',   mode = 'nv' },
    { '<c-k>',   '5k',              desc = 'Go up 5 lines',     mode = 'nv' },

    { '<s-h>',   '^',               desc = 'Go to sol',         mode = 'nvo' },
    { '<s-l>',   '$',               desc = 'Go to eol',         mode = 'nvo' },

    { '<tab>',   run 'tabnext',     desc = 'Go to next tab' },
    { '<s-tab>', run 'tabprevious', desc = 'Go to previous tab' },
}

-- Macros
map_keys {
    { ',',   '@@',           desc = 'Run saved macro' },
    { '\\a', 'gg<s-v><s-g>', desc = 'Select whole document' },
}

map_group_keys({ prefix = '<c-w>', desc = 'Split document' }, {
    { 'v',     '<c-w>v<c-w>w',         desc = 'Split document vertically' },
    { '<c-v>', '<c-w><c-v><c-w><c-w>', desc = 'Split document vertically' },
    { 's',     '<c-w>s<c-w>w',         desc = 'Split document horizontally' },
    { '<c-s>', '<c-w><c-s><c-w><c-w>', desc = 'Split document horizontally' },
})

map_group_keys({ prefix = ';', mode = 'nv', desc = 'Void yanks' }, {
    { 'd',     '"_d',     desc = 'Void yank d' },
    { 'c',     '"_c',     desc = 'Void yank c' },
    { 'x',     '"_x',     desc = 'Void yank x' },
    { 's',     '"_s',     desc = 'Void yank s' },
    { '<s-d>', '"_<s-d>', desc = 'Void yank D' },
    { '<s-c>', '"_<s-c>', desc = 'Void yank C' },
})
