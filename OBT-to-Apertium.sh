#!/bin/bash
# bash has arrays

# adj pos be ent
# <adj><pst><sg><def>

# This would be so much cleaner if I knew of a way to only replace
# stuff that's after a certain regexp within in a line. Ie. if I could
# say "look for lines that start with XYZ, do a global replace within
# the rest of the line but don't touch XYZ".  Of course, I _could_
# just tear them apart at the equals sign with ssed 's/^.*=//'
# etc. and then use paste to zip them back together...
L0="\(^LIST  *[^ ][^ ]*  *=.*[\( ]\)"
L1="\(^[^:]* REMOVE.*[\( ]\)"
L2="\(^[^:]* SELECT.*[\( ]\)"
L="s/\(${L0}\|${L1}\|${L2}\)" # these disjunctions are s..l...o.....w
M="\([\) ;]\)/\1"	      # hey sed! it's got a ^! use it!
R="\5/"
ssed -e "
:LIST
${L}n mask prop${M}np m${R}
${L}n fem prop${M}np f${R}
${L}n nt prop${M}np nt${R}
${L}n nøyt prop${M}np nt${R}
${L}n prop${M}np${R}
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
${L}refl${M}ref${R}
${L}kvant${M}qnt${R}
${L}konj${M}cnjcoo${R}
${L}sbu${M}cnjsub${R}
${L}m\/f${M}mf${R}
${L}<perf-part>${M}pp${R}
tLIST
" $1
# ^^ takes file as argument
# actually 'en' gets 'det kvant'...

# TODO: ordenstal(l), <pres-part>, inf-merke, forst, pers, ubøy
# pron pers should split into p1, p2, p3
# ubøy -- not sure what do do about this ("no inflection")
# ukjent -- unknown..hum.
# http://omilia.uio.no/obt/morfosyn.html
