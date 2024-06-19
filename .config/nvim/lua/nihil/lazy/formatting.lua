---@diagnostic disable: missing-return-value
return {
    {
        'stevearc/conform.nvim',
        event = 'BufWritePre',
        lazy = true,

        dependencies = {
            'WhoIsSethDaniel/mason-tool-installer.nvim',
            opts = { ensure_installed = Nihil.config.conform.mason_ensure_installed },
            lazy = false,
        },

        cmd = { 'ConformInfo' },
        keys = {
            {
                '<a-s-f>',
                function() require('conform').format(Nihil.config.conform.format_on_save) end,
                mode = { 'i', 'n', 'v' },
                desc = 'Format buffer',
            },
            {
                '<leader>cf',
                function() require('conform').format(Nihil.config.conform.format_on_save) end,
                mode = { 'n', 'v' },
                desc = 'Format buffer',
            },
            { '<leader><leader>f', '<cmd>ToggleAutoFormat <cr>', desc = 'Toggle Auto Format (local)' },
            { '<leader><leader>F', '<cmd>ToggleAutoFormat! <cr>', desc = 'Toggle Auto Format (global)' },
        },

        init = function()
            vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
            vim.api.nvim_create_user_command('ToggleAutoFormat', function(args)
                local vim_loc = args.bang and 'g' or 'b'
                vim[vim_loc].disable_autoformat = not vim[vim_loc].disable_autoformat ---@diagnostic disable-line: no-unknown
                Nihil.debug.info(
                    string.format('📄 %s Auto Format (%s) !', vim[vim_loc].disable_autoformat and 'Disabled' or 'Enabled', args.bang and 'global' or 'local')
                )
            end, { bang = true })
        end,

        ---@type conform.setupOpts
        opts = {
            format_on_save = function(bufnr)
                -- for files in a certain path
                local bufname = vim.api.nvim_buf_get_name(bufnr)
                if bufname:match '/node_modules/' or bufname:match '/dist/' then return end

                -- on certain filetypes
                if vim.tbl_contains(Nihil.config.excluded_filetypes, vim.bo[bufnr].filetype) then return end

                -- toggle
                if vim.g.disable_autoformat or vim.b.disable_autoformat then return end

                return Nihil.config.conform.format_on_save
            end,
        },

        config = function(_, opts) require('conform').setup(vim.tbl_deep_extend('force', {}, Nihil.config.conform, opts)) end,
    },
}
