bind -M insert \ce __fzf_search_registry

set -gx FZF_DEFAULT_OPTS \
    --cycle \
    --reverse \
    --color header:italic \
    --color gutter:-1 \
    --color bg+:#313244,spinner:#f5e0dc,hl:#f38ba8 \
    --color fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
    --bind ctrl-l:accept \
    --bind ctrl-i:ignore,ctrl-z:toggle-preview \
    --bind ctrl-n:preview-down,ctrl-p:preview-up \
    --bind ctrl-d:preview-page-down,ctrl-u:preview-page-up \
    --bind "ctrl-y:execute-silent(readlink -f {} | $CLIPBOARD)"

set -U fzf_preview_file_cmd bat \
    --style numbers \
    --color always

set -U fzf_preview_dir_cmd eza -laU \
    --icons \
    --no-user \
    --color always \
    --no-filesize \
    --group-directories-first

set -U fzf_fd_opts \
    --exclude .git \
    --exclude .next \
    --exclude dist \
    --exclude node_modules


# --------------------------------------------------
#		Helpers & Widgets
# -----------------------------

function __fzf_report_file_type --argument-names file_path file_type --description "Explain the file type for a file."
    set_color red
    echo "Cannot preview '$file_path': it is a $file_type."
    set_color normal
end

function __fzf_preview_file --description "Print a preview for the given file based on its file type."
    set -f file_path $argv

    if test -L "$file_path" # symlink
        set -l target_path (realpath "$file_path") # notify user and recurse on the target of the symlink, which can be any of these file types

        set_color yellow
        echo "'$file_path' is a symlink to '$target_path'."
        set_color normal

        __fzf_preview_file "$target_path"
    else if test -f "$file_path" # regular file
        if set -q fzf_preview_file_cmd
            # need to escape quotes to make sure eval receives file_path as a single arg
            eval "$fzf_preview_file_cmd '$file_path'"
        else
            cat --number "$file_path"
        end

    else if test -d "$file_path" # directory
        if set -q fzf_preview_dir_cmd
            eval "$fzf_preview_dir_cmd '$file_path'"
        else
            command ls -A -F "$file_path"
        end

    else if test -c "$file_path"
        __fzf_report_file_type "$file_path" "character device file"
    else if test -b "$file_path"
        __fzf_report_file_type "$file_path" "block device file"
    else if test -S "$file_path"
        __fzf_report_file_type "$file_path" socket
    else if test -p "$file_path"
        __fzf_report_file_type "$file_path" "named pipe"
    else
        echo "$file_path doesn't exist." >&2
    end
end

function __fzf_search_registry -d "Search/Open files/directories"
    set -f token (commandline --current-token)
    # expand vars or leading tidle
    set -f expanded_token (eval echo -- $token)
    # remove backslashes (will mess up fd otherwise)
    # (e.g, 'path/foo \is \dumb/' -> 'path/foo is dumb')
    set -f unescaped_exp_token (string unescape -- $expanded_token)

    set -f fd_cmd fd --hidden --no-ignore --color=always $fzf_fd_opts
    set -f fzf_cmd fzf --ansi $FZF_DEFAULT_OPTS

    if [ -n "$TMUX" ]
        set -f tab_cmd tmux new-window -d
        set -f pane_cmd tmux split-window
        set -a fzf_cmd \
            --bind "ctrl-alt-n:execute-silent([ -f {} ] && $tab_cmd \"$EDITOR {}\" || $tab_cmd -c {})" \
            --bind "ctrl-alt-v:execute-silent([ -f {} ] && $pane_cmd -h \"$EDITOR {}\" || $pane_cmd -h -c {})" \
            --header "CTRL-ALT-N: Open new window  CTRL-ALT-V: Open new split"
    end

    # If the current token is a directory and has a trailing slash, then use it as fd's base directory.
    if string match -q -- "*/" $unescaped_exp_token && test -d "$unescaped_exp_token"
        set -a fd_cmd --base-directory=$unescaped_exp_token
        # use the directory name as fzf's prompt to indicate the search is limited to that directory
        set -a fzf_cmd --prompt=" $unescaped_exp_token> " --preview="__fzf_preview_file $expanded_token{}"
        set -f result $unescaped_exp_token($fd_cmd 2>/dev/null | $fzf_cmd)
    else
        set -a fzf_cmd --prompt=" > " --query="$unescaped_exp_token" --preview="__fzf_preview_file {}"
        set -f result ($fd_cmd 2>/dev/null | $fzf_cmd)
    end

    if [ -n "$result" ]
        if [ -d "$result" ]
            cd -- $result
        else if [ -f "$result" ]
            $EDITOR -- $result
        end
    end

    commandline -t "" # clear token

    commandline --function repaint
end
