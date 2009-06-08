#!/bin/sh

# Changes output from the ordbanken script to the beginnings of a
# paradigm. See script at
# https://savannah.nongnu.org/projects/ordbanken/

echo '<pardef n="__">'
ssed 's/\([^ \t]*\)[ \t]*\([^ \t]*\)/<e>       <p><l>\2<\/l>\t<r>\1\nXXXX/' |\
ssed '/XXXX/s/\([^X \t][^ \t]*\)/<s n="\1"\/>/g' |\
ssed 's/[ ]*</</g' |\
ssed '/XXXX/s/"eint"/"sg"/g' |\
ssed '/XXXX/s/"ent"/"sg"/g' |\
ssed '/XXXX/s/"fl"/"pl"/g' |\
ssed '/XXXX/s/"bu"/"def"/g' |\
ssed '/XXXX/s/"be"/"def"/g' |\
ssed '/XXXX/s/"ub"/"ind"/g' |\
ssed '/XXXX/s/"st-form"/"pst"/g' |\
ssed '/XXXX/s/"<perf-part>"/"pst"/g' |\
ssed '/XXXX/s/"<pres-part>"/"pp"/g' |\
ssed '/XXXX/s/"perf-part"/"pp"/g' |\
ssed '/XXXX/s/nøyt/nt/g' |\
ssed '/XXXX/s/m\/f/mf/g' |\
ssed '/$/N;s/\nXXXX//' |\
ssed 's/^/  /' |\
ssed 's/$/<\/r><\/p><\/e>/' |\
ssed 's/<s n="def"\/><s n="sg"\/>/<s n="sg"\/><s n="def"\/>/' |\
ssed 's/<s n="ind"\/><s n="sg"\/>/<s n="sg"\/><s n="ind"\/>/' 
echo '</pardef>'