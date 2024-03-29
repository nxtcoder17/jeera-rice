# compdef task
#source: https://raw.githubusercontent.com/sawadashota/go-task-completions/master/_task

# Listing commands from Taskfile.yml
function __list() {
    [ -f Taskfile.yml ] || return 0
    local -a scripts

    if [ -f Taskfile.yml ]; then
        tasks=$(task -l | sed -En "s/^\* ([^[:space:]]+):[[:space:]]+(.+)$/\1 \2/p" | awk '{gsub(/:/,"\\:",$1)} 1' | awk "{ st = index(\$0,\" \"); print \$1 \":\" substr(\$0,st+1)}")
        scripts=("${(@f)$(echo $tasks)}")
        _describe 'script' scripts
    fi
}

_arguments \
    '(-d --dir)'{-d,--dir}'[sets directory of execution]: :_files' \
    '(--dry)'--dry'[compiles and prints tasks in the order that they would be run, without executing them]' \
    '(-f --force)'{-f,--force}'[forces execution even when the task is up-to-date]' \
    '(-i --init)'{-i,--init}'[creates a new Taskfile.yml in the current folder]' \
    '(-l --list)'{-l,--list}'[lists tasks with description of current Taskfile]' \
    '(-p --parallel)'{-p,--parallel}'[executes tasks provided on command line in parallel]' \
    '(-s --silent)'{-s,--silent}'[disables echoing]' \
    '(--status)'--status'[exits with non-zero exit code if any of the given tasks is not up-to-date]' \
    '(--summary)'--summary'[show summary about a task]' \
    '(-t --taskfile)'{-t,--taskfile}'[choose which Taskfile to run. Defaults to "Taskfile.yml"]' \
    '(-v --verbose)'{-v,--verbose}'[enables verbose mode]' \
    '(--version)'--version'[show Task version]' \
    '(-w --watch)'{-w,--watch}'[enables watch of the given task]' \
    '(- *)'{-h,--help}'[show help]' \
    '*: :__list'

