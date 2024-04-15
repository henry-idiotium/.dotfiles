function fzf_search_path
    # no escape chars, expanded token
    set -f token (string unescape -- (echo -- (commandline --current-token)))

    # If the current token is a directory and has a trailing slash,
    # then use it as fd's base directory.
    if string match -q -- "*/" $token && test -d "$token"
        set -fa fzf_fd_cmd --base-directory $token
        set -fa fzf_cmd \
            --prompt " $token> " \
            --preview "__fzf_preview_path $token{}"

        set -f result $token($fzf_fd_cmd 2>/dev/null | $fzf_cmd)
    else
        set -a fzf_cmd \
            --prompt " > " \
            --query "$token" \
            --preview "__fzf_preview_path {}"
        set -f result ($fzf_fd_cmd 2>/dev/null | $fzf_cmd)

    end

    __fzf_open_path $result
end
