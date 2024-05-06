set -gx FZF_DEFAULT_OPTS \
    --ansi --cycle --reverse --inline-info \
    --color header:italic,gutter:-1 \
    --color fg:#908CAA,hl:#EA9A97 \
    --color fg+:#E6E6E6,bg+:#1F1F24,hl+:#EA9A97 \
    --color border:#44415A,header:#3E8FB0 \
    --color spinner:#F6C177,info:#9CCFD8,separator:#44415A \
    --color pointer:#C4A7E7,marker:#EB6F92,prompt:#908CAA \
    --bind ctrl-q:abort \
    --bind ctrl-l:accept \
    --bind ctrl-i:beginning-of-line,ctrl-a:end-of-line \
    --bind alt-g:first,alt-G:last \
    --bind tab:toggle+down,btab:toggle+up

set -gx RG_DEFAULT_OPTS \
    --sortr accessed --files --hidden --follow \
    --iglob !.git

# --color always \
set -gx FD_DEFAULT_OPTS \
    --follow --hidden --no-require-git \
    --exclude .git \
    --exclude node_modules

set -g __fzf_cmd fzf $FZF_DEFAULT_OPTS
set -g __find_cmd fd $FD_DEFAULT_OPTS

set -g fzf_main_dirs \
    ~/.config/ \
    ~/documents/personal/ \
    ~/documents/work/ \
    ~/documents/projects/ \
    ~/documents/throwaways/



# -------- FUNCTIONS ------------------------------------------------
function fzf_main_dirs
    set -fa __fzf_cmd --prompt ' Documents> '
    set -fa __find_cmd --type directory

    begin
        string join \n $fzf_main_dirs
        $__find_cmd --max-depth 1 -- . $fzf_main_dirs
    end \
        # # remove duplicates
        # | awk '!arr[$1]++' \
        | string replace "$HOME/" '' \
        | path sort \
        | $__fzf_cmd \
        | read -l result; or return

    __fzf_open_path ~/$result
end

function fzf_search_path
    set -f token (eval echo -- (commandline -t)) # expand vars & tidle
    set token (string unescape -- $token) # unescape to void compromise the path

    # If the current token is a directory and has a trailing slash,
    # then use it as fd's base directory.
    if string match -q -- "*/" $token && test -d "$token"
        set -fa __find_cmd --base-directory $token
        set -fa __fzf_cmd --prompt " $token> "
        set -f result $token($__find_cmd | $__fzf_cmd; or return)
    else
        set -fa __fzf_cmd --prompt " > " --query "$token"
        set -f result ($__find_cmd | $__fzf_cmd; or return)
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
