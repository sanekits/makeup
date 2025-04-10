#!/bin/bash
# make-debug.sh
# Launch make with debug options and capture output to /tmp/make.log

scriptName="$(readlink -f "$0")"
scriptDir=$(command dirname -- "${scriptName}")

die() {
    builtin echo "ERROR($(basename ${scriptName})): $*" >&2
    builtin exit 1
}

do_help() {
    cat <<-EOF | cut -c 6-

    |Additional options for make-debug.sh:
    |  --light: Use -xc instead of -uxec for .SHELLFLAGS
    |  --ps4: Print PS4x pasteable for GNU make
    
EOF
}

do_ps4x() {
    cat <<-"EOF"
#	PS4=$(PS4x)  # <-- Copy/uncomment this in recipe to enable smart PS4 
PS4x='$$( _0=$$?;_1="$(notdir $@)";_2="$(realpath $(lastword $(MAKEFILE_LIST)))"; exec 2>/dev/null; echo "$${_2}|$${_1}@+$${LINENO} ^$$_0 $${FUNCNAME[0]:-?}()=>" ) '
EOF
}

ENABLE_HELP_APPEND=false
Logfile=/tmp/make.log
FwdArgs=()
Shellflags="-uxec"
while [[ $# -gt 0 ]]; do
    case $1 in
        --help|-h)
            ENABLE_HELP_APPEND=true
            FwdArgs+=("$1")
            ;;
        --light)
            Shellflags="-xc"
            ;;
        --ps4*)
            do_ps4x; exit;;
        *)
            FwdArgs+=("$1")
            ;;
    esac
    shift
done
{
    printf "%s " "[make-debug.sh $(date -Iseconds)] Invoking: make -rd \".SHELLFLAGS= ${Shellflags}\""
    printf "%s " "${FwdArgs[@]}"
    printf "\n"
    make -rd ".SHELLFLAGS= ${Shellflags}" "${FwdArgs[@]}"
    $ENABLE_HELP_APPEND && do_help
    echo "[make-debug.sh $(date -Iseconds)] Output of make was captured in $Logfile"
} |& tee /tmp/make.log
