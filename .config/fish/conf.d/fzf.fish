set -U fzf_cmd fzf \
    --ansi --cycle --reverse --info inline-right --color header:italic,gutter:-1 \
    --bind ctrl-l:accept \
    --bind ctrl-i:beginning-of-line,ctrl-a:end-of-line \
    --bind ctrl-alt-u:preview-page-up,ctrl-alt-d:preview-page-down \
    --bind alt-g:first,alt-G:last

set -U fzf_fd_cmd fd \
    --follow --hidden --no-ignore --no-require-git --color always \
    --exclude .git \
    --exclude node_modules


# -------- functions ------------------------------------------------

function fzf_change_document
    set -fa fzf_cmd --prompt ' Documents> '
    set -fa fzf_fd_cmd --exact-depth 1 --type directory \
        --base-directory $HOME \
        -- . .config documents \
        documents/throwaways \
        documents/personal \
        documents/projects \
        documents/work

    set -f result $HOME/($fzf_fd_cmd | $fzf_cmd; or return)

    __fzf_open_path $result
end

function fzf_search_path
    set -f token (eval echo -- (commandline -t)) # expand vars & tidle
    set token (string unescape -- $token) # unescape to void compromise the path

    # If the current token is a directory and has a trailing slash,
    # then use it as fd's base directory.
    if string match -q -- "*/" $token && test -d "$token"
        set -fa fzf_fd_cmd --base-directory $token
        set -fa fzf_cmd --prompt " $token> "
        set -f result $token($fzf_fd_cmd | $fzf_cmd; or return)
    else
        set -fa fzf_cmd --prompt " > " --query "$token"
        set -f result ($fzf_fd_cmd | $fzf_cmd; or return)
    end

    __fzf_open_path $result
end

function __fzf_open_path -d 'FZF helper to open path'
    set -f path $argv[1]
    [ -f "$path" -a -w "$path" ]; and set -f token $EDITOR

    set -fa token (string replace $HOME '~' (string escape -n $path))

    # add to history via executing input token
    commandline -t "$token "
    commandline -f repaint execute
end
