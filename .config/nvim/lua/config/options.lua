vim.g.mapleader = ' '
vim.g.shortmess = 'I' -- Disable intro message

vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

vim.opt.number = true -- Line Numbers
vim.opt.relativenumber = false

vim.opt.title = false -- set false to avoid weird buffer renering with Wezterm terminal
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.ignorecase = true -- case insensitive searching UNLESS /C or capital in search
vim.opt.hlsearch = true
vim.opt.showcmd = true
vim.opt.timeoutlen = 500
vim.opt.showtabline = 0 -- 0: never, 1: if any, 2: always
vim.opt.scrolloff = 5
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
vim.opt.winblend = 0
vim.opt.wildoptions = 'pum'
vim.opt.pumblend = 5
vim.opt.background = 'dark'

-- Indent Settings
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.autoindent = true
vim.opt.breakindent = true
vim.opt.smartindent = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = ' '
vim.opt.breakat = ' \t;:,!?'
vim.opt.breakindentopt = { 'shift:4', 'min:40', 'sbr' }

vim.opt.backupskip = { '/tmp/*', '/private/tmp/*' }
vim.opt.backspace = { 'start', 'eol', 'indent' }

vim.opt.path:append { '**' } -- Finding files - Search down into subfolders
vim.opt.wildignore:append { '*/node_modules/*' }
vim.opt.formatoptions:append { 'r' } -- Add asterisks in block comments

-- Undercurl
vim.cmd [[ let &t_Cs = "\e[4:3m" ]]
vim.cmd [[ let &t_Ce = "\e[4:0m" ]]

vim.cmd [[ au BufNewFile,BufRead *.astro setf astro ]]
vim.cmd [[ au BufNewFile,BufRead Podfile setf ruby ]]
