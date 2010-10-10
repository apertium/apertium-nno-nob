#!/bin/bash

# OBT-to-Apertium.sh
# Convert (most of) the OBT CG into Apertium tag format.
# usage:
# cat current-OBT/nn_morf.cg | iconv -f latin1 -t utf8 > current-OBT/nn_morf.u8.cg
# ./OBT-to-Apertium.sh current-OBT/nn_morf.u8.cg > ../apertium-nn-nb.nn-nb.rlx


# What the original CG expects: adj pos be ent
# What the monodix give:        adj posi sg def


# OBT CG has no soft delimiters, but when running cg-proc on huge
# amounts of text, these stop us from getting "hard breaks":
echo 'SOFT-DELIMITERS = "<,>" ;'


LISTL=`mktemp -t obtll.XXXXXXXXXX`;
LISTR=`mktemp -t obtlr.XXXXXXXXXX`;
NEWLISTR=`mktemp -t obtnlr.XXXXXXXXXX`;
LISTDONE=`mktemp -t obtld.XXXXXXXXXX`;
RULEL=`mktemp -t obtrl.XXXXXXXXXX`;
RULER=`mktemp -t obtrr.XXXXXXXXXX`;
NEWRULER=`mktemp -t obtrnr.XXXXXXXXXX`;

replace () {
    L="s/\([\( ]\)"
    M="\([\) ;]\)/\1"
    R="\2/g"
    sed -e "
:LIST
${L}fork subst${M}n acr${R}
${L}fork${M}acr${R}
${L}subst mask prop${M}np m${R}
${L}subst fem prop${M}np f${R}
${L}subst nøyt prop${M}np nt${R}
${L}subst prop${M}np${R}
${L}subst${M}n${R}
${L}prop${M}np${R}
${L}mask${M}m${R}
${L}fem${M}f${R}
${L}nøyt${M}nt${R}
${L}verb${M}vblex${R}
${L}ent${M}sg${R}
${L}eint${M}sg${R}
${L}ub${M}ind${R}
${L}be${M}def${R}
${L}bu${M}def${R}
${L}fl${M}pl${R}
${L}akk${M}acc${R}
${L}pos${M}posi${R}
${L}poss${M}pos${R}
${L}pron${M}prn${R}
${L}prep${M}pr${R}
${L}komp${M}comp${R}
${L}refl${M}ref${R}
${L}kvant${M}qnt${R}
${L}konj${M}cnjcoo${R}
${L}sbu${M}cnjsub${R}
${L}m\/f${M}mf${R}
${L}<pres-part>${M}pprs${R}
${L}<perf-part>${M}adj pp${R}
${L}perf-part${M}vblex pp${R}
${L}st-form${M}pass${R}
${L}<st-verb>${M}pstv${R}
${L}<s-verb>${M}pstv${R}
${L}inf-merke${M}part${R}
${L}sp${M}itg${R}
${L}forst${M}emph${R}
${L}&sted${M}top${R}
${L}<sted>${M}top${R}
${L}<komma>${M}cm${R}
${L}<parentes-beg>${M}lpar${R}
${L}<parentes-slutt>${M}rpar${R}
${L}<ordenstall>${M}ord${R}
${L}<ordenstal>${M}ord${R}
${L}interj${M}ij${R}
tLIST
"
}

# remove anything that follows 'LIST name ='
cat $1 | sed 's/^\(LIST [^=][^=]*\).*/\1/' > $LISTL 
# keep only what follows 'LIST name ='
cat $1 | sed 's/^LIST [^=][^=]*/¶/' | sed 's/^[^¶].*//' | sed 's/^¶//' > $LISTR 

cat $LISTR | replace > $NEWLISTR
paste -d '' $LISTL $NEWLISTR > $LISTDONE

# remove anything that follows 'REMOVE/SELECT/MAP'
cat $LISTDONE | sed 's/^\([^:]*\)\(REMOVE\|SELECT\|MAP\).*/\1\2/' > $RULEL
# keep only what follows 'REMOVE/SELECT/MAP'
cat $1 | sed 's/^[^:]*\(REMOVE\|SELECT\|MAP\)/¶/' | sed 's/^[^¶].*//' | sed 's/^¶//' > $RULER 

cat $RULER | replace > $NEWRULER
paste -d '' $RULEL $NEWRULER 




##### TODO: ################################################################
# 
# appell -- eg. 'fyrst (np)', rather few rules, requires tagging lots
# of nouns as <appell>
# 
# symb => acr -- or? we don't split between symbols and acronyms, do
# we? symb only has one rule though, not important?
# 
# pron pers should split into p1, p2, p3; and then some places we have
# eg. (prn pers 1)
# 
# ubøy -- not sure what do do about this ("no inflection") 
# 
# ukjent -- can we check for * ?
# 
# <adj> -- never used; adj is used a lot, but <adj> is another POS
# which is "adjectival"
# 
# res -- currently using the same tag, but might change?
#
# hum -- not tagged in apertium (eg. 'hverandre', human, animate)
#
# <person>, <org>, <verk>, <hendelse>, <annet>, &person, &org, &verk,
# &hendelse, &annet -- not used, but at least we change &sted and
# <sted> to top
# 
# <strek>, <ellipse>, <anf> -- 
# 
##### See http://omilia.uio.no/obt/morfosyn.html ###########################


##### Stuff that needs doing afterwards if I run this again: ###############
# - make sure each rule has an IF: $ grep -nE "(SELECT|REMOVE).*[^F]$" *.rlx 
#   Actually, this seems to have no effect, even if we have a wordform
#   there, eg. SELECT ("<å>"ri) + (part) (1 vinf); it still works w/o IF
#
# - replace within SUBSTITUTE rules (only in bokmål)
#
# - Replace (pron pers) with (pron p1) (pron p2) (pron p3), etc. Hint:
#   only in one rule do we have "pers" appearing without "pron " before it:
#   "<meg>"  SELECT:3450 (pers) IF
#   (and in select/remove rules, just grep for 'pers)'
#
# - LIST adj-reinmask = (adj m) missing a semicolon in nn-nb.rlx
#
# - REMOVE:3536 needs (NOT -1 fl-adj/fl-det) added, add
#   REMOVE ("<hjem>") + (pr) IF (-1 det) (-2 prep);
# 
# - Replace n with "n or np" (except where we have "n appell")
############################################################################
