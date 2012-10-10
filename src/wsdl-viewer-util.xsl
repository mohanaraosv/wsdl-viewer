<?xml version="1.0" encoding="UTF-8" ?>
<!--
/**
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements. See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
-->

<!--
* ====================================================================
* wsdl-viewer-util.xsl
* Author: tomi vanek
* ====================================================================
* Description:
* 		Supporting templates
* ====================================================================
-->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:ws="http://schemas.xmlsoap.org/wsdl/"
	xmlns:ws2="http://www.w3.org/ns/wsdl"
	exclude-result-prefixes="ws ws2">

<!--
==================================================================
	Rendering: QName link is normalized with removing the namespace prefix
==================================================================
-->
<xsl:template match="@*" mode="qname.normalized">
	<xsl:variable name="local" select="substring-after(., ':')"/>
	<xsl:choose>
		<xsl:when test="$local"><xsl:value-of select="$local"/></xsl:when>
		<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!--
==================================================================
	Rendering: HTML title
==================================================================
-->
<xsl:template match="ws:definitions | ws2:description" mode="html-title.render">
	<xsl:choose>
		<xsl:when test="$global.service-name"><xsl:value-of select="concat('Web Service: ', $global.service-name)"/></xsl:when>
		<xsl:when test="$global.binding-name"><xsl:value-of select="concat('WS Binding: ', $global.binding-name)"/></xsl:when>
		<xsl:when test="ws2:interface/@name"><xsl:value-of select="concat('WS Interface: ', ws2:interface/@name)"/></xsl:when>
		<xsl:otherwise>Web Service Fragment</xsl:otherwise>
<!--		<xsl:otherwise><xsl:message terminate="yes">Syntax error in element <xsl:call-template name="src.syntax-error.path"/></xsl:message>
		</xsl:otherwise>
-->
	</xsl:choose>
</xsl:template>

<!--
==================================================================
	Rendering: Syntax error
==================================================================
-->
<xsl:template name="src.syntax-error">
	<xsl:message terminate="yes">Syntax error by WSDL source rendering in element <xsl:call-template name="src.syntax-error.path"/></xsl:message>
</xsl:template>

<xsl:template name="src.syntax-error.path">
	<xsl:for-each select="parent::*"><xsl:call-template name="src.syntax-error.path"/></xsl:for-each>
	<xsl:value-of select="concat('/', name(), '[', position(), ']')"/>
</xsl:template>

<!--
==================================================================
	Rendering: Documentation
==================================================================
-->
<xsl:template match="*[local-name(.) = 'documentation']" mode="documentation.render">
	<xsl:if test="$ENABLE-DESCRIPTION and string-length(.) &gt; 0">
		<div class="description_label">Description:</div>
		<div class="description_value"><xsl:value-of select="." disable-output-escaping="yes"/></div>
	</xsl:if>
</xsl:template>

<!--
==================================================================
	Rendering: Link to source code
==================================================================
-->
<xsl:template name="render.source-code-link">
	<xsl:if test="$ENABLE-SRC-CODE-PARAGRAPH and $ENABLE-LINK">
		<a class="local" href="{concat('#', $SRC-PREFIX, generate-id(.))}"><xsl:value-of select="$SOURCE-CODE-TEXT"/></a>
	</xsl:if>
</xsl:template>

<!--
==================================================================
	Rendering: About
==================================================================
-->
<xsl:template name="about.detail">
<xsl:param name="version"/>
<div>
	This page has been generated by <big>wsdl-viewer.xsl</big>, version <xsl:value-of select="$version"/><br />
	Author: <a href="http://tomi.vanek.sk/">tomi vanek</a><br />
	Download at <a href="http://tomi.vanek.sk/xml/wsdl-viewer.xsl">http://tomi.vanek.sk/xml/wsdl-viewer.xsl</a>.<br />
	<br />
	The transformation was inspired by the article<br />
	Uche Ogbuji: <a href="http://www-106.ibm.com/developerworks/library/ws-trans/index.html">WSDL processing with XSLT</a><br />
</div>
</xsl:template>

<!--
==================================================================
	Rendering: processor-info
==================================================================
-->
<xsl:template name="processor-info.render">
<xsl:text>
</xsl:text>
<xsl:text>This document was generated by </xsl:text>
<a href="{system-property('xsl:vendor-url')}"><xsl:value-of select="system-property('xsl:vendor')"/></a>
<xsl:text> XSLT engine.
</xsl:text>

<xsl:text>The engine processed the WSDL in XSLT </xsl:text>
<xsl:value-of select="format-number(system-property('xsl:version'), '#.0')"/>
<xsl:text> compliant mode.
</xsl:text>

</xsl:template>

</xsl:stylesheet>
