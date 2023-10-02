set -gx LOG_DEBUG false
set -gx EDITOR nvim
set -gx XDG_CONFIG_HOME "$HOME/.config" # config dir
set -gx BAT_CONFIG_PATH "$XDG_CONFIG_HOME/bat/bat.conf" # custom `bat` config path
set -gx LESSHISTFILE - # disable Less history file

set -gx WINDOW_HOME /mnt/c/Users/Henry

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

set -gx FZF_DEFAULT_COMMAND \
	'fd --type f --strip-cwd-prefix --hidden --follow
		--exclude .git
		--exclude .next
		--exclude node_modules
		--exclude dist
	'
