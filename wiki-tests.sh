#!/bin/bash
# -*- bidi-display-reordering: nil -*-

URLBASE=http://wiki.apertium.org/wiki/Norwegian_Nynorsk_and_Norwegian_Bokmål

TESTTYPE="$1_tests"
SRCLANG="$2"
TRGLANG="$3"
mode="$SRCLANG-$TRGLANG"
HTML=".deps/$TESTTYPE.html"

if [ "$#" -lt 3 ]; then echo "Usage: wiki-tests.sh {Regression,Pending} SRCLANG TRGLANG [update]"; exit 1; fi

printf "Running $1-tests with mode \"$mode\""
if [ "$4" == "update" ]; then
    printf " with updated tests..."
    TMPHTML=`mktemp -t tmp.$SRCLANG-html.XXXXXXXXXX`;
    wget -O $TMPHTML -q "$URLBASE/$TESTTYPE"
    if [[ -s $TMPHTML ]]; then mv $TMPHTML $HTML;
    else rm $TMPHTML; echo "Couldn't fetch $URLBASE/$TESTTYPE"; fi
fi
echo "..."

if [[ ! -s $HTML ]]; then echo "$HTML does not exist or is empty (use 'update' option)"; exit 1; fi


# Mac mktemp has no default template, this works on both
SRCLIST=`mktemp -t tmp.$SRCLANG-src.XXXXXXXXXX`;
TRGLIST=`mktemp -t tmp.$SRCLANG-trg.XXXXXXXXXX`;
TSTLIST=`mktemp -t tmp.$SRCLANG-tst.XXXXXXXXXX`;

ECHOE="echo -e"
SED=sed
if test x$(uname -s) = xDarwin; then
	ECHOE="builtin echo"
	SED=gsed
fi

cleansrc () {
    grep "<li> ($SRCLANG)" | $SED 's/<.*li>//g' | $SED 's/ /_/g' | cut -f2- -d')' | $SED 's/<i>//g' | $SED 's/<\/i>//g' | cut -f2 -d'*' | $SED 's/→/!/g' | cut -f1 -d'!' | $SED 's/(note:/!/g' | $SED 's/_/ /g' | $SED 's/^ *//g' | $SED 's/ *$//g' | $SED 's/\([^,.?!:;؟]\)$/\1./g'
}
cleantrg () {
    grep "<li> ($SRCLANG)" | $SED 's/<.*li>//g' | $SED 's/ /_/g' | $SED 's/(\w\w)//g' | $SED 's/<i>//g' | cut -f2 -d'*' | $SED 's/<\/i>_→/!/g' | cut -f2 -d'!' | $SED 's/_/ /g' | $SED 's/^ *//g' | $SED 's/ *$//g' | $SED 's/\([^,.?!:;؟]\)$/\1./g'
}
cleansrc < "$HTML" > "$SRCLIST"
cleantrg < "$HTML" > "$TRGLIST"


# Translate
apertium -d . $mode < $SRCLIST > $TSTLIST;

# Output the MT vs ref translations:
TOTAL=0
CORRECT=0
for LINE in `paste $SRCLIST $TRGLIST $TSTLIST | $SED 's/ /%_%/g' | $SED 's/\t/!/g'`; do
	SRC=`echo $LINE | $SED 's/%_%/ /g' | cut -f1 -d'!' | $SED 's/^ *//g' | $SED 's/ *$//g' | $SED 's/   */ /g'`;
	TRG=`echo $LINE | $SED 's/%_%/ /g' | cut -f2 -d'!' | $SED 's/^ *//g' | $SED 's/ *$//g' | $SED 's/   */ /g'`;
	TST=`echo $LINE | $SED 's/%_%/ /g' | cut -f3 -d'!' | $SED 's/^ *//g' | $SED 's/ *$//g' | $SED 's/   */ /g'`;

	if [ "$LINE" = "!!" ]; then
		continue;
	fi
	echo $TRG | grep "^${TST}$" > /dev/null;
	if [ $? -eq 1 ]; then
		$ECHOE $mode"\t  ${SRC}\n\t- ${TRG}\n\t+ ${TST}\n\n";
	else
		$ECHOE $mode"\t  ${SRC}\nWORKS\t  ${TST}\n\n";
		CORRECT=`expr $CORRECT + 1`;
	fi
	TOTAL=`expr $TOTAL + 1`;
done


# Output the sums:
CALC=
WORKING=
if [ -x /usr/bin/calc ]; then
    CALC="/usr/bin/calc"
elif [ -x /opt/local/bin/calc ]; then
    CALC="/opt/local/bin/calc"
fi
if [ -n "$CALC" ]; then
	WORKING=`$CALC $CORRECT" / "$TOTAL" * 100" | head -c 7`;
	WORKING=", "$WORKING"%";
fi
echo $CORRECT" / "$TOTAL$WORKING;

rm -f $SRCLIST $TRGLIST $TSTLIST;
#echo $SRCLIST $TRGLIST $TSTLIST;
