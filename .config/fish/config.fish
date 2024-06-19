## fish options
set -U fish_greeting ''
set -U fish_vi_force_cursor true
set -U fish_cursor_insert line blink
set -U fish_cursor_default block blink

## plugins
if functions -q fundle
    fundle plugin IlanCosman/tide@v6
    fundle plugin jorgebucaran/autopair.fish
    fundle init
else
    eval (curl -sfL https://git.io/fundle-install)
end

## aliases
alias cp 'cp -iv'
alias mv 'mv -iv'
alias rm 'rm -iv'
alias mkdir 'mkdir -pv'
alias which 'type -a'
alias vi nvim
alias ls 'eza -laU --icons --no-filesize --no-user --group-directories-first'
alias l ls
alias g git
alias gd 'git --git-dir $HOME/.dotfiles -C $HOME --work-tree $HOME'

## keymaps
function fish_user_key_bindings
    for key in \cd \cs # unbind keys (run in fish_user_key_bindings to ensure it works)
        bind -e --preset $key
        bind -e --preset -M insert $key
        bind -e --preset -M visual $key
    end
end

# actions
bind \cq exit
bind -M insert -m default jj ''
bind -M insert -m default jk ''

bind -M insert \cy forward-char # accept inline suggestion

bind L end-of-line
bind H beginning-of-line
bind -M visual L end-of-line
bind -M visual H beginning-of-line

# scripts
# script closing
set -l _sc "; echo; commandline -t ''; commandline -f repaint-mode; set fish_bind_mode insert;"
bind -M insert \e\; '[ -z "$TMUX" ] && tmuxizer'$_sc
bind -M insert \cp '[ -z "$fish_private_mode" ] && fish --private || echo -e \n(set_color yellow)ALready in private mode !!'$_sc

# extenal scripts needed to be sourced, otherwise it won't work as expected
alias fzf-search-path 'source (type -p fzf_search_path)'
alias fzf-home-projects 'source (type -p fzf_home_projects)'

bind -M insert \ce fzf-search-path
bind -M insert \cd fzf-home-projects


## os
switch (uname -sr)
    case 'Linux*WSL*'
        source (dirname (status --current-filename))/config-wsl.fish
end
