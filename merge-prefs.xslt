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
      <xsl:comment><xsl:value-of select="$with-file"/>: </xsl:comment>
      <xsl:value-of select="$LineBreak"/><xsl:text>  </xsl:text>
      <xsl:apply-templates select="document($with-file)/preferences/preference"/>
      <xsl:value-of select="$LineBreak"/>

      <xsl:value-of select="$LineBreak"/>
      <xsl:value-of select="$LineBreak"/>

      <incompatibilities>
        <xsl:value-of select="$LineBreak"/><xsl:text>    </xsl:text>
        <xsl:apply-templates select="incompatibilities/incompat"/>
        <xsl:value-of select="$LineBreak"/><xsl:text>    </xsl:text>
        <xsl:comment><xsl:value-of select="$with-file"/>: </xsl:comment>
        <xsl:apply-templates select="document($with-file)/preferences/incompatibilities/node()"/>
        <xsl:value-of select="$LineBreak"/>
      </incompatibilities>

      <xsl:value-of select="$LineBreak"/>
      <xsl:value-of select="$LineBreak"/>

      <templates>
        <xsl:value-of select="$LineBreak"/><xsl:text>    </xsl:text>
        <xsl:apply-templates select="templates/template" mode="OrigPlusWith"/>
        <xsl:value-of select="$LineBreak"/>
        <xsl:value-of select="$LineBreak"/><xsl:text>    </xsl:text>

        <xsl:comment>Only in <xsl:value-of select="$with-file"/>: </xsl:comment>
        <xsl:apply-templates select="document($with-file)/preferences/templates/template" mode="NotInOrig">
          <xsl:with-param name="TemplatesInOrig" select="templates/template"/>
        </xsl:apply-templates>
        <xsl:value-of select="$LineBreak"/>
        <xsl:value-of select="$LineBreak"/>
      </templates>

      <xsl:value-of select="$LineBreak"/>
      <xsl:value-of select="$LineBreak"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="template" mode="OrigPlusWith">
    <!-- Merge in any templates in with-file that have the same name as this template -->
    <xsl:variable name="thisName"><xsl:value-of select="./@name"/></xsl:variable>
      <xsl:value-of select="$LineBreak"/><xsl:text>    </xsl:text>
      <xsl:copy>
        <xsl:copy-of select="@*"/>              <!-- copy the attributes -->
        <xsl:apply-templates select="node()" /> <!-- copy our children -->
        <xsl:if test="count(document($with-file)/preferences/templates/template[@name=$thisName]) &gt; 0">
          <xsl:text>  </xsl:text>               <!-- copy children of other file -->
          <xsl:comment><xsl:value-of select="$with-file"/>: </xsl:comment>
          <xsl:apply-templates select="document($with-file)/preferences/templates/template[@name=$thisName]/node()"/>
        </xsl:if>
      </xsl:copy>
  </xsl:template>

  <xsl:template match="template" mode="NotInOrig">
    <!-- Only output template from with-file if not in orig-file -->
    <xsl:param name="TemplatesInOrig"/>
    <xsl:variable name="thisName"><xsl:value-of select="./@name"/></xsl:variable>
    <xsl:if test="count($TemplatesInOrig[@name=$thisName]) = 0">
      <xsl:value-of select="$LineBreak"/><xsl:text>    </xsl:text>
      <xsl:apply-templates select="."/>
    </xsl:if>
  </xsl:template>

  <!-- identity transform on anything not matched by the above: -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
