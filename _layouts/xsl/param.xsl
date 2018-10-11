<?xml version="1.0"?>
<!-- This file is generated from param.xweb -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


  <xsl:param name="html.ext">.html</xsl:param>
  <xsl:output omit-xml-declaration="yes" method="html" encoding="utf-8" indent="no"  />

  <xsl:param name="chunker.output.encoding" select="'UTF-8'"/>
  <xsl:param name="chunker.output.indent" select="'no'"/>
  <xsl:param name="chunker.output.omit-xml-declaration" select="'yes'"/>
  <xsl:param name="chunker.output.standalone" select="'no'"/>
  <xsl:param name="chunker.output.doctype-public" select="''"/>
  <xsl:param name="chunker.output.doctype-system" select="''"/>
  <xsl:param name="chunker.output.media-type" select="''"/>
  <xsl:param name="chunker.output.cdata-section-elements" select="''"/>

  <xsl:param name="make.clean.html" select="1"/>
  <xsl:param name="generate.id.attributes" select="1"/>

  <xsl:param name="generate.legalnotice.link" select="1"/>
  <xsl:param name="generate.manifest" select="1"/>

  <xsl:param name="make.graphic.viewport" select="0"/>
  <xsl:param name="admon.graphics.extension">.svg</xsl:param>
  <xsl:param name="admon.graphics" select="1"/>
  <xsl:param name="admon.graphics.path">assets/fig/</xsl:param>
  <xsl:param name="html.stylesheet" select="'../assets/css/pandoc_thesis_docbook.css'"/>

  <xsl:param name="docbook.css.link" select="0"/>
<xsl:param name="docbook.css.source"></xsl:param>
  <xsl:param name="html.css">
  https://use.fontawesome.com/releases/v5.0.13/css/all.css sha384-DNOHZ68U8hZfKXOrtjWvjxusGo9WQnrNx2sqG0tfsghAvtVlRW3tvkXWZh58N9jp
  </xsl:param>
  <xsl:param name="html.css.fa" select="1" />

  <xsl:param name="img.src.path" select="'../'"/>

  <xsl:param name="chapter.autolabel" select="0"/>
  <xsl:param name="appendix.autolabel" select="0"/>
  <xsl:param name="section.autolabel" select="0"/>
  <xsl:param name="formal.title.placement">
  figure after
  example before
  equation before
  table before
  procedure before
  task before
  </xsl:param>

  <xsl:param name="generate.toc">
  appendix  nop
  article   toc,title
  book      toc,title,figure,table,example,equation
  chapter   title
  part      nop
  preface   nop
  qandadiv  nop
  qandaset  nop
  reference toc,title
  section   nop
  set       toc
  </xsl:param>

  <xsl:param name="toc.list.type">ul</xsl:param>
  <xsl:param name="toc.max.depth">8</xsl:param>
  <xsl:param name="toc.section.depth">2</xsl:param>
  <xsl:param name="chunk.tocs.and.lots" select="1"/>

  <xsl:param name="use.embed.for.svg" select="0"/>
  <xsl:param name="use.extensions" select="0"/>
  <xsl:param name="use.svg" select="1"/>

  <xsl:param name="glossary.sort" select="1"/>
  <xsl:param name="glossentry.show.acronym">yes</xsl:param>
  <xsl:param name="glossterm.auto.link" select="1"/>
  <xsl:param name="glossary.collection"></xsl:param>


</xsl:stylesheet>
