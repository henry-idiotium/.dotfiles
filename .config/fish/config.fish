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
set -gx TERM wezterm # enable undercurl (~/.terminfo/w/wezterm)
set -gx EDITOR vi

fish_add_path -g ~/bin ~/.local/bin
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
alias nvimdiff 'nvim -d'
alias g git
alias cat bat
alias ls 'eza -laU --icons --no-filesize --no-user --group-directories-first'
alias l ls

alias git_dotfiles 'git -C $HOME --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias gd git_dotfiles

# user defined functions folder
set -a fish_function_path \
    $__fish_config_dir/functions/user.d/ \
    $__fish_config_dir/functions/user.d/*/

## keymaps
function fish_user_key_bindings
    fish_vi_key_bindings

    # unbind keys
    for key in \cd \cs
        bind -e --preset $key
        bind -e --preset -M insert $key
        bind -e --preset -M visual $key
    end

    bind \cq exit
    bind -M insert -m default jj ''

    __bind -m default,visual L end-of-line
    __bind -m default,visual H beginning-of-line

    __bind -m insert \ce fzf_search_path
    __bind -m insert \cd 'fzf_search_base_dir ~/.config/'
    __bind -m insert \cn 'fzf_search_base_dir ~/documents/notes/'
    __bind -m insert \cp 'fzf_search_base_dir ~/documents/projects/'
    __bind -m insert \ct 'fzf_search_base_dir ~/documents/throwaways/'
    __bind -m insert \cr 'fzf_search_run ~/documents/scripts/'
end
