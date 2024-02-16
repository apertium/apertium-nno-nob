#!/usr/bin/env -S awk -f

# This file creates an lsx file that merges law names into np's in
# certain fixed contexts. Maybe it could be made more general, but for
# now this is what we need.

BEGIN {
    print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
    print "<dictionary type=\"separable\">"
    print ""
    print "<!-- Generated automatically from "ARGV[1]" - DO NOT EDIT MANUALLY! -->"
    print ""
    print "  <alphabet></alphabet>"
    print "  <sdefs>"
    print "    <sdef n=\"np\"      c=\"Proper noun\"/>"
    print "    <sdef n=\"lpar\"    c=\"Left parenthesis\" />"
    print "    <sdef n=\"pr\"      c=\"Preposition\"/>"
    print "    <sdef n=\"@app\"/>"
    print "    <sdef n=\"aa\"/>"
    print "  </sdefs>"
    print ""
    print "  <pardefs>"
    print ""
    print "    <pardef n=\"reading\" c=\"match and keep readings (incl. tagless/unknown). Includes end delimiter\">"
    print "      <e>   <i>/<w/><d/></i>            </e>"
    print "      <e>   <i>/<w/><t/><d/></i>        </e>"
    print "    </pardef>"
    print ""
    print "    <pardef n=\"reading:\" c=\"match and drop readings (incl. tagless/unknown). Includes end delimiter\">"
    print "      <e><p><l>/<w/><d/></l>    <r/></p></e>"
    print "      <e><p><l>/<w/><t/><d/></l><r/></p></e>"
    print "    </pardef>"
    print ""
    print "    <pardef n=\"pr|lpar|jf\" c=\"includes end delimiter\">"
    print "      <e><i><w/>/<w/><s n=\"pr\"/><t/><d/></i></e>"
    print "      <e><i><w/>/<w/><s n=\"lpar\"/><t/><d/></i></e>"
    print "      <e><i>jf</i>      <par n=\"reading\"/></e>"
    print "      <e><i>jf.</i>     <par n=\"reading\"/></e>"
    print "      <e><i>jamføre</i> <par n=\"reading\"/></e>"
    print "    </pardef>"
    print ""
    print "  </pardefs>"
    print ""
    print "  <section id=\"main\" type=\"standard\">"
    print ""
}

{
    gsub(/^[[:space:]]+|[[:space:]]+$/, "") # trim whitespace from beginning/end
    print ""
    print "    <e>"
    print "      <par n=\"pr|lpar|jf\"/>"
    for(i=1;i<=NF;i++)
        printf "      <p><l>%s</l> <r></r></p> <par n=\"reading:\"/>\n",$i
    gsub(/ /, "<b/>")                       # use <b/> for blanks
    print "      <p><l></l> <r>"$0"/"$0"<s n=\"np\"/><s n=\"aa\"/><s n=\"@app\"/><d/></r></p>"
    print "    </e>"
}

END {
    print "  </section>"
    print "</dictionary>"
}
