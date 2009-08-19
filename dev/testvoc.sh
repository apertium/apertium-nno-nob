#!/bin/sh

# Creates some simple lists of the @'s, /'s and #' from the
# dev/inconsistency.sh scripts, and prints counts for putting on the
# wiki. Hmm, I wonder how much work would be involved in being able to
# say "make testvoc" and run this iff the dix haven't changed.

# Important: check the (bi)slash files before the hash files, since
# any slash implies a hash. Hmm, I should probaby grep -v
# those... after version 0.6 is out.

# Note: ssed used some places instead of sed since Mac OS X sed sucks,
# haven't bothered with making this general. Either install ssed
# (eg. from Macports) make a symlink.

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


echo "finding all nn=>nb inconsistencies..."
./nn-nb.inconsistency.sh > nn-nb.inconsistency 
echo "finding nb.@'s..." 
cat nn-nb.inconsistency | grep '@' |sed 's/<n></<n_/g'| ssed 's/.*@\([^>]*\).*/\1>/' | uniq > nb.@ 
echo "finding nb.#'s..."
cat nn-nb.inconsistency | grep '#' |sed 's/<n></<n_/g'| ssed 's/.*#\([^>]*\).*/\1>/' | uniq > nb.# 
echo "finding nb.bislash (bidix /'s)..."
cat nn-nb.inconsistency | grep    ' --------->.*\/.*--------->' | grep '\/' |sed 's/<n></<n_/g'| ssed 's/.*#\([^>]*\).*\/\([^>]*\).*/\1> \2>/' | uniq > nb.bislash
echo "finding nb.slash (generation /'s)..."
cat nn-nb.inconsistency | grep -v ' --------->.*\/.*--------->' | grep '\/' |sed 's/<n></<n_/g'| ssed 's/..*\^\([^>]*\).*/\1>/' | uniq > nb.slash

echo "finding all nb=>nn inconsistencies..."
./nb-nn.inconsistency.sh > nb-nn.inconsistency 
echo "finding nn.@'s..."
cat nb-nn.inconsistency | grep '@' |sed 's/<n></<n_/g'| ssed 's/.*@\([^>]*\).*/\1>/' | uniq > nn.@ 
echo "finding nn.#'s..."
cat nb-nn.inconsistency | grep '#' |sed 's/<n></<n_/g'| ssed 's/.*#\([^>]*\).*/\1>/' | uniq > nn.# 
echo "finding nn.bislash (bidix /'s)..."
cat nb-nn.inconsistency | grep    ' --------->.*\/.*--------->' | grep '\/' |sed 's/<n></<n_/g'| ssed 's/.*#\([^>]*\).*\/\([^>]*\).*/\1> \2>/' | uniq > nn.bislash
echo "finding nn.slash (generation /'s)..."
cat nb-nn.inconsistency | grep -v ' --------->.*\/.*--------->' | grep '\/' |sed 's/<n></<n_/g'| ssed 's/..*\^\([^>]*\).*/\1>/' | uniq > nn.slash

echo "stats for wiki:"
echo '|  Nynorsk' && wc -l nn.# nn.@ nn.bislash nn.slash | awk '!/total/ {print "| ", $1}' && echo '|
|-
|  Bokmål' &&  wc -l nb.# nb.@ nb.bislash nb.slash | awk '!/total/ {print "| ", $1}'
echo ""
