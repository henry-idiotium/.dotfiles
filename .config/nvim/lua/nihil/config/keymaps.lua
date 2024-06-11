---@diagnostic disable: no-unknown
---@param args ReolveRawKeymapOpts
local function map(args)
    local mode, lhs, rhs, opts = Nihil.utils.key.resolve_raw_keymap_opts(args)
    opts.silent = opts.silent ~= false
    opts.noremap = opts.noremap ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
end

vim.keymap.set('n', 'K', '<nop>')

----- Bindings
map { 'jj', '<esc>', mode = 'i' }
map { 'jk', '<esc>', mode = 'i' }
map { '<c-q>', '<c-c>', mode = 'c' }
map { '<c-a>', 'gg<s-v><s-g>' }
map { 'H', '^', mode = { 'n', 'v', 'o' } }
map { 'L', '$', mode = { 'n', 'v', 'o' } }

-- better up/down
map { 'j', [[v:count == 0 ? 'gj' : 'j']], mode = { 'n', 'x' }, expr = true }
map { 'k', [[v:count == 0 ? 'gk' : 'k']], mode = { 'n', 'x' }, expr = true }
map { '<c-k>', '5k', mode = { 'n', 'v' }, nowait = true }
map { '<c-j>', '5j', mode = { 'n', 'v' }, nowait = true }

-- highlights under cursor
map { '<leader>ui', vim.show_pos, desc = 'Inspect highlight under cursor' }

-- Better Next/Prev (https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n)
map { 'n', [['Nn'[v:searchforward].'zzzv']], expr = true, desc = 'Next Search Result' }
map { 'N', [['nN'[v:searchforward].'zzzv']], expr = true, desc = 'Prev Search Result' }
map { 'n', [['Nn'[v:searchforward].'zz']], mode = { 'x', 'o' }, expr = true, desc = 'Next Search Result' }
map { 'N', [['nN'[v:searchforward].'zz']], mode = { 'x', 'o' }, expr = true, desc = 'Prev Search Result' }

---- Editor
map { '<c-q>', function() pcall(vim.cmd.close) end, desc = 'Close Buffer' }
map { 'ZZ', vim.cmd.quitall, desc = 'Close Session' }
map { '<c-s>', '<cmd>w<cr><esc>', mode = { 'i', 'x', 'n', 's' }, desc = 'Save File' }

map { '<c-z>', vim.cmd.undo, mode = { 'n', 'i', 'v' } }
map { '<c-y>', vim.cmd.redo, mode = { 'n', 'i', 'v' } }

map { 'o', 'o<esc>', remap = true, desc = 'Open Line' }
map { 'O', 'O<esc>', remap = true, desc = 'Open Line Above' }
map { 'p', 'P', remap = true, mode = 'v', desc = 'Paste Line' }

map { '<a-z>', ':setlocal wrap! <cr>', desc = 'Toggle Wrap' }

map { '+', '<c-a>', mode = { 'n', 'v' }, desc = 'Increase Number' }
map { '-', '<c-x>', mode = { 'n', 'v' }, desc = 'Decrease Number' }

map { '<', '<gv', mode = 'v', desc = 'Indent' }
map { '>', '>gv', mode = 'v', desc = 'Unindent' }

map { '<leader>um', ':delm! | delm a-z <cr>', desc = 'Clear Marks in Active Buffer' }

map { '<leader>sr', [[:%s/\<<c-r><c-w>\>/<c-r><c-w> /gc<c-left><bs>]], desc = 'Replace Word Under Cursor', silent = false }

-- commands
map { '<leader>!x', ':write | !chmod +x %<cr><cmd>e! % <cr>', desc = 'Set File Executable' }

-- folding
map { 'zC', ':setlocal foldlevel=00 <cr>', desc = 'Min Fold Level' }
map { 'zO', ':setlocal foldlevel=60 <cr>', desc = 'Max Fold Level' }
map { 'zl', ':<c-u>let &l:foldlevel = v:count<cr>', desc = 'Set Fold Level' }
map { 'zi', ':%g/ /norm! zf%<c-left><c-left><bs>', desc = 'Fold with Pattern', silent = false }

-- register
map { 'x', '"_x', mode = { 'n', 's', 'x' }, desc = 'Void yank x' }
map { ',', '"_', mode = { 'n', 's', 'x', 'o' }, desc = 'Void Reigster' }
map { ',s', '"+', mode = { 'n', 's', 'x', 'o' }, desc = 'System Clipboard Register' }

