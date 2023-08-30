--- Code highlighter
return {
    'nvim-treesitter/nvim-treesitter',
    dependencies = 'nvim-treesitter/nvim-treesitter-textobjects',
    build = function() require 'nvim-treesitter.install'.update { with_sync = true } end,

    config = function()
        require 'nvim-treesitter.configs'.setup {
            highlight = {
                enable = true,
                disable = {},
                additional_vim_regex_highlighting = false
            },
            indent = {
                enable = true,
                disable = {},
            },
            autotag = {
                enable = true,
            },
            ensure_installed = {
                'javascript',
                'typescript',
                'tsx',
                'fish',
                'css',
                'html',
                'lua',
                'markdown',
                'markdown_inline',
                'json',
                'jsonc',
                'bash',
                'fish',
                'python'
            },
        }

        local parser_config = require 'nvim-treesitter.parsers'.get_parser_configs()
        parser_config.tsx.filetype_to_parsername = { 'javascript', 'typescript.tsx' }
    end,
}
