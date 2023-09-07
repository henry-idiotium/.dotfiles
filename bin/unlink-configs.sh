#!/bin/bash

. __share_params.sh ## import capture params
. __var.sh ## import variables

while IFS= read -r symlink_path; do
	printf "Remove symlink: $symlink_path\n"
	if $test_output; then continue; fi

	command rm $symlink_path
done < $symlink_logfile_path

