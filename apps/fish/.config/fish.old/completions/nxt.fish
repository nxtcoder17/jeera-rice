# nxt completions fish shell completion
set GO_TASK_PROGNAME nxt

function __fish_nxt --description 'Test if there has been any subcommand yet'
    for i in (commandline -opc)
        if contains -- $i fish help h
            return 1
        end
    end
    return 0
end

# function __task_get_tasks --description "Prints all available tasks with their description"
# 	set -l output ($GO_TASK_PROGNAME --list-all | sed '1d; s/\* \(.*\):\s*\(.*\)/\1\t\2/' | string split0)
#   if test $output
#       echo $output
#   end
# end


complete -c nxt -d 'Runs the specified task(s). Falls back to the "default" task if no task name was specified, or lists all tasks if an unknown task name was specified.' -xa "__fish_nxt"

complete -c nxt -n  '__fish_nxt completions_no_subcommand' -a 'completions'  -f -l help -s h -d 'show help'
# complete -c nxt -n '__fish_nxt completions_no_subcommand' -f -l help -s h -d 'show help'
# complete -c nxt -n '__fish_seen_subcommand_from fish' -f -l help -s h -d 'show help'
# complete -r -c nxt -n '__fish_nxt completions_no_subcommand' -a 'fish'
# complete -c nxt -n '__fish_seen_subcommand_from fish' -f -l help -s h -d 'show help'
# complete -c nxt -n '__fish_seen_subcommand_from help h' -f -l help -s h -d 'show help'
# complete -r -c nxt -n '__fish_nxt completions_no_subcommand' -a 'help h' -d 'Shows a list of commands or help for one command'
#
