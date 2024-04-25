---@diagnostic disable: no-unknown
local function map(mode, lhs, rhs, opts)
    opts = vim.tbl_extend('force', { noremap = true, silent = true }, opts or {})
    vim.keymap.set(mode, lhs, rhs, opts)
end

----- Unbindings
map('n', 'ZZ', '<nop>')
map('n', '<c-w>q', '<nop>')

----- Bindings
map('i', 'jj', '<esc>')
map('i', 'jk', '<esc>')
map('c', '<c-q>', '<c-c>')
map('n', '<c-a>', 'gg<s-v><s-g>')
map({ 'n', 'v', 'o' }, '<s-h>', '^')
map({ 'n', 'v', 'o' }, '<s-l>', '$')
map('n', '<c-a>', 'gg<s-v><s-g>')

-- better up/down
map({ 'n', 'v' }, '<c-k>', '5k')
map({ 'n', 'v' }, '<c-j>', '5j')
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- remap builtin f nav
map({ 'n', 's', 'x', 'o' }, '<a-,>', ',')
map({ 'n', 's', 'x', 'o' }, '<a-;>', ';')

-- highlights under cursor
map('n', '<leader>ui', vim.show_pos, { desc = 'Inspect highlight under cursor' })

---- Editor
map('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit All' })
map({ 'i', 'x', 'n', 's' }, '<c-s>', '<cmd>w<cr><esc>', { desc = 'Save File' })

map({ 'n', 's', 'x' }, 'x', '"_x', { desc = 'Void yank x' })
map({ 'n', 's', 'x', 'o' }, ',', '"_', { desc = 'Void yank' })

map({ 'n', 'i', 'v' }, '<c-z>', '<cmd>undo<cr>')
map({ 'n', 'i', 'v' }, '<c-y>', '<cmd>redo<cr>')

map('n', 'o', 'o<esc>')
map('n', '<s-o>', '<s-o><esc>')
map('v', 'p', '<s-p>') -- Avoid copy on paste in Visual mode

map('n', '<a-z>', '<cmd>set wrap!<cr>')

map('n', '+', '<c-a>')
map('n', '-', '<c-x>')

-- better remap
map({ 'n', 's', 'x', 'o' }, '<a-p>', '"+p', { desc = 'Paste from system clipboard' })
map({ 'n', 's', 'x', 'o' }, '<a-y>', '"+y', { desc = 'Copy to system clipboard' })
map({ 'n', 's', 'x', 'o' }, '<a-s-y>', '"+<s-y>', { desc = 'Copy to system clipboard' })

-- Clear search with <esc>
map({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and Clear hlsearch' })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map('n', '<leader>ur', '<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>', { desc = 'Redraw / Clear hlsearch / Diff Update' })

-- move lines
map('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move Down' })
map('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move Up' })
map('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move Down' })
map('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move Up' })
map('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move Down' })
map('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move Up' })

-- duplication
map('n', '<s-a-j>', "<s-v>:'<,'>t'><cr>gv<esc>")
map('n', '<s-a-k>', "<s-v>:'<,'>t'><cr>gv<esc>")
map('v', '<s-a-j>', ":'<,'>t'><cr>gv")
map('v', '<s-a-k>', ":'<,'>t'><cr>gv")

-- indent
map('v', '<', '<gv')
map('v', '>', '>gv')
map('n', 'z<s-c>', ':set foldlevel=00<cr>')
map('n', 'z<s-o>', ':set foldlevel=99<cr>')

---- Quickfix/Localtion list
map('n', '<leader>xl', '<cmd>lopen<cr>', { desc = 'Location List' })
map('n', '<leader>xq', '<cmd>copen<cr>', { desc = 'Quickfix List' })

map('n', '[q', '<cmd>cprev<cr>', { desc = 'Previous Quickfix' })
map('n', ']q', '<cmd>cnext<cr>', { desc = 'Next Quickfix' })

---- Split
-- Resize window using <ctrl> arrow keys
map('n', '<c-s-up>', '<cmd>resize +2<cr>', { desc = 'Increase Window Height' })
map('n', '<c-s-down>', '<cmd>resize -2<cr>', { desc = 'Decrease Window Height' })
map('n', '<c-s-left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease Window Width' })
map('n', '<c-s-right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase Window Width' })

---- Tab
map('n', '<tab>', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
map('n', '<s-tab>', '<cmd>tabprev<cr>', { desc = 'Prev Tab' })
map('n', '<leader><tab>d', '<cmd>tabclose<cr>', { desc = 'Close Tab' })
map('n', '<leader><tab>n', '<cmd>tabnew<cr>', { desc = 'New Tab' })

---- Buffers
map('n', ']b', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
map('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
map('n', '<leader>`', '<cmd>b#<cr>', { desc = 'Alternate buffer' })
map('n', '<leader>bd', '<cmd>bwipeout<cr>', { desc = 'Delete buffer from list' })

---- Others
map('n', '<leader>ol', '<cmd>Lazy<cr>', { desc = 'Lazy' })
map('n', '<leader>om', '<cmd>Mason<cr>', { desc = 'Mason' })

---- Diagnostics
---@param dir 'next'|'prev'
---@param severity? vim.diagnostic.Severity
local diagnostic_goto = function(dir, severity)
    local go = vim.diagnostic['goto_' .. dir]
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function() go { severity = severity } end
end
map('n', ']d', diagnostic_goto 'next', { desc = 'Next diagnostic' })
map('n', '[d', diagnostic_goto 'prev', { desc = 'Prev diagnostic' })
map('n', ']e', diagnostic_goto('next', 'ERROR'), { desc = 'Next error diagnostic' })
map('n', '[e', diagnostic_goto('prev', 'ERROR'), { desc = 'Prev error diagnostic' })
map('n', ']w', diagnostic_goto('next', 'WARN'), { desc = 'Next warning diagnostic' })
map('n', '[w', diagnostic_goto('prev', 'WARN'), { desc = 'Prev warning diagnostic' })
