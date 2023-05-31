<?xml version="1.0" encoding="UTF-8" ?>
<!-- noinspection HardwiredNamespacePrefix -->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:site="http://xmlns.webmaking.ms/site/"
                xmlns:content="http://xmlns.webmaking.ms/content/"
                exclude-result-prefixes="site content"
                xmlns:func="http://exslt.org/functions"
                xmlns:math="http://exslt.org/math"
                xmlns:exslt="http://exslt.org/common"
                xmlns:date="http://exslt.org/dates-and-times"
                xmlns:str="http://exslt.org/strings"
                xmlns:php="http://php.net/xsl"
                extension-element-prefixes="func math exslt date str php">

    <xsl:variable name="current_lang" select="/site:site/site:page/@page-language-iso" />
    <xsl:variable name="has_subnav" select="count( /site:site/site:tree/menu[@vstate='active' and @level=1]/*) &gt; 0" />
    <xsl:variable name="nav_page_level" select="count(str:tokenize(/site:site/site:page/languages/*[@state='current']/@url,'/'))-1" />
    <xsl:variable name="dev_domain" select="string( /site:site[ site:env/site:vars/dev = 'yes' ]/site:website/@domain-standard-uri )" />
    <xsl:variable name="nst-template-settings" select="/site:site/site:template/template-settings/template-setting" />

    <xsl:variable name="ua_browser_name" select="/site:site/site:env/site:user-agent/@name" />
    <xsl:variable name="ua_browser_version" select="/site:site/site:env/site:user-agent/@version" />
    <xsl:variable name="ua_is_mobile" select="/site:site/site:env/site:user-agent/@mobile" />
    <xsl:variable name="ua_is_mobile_or_tablet" select="/site:site/site:env/site:user-agent[@mobile or @tablet]" />

    <xsl:variable name="site-content" select="/site:site/site:content" />
    <xsl:variable name="site-content-item" select="$site-content/site:content-item" />
    <xsl:output media-type="html"/>

    <xsl:template match="site:site">
        <html lang="de">
            <head>
                <link href="demo.css" rel="preload stylesheet" as="style" type="text/css" />
            </head>
            <body>
                <div id="site" class="site">
                    <xsl:apply-templates select="site:match-space/header" />
                    <xsl:apply-templates select="site:match-space/main" />
                    <xsl:apply-templates select="site:match-space/footer" />
                </div>
            </body>
        </html>
    </xsl:template>

    <!-- ######## MAIN ######## -->
    <xsl:template match="site:match-space/main">
        <main id="main">
            <xsl:apply-templates select="$site-content-item[@name='content']"/>
        </main>
    </xsl:template>

    <xsl:variable name="groupItems" select="4"/>
    <xsl:template match="site:content-item[@name='content']">
        <xsl:for-each select="./*[position() mod $groupItems = 1]">
            <xsl:apply-templates select=".">
                <xsl:with-param name="position" select="position()"/>
            </xsl:apply-templates>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="site:content-item[@name='content']/*">
        <xsl:param name="position" />
        <xsl:variable name="even" select="$position mod 2 = 0"/>
        <div class="content-item">
            <!--
            <xsl:value-of select="$position"/><xsl:value-of select="name()"/> <hr/>
            -->
            <xsl:for-each select=".|following-sibling::*[not(position() > $groupItems -1)]">
                    <div class="item">
                        <xsl:value-of select="$position"/> -- <xsl:value-of select="position()"/> __ <xsl:value-of select="name()"/> <hr/>
                    </div>
            </xsl:for-each>
        </div>
    </xsl:template>
</xsl:stylesheet>