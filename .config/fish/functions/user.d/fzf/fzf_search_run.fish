function fzf_search_run -d "Search (and/or run it) entries in specified directory"
    argparse -n fzf_open_file d/disable-run -- $argv

    set -f base_dir (string unescape -- (echo -- $argv[1]))

    set -fa fzf_fd_cmd --base-directory "$base_dir"
    set -fa fzf_cmd \
        --prompt " $(basename $base_dir)> " \
        --preview "__fzf_preview_file $base_dir{}" \
        --bind 'ctrl-o:clear-query+put()+print-query'

    set -f result $base_dir($fzf_fd_cmd | $fzf_cmd)
    [ -z "$result" ]; and return

    # put result in the current token; otherwise run it
    echo; and eval "$result"

    commandline -t ''
    commandline -f repaint
end
