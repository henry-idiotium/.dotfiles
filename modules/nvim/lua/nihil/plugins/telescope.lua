--- Utility popup modals
return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.2',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        -- 'nvim-telescope/telescope-file-browser.nvim',
    },
    config = function()
        local telescope = require 'telescope'
        local actions = require 'telescope.actions'
        -- local fb_actions = telescope.extensions.file_browser.actions
        local layout = require 'telescope.actions.layout'
        local map_keys = nihil.utils.keymap.map_keys

        -- local function get_buffer_dir() return vim.fn.expand '%:p:h' end

        local configs = {
            defaults = {
                path_display = { 'tail' },
                file_ignore_patterns = { '^node_modules$', '^node_modules/*', '^.git$', '^.git/*' },
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
                    flex = { flip_columns = 130 },
                },

                mappings = {
                    n = {
                        ['<c-q>'] = actions.close,
                        ['l'] = actions.select_default,
                        ['<c-l>'] = actions.select_tab,
                        ['<c-p>'] = layout.toggle_preview,
                        ['q'] = actions.close,
                        ['<c-j>'] = actions.move_selection_next,
                        ['<c-k>'] = actions.move_selection_previous,
                        ['<esc>'] = false,
                    },
                    i = {
                        ['<c-l>'] = actions.select_default,
                        ['<c-s-l>'] = actions.select_tab,
                        ['<c-j>'] = actions.move_selection_next,
                        ['<c-k>'] = actions.move_selection_previous,
                        ['<c-p>'] = layout.toggle_preview,
                        ['<c-q>'] = actions.close,
                    },
                },
            },
            pickers = {
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

                --[[ diagnostics = { initial_mode = 'normal' },
                colorscheme = {
                    theme = 'dropdown',
                    enable_preview = true,
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
                            ['<c-x>'] = actions.delete_buffer,
                        },
                    },
                }, ]]
            },
            extensions = {
                fzf = {
                    fuzzy = true, -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true, -- override the file sorter
                    case_mode = 'smart_case', -- or "ignore_case" or "respect_case", default case_mode is "smart_case"
                },
                --[[ file_browser = {
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
                            ['<s-n>'] = fb_actions.create,
                            ['h'] = fb_actions.goto_parent_dir,
                            ['dd'] = fb_actions.remove,
                            ['<c-s-h>'] = fb_actions.toggle_hidden,
                        },
                    },
                }, ]]
            },
        }

        telescope.setup(configs)
        for ext, _ in pairs(configs.extensions) do
            telescope.load_extension(ext)
        end

        local function run(after) return nihil.utils.cmd.callbackRun('Telescope ' .. after) end

        map_keys({
            ['<leader>'] = { run 'resume', desc = 'Open previous telescope action' },
            f = {
                desc = 'Telescope find',
                f = { run 'find_files', desc = 'Find files in workspace' },
                g = {
                    desc = 'Search words',
                    f = { run 'current_buffer_fuzzy_find', desc = 'Search words in active document/buffer' },
                    w = { run 'live_grep', desc = 'Search words in workspace' },
                },
            },
        }, { prefix = '<leader>' })
    end,
}
