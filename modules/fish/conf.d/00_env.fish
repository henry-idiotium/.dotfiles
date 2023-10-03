set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"

set -gx EDITOR nvim
set -gx BAT_CONFIG_PATH "$XDG_CONFIG_HOME/bat/bat.conf" # custom `bat` config path
set -gx LESSHISTFILE - # disable Less history file

fish_add_path -g \
    $HOME/bin $HOME/.local/bin \
    $HOME/.cargo/bin \
    $HOME/.local/share/pnpm \
    $HOME/.bun/bin \
    $HOME/.fnm

# Fast Node Manager
if status is-interactive && type -q fnm
    fnm env --use-on-cd \
        --shell=fish \
        --version-file-strategy=recursive \
        | source
end

## -------------------------
set CLIPBOARD '/mnt/c/Windows/System32/clip.exe'
## FZF configs
set -gx FZF_DEFAULT_COMMAND "rg --files --follow"
set -gx FZF_DEFAULT_OPTS "
	--height 80%
	--reverse

    --preview 'bat --style=numbers --color=always --line-range :500 {}'
    --preview-window right:50%:hidden
	--color header:italic

	--bind ctrl-p:toggle-preview
    --bind ctrl-l:accept,ctrl-o:accept
	--bind alt-j:preview-down,alt-k:preview-up
	--bind ctrl-alt-j:preview-page-down,ctrl-alt-k:preview-page-up
"

set -gx FZF_CTRL_T_COMMAND "
    $FZF_DEFAULT_COMMAND \
    --hidden \
    --glob '!**/node_modules' \
    --glob '!.next' \
    --glob '!.git' \
"
set -gx FZF_CTRL_T_OPTS "
    $FZF_DEFAULT_OPTS
	--bind 'ctrl-y:execute-silent(echo -n {} | $CLIPBOARD)+abort'
	--header 'Press CTRL-Y to copy relative path into clipboard'
"

set -gx FZF_CTRL_R_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_CTRL_R_OPTS "
    $FZF_DEFAULT_OPTS
	--bind 'ctrl-y:execute-silent(echo -n {2..} | $CLIPBOARD)+abort'
	--header 'Press CTRL-Y to copy command into clipboard'
"

set -gx FZF_ALT_C_COMMAND "fd \
    --type directory \
    --exclude '.git' \
    --exclude '.next' \
    --exclude 'dist' \
    --exclude 'node_modules' \
"
set -gx FZF_ALT_C_OPTS "
    --preview 'tree -C {}'
"
