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
    [[ "$*" == *BASH_MAKE_COMPLETION* ]] && {
        # our wrapper will interfere with completions unless we defer
        # entirely to make on that use case:
        command make "$@"
        exit
    }
    set -ue
    [[ $# -eq 0 ]] && { do_help; exit ; }
    while [[ -n $1 ]]; do
        case "$1" in
            -h|--help) shift; do_help "$@" ; return;;
            --) shift; break;;  # Remaining args get forwarded to make
        esac
        shift
    done

    echo '#!/bin/bash'
    $(which make) -qn "$@" | shfmt -i 4 
}

if [[ -z "${sourceMe}" ]]; then
    main "$@"
    builtin exit
fi
command true
