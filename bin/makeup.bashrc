# shellcheck shell=bash
# makeup.bashrc - shell init file for makeup sourced from ~/.bashrc
# To run shellcheck without relying on the shebang, use: shellcheck -s bash /path/to/this/script

makeup-semaphore() {
    [[ 1 -eq  1 ]]
}

type -p _completion_loader && {
    # If you see "bash: _make: command not found" when trying to
    # autocomplete aliases mapped to make/gmake, it means that
    # the completion for make itself isn't yet loaded.  We can force that:
    _completion_loader make
    _completion_loader gmake
}

alias mkd=make-debug.sh
alias makesh=makesh.sh
complete -F _make make-debug.sh
complete -F _make makesh.sh
complete -F _complete_alias makesh
complete -F _complete_alias mkd


