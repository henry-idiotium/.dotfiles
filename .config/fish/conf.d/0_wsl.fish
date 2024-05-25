not string match -q 'Linux*WSL*' -- (uname -sr); and return

set -gx CLIPBOARD (command -vq win32yank.exe && echo win32yank.exe -i || echo clip.exe)

alias pwsh 'pwsh.exe -WorkingDirectory "~"'
alias ofe 'xdg-open .'
