local set = function(mode, lhs, rhs, opts)
    opts = vim.tbl_extend('force', { noremap = true, silent = true }, opts or {})
    vim.keymap.set(mode, lhs, rhs, opts)
end

----- Unbindings
set('n', 'ZZ', '<nop>')

----- Bindings
set('i', 'jj', '<esc>')
set('c', '<c-q>', '<c-c>')
set('n', '<c-a>', 'gg<s-v><s-g>')
set({ 'n', 'v' }, '<c-k>', '5k')
set({ 'n', 'v' }, '<c-j>', '5j')
set({ 'n', 'v', 'o' }, '<s-h>', '^')
set({ 'n', 'v', 'o' }, '<s-l>', '$')
set('n', '<c-a>', 'gg<s-v><s-g>')
set('n', '<c-s-p>', '6j')
set('n', '<leader>uu', vim.cmd.UndotreeToggle)

---- Editor
set({ 'n', 'i', 'v' }, '<c-z>', '<cmd>undo<cr>')
set({ 'n', 'i', 'v' }, '<c-y>', '<cmd>redo<cr>')

set('n', 'o', 'o<esc>')
set('n', '<s-o>', '<s-o><esc>')
set('v', 'p', '<s-p>') -- Avoid copy on paste in Visual mode

-- move lines
set({ 'n', 'i' }, '<a-j>', '<cmd>m +1<cr>')
set({ 'n', 'i' }, '<a-k>', '<cmd>m -2<cr>')
set('v', '<a-j>', ":m '>+1<cr>gv")
set('v', '<a-k>', ":m '<-2<cr>gv")

-- duplication
set('n', '<s-a-j>', "<s-v>:'<,'>t'><cr>gv<esc>")
set('n', '<s-a-k>', "<s-v>:'<,'>t'><cr>gv<esc>")
set('v', '<s-a-j>', ":'<,'>t'><cr>gv")
set('v', '<s-a-k>', ":'<,'>t'><cr>gv")

-- indent
set('v', '<', '<gv')
set('v', '>', '>gv')
set('n', 'z<s-c>', '<cmd>set foldlevel=00<cr>')
set('n', 'z<s-o>', '<cmd>set foldlevel=99<cr>')

-- Void yanks
set('n', 'x', '"_x')
set({ 'n', 's', 'x', 'o' }, ',', '"_', { desc = 'Void' })

---- Tab
set('n', '<a-z>', ':set wrap!<cr>')
set('n', '<c-a-up>', '<c-w>+')
set('n', '<c-a-down>', '<c-w>-')
set('n', '<c-a-left>', '<c-w><')
set('n', '<c-a-right>', '<c-w>>')
