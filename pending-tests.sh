#!/bin/bash

C=2
GREP='.'
if [ $# -eq 1 ]
then
C=$1
GREP='WORKS'
fi

./wiki-tests.sh Pending nb nn  | grep -C $C "$GREP"

./wiki-tests.sh Pending nn nb  | grep -C $C "$GREP"


