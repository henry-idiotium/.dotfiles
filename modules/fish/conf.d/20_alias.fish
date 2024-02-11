alias cp 'cp -iv'
alias mv 'mv -iv'
alias mkdir 'mkdir -pv'
alias which 'type -a'
alias l 'ls -l'
alias la 'l -a'
alias vi nvim
alias g git
alias cat bat
alias mkcd make-then-cd-into-dir

if type -q exa
    alias ls 'exa --icons --group-directories-first'
    alias lg 'la --git --git-ignore'
end
