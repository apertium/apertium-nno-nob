#!/bin/sh

########################################################################################
# Changes output from the ordbanken script to the beginnings of a 		       #
# paradigm. See script at							       #
# https://savannah.nongnu.org/projects/ordbanken/				       #
#										       #
# Usage:									       #
# ./ordbanken2XML.sh LANG WORD							       #
# eg.										       #
# ./ordbanken2XML.sh nn balderbrå						       #
########################################################################################

# Darwin sed has no (normal) \t nor \n
T="	" 
N="\\
"

echo '<pardef n="__">'

ordbanken -FPs $@ |\
# put tags on separate lines starting with XXXX
sed "s/\([^ ${T}]*\)[ ${T}]*\([^ ${T}]*\)/<e>       <p><l>\2<\/l>${T}<r>\1${N}XXXX/" |\
# put tags into <s> elements
sed '/XXXX/s/\([^X ${T}][^ ${T}]*\)/<s n="\1"\/>/g' |\
# remove unneccessary whitespace
sed 's/[ ]*</</g' |\
# convert tags
sed '/XXXX/s/"eint"/"sg"/g' |\
sed '/XXXX/s/"ent"/"sg"/g' |\
sed '/XXXX/s/"subst"/"n"/g' |\
sed '/XXXX/s/"fl"/"pl"/g' |\
sed '/XXXX/s/"bu"/"def"/g' |\
sed '/XXXX/s/"be"/"def"/g' |\
sed '/XXXX/s/"ub"/"ind"/g' |\
sed '/XXXX/s/"kvant"/"qnt"/g' |\
sed '/XXXX/s/"pos"/"posi"/g' |\
sed '/XXXX/s/"komp"/"comp"/g' |\
sed '/XXXX/s/"verb"/"vblex"/g' |\
sed '/XXXX/s/"st-form"/"pst"/g' |\
sed '/XXXX/s/"<st-verb>"/"pstv"/g' |\
sed '/XXXX/s/"<pres-part>"/"pprs"/g' |\
sed '/XXXX/s/"<perf-part>"/"pp"/g' |\
sed '/XXXX/s/"perf-part"/"pp"/g' |\
sed '/XXXX/s/nøyt/nt/g' |\
sed '/XXXX/s/m\/f/mf/g' |\
sed '/XXXX/s/mask/m/g' |\
sed '/XXXX/s/fem/f/g' |\
sed '/XXXX/s/<s n="appell"\/>//g' |\
# put things back on one line:
sed '/$/N;s/\nXXXX//' |\
# indent:
sed 's/^/  /' |\
# end tags:
sed 's/$/<\/r><\/p><\/e>/' |\
# make sure we have the right order:
sed 's/<s n="def"\/><s n="sg"\/>/<s n="sg"\/><s n="def"\/>/' |\
sed 's/<s n="ind"\/><s n="sg"\/>/<s n="sg"\/><s n="ind"\/>/' |\
# klammeform to LR
sed 's/<e>\(.*\)<s n="klammeform"\/>\(.*\)/<e r="LR">\1\2/' |\
# indent:
sed 's/<e>/<e>       /'
echo '</pardef>'
