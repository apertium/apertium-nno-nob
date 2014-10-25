#!/bin/bash

set -e -u

export AP_SRCN=AP_SRC2
export SLANG=nob
export PREFIX=nob-nno
export BASENAME=apertium-nno-nob

bash "$(dirname $0)"/inconsistency.sh
