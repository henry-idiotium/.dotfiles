alias pwsh 'pwsh.exe -WorkingDirectory "~"'
alias update-scoop "pwsh -c 'scoop update | scoop status | foreach { scoop update \$_.Name }'"

function get-window-home
    # flag_u: unix  |  flag_m: windows
    argparse -n get-window-home u m -- $argv; or return
    set path (cmd.exe /c '<nul set /p=%UserProfile%' 2>/dev/null) # still in Windows path (forward slashes)

    if set -q _flag_m
        echo $path
        return
    end

    wslpath -u $path
end

function open-wezterm-config
    $EDITOR (get-window-home)/.config/wezterm/wezterm.lua
end
