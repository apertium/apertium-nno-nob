#!/bin/bash

C=2
GREP='.'
if [ $# -eq 1 ]
then
C=$1
GREP='WORKS'
fi

./wiki-tests.sh Pending nob nno  | grep -C $C "$GREP"

./wiki-tests.sh Pending nno nob  | grep -C $C "$GREP"


