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
