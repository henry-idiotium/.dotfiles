nihil.utils.plugin.require('lspsaga', function(saga)
    local C = require 'catppuccin.palettes'.get_palette()

    saga.setup {
        lightbulb = { enable = false, },
        finder = {
            keys = {
                edit = { 'o', '<cr>' },
                vsplit = 'sv',
                split = 'ss',
                tabe = '<c-t>',
                quit = { '<c-q', 'q', '<esc>' },
            }
        },
        diagnostic = {
            on_insert = false,
            show_source = true,
            show_code_action = true,
            jump_num_shortcut = true,
            max_width = 0.9,
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
            }
        },
        code_action = {
            num_shortcut = true,
            keys = {
                quit = { 'q', '<c-q', '<esc>' },
                exec = { '<cr>', 'l', '<c-l>' },
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

            kind = {
                Text          = { ' ', '@text' },
                Method        = { ' ', '@method' },
                Function      = { ' ', '@function' },
                Constructor   = { ' ', '@constructor' },
                Field         = { ' ', '@field' },
                Variable      = { ' ', '@variable' },
                Class         = { ' ', '@class' },
                Interface     = { ' ', '@interface' },
                Module        = { ' ', '@module' },
                Property      = { ' ', '@property' },
                Unit          = { ' ', '@unit' },
                Value         = { ' ', '@value' },
                Enum          = { ' ', '@enum' },
                Snippet       = { ' ', '@snippet' },
                File          = { ' ', '@file' },
                Folder        = { ' ', '@folder' },
                EnumMember    = { ' ', '@enumMember' },
                Constant      = { ' ', '@constant' },
                Struct        = { ' ', '@struct' },
                Event         = { ' ', '@event' },
                Operator      = { ' ', '@operator' },
                TypeParameter = { ' ', '@typeParameter' },
                Namespace     = { ' ', '@namespace' },
                Package       = { ' ', '@package' },
                String        = { ' ', '@string' },
                Number        = { ' ', '@number' },
                Boolean       = { ' ', '@boolean' },
                Array         = { ' ', '@array' },
                Object        = { ' ', '@object' },
                Key           = { ' ', '@key' },
                Null          = { ' ', '@null' },
                TypeAlias     = { ' ', '@typeAlias' },
                Parameter     = { ' ', '@parameter' },
                StaticMethod  = { 'ﴂ ', '@staticMethod' },
                Macro         = { ' ', '@macro' },
            },
        },
    }

    if C then
        vim.api.nvim_set_hl(0, 'SagaWinbarSep', { fg = C.subtext1 })
    end
end)

local foo = ''
print(foo)
