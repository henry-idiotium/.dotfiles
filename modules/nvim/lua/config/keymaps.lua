local map = vim.keymap.set

----- Unbindings
local all_modes = { 'i', 'x', 'n', 's' }
local function disable_keymap(key, modes) pcall(map, modes or all_modes, key, '<Nop>', { remap = true }) end
local function del_keymap(key) pcall(vim.keymap.del, all_modes, key) end

disable_keymap '<s-z><s-z>'
disable_keymap('zj', { 'n', 'v' })
disable_keymap('zk', { 'n', 'v' })
disable_keymap '<c-b>'
disable_keymap '<c-f>'
del_keymap '<leader>cf'
del_keymap '<leader>ww'
del_keymap '<leader>wd'
del_keymap '<leader>w-'
del_keymap '<leader>w|'
del_keymap '<leader>-'
del_keymap '<leader>|'

----- Bindings
local Util = require 'lazyvim.util'
local opts = { noremap = true, silent = true }

map('i', 'jj', '<esc>', opts)
map({ 'n', 'v' }, '<c-k>', '5k', opts)
map({ 'n', 'v' }, '<c-j>', '5j', opts)
map('c', '<c-q>', '<c-c>', opts)
map({ 'n', 'v', 'o' }, '<s-h>', '^', opts)
map({ 'n', 'v', 'o' }, '<s-l>', '$', opts)

---- Editor
map({ 'n', 'i', 'v' }, '<c-z>', '<cmd>undo<cr>', opts)
map({ 'n', 'i', 'v' }, '<c-y>', '<cmd>redo<cr>', opts)

map('n', 'o', 'o<esc>', opts)
map('n', '<s-o>', '<s-o><esc>', opts)
map('v', 'p', '<s-p>', opts) -- Avoid copy on paste in Visual mode

-- formatting
map({ 'n', 'v' }, '<a-s-f>', function() Util.format { force = true } end, opts)

-- move lines
map({ 'n', 'i' }, '<a-j>', '<cmd>m +1<cr>', opts)
map({ 'n', 'i' }, '<a-k>', '<cmd>m -2<cr>', opts)
map('v', '<a-j>', ":m '>+1<cr>gv", opts)
map('v', '<a-k>', ":m '<-2<cr>gv", opts)

-- indent
map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)
map('n', '+', '<c-a>', opts)
map('n', '-', '<c-x>', opts)
map('n', 'z<s-c>', 'set foldlevel=00', opts)
map('n', 'z<s-o>', 'set foldlevel=99', opts)

-- duplication
map('n', '<s-a-j>', "<s-v>:'<,'>t'><cr>gv<esc>", opts)
map('n', '<s-a-k>', "<s-v>:'<,'>t'><cr>gv<esc>", opts)
map('v', '<s-a-j>', ":'<,'>t'><cr>gv", opts)
map('v', '<s-a-k>', ":'<,'>t'><cr>gv", opts)

-- Void yanks
map('n', 'x', '"_x')
map({ 'n', 'v' }, ';d', '"_d', opts)
map({ 'n', 'v' }, ';c', '"_c', opts)
map({ 'n', 'v' }, ';x', '"_x', opts)
map({ 'n', 'v' }, ';<s-d>', '"_<s-d>', opts)
map({ 'n', 'v' }, ';<s-c>', '"_<s-c>', opts)

---- Tab
map('n', '<a-z>', ':set wrap!<cr>')
map('n', '<c-a-up>', '<c-w>+')
map('n', '<c-a-down>', '<c-w>-')
map('n', '<c-a-left>', '<c-w><')
map('n', '<c-a-right>', '<c-w>>')

map('n', ',', '@@', vim.tbl_extend('keep', opts, { remap = true }))
map('n', '<c-a>', 'gg<s-v><s-g>', opts)

-- find and replace/delete selected/under-cusor characters
map('n', 'cgw', '*<s-n>"_cgn', { remap = true })
map('v', 'cg', '*<s-n>cgn', { remap = true })
map('n', 'dgw', '*<s-n>"_dgn', { remap = true })
map('v', 'dg', '*<s-n>dgn', { remap = true })

-- Diagnostics
-- map('n', '<leader>]d', vim.diagnostic.goto_next, opts)
-- map('n', '<leader>[d', vim.diagnostic.goto_prev, opts)
