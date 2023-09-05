---@diagnostic disable: undefined-field
-- Init Lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        'https://github.com/folke/lazy.nvim.git',
        '--filter=blob:none',
        '--branch=stable', -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = ' ' --note: required for lazy.nvim to work poperly

-- -------------------------
-- ------

local BASE_MODULE = 'nihil'

local M = {}

---@type fun(config: table, options?: table)
M.setup = require('lazy').setup

---@param modules table
function M.parse_modules(modules)
    local result = {}
    for _, module in ipairs(modules) do
        table.insert(result, {
            import = BASE_MODULE .. '.' .. module,
        })
    end
    return result
end

return M
