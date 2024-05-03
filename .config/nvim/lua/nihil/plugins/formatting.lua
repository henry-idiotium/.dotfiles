return {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    lazy = true,

    dependencies = {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        opts = { ensure_installed = Nihil.settings.conform.mason_tools },
        config = true,
    },

    cmd = { 'ConformInfo' },
    keys = {
        { '<a-s-f>', function() require('conform').format(Nihil.settings.conform.format_on_save) end, mode = { 'i', 'n', 'v' }, desc = 'Format buffer' },
        { '<leader>cf', function() require('conform').format(Nihil.settings.conform.format_on_save) end, mode = { 'n', 'v' }, desc = 'Format buffer' },
        { '<leader>tf', '<cmd>ToggleAutoFormat<cr>', mode = { 'n', 'v' }, desc = 'Toggle Auto Format Globally' },
    },

    init = function()
        vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"

        vim.api.nvim_create_user_command('ToggleAutoFormat', function()
            vim.g.disable_autoformat = not vim.g.disable_autoformat
            vim.notify('Conform auto format (global) ' .. (vim.g.disable_autoformat and '❌' or '👍'))
        end, {})
    end,

    opts = vim.tbl_deep_extend('force', Nihil.settings.conform, {
        format_on_save = function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
            return Nihil.settings.conform.format_on_save
        end,
    }),
}
