<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY % common.entities SYSTEM "entities.ent">
%common.entities;
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 xmlns:xhtml="http://www.w3.org/1999/xhtml"
                 xmlns:db="http://docbook.org/ns"
                 xmlns:xi="http://www.w3.org/2001/XInclude"
                 xmlns:xlink="http://www.w3.org/1999/xlink"
                 xmlns:exsl="http://exslt.org/common"
                 version="1.0"
                 exclude-result-prefixes="xhtml db xi xlink exsl">

  <xsl:import href="/usr/share/sgml/docbook/xsl-stylesheets/html/chunk.xsl"/>
  <xsl:include href="param.xsl"/>
  <xsl:include href="layout.xsl"/>
  <xsl:include href="glossary.xsl"/>
  <xsl:include href="titlepage.xsl"/>
  <xsl:include href="inline.xsl"/>


  <!-- ==================================================================== -->
  <xsl:param name="local.l10n.xml" select="document('')"/>
  <l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
    <l:l10n language="en">
      <l:context name="title">
        <l:template name="table" text="%t"/>
        <l:template name="figure" text="%t"/>
      </l:context>
      <l:context name="xref-number-and-title">
        <l:template name="table" text="the table titled &#8220;%t&#8221;"/>
      </l:context>
    </l:l10n>
  </l:i18n>

  <!-- ==================================================================== -->
  <xsl:template match="table" mode="label.markup"/>

</xsl:stylesheet>
