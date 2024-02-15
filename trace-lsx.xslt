<?xml version="1.0" encoding="UTF-8"?> <!-- -*- nxml -*- -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="UTF-8"/>

  <xsl:variable name="LineBreak"><xsl:text>&#10;</xsl:text></xsl:variable>

  <xsl:template match="section">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="./e" mode="Trace">
        <xsl:with-param name="TemplatesInOrig" select="templates/template"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="e" mode="Trace">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <!-- The attribute linenum is added by awk in Makefile.am, since
           xsltproc can't do line numbers (only position()) -->
      <p><l></l><r>{LINE:<xsl:value-of select="@linenum" /><d/></r></p>
      <xsl:apply-templates select="node()"/>
      <p><l></l><r><d/>END:<xsl:value-of select="@linenum" />}</r></p>
      <xsl:value-of select="$LineBreak"/>
    </xsl:copy>
    <xsl:value-of select="$LineBreak"/>
  </xsl:template>

  <!-- workaround for
       https://github.com/apertium/apertium-separable/issues/53
       (ensure all <e></e>'s have some space, so they don't turn into <e/>)
  -->
  <xsl:template match="e">
    <xsl:copy>
        <xsl:apply-templates select="node()|@*" />
        <xsl:text>  </xsl:text>
    </xsl:copy>
  </xsl:template>

  <!-- identity transform on anything not matched by the above: -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>


</xsl:stylesheet>
