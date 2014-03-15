#!/bin/bash

C=2
GREP='.'
if [ $# -eq 1 ]; then
    C=$1
    GREP='[*#/]'
fi

./wiki-tests.sh Regression nob nno  | grep -C $C "$GREP"

./wiki-tests.sh Regression nno nob  | grep -C $C "$GREP"

