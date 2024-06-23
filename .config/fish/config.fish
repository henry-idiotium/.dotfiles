## fish options
set -U fish_greeting ''
set -U fish_vi_force_cursor true
set -U fish_cursor_insert line blink
set -U fish_cursor_default block blink

## plugins
if functions -q fundle
    fundle plugin IlanCosman/tide@v6
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
    fish_vi_key_bindings
    for key in \cd \cs # unbind keys (run in fish_user_key_bindings to ensure it works)
        bind --erase --preset $key
        bind --erase --preset -M insert $key
        bind --erase --preset -M visual $key
    end

    # actions
    bind --preset \cq exit
    bind --preset -M insert -m default jj ''
    bind --preset -M insert -m default jk ''
    bind --preset -M insert \cy forward-char # accept inline suggestion
    bind --preset L end-of-line
    bind --preset H beginning-of-line
    bind --preset -M visual L end-of-line
    bind --preset -M visual H beginning-of-line

    # scripts
    # script closing
    set -l _sc "; echo; commandline -t ''; commandline -f repaint-mode; set fish_bind_mode insert;"
    bind --preset -M insert \e\; '[ -z "$TMUX" ] && tmuxizer'$_sc
    bind --preset -M insert \cp '[ -z "$fish_private_mode" ] && fish --private || echo -e \n(set_color yellow)Private mode is active!!'$_sc

    # extenal scripts needed to be sourced, otherwise it won't work as expected
    alias fzf-search-path 'source (type -p fzf_search_path)'
    alias fzf-home-projects 'source (type -p fzf_home_projects)'
    bind --preset -M insert \ce fzf-search-path
    bind --preset -M insert \cd fzf-home-projects
end

## os
switch (uname -sr)
    case 'Linux*WSL*'
        source (dirname (status --current-filename))/config-wsl.fish
end
