#!/usr/bin/perl -w

# Script to postedit articles translated from
# Bokmål Wikipedia to Nynorsk Wikipedia.

# Usage (in the directory apertium-nn-nb/):
# cat nb-inputarticle | apertium -d . -u nb-nn | ./wikifix-nb-nn.pl | ...

use utf8 ;
print "\n{{språkvask}}\n\n" ;


while (<>) 
{
s/\[\[dei:/\[\[de:/g ; # iw german
s/\[\[ein:/\[\[en:/g ; # iw english
s/\[\[gav:/\[\[ga:/g ; # iw galician?
s/\[\[eit:/\[\[et:/g ; # iw estonian
s/\[\[då:/\[\[da:/g ;  # iw danish
s/\[\[nn:/\[\[nb:/g ;  # iw switch 
s/{{.*stubb}}/{{spire}}/g ; # 
s/\]\]ein /\]\]en /g ; # definite suffix -en
s/\]\]eine /\]\]ane /g ; # definite suffix -ene
s/\]\]eit /\]\]et /g ; # definite suffix -et

print ;
}

print "\n[[Kategori:Omsett med Apertium]]\n" ;
