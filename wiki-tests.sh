#!/bin/bash

TESTTYPE="$1_tests"
SRCLANG=$2
TRGLANG=$3

# Mac mktemp has no default template, this works on both
SRCLIST=`mktemp -t tmp.XXXXXXXXXX`;
TRGLIST=`mktemp -t tmp.XXXXXXXXXX`;
TSTLIST=`mktemp -t tmp.XXXXXXXXXX`;

basedir=`pwd`;
mode="$SRCLANG-$TRGLANG"

wget -O - -q http://wiki.apertium.org/wiki/Norwegian_Nynorsk_and_Norwegian_Bokmål/$TESTTYPE | grep "<li> ($SRCLANG)" | sed 's/<.*li>//g' | sed 's/ /_/g' | cut -f2 -d')' | sed 's/<i>//g' | sed 's/<\/i>//g' | cut -f2 -d'*' | sed 's/→/!/g' | cut -f1 -d'!' | sed 's/(note:/!/g' | sed 's/_/ /g' | sed 's/$/./g' > $SRCLIST;
wget -O - -q http://wiki.apertium.org/wiki/Norwegian_Nynorsk_and_Norwegian_Bokmål/$TESTTYPE | grep "<li> ($SRCLANG)" | sed 's/<.*li>//g' | sed 's/ /_/g' | sed 's/(\w\w)//g' | sed 's/<i>//g' | cut -f2 -d'*' | sed 's/<\/i>_→/!/g' | cut -f2 -d'!' | sed 's/_/ /g' | sed 's/^ *//g' | sed 's/ *$//g' | sed 's/$/./g' > $TRGLIST;

apertium -d . $mode < $SRCLIST > $TSTLIST;

cat $SRCLIST | sed 's/\.$//g' > $SRCLIST.n; mv $SRCLIST.n $SRCLIST;
cat $TRGLIST | sed 's/\.$//g' > $TRGLIST.n; mv $TRGLIST.n $TRGLIST;
# 2nd sed removes tab characters, Mac sed doesn't recognize \t
cat $TSTLIST | sed 's/\.$//g' | sed 's/	/ /g' > $TSTLIST.n; mv $TSTLIST.n $TSTLIST;

TOTAL=0
CORRECT=0
# sed with tab again
for LINE in `paste $SRCLIST $TRGLIST $TSTLIST | sed 's/ /%_%/g' | sed 's/	/!/g'`; do
#	echo $LINE;

	SRC=`echo $LINE | sed 's/%_%/ /g' | cut -f1 -d'!' | sed 's/^ *//g' | sed 's/ *$//g' | sed 's/  / /g'`;
	TRG=`echo $LINE | sed 's/%_%/ /g' | cut -f2 -d'!' | sed 's/^ *//g' | sed 's/ *$//g' | sed 's/  / /g'`;
	TST=`echo $LINE | sed 's/%_%/ /g' | cut -f3 -d'!' | sed 's/^ *//g' | sed 's/ *$//g' | sed 's/  / /g'`;

	
	echo $TRG | grep "^$TST$" > /dev/null;	
	if [ $? -eq 1 ]; then
		echo -e $mode"\t  "$SRC"\n\t- $TRG\n\t+ "$TST"\n";
	else
		echo -e $mode"\t  "$SRC"\nWORKS\t  $TST\n";
		CORRECT=`expr $CORRECT + 1`;
	fi
	TOTAL=`expr $TOTAL + 1`;
done

echo $CORRECT" / "$TOTAL ;
if [ -x /usr/bin/calc ]; then
	WORKING=`calc $CORRECT" / "$TOTAL" * 100" | head -c 7`;

	echo $WORKING"%";
fi

rm $SRCLIST $TRGLIST $TSTLIST;
