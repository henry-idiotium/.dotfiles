function __fzf_open_path -d '[fzf helper] Open path'
    set -f path $argv[1]
    set -f token

    [ -f "$path" ]; and set token $EDITOR

    set path (string replace $HOME '~' (string escape -n  $path)) # shorten $HOME
    set -a token $path

    # add to history via executing input token
    commandline -t "$token "
    commandline -f repaint execute
end
