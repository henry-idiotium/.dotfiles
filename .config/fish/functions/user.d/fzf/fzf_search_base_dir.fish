function fzf_search_base_dir -d 'Fuzzy searching paths in specified directory.'
    set -f base_dir $argv[1]

    set -f base_dir (string unescape -- (echo -- $base_dir))

    set -fa fzf_fd_cmd --base-directory "$base_dir"
    set -fa fzf_cmd \
        --prompt " $(basename $base_dir)> " \
        --preview "__fzf_preview_file $base_dir{}" \
        --bind 'ctrl-o:clear-query+put()+print-query'

    set -f result $base_dir($fzf_fd_cmd | $fzf_cmd)

    # parse absolute path to relative path
    set result (realpath --relative-base "$PWD" "$result")
    [ -d "$result" ]; and set result "$result/"

    __fzf_open_path $result
end
