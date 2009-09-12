# script for washing the noreg-no-n*.txt files
grep -v 'Gå til toppen' | \
preprocess --abbr=~/gtsvn/st/nob/bin/abbr.txt | \
sed 's/^\.$/\.¢/g' | sed 's/^\?$/\?¢/' | \
sed 's/^\!$/\!¢/' | \
tr '[•\|]' '¢' | \
tr '\n' ' ' | \
tr '¢' '\n' | \
#sed 's/^ *(Gå til toppen )[0-9]|//g' | \
sed 's/^[0-9 \t\|]*//g' | \
grep -v '^$'
