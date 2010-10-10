#!/bin/sh
# http://wiki.apertium.org/wiki/Asturian#Calculating_coverage
# Usage:
# cat /path/to/corpora/nb.txt | ./coverage.sh ../nb-nn.automorf.bin

# temp files
F=/tmp/corpus-stat-res.txt 
S=/tmp/corpus-stat-sorted.txt

export LC_ALL=

# mac sed is horribly slow for certain operations
GSED=sed; 
if test x$(uname -s) = xDarwin; then 
    type -P gsed &>/dev/null || { echo "This script requires gsed (or a real GNU/Linux machine) but it's not installed.  Aborting." >&2; exit 1; }
    GSED=gsed; 
fi

# Calculate the number of tokenised words in the corpus:
apertium-destxt |\
$GSED 's/\<the\>//g' |\
$GSED 's/\<The\>//g' |\
$GSED 's/\<of\>//g' |\
$GSED 's/\<oblast\>//g' |\
$GSED 's/\<in\>//g' |\
$GSED 's/\<In\>//g' |\
$GSED 's/\<it\>//g' |\
$GSED 's/\<if\>//g' |\
$GSED 's/\<ki\>//g' |\
$GSED 's/\<any\>//g' |\
$GSED 's/\<will\>//g' |\
$GSED 's/\<his\>//g' |\
$GSED 's/\<this\>//g' |\
$GSED 's/\<who\>//g' |\
$GSED 's/\<we\>//g' |\
$GSED 's/\<right\>//g' |\
$GSED 's/\<new\>//g' |\
$GSED 's/\<their\>//g' |\
$GSED 's/\<kraj\>//g' |\
$GSED 's/\<that\>//g' |\
$GSED 's/\<OfNm\>//g' |\
$GSED 's/\<you\>//g' |\
$GSED 's/\<www\>//g' |\
$GSED 's/\<com\>//g' |\
$GSED 's/\<org\>//g' |\
$GSED 's/\<Ob\>//g' |\
$GSED 's/\<http\>//g' |\
$GSED 's/\<px\>//g' |\
$GSED 's/\<inst\>//g' |\
$GSED 's/\<also\>//g' |\
$GSED 's/\<na\>//g' |\
$GSED 's/\<on\>//g' |\
$GSED 's/\<one\>//g' |\
$GSED 's/\<One\>//g' |\
$GSED 's/\<On\>//g' |\
$GSED 's/\<och\>//g' |\
$GSED 's/\<till\>//g' |\
$GSED 's/\<und\>//g' |\
$GSED 's/\<with\>//g' |\
$GSED 's/\<which\>//g' |\
$GSED 's/\<were\>//g' |\
$GSED 's/\<can\>//g' |\
$GSED 's/\<when\>//g' |\
$GSED 's/\<was\>//g' |\
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
