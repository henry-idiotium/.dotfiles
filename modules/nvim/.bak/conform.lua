local function conform_format()
    local buf = 0
    local buf_name = vim.api.nvim_buf_get_name(buf)

    local exclude_path = '/node_modules/'
    local exclude_filetypes = { 'sql' }

    -- Disable autoformat on certain filetypes
    if vim.tbl_contains(exclude_filetypes, vim.bo[buf].filetype) then return end

    -- Disable autoformat for files in a certain path
    if buf_name:match(exclude_path) then return end

    -- Eslint
    if vim.tbl_contains({ 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' }, vim.bo[buf].filetype) then vim.cmd 'EslintFixAll' end

    -- Disable with a global or buffer-local variable
    -- if vim.g.disable_autoformat or vim.b[buf].disable_autoformat then return end

    ---@diagnostic disable-next-line: discard-returns, param-type-mismatch
    require('conform').format {
        timeout_ms = 1000,
        lsp_fallback = true,
        buf = buf_name,
        async = true,
    }
end

return {
    'stevearc/conform.nvim',
    enabled = false,
    config = function()
        local conform = require 'conform'
        local map_keys = nihil.utils.keymap.map_keys

        map_keys {
            ---@diagnostic disable-next-line: assign-type-mismatch
            ['<a-s-f>'] = conform_format,
        }

        local prettier_config = {
            formatters = { 'prettierd' },
        }

        conform.setup {
            formatters_by_ft = {
                lua = { 'stylua' },

                javascript = prettier_config,
                typescript = prettier_config,
                javascriptreact = prettier_config,
                typescriptreact = prettier_config,

                -- python = {
                --     formatters = { 'isort', 'black' },
                --     run_all_formatters = true,
                -- },
            },
        }
    end,
}
