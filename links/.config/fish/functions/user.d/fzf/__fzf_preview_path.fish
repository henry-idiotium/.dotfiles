function __fzf_preview_path -d '[fzf helper] Print a preview for the given path based on its type.'
    set -f file_path $argv

    if [ -L "$file_path" ] #> symlink
        set -l target_path (realpath "$file_path")
        echo -e "'$file_path' is a symlink to '$target_path'.\n"
        __fzf_preview_path "$target_path"

    else if [ -f "$file_path" ] #> regular file
        bat "$file_path" --color always --style plain,numbers

    else if [ -d "$file_path" ] #> directory
        eza "$file_path" -laU --icons --color always \
            --no-filesize --no-user --group-directories-first

    else #> unrecognizable
        echo -e "Cannot preview '$file_path'.\n"

    end
end
