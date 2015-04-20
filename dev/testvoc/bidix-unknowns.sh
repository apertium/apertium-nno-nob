#!/bin/bash

set -e -u

if [[ $# -eq 1 ]]; then
    lang=$1
    monodix=guess
    bidix=guess
    side=guess
elif  [[ $# -eq 4 ]]; then
    lang=$1
    monodix=$2
    bidix=$3
    side=$4
else
    cat >&2 <<EOF
Usage: $0 lang
or:    $0 lang mono.dix bi.dix [r|l]

Expands the analyser, and looks up all the bidix entries in the
expanded analyser.

For example, do \`$0 nno' in trunk/apertium-nno-nob/' to find
nno-words that are in bidix but not the nno-analyser. If the source
.dix files have a non-standard name, you can specify them in the
second and third arguments, for example
\`$0 eng ../apertium-eng_feil/apertium-eng.eng.dix apertium-eng-sco.eng-sco.dix l'
(where \`l' means eng is the left-side of the bidix).
EOF
    exit 1
fi


if [[ ${monodix} = guess ]]; then
    langdir=$(grep -m1 "^AP_SRC.*apertium-${lang}" config.log | sed "s/^[^=]*='//;s/'$//")
    monodix=${langdir}/apertium-${lang}.${lang}.dix
fi
if [[ ${bidix} = guess ]]; then
    basename=$(grep -m1 "^PACKAGE='apertium-" config.log | sed "s/^[^=]*='//;s/'$//")
    pair=${basename##apertium-}
    bidix=${basename}.${pair}.dix
fi
if [[ ${side} = guess ]]; then
    if [[ ${lang} = ${pair%%-*} ]]; then
        side=l
    else
        side=r
    fi
fi

exp=$(mktemp -t bidix-unknowns.XXXXXXXX)
trap 'rm -f "${exp}"' EXIT

echo "Expanding monodix …" >&2
lt-expand "${monodix}" \
    | grep -ve __REGEXP__ \
    | sed 's/[^:]*//; s/\(<.*>\)\(#.*\)/\2\1/' \
    | LC_ALL=C sort -u >"${exp}"

in_mono () {
    # bidix has prefixes of monodix, have to use look instead of comm :-/
    LC_ALL=C look "$1" "${exp}" >/dev/null
}
echo "Expanding bidix and checking for entries missing from monodix …" >&2
lt-expand "${bidix}" \
    | awk -vside="${side}" -F':|:[<>]:' '
        BEGIN {
          if(side=="l") {
            nside=1
            LR=":>:"
            RL=":<:"
          }
          else {
            nside=2
            LR=":<:"            # flip it
            RL=":>:"            # and reverse
          }
        }
        # Make bidix match up with monodix (left=left, right=right):
        /:>:/ { print LR $nside; next }
        /:<:/ { print RL $nside; next }
        /:/   { print ":"$nside }
' \
    | while read -r bientry; do
          # Bidix now normalised to have the requested monodix on the "left"
          case ${bientry} in
              ":>:"* ) # If it's LR in bidix, then we check if unmarked / LR is in monodix
                       in_mono "${bientry##:>}" || in_mono "${bientry}" || echo "${bientry}"
                       ;;
              ":<:"* ) # If it's RL in bidix, then we check if unmarked / RL is in monodix
                       in_mono "${bientry##:<}" || in_mono "${bientry}" || echo "${bientry}"
                       ;;
              ":"* ) # If it's unmarked in bidix, then we check if unmarked / LR / RL in monodix
                     in_mono "${bientry}" || in_mono ":>${bientry}" || in_mono ":<${bientry}" || echo "${bientry}"
                     ;;
              *) echo "ERROR: unexpected bientry format: ${bientry}" >&2;;
          esac
      done
