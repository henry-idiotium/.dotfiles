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

# NOTE: for FZF execute binds
set -gx FZF_ADDITIONAL_OPTS \
    --bind ctrl-y:execute'(echo {} | win32yank.exe -i)'

set -gx FD_DEFAULT_OPTS --follow --hidden
set -gx RG_DEFAULT_OPTS $FD_DEFAULT_OPTS --files --sortr modified

set -gx FZF_HOME_PROJECTS \
    ~/.config/ \
    ~/documents/ \
    ~/documents/works/ \
    ~/documents/projects/ \
    ~/documents/throwaways/ \
    ~/bin/.local/scripts/


set -gx fzf_cmd fzf $FZF_ADDITIONAL_OPTS
set -gx find_cmd fd $FD_DEFAULT_OPTS

# -------- Actions ------------------------------------------------
function fzf-home-projects
    begin
        string unescape $FZF_HOME_PROJECTS
        $find_cmd -a -d 1 -t d -- . $FZF_HOME_PROJECTS
    end \
        | sort -ur \
        | string replace "$HOME/" '' \
        | $fzf_cmd --prompt " > " \
        | read -l result
    or return

    __open-path ~/$result
end

function fzf-search-path
    set token (eval echo -- (commandline -t)) # expand vars & tidle
    set token (string unescape -- $token) # unescape to void compromise the path

    set -fa find_cmd --no-require-git

    # If the current token is a directory and has a trailing slash,
    # then use it as fd's base directory.
    if [ -d "$token" ] && string match -q -- "*/" $token
        set -fa find_cmd --base-directory $token
        set -fa fzf_cmd --prompt " $token> "
        set -f result $token($find_cmd | $fzf_cmd; or return)
    else
        set -fa fzf_cmd --prompt " > " --query "$token"
        set -f result ($find_cmd | $fzf_cmd; or return)
    end

    __open-path $result
end

function __open-path -d "Open a path in the current directory"
    set -f path $argv
    set -f token

    [ -f "$path" -a -w "$path" ]; and set token $EDITOR

    set -a token (string replace $HOME '~' (string escape -n $path))

    # add to history
    set -f hist_file ~/.local/share/fish/fish_history
    echo "- cmd:" (string unescape -n $token) >>$hist_file
    echo "  when:" (date "+%s") >>$hist_file
    history --merge # merge history file with (empty) internal history

    # execute command
    eval $token
    set fish_bind_mode insert
    commandline -f repaint-mode
end

# alias sort-paths "xargs -I {} stat --printf '%Y\t%n\n' '{}' | sort -gr -S 10% --parallel 4 | cut -f2"
