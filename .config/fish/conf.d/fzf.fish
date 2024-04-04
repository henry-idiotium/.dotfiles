bind -M insert \ce fzf_search_directory
bind -M insert \cd 'fzf_search_base_directory ~/.config/dotfiles/'
bind -M insert \cn 'fzf_search_base_directory ~/documents/notes/'
bind -M insert \cp 'fzf_search_base_directory ~/documents/projects/'
bind -M insert \ct 'fzf_search_base_directory ~/documents/throwaways/'


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
function __fzf_open_dir
    set -f cmd $argv[1]
    [ -z "$cmd" ]; and return #> empty
    [ -f "$cmd" ]; and set -p cmd $EDITOR #> file

    commandline -t "$cmd"
    commandline -f repaint
    commandline -f execute
end

function __fzf_preview_file -d 'Print a preview for the given file based on its file type.'
    set -f file_path $argv

    # notify user and recurse on the target of the symlink,
    # which can be any of these file types
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

function fzf_search_directory -d 'Search files and directories'
    set -f token (commandline --current-token)
    set -f unescaped_exp_token (string unescape -- (echo -- "$token"))

    # If the current token is a directory and has a trailing slash,
    # then use it as fd's base directory.
    if string match -q -- "*/" $unescaped_exp_token && test -d "$unescaped_exp_token"
        set -a fzf_fd_cmd --base-directory $unescaped_exp_token
        set -a fzf_cmd \
            --prompt " $unescaped_exp_token> " \
            --preview "__fzf_preview_file $unescaped_exp_token{}"
        set -f result $unescaped_exp_token($fzf_fd_cmd | $fzf_cmd)
    else
        set -a fzf_cmd \
            --prompt " > " \
            --query "$unescaped_exp_token" \
            --preview "__fzf_preview_file {}"
        set -f result ($fzf_fd_cmd 2>/dev/null | $fzf_cmd)
    end

    __fzf_open_dir $result
end

function fzf_search_base_directory -d "Search files and directories with specify base directory."
    set -f dir (realpath $argv[1])/ # realpath of base directory

    set -f relative_dir (realpath -s --relative-to . $dir)/
    not string match -q '../*' "$relative_dir"; and set dir $relative_dir

    set -a fzf_fd_cmd --base-directory "$dir"
    set -a fzf_cmd --prompt " $(basename $dir)> " \
        --preview "__fzf_preview_file $dir{}" \
        --bind 'ctrl-o:clear-query+put()+print-query'

    set -f result $dir($fzf_fd_cmd | $fzf_cmd)

    __fzf_open_dir $result
end
