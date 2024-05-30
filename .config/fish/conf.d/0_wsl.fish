not string match -q 'Linux*WSL*' -- (uname -sr); and return

# set -gx CLIPBOARD (command -vq win32yank.exe && echo win32yank.exe -i || echo clip.exe)

# wslpath convert to linux path
set -gx WINDOWS_HOME (wslpath (cmd.exe /c '<nul set /p=%UserProfile%' 2>/dev/null))

alias pwsh 'pwsh.exe -WorkingDirectory "~"'
alias update-scoop "pwsh -c 'scoop update | scoop status | foreach { scoop update \$_.Name }'"

function ofe -d "Open Windows File Explorer."
    set -f path $argv
    [ -z "$path" ] && set path .

    xdg-open "$argv"
end
