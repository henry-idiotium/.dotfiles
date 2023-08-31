require 'nihil'

vim.cmd [[
    if &term == "screen-256color" || &term == "tmux-256color" || &term == "screen" || &term == "tmux"
        map <esc>[1;5D <C-Left>
        map! <esc>[1;5D <C-Left>
        map <esc>[1;5C <C-Right>
        map! <esc>[1;5C <C-Right>
    endif
]]
