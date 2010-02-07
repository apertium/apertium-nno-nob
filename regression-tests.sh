#!/bin/bash

C=2
GREP='.'
if [ $# -eq 1 ]
then
C=$1
GREP='[*#/]'
fi

./wiki-tests.sh Regression nb nn  | grep -C $C "$GREP"

./wiki-tests.sh Regression nn nb  | grep -C $C "$GREP"

