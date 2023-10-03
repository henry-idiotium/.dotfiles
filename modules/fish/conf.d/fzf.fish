# Modified version from /usr/share/fish/vendor_functions.d/fzf_key_bindings.fish

## Keybinding
bind \ce fzf-file-widget
bind \ch fzf-history-widget
bind \cd fzf-cd-widget

if bind -M insert >/dev/null 2>&1
    bind -M insert \ce fzf-file-widget
    bind -M insert \ch fzf-history-widget
    bind -M insert \cd fzf-cd-widget
end


## Actions

# Store current token in $dir as root for the 'find' command
function fzf-file-widget -d "List files and folders"
    set -l commandline (__fzf_parse_commandline)
    set -l dir $commandline[1]
    set -l fzf_query $commandline[2]
    set -l prefix $commandline[3]

    # "-path \$dir'*/\\.*'" matches hidden files/folders inside $dir but not
    # $dir itself, even if hidden.
    test -n "$FZF_CTRL_T_COMMAND"; or set -l FZF_CTRL_T_COMMAND "
		command find -L \$dir -mindepth 1 \\( -path \$dir'*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' \\) -prune \
		-o -type f -print \
		-o -type d -print \
		-o -type l -print 2> /dev/null | sed 's@^\./@@'"

    test -n "$FZF_TMUX_HEIGHT"; or set FZF_TMUX_HEIGHT 40%
    begin
        set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT --prompt 'Files > ' --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS"
        eval "$FZF_CTRL_T_COMMAND | "(__fzfcmd)' -m --query "'$fzf_query'"' | while read -l r
            set result $result $r
        end
    end
    if [ -z "$result" ]
        commandline -f repaint
        return
    else
        # Remove last token from commandline.
        commandline -t ""
    end
    for i in $result
        commandline -it -- $prefix
        commandline -it -- (string escape $i)
        commandline -it -- ' '
    end
    commandline -f repaint
end

function fzf-history-widget -d "Show command history"
    test -n "$FZF_TMUX_HEIGHT"; or set FZF_TMUX_HEIGHT 40%
    begin
        set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT $FZF_DEFAULT_OPTS --prompt 'Command Histories > ' --scheme=history --bind=ctrl-r:toggle-sort,ctrl-z:ignore $FZF_CTRL_R_OPTS +m"

        set -l FISH_MAJOR (echo $version | cut -f1 -d.)
        set -l FISH_MINOR (echo $version | cut -f2 -d.)

        # history's -z flag is needed for multi-line support.
        # history's -z flag was added in fish 2.4.0, so don't use it for versions
        # before 2.4.0.
        if [ "$FISH_MAJOR" -gt 2 -o \( "$FISH_MAJOR" -eq 2 -a "$FISH_MINOR" -ge 4 \) ]
            history -z | eval (__fzfcmd) --read0 --print0 -q '(commandline)' | read -lz result
            and commandline -- $result
        else
            history | eval (__fzfcmd) -q '(commandline)' | read -l result
            and commandline -- $result
        end
    end
    commandline -f repaint
end

function fzf-cd-widget -d "Change directory"
    set -l commandline (__fzf_parse_commandline)
    set -l dir $commandline[1]
    set -l fzf_query $commandline[2]
    set -l prefix $commandline[3]

    test -n "$FZF_ALT_C_COMMAND"; or set -l FZF_ALT_C_COMMAND "
		command find -L \$dir -mindepth 1 \\( -path \$dir'*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' \\) -prune \
		-o -type d -print 2> /dev/null | sed 's@^\./@@'"
    test -n "$FZF_TMUX_HEIGHT"; or set FZF_TMUX_HEIGHT 40%
    begin
        set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT --prompt 'Directories > ' --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS"
        eval "$FZF_ALT_C_COMMAND | "(__fzfcmd)' +m --query "'$fzf_query'"' | read -l result

        if [ -n "$result" ]
            cd -- $result

            # Remove last token from commandline.
            commandline -t ""
            commandline -it -- $prefix
        end
    end

    commandline -f repaint
end

function fzf-git-browse-commits-widget --description "Git browse commits"
    set -l log_line_to_hash "echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
    set -l view_commit "$log_line_to_hash | xargs -I % sh -c 'git show --color=always % | diff-so-fancy | less -R'"
    set -l copy_commit_hash "$log_line_to_hash | xclip"
    set -l git_checkout "$log_line_to_hash | xargs -I % sh -c 'git checkout %'"
    # set -l open_cmd open

    if test (uname) = Linux
        set open_cmd xdg-open
    end

    # set github_open "$log_line_to_hash | xargs -I % sh -c '$open_cmd https://github.\$(git config remote.origin.url | cut -f2 -d. | tr \':\' /)/commit/%'"

    set -lx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS
		--prompt 'Git Commits > '
		--marker * --no-sort --tiebreak index --no-multi --ansi
		--preview \"$view_commit\"
		--header 'ENTER to view, CTRL-Y to copy hash, CTRL-O to open on GitHub, CTRL-X to checkout, CTRL-C to exit'
		--bind \"enter:execute:$view_commit\"
		--bind \"ctrl-y:execute:$copy_commit_hash\"
		--bind \"ctrl-x:execute:$git_checkout\"
	"
    # --bind \"ctrl-o:execute:$github_open\"

    git log --color=always --format='%C(auto)%h%d %s %C(green)%C(bold)%cr% C(blue)%an' | eval (__fzfcmd)
