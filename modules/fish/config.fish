set -U fish_greeting ""
set -gx TERM xterm-256color

# theme
set -g theme_color_scheme "Catppuccin Mocha"
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

## vi mode
fish_vi_key_bindings
set -U fish_vi_force_cursor true
set -U fish_cursor_default block
set -U fish_cursor_insert line
set -U fish_cursor_replace_one underscore
set -U fish_cursor_visual block

## env
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx EDITOR nvim

fish_add_path -g ~/.local/bin
fish_add_path -g ~/.cargo/bin
fish_add_path -g ~/.local/share/pnpm
fish_add_path -g ~/.bun/bin
fish_add_path -g ~/.local/share/fnm && type -q fnm && fnm env --use-on-cd --shell=fish --version-file-strategy=recursive | source
type -q bat && set -gx BAT_CONFIG_PATH "$XDG_CONFIG_HOME/bat/bat.conf"

## aliases
alias cp 'cp -iv'
alias mv 'mv -iv'
alias rm 'rm -iv'
alias mkdir 'mkdir -pv'
alias which 'type -a'
alias ls 'ls -Gp'
alias la 'ls -A'
alias ll 'ls -l'
alias lla 'll -A'
type -q exa && alias l 'exa -laU --icons --no-filesize --no-user --group-directories-first'
type -q zoxide && zoxide init fish --cmd j | source
alias vi nvim
alias g git
alias cat bat

## keymaps
# unbind keys
bind \cd false
bind -M insert \cd false
bind -M visual \cd false

bind -M insert jj "commandline -P && commandline -f cancel || set fish_bind_mode default && commandline -f backward-char repaint-mode"
bind -M default \cq exit # close session

# move cursor to eol/sol
bind L end-of-line
bind H beginning-of-line
bind -M visual L end-of-line
bind -M visual H beginning-of-line

## configs
set FISH_CONF_D (dirname (status --current-filename))
switch "$(uname) $(uname -r)"
    case Darwin
        source $FISH_CONF_D/config-darwin.fish
    case Linux
        source $FISH_CONF_D/config-linux.fish
    case 'Linux*WSL*'
        source $FISH_CONF_D/config-wsl.fish
    case '*'
        echo 'Unable to detect OS specific fish config!!'
end

set LOCAL_CONFIG $FISH_CONF_D/config-local.fish
test -f $LOCAL_CONFIG && source $LOCAL_CONFIG
