# shell:completion fish shell completion

function __fish_shell:completion_no_subcommand --description 'Test if there has been any subcommand yet'
    for i in (commandline -opc)
        if contains -- $i help h
            return 1
        end
    end
    return 0
end

complete -c shell:completion -n '__fish_shell:completion_no_subcommand' -f -l help -s h -d 'show help'
complete -c shell:completion -n '__fish_shell:completion_no_subcommand' -f -l help -s h -d 'show help'
complete -r -c shell:completion -n '__fish_shell:completion_no_subcommand' -a 'help h' -d 'Shows a list of commands or help for one command'
