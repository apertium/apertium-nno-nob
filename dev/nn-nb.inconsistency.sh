TMPDIR=/tmp
ALPHABET="ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅabcdefghijklmnopqrstuvwxyzæøåcqwxzCQWXZéèêóòâôÉÊÈÓÔÒÂáàÁÀäÄöÖ"
lt-expand ../apertium-nn-nb.nn.dix | grep -v '<prn><enc>' | grep -e ':<:' -e "[$ALPHABET]:[$ALPHABET]" | sed 's/:<:/%/g' | sed 's/:/%/g' | cut -f2 -d'%' |  sed 's/^/^/g' | sed 's/$/$ ^.<sent><clb>$/g' | tee $TMPDIR/tmp_testvoc1.txt |
        apertium-pretransfer|
        apertium-transfer ../apertium-nn-nb.nn-nb.t1x  ../nn-nb.t1x.bin  ../nn-nb.autobil.bin | tee $TMPDIR/tmp_testvoc2.txt | 
        lt-proc -d ../nn-nb.autogen.bin > $TMPDIR/tmp_testvoc3.txt
paste -d _ $TMPDIR/tmp_testvoc1.txt $TMPDIR/tmp_testvoc2.txt $TMPDIR/tmp_testvoc3.txt | sed 's/\^.<sent><clb>\$//g' | sed 's/_/   --------->  /g' | sed 's/\\//g'
