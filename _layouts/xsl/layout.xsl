<?xml version="1.0"?>
<!-- This file is generated from param.xweb -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <!-- a CSS link reference must take into account the relative
       path to a CSS file when chunked HTML is output to more than one directory -->
  <xsl:template name="make.css_cdn.link">
    <xsl:param name="css.filename" select="''"/>
    <xsl:param name="css.hash" select="''"/>

    <xsl:variable name="href">
      <xsl:call-template name="relative.path.link">
        <xsl:with-param name="target.pathname" select="$css.filename"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="string-length($css.filename) != 0 and string-length($css.hash) =0 ">
      <link rel="stylesheet"
            type="text/css"
            href="{$href}"/>
    </xsl:when>
    <xsl:when test="string-length($css.filename) != 0 and $css.hash !=''">
      <link rel="stylesheet"
            type="text/css"
            href="{$href}"
            integrity="{$css.hash}" crossorigin="anonymous"/>
    </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="output.html.css">
    <xsl:param name="css" select="''"/>
    <xsl:param name="hash" select="''"/>
    <xsl:choose>
      <xsl:when test="contains($css, ' ')">
        <xsl:variable name="css.filename" select="substring-before($css, ' ')"/>

        <xsl:call-template name="make.css_cdn.link">
          <xsl:with-param name="css.filename" select="$css.filename"/>
          <xsl:with-param name="css.hash" select="$hash"/>
        </xsl:call-template>

        <xsl:call-template name="output.html.css">
          <xsl:with-param name="css" select="substring-after($css, ' ')"/>
          <xsl:with-param name="hash" select="$hash"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$css != ''">
        <xsl:call-template name="make.css_cdn.link">
          <xsl:with-param name="css.filename" select="$css"/>
          <xsl:with-param name="css.hash" select="$hash"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- ==================================================================== -->
  <!-- For ToC -->

  <xsl:template name="make.toc">
    <xsl:param name="toc-context" select="/"/>
    <xsl:param name="toc.title.p" select="true()"/>
    <xsl:param name="nodes" select="/NOT-AN-ELEMENT"/>

    <xsl:variable name="nodes.plus" select="$nodes | qandaset"/>

    <xsl:variable name="toc.title">
      <xsl:if test="$toc.title.p">
        <xsl:choose>
          <xsl:when test="$make.clean.html != 0">
            <div class="toc-title">
              <xsl:call-template name="gentext">
                <xsl:with-param name="key">TableofContents</xsl:with-param>
              </xsl:call-template>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <p>
              <b>
                <xsl:call-template name="gentext">
                  <xsl:with-param name="key">TableofContents</xsl:with-param>
                </xsl:call-template>
              </b>
            </p>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$manual.toc != ''">
        <xsl:variable name="id">
          <xsl:call-template name="object.id"/>
        </xsl:variable>
        <xsl:variable name="toc" select="document($manual.toc, .)"/>
        <xsl:variable name="tocentry" select="$toc//tocentry[@linkend=$id]"/>
        <xsl:if test="$tocentry and $tocentry/*">
          <div class="toc">
            <xsl:copy-of select="$toc.title"/>
            <xsl:element name="{$toc.list.type}">
              <xsl:call-template name="toc.list.attributes">
                <xsl:with-param name="toc-context" select="$toc-context"/>
                <xsl:with-param name="toc.title.p" select="$toc.title.p"/>
                <xsl:with-param name="nodes" select="$nodes"/>
              </xsl:call-template>
              <xsl:call-template name="manual-toc">
                <xsl:with-param name="tocentry" select="$tocentry/*[1]"/>
              </xsl:call-template>
            </xsl:element>
          </div>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$qanda.in.toc != 0">
            <xsl:if test="$nodes.plus">
              <div class="toc">
                <xsl:copy-of select="$toc.title"/>
                <xsl:element name="{$toc.list.type}">
                  <xsl:call-template name="toc.list.attributes">
                    <xsl:with-param name="toc-context" select="$toc-context"/>
                    <xsl:with-param name="toc.title.p" select="$toc.title.p"/>
                    <xsl:with-param name="nodes" select="$nodes"/>
                  </xsl:call-template>
                  <xsl:apply-templates select="$nodes.plus" mode="toc">
                    <xsl:with-param name="toc-context" select="$toc-context"/>
                  </xsl:apply-templates>
                </xsl:element>
              </div>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$nodes">
              <div class="toc">
                <xsl:copy-of select="$toc.title"/>
                <xsl:element name="{$toc.list.type}">
                  <xsl:call-template name="toc.list.attributes">
                    <xsl:with-param name="toc-context" select="$toc-context"/>
                    <xsl:with-param name="toc.title.p" select="$toc.title.p"/>
                    <xsl:with-param name="nodes" select="$nodes"/>
                  </xsl:call-template>
                  <xsl:apply-templates select="$nodes" mode="toc">
                    <xsl:with-param name="toc-context" select="$toc-context"/>
                  </xsl:apply-templates>
                </xsl:element>
              </div>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>

      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- ==================================================================== -->
  <!-- Thesis Layout -->
  <xsl:template name="chunk-element-content">
    <xsl:param name="prev"/>
    <xsl:param name="next"/>
    <xsl:param name="nav.context"/>
    <xsl:param name="content">
      <xsl:apply-imports/>
    </xsl:param>
    <xsl:call-template name="user.preroot"/>

    <html >
      <xsl:call-template name="root.attributes"/>
      <xsl:call-template name="html.head">
        <xsl:with-param name="prev" select="$prev"/>
        <xsl:with-param name="next" select="$next"/>
      </xsl:call-template>
      <body>
        <xsl:call-template name="body.attributes"/>
        <a id="skippy" class="sr-only sr-only-focusable" href="#content">
         <div class="container"><span class="skiplink-text">Skip to main content</span></div>
        </a>
        <div id="TOP" class="container-fluid">
        <xsl:if test="count($prev) > 0">
          <xsl:call-template name="header.navigation">
            <xsl:with-param name="prev" select="$prev"/>
            <xsl:with-param name="next" select="$next"/>
            <xsl:with-param name="nav.context" select="$nav.context"/>
          </xsl:call-template>
        </xsl:if>

        <xsl:call-template name="user.header.content"/>

  <div class="container-fluid">

    <xsl:choose>
      <xsl:when test="count($prev) > 0 and 1">
    <div class="row flex-xl-nowrap">
        <aside class="d-none d-md-block col-md-3 col-xl-2 nav-toc" role="navigation">
          <nav id="TOC" class="page-toc">
          <!-- TODO: put TOC here? -->
            <ul class="division-toc">
              <li>  <a  class="btn btn-foot btn-toc" accesskey="t" aria-label="Toc">
                  <xsl:attribute name="href">
                    <xsl:value-of select="$chunked.filename.prefix"/>
                    <xsl:apply-templates select="/*[1]" mode="recursive-chunk-filename">
                      <xsl:with-param name="recursive" select="true()"/>
                    </xsl:apply-templates>
                    <xsl:text>-toc</xsl:text>
                    <xsl:value-of select="$html.ext"/>
                  </xsl:attribute>
                  <xsl:attribute name="title">
                    <xsl:text>Goto table of contents</xsl:text>
                  </xsl:attribute>
                  <xsl:choose>
                  <xsl:when test="$html.css.fa"><xsl:text disable-output-escaping="yes"><![CDATA[
                    <i class="fa fa-list-ol" aria-hidden="true"></i>
                  ]]></xsl:text></xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="gentext">
                      <xsl:with-param name="key" select="'nav-toc'"/>
                    </xsl:call-template>
                </xsl:otherwise>
                </xsl:choose>
                </a></li>
            <xsl:call-template name="subtoc">
              <xsl:with-param name="toc-context" select="."/>
              <xsl:with-param name="nodes" select="set|book|setindex
                                           |part|reference
                                           |preface|chapter|appendix
                                           |article
                                           |section|sect1|sect2
                                           |simplesect[$simplesect.in.toc != 0]
                                           |topic
                                           |refentry
                                           |glossary|bibliography|index
                                           |bridgehead[$bridgehead.in.toc != 0]"/>
            </xsl:call-template>
            </ul>
          </nav>
        </aside>
        <div class="col-12 col-md-9 col-md-10 content" role="main"  id="content">
          <main>
              <xsl:copy-of select="$content"/>
          </main>
        </div>
    </div>
      </xsl:when>
      <xsl:otherwise>
    <div class="col-12  content" role="main"  id="content">
      <main>
          <xsl:copy-of select="$content"/>
      </main>
    </div>
      </xsl:otherwise>
    </xsl:choose>

  </div>

        <xsl:call-template name="user.footer.content"/>

        <xsl:call-template name="footer.navigation">
          <xsl:with-param name="prev" select="$prev"/>
          <xsl:with-param name="next" select="$next"/>
          <xsl:with-param name="nav.context" select="$nav.context"/>
        </xsl:call-template>

        <xsl:call-template name="user.footer.navigation">
          <xsl:with-param name="prev" select="$prev"/>
          <xsl:with-param name="next" select="$next"/>
          <xsl:with-param name="nav.context" select="$nav.context"/>
        </xsl:call-template>
        </div>
        
      <xsl:call-template name="body.end">
        <xsl:with-param name="prev" select="$prev"/>
        <xsl:with-param name="next" select="$next"/>
      </xsl:call-template>
      </body>
    </html>
    <xsl:value-of select="$chunk.append"/>
  </xsl:template>

  <!-- ==================================================================== -->
  <!-- HTML5 HEAD elements -->
  <xsl:template name="system.head.content">
    <xsl:text disable-output-escaping="yes"><![CDATA[
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1, user-scalable=yes">
  <meta name="HandheldFriendly" content="True">
  <meta name="MobileOptimized" content="320">
  ]]></xsl:text>
  </xsl:template>
  <xsl:template name="user.head.content">
    <xsl:if test="$html.css != ''">
      <xsl:call-template name="output.html.css">
        <xsl:with-param name="css" select="substring-before(normalize-space($html.css), ' ')"/>
        <xsl:with-param name="hash" select="substring-after(normalize-space($html.css), ' ')"/>
      </xsl:call-template>
    </xsl:if>
  	<xsl:text disable-output-escaping="yes"><![CDATA[
  <!-- AMP -->
  <script async src="https://cdn.ampproject.org/v0.js"></script>
  <style amp-boilerplate>body{-webkit-animation:-amp-start 8s steps(1,end) 0s 1 normal both;-moz-animation:-amp-start 8s steps(1,end) 0s 1 normal both;-ms-animation:-amp-start 8s steps(1,end) 0s 1 normal both;animation:-amp-start 8s steps(1,end) 0s 1 normal both}@-webkit-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-moz-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-ms-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-o-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}</style><noscript><style amp-boilerplate>body{-webkit-animation:none;-moz-animation:none;-ms-animation:none;animation:none}</style></noscript>
  <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
  <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
  <!--[if lt IE 9]>
  <script async src="//cdnjs.cloudflare.com/ajax/libs/html5shiv/3.7.3/html5shiv-printshiv.min.js"></script>
  <script async src="//oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
  <![endif]-->
  <script async src="//code.jquery.com/jquery-3.3.1.min.js"></script>
  	]]></xsl:text>
  </xsl:template>

  <xsl:template name="breadcrumbs">
    <xsl:param name="this.node" select="."/>
    <div class="breadcrumbs">
      <xsl:for-each select="$this.node/ancestor::*">
        <span class="breadcrumb-item">
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="href.target">
                <xsl:with-param name="object" select="."/>
                <xsl:with-param name="context" select="$this.node"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:apply-templates select="." mode="title.markup"/>
          </a>
        </span>
        <xsl:text> &gt; </xsl:text>
      </xsl:for-each>
      <!-- And display the current node, but not as a link -->
      <span class="breadcrumb-node">
        <xsl:apply-templates select="$this.node" mode="title.markup"/>
      </span>
    </div>
  </xsl:template>
  <!-- ==================================================================== -->
  <!-- HEADER-->
  <xsl:template name="header.navigation">
    <xsl:param name="prev" select="/foo"/>
    <xsl:param name="next" select="/foo"/>
    <xsl:param name="nav.context"/>

    <xsl:variable name="home" select="/*[1]"/>
    <xsl:variable name="up" select="parent::*"/>

    <xsl:variable name="banner-nav" select="count($prev) &gt; 0
                                      or (count($up) &gt; 0
                                          and generate-id($up) != generate-id($home)
                                          and $navig.showtitles != 0)
                                      or count($next) &gt; 0"/>

    <xsl:if test="$suppress.navigation = '0' and $suppress.header.navigation = '0'">
  <div id="BANNER" class="clearfix container-fluid" role="banner">
    <div class="navbar thesis-banner">
      <xsl:call-template name="breadcrumbs"/>
      <xsl:if test="$banner-nav">
        <div class="banner-nav" role="navigation">
          <nav class="row">
            <ul class="navbar pagination">
               <li class="nav-link page-item nav-prev"><xsl:if test="count($prev)>0">
                <a class="page-link btn btn-head btn-prev" accesskey="p" aria-label="Previous">
                  <xsl:attribute name="href">
                    <xsl:call-template name="href.target">
                      <xsl:with-param name="object" select="$prev"/>
                    </xsl:call-template>
                  </xsl:attribute>
                  <xsl:attribute name="title">
                    <xsl:text>Previous page</xsl:text>
                  </xsl:attribute>
                  <xsl:choose>
                  <xsl:when test="$html.css.fa"><xsl:text disable-output-escaping="yes"><![CDATA[
                    <i class="fa fa-caret-square-left" aria-hidden="true"></i>
                  ]]></xsl:text></xsl:when>
                  <xsl:otherwise>
                  <xsl:call-template name="navig.content">
                    <xsl:with-param name="direction" select="'prev'"/>
                  </xsl:call-template>
                  </xsl:otherwise>
                  </xsl:choose>
                </a>
              </xsl:if><xsl:text>&#160;</xsl:text></li>
              <li class="nav-link page-item nav-up">
                <xsl:choose>
                  <xsl:when test="count($up) > 0
                                  and generate-id($up) != generate-id($home)
                                  and $navig.showtitles != 0">
                    <xsl:apply-templates select="$up" mode="object.title.markup"/>
                  </xsl:when>
                  <xsl:otherwise>&#160;</xsl:otherwise>
                </xsl:choose>
              </li>
              <li class="nav-link page-item nav-next">
                 <xsl:text>&#160;</xsl:text>
                 <xsl:if test="count($next)>0"><a class="page-link btn btn-head btn-next" accesskey="n" aria-label="Next">
                  <xsl:attribute name="href">
                    <xsl:call-template name="href.target">
                      <xsl:with-param name="object" select="$next"/>
                    </xsl:call-template>
                  </xsl:attribute>
                  <xsl:attribute name="title">
                    <xsl:text>Next page</xsl:text>
                  </xsl:attribute>
                  <xsl:choose>
                  <xsl:when test="$html.css.fa"><xsl:text disable-output-escaping="yes"><![CDATA[
                    <i class="fa fa-caret-square-right" aria-hidden="true"></i>
                  ]]></xsl:text></xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="navig.content">
                      <xsl:with-param name="direction" select="'next'"/>
                    </xsl:call-template>
                  </xsl:otherwise>
                  </xsl:choose>
                </a></xsl:if>
              </li>
            </ul>
          </nav></div>
        </xsl:if>
        <xsl:if test="$header.rule != 0">
          <hr/>
        </xsl:if>
      </div></div>
    </xsl:if>
  </xsl:template>

  <!-- ==================================================================== -->
  <!-- FOOTER-->
  <xsl:template name="footer.navigation">
    <xsl:param name="prev" select="/foo"/>
    <xsl:param name="next" select="/foo"/>
    <xsl:param name="nav.context"/>

    <xsl:variable name="home" select="/*[1]"/>
    <xsl:variable name="up" select="parent::*"/>

    <xsl:variable name="footer-nav" select="count($prev) &gt; 0                                     or count($up) &gt; 0                                     or count($next) &gt; 0"/>

    <xsl:variable name="home-toc" select="($prev and $navig.showtitles != 0)                                     or (generate-id($home) != generate-id(.)                                         or $nav.context = 'toc')                                     or ($chunk.tocs.and.lots != 0                                         and $nav.context != 'toc')                                     or ($next and $navig.showtitles != 0)"/>

    <xsl:if test="$suppress.navigation = '0' and $suppress.footer.navigation = '0'">

    <div class="clearfix container-fluid">
    <footer class="footer" id='FOOTER'>
        <xsl:if test="$footer.rule != 0">
          <hr/>
        </xsl:if>

        <xsl:if test="$footer-nav or $home-toc">
          <xsl:if test="$footer-nav">
            <div class="footer-nav" role="navigation">
              <nav class="row">
                <ul class="navbar pagination">
                   <li class="nav-link page-item nav-prev"><xsl:if test="count($prev)>0">
                    <a class="page-link btn btn-foot btn-prev" accesskey="p" aria-label="Previous">
                      <xsl:attribute name="href">
                        <xsl:call-template name="href.target">
                          <xsl:with-param name="object" select="$prev"/>
                        </xsl:call-template>
                      </xsl:attribute>
                      <xsl:attribute name="title">
                        <xsl:text>Previous page</xsl:text>
                      </xsl:attribute>
                      <xsl:choose>
                      <xsl:when test="$html.css.fa"><xsl:text disable-output-escaping="yes"><![CDATA[
                        <i class="fa fa-caret-square-left" aria-hidden="true"></i>
                      ]]></xsl:text></xsl:when>
                      <xsl:otherwise>
                      <xsl:call-template name="navig.content">
                        <xsl:with-param name="direction" select="'prev'"/>
                      </xsl:call-template>
                      </xsl:otherwise>
                      </xsl:choose>
                    </a>
                  </xsl:if><xsl:text>&#160;</xsl:text></li>
                  <li class="nav-link page-item nav-up">
                    <xsl:choose>
                      <xsl:when test="count($up) > 0
                                      and generate-id($up) != generate-id($home)
                                      and $navig.showtitles != 0">
                        <xsl:apply-templates select="$up" mode="object.title.markup"/>
                      </xsl:when>
                      <xsl:otherwise>&#160;</xsl:otherwise>
                    </xsl:choose>
                  </li>
                  <li class="nav-link page-item nav-next">
                     <xsl:text>&#160;</xsl:text>
                     <xsl:if test="count($next)>0"><a class="page-link btn btn-foot btn-next" accesskey="n" aria-label="Next">
                      <xsl:attribute name="href">
                        <xsl:call-template name="href.target">
                          <xsl:with-param name="object" select="$next"/>
                        </xsl:call-template>
                      </xsl:attribute>
                      <xsl:attribute name="title">
                        <xsl:text>Next page</xsl:text>
                      </xsl:attribute>
                      <xsl:choose>
                      <xsl:when test="$html.css.fa"><xsl:text disable-output-escaping="yes"><![CDATA[
                        <i class="fa fa-caret-square-right" aria-hidden="true"></i>
                      ]]></xsl:text></xsl:when>
                      <xsl:otherwise>
                        <xsl:call-template name="navig.content">
                          <xsl:with-param name="direction" select="'next'"/>
                        </xsl:call-template>
                      </xsl:otherwise>
                      </xsl:choose>
                    </a></xsl:if>
                  </li>
                </ul>
              </nav></div>
          </xsl:if>

          <xsl:if test="$home-toc">
            <div class="footer-heading"><ul class="navbar pagination">
              <li class="nav-link page-item nav-prev">
                <xsl:if test="$navig.showtitles != 0">
                  <xsl:apply-templates select="$prev" mode="object.title.markup"/>
                </xsl:if>
                <xsl:text>&#160;</xsl:text>
              </li>
              <li class="nav-link page-item nav-home">
                <xsl:choose>
                  <xsl:when test="$home != . or $nav.context = 'toc'">
                    <a class="btn btn-foot btn-home" accesskey="h" aria-label="Home">
                      <xsl:attribute name="href">
                        <xsl:call-template name="href.target">
                          <xsl:with-param name="object" select="$home"/>
                        </xsl:call-template>
                      </xsl:attribute>
                      <xsl:attribute name="title">
                        <xsl:text>Goto titlepage</xsl:text>
                      </xsl:attribute>
                      <xsl:choose>
                      <xsl:when test="$html.css.fa"><xsl:text disable-output-escaping="yes"><![CDATA[
                        <i class="fa fa-home" aria-hidden="true"></i>
                      ]]></xsl:text></xsl:when>
                      <xsl:otherwise>
                      <xsl:call-template name="navig.content">
                        <xsl:with-param name="direction" select="'home'"/>
                      </xsl:call-template>
                    </xsl:otherwise>
                    </xsl:choose>
                    </a>
                    <xsl:if test="$chunk.tocs.and.lots != 0 and $nav.context != 'toc'">
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>&#160;</xsl:otherwise>
                </xsl:choose>
              </li>
              <li class="nav-link page-item">
                <xsl:if test="$chunk.tocs.and.lots != 0 and $nav.context != 'toc'">
                  <a  class="btn btn-foot btn-toc" accesskey="t" aria-label="Toc">
                    <xsl:attribute name="href">
                      <xsl:value-of select="$chunked.filename.prefix"/>
                      <xsl:apply-templates select="/*[1]" mode="recursive-chunk-filename">
                        <xsl:with-param name="recursive" select="true()"/>
                      </xsl:apply-templates>
                      <xsl:text>-toc</xsl:text>
                      <xsl:value-of select="$html.ext"/>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                      <xsl:text>Goto table of contents</xsl:text>
                    </xsl:attribute>
                    <xsl:choose>
                    <xsl:when test="$html.css.fa"><xsl:text disable-output-escaping="yes"><![CDATA[
                      <i class="fa fa-list-ol" aria-hidden="true"></i>
                    ]]></xsl:text></xsl:when>
                    <xsl:otherwise>
                      <xsl:call-template name="gentext">
                        <xsl:with-param name="key" select="'nav-toc'"/>
                      </xsl:call-template>
                  </xsl:otherwise>
                  </xsl:choose>
                  </a>
                </xsl:if>
              </li>
              <li class="nav-link page-item nav-next">
                <xsl:text>&#160;</xsl:text>
                <xsl:if test="$navig.showtitles != 0">
                  <xsl:apply-templates select="$next" mode="object.title.markup"/>
                </xsl:if>
              </li>
            </ul></div>
          </xsl:if>
        </xsl:if>
      </footer></div>
    </xsl:if>
  </xsl:template>

  <!-- ==================================================================== -->
  <!-- BODY END -->
  <xsl:template name="body.end">
    <xsl:param name="prev" select="/foo"/>
    <xsl:param name="next" select="/foo"/>
    <xsl:param name="nav.context"/>
  </xsl:template>
</xsl:stylesheet>
