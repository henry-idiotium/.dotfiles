bind -M insert \ce fzf-search-path
bind -M insert \cd fzf-home-projects


set -gx FZF_DEFAULT_OPTS \
    --ansi \
    --highlight-line \
    --inline-info \
    --padding 1,2 \
    --cycle --reverse \
    --marker │ --pointer ┃ \
    # keymaps
    --bind ctrl-l:accept,ctrl-q:abort,ctrl-s:toggle \
    --bind ctrl-i:beginning-of-line,ctrl-a:end-of-line \
    --bind alt-g:first,alt-G:last \
    # theme
    --color header:italic,gutter:-1 \
    --color fg:#908CAA,hl:#EA9A97 \
    --color fg+:#E6E6E6,bg+:#1F1F24,hl+:#EA9A97 \
    --color border:#44415A,header:#3E8FB0 \
    --color spinner:#F6C177,info:#9CCFD8,separator:#44415A \
    --color pointer:#C4A7E7,marker:#EB6F92,prompt:#908CAA


set -gx FD_DEFAULT_OPTS \
    --follow --hidden \
    --ignore-file $GLOBAL_IGNORE_FILE

set -gx RG_DEFAULT_OPTS \
    --follow --hidden --files --sortr modified \
    --ignore-file $GLOBAL_IGNORE_FILE

set -gx FZF_HOME_PROJECTS \
    ~/.config/ \
    ~/documents/ \
    ~/documents/works/ \
    ~/documents/projects/ \
    ~/documents/throwaways/ \
    ~/bin/.local/scripts/

set -gx fzf_cmd fzf \
    --bind ctrl-y:execute-silent'(echo {} | win32yank.exe -i)'

[ -n "$TMUX" ]
and set -gxa fzf_cmd --tmux 70%,85% --border rounded

set -gx find_cmd fd $FD_DEFAULT_OPTS \
    --ignore-file ~/.config/dotfiles/gitignore \
    --no-require-git \
    --no-ignore-vcs


# -------- Actions ------------------------------------------------
function fzf-home-projects
    begin
        string unescape $FZF_HOME_PROJECTS
        $find_cmd -a -d 1 -t d -- . $FZF_HOME_PROJECTS
    end \
        | sort -ur \
        | string replace "$HOME/" '' \
        | $fzf_cmd --border-label ' Home Projects ' \
        | read -l result
    or return

    __open-path ~/$result
end

function fzf-search-path
    set token (eval echo -- (commandline -t)) # expand vars & tidle
    set token (string unescape -- $token) # unescape to void compromise the path

    # If the current token is a directory and has a trailing slash,
    # then use it as fd's base directory.
    if [ -d "$token" ] && string match -q -- "*/" $token
        $find_cmd --base-directory $token \
            | $fzf_cmd --border-label " $token " \
            | awk "{print $token\$1}" \
            | read -f result
        or return 1
    else
        $find_cmd \
            | $fzf_cmd --query "$token" --border-label " $(string replace $HOME '~' (pwd)) " \
            | read -f result
        or return 1
    end

    __open-path $result
end

function __open-path -d "Open a path in the current directory"
    set -f path $argv
    set -f token

    # NOTE: avoid possible multiple results (avoid fzf print action)
    if [ (count $argv) -gt 1 ]
        echo (set_color red)'fish fzf: too many arguments:'(set_color normal)
        for arg in $argv
            echo -e "\t->$arg"
        end
        return
    end

    # handlers
    [ -f "$path" -a -w "$path" ]; and set token $EDITOR # file
    #[ -d "$path" ]; and set token cd # dir

    # prettify path
    set -a token (string replace $HOME '~' (string escape -n $path))

    # add to history (if not in private mode)
    if [ -z "$fish_private_mode" ]
        set -f hist_file ~/.local/share/fish/fish_history

        echo '- cmd:' (string unescape -n $token) >>$hist_file
        echo '  when:' (date '+%s') >>$hist_file

        # merge history file with (empty) internal history
        history --merge
    end

    # execute command
    eval $token
    set fish_bind_mode insert
    commandline -f repaint-mode
end

# alias sort-paths "xargs -I {} stat --printf '%Y\t%n\n' '{}' | sort -gr -S 10% --parallel 4 | cut -f2"
