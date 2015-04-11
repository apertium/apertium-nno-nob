#!/bin/bash

set -u

lang1=nno
lang2=nob


basename=apertium-$lang1-$lang2

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

cd "$(dirname $0)/../.."

eval $(grep ^AP_SRC config.log)

echo "=== ${lang1}-${lang2} ==="
analysis-expansion "$AP_SRC1"/apertium-${lang1}.${lang1}.dix \
    | mode-after-analysis modes/${lang1}-${lang2}.mode \
    | only-errs

echo "=== ${lang2}-${lang1} ==="
analysis-expansion "$AP_SRC2"/apertium-${lang2}.${lang2}.dix \
    | mode-after-analysis modes/${lang2}-${lang1}.mode \
    | only-errs

