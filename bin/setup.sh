#!/bin/bash


# ------------------------
# Require FISH to continue
if ! command -v fish &> /dev/null; then
    echo "Error: Fish could not be found! Please install."
    exit
fi


config_dir="$HOME/.config"
dotfile_dir="$config_dir/dotfiles"
module_dir="$dotfile_dir/modules"


# ------------------------
# Symlink modules

shopt -s dotglob
for entry in "$module_dir"/*; do
    printf "Set symlink: $entry --> $config_dir/$(basename ${entry})\n"
    ln -sf $entry $config_dir
done
shopt -u dotglob

