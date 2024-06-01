set -U fish_greeting ''
set -U fish_vi_force_cursor true
set -U fish_cursor_insert line blink
set -U fish_cursor_default block blink


## env
set -gx XDG_CONFIG_HOME ~/.config/
set -gx XDG_CACHE_HOME ~/.cache/
set -gx XDG_DATA_HOME ~/.local/share/
set -gx XDG_STATE_HOME ~/.local/state/
set -gx XDG_RUNTIME_DIR /run/user/1000/

set -gx MY_NOTE_HOME ~/documents/notes/
set -gx MY_PROJECT_HOME ~/documents/projects/
set -gx MY_WORK_HOME ~/documents/works/
set -gx MY_THROWAWAY_HOME ~/documents/throwaways/

set -gx TERM wezterm # enable undercurl ~/.terminfo/w/wezterm
set -gx GIT_EDITOR nvim # nvim cus git uses sh internally
set -gx EDITOR vi

fish_add_path -g ~/.local/bin # third parties' stuffs
fish_add_path -g ~/bin/.local # user scripts
fish_add_path -g ~/.bun/bin ~/.cache/.bun/bin
fish_add_path -g ~/.cargo/bin
fish_add_path -g ~/go/bin
fish_add_path -g $XDG_DATA_HOME/bob/nvim-bin
fish_add_path -g $XDG_DATA_HOME/fnm && type -q fnm && fnm env --use-on-cd --shell=fish --version-file-strategy=recursive | source


## aliases
alias cp 'cp -iv'
alias mv 'mv -iv'
alias rm 'rm -iv'
alias mkdir 'mkdir -pv'
alias which 'type -a'
alias vi nvim
alias g git
alias cat bat
alias ls 'eza -laU --icons --no-filesize --no-user --group-directories-first'
alias l ls

alias gd 'git --git-dir=$HOME/.dotfiles -C $HOME --work-tree=$HOME'


## keymaps
function fish_user_key_bindings
    fish_vi_key_bindings

    set -l keys_to_unbind \cd \cs

    # unbind keys (run in fish_user_key_bindings to ensure it works)
    for key in $keys_to_unbind
        bind -e --preset $key
        bind -e --preset -M insert $key
        bind -e --preset -M visual $key
    end
end


# actions
bind \cq exit
bind -M insert -m default jj ''
bind -M insert -m default jk ''

bind L end-of-line
bind H beginning-of-line
bind -M visual L end-of-line
bind -M visual H beginning-of-line

bind -M insert \cy forward-char # accept inline suggestion

# scripts
set -l __script_suffix '; echo; commandline -t ''; commandline -f repaint-mode'
bind -M insert \e\; "start-tmux $__script_suffix"
