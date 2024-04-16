function __bind -d 'Alternative bind function. (e.g., __bind -m default,insert \cc do_smth)'
    argparse -n __bind 'm/modes=' -- $argv
    or return

    set -f key $argv[1]
    set -f action $argv[2..]
    set -f modes $_flag_modes

    if [ -n "$_flag_modes" ]
        set modes (string replace ' ' '' -- (string split ',' $modes))
    else
        set modes default
    end

    for mode in $modes
        bind -M $mode $key $action
    end
end
