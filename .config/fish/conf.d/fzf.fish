set -U fzf_cmd fzf \
    --header-first --ansi --cycle --reverse --info inline-right \
    --preview-window right:50%,hidden \
    --color header:italic,gutter:-1 \
    --bind ctrl-l:accept \
    --bind ctrl-i:beginning-of-line,ctrl-a:end-of-line \
    --bind alt-p:toggle-preview,alt-z:toggle-preview-wrap \
    --bind ctrl-u:preview-up,ctrl-d:preview-down \
    --bind ctrl-alt-u:preview-page-up,ctrl-alt-d:preview-page-down

if [ -n "$TMUX" ]
    set -a fzf_cmd \
        --bind 'ctrl-alt-n:execute-silent(tmux new-window -dc (dirname (readpath {})))' \
        --bind 'ctrl-alt-v:execute-silent(tmux split-window dirname (readpath {}))'
end

set -U fzf_fd_cmd fd \
    --hidden \
    --no-ignore \
    --color always \
    --exclude .git \
    --exclude .next \
    --exclude dist \
    --exclude node_modules
