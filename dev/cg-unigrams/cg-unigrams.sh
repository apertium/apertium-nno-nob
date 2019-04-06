#!/bin/bash

if [[ ! -f /tmp/nno.ntb.hitparade ]];then
    xzcat  ~/corpora/nno/ntb.wip.xz                     \
        | apertium-deshtml                              \
        | apertium -f none -d ../apertium-nno nno-morph \
        | apertium-cleanstream -n                       \
        | sed 's,/[^$]*,,g'                             \
        | tr -d '^$'                                    \
        | sort                                          \
        | uniq -c                                       \
        | sort -nr                                      \
        | sed 's/^ *\([0-9][0-9]*\) /\1\t/' >/tmp/nno.ntb.hitparade
fi

xzcat  ~/corpora/nob/ntb.wip.xz                                              \
    | tr -s ' ' '\n'                                                         \
    | apertium-deshtml                                                       \
    | ~/src/ap/lttoolbox/lttoolbox/lt-proc -w -e 'nob-nno.automorf.bin'      \
    | cg-proc -w 'nob-nno.rlx.bin'                                           \
    | python3 dev/testvoc/splitambig.py                                      \
    | apertium-pretransfer                                                   \
    | lt-proc -o 'nob-nno.autobil.bin'                                       \
    | apertium-transfer -b 'apertium-nno-nob.nob-nno.t1x'  'nob-nno.t1x.bin' \
    | apertium-interchunk 'apertium-nno-nob.nob-nno.t2x'  'nob-nno.t2x.bin'  \
    | apertium-postchunk 'apertium-nno-nob.nob-nno.t3x'  'nob-nno.t3x.bin'   \
    | lt-proc -N1 -g 'nob-nno_e.autogen.bin'                                 \
    | lt-proc -p 'nob-nno.autopgen.bin'                                      \
    | apertium-rehtml-noent                                                  \
    | sed 's,<apertium-notrans>,\n,g;s,</apertium-notrans>,\t,g'             \
    | sed 's, [.] *$,,'                                                      \
    | gawk 'BEGIN{OFS=FS="\t";n[""]++ } /^$/{ if(length(n)>1)print p;p="";for(w in n)delete n[w]} $2{ p=p"\n"$0;n[$2]++ }'     \
    | gawk -v h=/tmp/nno.ntb.hitparade 'BEGIN{OFS=FS="\t";while(getline<h)f[$2]=$1} $2 && $2 in f{print $0,f[$2]} /^$/{print}' \
           >/tmp/nob.cg-unigrams

tr '/' '\t' < /tmp/nob.cg-unigrams  \
    | cut -f1 \
    | grep . \
    | sort \
    | uniq -c \
    | sort -nr \
    | sed 's/^ *\([0-9]\+\) /\1\t/' >/tmp/unigrams.hitparade

tr '/' '\t' < /tmp/nob.cg-unigrams  \
    | gawk 'BEGIN{OFS=FS="\t";  while(getline<"/tmp/unigrams.hitparade")f[$2]=$1} !($1 in s){print $0,f[$1]; x=$1} /^$/{s[x]++;print ""}'  \
    | uniq >/tmp/with-frequencies

</tmp/with-frequencies awk '
 BEGIN{OFS=FS="\t"; }
 /^$/{if(s>1 && highest>(2*lowest)){print "l="lowest,"h="highest g"\n"; hs=""; for(x in select){ hs=x" "hs; } for(x in remove)print "\"<"nobform">\" REMOVE:default-"x" ;\t# keep "hs; } g="";lowest=0;highest=0;s=0;nobform=""}
 $4{s++} (!lowest) || $4<lowest{lowest=$4;for(x in remove)delete remove[x]}
 $4==lowest{t=$2; sub(/^/,"\"",t);sub(/</,"\" ",t);gsub(/</," ",t);gsub(/>/," ",t);gsub(/  +/," ",t);sub(/ $/,"",t);remove[$3" ("t")"]++}
 $4>highest{highest=$4;for(x in select)delete select[x]}
 $4==highest{select[$2"→"$3]++}
 $4{g=g"\n"$0;nobform=$1}'
