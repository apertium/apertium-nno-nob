#!/bin/bash

set -e -u

declare -ri MAX_SECS=120
declare -ri MAX_LINES=50000

timeout () {
    if command -V timeout &>/dev/null; then
        command timeout "$MAX_SECS" "$@"
    else
        "$@"
    fi
}

cd "$(dirname "$0")"/../..

if [[ $# -ne 1 ]]; then
    echo "Expecting language pair as argument, e.g. 'dan-swe'" >&2
    exit 1
fi
pair="$1"
lang1="${pair%%-*}"
lang1dir=$(grep -m1 "^AP_SRC.*apertium-${lang1}" config.log | sed "s/^[^=]*='//;s/'$//")

# exit with 0 if we found no # nor @
! timeout paste -d '\n' "${lang1dir}"/texts/ngrams.[0-9] \
    | head -"$MAX_LINES" \
    | cut -f2- \
    | tr '\t' ' ' \
    | apertium -f html-noent -d . "$pair"-dgen \
    | grep '[#@]'

