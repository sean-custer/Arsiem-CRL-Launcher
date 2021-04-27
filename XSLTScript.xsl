<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" omit_xml_declaration="no"/>
  <xsl:strip-space elements="*"/>

  <!-- INITIALIZE PARAMETER -->
  <xsl:param name="new_ip" /> 

  <!-- IDENTITY TRANSFORM -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- REWRITE TITLE TEXT -->
  <xsl:template match="param[@name='hostname']">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <xsl:value-of select="$new_ip"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
