nihil.utils.plugin.require('mason', function(mason)
    local lspconfig = require 'mason-lspconfig'

    mason.setup {
        ensure_installed = {
            'lua_ls',
            'jsonls',
            'marksman',
            'cssls',
            'emmet_ls',
            'eslint',
            'pyright',
            'prettierd',
            'tailwindcss',
            'tsserver',
        }
    }

    lspconfig.setup {
        automatic_installation = true
    }
end)
