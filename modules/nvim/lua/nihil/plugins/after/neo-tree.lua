return {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
        'MunifTanjim/nui.nvim',
        'nvim-lua/plenary.nvim',
    },
    keys = {
        { '<c-l><c-e>', '<cmd>Neotree toggle<cr>', desc = 'NeoTree' },
    },
    init = function()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        -- set termguicolors to enable highlight groups
        vim.opt.termguicolors = true
    end,
    config = function()
        local map_keys = nihil.utils.keymap.map_keys
        local unmap_keys = nihil.utils.keymap.unmap_keys

        local function on_attach(bufnr)
            local api = require 'nvim-tree.api'

            -- default mappings
            api.config.mappings.default_on_attach(bufnr)

            unmap_keys {
                '<c-s>',
            }

            map_keys({
                { '<c-t>', api.tree.change_root_to_parent, desc = 'Explorer tree go up' },
                { '<c-/>', api.tree.toggle_help, desc = 'Explorer tree open help' },
            }, { buffer = bufnr })
        end

        require('neo-tree').setup {
            on_attach = on_attach,
            sort_by = 'case_sensitive',
            view = {
                width = 30,
            },
            renderer = {
                group_empty = true,
            },
            filters = {
                dotfiles = false,
            },
        }
    end,
}
