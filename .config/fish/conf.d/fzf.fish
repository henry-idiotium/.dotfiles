set -gx FZF_DEFAULT_OPTS \
    --ansi --reverse --inline-info \
    --color header:italic,gutter:-1,marker:bright-red,pointer:bright-blue \
    --color bg+:#1F1F24 \
    --bind ctrl-q:abort \
    --bind ctrl-l:accept \
    --bind ctrl-i:beginning-of-line,ctrl-a:end-of-line \
    --bind alt-g:first,alt-G:last \
    --bind tab:toggle+down,btab:toggle+up

set -gx RG_DEFAULT_OPTS \
    --sortr accessed --files --hidden --follow \
    --iglob !.git

set -gx FD_DEFAULT_OPTS \
    --follow --hidden --no-require-git --color always \
    --exclude .git \
    --exclude node_modules

set -g fzf_bin fzf # fzf | sk
set -g fzf_base_doc_dirs \
    .config documents \
    documents/throwaways \
    documents/personal \
    documents/projects \
    documents/work



# -------- FUNCTIONS ------------------------------------------------
function fzf_change_document
    set -f fzf_cmd $fzf_bin $FZF_DEFAULT_OPTS \
        --prompt ' Documents> '
    set -f find_cmd fd $FD_DEFAULT_OPTS \
        --exact-depth 1 --type directory --base-directory $HOME -- . $fzf_base_doc_dirs

    __fzf_open_path $HOME/($find_cmd | $fzf_cmd; or return)
end

function fzf_search_path
    set -f token (eval echo -- (commandline -t)) # expand vars & tidle
    set token (string unescape -- $token) # unescape to void compromise the path

    set -f fzf_cmd $fzf_bin $FZF_DEFAULT_OPTS
    set -f find_cmd fd $FD_DEFAULT_OPTS

    # If the current token is a directory and has a trailing slash,
    # then use it as fd's base directory.
    if string match -q -- "*/" $token && test -d "$token"
        set -a find_cmd --base-directory $token
        set -a fzf_cmd --prompt " $token> "
        set -f result $token($find_cmd | $fzf_cmd; or return)
    else
        set -a fzf_cmd --prompt " > " --query "$token"
        set -f result ($find_cmd | $fzf_cmd; or return)
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
