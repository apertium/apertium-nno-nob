#!/usr/bin/perl -w

# Script to postedit articles translated from
# Bokmål Wikipedia to Nynorsk Wikipedia.

# Usage (in the directory apertium-nn-nb/):
# cat nb-inputarticle | apertium -d . -u nb-nn | ./wikifix-nb-nn.pl | ...

use utf8 ;

@months = qw(jan feb mars april mai juni juli aug sept okt nov des);
@weekDays = qw(søndag måndag tysdag onsdag torsdag fredag laurdag søndag);
($second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime();

$minute = sprintf("%2d", $minute);
$minute=~ tr/ /0/;

$hour = sprintf("%2d", $hour);
$hour=~ tr/ /0/;

$year = 1900 + $yearOffset;
$tidspunkt = "$weekDays[$dayOfWeek]  $dayOfMonth. $months[$month] $year, klokka $hour:$minute.\n\n";


print "\n{{språkvask}}\n\n" ;

while (<>) 
{
s/\[\[ase:/\[\[ast:/g ; # iw asturian
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

print "\n\n== Kjelde ==\n\n* Omsett frå [[:nb:Hovedside|Wikipedia på bokmål]] $tidspunkt \n\n" ;

print "\n[[Kategori:Omsett med Apertium]]\n" ;
