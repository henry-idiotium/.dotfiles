vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1
vim.g.markdown_recommended_style = 0 -- Fix markdown indentation settings
vim.g.neotree_position = 'float' -- float | right

vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.opt.shell = 'fish'
vim.opt.path:append { '**' } -- Finding files - Search down into subfolders
vim.opt.wildignore:append { '*/node_modules/*' }
vim.opt.formatoptions:append { 'r' } -- Add asterisks in block comments
vim.opt.spelllang = { 'en' }
vim.opt.spelloptions:append 'noplainbuffer'
vim.opt.shortmess = 'ltToOCFWIcCm'

vim.opt.undofile = true
vim.opt.backup = false
vim.opt.backupskip = { '/tmp/*', '/private/tmp/*' }

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.ignorecase = true -- case insensitive searching UNLESS /C or capital in search
vim.opt.hlsearch = true
vim.opt.showcmd = true
vim.opt.timeoutlen = 500
vim.opt.showtabline = 1
vim.opt.scrolloff = 6
vim.opt.inccommand = 'split'
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true
vim.opt.winblend = 0
vim.opt.pumblend = 0
vim.opt.pumheight = 7
vim.opt.background = 'dark'
vim.opt.guicursor:append { 'n-i-r:blinkwait700-blinkon500-blinkoff500' }
vim.opt.wildoptions = 'pum'
vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.confirm = true
vim.opt.mouse = 'n'
vim.opt.mousefocus = true
vim.opt.smoothscroll = true
vim.opt.conceallevel = 0
vim.opt.wrap = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.showbreak = ''
vim.opt.linebreak = true
vim.opt.autoindent = true
vim.opt.smartindent = false
vim.opt.breakindent = true
vim.opt.breakindentopt = { 'shift:4', 'min:40', 'sbr' }
vim.opt.backspace = { 'start', 'eol', 'indent' }

vim.opt.foldlevel = 99
vim.opt.foldmethod = 'expr'
vim.opt.foldenable = true
-- vim.opt.foldexpr = [[v:lua.vim.treesitter.foldexpr()]]
vim.opt.foldtext = ''
vim.opt.statuscolumn = [[%!v:lua.require'nihil.util.ui'.statuscolumn()]]
vim.opt.fillchars = { fold = ' ', eob = ' ' }
