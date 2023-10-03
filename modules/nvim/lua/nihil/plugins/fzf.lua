return {
    'junegunn/fzf.vim',
    dependencies = { 'junegunn/fzf', build = ':call fzf#install()' },
    init = function()
        vim.g.fzf_nvim_statusline = 0
        vim.cmd [[
            let g:fzf_action = {
            \    'alt-l': 'tab split',
            \    'ctrl-s': 'split',
            \    'ctrl-v': 'vsplit',
            \ }
            let g:fzf_vim = {
            \    'command_prefix': 'Fzf',
            \    'preview_window': ['hidden,right,50%', 'ctrl-p'],
            \ }

            command! -bang -nargs=? -complete=dir Files
                \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)
            command! -bang -nargs=* BLines
                \ call fzf#vim#buffer_lines(<q-args>, {'options': ['--layout=reverse', '--info=inline']}, <bang>0)
            command! -bang -nargs=* Rg
                \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -- ".fzf#shellescape(<q-args>), fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)
        ]]
    end,
    config = function()
        nihil.utils.keymap.map_keys {
            ['<c-e>'] = ':FzfFiles<cr>',
            ['<c-f>'] = ':FzfBLines<cr>',
            ['<c-s-f>'] = ':FzfRg<cr>',
            ['<c-a-f>'] = ':FzfRg<cr>',
            ['<leader>b'] = ':FzfBuffers<cr>',
            ['<leader><s-b>'] = ':FzfWindows<cr>',
            ['<leader><s-o>'] = ':FzfBTags<cr>',
            ['<leader>o'] = ':FzfTags<cr>',
            ['<leader>?'] = ':FzfHistory<cr>',
        }
    end,
}
