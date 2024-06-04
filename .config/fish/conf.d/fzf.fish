bind -M insert \ce fzf-search-path
bind -M insert \cd fzf-home-projects


set -gx FZF_DEFAULT_OPTS \
    --ansi \
    --cycle \
    --reverse \
    --inline-info \
    # keymaps
    --bind ctrl-q:abort \
    --bind ctrl-l:accept \
    --bind ctrl-i:beginning-of-line,ctrl-a:end-of-line \
    --bind alt-g:first,alt-G:last \
    --bind tab:toggle+down,btab:toggle+up \
    # theme
    --color header:italic,gutter:-1 \
    --color fg:#908CAA,hl:#EA9A97 \
    --color fg+:#E6E6E6,bg+:#1F1F24,hl+:#EA9A97 \
    --color border:#44415A,header:#3E8FB0 \
    --color spinner:#F6C177,info:#9CCFD8,separator:#44415A \
    --color pointer:#C4A7E7,marker:#EB6F92,prompt:#908CAA

set -gx FD_DEFAULT_OPTS --follow --hidden
set -gx RG_DEFAULT_OPTS $FD_DEFAULT_OPTS --files --sortr modified

set -g __fzf_cmd fzf $FZF_DEFAULT_OPTS \
    # NOTE: setting these in FZF_DEFAULT_OPTS makes `fzf` confused?
    --bind alt-y:execute'(echo {} | win32yank.exe -i)'

set -g __find_cmd fd $FD_DEFAULT_OPTS

set -g __fzf_home_projects \
    ~/.config/ \
    ~/documents/ \
    ~/documents/works/ \
    ~/documents/projects/ \
    ~/documents/throwaways/ \
    ~/bin/.local/

# -------- Actions ------------------------------------------------
function fzf-home-projects
    set -fa __fzf_cmd --prompt " > "
    set -fa __find_cmd

    begin
        string unescape $__fzf_home_projects
        $__find_cmd -a -d 1 -- . $__fzf_home_projects
    end \
        | sort -ur \
        | string replace "$HOME/" '' \
        | $__fzf_cmd \
        | read -l result
    or return

    vicd-path ~/$result
end

function fzf-search-path
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

    vicd-path $result
end


# -------- Helpers ------------------------------------------------
function vicd-path -d 'FZF helper to open path'
    set -f path $argv[1]
    set -f token

    if [ -f "$path" -a -w "$path" ] # file
        set token $EDITOR
    else if [ -d "$path" ] # dir
        # not status is-interactive; and set token cd
    else
        return
    end

    set -a token (string replace $HOME '~' (string escape -n $path))

    history-add $token
    eval $token
    set fish_bind_mode insert
    commandline -f repaint-mode
end

function history-add
    set -f hist_file $XDG_DATA_HOME/fish/fish_history

    # append our command 
    begin
        echo "- cmd:" (string unescape -n $argv)
        echo "  when:" (date "+%s")
    end >>$hist_file

    # merge history file with (empty) internal history
    history --merge
end

# alias sort-paths "xargs -I {} stat --printf '%Y\t%n\n' '{}' | sort -gr -S 10% --parallel 4 | cut -f2"
