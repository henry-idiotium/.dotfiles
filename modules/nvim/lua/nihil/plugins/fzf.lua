return {
    'junegunn/fzf.vim',
    dependencies = { 'junegunn/fzf', build = ':call fzf#install()' },
    init = function()
        vim.g.fzf_nvim_statusline = 0
        vim.cmd [[
            let $FZF_DEFAULT_COMMAND='fd
                \ --type f --strip-cwd-prefix --hidden --follow
                \ --exclude .git
                \ --exclude .next
                \ --exclude node_modules
                \ --exclude dist
                \'
        ]]
    end,
    config = function()
        nihil.utils.keymap.map_keys {
            ['<c-e>'] = ':Files<cr>',
            ['<c-f>'] = ':BLines<cr>',
            ['<c-s-f>'] = ':RG<cr>',
            ['<c-a-f>'] = ':RG<cr>',
            ['<leader>b'] = ':Buffers<cr>',
            ['<leader><s-b>'] = ':Windows<cr>',
            ['<leader><s-o>'] = ':BTags<cr>',
            ['<leader>o'] = ':Tags<cr>',
            ['<leader>?'] = ':History<cr>',
        }
    end,
}
