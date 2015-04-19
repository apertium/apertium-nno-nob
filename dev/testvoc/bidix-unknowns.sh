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
    | grep -ve __REGEXP__ -e ':<:' \
    | sed 's/.*://; s/\(<.*>\)\(#.*\)/\2\1/' \
    | LC_ALL=C sort -u >"${exp}"

echo "Expanding bidix and checking for entries missing from monodix …" >&2
lt-expand "${bidix}" \
    | awk -vside="${side}" -F':|:[<>]:' '
        BEGIN {
          if(side=="l") {
            nside=1
          }
          else {
            nside=2
          }
        }
        {print $nside}' \
    | while read -r bientry;do
          LC_ALL=C look "${bientry}" "${exp}" >/dev/null || echo "${bientry}"
      done
