--- Status line
return {
    'hoob3rt/lualine.nvim',
    dependencies = {
        'linrongbin16/lsp-progress.nvim',
    },
    config = function()
        local lualine = require 'lualine'
        local cat_theme = require 'lualine.themes.catppuccin'
        local C = require 'catppuccin.palettes'.get_palette()

        --: custom colorscheme
        cat_theme.normal.c.bg = C.none
        cat_theme.inactive.c.bg = C.none
        for _, mode in pairs {
            'normal', 'visual', 'insert', 'replace',
            'command', 'inactive', 'terminal'
        } do cat_theme[mode].b.bg = C.base end

        lualine.setup {
            options = {
                icons_enabled        = true,
                theme                = cat_theme,
                section_separators   = { left = '', right = '' },
                component_separators = { left = '', right = '' },
                disabled_filetypes   = {},
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = {
                    { 'filename',
                        file_status = true, --: displays file status
                        path = 0, --: just filename
                        symbols = {
                            modified = '', -- Text to show when the file is modified.
                            readonly = '', -- Text to show when the file is non-modifiable or readonly.
                            unnamed = '[void]', -- Text to show for unnamed buffers.
                        }
                    },
                },
                lualine_c = {
                    'branch',
                    { 'diff',
                        symbols = { added = ' ', modified = ' ', removed = '󱎘 ' }
                    },
                },
                lualine_x = {
                    require 'lsp-progress'.progress,
                    { 'diagnostics',
                        sources = { 'nvim_diagnostic' },
                        symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
                    },
                    'encoding',
                    'filetype',
                },
                lualine_y = { 'process' },
                lualine_z = { 'location' },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {
                    {
                        'filename',
                        file_status = true, --: displays file status (readonly status, modified status)
                        path = 1,
                    }
                },
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            extensions = { 'fugitive' },
        }

        pcall(vim.cmd, [[
            augroup lualine_augroup
                autocmd!
                autocmd User LspProgressStatusUpdated lua require("lualine").refresh()
            augroup END
        ]])
    end,
}
