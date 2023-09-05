local _, helper = pcall(require, 'nihil.helpers.lsp')

--- Vscode-like pictograms
return {
    'onsails/lspkind-nvim',
    ft = helper.FILE_TYPES,
    -- dependencies = 'neovim/nvim-lspconfig',
    config = function()
        local lspkind = require 'lspkind'
        local helpers = require 'nihil.helpers.lsp'

        lspkind.init {
            -- enables text annotations
            mode = 'symbol',

            -- default symbol map
            -- can be either 'default' (requires nerd-fonts font) or
            -- 'codicons' for codicon preset (requires vscode-codicons font)
            preset = 'codicons',

            -- override preset symbols
            symbol_map = helpers.LSP_ITEM_KINDS,
        }
    end,
}
