# NOTE: only have logic window explorer.
function open-file-explorer
	set explorer '/mnt/c/windows/explorer.exe'

	if ! command -vq "$explorer"
		printf '\n Not found window explorer\n\n'
		return
	end

    set path_dir (test -n "$argv" && echo "$argv" || echo '.')
    command "$explorer" "$path_dir"
end

