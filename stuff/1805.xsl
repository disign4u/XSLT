<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:site="http://xmlns.webmaking.ms/site/" xmlns:content="http://xmlns.webmaking.ms/content/" exclude-result-prefixes="site content" xmlns:func="http://exslt.org/functions" xmlns:math="http://exslt.org/math" xmlns:exslt="http://exslt.org/common" xmlns:str="http://exslt.org/strings" extension-element-prefixes="func math exslt str">
	<xsl:variable name="tao-id" select="0" />
	<!--
		eingabe:    language string ID [, zusatztext [, language iso code ] ]
		rückgabe    übersetzte string

		beispiel:   content:ls('back home')         content:ls('back home','','en')     content:ls('main page','Lorem Ipsum')
		            gibt: Zurück zur Startseite     gibt: Back to the Homepage          gibt: Lorem Ipsum Übersichtsseite
	-->
	<func:function name="content:ls">
		<xsl:param name="ls" />
		<xsl:param name="secondary-text" select="''" />
		<xsl:param name="lang" select="/site:site/site:page/@page-language-iso" />

		<func:result><xsl:choose>
			<xsl:when test="$ls='lorem'">
				<xsl:choose>
					<xsl:when test="$lang='de'">ipsum</xsl:when>
					<xsl:when test="$lang='fr'">dolor</xsl:when>
					<xsl:when test="$lang='it'">sit</xsl:when>
					<xsl:otherwise>amet</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="content:ls-nst( $ls, $secondary-text, $lang )"/></xsl:otherwise>
		</xsl:choose></func:result>
	</func:function>

	<cms:description xmlns:cms="http://xmlns.webmaking.ms/cms/">
		<cms:name>Website (NST)</cms:name>
		<cms:created>
			<cms:name>FrontEnd Team</cms:name>
			<cms:company>vioma GmbH</cms:company>
			<cms:email>websites@vioma.de</cms:email>
		</cms:created>
		<cms:less source="../../data/customer-templates/nst/2015/nst2015-include.less" target="static/template-{template_id}/css/config.less" />
		<cms:layout>
			<table xmlns:cms="http://xmlns.webmaking.ms/cms/" border="1" cellpadding="0" cellspacing="0">
				<tr>
					<td><cms:content type="content" name="logo" width="150" height="50" /></td>
					<td><cms:content type="content" name="nav" width="300" height="50" /></td>
					<td><cms:content type="content" name="tools" width="150" height="50" /></td>
				</tr>
				<tr>
					<td colspan="3"><cms:content type="content" name="gallery" width="600" height="400" /></td>
				</tr>
				<tr>
					<td colspan="3"><cms:content type="content" name="widget" width="600" height="50" /></td>
				</tr>
				<!--<tr>
					<td colspan="3"><cms:content type="content" name="actions" width="600" height="50" /></td>
				</tr>-->
				<tr>
					<td colspan="3"><cms:content type="content" name="content" width="600" height="400" /></td>
				</tr>
				<tr>
					<td colspan="3"><cms:content type="content" name="footer" width="600" height="100" /></td>
				</tr>
				<tr>
					<td colspan="3"><cms:content type="content" name="partners" width="600" height="100" /></td>
				</tr>
				<tr>
					<td colspan="3"><cms:content type="content" name="cookie-hint" width="600" height="100"/></td>
				</tr>
			</table>
		</cms:layout>
		<cms:page-attributes>
			<!--<page-attribute name="type" type="content" always="0" relation="struct">
				<page-attribute-content name="type-a" />
				<page-attribute-content name="type-b" />
				<page-attribute-content name="type-c" />
				<page-attribute-content name="type-d" />
			</page-attribute>-->
			<page-attribute name="special-page" type="text" always="1" relation="struct" />
			<page-attribute name="untertitel" type="text" always="1" relation="page" />
		</cms:page-attributes>
		<cms:content-attributes>
			<content-attribute name="layout" type="content">
				<content-attribute-content name="spalten" />
				<content-attribute-content name="spalte-doppelbreite" />
				<content-attribute-content name="spalte-volle-breite" />
				<content-attribute-content name="kacheln" />
				<content-attribute-content name="kacheln-klein" />
				<content-attribute-content name="kacheln-gross" />
				<content-attribute-content name="karte" />
				<content-attribute-content name="parallax" />
				<content-attribute-content name="responsive-formular" />
			</content-attribute>
			<content-attribute name="hintergrund" type="content">
				<content-attribute-content name="hauptfarbe" />
				<content-attribute-content name="nebenfarbe" />
				<content-attribute-content name="hell" />
				<content-attribute-content name="akzent" />
				<content-attribute-content name="schriftfarbe" />
				<content-attribute-content name="bild" />
				<content-attribute-content name="bild-wiederholt" />
			</content-attribute>
			<content-attribute name="hintergrund-bild-id" type="text" />
			<content-attribute name="sprungmarke" type="text" />
			<content-attribute name="akkordeon-titel" type="text" />
		</cms:content-attributes>
	</cms:description>

	<xsl:include href="../../../data/customer-templates/nst/2015/nst2015-include.xsl" />

	<!-- Zusatz css und js:
		<site:combine action="include" href="pfad/zur/datei.css" />
	-->
	<xsl:template name="nst15-custom-css">
		<link rel="stylesheet" type="text/css" site:combine="true">
			<site:combine action="include" href="/static/template-1805/css/animate.css" />
		</link>
	</xsl:template>

	<xsl:template name="nst15-custom-js">
		<site:combine action="include" href="/static/template-1805/js/site.js" />
		<!--<script type="text/javascript">mg2015.opt.std_domain = '<xsl:value-of select="$dev_domain" />';</script>-->
	</xsl:template>

	<!-- Ersatzstring für condeon (jQuery@1.11.0,jQuery-UI@1.11.4,jQuery-flexslider@2.5.0,nst@2015) -->
	<xsl:template name="nst15-custom-lib-versions" />

	<!-- Zusatz HEAD Elemente
		script, meta, link...
	-->

	<xsl:template name="nst15-custom-head">
		<script type="text/javascript" site:shake="false">
			window['nst_manual_init']=true;
		</script>
	</xsl:template>

	<!-- ######## HEADER ######## -->
	<xsl:template match="site:match-space/header">
		<header id="header" class="header" data-variant="{$nst-template-settings[@name='variant-header']/@value}" data-variant-logo="{$nst-template-settings[@name='variant-logo']/@value}">
			<div class="banner cf">
				<div class="top-menu">
					<xsl:apply-templates select="$site-content-item[@name='tools']" />
				</div>
				<!--<xsl:apply-templates select="$site-content-item[@name='logo']"/>-->
				<nav class="nav-level-0" role="navigation"><xsl:apply-templates select="$site-content-item[@name='nav']"/></nav>
			</div>
			<div class="gallery">
				<xsl:apply-templates select="$site-content-item[@name='gallery']" />
				<xsl:if test="$site-content-item[@name='widget']/*[1] and $nst-template-settings[@name='variant-template']/@value = 'A'">
					<div class="header-widget" data-variant="{$nst-template-settings[@name='variant-widget']/@value}">
						<xsl:apply-templates select="$site-content-item[@name='widget']"/>
					</div>
				</xsl:if>
			</div>
			<xsl:if test="$site-content-item[@name='quicklinks']/*[1]">
				<div class="quicklinks">
					<xsl:apply-templates select="$site-content-item[@name='quicklinks']"/>
				</div>
			</xsl:if>
			<xsl:apply-templates select="$site-content-item[@name='actions']"/>
		</header>
	</xsl:template>

	<xsl:template match="site:content-item[@name='tools']">
		<div class="top-menu-col left">
			<xsl:apply-templates select="*[1]"/>
		</div>
		<div class="top-menu-col logo">
			<xsl:apply-templates select="../site:content-item[@name='logo']"/>
		</div>
		<div class="top-menu-col right">
			<xsl:for-each select="*[position() &gt; 1]">
				<xsl:apply-templates select="."/>
			</xsl:for-each>
		</div>
		<div id="nav_menu_button" class="top-menu-col menu-button">
			<span class="menu-text">
				<xsl:value-of select="content:ls('menu')"/>
			</span>
			<span class="menu-icon"></span>
		</div>
	</xsl:template>

	<!-- ######## SVG LOGO ######## -->
	<xsl:template match="content:media-display[../@name='logo']">
		<!--<xsl:variable name="layout" select="@attr-layout"/> -->
		<xsl:choose>
			<xsl:when test="contains(media_preview_url,'.svg')">
				<!--svg ist die vorschau datei-->
				<xsl:variable name="svg" select="media_preview_url"/>
				<xsl:variable name="fallback" select="media_url"/>
				<xsl:variable name="alt" select="media_display/media_display_name"/>
				<xsl:variable name="link" select="/site:site/site:tree/menu[@level=0]/@url" />
				<a href="{$link}"><img src="{$fallback}" alt="{normalize-space($alt)}" srcset="{$svg} 1x"/></a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="max-w"><xsl:choose>
					<xsl:when test="media_display/media_display_width &gt;= 250">250</xsl:when>
					<xsl:otherwise><xsl:value-of select="media_display/media_display_width" /></xsl:otherwise>
				</xsl:choose></xsl:variable>
				<xsl:variable name="max-h"><xsl:choose>
					<xsl:when test="media_display/media_display_height &gt;= 250">250</xsl:when>
					<xsl:otherwise><xsl:value-of select="media_display/media_display_height" /></xsl:otherwise>
				</xsl:choose></xsl:variable>
				<xsl:call-template name="nst15-header-logo">
					<xsl:with-param name="media_id" select="media/media_file_id" />
					<xsl:with-param name="link" select="/site:site/site:tree/menu[@level=0]/@url" />
					<xsl:with-param name="logo_w" select="$max-w" />
					<xsl:with-param name="logo_h" select="$max-h" />
					<xsl:with-param name="hidpi" select="media_display/media_display_width &gt;= 500" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ######## GALLERY ######## -->
	<xsl:template match="content:gallery[../@name='gallery']" name="schliffkopf-header-gallery">
		<xsl:param name="gallery-items" select="gallery-items/*" />
		<xsl:variable name="slide-duration"><xsl:choose>
			<xsl:when test="gallery/mcg_slideshow = 1 and gallery/mcg_slideshow_time_pause &gt;= 0"><xsl:value-of select="gallery/mcg_slideshow_time_pause" /></xsl:when>
			<xsl:when test="$nst-template-settings[@name='header-gallery-slide-duration'] and number( $nst-template-settings[@name='header-gallery-slide-duration']/@value ) &gt;= 0"><xsl:value-of select="string( number( $nst-template-settings[@name='header-gallery-slide-duration']/@value ) )" /></xsl:when>
			<xsl:otherwise>7</xsl:otherwise>
		</xsl:choose></xsl:variable>
		<xsl:variable name="transition-duration"><xsl:choose>
			<xsl:when test="gallery/mcg_slideshow = 1 and gallery/mcg_slideshow_time &gt;= 0"><xsl:value-of select="gallery/mcg_slideshow_time" /></xsl:when>
			<xsl:when test="$nst-template-settings[@name='header-gallery-transition-duration'] and number( $nst-template-settings[@name='header-gallery-transition-duration']/@value ) &gt;= 0"><xsl:value-of select="string( number( $nst-template-settings[@name='header-gallery-transition-duration']/@value ) )" /></xsl:when>
			<xsl:otherwise>1</xsl:otherwise>
		</xsl:choose></xsl:variable>
		<xsl:variable name="id" select="generate-id()" />

		<xsl:call-template name="gallery-flex">
			<xsl:with-param name="control-nav" select="false()" />
			<xsl:with-param name="items" select="$gallery-items" />
			<xsl:with-param name="direction-nav" select="contains( ',always,desktop,', concat(',',$nst-template-settings[@name='header-gallery-controls']/@value,',' ) )" />
			<xsl:with-param name="prev-text" select="''" />
			<xsl:with-param name="next-text" select="''" />
			<xsl:with-param name="animation-loop" select="true()" />
			<xsl:with-param name="domain" select="$dev_domain" />
			<xsl:with-param name="open-graph" select="true()" />
			<xsl:with-param name="slide-duration" select="1000 * $slide-duration" />
			<xsl:with-param name="transition-duration" select="1000 * $transition-duration" />
			<xsl:with-param name="img-tag" select="true()" />
			<xsl:with-param name="display-pois" select="@attr-layout!='pois-fixed' or not(@attr-layout)" />
		</xsl:call-template>

		<xsl:if test="contains( ',left,right,', concat(',',$nst-template-settings[@name='header-gallery-control-fullscreen']/@value,',') )">
			<div class="gallery-fullscreen">
				<span class="gallery-fullscreen-text">
					<xsl:value-of select="content:ls('fullscreen')"/>
				</span>
				<span class="gallery-fullscreen-text-back">
					<xsl:value-of select="content:ls('fullscreen-back')"/>
				</span>
			</div>
		</xsl:if>

		<xsl:if test="@attr-layout = 'pois-fixed'">
			<xsl:apply-templates select="gallery-items/*[1]/pois">
				<xsl:with-param name="container-id">g<xsl:value-of select="$id" /></xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>

	</xsl:template>

	<xsl:template match="content:proxy1[../@name='gallery' and ( count(xml/gallery-items/*) &gt; 0 or xml/overlay )]">
		<xsl:if test="count(xml/gallery-items/*) &gt; 0">
			<xsl:call-template name="nst-header-gallery">
				<xsl:with-param name="gallery-items" select="xml/gallery-items/*" />
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="xml/overlay">
			<div class="cst-overlay">
				<xsl:copy-of select="xml/overlay/node()" />
			</div>
		</xsl:if>
	</xsl:template>
	<xsl:template match="content:gallery[../@name='gallery']/gallery-items/*/pois">
		<xsl:for-each select="*">
			<xsl:variable name="poi-id" select="generate-id()" />
			<xsl:variable name="poi-color">poi-normal</xsl:variable>
			<xsl:variable name="x" select="number( media_poi_left ) div number( media_poi_media_width )" />
			<xsl:variable name="y" select="number( media_poi_top ) div number( media_poi_media_height )" />
			<xsl:variable name="pos-x"><xsl:choose>
				<xsl:when test="$x&lt;0.333">left</xsl:when>
				<xsl:when test="$x&lt;0.666">center</xsl:when>
				<xsl:otherwise>right</xsl:otherwise>
			</xsl:choose></xsl:variable>
			<xsl:variable name="pos-y"><xsl:choose>
				<xsl:when test="$y&lt;0.333">top</xsl:when>
				<xsl:when test="$y&lt;0.666">middle</xsl:when>
				<xsl:otherwise>bottom</xsl:otherwise>
			</xsl:choose></xsl:variable>

			<a class="container {$poi-color}" id="poi_{$poi-id}">
				<xsl:variable name="link" select="(media_poi_text_xml//a[@href])[1]" />
				<xsl:if test="$link/@href"><xsl:attribute name="href"><xsl:value-of select="$link/@href" /></xsl:attribute></xsl:if>
				<xsl:if test="$link/@target='_blank'"><xsl:attribute name="onclick">this.target='_blank';</xsl:attribute></xsl:if>
				<div class="poi animated">
					<div class="poi-text ">
						<!--<xsl:value-of select="media_poi_text" disable-output-escaping="yes" />-->
						<xsl:apply-templates select="media_poi_text_xml/node()" />
					</div>
				</div>
			</a>

		</xsl:for-each>
		<xsl:variable name="transform">transform: rotate(0deg) translateX(-50%) translateY(-50%)</xsl:variable>
		<xsl:variable name="poi-styles">
			<xsl:for-each select="*">
				<xsl:variable name="poi-id" select="generate-id()" />
				<xsl:variable name="x" select="number( media_poi_left ) div number( media_poi_media_width )" />
				<xsl:variable name="y" select="number( media_poi_top ) div number( media_poi_media_height )" />
				#poi_<xsl:value-of select="$poi-id" />{
					left:<xsl:value-of select="format-number(100*$x,'#.###')" />%;
					top:<xsl:value-of select="format-number(100*$y,'#.###')" />%;
				}
				#poi_<xsl:value-of select="$poi-id" />:hover {
					transform: scale(1.1);
				}
			</xsl:for-each>
		</xsl:variable>

		<!--<style type="text/css"><xsl:value-of select="normalize-space($poi-styles)" /></style>-->
	</xsl:template>

	<xsl:template match="media_poi_text_xml//*">
		<xsl:choose>
			<xsl:when test="name() = 'a'">
				<span class="poi-link">
					<xsl:apply-templates select="node()" />
				</span>
			</xsl:when>
			<xsl:when test="self::text()"><xsl:value-of select="text()" /></xsl:when>
			<xsl:otherwise>
				<xsl:element name="{name(.)}">
					<xsl:for-each select="@*">
						<xsl:attribute name="{name(.)}"><xsl:value-of select="."/></xsl:attribute>
					</xsl:for-each>
					<xsl:apply-templates select="node()" />
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="content:menu1[ancestor::site:content-item[@name='nav']]">
		<ul class="main-menu" id="nav_menu">
			<xsl:for-each select="/site:site/site:tree/menu[@level=0]/*">
				<xsl:variable name="position" select="position()"/>
				<xsl:variable name="struct" select="@struct" />
				<xsl:variable name="page" select="@id" />
				<xsl:variable name="struct_children" select="/site:site/site:tree/menu[@struct=$struct]/*" />
				<xsl:variable name="struct_children_num" select="count($struct_children)" />

				<li class="main-menu-item">
					<!--<xsl:if test="@state='active'"><xsl:attribute name="class">main-menu-item active</xsl:attribute></xsl:if>-->
					<xsl:attribute name="class">main-menu-item menu-<xsl:value-of select="$position"/><xsl:if test="not( $struct_children_num )"> menu-single</xsl:if><xsl:if test="@state = 'active'"> active open-mobile</xsl:if></xsl:attribute>
					<a href="{@url}"><xsl:value-of select="." /></a>

					<xsl:variable name="mixed-menu">
						<xsl:for-each select="/site:site/site:tree/menu[@struct=$struct]/*">
							<xsl:variable name="struct-pid" select="@struct"/>
							<xsl:variable name="count-sub"
							              select="count(/site:site/site:tree/menu[@struct=$struct-pid]/*)"/>
							<xsl:if test="$count-sub &lt; 0 "><xsl:value-of select="$struct-pid"/></xsl:if>
						</xsl:for-each>
					</xsl:variable>

					<xsl:if test="$struct_children_num &gt; 0">
						<div class="sub-menu-button"><xsl:text/></div>
						<div class="sub-menu" id="sub-{@struct}">
							<!--<div class="sub-menu-overview"><a href="{@url}"><xsl:value-of select="content:ls('to main page')" /></a></div>-->

							<ul class="sub-menu-items">
								<xsl:for-each select="$struct_children[position() &lt; 4 or (position() = 4 and $struct_children_num = 4)]">
									<xsl:variable name="active"><xsl:if test="@state='active'"> active</xsl:if></xsl:variable>
									<li class="menu-item-media menu-item-media-{@struct}{$active}">
										<a href="{@url}">
											<!-- Title oder Untertile-->
											<xsl:variable name="page-id" select="@id"/>
											<xsl:choose>
												<xsl:when
														test="/site:site/site:page/page-attributes/*[@name='untertitel' and @page = $page-id]">
													<xsl:value-of
															select="/site:site/site:page/page-attributes/*[@name='untertitel' and @page = $page-id]/@value"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="."/>
												</xsl:otherwise>
											</xsl:choose>
											<!--Error mixed menüs sind nicht erlaubt-->
											<xsl:if test="@struct = $mixed-menu">
												<div class="error"><xsl:value-of select="$mixed-menu"/></div>
											</xsl:if>
										</a>
										<xsl:variable name="struct_sub" select="@struct"/>
										<xsl:variable name="struct_children_sub" select="/site:site/site:tree/menu[@struct=$struct_sub]/*"/>
										<xsl:variable name="struct_children_sub_count" select="count($struct_children_sub)"/>
										<xsl:if test="$struct_children_sub_count &gt; 0">
											<ul>
												<xsl:for-each select="$struct_children_sub[position() &lt; 4 or (position() = 4 and $struct_children_sub_count = 4)]">
													<xsl:variable name="sub_active"><xsl:if test="@state='active'"> sub_active</xsl:if></xsl:variable>
													<li class="menu-item-sub-{@struct}{$sub_active}">
														<a href="{@url}" class="{$sub_active}">
															<xsl:value-of select="."/>
														</a>
													</li>
												</xsl:for-each>
											</ul>
										</xsl:if>
									</li>
								</xsl:for-each>
								<xsl:if test="$struct_children_num &gt; 4">
									<li class="menu-items-next">
										<ul>
											<xsl:for-each select="$struct_children[position() &gt;= 4]">
												<xsl:variable name="active"><xsl:if test="@state='active'"> active</xsl:if></xsl:variable>
												<li class="menu-item{$active}">
													<a href="{@url}"><xsl:value-of select="." /></a>
												</li>
											</xsl:for-each>
										</ul>
									</li>
								</xsl:if>
							</ul>
						</div>
					</xsl:if>
				</li>
				<xsl:if test="$position=2">
					<li class="main-menu-item empty"></li>
				</xsl:if>
			</xsl:for-each>
		</ul>
		<xsl:for-each select="/site:site/site:tree/menu[@level=0]/*">

		</xsl:for-each>
		<xsl:variable name="menu-images-css">

			@media (min-width: 960px) {
			<xsl:for-each select="/site:site/site:page/page-attributes/*[@name='menü-bild' and @value &gt; 0]">
				.menu-item-media-<xsl:value-of select="@struct" />::before {
				background-image: url( '<xsl:value-of select="$dev_domain" />/(cms)/media/resize/size=190x190,scale=crop,quality=80/<xsl:value-of select="@value" />' );
				}
			</xsl:for-each>
			}
			@media (min-width: 1150px) {
			<xsl:for-each select="/site:site/site:page/page-attributes/*[@name='menü-bild' and @value &gt; 0]">
				.menu-item-media-<xsl:value-of select="@struct" />::before {
				background-image: url( '<xsl:value-of select="$dev_domain" />/(cms)/media/resize/size=190x220,scale=crop,quality=80/<xsl:value-of select="@value" />' );
				}
			</xsl:for-each>
			}
			@media (min-width: 1150px) and (-webkit-min-device-pixel-ratio: 2), (min-width: 1150px) and (min-resolution: 192dpi) {
			<xsl:for-each select="/site:site/site:page/page-attributes/*[@name='menü-bild' and @value &gt; 0]">
				.menu-item-media-<xsl:value-of select="@struct" />::before {
				background-image: url( '<xsl:value-of select="$dev_domain" />/(cms)/media/resize/size=380x440,scale=crop,quality=80/<xsl:value-of select="@value" />' );
				}
			</xsl:for-each>
			}
		</xsl:variable>
		<!-- Preload -->
		<xsl:variable name="menu-images-js">
			!( function(){
			var size = !window.devicePixelRatio || window.devicePixelRatio == 1 ? '190x220' : '380x440';
			<xsl:for-each select="/site:site/site:page/page-attributes/*[@name='menü-bild' and @value &gt; 0]">
				(document.createElement('img')).src = '<xsl:value-of select="$dev_domain" />/(cms)/media/resize/size='+size+',scale=crop,quality=80/<xsl:value-of select="@value" />';
			</xsl:for-each> } )();
		</xsl:variable>
		<script type="text/javascript"><xsl:value-of select="normalize-space($menu-images-js)" /></script>
		<style type="text/css"><xsl:value-of select="normalize-space($menu-images-css)" /></style>
	</xsl:template>

	<!-- ######## NAVIGATION ######## -->
	<xsl:template match="content:menu1[../@name='nav_']" name="mega-nav">
		<xsl:param name="level" select="0" />
		<xsl:choose>
			<xsl:when test="$level = 0">
				<div class="menu" id="nav_menu">
					<xsl:apply-templates select="/site:site/site:page/languages" />
					<ul class="nav-mega">
						<xsl:for-each select="/site:site/site:tree/menu[@level=0]/*[position() &lt;= 4]">
							<xsl:variable name="position" select="position()" />
							<xsl:variable name="page-id" select="@id" />
							<xsl:variable name="struct" select="@struct" />
							<xsl:variable name="subpages" select="/site:site/site:tree/menu[@struct=$struct]/*" />
							<xsl:variable name="has-subpages" select="count( $subpages ) &gt; 0" />
							<li>
								<xsl:variable name="page-subtitle" select="/site:site/site:page/page-attributes/page-attribute[@name='untertitel' and @page=$page-id]/@value" />
								<xsl:attribute name="class"><xsl:choose>
									<xsl:when test="$position &gt; 2">nav-mega-right</xsl:when>
									<xsl:otherwise>nav-mega-left</xsl:otherwise>
								</xsl:choose> main-menu-item menu-<xsl:value-of select="$position"/><xsl:if test="not( $has-subpages )"> menu-single</xsl:if><xsl:if test="@state = 'active'"> active open-mobile</xsl:if></xsl:attribute>
								<a href="{@url}" class="main-menu-link">
								<xsl:choose>
										<xsl:when test="string-length( $page-subtitle ) &gt; 0"><div class="main-menu-subtitle"><xsl:value-of select="$page-subtitle" /></div></xsl:when>
										<xsl:otherwise><div class="main-menu-subtitle"><xsl:value-of select="." /></div></xsl:otherwise>
									</xsl:choose>
								</a>
								<xsl:if test="count(/site:site/site:content/site:content-item[@name='nav-content-1']) &gt; 0">
									<xsl:apply-templates select="/site:site/site:content/site:content-item[@name=concat('nav-content-',$position)]" />
								</xsl:if>
							</li>
							<xsl:if test="$position=2">
								<li class="nav-mega-col empty"><!--empty--></li>
							</xsl:if>
						</xsl:for-each>
					</ul>
				</div>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="/site:site/site:content/site:content-item[@name='nav-content-1' or @name='nav-content-2' or @name='nav-content-3' or @name='nav-content-4']">
		<ul>
			<xsl:for-each select="./*">
			<xsl:variable name="name" select="name()"/>
				<xsl:choose>
					<xsl:when test="$name='content:media-display'">
						<li class="nav-mega-item">
							<xsl:apply-templates select="."/>
						</li>
					</xsl:when>
					<xsl:when test="$name='content:article1'">
						<li class="nav-mega-item">
							<xsl:apply-templates select="."/>
						</li>
					</xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</ul>
	</xsl:template>


	<xsl:template match="content:media-display[media/media_file_class = 1 and contains(../@name, 'nav-content')]">
		<xsl:variable name="test_domain">https://cms-3146-678.viomassl.com</xsl:variable>
		<xsl:variable name="image">
			<img src="{$test_domain}/(cms)/media/resize/size=450x0,quality=70,interlace=1/{media/media_file_id}" alt="{normalize-space(media_display/media_display_name)}" onclick="return false;">
			<xsl:attribute name="alt"><xsl:value-of select="media_display/media_display_alt" /></xsl:attribute>
		</img></xsl:variable>
		<!--Fancybox Caption-->
		<xsl:choose>
			<xsl:when test="media_display/media_display_controls = 1">
				<a href="{$test_domain}/(cms)/media/resize/size=1024x0,quality=70,interlace=1/{media/media_file_id}"
				   data-fancybox-title="{normalize-space(media_display/media_display_name)}"
				   data-fancybox-type="image"
				   class="fancybox animated" >
					<xsl:copy-of select="$image" />
					<xsl:if test="media_display/media_display_class='caption'">
						<figcaption class="mask">
							<xsl:copy-of select="media_display/media_display_description_xml/xml/node()" />
						</figcaption>
					</xsl:if>
					<ul class="external">
						<li class="zoom"></li>
					</ul>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$image" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

