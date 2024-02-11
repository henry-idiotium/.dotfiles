if ! string match -q "*WSL*" (uname -r)
    exit 0
end

set -gx WINDOW_CLIPBOARD '/mnt/c/Windows/System32/clip.exe'

alias ofe open-file-explorer
function open-file-explorer
    set explorer '/mnt/c/Windows/explorer.exe'

    if ! command -vq "$explorer"
        printf '\n Not found window explorer\n\n'
        return
    end

    set path_dir (test -n "$argv" && echo "$argv" || echo '.')
    command "$explorer" "$path_dir"
end
