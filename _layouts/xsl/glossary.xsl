<?xml version='1.0'?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY % common.entities SYSTEM "entities.ent">
%common.entities;
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink='http://www.w3.org/1999/xlink'
                exclude-result-prefixes="xlink"
                version='1.0'>

<!-- ==================================================================== -->

<xsl:template match="glossentry/acronym">
  <xsl:apply-templates/>
  <xsl:if test="following-sibling::acronym|following-sibling::abbrev">, </xsl:if>
</xsl:template>

<!-- ==================================================================== -->
<xsl:template match="glossary/title">
  <h1 class="{name(.)}">
    <xsl:apply-templates/>
  </h1>
</xsl:template>

<xsl:template match="glossdiv/title">
  <h2 class="{name(.)}">
    <xsl:apply-templates/>
  </h2>
</xsl:template>

<!-- ==================================================================== -->


</xsl:stylesheet>
