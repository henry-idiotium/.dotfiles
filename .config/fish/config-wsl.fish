set -gx WINDOW_CLIPBOARD (type -q win32yank.exe && echo 'win32yank.exe' || echo 'clip.exe')

set -l explorer_path 'explorer.exe'
if ! command -vq "$explorer_path"
    function ofe -d "Open directory in a Windows's explorer"
        command "$explorer_path" .
    end
end
