#!/bin/bash

case $1 in
    cog) p="Aasen__np"; ps="Kjos__np";;
    ant|f) p="Eva__np"; ps="Doris__np";;
    m) p="Jo__np"; ps="Jens__np";;
    org) p="Wikipedia__np"; ps="Findus__np";;
    top) p="Noreg__np"; ps="Ås__np";;
    *) cat <<EOF
Please supply main np tag as arg, e.g.

    $0 cog < last-names-one-per-line.txt

or

    $0 ant < first-names-one-per-line.txt
    $0 top < place-names-one-per-line.txt
    $0 m < masc-names-one-per-line.txt
    $0 org < org-names-one-per-line.txt
EOF
       exit 1;;
esac

sed 's/.*/[&]&/'                                                                             \
    | apertium -f none -d . nob-nno_e-morph                                                  \
    | grep -v ']\^[^^]*<np>[^^]*$'                                                           \
    | sed 's/].*//;s/\[//'                                                                   \
    | awk -v p="$p" -v ps="$ps"                                                              \
          '{pn=p}
           /[szx]$/{pn=ps}
           {i=$0;gsub(/ /,"<b/>",i);print "<e lm=\""$0"\"><i>"i"</i><par n=\""pn"\"/></e>"}' \
    | rev                                                                                    \
    | sort                                                                                   \
    | rev
