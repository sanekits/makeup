# makeup.bashrc - shell init file for makeup sourced from ~/.bashrc

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


