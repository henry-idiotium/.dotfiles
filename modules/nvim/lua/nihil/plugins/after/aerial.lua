--- Code outline
---@type LazySpec
return {
    'stevearc/aerial.nvim',
    keys = {
        { '<c-s-o>', '<cmd>AerialToggle!<cr>', desc = 'Toggle Aerial (doc/buffer symbols)', id = 'key_AerialToggle' },
    },
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-tree/nvim-web-devicons',
    },

    config = function()
        local aerial = require 'aerial'
        local map_keys = nihil.utils.keymap.map_keys

        aerial.setup {
            on_attach = function(bufnr)
                -- Jump forwards/backwards
                map_keys({
                    { '<s-[>', '<cmd>AerialPrev<CR>' },
                    { '<s-]>', '<cmd>AerialNext<CR>' },
                }, { buffer = bufnr })
            end,
        }
    end,
}
