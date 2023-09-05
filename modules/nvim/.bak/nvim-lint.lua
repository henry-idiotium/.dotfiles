local function filetypes_by_linter(schema)
    local config = {}

    for linter, langs in ipairs(schema) do
        for _, lang in ipairs(langs) do
            config[lang] = { linter }
        end
    end

    return config
end

---@type LazySpec
return {
    'mfussenegger/nvim-lint',
    enabled = false,
    config = function()
        local lint = require 'lint'

        vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
            callback = require('lint').try_lint,
        })

        lint.linters_by_ft = {
            --[[ eslint_d = {
                'typescript',
                'typescriptreact',
                'javascript',
                'javascriptreact',
            },
            eslint = {
                'typescript',
                'typescriptreact',
                'javascript',
                'javascriptreact',
            }, ]]
            javascript = { 'eslint_d' },
            typescript = { 'eslint_d' },
            javascriptreact = { 'eslint_d' },
            typescriptreact = { 'eslint_d' },
        }

        -- vim.cmd [[
        --     au BufWritePost * lua require 'lint'.try_lint()
        -- ]]
    end,
}
