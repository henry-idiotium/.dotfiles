not string match -q 'Linux*WSL*' -- (uname -sr); and return

# wslpath convert to linux path
# set -gx WINDOWS_HOME (wslpath (cmd.exe /c '<nul set /p=%UserProfile%' 2>/dev/null))

alias pwsh 'pwsh.exe -WorkingDirectory "~"'
alias update-scoop 'pwsh -c "scoop update | scoop status | foreach { scoop update $_.Name }"'
