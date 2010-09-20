DEV=$(dirname $0)
TMPDIR=/tmp
ALPHABET="ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅabcdefghijklmnopqrstuvwxyzæøåcqwxzCQWXZéèêóòâôÉÊÈÓÔÒÂáàÁÀäÄöÖ"

SLANG=nb
PREFIX=nb-nn
BASENAME=apertium-nn-nb

lt-expand ${DEV}/../${BASENAME}.${SLANG}.dix | grep -v '<prn><enc>\|DUE_TO_LT_PROC_HANG\|__REGEXP__\|<compound-only-L>\|<compound-R>' | grep -e ':>:' -e "[$ALPHABET]:[$ALPHABET]" | sed 's/:>:/%/g' | sed 's/:/%/g' | cut -f2 -d'%' | sed 's%\/%\\/%g' | sed 's/^/^/g' | sed 's/$/$ ^.<sent><clb>$/g' | tee $TMPDIR/tmp_${PREFIX}_testvoc1.txt |
        apertium-pretransfer|
        apertium-transfer ${DEV}/../${BASENAME}.${PREFIX}.t1x  ${DEV}/../${PREFIX}.t1x.bin  ${DEV}/../${PREFIX}.autobil.bin | tee $TMPDIR/tmp_${PREFIX}_testvoc2t.txt |
	apertium-interchunk ${DEV}/../${BASENAME}.${PREFIX}.t2x  ${DEV}/../${PREFIX}.t2x.bin | tee $TMPDIR/tmp_${PREFIX}_testvoc2i.txt |
	apertium-postchunk ${DEV}/../${BASENAME}.${PREFIX}.t3x  ${DEV}/../${PREFIX}.t3x.bin | tee $TMPDIR/tmp_${PREFIX}_testvoc2p.txt |
        lt-proc -d  ${DEV}/../${PREFIX}.autogen-no-cp.bin > $TMPDIR/tmp_${PREFIX}_testvoc3.txt

# add nb->nn_a:
cat $TMPDIR/tmp_${PREFIX}_testvoc2p.txt | lt-proc -d  ${DEV}/../${PREFIX}_a.autogen-no-cp.bin > $TMPDIR/tmp_${PREFIX}_testvoc3_a.txt

paste -d _ $TMPDIR/tmp_${PREFIX}_testvoc1.txt $TMPDIR/tmp_${PREFIX}_testvoc2t.txt $TMPDIR/tmp_${PREFIX}_testvoc3.txt | sed 's/\^.<sent><clb>\$//g' | sed 's/_/   --------->  /g' | sed 's/\\//g'

paste -d _ $TMPDIR/tmp_${PREFIX}_testvoc1.txt $TMPDIR/tmp_${PREFIX}_testvoc2t.txt $TMPDIR/tmp_${PREFIX}_testvoc3_a.txt | sed 's/\^.<sent><clb>\$//g' | sed 's/_/   --------->  /g' | sed 's/\\//g'
