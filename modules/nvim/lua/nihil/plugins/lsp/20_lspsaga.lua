return {
    'nvimdev/lspsaga.nvim',
    dependencies = 'neovim/nvim-lspconfig',
    config = function()
        local C = require('catppuccin.palettes').get_palette() or error 'Missing `catppuccin.palettes`'
        vim.api.nvim_set_hl(0, 'SagaWinbarSep', { fg = C.subtext1 })

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
                folder_level = 1,
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

        local map_keys = nihil.utils.keymap.map_keys
        local function run(cmd) return ('<cmd>Lspsaga ' .. cmd .. '<cr>') end
        map_keys {
            {
                gi = { vim.lsp.buf.implementation, desc = 'Go to Implementation' },
                gd = { run 'goto_definition', desc = 'Go to definition' },
                ['<s-k>'] = { run 'hover_doc', desc = 'Show documentation' },
                ['<c-.>'] = { run 'code_action', desc = 'Show code actions' },
                ['<a-.>'] = { run 'code_action', desc = 'Show code actions' },

                gp = {
                    desc = 'Peek lsp',
                    d = { run 'peek_definition', desc = 'Peek definition' },
                    f = { run 'finder', desc = 'Show definition and references' },
                },

                [']d'] = { run 'diagnostic_jump_next', desc = 'Go to next diagnostics' },
                ['[d'] = { run 'diagnostic_jump_prev', desc = 'Go to previous diagnostics' },

                ['<space>r'] = {
                    desc = 'Rename',
                    ['n'] = { run 'rename', desc = 'Rename symbol' },
                },
            },
        }
    end,
}
