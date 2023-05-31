<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:php="http://php.net/xsl"
                xmlns:site="http://xmlns.webmaking.ms/site/"
                xmlns:content="http://xmlns.webmaking.ms/content/"
                exclude-result-prefixes="site content"
                xmlns:func="http://exslt.org/functions"
                xmlns:math="http://exslt.org/math"
                xmlns:exslt="http://exslt.org/common"
                xmlns:str="http://exslt.org/strings"
                extension-element-prefixes="func math exslt str php">
	<xsl:template match="site:site">
		<html>
			<head>
				<title>MegaNav Menu</title>
                <link rel="stylesheet" type="text/css" href="style.css"/>
			</head>
			<div id="site" class="site">
				<header id="header" class="header">
                    <div class="top-menu">
                        <div class="top-menu-col left"> <xsl:apply-templates select="site:content-item[@name='tools']/*[1]"/></div>
                        <div class="top-menu-col empty"><!--space für logo--></div>
                        <div class="top-menu-col right">
							<!--<xsl:apply-templates select="site:content-item[@name='tools']/*[2]"/>-->
							<!--<xsl:copy-of select="/site:site/site:content/site:content-item/content:article1/xml/node()"/>-->
							<!--<xsl:value-of select="/site:site/site:content/site:content-item/content:article1"/>-->
						</div>
                    </div>
					<div class="banner">
						<nav id="nav_0" class="nav-level-0">
							<xsl:apply-templates select="site:content/site:content-item[@name='nav']"/>
						</nav>
					</div>
				</header>
				<main id="main">
					main
				</main>
				<footer>
					footer
				</footer>
			</div>
		</html>
	</xsl:template>
	
	<xsl:template match="site:content/site:content-item[@name='nav']">
		navigation
    </xsl:template>

	<xsl:template match="content:article1">
		<xsl:value-of disable-output-escaping="yes" select="." />
	</xsl:template>

	<xsl:template match="content:article1[@xml='true']">
		<xsl:copy-of select="xml/node()" />
	</xsl:template>

</xsl:stylesheet>