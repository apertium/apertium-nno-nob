#!/bin/bash

set -e -u

slang=nno
prefix=nno-nob
basename=apertium-nno-nob

pairdir=$(dirname $0)/../..

source <(grep '^AP_SRC[^=]*=' ${pairdir}/config.log)

lt-expand ${AP_SRC1}/apertium-${slang}.${slang}.dix |
    grep -v ':<:\|DUE_TO_LT_PROC_HANG\|__REGEXP__\|<compound-only-L>\|<compound-R>' |
    awk -F':|:[<>]:' '{print "^"$2"$^.<sent><clb>$"}' |
    apertium-pretransfer |
    lt-proc -b ${pairdir}/${prefix}.autobil.bin |
    apertium-transfer -b ${pairdir}/${basename}.${prefix}.t1x  ${pairdir}/${prefix}.t1x.bin |
    sed 's%\^.<sent><clb>\$%%' |
    lt-proc -d ${pairdir}/${prefix}.autogen.bin 
