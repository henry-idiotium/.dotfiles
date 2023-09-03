#!/bin/bash

config_path=${XDG_CONFIG_PATH-$HOME/.config}
module_path="$config_path/dotfiles/modules"

# ------------------------
# Symlink modules

shopt -s dotglob
for entry in "$module_path"/*; do
    printf "Remove symlink: $config_path/$(basename ${entry})\n"
	command rm "$config_path/$(basename ${entry})"
done
shopt -u dotglob

