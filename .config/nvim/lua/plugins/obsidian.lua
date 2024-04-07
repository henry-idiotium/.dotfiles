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
            daily_notes = { folder = 'notes', template = 'templates/daily-note.md' },
            notes_subdir = 'notes',

            disable_frontmatter = false,
            note_frontmatter_func = function(note)
                if note.title then note:add_alias(note.title) end

                local out = { id = note.id, aliases = note.aliases }

                if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
                    for k, v in pairs(note.metadata) do
                        out[k] = v
                    end
                end

                return out
            end,

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

            ui = {
                enable = true, -- set to false to disable all additional syntax features
                update_debounce = 200, -- update delay after a text change (in milliseconds)
                -- Define how various check-boxes are displayed
                checkboxes = {
                    -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
                    [' '] = { char = '󰄱  ', hl_group = 'ObsidianTodo' },
                    ['x'] = { char = '  ', hl_group = 'ObsidianDone' },
                    ['>'] = { char = '  ', hl_group = 'ObsidianRightArrow' },
                    ['~'] = { char = '󰰱  ', hl_group = 'ObsidianTilde' },
                },
            },
        },
    },
}
