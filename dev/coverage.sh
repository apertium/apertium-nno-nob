#!/bin/sh
# http://wiki.apertium.org/wiki/Asturian#Calculating_coverage
# Usage:
# cat /path/to/corpora/nb.txt | ./coverage.sh ../nb-nn.automorf.bin

# temp files
F=/tmp/corpus-stat-res.txt 
S=/tmp/corpus-stat-sorted.txt

export LC_ALL=

# Calculate the number of tokenised words in the corpus:
apertium-destxt |\
gsed 's/\<the\>//g' |\
gsed 's/\<The\>//g' |\
gsed 's/\<of\>//g' |\
gsed 's/\<oblast\>//g' |\
gsed 's/\<in\>//g' |\
gsed 's/\<In\>//g' |\
gsed 's/\<it\>//g' |\
gsed 's/\<if\>//g' |\
gsed 's/\<ki\>//g' |\
gsed 's/\<any\>//g' |\
gsed 's/\<will\>//g' |\
gsed 's/\<his\>//g' |\
gsed 's/\<this\>//g' |\
gsed 's/\<who\>//g' |\
gsed 's/\<we\>//g' |\
gsed 's/\<right\>//g' |\
gsed 's/\<new\>//g' |\
gsed 's/\<their\>//g' |\
gsed 's/\<kraj\>//g' |\
gsed 's/\<that\>//g' |\
gsed 's/\<OfNm\>//g' |\
gsed 's/\<you\>//g' |\
gsed 's/\<www\>//g' |\
gsed 's/\<com\>//g' |\
gsed 's/\<org\>//g' |\
gsed 's/\<Ob\>//g' |\
gsed 's/\<http\>//g' |\
gsed 's/\<px\>//g' |\
gsed 's/\<inst\>//g' |\
gsed 's/\<also\>//g' |\
gsed 's/\<na\>//g' |\
gsed 's/\<on\>//g' |\
gsed 's/\<one\>//g' |\
gsed 's/\<One\>//g' |\
gsed 's/\<On\>//g' |\
gsed 's/\<och\>//g' |\
gsed 's/\<till\>//g' |\
gsed 's/\<und\>//g' |\
gsed 's/\<with\>//g' |\
gsed 's/\<which\>//g' |\
gsed 's/\<were\>//g' |\
gsed 's/\<can\>//g' |\
gsed 's/\<when\>//g' |\
gsed 's/\<was\>//g' |\
lt-proc -w $1 |apertium-retxt |\
# for some reason putting the newline in directly doesn't work, so two seds
sed 's/\$[^^]*\^/$^/g' | sed 's/\$\^/$\
^/g' > $F

NUMWORDS=`cat $F | wc -l`
echo "Number of tokenised words in the corpus: $NUMWORDS"

# Calculate the number of words that are not unknown
NUMKNOWNWORDS=`cat $F | grep -v '\/\*' | wc -l`
echo "Number of known words in the corpus: $NUMKNOWNWORDS"

# Calculate the coverage
COVERAGE=`calc "round($NUMKNOWNWORDS/$NUMWORDS*1000)/10"`
echo "Coverage: $COVERAGE %"

# Show the top-ten unknown words.
echo "Top unknown words in the corpus:"
# sort on Mac is stupid:
export LC_ALL='C' 
cat $F | grep '\/\*' | sort -f | uniq -c | sort -gr > $S
head -10 $S

NEEDED=`calc "$NUMWORDS*.90-$NUMKNOWNWORDS"`
echo "Tokens needed to get 90 %: $NEEDED . Corresponding wordlist::"
awk '// {print $0; t += $1; if( t > '"$NEEDED"' ) exit; } END {print t}' $S 
awk '// {printf "%s", $0; w += 1; t += $1; if(w%1==0) printf "\n"; if( t > '"$NEEDED"' ) exit; } END {print t}' $S 
