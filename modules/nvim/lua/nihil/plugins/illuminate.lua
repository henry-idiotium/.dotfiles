return {
    'RRethy/vim-illuminate',
    config = function()
        local illuminate = require 'illuminate'

        illuminate.configure {
            -- providers: provider used to get references in the buffer, ordered by priority
            providers = {
                'treesitter',
                'regex',
                'lsp',
            },
            -- delay: delay in milliseconds
            delay = 100,
            min_count_to_highlight = 2,
        }
    end
}
