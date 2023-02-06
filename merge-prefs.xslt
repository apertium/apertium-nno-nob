<?xml version="1.0" encoding="UTF-8"?> <!-- -*- nxml -*- -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="UTF-8"/>

  <xsl:param name="with-file"/>     <!-- the file to merge with -->

  <xsl:variable name="LineBreak"><xsl:text>&#10;</xsl:text></xsl:variable>

  <xsl:template match="/preferences">
    <xsl:copy>

      <xsl:value-of select="$LineBreak"/><xsl:text>  </xsl:text>
      <xsl:apply-templates select="preference"/>
      <xsl:value-of select="$LineBreak"/>
      <xsl:comment> <xsl:value-of select="$with-file"/>: </xsl:comment>
      <xsl:value-of select="$LineBreak"/><xsl:text>  </xsl:text>
      <xsl:apply-templates select="document($with-file)/preferences/preference"/>
      <xsl:value-of select="$LineBreak"/>

      <xsl:value-of select="$LineBreak"/>

      <incompatibilities>
      <xsl:value-of select="$LineBreak"/><xsl:text>    </xsl:text>
      <xsl:apply-templates select="incompatibilities/incompat"/>
      <xsl:value-of select="$LineBreak"/>
      <xsl:comment><xsl:value-of select="$with-file"/>: </xsl:comment>
      <xsl:value-of select="$LineBreak"/><xsl:text>    </xsl:text>
      <xsl:apply-templates select="document($with-file)/preferences/incompatibilities/incompat"/>
      <xsl:value-of select="$LineBreak"/>
      </incompatibilities>

      <xsl:value-of select="$LineBreak"/>
    </xsl:copy>
  </xsl:template>

  <!-- identity transform on anything not matched by the above: -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
