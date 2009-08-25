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
ssed 's/\<the\>//g' |\
ssed 's/\<The\>//g' |\
ssed 's/\<of\>//g' |\
ssed 's/\<oblast\>//g' |\
ssed 's/\<in\>//g' |\
ssed 's/\<In\>//g' |\
ssed 's/\<it\>//g' |\
ssed 's/\<if\>//g' |\
ssed 's/\<ki\>//g' |\
ssed 's/\<any\>//g' |\
ssed 's/\<will\>//g' |\
ssed 's/\<his\>//g' |\
ssed 's/\<this\>//g' |\
ssed 's/\<who\>//g' |\
ssed 's/\<we\>//g' |\
ssed 's/\<right\>//g' |\
ssed 's/\<new\>//g' |\
ssed 's/\<their\>//g' |\
ssed 's/\<kraj\>//g' |\
ssed 's/\<that\>//g' |\
ssed 's/\<OfNm\>//g' |\
ssed 's/\<you\>//g' |\
ssed 's/\<www\>//g' |\
ssed 's/\<com\>//g' |\
ssed 's/\<org\>//g' |\
ssed 's/\<Ob\>//g' |\
ssed 's/\<http\>//g' |\
ssed 's/\<px\>//g' |\
ssed 's/\<inst\>//g' |\
ssed 's/\<also\>//g' |\
ssed 's/\<na\>//g' |\
ssed 's/\<on\>//g' |\
ssed 's/\<one\>//g' |\
ssed 's/\<One\>//g' |\
ssed 's/\<On\>//g' |\
ssed 's/\<och\>//g' |\
ssed 's/\<till\>//g' |\
ssed 's/\<und\>//g' |\
ssed 's/\<with\>//g' |\
ssed 's/\<which\>//g' |\
ssed 's/\<were\>//g' |\
ssed 's/\<can\>//g' |\
ssed 's/\<when\>//g' |\
ssed 's/\<was\>//g' |\
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
