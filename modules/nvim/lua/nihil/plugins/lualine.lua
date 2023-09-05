--- Status line
return {
    'hoob3rt/lualine.nvim',
    priority = 500,
    dependencies = { 'linrongbin16/lsp-progress.nvim' },
    config = function()
        local lsp_progess_exist, lsp_progess = pcall(require, 'lsp-progress')

        local cat_theme = require 'lualine.themes.catppuccin'
        local C = require('catppuccin.palettes').get_palette() or error 'Missing `catppuccin.palettes`'

        -- custom colorscheme
        cat_theme.normal.c.bg = C.none
        cat_theme.inactive.c.bg = C.none
        for _, mode in ipairs(vim.tbl_keys(cat_theme)) do
            cat_theme[mode].b.bg = C.base
        end

        require('lualine').setup {
            options = {
                icons_enabled = true,
                section_separators = { left = '', right = '' },
                component_separators = { left = '', right = '' },
                theme = cat_theme,
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = {
                    {
                        'filename',
                        file_status = true, --: displays file status
                        path = 0, --: just filename
                        symbols = {
                            modified = '', -- Text to show when the file is modified.
                            readonly = '', -- Text to show when the file is non-modifiable or readonly.
                            unnamed = '[void]', -- Text to show for unnamed buffers.
                        },
                    },
                },
                lualine_c = {
                    'branch',
                    { 'diff', symbols = { added = ' ', modified = ' ', removed = '󱎘 ' } },
                },
                lualine_x = {
                    lsp_progess_exist and lsp_progess.progress or {},
                    {
                        'diagnostics',
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
                    },
                },
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            extensions = { 'fugitive' },
        }

        -- lsp progess augroup
        if lsp_progess_exist then
            vim.cmd [[
                augroup lualine_augroup
                    autocmd!
                    autocmd User LspProgressStatusUpdated lua require('lualine').refresh()
                augroup END
            ]]
        end
    end,
}
