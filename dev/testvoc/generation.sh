#!/bin/bash

set -e -u

if [[ $# -eq 1 ]]; then
    mode=$1
    dix=guess
elif  [[ $# -eq 2 ]]; then
    mode=$1
    dix=$2
else
    cat >&2 <<EOF
Usage: $0 lang1-lang2
For example, do '$0 nno-nob' in trunk/apertium-nno-nob/ to
find generation errors in the nno-nob direction
Alternatively: $0 lang1-lang2 foo.dix
to specify the source .dix to expand.
EOF
    exit 1
fi

analysis-expansion ()
{
    lt-expand "$1" \
        | awk -F':|:[<>]:' '
          /:<:/ {next}
          $2~/<compound-(R|only-L)>|DUE_TO_LT_PROC_HANG/ {next}
          {
            esc=$2
            gsub("/","\\/",esc)
            gsub("^","\\^",esc)
            gsub("$","\\$",esc)
            print "["esc"] ^"$1"/"$2"$ ^./.<sent><clb>$"
          }'
}

mode-after-analysis ()
{
    eval $(grep '|' "$1" | sed 's/[^|]*|//' | sed 's/\$1/-d/g;s/\$2//g')
}

only-errs () {
    grep '][^<]*[#/]'
}


lang1=${mode%%-*}

if [[ ${dix} = guess ]]; then
    lang1dir=$(grep -m1 "^AP_SRC.*apertium-${lang1}" config.log | sed "s/^[^=]*='//;s/'$//")
    dix=${lang1dir}/apertium-${lang1}.${lang1}.dix
fi

analysis-expansion "${dix}" \
    | mode-after-analysis modes/"${mode}".mode \
    | only-errs
