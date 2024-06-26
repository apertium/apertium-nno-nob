#!/bin/bash

sed 's/.*/[&]&/'                                                                                           \
    | apertium -f none -d . nob-nno_e-morph                                                                \
    | grep -v '^\[\(.*\)].*/\1<np>'                                                                        \
    | sed 's/].*//;s/\[//'                                                                                 \
    | awk '{i=$0;gsub(/ /,"<b/>",i);print "<e><p><l>"i"<s n=\"np\"/></l><r>"i"<s n=\"np\"/></r></p></e>"}' \
    | rev                                                                                                  \
    | sort -u                                                                                              \
    | rev
