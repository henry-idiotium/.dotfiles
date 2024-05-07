return {
    {
        'stevearc/conform.nvim',
        event = 'BufWritePre',
        lazy = true,

        dependencies = {
            'WhoIsSethDaniel/mason-tool-installer.nvim',
            opts = { ensure_installed = Nihil.settings.conform.mason_ensure_installed },
            lazy = false,
        },

        cmd = { 'ConformInfo' },
        keys = {
            { '<leader>of', '<cmd>ConformInfo<cr>', desc = 'Conform Info' },
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
                -- Disable autoformat on certain filetypes
                if vim.tbl_contains(Nihil.settings.minimal_plugins_filetypes, vim.bo[bufnr].filetype) then return end

                -- Disable autoformat for files in a certain path
                local bufname = vim.api.nvim_buf_get_name(bufnr)
                if bufname:match '/node_modules/' or bufname:match '/dist/' then return end

                if vim.g.disable_autoformat then return end
                return Nihil.settings.conform.format_on_save
            end,
        }),
    },
}
