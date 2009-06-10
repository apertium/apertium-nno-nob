#!/bin/bash

# OBT-to-Apertium.sh
# Convert (most of) the OBT CG into Apertium tag format.
# usage:
# ./OBT-to-Apertium nn_morf-utf8.cg > apertium-nn-nb.nn-nb.rlx

# What the original CG expects: adj pos be ent
# What the monodix give:        adj pst sg def

# OBT CG has no soft delimiters, but when running cg-proc on huge
# amounts of text, these stop us from getting "hard breaks":
echo 'SOFT-DELIMITERS = "<,>" ;'

# This would be so much cleaner if I knew of a way to only replace
# stuff that's after a certain regexp within in a line. Ie. if I could
# say "look for lines that start with XYZ, do a global replace within
# the rest of the line but don't touch XYZ".  Of course, I _could_
# just tear them apart at the equals sign with ssed 's/^.*=//'
# etc. and then use paste to zip them back together...
L0="\(^LIST  *[^ ][^ ]*  *=.*[\( ]\)"
L1="\(^[^:]*REMOVE.*[\( ]\)"
L2="\(^[^:]*SELECT.*[\( ]\)"
L3="\(^[^:]*SUBSTITUTE.*[\( ]\)" # I'll do those manually instead
L="s/\(${L0}\|${L1}\|${L2}\)" # these disjunctions are s..l...o.....w
M="\([\) ;]\)/\1"	      # hey sed! it's got a ^! use it!
R="\5/"
ssed -e "
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
${L}poss${M}pos${R}
${L}pron${M}prn${R}
${L}prep${M}pr${R}
${L}komp${M}comp${R}
${L}pos${M}posi${R}
${L}refl${M}ref${R}
${L}kvant${M}qnt${R}
${L}konj${M}cnjcoo${R}
${L}sbu${M}cnjsub${R}
${L}m\/f${M}mf${R}
${L}<pres-part>${M}pprs${R}
${L}<perf-part>${M}adj pp${R}
${L}perf-part${M}vblex pp${R}
${L}st-form${M}pst${R}
${L}<st-verb>${M}pstv${R}
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
tLIST
" $1
# ^^ takes file as argument

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
# - move "mens" rule up before REMOVE:2046 (cnjsub)
# - replace within SUBSTITUTE rules (only in bokmål)
# - Replace (pron pers) with (pron p1) (pron p2) (pron p3), etc. Hint:
#   only in one rule do we have "pers" appearing without "pron " before it:
#   "<meg>"  SELECT:3450 (pers) IF...
############################################################################
