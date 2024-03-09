local set = vim.keymap.set
local nomap = function(key, mode) set(mode or { 'n', 'v', 'i', 'x' }, key, '<nop>', { remap = true }) end

----- Unbindings
nomap '<s-z><s-z>'

----- Bindings
local Util = require 'lazyvim.util'
local dopts = { noremap = true, silent = true } -- default options
local eopts = function(opts) return vim.tbl_extend('force', dopts, opts) end -- overwrite/extend default options

set('i', 'jj', '<esc>', dopts)
set({ 'n', 'v' }, '<c-k>', '5k', dopts)
set({ 'n', 'v' }, '<c-j>', '5j', dopts)
set('c', '<c-q>', '<c-c>', dopts)
set({ 'n', 'v', 'o' }, '<s-h>', '^', dopts)
set({ 'n', 'v', 'o' }, '<s-l>', '$', dopts)

---- Editor
set({ 'n', 'i', 'v' }, '<c-z>', '<cmd>undo<cr>', dopts)
set({ 'n', 'i', 'v' }, '<c-y>', '<cmd>redo<cr>', dopts)

set('n', 'o', 'o<esc>', dopts)
set('n', '<s-o>', '<s-o><esc>', dopts)
set('v', 'p', '<s-p>', dopts) -- Avoid copy on paste in Visual mode

-- formatting
set({ 'n', 'v' }, '<a-s-f>', function() Util.format { force = true } end, dopts)

-- move lines
set({ 'n', 'i' }, '<a-j>', '<cmd>m +1<cr>', dopts)
set({ 'n', 'i' }, '<a-k>', '<cmd>m -2<cr>', dopts)
set('v', '<a-j>', ":m '>+1<cr>gv", dopts)
set('v', '<a-k>', ":m '<-2<cr>gv", dopts)

-- indent
set('v', '<', '<gv', dopts)
set('v', '>', '>gv', dopts)
set('n', '+', '<c-a>', dopts)
set('n', '-', '<c-x>', dopts)
set('n', 'z<s-c>', 'set foldlevel=00', dopts)
set('n', 'z<s-o>', 'set foldlevel=99', dopts)

-- duplication
set('n', '<s-a-j>', "<s-v>:'<,'>t'><cr>gv<esc>", dopts)
set('n', '<s-a-k>', "<s-v>:'<,'>t'><cr>gv<esc>", dopts)
set('v', '<s-a-j>', ":'<,'>t'><cr>gv", dopts)
set('v', '<s-a-k>', ":'<,'>t'><cr>gv", dopts)

-- Void yanks
set('n', 'x', '"_x')
set('n', ';<s-d>', '"_<s-d>', eopts { desc = 'Void delete D' })
set('n', ';<s-c>', '"_<s-c>', eopts { desc = 'Void delete C' })
set({ 'n', 'v' }, ';d', '"_d', eopts { desc = 'Void delete d' })
set({ 'n', 'v' }, ';c', '"_c', eopts { desc = 'Void delete c' })
set({ 'n', 'v' }, ';x', '"_x', eopts { desc = 'Void delete x' })

---- Tab
set('n', '<a-z>', ':set wrap!<cr>')
set('n', '<c-a-up>', '<c-w>+')
set('n', '<c-a-down>', '<c-w>-')
set('n', '<c-a-left>', '<c-w><')
set('n', '<c-a-right>', '<c-w>>')

set('n', ',', '@@', eopts { noremap = false, remap = true })
set('n', '<c-a>', 'gg<s-v><s-g>', dopts)

-- find and replace/delete selected/under-cusor characters
set('n', 'cgw', '*<s-n>cgn', eopts { remap = true, desc = 'Find and replace' })
set('n', 'dgw', '*<s-n>dgn', eopts { remap = true, desc = 'Find and replace' })
set('v', 'cg', '*<s-n>cgn', eopts { remap = true, desc = 'Find and replace' })
set('v', 'dg', '*<s-n>dgn', eopts { remap = true, desc = 'Find and replace' })
set('n', ';cgw', '*<s-n>"_cgn', eopts { remap = true, desc = 'Find and replace' })
set('n', ';dgw', '*<s-n>"_dgn', eopts { remap = true, desc = 'Find and replace' })
set('v', ';cg', '*<s-n>"_cg', eopts { remap = true, desc = 'Find and replace' })
set('v', ';dg', '*<s-n>"_dgn', eopts { remap = true, desc = 'Find and replace' })
