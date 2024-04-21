---@diagnostic disable: no-unknown
local map = function(mode, lhs, rhs, opts)
    opts = vim.tbl_extend('force', { noremap = true, silent = true }, opts or {})
    vim.keymap.set(mode, lhs, rhs, opts)
end

----- Unbindings
map('n', 'ZZ', '<nop>')

----- Bindings
map('i', 'jj', '<esc>')
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

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next Search Result' })
map('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
map('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
map('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev Search Result' })
map('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })
map('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })

-- highlights under cursor
map('n', '<leader>ui', vim.show_pos, { desc = 'Inspect Pos' })

---- Editor
map('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit All' })
map({ 'i', 'x', 'n', 's' }, '<c-s>', '<cmd>w<cr><esc>', { desc = 'Save File' })

map({ 'n', 's', 'x', 'o' }, ',', '"_', { desc = 'Void yank' })

map({ 'n', 'i', 'v' }, '<c-z>', '<cmd>undo<cr>')
map({ 'n', 'i', 'v' }, '<c-y>', '<cmd>redo<cr>')

map('n', 'o', 'o<esc>')
map('n', '<s-o>', '<s-o><esc>')
map('v', 'p', '<s-p>') -- Avoid copy on paste in Visual mode

map('n', '<a-z>', '<cmd>set wrap!<cr>')

map('n', '+', '<c-a>')
map('n', '-', '<c-x>')

map('x', '<leader>p', '"_dP')
map({ 'n', 'v' }, ',y', '"+y', { desc = 'Copy to system clipboard' })
map('n', ',<s-y>', '"+Y')

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
map('n', '<leader>xl', vim.cmd.lopen, { desc = 'Location List' })
map('n', '<leader>xq', vim.cmd.copen, { desc = 'Quickfix List' })

map('n', '[q', vim.cmd.cprev, { desc = 'Previous Quickfix' })
map('n', ']q', vim.cmd.cnext, { desc = 'Next Quickfix' })

---- Split
-- Resize window using <ctrl> arrow keys
map('n', '<c-a-up>', '<cmd>resize +2<cr>', { desc = 'Increase Window Height' })
map('n', '<c-a-down>', '<cmd>resize -2<cr>', { desc = 'Decrease Window Height' })
map('n', '<c-a-left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease Window Width' })
map('n', '<c-a-right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase Window Width' })

---- Tab
map('n', '<tab>', vim.cmd.tabnext, { desc = 'Next Tab' })
map('n', '<s-tab>', vim.cmd.tabprev, { desc = 'Prev Tab' })
map('n', '<leader><tab>d', vim.cmd.tabclose, { desc = 'Close Tab' })

---- Buffers
map('n', '<leader><tab>', vim.cmd.bnext, { desc = 'Next Buffer' })
map('n', '<leader><s-tab>', vim.cmd.bprevious, { desc = 'Prev Buffer' })
map('n', ']b', vim.cmd.bnext, { desc = 'Next Buffer' })
map('n', '[b', vim.cmd.bprevious, { desc = 'Prev Buffer' })
map('n', '<leader>`', '<cmd>b#<cr>', { desc = 'Alternative buffer' })

---- Others
if vim.cmd.Lazy ~= nil then map('n', '<leader>l', vim.cmd.Lazy, { desc = 'Lazy' }) end

---- Diagnostics
local diagnostic_goto = function(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function() go { severity = severity } end
end
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = '[LSP] Line diagnostics' })
map('n', ']d', diagnostic_goto(true), { desc = '[LSP] Next diagnostic' })
map('n', '[d', diagnostic_goto(false), { desc = '[LSP] Prev diagnostic' })
map('n', ']e', diagnostic_goto(true, 'ERROR'), { desc = '[LSP] Next error diagnostic' })
map('n', '[e', diagnostic_goto(false, 'ERROR'), { desc = '[LSP] Prev error diagnostic' })
map('n', ']w', diagnostic_goto(true, 'WARN'), { desc = '[LSP] Next warning diagnostic' })
map('n', '[w', diagnostic_goto(false, 'WARN'), { desc = '[LSP] Prev warning diagnostic' })
