# script for washing the noreg-no-n*.txt files
# the "preprocess" line requires the perl script

grep -v '[•\|]' | \
egrep -v '(Gå til toppen|MinID|\[|A-Å|A B D E|Ofte Stilte Spørsmål)' | \
preprocess --abbr=abbr.txt | \
sed 's/^\.$/\.¢/g' | sed 's/^\?$/\?¢/' | \
sed 's/^\!$/\!¢/' | \
tr '[•\|]' '¢' | \
tr '\n' ' ' | \
tr '¢' '\n' | \
#sed 's/^ *(Gå til toppen )[0-9]|//g' | \
#sed 's/^[0-9 \t\|]*//g' | \
grep -v '^$' | \
sed 's/^ *//g;'

