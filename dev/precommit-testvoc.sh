#!/bin/bash

set -u

lang1=nn
lang2=nb

basename=apertium-$lang1-$lang2

vc=svn
if [[ -d "$(dirname "$0")"/../.git ]]; then
    vc=git
fi


make -j3

echo "Translating changes from $vc diff:"

declare -i e=0

$vc diff $basename.$lang1-$lang2.dix | awk -F'<l>|</l>' '{gsub(/<s [^>]*>/,"")} $2{print $2}' | apertium -d . $lang1-$lang2 | grep '[#@/]' && (( e++ ))
$vc diff $basename.$lang1-$lang2.dix | awk -F"<r>|</r>" '{gsub(/<s [^>]*>/,"")} $2{print $2}' | apertium -d . $lang2-$lang1 | grep '[#@/]' && (( e++ ))
$vc diff $basename.$lang1.dix        | awk -F'lm="|"' '$2{print $2}'                          | apertium -d . $lang1-$lang2 | grep '[#@/]' && (( e++ ))
$vc diff $basename.$lang2.dix        | awk -F'lm="|"' '$2{print $2}'                          | apertium -d . $lang2-$lang1 | grep '[#@/]' && (( e++ ))


if [[ $e -eq 0 ]]; then
    echo "Uncommitted changes to $basename.$lang1.dix, $basename.$lang2.dix and $basename.$lang1-$lang2.dix appear testvoc clean, go ahead and commit."
else
    echo "Uh-oh, there appear to be inconsistencies in your uncommitted changes. Please fix before committing."
fi
