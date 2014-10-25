#!/bin/bash

set -e -u

export AP_SRCN=AP_SRC1
export SLANG=nno
export PREFIX=nno-nob
export BASENAME=apertium-nno-nob

bash "$(dirname $0)"/inconsistency.sh
