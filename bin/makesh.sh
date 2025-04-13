#!/bin/bash
# makesh

scriptName="$(readlink -f "$0")"
# (if needed) scriptDir=$(command dirname -- "${scriptName}")

#shellcheck disable=2154
setPs4() {
    PS4='$( _0=$?; exec 2>/dev/null; realpath -- "${BASH_SOURCE[0]:-?}:${LINENO} ^$_0 ${FUNCNAME[0]:-?}()=>" ) '
}

die() {
    builtin echo "ERROR($(basename "${scriptName}")): $*" >&2
    builtin exit 1
}

do_help() {
    cat <<EOF
Usage: $(basename "$scriptName") [OPTIONS] [--] [MAKE_TARGETS]

This script invokes 'make' with the specified targets and options, while enabling:
  - '-q': Quiet mode (don't print unnecessary messages)
  - '-n': Dry-run mode (show what would be done without executing)

The output is formatted using 'shfmt' for readability and prefixed with a shebang,
making it reusable as a shell script.

Options:
  -h, --help    Show this help message and exit
  --            Pass remaining arguments directly to 'make'

Examples:
  $(basename "$scriptName") -h
  $(basename "$scriptName") -- INCLUDE=/foo/inc build install
EOF
}

main() {
    setPs4
    [[ "$*" == *BASH_MAKE_COMPLETION* ]] && {
        # our wrapper will interfere with completions unless we defer
        # entirely to make on that use case:
        command make "$@"
        exit
    }
    set -e
    while [[ -n $1 ]]; do
        case "$1" in
            -h|--help) shift; do_help "$@" ; return;;
            --) shift; break;;  # Remaining args get forwarded to make
            *) break ;; # Anything we don't understand is also a sign that we're done with our own args
        esac
        shift
    done
    set -u

    echo '#!/bin/bash'
    command make  --silent --dry-run --no-print-directory "$@" | command shfmt -i 4 
}

if [[ -z "${sourceMe}" ]]; then
    main "$@"
    builtin exit
fi
command true
