set -U fish_greeting ''
set -U fish_vi_force_cursor true


## env
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx TERM wezterm # enable undercurl (~/.terminfo/w/wezterm)
set -gx EDITOR vi

fish_add_path -g ~/.local/bin
fish_add_path -g ~/.bun/bin
fish_add_path -g ~/.cache/.bun/bin
fish_add_path -g ~/.cargo/bin
fish_add_path -g ~/.local/share/fnm && type -q fnm && fnm env --use-on-cd --shell=fish --version-file-strategy=recursive | source


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


## keymaps
function fish_user_key_bindings
    fish_vi_key_bindings

    # unbind keys
    for key in \cd
        bind -e --preset $key
        bind -e --preset -M insert $key
        bind -e --preset -M visual $key
    end

    bind -M insert jj 'set fish_bind_mode default; commandline -f repaint'
    bind \cq exit

    bind L end-of-line
    bind H beginning-of-line
    bind -M visual L end-of-line
    bind -M visual H beginning-of-line
end
