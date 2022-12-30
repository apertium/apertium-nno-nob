#!/usr/bin/gawk -f

BEGIN {
    # nrestrict="<sg><ind>" # only dictionary forms
    # vrestrict="<inf>"     # only dictionary forms
    nrestrict=""          # try all forms
    vrestrict=""          # try all forms
    vprestrict=""         # try all forms
    asrestrict=""         # try all forms
    anrestrict=""         # try all forms
    avrestrict=""         # try all forms
    FS="/"
    langs["nno"]++
    langs["nob"]++
    for(lang in langs) {        # initialize so awk doesn't type-fail
        ana[lang]["m"][""]++; delete ana[lang]["m"][""]
        ana[lang]["f"][""]++; delete ana[lang]["f"][""]
        ana[lang]["nt"][""]++; delete ana[lang]["nt"][""]
        ana[lang]["v"][""]++; delete ana[lang]["v"][""]
        ana[lang]["as"][""]++; delete ana[lang]["as"][""]
        ana[lang]["an"][""]++; delete ana[lang]["an"][""]
        ana[lang]["av"][""]++; delete ana[lang]["av"][""]
    }
    for(lang in langs)while(getline<(tmpd"/"lang)){
      gsub(/[$^]/,"")
      for(a=2;a<=NF;a++){
             if($a~$1"<n><m>"nrestrict)       ana[lang]["m"][$1]++;
        else if($a~$1"<n><f>"nrestrict)       ana[lang]["f"][$1]++;
        else if($a~$1"<n><nt>"nrestrict)      ana[lang]["nt"][$1]++;
        else if($a~$1"<vblex>"vrestrict)      ana[lang]["v"][$1]++
        else if($a~$1"<adj><pp>"vprestrict)   ana[lang]["v"][$1]++
        else if($a~$1"<adj><sint>"asrestrict) ana[lang]["as"][$1]++
        else if($a~$1"<adj>"anrestrict)       ana[lang]["an"][$1]++
        else if($a~$1"<adv>"avrestrict)       ana[lang]["av"][$1]++
      }
    }

    FS=":"
    while(getline<(tmpd"/bi")){ bi[$1][$2]++ }
    while(getline<(tmpd"/nno-known")){ nknown[$1]++ }
    while(getline<(tmpd"/nob-known")){ bknown[$1]++ }

    for(ng in ana["nno"]) {
     for(nw in ana["nno"][ng]) {
      if(nw in bi)for(bw in bi[nw]) {
       biseen[nw][bw]++
       if(bw in bknown && nw in nknown) {
           print "<apertium-notrans>Both sides in, check that this gives the right translation:</apertium-notrans>"bw"<apertium-notrans>"nw":"bw"</apertium-notrans>"
           continue
       }
       else if(bw in bknown) {
           print "<apertium-notrans>Only nob-side in, check that this gives the right translation:</apertium-notrans>"bw"<apertium-notrans>"nw":"bw"</apertium-notrans>"
       }
       if(ng=="f" &&nw in ana["nno"]["m"]) print "nno-side dupe!"
       if(ng=="f" &&nw in ana["nno"]["nt"]) print "nno-side dupe!"
       if(ng=="m" &&nw in ana["nno"]["nt"]) print "nno-side dupe!"
       nW=nw;gsub(/ /,"<b/>",nW)
       bW=bw;gsub(/ /,"<b/>",bW)
       if(ng=="v" && bw in ana["nob"]["v"])        print "<e>       <p><l>"nW"</l><r>"bW"</r></p><par n=\"vblex_adj\"/></e>"
       else if(ng=="as" && bw in ana["nob"]["as"]) print "<e>       <p><l>"nW"</l><r>"bW"</r></p><par n=\"adj_sint\"/></e>"
       else if(ng=="an" && bw in ana["nob"]["as"]) print "<e>       <p><l>"nW"</l><r>"bW"</r></p><par n=\"adj:adj_sint\"/></e>"
       else if(ng=="as" && bw in ana["nob"]["an"]) print "<e>       <p><l>"nW"</l><r>"bW"</r></p><par n=\"adj_sint:adj\"/></e>"
       else if(ng=="an" && bw in ana["nob"]["an"]) print "<e>       <p><l>"nW"</l><r>"bW"</r></p><par n=\"adj\"/></e>"
       else if(ng=="av" && bw in ana["nob"]["av"]) print "<e>       <p><l>"nW"<s n=\"adv\"/></l><r>"bW"<s n=\"adv\"/></r></p></e>"
       else {
            if(bw in ana["nob"]["f"])              print "<e>       <p><l>"nW"<s n=\"n\"/><s n=\""ng"\"/></l><r>"bW"</r></p><par n=\":n_m_RL_f\"/></e>"
            else if(bw in ana["nob"]["m"])         print "<e>       <p><l>"nW"<s n=\"n\"/><s n=\""ng"\"/></l><r>"bW"<s n=\"n\"/><s n=\"m\"/></r></p></e>"
            if(bw in ana["nob"]["nt"])             print "<e>       <p><l>"nW"<s n=\"n\"/><s n=\""ng"\"/></l><r>"bW"<s n=\"n\"/><s n=\"nt\"/></r></p></e>"
            else if(!(bw in ana["nob"]["f"] || bw in ana["nob"]["m"])) {
                # all the print <e> above failed:
                bgg=""; for(bg in ana["nob"])if(bw in ana["nob"][bg])bgg=bgg"]["bg; sub(/^\]\[/,"",bgg)
                if(!bgg) {
                    print "Only found in nno: "nw"["ng"], nob: "bw
                }
                else {
                    print "Only mismatching PoS found: "nw"["ng"] vs "bw"["bgg"]"
                }
            }
       }
      }
     }
    }
    for(nw in bi) {
        for(bw in bi[nw]){
            if(!(nw in biseen && bw in biseen[nw])) {
                print "No analysis for: "nw":"bw
            }
        }
    }
}
