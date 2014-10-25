#!/bin/bash

set -e -u -o pipefail

pairdir=$(dirname $0)/../..

AP_SRC=$(grep "^${AP_SRCN}='" ${pairdir}/config.log | sed "s/[^=]*='//;s/'$//")

lt-expand ${pairdir}/${AP_SRC}/apertium-${SLANG}.${SLANG}.dix |
    awk -F':|:[<>]:' '
      /:<:|__REGEXP__|DUE_TO_LT_PROC_HANG|<compound-only-L>|<compound-R>/ { next }
      { print "^"$2"$^.<sent><clb>$" }' |
    apertium-pretransfer |
    lt-proc -b ${pairdir}/${PREFIX}.autobil.bin |
    apertium-transfer -b ${pairdir}/${BASENAME}.${PREFIX}.t1x ${pairdir}/${PREFIX}.t1x.bin |
    apertium-interchunk  ${pairdir}/${BASENAME}.${PREFIX}.t2x ${pairdir}/${PREFIX}.t2x.bin |
    apertium-postchunk   ${pairdir}/${BASENAME}.${PREFIX}.t3x ${pairdir}/${PREFIX}.t3x.bin |
    sed 's%\^.<sent><clb>\$%%' |
    lt-proc -d ${pairdir}/${PREFIX}.autogen.bin
