#!/bin/bash


config_path=${XDG_CONFIG_HOME-$HOME/.config}
dotfiles_path="$config_path/dotfiles"
modules_path="$dotfiles_path/modules"  ## config modules for `.config` dir
externals_path="$dotfiles_path/externals"  ## config modules for NON `.config` dir
log_path="$dotfiles_path/.log"

mkdir -pv "$log_path"
symlink_logfile_path="$log_path/config_symlinks"

