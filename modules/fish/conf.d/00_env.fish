set -gx EDITOR 'nvim'
set -gx XDG_CONFIG_HOME ([ -n "$XDG_CONFIG_HOME" ] && echo $XDG_CONFIG_HOME || echo "$HOME/.config" )

# Init path
fish_add_path -g \
	$HOME/bin \
	$HOME/.local/bin

set -gx BAT_CONFIG_PATH "$XDG_CONFIG_HOME/bat/bat.conf" # custom `bat` config path
set -gx LESSHISTFILE '-' # disable Less history file
set -gx WINDOW_HOME '/mnt/c/Users/Henry'
set -gx PROJECT_PATHS "$HOME/documents/projects" # `pj` fish plugins config
# \ "$WINDOW_HOME/Documents/.main/personal/projects"

# Fast Node Manager
fish_add_path -g $HOME/.fnm
eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"

# PNPM
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
fish_add_path -g $PNPM_HOME


