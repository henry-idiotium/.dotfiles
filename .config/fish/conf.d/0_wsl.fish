not string match -q 'Linux*WSL*' -- (uname -sr); and return

set -gx CLIPBOARD (command -vq win32yank.exe && echo win32yank.exe -i || echo clip.exe)

alias pwsh 'pwsh.exe -WorkingDirectory "~"'

function ofe -d "Open Windows File Explorer."
    set -f path $argv
    [ -z "$path" ] && set path .

    xdg-open "$argv"
end

set -gx WINDOWS_HOME (cmd.exe /c '<nul set /p=%UserProfile%' 2>/dev/null)
set WINDOWS_HOME (wslpath -u $WINDOWS_HOME) # convert to linux path
