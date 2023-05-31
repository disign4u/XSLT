<?xml version = "1.0" encoding = "UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:site="http://xmlns.webmaking.ms/site/" xmlns:cstc="http://xmlns.webmaking.ms/cstc/" exclude-result-prefixes="site cstc">
	<xsl:output method="html"/>
	<xsl:template match="cstc:site">
		<div class="cst">
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<xsl:template match="cstc:roomtype-list">
		<xsl:variable name="layout">summer</xsl:variable>
		<h1>Preise</h1>
		<xsl:choose>
			<xsl:when test="$layout='summer'">
				<h2>Preise Sommer</h2>

			</xsl:when>
			<xsl:otherwise>kein layout definiert</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>