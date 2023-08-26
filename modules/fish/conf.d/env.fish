set -gx EDITOR      nvim
set -gx VISUAL      nvim
set -g -x CONFIG_PATH "$HOME/.config"

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

