if ! type -q fzf
    exit 0
end


# keymaps
bind -M insert \ce fzf-open-vim-widget
bind -M insert \cf fzf-file-widget
bind -M insert \ch fzf-history-widget
bind -M insert \cd fzf-cd-widget
bind -M insert \cg fzf-git-status-widget


# settings
set -gx FZF_DEFAULT_COMMAND "rg --files --follow"
set -gx FZF_DEFAULT_OPTS "
	--height 80%
	--reverse
	--border

	--color header:italic
	--color gutter:-1
	--color bg+:#313244,spinner:#f5e0dc,hl:#f38ba8
	--color fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
	--color marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8

	--bind ctrl-p:toggle-preview
    --bind ctrl-l:accept,ctrl-o:accept
	--bind alt-j:preview-down,alt-k:preview-up
	--bind ctrl-alt-j:preview-page-down,ctrl-alt-k:preview-page-up
"

set -l FZF_FILE_DISPLAY_OPTS "
    --preview 'bat --style=numbers --color=always --line-range :500 {}'
    --preview-window right:50%:hidden
"

set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND \
    --glob '!.git' \
    --glob '!**/node_modules' \
    --glob '!.next' \
"
set -gx FZF_CTRL_T_OPTS "
	$FZF_FILE_DISPLAY_OPTS
	--bind 'ctrl-y:execute-silent(echo -n {} | $WINDOW_CLIPBOARD)+abort'
	--header 'Press CTRL-Y to copy relative path into clipboard'
"

# set -gx FZF_CTRL_R_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_CTRL_R_OPTS "
	$FZF_FILE_DISPLAY_OPTS
	--bind 'ctrl-y:execute-silent(echo -n {2..} | $WINDOW_CLIPBOARD)+abort'
	--header 'Press CTRL-Y to copy command into clipboard'
"

set -gx FZF_ALT_C_COMMAND "fd \
    --type directory \
    --exclude '.git' \
    --exclude '.next' \
    --exclude 'dist' \
    --exclude 'node_modules' \
"
set -gx FZF_ALT_C_OPTS "
	$FZF_FILE_DISPLAY_OPTS
    --preview 'tree -C {}'
"


# widgets
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
        set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT --prompt '≡ƒôé ' --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS"
        eval "$FZF_ALT_C_COMMAND | "(__fzf_cmd)' +m --query "'$fzf_query'"' | read -l result

        if [ -n "$result" ]
            cd -- $result

            # Remove last token from commandline.
            commandline -t ""
            commandline -it -- $prefix
        end
    end

    commandline -f repaint
end

function fzf-file-widget -d "List files and folders" # Store current token in $dir as root for the 'find' command
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
        eval "$FZF_CTRL_T_COMMAND | "(__fzf_cmd)' -m --query "'$fzf_query'"' | while read -l r
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

    git log --color=always --format='%C(auto)%h%d %s %C(green)%C(bold)%cr% C(blue)%an' | eval (__fzf_cmd)
end

function fzf-git-status-widget --description "Git browse status"
    set -f preview_cmd '__fzf_preview_changed_file {} | delta --syntax-theme Catppuccin-mocha --paging=never --width=20'

    set -lx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS
		--prompt 'Git Status > '
		--marker * --no-sort --tiebreak index --no-multi --ansi
		--preview \"$preview_cmd\"
	"
    git -c color.status=always status --short | eval (__fzf_cmd)
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
            history -z | eval (__fzf_cmd) --read0 --print0 -q '(commandline)' | read -lz result
            and commandline -- $result
        else
            history | eval (__fzf_cmd) -q '(commandline)' | read -l result
            and commandline -- $result
        end
    end
    commandline -f repaint
end

function fzf-open-vim-widget -d "Open with vim"
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
        set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT --prompt 'εÿ½ ' --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS"
        eval "$FZF_CTRL_T_COMMAND | "(__fzf_cmd)' -m --query "'$fzf_query'"' | while read -l r
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

    commandline -f repaint

    nvim $result
end
