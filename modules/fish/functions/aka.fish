# A helper function that act as a wrapper for alias built-in function
function aka
    set alias_name $argv[1]
    set program $argv[2]
    set options $argv[3..-1]

    set command (test -n "$options" && printf "$program $options" || printf "$program")

    run_if_program_exist $program alias $alias_name "$command"
end

