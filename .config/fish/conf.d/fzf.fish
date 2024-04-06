bind -M insert \ce fzf_open_file
bind -M insert \cs 'fzf_run ~/documents/scripts/'
bind -M insert \cd 'fzf_open_file ~/.config/dotfiles/'
bind -M insert \cn 'fzf_open_file ~/documents/notes/'
bind -M insert \cp 'fzf_open_file ~/documents/projects/'
bind -M insert \ct 'fzf_open_file ~/documents/throwaways/'


set -U fzf_cmd fzf \
    --header-first --ansi --cycle --reverse \
    --preview-window right:50%,hidden \
    --color header:italic,gutter:-1 \
    --bind ctrl-l:accept \
    --bind ctrl-p:toggle-preview,ctrl-z:toggle-preview-wrap \
    --bind ctrl-u:preview-up,ctrl-d:preview-down \
    --bind ctrl-alt-u:preview-page-up,ctrl-alt-d:preview-page-down \
    --bind "ctrl-y:execute-silent(readlink -f {} | $CLIPBOARD)"

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


# --------------------------------------------------
#		Helpers & Widgets
# -----------------------------
function __fzf_preview_file -d 'Print a preview for the given file based on its file type.'
    set -f file_path $argv

    if [ -L "$file_path" ] #> symlink
        set -l target_path (realpath "$file_path")
        echo -e "'$file_path' is a symlink to '$target_path'.\n"
        __fzf_preview_file "$target_path"

    else if [ -f "$file_path" ] #> regular file
        bat "$file_path" --color always --style plain,numbers

    else if [ -d "$file_path" ] #> directory
        eza "$file_path" --color always -laU --icons \
            --no-filesize --no-user --group-directories-first

    else #> unrecognizable
        echo -e "Cannot preview '$file_path'.\n"

    end
end

function __fzf_open_file
    [ -z "$result" ]; and return #> empty
    [ -f "$result" ]; and set -p result $EDITOR #> file

    # add result to history via executing input
    commandline -t "$result " # white space to `disable` completion inline hinting
    commandline -f repaint execute
end

function fzf_search_file
    # no escape chars, expanded token
    set -f token (string unescape -- (echo -- (commandline --current-token)))

    # If the current token is a directory and has a trailing slash,
    # then use it as fd's base directory.
    if string match -q -- "*/" $token && test -d "$token"
        set -a fzf_fd_cmd --base-directory $token
        set -a fzf_cmd \
            --prompt " $token> " \
            --preview "__fzf_preview_file $token{}"

        set -f result $token($fzf_fd_cmd 2>/dev/null | $fzf_cmd)
    else
        set -a fzf_cmd \
            --prompt " > " \
            --query "$token" \
            --preview "__fzf_preview_file {}"

        set -f result ($fzf_fd_cmd 2>/dev/null | $fzf_cmd)
    end

    __fzf_open_file $result
end

function fzf_search_base_dir
    set -f base_dir $argv[1]

    set -f base_dir (string unescape -- (echo -- $base_dir))

    set -a fzf_fd_cmd --base-directory "$base_dir"
    set -a fzf_cmd \
        --prompt " $(basename $base_dir)> " \
        --preview "__fzf_preview_file $base_dir{}" \
        --bind 'ctrl-o:clear-query+put()+print-query'

    set -f result $base_dir($fzf_fd_cmd | $fzf_cmd)

    __fzf_open_file $result
end


function fzf_run -d "Search (and/or run it) entries in specified directory"
    argparse -n fzf_open_file d/disable-run -- $argv

    set -f base_dir (string unescape -- (echo -- $argv[1]))

    set -a fzf_fd_cmd --base-directory "$base_dir"
    set -a fzf_cmd \
        --prompt " $(basename $base_dir)> " \
        --preview "__fzf_preview_file $base_dir{}" \
        --bind 'ctrl-o:clear-query+put()+print-query'

    set -f result $base_dir($fzf_fd_cmd | $fzf_cmd)

    # put result in the current token; otherwise run it
    if [ -z "$_flag_disable_run"]
        echo; and eval "$result"
    else
        set -f token $result
    end

    commandline -t "$token"
    commandline -f repaint
end
