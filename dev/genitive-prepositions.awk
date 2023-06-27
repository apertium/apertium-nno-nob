#!/bin/gawk -f

BEGIN{
    OFS=FS=" "

    # s: nno head:obj pairs that appeared in the genitive in nob corpus
    # (these have been sent through bidix)
    while(getline<nob2nnosgenf) { s[$1][$2]++ }

    # ns: nno head:obj pairs that appeared in the genitive in nno corpus
    while(getline<nnosgenf){ ns[$1][$2]++; umax_s[$1]++; omax_s[$2]++; }

    PROCINFO["sorted_in"]="@val_num_desc"

    min_nob_s_gen_freq = 1    # minimum head+obj    freq in nob2nno.sgen required for making prep rules
    min_nno_pr_freq = 1       # minimum head+pr+obj freq in nno.prep3g   required for making prep rules
    min_freq_bi_keep_sgen = 2 # minimum head+obj    freq in nno.sgen     required for making keep-s-gen rules
}

# input is tab-separated
# 1:obj	2:prep	3:head
{
    obj  = $1
    pr   = $2
    head = $3
}
head in s && obj in s[head]{
    bi[head][pr][obj]++  # bigram frequency of head + preposition + object
    uni[head][pr]++      # unigram frequency of head with this preposition
    unio[obj][pr]++      # unigram frequency of object with this preposition
    biAllPr[head][obj]++ # bigram frequency of head + object over all prepositions
    # print ":"$0
}

