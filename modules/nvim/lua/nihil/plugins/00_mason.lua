return {
    'williamboman/mason.nvim',
    build = function() require('mason-registry').update() end,
    dependencies = 'williamboman/mason-lspconfig.nvim',
    config = function()
        local mason = require 'mason'
        local mason_lsp = require 'mason-lspconfig'

        -- bashls cssls emmet_language_server eslint jsonls lua_ls marksman pyright stylua tailwindcss tree-sitter-cli tsserver
        mason.setup {
            ui = {
                border = 'rounded',
            },
        }

        mason_lsp.setup {
            automatic_installation = true,
        }
    end,
}