<!--	<xsl:template match="content:article1[contains(../@name, 'nav-content')]">
		<div class=""><a href="">2</a></div>
	</xsl:template>-->

	<!-- ######## MEDIA DISPLAY INFOBOX ######## -->
	<xsl:template match="members/content:media-display[media/media_file_class = 1]">
		<xsl:variable name="cols" select="count( ../* ) + count( ../*[@attr-layout='spalte-doppelbreite'] ) - count( ../*[@attr-layout='spalte-volle-breite'] )" />
		<xsl:variable name="layout" select="@attr-layout"/>
		<xsl:variable name="width"><xsl:choose>
			<xsl:when test="@attr-layout='spalte-volle-breite'">100</xsl:when>
			<xsl:when test="@attr-layout='spalte-doppelbreite' and $cols = 2">100</xsl:when>
			<xsl:when test="@attr-layout='spalte-doppelbreite' and $cols = 3">66.666</xsl:when>
			<xsl:when test="@attr-layout='spalte-doppelbreite' and $cols = 4">50</xsl:when>
			<xsl:when test="$cols = 2">50</xsl:when>
			<xsl:when test="$cols = 3">33.333</xsl:when>
			<xsl:when test="$cols = 4">25</xsl:when>
		</xsl:choose></xsl:variable>

		<xsl:variable name="image"><img src="{$dev_domain}/(cms)/media/resize/size=1200x0,quality=70,interlace=1/{media/media_file_id}" width="{media_display/media_display_width}" height="{media_display/media_display_height}" alt="{normalize-space(media_display/media_display_name)}" onclick="return false;">
			<xsl:variable name="sizes">
				<xsl:if test="number( $width ) &lt; 50">(min-with:960px) 33.333vw, </xsl:if>
				<xsl:if test="number( $width ) &gt; 50 and number( $width ) &lt; 100">(min-with:960px) 66.666vw, </xsl:if>
				<xsl:if test="number( $width ) &lt; 100">(min-with:640px) 50vw, (max-width: 639px)</xsl:if>
				100vw
			</xsl:variable>
			<xsl:variable name="srcset">
				<xsl:value-of select="$dev_domain" />/(cms)/media/resize/size=480x0%2Cquality=70%2Cinterlace=1/<xsl:value-of select="media/media_file_id" /> 480w,
				<xsl:value-of select="$dev_domain" />/(cms)/media/resize/size=640x0%2Cquality=70%2Cinterlace=1/<xsl:value-of select="media/media_file_id" /> 640w,
				<xsl:value-of select="$dev_domain" />/(cms)/media/resize/size=960x0%2Cquality=70%2Cinterlace=1/<xsl:value-of select="media/media_file_id" /> 960w,
				<xsl:value-of select="$dev_domain" />/(cms)/media/resize/size=1200x0%2Cquality=70%2Cinterlace=1/<xsl:value-of select="media/media_file_id" /> 1200w
			</xsl:variable>
			<xsl:attribute name="sizes"><xsl:value-of select="normalize-space($sizes)" /></xsl:attribute>
			<xsl:attribute name="srcset"><xsl:value-of select="normalize-space($srcset)" /></xsl:attribute>
			<xsl:attribute name="alt"><xsl:value-of select="media_display/media_display_alt" /></xsl:attribute>
		</img>
		</xsl:variable>

		<!--Fancybox Caption-->
		<xsl:choose>
			<xsl:when test="$layout='infobox'">
				<div class="infobox">
					<a href="{$dev_domain}/(cms)/media/resize/size=1024x0,quality=70,interlace=1/{media/media_file_id}"
					   data-fancybox-title="{normalize-space(media_display/media_display_name)}"
					   data-fancybox-type="image"
					   class="fancybox animated" >
						<xsl:copy-of select="$image" />
						<ul class="external">
							<li class="zoom"></li>
						</ul>
					</a>
					<div class="infobox-text">
						<xsl:copy-of select="media_display/media_display_description_xml/xml/node()" />
					</div>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$image" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>