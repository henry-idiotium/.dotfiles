vim.scriptencoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.opt.encoding = 'utf-8'

vim.opt.title = false -- set false to avoid weird buffer renering with Wezterm terminal
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.ignorecase = true -- case insensitive searching UNLESS /C or capital in search
vim.opt.hlsearch = true
vim.opt.showcmd = true
vim.opt.showtabline = 0 -- 0: never, 1: if any, 2: always
vim.opt.timeoutlen = 500
vim.opt.scrolloff = 5
vim.opt.shell = '/bin/fish'
vim.g.shortmess = 'I' -- Disable intro message
vim.go.cmdheight = 1
vim.go.viminfofile = ''
vim.go.viminfo = ''

vim.opt.laststatus = 2
vim.opt.inccommand = 'split'

vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'
vim.opt.termguicolors = true
vim.opt.winblend = 0
vim.opt.wildoptions = 'pum'
vim.opt.pumblend = 5
vim.opt.background = 'dark'

vim.opt.backupskip = { '/tmp/*', '/private/tmp/*' }
vim.opt.backspace = { 'start', 'eol', 'indent' }

vim.opt.path:append { '**' } -- Finding files - Search down into subfolders
vim.opt.wildignore:append { '*/node_modules/*' }
vim.opt.formatoptions:append { 'r' } -- Add asterisks in block comments

-- Mouse
vim.opt.mouse = 'a'
vim.opt.mousefocus = true

-- Line Numbers
vim.opt.number = true
vim.opt.relativenumber = false

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Indent Settings
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.autoindent = true
vim.opt.breakindent = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- Undercurl
vim.cmd [[ let &t_Cs = "\e[4:3m" ]]
vim.cmd [[ let &t_Ce = "\e[4:0m" ]]

vim.cmd [[ au BufNewFile,BufRead *.astro setf astro ]]
vim.cmd [[ au BufNewFile,BufRead Podfile setf ruby ]]
