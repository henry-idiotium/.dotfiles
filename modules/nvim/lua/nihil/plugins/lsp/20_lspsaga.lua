-- local wk_exist, wk = pcall(require, 'which-key')
-- if wk_exist then
--     wk.register {
--         gp = { name = 'Peek LSP' },
--         ['<leader>'] = {
--             r = { name = 'Rename stuffs' },
--             t = {
--                 name = 'Toggle things',
--                 l = { name = 'Toggle LSP' },
--                 g = { name = 'Toggle diagnostic' },
--             },
--         },
--     }
-- end

return {
    'nvimdev/lspsaga.nvim',
    dependencies = 'neovim/nvim-lspconfig',
    -- keys = {
    --     { 'gi', vim.lsp.buf.implementation, desc = 'Go to Implementation' },
    --     { '<s-k>', '<cmd>Lspsaga hover_doc<cr>', desc = 'Show documentation' },
    --     { '<c-.>', '<cmd>Lspsaga code_action<cr>', desc = 'Show code actions' },
    --     { 'gd', '<cmd>Lspsaga goto_definition<cr>', desc = 'Go to definition' },
    --     { 'gpd', '<cmd>Lspsaga peek_definition<cr>', desc = 'Peek definition' },
    --     { 'gpf', '<cmd>Lspsaga finder<cr>', desc = 'Show definition and references' },
    --     { ']d', '<cmd>Lspsaga diagnostic_jump_next<cr>', desc = 'Go to next diagnostics' },
    --     { '[d', '<cmd>Lspsaga diagnostic_jump_prev<cr>', desc = 'Go to previous diagnostics' },
    --     { '<leader>rn', '<cmd>Lspsaga rename<cr>', desc = 'Rename symbol' },
    --     { '<leader>tld', '<cmd>LspDiagnosticToggle<cr>', desc = 'Toggle diagnostic' },
    --     { '<leader>tlf', '<cmd>LspAutoFormatToggle<cr>', desc = 'Toggle format on save' },
    --     { '<leader>tgd', '<cmd>Lspsaga show_cursor_diagnostics<cr>', desc = 'Show diagnostics of current line' },
    --     { '<leader>tg<s-d>', '<cmd>Lspsaga show_buf_diagnostics<cr>', desc = 'Show diagnostics of active file' },
    -- },
    config = function()
        require('lspsaga').setup {
            lightbulb = { enable = false },
            finder = {
                keys = {
                    edit = { 'o', '<cr>' },
                    vsplit = 'sv',
                    split = 'ss',
                    tabe = '<c-t>',
                    quit = { '<c-q', 'q', '<esc>' },
                },
            },
            diagnostic = {
                on_insert = false,
                show_source = true,
                show_code_action = true,
                jump_num_shortcut = true,
                max_width = 1,
                border_follow = true,
                keys = {
                    exec_action = 'o',
                    go_action = 'g',
                    quit = 'q',
                },
            },
            rename = {
                auto_save = false,
                in_select = false,
                project_max_width = 0.5,
                project_max_height = 0.5,
                keys = {
                    quit = '<c-q>',
                    exec = '<c-o>',
                    select = 'x',
                },
            },
            code_action = {
                num_shortcut = true,
                keys = {
                    quit = { 'q', '<c-q', '<esc>' },
                    exec = { '<cr>', '<c-.>' },
                },
            },
            symbol_in_winbar = {
                enable = true,
                separator = '  ',
                hide_keyword = true,
                show_file = true,
                folder_level = 0,
                color_mode = true,
                delay = 300,
            },

            beacon = {
                enable = true,
                frequency = 7,
            },
            scroll_preview = {
                scroll_down = '<c-d>',
                scroll_up = '<c-u>',
            },
            ui = {
                title = false,
                devicon = true,
                border = 'rounded',

                imp_sign = '󰳛 ',

                diagnostic = ' ',
                code_action = ' ',
                actionfix = ' ',

                preview = '',
                collapse = '⊟',
                expand = '⊞',

                lines = { '┗', '┣', '┃', '━', '┏' },

                kind = require('catppuccin.groups.integrations.lsp_saga').custom_kind(),
            },
        }

        local C = require('catppuccin.palettes').get_palette() or error 'Missing `catppuccin.palettes`'
        vim.api.nvim_set_hl(0, 'SagaWinbarSep', { fg = C.subtext1 })
    end,
}
