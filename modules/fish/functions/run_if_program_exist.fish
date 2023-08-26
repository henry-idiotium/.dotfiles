# A helper function that provide program checking ability.
# If it exist then run the remain args
function run_if_program_exist
    set program $argv[1]
    set command $argv[2..-1]

    set RED '\033[0;31m'
    set error_message (printf $RED"> $program is not installed!!")

    type -q $program && $command || echo $error_message
end

