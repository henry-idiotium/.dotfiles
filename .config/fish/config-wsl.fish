set -gx WINDOW_CLIPBOARD (type -q win32yank.exe && echo 'clip.exe' || echo 'win32yank.exe')

alias ofe open-file-explorer
function open-file-explorer
    set explorer 'explorer.exe'

    if ! command -vq "$explorer"
        printf '\n Not found window explorer\n\n'
        return
    end

    set path_dir (test -n "$argv" && echo "$argv" || echo '.')
    command "$explorer" "$path_dir"
end
