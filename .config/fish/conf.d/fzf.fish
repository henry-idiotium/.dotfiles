set -gx FZF_DEFAULT_OPTS \
    --padding 1 \
    --cycle --reverse \
    --marker │ --pointer ┃ \
    --ansi --inline-info \
    # keymaps -------------------
    --bind ctrl-l:accept,ctrl-q:abort,ctrl-s:toggle \
    --bind ctrl-i:beginning-of-line,ctrl-a:end-of-line \
    --bind alt-g:first,alt-G:last \
    # theme ---------------------
    --color header:italic,header:#3E8FB0,gutter:-1 \
    --color fg:#908CAA,fg+:#E6E6E6,bg+:#1F1F24 \
    --color hl:#EA9A97,hl+:#EA9A97,border:#44415A \
    --color spinner:#F6C177,info:#9CCFD8,separator:#44415A \
    --color pointer:#C4A7E7,marker:#EB6F92,prompt:#908CAA


## For other parties to use
set -gx FD_DEFAULT_OPTS \
    --follow --hidden \
    --ignore-file $GLOBAL_IGNORE_FILE

set -gx FZF_HOME_PROJECTS \
    $MY_WORK_HOME/ $MY_PROJECT_HOME/ $MY_THROWAWAY_HOME/ $MY_SCRIPT_HOME/ \
    ~/.config/ ~/documents/


## For only scripts use
set -gx fzf_cmd fzf
[ -n "$TMUX" ]; and set -gxa fzf_cmd --tmux 70%,85% --border rounded

set -gx find_cmd fd $FD_DEFAULT_OPTS \
    --no-require-git \
    --no-ignore-vcs
