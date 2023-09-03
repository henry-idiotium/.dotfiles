set -gx EDITOR         nvim
set -gx CONFIG_PATH  "$HOME/.config"

# Init path
fish_add_path -g \
	$HOME/bin \
	$HOME/.local/bin


# Fast Node Manager
fish_add_path -g $HOME/.fnm
eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"


# BAT
set -gx BAT_CONFIG_PATH "$CONFIG_PATH/bat/bat.conf"


# PNPM
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if [ -z "$(string match -ra $PNPM_HOME $PATH)" ]
	fish_add_path -g $PNPM_HOME
end


# disable Less history file
set -gx LESSHISTFILE '-'


# `pj` plugins config
set -gx PROJECT_PATHS \
	'/mnt/c/Users/Henry/Documents/.main/personal/projects'

