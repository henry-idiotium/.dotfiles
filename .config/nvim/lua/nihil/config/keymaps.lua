---@diagnostic disable: no-unknown
---@param opts? vim.keymap.set.Opts
local function map(mode, lhs, rhs, opts)
    opts = vim.tbl_extend('force', { noremap = true, silent = true }, opts or {})
    vim.keymap.set(mode, lhs, rhs, opts)
end

----- Bindings
map('i', 'jj', '<esc>')
map('i', 'jk', '<esc>')
map('c', '<c-q>', '<c-c>')
map('n', '<c-a>', 'gg<s-v><s-g>')
map({ 'n', 'v', 'o' }, '<s-h>', '^')
map({ 'n', 'v', 'o' }, '<s-l>', '$')
map('n', '<c-a>', 'gg<s-v><s-g>')

-- better up/down
map({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
map({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })
map({ 'n', 'v' }, '<c-k>', '5k', { nowait = true })
map({ 'n', 'v' }, '<c-j>', '5j', { nowait = true })

-- highlights under cursor
map('n', '<leader>ui', vim.show_pos, { desc = 'Inspect highlight under cursor' })

-- Better Next/Prev (https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n)
map('n', 'n', [['Nn'[v:searchforward].'zzzv']], { expr = true, desc = 'Next Search Result' })
map('n', 'N', [['nN'[v:searchforward].'zzzv']], { expr = true, desc = 'Prev Search Result' })
map({ 'x', 'o' }, 'n', [['Nn'[v:searchforward].'zz']], { expr = true, desc = 'Next Search Result' })
map({ 'x', 'o' }, 'N', [['nN'[v:searchforward].'zz']], { expr = true, desc = 'Prev Search Result' })

---- Editor
map('n', '<c-q>', function() pcall(vim.cmd.close) end, { desc = 'Close Buffer' })
map('n', 'ZZ', vim.cmd.quitall, { desc = 'Close Session' })
map({ 'i', 'x', 'n', 's' }, '<c-s>', '<cmd>w<cr><esc>', { desc = 'Save File' })

map({ 'n', 'i', 'v' }, '<c-z>', vim.cmd.undo)
map({ 'n', 'i', 'v' }, '<c-y>', vim.cmd.redo)

map('n', 'o', 'o<esc>', { remap = true })
map('n', '<s-o>', '<s-o><esc>', { remap = true })
map('v', 'p', '<s-p>', { remap = true })

map('n', '<a-z>', ':setlocal wrap! <cr>')

map('n', '+', '<c-a>')
map('n', '-', '<c-x>')

map('v', '<', '<gv')
map('v', '>', '>gv')

map('n', '<leader>um', ':delm! | delm a-z <cr>', { desc = 'Clear Marks in Active Buffer' })

map('n', '<leader>sr', [[:%s/\<<c-r><c-w>\>/<c-r><c-w> /gI<c-left><bs>]], { desc = 'Replace Word Under Cursor', silent = false })

-- commands
map('n', '<leader>!x', ':write | !chmod +x %<cr><cmd>e! % <cr>', { silent = true, desc = 'Set File Executable' })

-- folding
map('n', 'z<s-c>', ':setlocal foldlevel=00 <cr>', { desc = 'Min Fold Level' })
map('n', 'z<s-o>', ':setlocal foldlevel=10 <cr>', { desc = 'Max Fold Level' })
map('n', 'zl', ':<c-u>let &l:foldlevel = v:count<cr>', { desc = 'Set Fold Level' })
map('n', 'zi', ':%g/ /norm! zf%<c-left><c-left><bs>', { desc = 'Fold with Pattern', silent = false })

-- register
map({ 'n', 's', 'x' }, 'x', '"_x', { desc = 'Void yank x' })
map({ 'n', 's', 'x', 'o' }, ',', '"_', { desc = 'Void Reigster' })
map({ 'n', 's', 'x', 'o' }, ',s', '"+', { desc = 'System Clipboard Register' })

-- Clear search with <esc>
map({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and Clear hlsearch' })

-- Clear search, diff update and redraw taken from runtime/lua/_editor.lua
map('n', '<leader>ur', ':nohlsearch | diffupdate | normal! <c-l><cr>', { desc = 'Redraw / Clear hlsearch / Diff Update' })
map('n', '<leader>uc', function()
    vim.cmd [[ nohlsearch | diffupdate | redraw ]]
    require('notify').dismiss { silent = true, pending = true }
end, { desc = 'Clear UI Noises', nowait = true })

-- move lines
map('n', '<a-j>', ':m .+1<cr>==', { desc = 'Move Down' })
map('n', '<a-k>', ':m .-2<cr>==', { desc = 'Move Up' })
map('i', '<a-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move Down' })
map('i', '<a-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move Up' })
map('v', '<a-j>', [[:m '>+1<cr>gv=gv]], { desc = 'Move Down' })
map('v', '<a-k>', [[:m '<-2<cr>gv=gv]], { desc = 'Move Up' })
-- duplication
map('i', '<s-a-j>', '<cmd>t.<cr>', { desc = 'Duplicate Line Down' })
map('i', '<s-a-k>', '<cmd>t. | -1<cr>', { desc = 'Duplicate Line Up' })
map('n', '<s-a-j>', '<cmd>t.<cr>', { desc = 'Duplicate Line Down' })
map('n', '<s-a-k>', '<cmd>t.<cr>k', { desc = 'Duplicate Line Up' })
map({ 'v', 's', 'x' }, '<s-a-j>', ":'<,'>t'><cr>gv", { desc = 'Duplicate Lines Down' })
map({ 'v', 's', 'x' }, '<s-a-k>', ":'<,'>t'><cr>gv", { desc = 'Duplicate Lines Up' })

---- Quickfix/Localtion list
map('n', '<leader>xl', ':lopen 4 <cr>', { desc = 'Location List' })
map('n', '<leader>xq', ':copen 4 <cr>', { desc = 'Quickfix List' })

map('n', '[q', ':cprev <cr>', { desc = 'Previous Quickfix' })
map('n', ']q', ':cnext <cr>', { desc = 'Next Quickfix' })

---- Split
map('n', '<c-a-up>', ':resize +1<cr>', { desc = 'Increase Window Height' })
map('n', '<c-a-down>', ':resize -1<cr>', { desc = 'Decrease Window Height' })
map('n', '<c-a-left>', ':vertical resize -1<cr>', { desc = 'Decrease Window Width' })
map('n', '<c-a-right>', ':vertical resize +1<cr>', { desc = 'Increase Window Width' })

---- Tabs
map('n', '<tab>', ':tabnext <cr>', { desc = 'Next Tab' })
map('n', '<s-tab>', ':tabprev <cr>', { desc = 'Prev Tab' })
map('n', '<leader><tab>d', ':tabclose <cr>', { desc = 'Close Tab' })
map('n', '<c-s-right>', ':tabm +1 <cr>', { desc = 'Move Tab Right' })
map('n', '<c-s-left>', ':tabm -1 <cr>', { desc = 'Move Tab Left' })

---- Buffers
map('n', ']b', ':bnext <cr>', { desc = 'Next Buffer' })
map('n', '[b', ':bprevious <cr>', { desc = 'Prev Buffer' })
map('n', '<leader>`', ':b# <cr>', { desc = 'Alternate buffer' })
map('n', '<leader>bd', ':bwipeout <cr>', { desc = 'Delete Buffer' })
map('n', '<leader>b<s-d>', ':%bd | e# <cr>', { desc = 'Delete all buffers except active buffer.' })

---- Providers/Info
map('n', '<leader>mm', ':Lazy <cr>', { desc = 'Lazy Menu' })
map('n', '<leader>ms', ':Mason <cr>', { desc = 'Mason Menu' })
map('n', '<leader>ml', ':LspInfo <cr>', { desc = 'Lsp Info' })
map('n', '<leader>mc', ':ConformInfo <cr>', { desc = 'Conform Info' })

---- Diagnostics
---@param dir 'next'|'prev'
---@param severity? vim.diagnostic.Severity
local function diag_go(dir, severity)
    local go = vim.diagnostic['goto_' .. dir]
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function() go { severity = severity } end
end
map('n', ']d', diag_go 'next', { desc = 'Next diagnostic' })
map('n', '[d', diag_go 'prev', { desc = 'Prev diagnostic' })
map('n', ']e', diag_go('next', 'ERROR'), { desc = 'Next error diagnostic' })
map('n', '[e', diag_go('prev', 'ERROR'), { desc = 'Prev error diagnostic' })
map('n', ']w', diag_go('next', 'WARN'), { desc = 'Next warning diagnostic' })
map('n', '[w', diag_go('prev', 'WARN'), { desc = 'Prev warning diagnostic' })