-- Clear search, diff update and redraw
map {
    '<leader>uc',
    function()
        require('notify').dismiss { silent = true, pending = true }
        vim.cmd [[
            nohlsearch     " Clear the search highlighting
            diffupdate     " Redraw the screen
            redraw         " Update the diff highlighting and folds.
            NoiceDismiss   " Clear noice mini view
        ]]
    end,
    desc = 'Clear UI Noises',
    nowait = true,
}

-- move lines
map { '<a-j>', ':m .+1<cr>==', desc = 'Move Down' }
map { '<a-k>', ':m .-2<cr>==', desc = 'Move Up' }
map { '<a-j>', '<esc><cmd>m .+1<cr>==gi', mode = 'i', desc = 'Move Down' }
map { '<a-k>', '<esc><cmd>m .-2<cr>==gi', mode = 'i', desc = 'Move Up' }
map { '<a-j>', [[:m '>+1<cr>gv=gv]], mode = 'v', desc = 'Move Down' }
map { '<a-k>', [[:m '<-2<cr>gv=gv]], mode = 'v', desc = 'Move Up' }
-- duplication
map { '<s-a-j>', '<cmd>t. <cr>', desc = 'Duplicate Lines Down' }
map { '<s-a-k>', '<cmd>t. <cr>k', desc = 'Duplicate Lines Up' }
map { '<s-a-j>', '<cmd>t. <cr>', mode = 'i', desc = 'Duplicate Line Down' }
map { '<s-a-k>', '<cmd>t. | -1 <cr>', mode = 'i', desc = 'Duplicate Line Up' }
map { '<s-a-j>', ":'<,'>t'><cr>gv", mode = { 'v', 's', 'x' }, desc = 'Duplicate Lines Down' }
map { '<s-a-k>', ":'<,'>t'><cr>gv", mode = { 'v', 's', 'x' }, desc = 'Duplicate Lines Up' }

---- Quickfix/Localtion list
map { '<leader>xL', ':lopen <cr>', desc = 'Location List' }
map { '<leader>xQ', ':copen <cr>', desc = 'Quickfix List' }

map { '[q', ':cprev <cr>', desc = 'Previous Quickfix' }
map { ']q', ':cnext <cr>', desc = 'Next Quickfix' }

---- Split
map { '<c-a-up>', ':resize +1 <cr>', desc = 'Increase Window Height' }
map { '<c-a-down>', ':resize -1 <cr>', desc = 'Decrease Window Height' }
map { '<c-a-left>', ':vertical resize -1 <cr>', desc = 'Decrease Window Width' }
map { '<c-a-right>', ':vertical resize +1 <cr>', desc = 'Increase Window Width' }

---- Tabs
map { '<tab>', ':tabnext <cr>', desc = 'Next Tab' }
map { '<s-tab>', ':tabprev <cr>', desc = 'Prev Tab' }
map { '<leader><tab>d', ':tabclose <cr>', desc = 'Close Tab' }
map { '<c-s-right>', ':tabm +1 <cr>', desc = 'Move Tab Right' }
map { '<c-s-left>', ':tabm -1 <cr>', desc = 'Move Tab Left' }

---- Buffers
map { ']b', ':bnext <cr>', desc = 'Next Buffer' }
map { '[b', ':bprevious <cr>', desc = 'Prev Buffer' }
map { '<leader>`', ':b# <cr>', desc = 'Alternate buffer' }
map { '<leader>bd', ':bwipeout <cr>', desc = 'Delete Buffer' }
map { '<leader>b<s-d>', ':%bd | e# <cr>', desc = 'Delete all buffers except active buffer.' }

---- Providers/Info
map { '<leader>mm', '<cmd>Lazy <cr>', desc = 'Lazy Menu' }
map { '<leader>ms', '<cmd>Mason <cr>', desc = 'Mason Menu' }
map { '<leader>ml', '<cmd>LspInfo <cr>', desc = 'Lsp Info' }
map { '<leader>mc', '<cmd>ConformInfo <cr>', desc = 'Conform Info' }

---- Diagnostics
---@param dir 'next'|'prev'
---@param severity? vim.diagnostic.Severity
local function diag_go(dir, severity)
    local go = vim.diagnostic['goto_' .. dir]
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function() go { severity = severity } end
end
map { ']d', diag_go 'next', desc = 'Next diagnostic' }
map { '[d', diag_go 'prev', desc = 'Prev diagnostic' }
map { ']e', diag_go('next', 'ERROR'), desc = 'Next error diagnostic' }
map { '[e', diag_go('prev', 'ERROR'), desc = 'Prev error diagnostic' }
map { ']w', diag_go('next', 'WARN'), desc = 'Next warning diagnostic' }
map { '[w', diag_go('prev', 'WARN'), desc = 'Prev warning diagnostic' }
