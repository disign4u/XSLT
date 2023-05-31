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
                <title>Menu</title>
                <!--<link rel="stylesheet" type="text/css" href="site.css"/>-->
            </head>
            <div id="site" class="site">
                <header id="header" class="header">
                    <div class="banner">
                        <nav id="nav_0" class="nav-level-0">
                            <ul class="main-menu" id="nav_menu">
                                <xsl:for-each select="/site:site/site:tree/menu[@level=0]/*">
                                    <xsl:variable name="position" select="position()"/>
                                    <xsl:variable name="struct" select="@struct"/>
                                    <xsl:variable name="page" select="@id"/>
                                    <xsl:variable name="struct_children"
                                                  select="/site:site/site:tree/menu[@struct=$struct]/*"/>
                                    <xsl:variable name="struct_children_num" select="count($struct_children)"/>
                                    <li class="main-menu-item">
                                        <a>
                                           id:<xsl:value-of select="@id"/>
                                            - struct:<xsl:value-of select="@struct"/>
                                            - struct-pid:<xsl:value-of select="@struct-pid"/>
                                            - <xsl:value-of select="name()"/>
                                        </a>
                                    </li>
                                </xsl:for-each>
                            </ul>

                        </nav>
                    </div>
                </header>
            </div>
        </html>
    </xsl:template>

    <xsl:template match="site:content/site:content-item[@name='nav']">
        navigation
    </xsl:template>

    <xsl:template match="content:article1">
        <xsl:value-of disable-output-escaping="yes" select="."/>
    </xsl:template>

    <xsl:template match="content:article1[@xml='true']">
        <xsl:copy-of select="xml/node()"/>
    </xsl:template>

</xsl:stylesheet>