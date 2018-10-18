#!/bin/bash

# Run from apertium-nno-nob and redirect output to file, e.g.
#
# $ dev/adj-sint-consistency.sh > fixed-bi.dix
#
# Expects nno/nob monolinguals to be in the same parent dir as
# apertium-nno-nob.

set -e -u

trap 'rm -rf "${d}"' EXIT
d=$(mktemp -d -t adj-sint-consistency.sh.XXXXXXXXXXX)

for l in nno nob; do
    lt-expand ../apertium-$l/apertium-$l.$l.dix |grep '<pst>'|grep '<adj>'|sort -u > "$d"/mono.$l
    grep    '<sint>' "$d"/mono.$l |sed 's/<.*//;s/.*://' |sort -u >"$d"/mono.$l.sint
    grep -v '<sint>' "$d"/mono.$l |sed 's/<.*//;s/.*://' |sort -u >"$d"/mono.$l.adj
done

awk                     \
    -v lsf="$d"/mono.nno.sint \
    -v laf="$d"/mono.nno.adj \
    -v rsf="$d"/mono.nob.sint \
    -v raf="$d"/mono.nob.adj '
BEGIN {
    while(getline<lsf)ls[$0]++
    while(getline<laf)la[$0]++
    while(getline<rsf)rs[$0]++
    while(getline<raf)ra[$0]++
}
{l=$0; sub(/.*<l>/,"",l); sub(/(<s|<\/l>).*/, "", l); sub(/<b\/>/, " ", l)}
{r=$0; sub(/.*<r>/,"",r); sub(/(<s|<\/r>).*/, "", r); sub(/<b\/>/, " ", r)}
/<section/{section++}
section && /<par n="adj/ {
    par=""
    if(/<par n="adj[^"]*f"/) f="-f"
    else                     f=""
    if(l in ls && r in rs) {
        par="adj_sint"f
    }
    else if(l in la && r in rs) {
        par="adj:adj_sint"f
    }
    else if(l in ls && r in ra) {
        par="adj_sint:adj"f
    }
    else if(l in la && r in ra) {
        par="adj"f
    }
    if(par) sub(/par n="adj[^"]*/, "par n=\""par)
}
{print}
' apertium-nno-nob.nno-nob.dix
