return {
    'williamboman/mason.nvim', build = function() require 'mason-registry'.update() end,
    dependencies = 'williamboman/mason-lspconfig.nvim',
    config = function()
        local mason     = require 'mason'
        local mason_lsp = require 'mason-lspconfig'

        -- tree-sitter-cli prettierd eslint_d
        mason.setup {}

        mason_lsp.setup {
            automatic_installation = true,
        }
    end,
}
