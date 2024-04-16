function __fzf_open_path -d '[fzf helper] Open path'
    [ -z "$argv" ]; and return

    set -f token $argv[1]
    [ -f "$token" ]; and set -p token $EDITOR

    # shorten $HOME
    set token (string replace $HOME '~' (string escape -n  $token))

    # add to history via executing input token
    commandline -t "$token "
    commandline -f repaint execute
end
