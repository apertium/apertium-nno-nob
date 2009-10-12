#!/bin/sh

# Creates some simple lists of the @'s, /'s and #' from the
# dev/inconsistency.sh scripts, and prints counts for putting on the
# wiki. Hmm, I wonder how much work would be involved in being able to
# say "make testvoc" and run this iff the dix haven't changed.

# Important: check the (bi)slash files before the hash files, since
# any slash implies a hash. Hmm, I should probaby grep -v
# those... after version 0.6 is out.

# Note: gsed used some places instead of sed since Mac OS X sed sucks,
# haven't bothered with making this general. Either install gsed
# (eg. from Macports) make a symlink.

# To get nb.@ or nn.@ into bidix format, use:
# sed 's/<\([^_>]*\)>/<s n="\1"\/>/' |\
# sed 's/<n_\([^>]*\)>/<s n="n"\/><s n="\1">/' |\
# gsed 's/.*/<e>       <p><l>\0<\/l><r>\0<\/r><\/p><\/e>/'

dir=`echo "$0" | sed 's,[^/]*$,,'`
test "x${dir}" = "x" && dir='.'

if test "x`cd "${dir}" 2>/dev/null && pwd`" != "x`pwd`"
then
    echo "This script must be executed directly from the apertium-nn-nb/dev directory."
    exit 1
fi


echo "MWE's are not captured by the inconsistency scripts, finding those first:"
cat ../apertium-nn-nb.nn.dix |grep '<e lm="[^"]* '|sed 's/">.*//'|sed 's/.*"//'|apertium nn-nb| grep '[#@]'
cat ../apertium-nn-nb.nb.dix |grep '<e lm="[^"]* '|sed 's/">.*//'|sed 's/.*"//'|apertium nb-nn| grep '[#@]'
cat ../apertium-nn-nb.nn-nb.dix|grep '<b/>'|sed 's/.*<l>//'|sed 's/<s.*//'|sed 's/<b\/>/ /g'|apertium nn-nb|grep '[#@]'
cat ../apertium-nn-nb.nn-nb.dix|grep '<b/>'|sed 's/.*<r>//'|sed 's/<s.*//'|sed 's/<b\/>/ /g'|apertium nb-nn|grep '[#@]'


printf "finding all nn=>nb inconsistencies..."
./nn-nb.inconsistency.sh > nn-nb.inconsistency 
printf "finding nb.@'s..." 
cat nn-nb.inconsistency | grep '@' |sed 's/<n></<n_/g'| gsed 's/.*@\([^>]*\).*/\1>/' | uniq > nb.@ 
printf "finding nb.#'s..."
cat nn-nb.inconsistency | grep '#' |sed 's/<n></<n_/g'| gsed 's/.*#\([^>]*\).*/\1>/' | uniq > nb.# 
printf "finding nb.bislash (bidix /'s)..."
cat nn-nb.inconsistency | grep    ' --------->.*\/.*--------->' | grep '\/' |sed 's/<n></<n_/g'| gsed 's/.*#\([^>]*\).*\/\([^>]*\).*/\1> \2>/' | uniq > nb.bislash
printf "finding nb.slash (generation /'s)..."
cat nn-nb.inconsistency | grep -v ' --------->.*\/.*--------->' | grep '\/' |sed 's/<n></<n_/g'| gsed 's/..*\^\([^>]*\).*/\1>/' | uniq > nb.slash
echo ""

printf "finding all nb=>nn inconsistencies..."
./nb-nn.inconsistency.sh > nb-nn.inconsistency 
printf "finding nn.@'s..."
cat nb-nn.inconsistency | grep '@' |sed 's/<n></<n_/g'| gsed 's/.*@\([^>]*\).*/\1>/' | uniq > nn.@ 
printf "finding nn.#'s..."
cat nb-nn.inconsistency | grep '#' |sed 's/<n></<n_/g'| gsed 's/.*#\([^>]*\).*/\1>/' | uniq > nn.# 
printf "finding nn.bislash (bidix /'s)..."
cat nb-nn.inconsistency | grep    ' --------->.*\/.*--------->' | grep '\/' |sed 's/<n></<n_/g'| gsed 's/.*#\([^>]*\).*\/\([^>]*\).*/\1> \2>/' | uniq > nn.bislash
printf "finding nn.slash (generation /'s)..."
cat nb-nn.inconsistency | grep -v ' --------->.*\/.*--------->' | grep '\/' |sed 's/<n></<n_/g'| gsed 's/..*\^\([^>]*\).*/\1>/' | uniq > nn.slash
echo ""

echo "stats for wiki:"
echo '|  Nynorsk' && wc -l nn.# nn.@ nn.bislash nn.slash | awk '!/total/ {print "| ", $1}' && echo '|
|-
|  Bokmål' &&  wc -l nb.# nb.@ nb.bislash nb.slash | awk '!/total/ {print "| ", $1}'
echo ""
