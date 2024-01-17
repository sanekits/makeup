#!/bin/bash
# make-debug.sh
# Launch make with debug options and capture output to /tmp/make.log

scriptName="$(readlink -f "$0")"
scriptDir=$(command dirname -- "${scriptName}")

die() {
    builtin echo "ERROR($(basename ${scriptName})): $*" >&2
    builtin exit 1
}

Logfile=/tmp/make.log
make -rd ".SHELLFLAGS= -uxec" "$@" | tee ${Logfile}
echo "Output make captured in $Logfile" >&2
