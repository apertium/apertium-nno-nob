#!/bin/bash

set -e -u

trap 'rm -rf "${d}"' EXIT
d=$(mktemp -d -t adj-sint-consistency.sh.XXXXXXXXXXX)

for field in 1 2; do
    lt-expand apertium-nno-nob.nno-nob.dix \
        | awk -v field=$field -F':|:[<>]:' 'BEGIN{t="<"tag">"}
{w=$field}
w~/<adj>/ && w~/<pst>/ {
  if (w~/<sint>/) sint="sint"
  else sint="adj"
  sub(/<.*/,"",w)
  print sint"\t"w
}' \
        | sort -u > "$d"/$field
done

for tag in adj sint; do
    grep "^$tag" "$d"/1 | cut -f2- > "$d/nno.$tag"
    grep "^$tag" "$d"/2 | cut -f2- > "$d/nob.$tag"
done

for l in nno nob; do
    lt-expand ../apertium-$l/apertium-$l.$l.dix |grep '<pst>'|grep '<adj>'|sort -u > "$d"/mono.$l
    grep    '<sint>' "$d"/mono.$l |sed 's/<.*//;s/.*://' |sort -u >"$d"/mono.$l.sint
    grep -v '<sint>' "$d"/mono.$l |sed 's/<.*//;s/.*://' |sort -u >"$d"/mono.$l.adj
done

r_to_sint () {   comm -13 "$d"/mono.nob.adj  "$d"/nob.adj  | comm -12 - "$d"/mono.nob.sint ; }
l_to_sint () {   comm -13 "$d"/mono.nno.adj  "$d"/nno.adj  | comm -12 - "$d"/mono.nno.sint ; }
l_to_unsint () { comm -13 "$d"/mono.nno.sint "$d"/nno.sint | comm -12 - "$d"/mono.nno.adj  ; }
r_to_unsint () { comm -13 "$d"/mono.nob.sint "$d"/nob.sint | comm -12 - "$d"/mono.nob.adj  ; }

# TODO: fix bidix pardefs
# for each entry in r_to_sint, add the sint tag on the right hand side, etc.

# Watch out for the adj-f pardefs:
# <e r="RL"><p><l>einsleg</l><r>einslig</r></p><par n="adj_sint:adj-f"/></e>
