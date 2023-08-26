nihil.utils.plugin.require('telescope', function(telescope)
    local actions        = require 'telescope.actions'
    local fb_actions     = telescope.extensions.file_browser.actions
    local layout         = require 'telescope.actions.layout'
    local builtin        = require 'telescope.builtin'
    local map_keys       = nihil.utils.keymap.map_schema
    local map_group_keys = nihil.utils.keymap.map_schema_group

    local function get_buffer_dir()
        return vim.fn.expand '%:p:h'
    end

    local EXCLUDE_PATTERNS = {
        '^node_modules$', '^node_modules/*',
        '^.git$', '^.git/*',
    }

    local configs = {
        defaults = {
            path_display = { 'tail' },
            file_ignore_patterns = EXCLUDE_PATTERNS,
            dynamic_preview_title = true,

            prompt_prefix = '   ',
            entry_prefix = '  ',
            selection_strategy = 'reset',
            sorting_strategy = 'ascending',

            layout_strategy = 'horizontal',
            layout_config = {
                horizontal = {
                    prompt_position = 'top',
                },
            },
            layout_defaults = {
                flex = { flip_columns = 130, }
            },

            mappings = {
                n = {
                    ['<c-q>'] = actions.close,
                    ['l']     = actions.select_default,
                    ['<c-l>'] = actions.select_tab,
                    ['<c-p>'] = layout.toggle_preview,
                    ['q']     = actions.close,
                    ['<esc>'] = false,

                },
                i = {
                    ['<c-l>']   = actions.select_default,
                    ['<c-s-l>'] = actions.select_tab,
                    ['<c-j>']   = actions.move_selection_next,
                    ['<c-k>']   = actions.move_selection_previous,
                    ['<c-p>']   = layout.toggle_preview,
                    ['<c-q>']   = actions.close,
                },
            },
        },
        pickers = {
            diagnostics = { initial_mode = 'normal', },
            find_files = {
                theme = 'dropdown',
                cwd = vim.g.documentos,
                no_ignore = false,
                hidden = true,

                path_display = { 'tail' },
            },
            current_buffer_fuzzy_find = {
                theme = 'dropdown',
                previewer = false,
                skip_empty_lines = true,
            },
            live_grep = {
                layout_config = {
                    horizontal = {
                        preview_width = 0.5,
                        results_width = 0.5,
                    },
                },
            },
            colorscheme = {
                theme = 'dropdown',
                enable_preview = true
            },
            oldfiles = {
                theme = 'dropdown',
                cwd = get_buffer_dir(),
                path = '%:p:h',
                previewer = false,
            },
            buffers = {
                theme = 'dropdown',
                initial_mode = 'normal',
                previewer = false,
                sort_mru = true,
                show_all_buffers = false,

                mappings = {
                    n = {
                        ['<c-x>'] = actions.delete_buffer
                    }
                }
            },
        },
        extensions = {
            fzf = {
                fuzzy = true,                   -- false will only do exact matching
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true,    -- override the file sorter
                case_mode = 'smart_case',       -- or "ignore_case" or "respect_case", default case_mode is "smart_case"
            },
            file_browser = {
                theme = 'dropdown',
                initial_mode = 'normal',
                cwd = get_buffer_dir(),
                path = '%:p:h',

                hijack_netrw = true, --: Disables netrw and use telescope-file-browser in its place

                hidden = true,
                grouped = true,
                previewer = false,
                hide_parent_dir = true,
                use_fd = false,

                git_status = false,
                respect_gitignore = false,

                layout_config = {
                    horizontal = {
                        preview_width = 0.6,
                        results_width = 0.8,
                    },
                },

                mappings = {
                    n = {
                        ['<s-n>']   = fb_actions.create,
                        ['h']       = fb_actions.goto_parent_dir,
                        ['dd']      = fb_actions.remove,
                        ['<c-s-h>'] = fb_actions.toggle_hidden,
                    },
                },
            },
            ['telescope-tabs'] = {
                initial_mode = 'normal',
                show_preview = false,

                close_tab_shortcut_i = '<c-x>',
                close_tab_shortcut_n = '<c-x>',

                ---@diagnostic disable-next-line: unused-local
                entry_formatter = function(tab_id, buffer_ids, file_names, file_paths, is_current)
                    local entry_string = table.concat(file_names, ', ')
                    return string.format('%d -  %s%s', tab_id,
                        entry_string,
                        is_current and ' ' or '')
                end,
            },
        },
    }

    telescope.setup(configs)
    for ext, _ in pairs(configs.extensions) do
        telescope.load_extension(ext)
    end


    local tele_tabs = require 'telescope-tabs'
    local tele_themes = require 'telescope.themes'

    map_keys {
        { '<leader><leader>', builtin.resume,           desc = 'Open previous telescope action' },
        { '<c-s-e>',          tele_tabs.go_to_previous, desc = 'Go to previous opened tab', },

        {
            desc = 'List current buffer tabs',
            '<c-e>',
            function()
                tele_tabs.list_tabs(tele_themes.get_dropdown({
                }))
            end,
        },
    }
    map_group_keys({ prefix = '<leader>f', name = 'Find' }, {
        { 'f', builtin.find_files,                             desc = 'Find files in workspace', },
        { 'o', builtin.oldfiles,                               desc = 'Show recent files' },
        { 'b', telescope.extensions.file_browser.file_browser, desc = 'Browse files of current cwd', },
        { 'd', builtin.diagnostics,                            desc = 'Show diagnostics in document' },
    })
    map_group_keys({ prefix = '<leader>fs', name = 'Find symbols' }, {
        { 'w', builtin.lsp_dynamic_workspace_symbols, desc = 'List symbols in workspace' },
        { 'd', builtin.lsp_document_symbols,          desc = 'List symbols in docyment' },
    })
    map_group_keys({ prefix = '<leader>g', name = 'Grep' }, {
        { 'w', builtin.live_grep,                 desc = 'Search words in workspace' },
        { 'f', builtin.current_buffer_fuzzy_find, desc = 'Search words in document', },
    })
end)
