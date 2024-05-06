not status is-interactive; and exit 0

set -U fish_greeting ''
set -U fish_vi_force_cursor true
set -U fish_cursor_insert line blink
set -U fish_cursor_default block blink


## env
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx TERM wezterm # enable undercurl  ~/.terminfo/w/wezterm
set -gx GIT_EDITOR nvim # git doesn't understand aliases
set -gx EDITOR vi

fish_add_path -g ~/.local/bin ~/bin ~/bin/.local/ ~/bin/.local/scripts/
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

# custom funcs
bind -M insert \ce fzf_search_path
bind -M insert \cd fzf_main_dirs

# scripts
function bind-script
    argparse -n bind-script 'M=+' -- $argv; or return
    bind -M $_flag_M $argv[1] "$argv[2]; echo; commandline -t ''; commandline -f repaint-mode"
end

bind-script -M insert \e\; start-tmux


functions -e bind-script
