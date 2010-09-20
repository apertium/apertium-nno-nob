DEV=$(dirname $0)
TMPDIR=/tmp
ALPHABET="ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅabcdefghijklmnopqrstuvwxyzæøåcqwxzCQWXZéèêóòâôÉÊÈÓÔÒÂáàÁÀäÄöÖ"

SLANG=nn
PREFIX=nn-nb
BASENAME=apertium-nn-nb

lt-expand ${DEV}/../${BASENAME}.${SLANG}.dix | grep -v '<prn><enc>\|DUE_TO_LT_PROC_HANG\|__REGEXP__\|<compound-only-L>\|<compound-R>' | grep -e ':>:' -e "[$ALPHABET]:[$ALPHABET]" | sed 's/:>:/%/g' | sed 's/:/%/g' | cut -f2 -d'%' | sed 's%\/%\\/%g' | sed 's/^/^/g' | sed 's/$/$ ^.<sent><clb>$/g' | tee $TMPDIR/tmp_${PREFIX}_testvoc1.txt |
        apertium-pretransfer|
        apertium-transfer ${DEV}/../${BASENAME}.${PREFIX}.t1x  ${DEV}/../${PREFIX}.t1x.bin  ${DEV}/../${PREFIX}.autobil.bin | tee $TMPDIR/tmp_${PREFIX}_testvoc2.txt | 
        lt-proc -d ${DEV}/../${PREFIX}.autogen-no-cp.bin > $TMPDIR/tmp_${PREFIX}_testvoc3.txt

paste -d _ $TMPDIR/tmp_${PREFIX}_testvoc1.txt $TMPDIR/tmp_${PREFIX}_testvoc2.txt $TMPDIR/tmp_${PREFIX}_testvoc3.txt | sed 's/\^.<sent><clb>\$//g' | sed 's/_/   --------->  /g' | sed 's/\\//g'