END{

    for(obj in unio)
        for(pr in unio[obj])
            if(omax[obj] < unio[obj][pr]) {
                omax[obj] = unio[obj][pr] # highest unigram frequency of this object for some preposition
                omaxpr[obj] = pr          # preposition that has the highest frequency for this object (argmax)
            }

    for(head in uni)
        for(pr in uni[head])
            if(umax[head] < uni[head][pr]) {
                umax[head] = uni[head][pr]
                umaxpr[head] = pr
            }

    for(head in bi)
        for(pr in bi[head])
            for(obj in bi[head][pr])
                if(bimax[head,obj] < bi[head][pr][obj]) {
                    bimax[head,obj] = bi[head][pr][obj]
                    bimaxpr[head,obj] = pr
                }

    for(head in bi) for(pr in bi[head]) if(pr != "til<pr>") {
                prs=pr; sub(/<.*/,"",prs)
                heads=head; sub(/<.*/,"",heads)
                for(obj in bi[head][pr]) {
                    nob_s_gen_freq = s[head][obj] >= min_nob_s_gen_freq
                    nno_pr_freq = bi[head][pr][obj] >= min_nno_pr_freq
                    nno_bi_gt_til = bi[head][pr][obj] > (bi[head]["til<pr>"][obj]+0)
                    nno_umax_gt_til = umax[head] > uni[head]["til<pr>"]        && umaxpr[head]      == pr
                    nno_bi_is_max = bimax[head,obj] > bi[head]["til<pr>"][obj] && bimaxpr[head,obj] == pr
                    nno_obj_is_max = omax[obj] > unio[obj]["til<pr>"]          && omaxpr[obj]       == pr && omax[obj] > uni[head]["til<pr>"]
                    if(nob_s_gen_freq && nno_bi_gt_til && nno_pr_freq) {
                        if(nno_umax_gt_til)
                            unilist[pr][head]++
                        else {
                            # No point in bigram entry if this prep is selected by head unigram anyway
                            # (But we do want bigram entry if it's just selected by obj,
                            #  obj-lists can't override head unigrams, but bigrams can)
                            if(nno_obj_is_max)
                                olist[pr][obj]++
                            objs=obj; sub(/<.*/,"",objs)
                            if(nno_bi_is_max)
                                bilist[pr][objs"_"heads]++
                        }
                    }
                }
            }

    PROCINFO["sorted_in"]="@ind_str_asc"
    print "\n<!-- s-genitives found in TL corpus where bi-frequency lt top prepositional: -->"
    print "\n<def-list n=\"bi-keep-gen-s\" c=\"Keep the s-genitive construction for these bigrams. Target-language lemmas.\">"
    for(head in ns) {
        hs=head;sub(/<.*/,"",hs)
        # if(umax_s[head] > umax[head] && umax_s[head] > 2)
                # print hs "\t________\t" umax_s[head]
        for(obj in ns[head]) {
            os=obj;sub(/<.*/,"",os)
            # if(omax_s[obj] > omax[obj] && omax_s[obj] > 2)
                # print "________\t" obj "\t" omax_s[obj]
            if(hs && os && ns[head][obj] > biAllPr[head][obj] && ns[head][obj] >= min_freq_bi_keep_sgen && head in s && obj in s[head]) {
                print "\t<list-item v=\""hs"_"os"\"/>\t<!-- ns["head"]["obj"] "ns[head][obj]" > biAllPr " biAllPr[head][obj] " -->"
                # print hs "\t" os "\t" ns[head][obj]
            }
        }
    }
    print "</def-list>"

    PROCINFO["sorted_in"]="@ind_str_asc"
    print "\n<!-- Genitive preps where bigram frequency gt til -->"
    for(pr in bilist) {
        prs=pr; sub(/<.*/,"",prs)
        print "\n<def-list n=\"bi-gen-"prs"\">"
        for(head in bilist[pr]) {
            sub(/<.*/,"",head)
            print "\t<list-item v=\""head"\"/>"
        }
        print "</def-list>"
    }
    print "\n<!-- Genitive preps where unigram frequency of *object* gt til -->"
    for(pr in olist) {
        prs=pr; sub(/<.*/,"",prs)
        print "\n<def-list n=\"obj-gen-"prs"\">"
        for(obj in olist[pr]) {
            sub(/<.*/,"",obj)
            print "\t<list-item v=\""obj"\"/>"
        }
        print "</def-list>"
    }
    print "\n<!-- Genitive preps where unigram frequency gt til -->"
    for(pr in unilist) {
        prs=pr; sub(/<.*/,"",prs)
        print "\n<def-list n=\"gen-"prs"\">"
        for(head in unilist[pr]) {
            sub(/<.*/,"",head)
            print "\t<list-item v=\""head"\"/>"
        }
        print "</def-list>"
    }

    print "\n<!-- put in t1x out_gen-prep macro choose: -->"
    for(pr in unilist) {
        prs=pr; sub(/<.*/,"",prs)
        printf "          <when><test><in><var n=\"lemma\"/><list n=\"gen-%s\"/></in></test><let><var n=\"gen-prep\"/><lit v=\"%s\"/></let></when>\n", prs, prs
    }

    print "\n<!-- put in t1x bigram_genprep macro choose: -->"
    for(pr in bilist) {
        prs=pr; sub(/<.*/,"",prs)
        printf "        <when><test><in><var n=\"bilem\"/><list n=\"bi-gen-%s\"/></in></test><append n=\"ntags\"><lit-tag v=\"pr_%s\"/></append></when>\n", prs, prs
    }
    print "        <otherwise>\n          <choose><when c=\"Only use obj unigram if both out_gen-prep and bi-gen didn't pick something first\">\n            <test><equal><var n=\"gen-prep\"/><lit v=\"til\"/></equal></test>\n            <choose>"
    # Manual override lists first:
    print "              <when><test><in><var n=\"lemma\"/><list n=\"obj-gen-frå2\"/></in></test><append n=\"ntags\"><lit-tag v=\"pr_frå\"/></append></when>"
    print "              <when><test><in><var n=\"lemma\"/><list n=\"obj-gen-med2\"/></in></test><append n=\"ntags\"><lit-tag v=\"pr_med\"/></append></when>"
    print "              <when><test><in><var n=\"lemma\"/><list n=\"obj-gen-av2\"/></in></test><append n=\"ntags\"><lit-tag v=\"pr_av\"/></append></when>"
    print "              <when><test><in><var n=\"lemma\"/><list n=\"obj-gen-på2\"/></in></test><append n=\"ntags\"><lit-tag v=\"pr_på\"/></append></when>"
    for(pr in olist) {
        prs=pr; sub(/<.*/,"",prs)
        printf "              <when><test><in><var n=\"lemma\"/><list n=\"obj-gen-%s\"/></in></test><append n=\"ntags\"><lit-tag v=\"pr_%s\"/></append></when>\n", prs, prs
    }
    print "            </choose>\n          </when></choose>\n        </otherwise>"

    print "\n<!-- put in t2x out_bi-gen-prep macro choose: -->"
    for(pr in bilist) {
        prs=pr; sub(/<.*/,"",prs)
        printf "        <when><test><equal><var n=\"genpr\"/><lit-tag v=\"pr_%s\"/></equal></test><let><var n=\"pr_lemh\"/><lit v=\"%s\"/></let></when>\n", prs, prs
    }
}
