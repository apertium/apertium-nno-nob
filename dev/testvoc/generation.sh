#!/bin/bash

set -e -u

# You can override the below variables by doing e.g.
# $ export CYCLES=1 BLOCK=1M
# before running this script.

# How many times to follow cycle when expanding with --hfst; gets slow if too high:
declare -ir CYCLES=${CYCLES-0}
# How many parallel pipelines to run (requires GNU parallel installed;
# only worth increasing if CPU's are not saturated and there's free
# RAM while running):
declare -ir J=${J-1}
# How much data to translate before restarting the pipeline (some
# pipelines have memory leaks and need restarting every so often):
declare -r BLOCK=${BLOCK:-100M}


if [[ $# -ge 1 && $1 = --hfst ]]; then
    HFST=true
    shift
else
    HFST=false
fi

if [[ $# -eq 1 ]]; then
    mode=$1
    dix=guess
elif  [[ $# -eq 2 ]]; then
    mode=$1
    dix=$2
else
    cat >&2 <<EOF
Usage: $0 lang1-lang2
or:    $0 lang1-lang2 foo.dix
or:    $0 --hfst lang1-lang2 foo-bar.automorf.bin

Replaces the first step of the pipeline with the expanded analyser and
shows the resulting generation errors.

For example, do \`$0 nno-nob' in trunk/apertium-nno-nob/' to find
generation errors in the nno-nob direction (assumes that
modes/nno-nob.mode exists).

If the source .dix file has a non-standard name, you can specify it in
the second argument, for example \`$0 eng-sco
../apertium-eng_feil/apertium-eng.eng.dix'

If you pass --hfst, the trimmed analyser will be used, and
disambiguation will be skipped. This is a lot faster, but assumes you
don't use mapping rules in CG. With --hfst, the optional dix argument
is interpreted as the analyser binary (defaulting to the first file
name of the first program of the mode).

EOF
    exit 1
fi

analysis_expansion () {
    lt-expand "$1" \
        | awk -v clb="$2" -F':|:[<>]:' '
          /:<:/ {next}
          $2 ~ /<compound-(R|only-L)>|DUE_TO_LT_PROC_HANG|__REGEXP__/ {next}
          {
            esc=$2
            gsub("/","\\/",esc)
            gsub("^","\\^",esc)
            gsub("$","\\$",esc)
            print "["esc"] ^"$1"/"$2"$ ^./.<sent>"clb"$"
          }'
}

analyser_to_hfst () {
    case "$(head -c4 "$1")" in
        HFST)
            hfst-fst2fst -t "$1"
            ;;
        *) # lttoolbox bin's start with their <alphabet>'s :(
            lt-print "$1" \
                | sed 's/ /@_SPACE_@/g' \
                | hfst-txt2fst -e ε
            ;;
    esac
}

analysis_expansion_hfst () {
    analyser_to_hfst "$1" \
        | hfst-project -p lower \
        | hfst-fst2strings -c"${CYCLES}"  \
        | awk -v clb="$2" '
          /[][$^{}\\]/{next} # skip escaping hell
          /<compound-(R|only-L)>|DUE_TO_LT_PROC_HANG|__REGEXP__/ {next}
          {
            gsub("]","\\]")
            esc=$0
            gsub("/","\\/",esc)
            gsub("^","\\^",esc)
            gsub("$","\\$",esc)
            print "["esc"] ^"$0"$ ^.<sent>"clb"$"
          }'
    # give the "disambiguated" output, no forms
}

only_errs () {
    if [[ $# -ge 1 && $1 = --no-@ ]]; then
        atfilter () { grep -v '].*/@'; }
    else
        atfilter () { cat; }
    fi
    # turn escaped SOLIDUS into DIVISION SLASH, so we don't grep correct stuff ("A/S" is a possible lemma)
    sed 's%\\/%∕%g' |\
        atfilter |\
        grep '][^<]*[#/]'
}

run_mode () {
    if command -V parallel &>/dev/null; then
        parallel -j"$J" --pipe --block "${BLOCK}" -- bash "$@"
    else
        bash "$@"
    fi
}

declare -a TMPFILES
cleanup () {
    for f in "${TMPFILES[@]}"; do
        rm -f "$f"
    done
}
trap 'cleanup' EXIT


PYTHONPATH="$(dirname "$0"):${PYTHONPATH:-}"
export PYTHONPATH
if command -V pypy3 &>/dev/null; then
    python=pypy3
else
    python=python3
fi
split_ambig=$(mktemp -t gentestvoc.XXXXXXXXXXX)
TMPFILES+=("${split_ambig}")
cat >"${split_ambig}" <<EOF
#!/usr/bin/env ${python}
from streamparser import parse_file, readingToString, known
import sys
for blank, lu in parse_file(sys.stdin, withText=True):
    if lu.knownness == known:
        print(blank+" ".join("^{}/{}\$".format(lu.wordform, readingToString(r))
                            for r in lu.readings),
            end="")
    else:
        print(blank+"^"+lu.wordform+"/"+lu.knownness.symbol+lu.wordform+"$",
              end="")
EOF
chmod +x "${split_ambig}"

# TODO: using modes.xml with gendebug="yes" should make these
mode_after_analysis=$(mktemp -t gentestvoc.XXXXXXXXXXX)
TMPFILES+=("${mode_after_analysis}")
grep '|' modes/"${mode}".mode \
    | sed 's/[^|]*|//' \
    | sed 's/lt-proc -p[^|]*/cat/' \
    | sed "s%autobil.bin'* *|%& ${split_ambig} |%" \
    | sed 's/\$1/-d/g;s/\$2//g' \
    > "${mode_after_analysis}"

mode_after_tagger=$(mktemp -t gentestvoc.XXXXXXXXXXX)
TMPFILES+=("${mode_after_tagger}")
grep '|' modes/"${mode}".mode \
    | sed 's/[^|]*|//' \
    | sed 's/.*apertium-pretransfer/apertium-pretransfer/' \
    | sed 's/lt-proc -p[^|]*/cat/' \
    | sed "s%autobil.bin'* *|%& ${split_ambig} |%" \
    | sed 's/\$1/-d/g;s/\$2//g' \
    > "${mode_after_tagger}"
# lt-proc -p fails, that's why we remove that


lang1=${mode%%-*}

clb=""
case ${lang1} in
    nno|nob) clb="<clb>" ;;
esac

if $HFST; then
    if [[ ${dix} = guess ]]; then
        dix=$(xmllint --xpath "string(/modes/mode[@name = '${mode}']/pipeline/program[1]/file[1]/@name)" modes.xml)
    fi
    analysis_expansion_hfst "${dix}" "${clb}" \
        | run_mode "${mode_after_tagger}"     \
        | only_errs
else
    if [[ ${dix} = guess ]]; then
        lang1dir=$(grep -m1 "^AP_SRC.*apertium-${lang1}" config.log | sed "s/^[^=]*='//;s/'$//")
        dix=${lang1dir}/apertium-${lang1}.${lang1}.dix
    fi
    # Make it possible to edit the .dix while testvoc is running:
    dixtmp=$(mktemp -t gentestvoc.XXXXXXXXXXX)
    TMPFILES+=("${dixtmp}")
    cat "${dix}" > "${dixtmp}"
    analysis_expansion "${dixtmp}" "${clb}" \
        | run_mode "${mode_after_analysis}" \
        | only_errs --no-@
fi
