#!/usr/bin/env python3

from streamparser import parse_file, readingToString, known
import sys

def stash(wf, r):
    return "[<apertium-notrans>{}\/{}<\/apertium-notrans>]".format(lu.wordform,
                                                                   readingToString(r))

for blank, lu in parse_file(sys.stdin, withText=True):
    if lu.knownness == known and len(lu.readings)>1:
        print(" ".join("{}^{}/{}$ ^./.<sent><clb>$".format(stash(lu.wordform, r),
                                                           lu.wordform,
                                                           readingToString(r))
                       for r in lu.readings
                       # Skip compounds:
                       if len(r) == 1),
              end="\n")
