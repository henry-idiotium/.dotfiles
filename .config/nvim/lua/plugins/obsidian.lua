return {
    {
        'epwalsh/obsidian.nvim',
        lazy = true,
        ft = 'markdown',
        event = { 'BufReadPre ' .. vim.env.HOME .. '/document/notes/**.md' },
        dependencies = { 'nvim-lua/plenary.nvim' },
        init = function() vim.opt.conceallevel = 2 end,
        opts = {
            workspaces = {
                { name = 'notes', path = '~/documents/notes' },
            },

            templates = { subdir = 'templates' },

            mappings = {
                ['gf'] = {
                    action = function()
                        if require('obsidian').util.cursor_on_markdown_link() then
                            return '<cmd>ObsidianFollowLink<CR>'
                        else
                            return 'gf'
                        end
                    end,
                    opts = { noremap = false, expr = true, buffer = true },
                },
            },
        },
    },
}
