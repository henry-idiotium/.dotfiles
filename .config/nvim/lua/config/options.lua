vim.g.mapleader = ' '

vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

vim.opt.number = true
vim.opt.relativenumber = false

vim.opt.undofile = true
vim.opt.backup = false
vim.opt.ignorecase = true -- case insensitive searching UNLESS /C or capital in search
vim.opt.hlsearch = true
vim.opt.showcmd = true
vim.opt.timeoutlen = 500
vim.opt.showtabline = 0
vim.opt.scrolloff = 6
vim.opt.laststatus = 2
vim.opt.shell = 'fish'
vim.opt.inccommand = 'split'
vim.opt.mouse = 'n'
vim.opt.mousefocus = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'
vim.opt.termguicolors = true
vim.opt.wildoptions = 'pum'
vim.opt.winblend = 0
vim.opt.pumblend = 5
vim.opt.background = 'dark'
vim.opt.conceallevel = 0

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.showbreak = ''
vim.opt.linebreak = true
vim.opt.autoindent = true
vim.opt.breakindent = true
vim.opt.smartindent = false
vim.opt.breakindent = true
vim.opt.breakindentopt = { 'shift:4', 'min:40', 'sbr' }

vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

vim.opt.backupskip = { '/tmp/*', '/private/tmp/*' }
vim.opt.backspace = { 'start', 'eol', 'indent' }

vim.opt.path:append { '**' } -- Finding files - Search down into subfolders
vim.opt.wildignore:append { '*/node_modules/*' }
vim.opt.formatoptions:append { 'r' } -- Add asterisks in block comments
