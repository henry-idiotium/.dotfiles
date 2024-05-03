local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazypath,
    }
end
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
    spec = 'nihil.plugins',
    change_detection = { notify = false },
    performance = {
        cache = { enabled = true },
        rtp = {
            disabled_plugins = {
                'gzip',
                'matchit',
                'matchparen',
                'netrwPlugin',
                'tarPlugin',
                'tohtml',
                'tutor',
                'zipPlugin',
            },
        },
    },
    ui = {
        border = 'rounded',
        backdrop = 0,
    },
}
