#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Initialize math functions
zmodload zsh/mathfunc

# Load time functions
zmodload zsh/datetime

PID=$1

if [[ -z $PID ]]; then
    echo "Please provide a PID that you want to debug."
    exit 1
fi

CACHE_DIR="${XDG_CACHE_HOME:-${HOME}/.cache}/powerlevel9k"
mkdir -p -m 0700 "${CACHE_DIR}"

# Read in cached segments
for file in $(ls -1 ${CACHE_DIR}/p9k_${PID}_*); do
    source $file

    # echo $segment
    local prefix="Rendered"
    if [[ "${CONDITION}" == "false" ]]; then
        prefix="%F{red}Not%f rendered"
    fi
    #local humanReadableDuration=$(TZ=GMT; strftime '%M:%S' $(( int(rint(DURATION)) )))
    typeset -F 2 humanReadableDuration
    humanReadableDuration=$DURATION
    print -P "${prefix} segment %F{blue}${NAME}%f on ${ALIGNMENT} side. Index was ${INDEX}. Duration was: ${humanReadableDuration}s"
done