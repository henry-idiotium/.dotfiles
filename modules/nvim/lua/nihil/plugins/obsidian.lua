return {}

--[[ return {
    'epwalsh/obsidian.nvim',
    lazy = true,
    event = {
        -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
        'BufReadPre '
            .. vim.fn.expand '~'
            .. '/documents/notes/**.md',
    },
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    config = function()
        local obs = require 'obsidian'
        local obs_map = require 'obsidian.mapping'

        obs.setup {
            dir = '~/documents/notes', -- no need to call 'vim.fn.expand' here
            -- other fields ...

            templates = {
                subdir = 'templates',
                date_format = '%Y-%m-%d-%a',
                time_format = '%H:%M',
            },

            mappings = {
                ['kkl'] = obs_map.gf_passthrough(),
            },
        }
    end,
} ]]
