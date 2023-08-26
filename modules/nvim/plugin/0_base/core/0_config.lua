vim.scriptencoding   = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.opt.encoding     = 'utf-8'


vim.opt.title       = false -- set false to avoid weird buffer renering with Wezterm terminal
vim.opt.undofile    = true
vim.opt.backup      = false
vim.opt.ignorecase  = true -- case insensitive searching UNLESS /C or capital in search
vim.opt.hlsearch    = true
vim.opt.showcmd     = true
vim.opt.showtabline = 0 -- 0: never, 1: if any, 2: always
vim.opt.timeoutlen  = 500
vim.opt.updatetime  = 100
vim.opt.ttimeoutlen = 5
vim.opt.scrolloff   = 5
vim.opt.shell       = '/bin/fish'
vim.g.shortmess     = 'I' -- Disable intro message
vim.go.cmdheight    = 1


vim.opt.laststatus = 2
vim.opt.inccommand = 'split'

vim.opt.foldlevel  = 99 --: Set default as unfold
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr   = 'nvim_treesitter#foldexpr()'

vim.opt.backupskip = { '/tmp/*', '/private/tmp/*' }
vim.opt.backspace  = { 'start', 'eol', 'indent' }

vim.opt.path:append { '**' }         --: Finding files - Search down into subfolders
vim.opt.wildignore:append { '*/node_modules/*' }
vim.opt.formatoptions:append { 'r' } --: Add asterisks in block comments

--: Disable default file explorer
vim.g.loaded_netrwPlugin    = 1
vim.g.loaded_netrw          = 1
vim.g.theme_switcher_loaded = true




-- Mouse
vim.opt.mouse          = "a"
vim.opt.mousefocus     = true

-- Line Numbers
vim.opt.number         = true
vim.opt.relativenumber = false

-- Splits
vim.opt.splitbelow     = true
vim.opt.splitright     = true

-- Indent Settings
vim.opt.expandtab      = true
vim.opt.smartindent    = true
vim.opt.wrap           = false
vim.opt.autoindent     = true
vim.opt.breakindent    = true
vim.opt.smarttab       = true
vim.opt.shiftwidth     = 4
vim.opt.tabstop        = 4
vim.opt.softtabstop    = 4


-- Completion
vim.opt.completeopt = "menu,menuone,noselect"


-- Fillchars
vim.opt.fillchars = {
    vert = "│",
    fold = "⠀",
    eob = " ", -- suppress ~ at EndOfBuffer
    --diff = "⣿", -- alternatives = ⣿ ░ ─ ╱
    msgsep = "‾",
    foldopen = "▾",
    foldsep = "│",
    foldclose = "▸",
}


-- Prefer ripgrep if it exists
if vim.fn.executable 'rg' == 1 then
    vim.o.grepprg = "rg --hidden --glob '!.git' --no-heading --smart-case --vimgrep --follow $*"
    vim.opt.grepformat = vim.opt.grepformat ^ { "%f:%l:%c:%m" }
end


-- -- Change directory to the current buffer
-- vim.cmd 'autocmd BufEnter * silent! lcd %:p:h'
