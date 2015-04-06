#!/bin/bash

set -u

lang1=nno
lang2=nob

basename=apertium-$lang1-$lang2

vc=svn
if [[ -d "$(dirname "$0")"/../.git ]]; then
    vc=git
fi

cd "$(dirname $0)/.."

make -j4 langs

echo "Translating changes from $vc diff:"

declare -i e=0

eval $(grep ^AP_SRC config.log)

$vc diff $AP_SRC1/apertium-$lang1.$lang1.dix | awk -F'lm="|"' '$2{print $2}' | apertium -d . $lang1-$lang2 | grep '[#@/]' && (( e++ ))
$vc diff $AP_SRC2/apertium-$lang2.$lang2.dix | awk -F'lm="|"' '$2{print $2}' | apertium -d . $lang2-$lang1 | grep '[#@/]' && (( e++ ))
$vc diff $basename.$lang1-$lang2.dix | awk -F'<l>|</l>' '{gsub(/<s [^>]*>/,"")} $2{print $2}' | apertium -d . $lang1-$lang2 | grep '[#@/]' && (( e++ ))
$vc diff $basename.$lang1-$lang2.dix | awk -F"<r>|</r>" '{gsub(/<s [^>]*>/,"")} $2{print $2}' | apertium -d . $lang2-$lang1 | grep '[#@/]' && (( e++ ))


if [[ $e -eq 0 ]]; then
    echo "Uncommitted changes to $lang1.dix, $lang2.dix and $lang1-$lang2.dix appear testvoc clean; go ahead and commit."
else
    echo "Uh-oh, there appear to be inconsistencies in your uncommitted changes. Please fix before committing."
fi