end

function fzf-git-status-widget --description "Git browse status"
    set -f preview_cmd '_fzf_preview_changed_file {} | delta --syntax-theme Catppuccin-mocha --paging=never --width=20'

    set -lx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS
		--prompt 'Git Status > '
		--marker * --no-sort --tiebreak index --no-multi --ansi
		--preview \"$preview_cmd\"
	"
    git -c color.status=always status --short | eval (__fzfcmd)
end



## Helpers
function __fzfcmd
    test -n "$FZF_TMUX"; or set FZF_TMUX 0
    test -n "$FZF_TMUX_HEIGHT"; or set FZF_TMUX_HEIGHT 40%
    if [ -n "$FZF_TMUX_OPTS" ]
        echo "fzf-tmux $FZF_TMUX_OPTS -- "
    else if [ $FZF_TMUX -eq 1 ]
        echo "fzf-tmux -d$FZF_TMUX_HEIGHT -- "
    else
        echo fzf
    end
end

function __fzf_parse_commandline -d 'Parse the current command line token and return split of existing filepath, fzf query, and optional -option= prefix'
    set -l commandline (commandline -t)

    # strip -option= from token if present
    set -l prefix (string match -r -- '^-[^\s=]+=' $commandline)
    set commandline (string replace -- "$prefix" '' $commandline)

    # eval is used to do shell expansion on paths
    eval set commandline $commandline

    if [ -z $commandline ]
        # Default to current directory with no --query
        set dir '.'
        set fzf_query ''
    else
        set dir (__fzf_get_dir $commandline)

        if [ "$dir" = "." -a (string sub -l 1 -- $commandline) != '.' ]
            # if $dir is "." but commandline is not a relative path, this means no file path found
            set fzf_query $commandline
        else
            # Also remove trailing slash after dir, to "split" input properly
            set fzf_query (string replace -r "^$dir/?" -- '' "$commandline")
        end
    end

    echo $dir
    echo $fzf_query
    echo $prefix
end

function __fzf_get_dir -d 'Find the longest existing filepath from input string'
    set dir $argv

    # Strip all trailing slashes. Ignore if $dir is root dir (/)
    if [ (string length -- $dir) -gt 1 ]
        set dir (string replace -r '/*$' -- '' $dir)
    end

    # Iteratively check if dir exists and strip tail end of path
    while [ ! -d "$dir" ]
        # If path is absolute, this can keep going until ends up at /
        # If path is relative, this can keep going until entire input is consumed, dirname returns "."
        set dir (dirname -- "$dir")
    end

    echo $dir
end

function _fzf_preview_changed_file --argument-names path_status --description "Show the git diff of the given file."
    # remove quotes because they'll be interpreted literally by git diff
    # no need to requote when referencing $path because fish does not perform word splitting
    # https://fishshell.com/docs/current/fish_for_bash_users.html
    set -f path (string unescape (string sub --start 4 $path_status))
    # first letter of short format shows index, second letter shows working tree
    # https://git-scm.com/docs/git-status/2.35.0#_short_format
    set -f index_status (string sub --length 1 $path_status)
    set -f working_tree_status (string sub --start 2 --length 1 $path_status)

    set -f diff_opts --color=always

    if test $index_status = '?'
        _fzf_report_diff_type Untracked
        _fzf_preview_file $path
    else if contains {$index_status}$working_tree_status DD AU UD UA DU AA UU
        # Unmerged statuses taken directly from git status help's short format table
        # Unmerged statuses are mutually exclusive with other statuses, so if we see
        # these, then safe to assume the path is unmerged
        _fzf_report_diff_type Unmerged
        git diff $diff_opts -- $path
    else
        if test $index_status != ' '
            _fzf_report_diff_type Staged

            # renames are only detected in the index, never working tree, so only need to test for it here
            # https://stackoverflow.com/questions/73954214
            if test $index_status = R
                # diff the post-rename path with the original path, otherwise the diff will show the entire file as being added
                set -f orig_and_new_path (string split --max 1 -- ' -> ' $path)
                git diff --staged $diff_opts -- $orig_and_new_path[1] $orig_and_new_path[2]
                # path currently has the form of "original -> current", so we need to correct it before it's used below
                set path $orig_and_new_path[2]
            else
                git diff --staged $diff_opts -- $path
            end
        end

        if test $working_tree_status != ' '
            _fzf_report_diff_type Unstaged
            git diff $diff_opts -- $path
        end
    end
end
