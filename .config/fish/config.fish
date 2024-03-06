# theme
set -U fish_greeting ""
set -g fish_prompt_pwd_dir_length 1
set -g theme_color_scheme "Catppuccin Mocha"
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

# vi mode
fish_vi_key_bindings
set -U fish_vi_force_cursor true
set -U fish_cursor_default block
set -U fish_cursor_insert line
set -U fish_cursor_replace_one underscore
set -U fish_cursor_visual block

## env
set -gx EDITOR /usr/bin/nvim
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"

fish_add_path -g ~/.local/bin
fish_add_path -g ~/.local/share/pnpm
fish_add_path -g ~/.bun/bin
fish_add_path -g ~/.cargo/bin
fish_add_path -g ~/.local/share/fnm && type -q fnm && fnm env --use-on-cd --shell=fish --version-file-strategy=recursive | source

## aliases
alias cp 'cp -iv'
alias mv 'mv -iv'
alias rm 'rm -iv'
alias mkdir 'mkdir -pv'
alias which 'type -a'
alias ls 'ls -Gp'
alias la 'ls -lA'
alias vi nvim
alias g git
alias cat bat

type -q exa && alias l 'exa -laU --icons --no-filesize --no-user --group-directories-first'
type -q zoxide && zoxide init fish --cmd j | source

## keymaps
bind -M insert jj 'commandline -P && commandline -f cancel || set fish_bind_mode default && commandline -f backward-char repaint-mode'
bind -M default \cq exit # close session

bind L end-of-line
bind H beginning-of-line
bind -M visual L end-of-line
bind -M visual H beginning-of-line

## configs
switch "$(uname -sr)"
    case Darwin
        source $__fish_config_dir/config-macos.fish
    case Linux
        source $__fish_config_dir/config-linux.fish
    case 'Linux*WSL*'
        source $__fish_config_dir/config-wsl.fish
end

set -l local_conf_file $__fish_config_dir/config-local.fish
test -f $local_conf_file && source $local_conf_file
