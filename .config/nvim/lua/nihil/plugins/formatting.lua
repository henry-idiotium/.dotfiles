local default_format_on_save = { timeout_ms = 3000, lsp_fallback = false, async = false }

return {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    lazy = true,

    cmd = { 'ConformInfo' },
    keys = {
        { '<a-s-f>', function() require('conform').format(default_format_on_save) end, mode = { 'i', 'n', 'v' }, desc = 'Format buffer' },
        { '<leader>cf', function() require('conform').format(default_format_on_save) end, mode = { 'n', 'v' }, desc = 'Format buffer' },
        { '<leader>tf', '<cmd>ToggleAutoFormat<cr>', mode = { 'n', 'v' }, desc = 'Toggle Auto Format Globally' },
    },

    init = function()
        vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"

        vim.api.nvim_create_user_command('ToggleAutoFormat', function()
            vim.g.disable_autoformat = not vim.g.disable_autoformat
            vim.notify('Conform auto format (global) ' .. (vim.g.disable_autoformat and '❌' or '💪'))
        end, {})
    end,

    opts = function()
        local prettier_fmt = { 'prettierd', 'prettier' }

        return {
            ---@type table<string, conform.FiletypeFormatter>
            formatters_by_ft = {
                lua = { 'stylua' },
                go = { 'goimports', 'gofmt' },
                rust = { 'rustfmt' },
                python = { 'isort', 'black' },
                fish = { 'fish_indent' },
                markdown = prettier_fmt,
                typescript = prettier_fmt,
                typescriptreact = prettier_fmt,
                javascript = prettier_fmt,
                javascriptreact = prettier_fmt,
                json = prettier_fmt,
                html = prettier_fmt,
                css = prettier_fmt,
                ['_'] = { 'trim_whitespace' },
            },

            format_on_save = function(bufnr)
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
                return default_format_on_save
            end,
        }
    end,
}
