#!/bin/bash

### Expects pair as argument 1, corpus on stdin

### Expects input looking like:
#sme	Hui hárve boahtá ovdan oahppoplánabarggus maid sii gáibidit skuvllas
#nob	Svært sjelden kommer det fram i læreplanarbeidet hva de krever av skolen
#
#sme	…
#nob	…
#

### Will work just fine with monolingual text as well, for example
### sed 's/^/sme\t/' corpus.txt | dev/analyse-all-stages.sh dan-nno


### Grab some corpora and turn into tsv:
# wget http://opus.lingfil.uu.se/OpenSubtitles2011/da-no.tmx.gz
# zcat da-no.tmx.gz | grep '<tuv xml:lang=' | sed 's/^ *<tuv xml:lang="//'|sed $'s/"><seg> */\t/'|sed 's%</seg></tuv>$%%'|sed 's/^da/\ndan/;s/^n[ob]/nob/;s/^nn/nno/' > dan-nob.tsv
# wget http://opus.lingfil.uu.se/GNOME/da-nn.tmx.gz
# zcat da-nn.tmx.gz | grep '<tuv xml:lang=' | sed 's/^ *<tuv xml:lang="//'|sed $'s/"><seg> */\t/'|sed 's%</seg></tuv>$%%'|sed 's/^da/\ndan/;s/^n[ob]/nob/;s/^nn/nno/' > dan-nno.tsv


set -e -u

PAIR=${1}
FROMLANG=${1%-*}
UNTOLANG=${1#*-}

unwrap-for () {
    name=$1
    sed "s%<apertium-notrans>${FROMLANG}\t\(.*\)</apertium-notrans>%<apertium-notrans>${name}</apertium-notrans>\t\1\n&%"
}
wrap () {
    name=$1
    sed "s%\(<apertium-notrans>${name}\)\(</apertium-notrans>\)\(.*\)%\1\3\2%"
}

tr '[]#@' '()%!' |
sed 's%^...\t.*%<apertium-notrans>&</apertium-notrans>%'  |
    unwrap-for MORPH |
    apertium -f html-noent -d . ${PAIR}-morph |
    wrap MORPH | unwrap-for TAGGER |
    apertium -f html-noent -d . ${PAIR}-tagger |
    wrap TAGGER | unwrap-for BIL |
    apertium -f html-noent -d . ${PAIR}-biltrans |
    wrap BIL | unwrap-for DGEN |
    apertium -d . -f html-noent ${PAIR}-dgen |
    sed 's%</*apertium-notrans>%%g'
