set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"

set -gx EDITOR nvim
set -gx BAT_CONFIG_PATH "$XDG_CONFIG_HOME/bat/bat.conf" # custom `bat` config path
set -gx LESSHISTFILE - # disable Less history file

## WSL
set -gx WINDOW_CLIPBOARD '/mnt/c/Windows/System32/clip.exe'


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
## FZF configs

set -gx FZF_DEFAULT_COMMAND "rg --files --follow"
set -gx FZF_DEFAULT_OPTS "
	--height 80%
	--reverse
	--border

	--color header:italic
	--color gutter:-1
	--color bg+:#313244,spinner:#f5e0dc,hl:#f38ba8
	--color fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
	--color marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8

	--bind ctrl-p:toggle-preview
    --bind ctrl-l:accept,ctrl-o:accept
	--bind alt-j:preview-down,alt-k:preview-up
	--bind ctrl-alt-j:preview-page-down,ctrl-alt-k:preview-page-up
"

set -l FZF_FILE_DISPLAY_OPTS "
    --preview 'bat --style=numbers --color=always --line-range :500 {}'
    --preview-window right:50%:hidden
"

set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND \
    --glob '!.git' \
    --glob '!**/node_modules' \
    --glob '!.next' \
"
set -gx FZF_CTRL_T_OPTS "
	$FZF_FILE_DISPLAY_OPTS
	--bind 'ctrl-y:execute-silent(echo -n {} | $WINDOW_CLIPBOARD)+abort'
	--header 'Press CTRL-Y to copy relative path into clipboard'
"

# set -gx FZF_CTRL_R_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_CTRL_R_OPTS "
	$FZF_FILE_DISPLAY_OPTS
	--bind 'ctrl-y:execute-silent(echo -n {2..} | $WINDOW_CLIPBOARD)+abort'
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
	$FZF_FILE_DISPLAY_OPTS
    --preview 'tree -C {}'
"
