#!/usr/bin/perl -w

while (<>) 
{
s/\[\[dei:/\[\[de:/g ;
s/\[\[ein:/\[\[en:/g ;
s/\[\[gav:/\[\[ga:/g ;
s/\[\[eit:/\[\[et:/g ;
s/\[\[då:/\[\[da:/g ;
s/{{spire}}/{{stubb}}/g ;
s/\]\]ein /\]\]en /g ;
s/\]\]eit /\]\]et /g ;

print ;
}
