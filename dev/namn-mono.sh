#!/bin/bash


lang=$1
tag=$2

case "${tag}" in
    cog)   p="Aasen__np";     ps="Kjos__np"     ;;
    ant|f) p="Eva__np";       ps="Doris__np"    ;;
    m)     p="Jo__np";        ps="Jens__np"     ;;
    org)   p="Wikipedia__np"; ps="Findus__np"   ;;
    top)   p="Noreg__np";     ps="Ås__np"       ;;
    al)    p="d'or__np";      ps="d'autres__np" ;;
    *) cat >&2 <<EOF
Please supply source language and main np tag as args, e.g.

    $0 nno cog < last-names-one-per-line.txt

or

    $0 nob ant < first-names-one-per-line.txt
    $0 nno top < place-names-one-per-line.txt
    $0 nno m   < masc-names-one-per-line.txt
    $0 nob org < org-names-one-per-line.txt

Assumes: apertium-nno is available in ../apertium-nno
and that apertium-nob is available in ../apertium-nob
EOF
       exit 1
       ;;
esac

go () {
    dir="$1"
    mode="$2"
    tr -d '\\/$[]{}'                                                                         \
        | sed 's/.*/[&]&/'                                                                   \
        | apertium -f none -d "${dir}" "${mode}"                                             \
        | grep -v "^\[\(.*\)].*/\1<np>[^/$]*<${tag}>"                                        \
        | sed 's/].*//;s/\[//'                                                               \
        | awk -v p="$p" -v ps="$ps"                                                          \
              '{pn=p}
           /[szx]$/{pn=ps}
           {i=$0;gsub(/ /,"<b/>",i);print "<e lm=\""$0"\"><i>"i"</i><par n=\""pn"\"/></e>"}' \
               | sort -u                                                                     \
               || true
}

pdir=$(basename "$(dirname "$0")")/../..

case "${lang}" in
     nob) go "${pdir}"/apertium-nob nob-morph ;;
     nno) go "${pdir}"/apertium-nno nno-morph ;;
     *) echo "Expecting arg1 (monodix language code) to be one of 'nno' and 'nob'" >&2
        exit 1
        ;;
esac
