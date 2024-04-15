function __fzf_open_path -d '[fzf helper] Open path'
    set -f path $argv

    [ -z "$path" ]; and return #> empty
    [ -f "$path" ]; and set -p path $EDITOR #> file

    # add path to history via executing input
    commandline -t "$path " # white space to `disable` completion inline hinting
    commandline -f repaint execute
end
