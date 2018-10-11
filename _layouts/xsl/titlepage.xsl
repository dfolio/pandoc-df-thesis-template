<?xml version="1.0"?>
<!-- This file is generated from param.xweb -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                version="1.0">

  <!-- ==================================================================== -->
  <!-- titlepage-->
  <xsl:template name="book.titlepage">
    <div class="clearfix container-fluid thesis-titlepage">
      <xsl:variable name="recto.content">
        <xsl:call-template name="book.titlepage.before.recto"/>
        <xsl:call-template name="book.titlepage.recto"/>
      </xsl:variable>
      <xsl:variable name="recto.elements.count">
        <xsl:choose>
          <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
          <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
            <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
        <header class="thesis-header titlepage-recto"><xsl:copy-of select="$recto.content"/></header>
      </xsl:if>
      <xsl:variable name="verso.content">
        <xsl:call-template name="book.titlepage.before.verso"/>
        <xsl:call-template name="book.titlepage.verso"/>
      </xsl:variable>
      <xsl:variable name="verso.elements.count">
        <xsl:choose>
          <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
          <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
            <!--Xalan quirk--><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
        <header class="thesis-header titlepage-verso"><xsl:copy-of select="$verso.content"/></header>
      </xsl:if>
      <xsl:call-template name="book.titlepage.separator"/>
    </div>
  </xsl:template>
</xsl:stylesheet>
