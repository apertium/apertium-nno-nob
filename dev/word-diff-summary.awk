#!/usr/bin/awk -f

# Expects one argument: path to word-diff file to use for output
# sentences; and stdin should be the context-less word-diff

/^@@/{ range=$2".."$3; next }
/^==/{ next }
range {
    sub(/^[\t ]*/, "")
    difs[$0][range]++
    ndifs[$0]++
}

END{
    while(getline < wdiff) {
        if(/^@@/){ range=$2".."$3 }
        else if(range){ wdifs[range][$0]++ }
    }
    # Sort by number of examples per dif, start with most examples:
    PROCINFO["sorted_in"]="@val_num_desc"
    for(d in ndifs) {
        if(d ~ /^[0-9 [:punct:]]*$/) { continue } # skip noise
        print "* " d;
        print ""
        for(range in difs[d]) {
            # print range;
            for(sent in wdifs[range]) {
                print " " sent
            }
        }
        print ""
    }
}
