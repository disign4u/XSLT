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
                <link rel="stylesheet" type="text/css" href="site.css"/>
            </head>
            <div id="site" class="site">
                <header id="header" class="header">
                    <div class="banner cf">
                        <div class="top-menu"> <div class="top-menu-col left"> <ul> <li class="header-tel" style="white-space: nowrap;"> <a href="tel:+4974499200">+49 (0) 7449 - 920-0</a> </li> <li class="header-email"> <a href="mailto:info@schliffkopf.de">info@schliffkopf.de</a> </li> </ul> </div> <div class="top-menu-col logo"> <a href="/de/"> <img src="http://3146-678.sites.condeon.net/media/51267/g10-1560776.png" alt="" srcset="http://3146-678.sites.condeon.net/media/51267/logo-schliffkopf-1560777.svg 1x"/> </a> </div> <div class="top-menu-col right"> <ul> <li class="header-route"> <a>Anfahrt</a> </li> </ul> <ul class="lang-menu"> <li class="current"> <a href="/de/" title="Wellness &amp; Naturhotel Schliffkopf (DE)">DE</a> </li> <li class="alternative"> <a href="/fr/" title="wellness-fr (FR)">FR</a> </li> <li class="alternative"> <a href="/en/" title="wellness-en (EN)">EN</a> </li> </ul> </div> <div id="nav_menu_button" class="top-menu-col menu-button"> <span class="menu-text">Menü</span> <span class="menu-icon"></span> </div> </div>
                        <nav id="nav_0" class="nav-level-0">
                            <ul class="main-menu" id="main-menu">
                                <xsl:for-each select="/site:site/site:tree/menu[@level=0]/*">
                                    <xsl:variable name="position" select="position()"/>
                                    <xsl:variable name="struct" select="@struct"/>
                                    <xsl:variable name="page-id" select="@id"/>
                                    <xsl:variable name="struct_children"
                                                  select="/site:site/site:tree/menu[@struct=$struct]/*"/>
                                    <xsl:variable name="struct_children_num" select="count($struct_children)"/>
                                    <li class="main-menu-item menu-{$page-id}">
                                        <xsl:variable name="page-subtitle"
                                                      select="/site:site/site:page/page-attributes/page-attribute[@name='untertitel' and @page=$page-id]/@value"/>
                                        <xsl:attribute name="class">
                                            <xsl:choose>
                                                <xsl:when test="$position &gt; 2">nav-right</xsl:when>
                                                <xsl:otherwise>nav-left</xsl:otherwise>
                                            </xsl:choose>
                                            main-menu-item menu-<xsl:value-of select="$position"/>
                                            <xsl:if test="not( $struct_children_num )">menu-single</xsl:if>
                                            <xsl:if test="@state = 'active'"> active open-mobile</xsl:if>
                                        </xsl:attribute>
                                        <a href="{@url}" class="main-menu-link">
                                            <xsl:choose>
                                                <xsl:when test="string-length( $page-subtitle ) &gt; 0">
                                                    <div class="main-menu-subtitle">
                                                        <xsl:value-of select="$page-subtitle"/>
                                                    </div>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <div class="main-menu-subtitle">
                                                        <xsl:value-of select="."/>
                                                    </div>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </a>
                                        <!-- Wen jede 2 Ebene eine dritte Ebene hat mit mindestens 1 Seite render die 3 Ebene
                                            Ebene 2: <xsl:value-of select="count(/site:site/site:tree/menu[@struct=$struct]/*)"/><br/>
                                            Ebene 3: <xsl:value-of select="count(/site:site/site:tree/menu[@struct-pid=$struct]/*[1])"/>
                                        -->
                                        <xsl:variable name="struct_children_sub_num"
                                                      select="count(/site:site/site:tree/menu[@struct-pid=$struct]/*[1])"/>
                                        <xsl:choose>
                                            <xsl:when
                                                    test="$struct_children_num &gt; 0 and ($struct_children_num = $struct_children_sub_num)">
                                                <xsl:call-template name="sub-menu">
                                                    <xsl:with-param name="struct" select="$struct_children"/>
                                                    <xsl:with-param name="level-3" select="true()"/>
                                                </xsl:call-template>
                                            </xsl:when>
                                            <xsl:when test="$struct_children_num &gt; 0">
                                                <xsl:call-template name="sub-menu">
                                                    <xsl:with-param name="struct" select="$struct_children"/>
                                                    <xsl:with-param name="level-3" select="false()"/>
                                                </xsl:call-template>
                                            </xsl:when>
                                            <xsl:otherwise><!-- do nothing--></xsl:otherwise>
                                        </xsl:choose>
                                    </li>
                                    <xsl:if test="$position=2">
                                        <li class="main-menu-item empty"><!--empty placeholder for logo --></li>
                                    </xsl:if>
                                </xsl:for-each>
                            </ul>
                        </nav>
                    </div>
                    <div class="quicklinks"><ul>
                        <li><a class="tour" title="360° Tour" href="#"><span class="action-button-text">360° Tour</span><span class="action-button-desc">erleben Sie das Hotel</span></a></li>
                        <li><a class="angebote" title="last minute" href="#"><span class="action-button-text">Last Minute</span><span class="action-button-desc">Angebote entdecken</span></a></li>
                        <li><a class="news" title="Basenfasten" href="#"><span class="action-button-text">Basenfasten</span><span class="action-button-desc">Neu im Schliffkopf</span></a></li>
                    </ul>
                    </div>
                </header>
                <main id="main">

                </main>
                <footer>

                </footer>
            </div>
        </html>
    </xsl:template>

    <xsl:template name="sub-menu">
        <xsl:param name="struct"/>
        <xsl:param name="level-3"/> <!--boolean-->
        <xsl:variable name="struct_num" select="count($struct)"/>
        <xsl:variable name="max-items">
            <xsl:choose>
                <xsl:when test="$level-3">4</xsl:when>
                <xsl:otherwise>5</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <div class="sub-menu" id="sub-{$struct/@id}">
            <xsl:choose>
                <xsl:when test="$level-3">
                    <ul class="sub-menu-list">
                        <xsl:for-each
                                select="$struct[position() &lt; $max-items or (position() = $max-items and $struct_num = $max-items)]">
                            <xsl:variable name="page-id" select="@id"/>
                            <xsl:variable name="pos" select="position()"/>
                            <xsl:variable name="active">
                                <xsl:if test="@state='active'">active</xsl:if>
                            </xsl:variable>
                            <xsl:variable name="page-title"
                                          select="/site:site/site:page/page-attributes/page-attribute[@name='untertitel' and @page=$page-id]/@value"/>
                            <!--Wen keine Seite aktive ist setze den ersten Link aktive-->
                            <xsl:variable name="set-active">
                                <xsl:if test="count($struct[@state='active']) = 0 and ($pos = 1)"> active</xsl:if>
                            </xsl:variable>
                            <li class="menu-item {$active}{$set-active}" id="page_{$page-id}">
                                <a href="{@url}" class="main-menu-link">
                                    <xsl:choose>
                                        <xsl:when test="string-length( $page-title ) &gt; 0">
                                            <div class="main-menu-subtitle">
                                                <xsl:value-of select="$page-title"/>
                                            </div>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <div class="main-menu-subtitle">
                                                <xsl:value-of select="."/>
                                            </div>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </a>
                                <!--ebene3-->
                                <xsl:variable name="struct_sub" select="@struct"/>
                                <xsl:variable name="struct_children_sub"
                                              select="/site:site/site:tree/menu[@struct=$struct_sub]/*"/>
                                <xsl:variable name="struct_children_sub_count" select="count($struct_children_sub)"/>
                                <ul class="sub-menu-container" id="container_{$struct_sub}">
                                    <xsl:for-each
                                            select="$struct_children_sub[position() &lt; $max-items or (position() = $max-items and $struct_children_sub_count = $max-items)]">
                                        <xsl:variable name="page-sub-id" select="@id"/>
                                        <xsl:variable name="active-sub">
                                            <xsl:if test="@state='active'"> active</xsl:if>
                                        </xsl:variable>
                                        <xsl:variable name="first-active-sub">
                                            <xsl:if test="@state='active'"> active</xsl:if>
                                        </xsl:variable>
                                        <xsl:variable name="page-subtitle"
                                                      select="/site:site/site:page/page-attributes/page-attribute[@name='untertitel' and @page=$page-sub-id]/@value"/>
                                        <li class="menu-item-sub {$active-sub}" id="page_{$page-sub-id}">
                                            <a href="{@url}" class="main-menu-link">
                                                <xsl:choose>
                                                    <xsl:when test="string-length( $page-subtitle ) &gt; 0">
                                                        <div class="main-menu-subtitle">
                                                            <xsl:value-of select="$page-subtitle"/>
                                                        </div>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <div class="main-menu-subtitle">
                                                            <xsl:value-of select="."/>
                                                        </div>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </a>
                                        </li>
                                    </xsl:for-each>
                                </ul>
                            </li>
                        </xsl:for-each>
                    </ul>
                </xsl:when>
                <xsl:otherwise>
                    <ul class="sub-menu-items">
                        <xsl:for-each
                                select="$struct[position() &lt; $max-items or (position() = $max-items and $struct_num = $max-items)]">
                            <xsl:variable name="page-id" select="@id"/>
                            <xsl:variable name="active">
                                <xsl:if test="@state='active'"> active</xsl:if>
                            </xsl:variable>
                            <xsl:variable name="page-subtitle"
                                          select="/site:site/site:page/page-attributes/page-attribute[@name='untertitel' and @page=$page-id]/@value"/>
                            <li class="menu-item-media menu-item-media-{@id}{$active}">
                                <a href="{@url}" class="main-menu-link">
                                    <xsl:choose>
                                        <xsl:when test="string-length( $page-subtitle ) &gt; 0">
                                            <div class="main-menu-subtitle">
                                                <xsl:value-of select="$page-subtitle"/>
                                            </div>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <div class="main-menu-subtitle">
                                                <xsl:value-of select="."/>
                                            </div>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </a>
                            </li>
                        </xsl:for-each>
                    </ul>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>

</xsl:stylesheet>