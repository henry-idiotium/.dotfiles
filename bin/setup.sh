#!/bin/bash

. __share_params.sh ## import capture params

# ------------------------
# Require FISH to continue
if ! command -v fish &> /dev/null; then
    echo "Error: Fish could not be found! Please install." 1>&2
    exit 64
fi

. __var.sh ## import variables

# ------------------------
# Symlink modules

if ! $test_output; then
	: > "$symlink_logfile_path" # empty symlink log file
fi


symlink_config() {
	item_path=$1
	dest_path=${2-$config_path}
	symlink_path="$dest_path/$(basename $item_path)"

    printf "Set symlink: $entry --> $symlink_path\n"
	if $test_output; then return; fi

	ln -sf $item_path $dest_path
	echo $symlink_path >> "$symlink_logfile_path"
}

## configs in `modules` dir
shopt -s dotglob
for entry in "$modules_path"/*; do
	symlink_config $entry
done
shopt -u dotglob

## gitconfig
symlink_config $externals_path/.gitconfig ~

