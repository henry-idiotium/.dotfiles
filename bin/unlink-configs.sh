#!/bin/bash

SCRIPT_DIR=$(dirname "$0")

source $SCRIPT_DIR/__params.sh ## import capture params
source $SCRIPT_DIR/__var.sh ## import variables

while IFS= read -r symlink_path; do
	printf "Remove symlink: $symlink_path\n"
	if $test_output; then continue; fi

	command rm $symlink_path
done < $symlink_logfile_path

