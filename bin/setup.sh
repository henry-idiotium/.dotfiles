#!/bin/bash


# ------------------------
# Require FISH to continue
if ! command -v fish &> /dev/null; then
    echo "Error: Fish could not be found! Please install."
    exit
fi


config_path=${XDG_CONFIG_PATH-$HOME/.config}
module_path="$config_path/dotfiles/modules"

# ------------------------
# Symlink modules

shopt -s dotglob
for entry in "$module_path"/*; do
    printf "Set symlink: $entry --> $config_path/$(basename ${entry})\n"
    ln -sf $entry $config_dir
done
shopt -u dotglob

