
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 xmlns:xhtml="http://www.w3.org/1999/xhtml"
                 xmlns:db="http://docbook.org/ns"
                 xmlns:xi="http://www.w3.org/2001/XInclude"
                 xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="xlink xhtml db xi"
                version='1.0'>
  <!-- ==================================================================== -->
  <!-- <abbrev> and <acronym> -->


	<!-- <emphasis> -->
	<xsl:template match="//db:emphasis" mode="body">
		<xsl:variable name="element">
			<xsl:choose>
				<xsl:when test="attribute::role='strong'">strong</xsl:when>
				<xsl:otherwise>em</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="html.inline">
			<xsl:with-param name="element" select="normalize-space($element)" />
			<xsl:with-param name="kind" />
		</xsl:call-template>
	</xsl:template>


	<xsl:template name="html.inline">
		<xsl:param name="element" select="'span'" />
		<xsl:param name="lang" />
		<xsl:param name="class" />
		<xsl:param name="role" select="@role" />
		<xsl:param name="id" select="normalize-space(@xml:id)" />
		<xsl:param name="kind" select="local-name()" />
		<xsl:param name="prefix" />
		<xsl:param name="suffix" />
		<xsl:param name="title" />
		<xsl:element name="{$element}">
			<xsl:call-template name="html.inline.attrs">
				<xsl:with-param name="class" select="$class" />
				<xsl:with-param name="lang" select="$lang" />
				<xsl:with-param name="role" select="$role" />
				<xsl:with-param name="id" select="$id" />
				<xsl:with-param name="kind" select="$kind" />
				<xsl:with-param name="title" select="$title" />
			</xsl:call-template>
			<xsl:copy-of select="$prefix" /><xsl:apply-templates select="node()" mode="body" /><xsl:copy-of select="$suffix" />
		</xsl:element>
	</xsl:template>

	<xsl:template name="html.inline.attrs">
		<xsl:param name="class" />
		<xsl:param name="role" select="@role" />
		<xsl:param name="id" select="normalize-space(@xml:id)" />
		<xsl:param name="kind" select="local-name()" />
		<xsl:param name="title" />
		<xsl:variable name="classes" select="normalize-space(concat($class, ' ', $role, ' ', $kind))" />
		<xsl:if test="$id != ''"><xsl:attribute name="id"><xsl:value-of select="$id" /></xsl:attribute></xsl:if>
		<xsl:if test="$classes != ''"><xsl:attribute name="class"><xsl:value-of select="$classes" /></xsl:attribute></xsl:if>
		<xsl:if test="normalize-space($title) != ''"><xsl:attribute name="title"><xsl:value-of select="$title" /></xsl:attribute></xsl:if>
	</xsl:template>
  <!-- ==================================================================== -->
  <xsl:template match="mediaobject" mode="class.value">
    <xsl:choose>
      <xsl:when test="@role">
        <xsl:value-of select="@role"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="local-name()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ==================================================================== -->
  <!-- some special cases -->
  <xsl:template match="author">
    <xsl:param name="content">
      <xsl:call-template name="person.name"/>
    </xsl:param>

    <xsl:param name="contentwithlink">
      <xsl:call-template name="anchor"/>
      <xsl:call-template name="simple.xlink">
        <xsl:with-param name="content" select="$content"/>
      </xsl:call-template>
      <xsl:call-template name="apply-annotations"/>
    </xsl:param>

    <span>
      <xsl:call-template name="html.inline.attrs"/>
      <xsl:call-template name="id.attribute"/>
      <xsl:copy-of select="$contentwithlink"/>
    </span>
  </xsl:template>
  <!-- ==================================================================== -->
  <xsl:template match="emphasis">
    <span>
      <xsl:call-template name="id.attribute"/>
      <xsl:choose>
        <!-- We don't want empty @class values, so do not propagate empty @roles -->
        <xsl:when test="@role  and
                        normalize-space(@role) != '' and
                        $emphasis.propagates.style != 0">
          <xsl:apply-templates select="." mode="common.html.attributes">
            <xsl:with-param name="class" select="@role"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="." mode="common.html.attributes"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="anchor"/>

      <xsl:call-template name="simple.xlink">
        <xsl:with-param name="content">
          <xsl:choose>
            <xsl:when test="@role = 'bold' or @role='strong'">
              <!-- backwards compatibility: make bold into b elements, but -->
              <!-- don't put bold inside figure, example, or table titles -->
              <xsl:choose>
                <xsl:when test="local-name(..) = 'title'
                                and (local-name(../..) = 'figure'
                                or local-name(../..) = 'example'
                                or local-name(../..) = 'table')">
                  <xsl:apply-templates/>
                </xsl:when>
                <xsl:otherwise>
                  <strong><xsl:apply-templates/></strong>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="@role='underline' or @role='uline'">
              <u><xsl:apply-templates/></u>
            </xsl:when>
            <xsl:when test="@role and $emphasis.propagates.style != 0">
              <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
              <em><xsl:apply-templates/></em>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </span>
  </xsl:template>

  <!-- ==================================================================== -->
  <xsl:template match="foreignphrase"><!--
    <span>
      <xsl:apply-templates select="." mode="common.html.attributes"/>
       <xsl:call-template name="inline.italicseq"/>
    </span> -->
     <xsl:call-template name="inline.charseq"/>
  </xsl:template>


  <xsl:template name="gentext.startquote"/>
  <xsl:template name="gentext.endquote"/>

  <xsl:template match="quote">
    <xsl:variable name="depth">
      <xsl:call-template name="dot.count">
        <xsl:with-param name="string">
          <xsl:number level="multiple"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <span>
      <xsl:apply-templates select="." mode="common.html.attributes"/>
      <xsl:call-template name="id.attribute"/>
      <xsl:choose>
        <xsl:when test="$depth mod 2 = 0">
          <xsl:call-template name="gentext.startquote"/>
          <xsl:call-template name="inline.charseq">
            <xsl:with-param name="wrapper-name">q</xsl:with-param>
          </xsl:call-template>
          <xsl:call-template name="gentext.endquote"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="gentext.nestedstartquote"/>
          <xsl:call-template name="inline.charseq">
            <xsl:with-param name="wrapper-name">q</xsl:with-param>
          </xsl:call-template>
          <xsl:call-template name="gentext.nestedendquote"/>
        </xsl:otherwise>
      </xsl:choose>
    </span>
  </xsl:template>

  <!-- ==================================================================== -->
  <xsl:key name="glossentries" match="glossentry" use="normalize-space(glossterm)"/>
  <xsl:key name="glossentries" match="glossentry" use="normalize-space(glossterm/@baseform)"/>

</xsl:stylesheet>
