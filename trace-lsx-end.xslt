<?xml version="1.0" encoding="UTF-8"?> <!-- -*- nxml -*- -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="UTF-8"/>

  <xsl:template match="section">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="./e" mode="Trace"/>
    </xsl:copy>
  </xsl:template>

  <!-- Mark the end of rules with END since lsx-comp -d only marks the beginning: -->
  <xsl:template match="e" mode="Trace">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="node()"/>
      <p><l></l><r>END</r></p>
    </xsl:copy>
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
