<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl" xmlns:site="http://xmlns.webmaking.ms/site/" xmlns:content="http://xmlns.webmaking.ms/content/" exclude-result-prefixes="site content" xmlns:func="http://exslt.org/functions" xmlns:math="http://exslt.org/math" xmlns:exslt="http://exslt.org/common" xmlns:str="http://exslt.org/strings" extension-element-prefixes="func math exslt str php">

	<xsl:include href="../../../modules/customer/2/content/misc_services/xsl/fe.xsl" />
	<xsl:include href="../../../modules/customer/2/content/tao_pixel/xsl/fe.xsl" />
	<xsl:include href="../../../modules/customer/2/content/default_templates/xsl/general.xsl" />

	<cms:description xmlns:cms="http://xmlns.webmaking.ms/cms/">
		<cms:name>Website</cms:name>
		<cms:created>
			<cms:name>Mathieu Grandadam</cms:name>
			<cms:company>vioma GmbH</cms:company>
			<cms:email>mtg@vioma.de</cms:email>
		</cms:created>
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
				<tr>
					<td colspan="3"><cms:content type="content" name="breadcrumb" width="600" height="50" /></td>
				</tr>
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
					<td colspan="3"><cms:content type="content" name="cookie-hint" width="600" height="50" /></td>
				</tr>
			</table>
		</cms:layout>
		<cms:page-attributes>
			<page-attribute name="seitenthema" type="content" always="0" relation="struct">
				<page-attribute-content name="spa" />
				<page-attribute-content name="gesundheit" />
				<page-attribute-content name="golf" />
				<page-attribute-content name="familie" />
			</page-attribute>
			<page-attribute name="menü-bild" type="text" always="1" relation="struct" />
		</cms:page-attributes>
		<cms:content-attributes>
			<page-attribute name="sprungmarke" type="text" />
			<content-attribute name="layout" type="content">
				<content-attribute-content name="spalten" />
				<content-attribute-content name="spalte-volle-breite" />
				<content-attribute-content name="spalte-doppelbreite" />
				<content-attribute-content name="spalte-platzhalter" />
				<content-attribute-content name="poster" />
				<content-attribute-content name="kacheln" />
				<content-attribute-content name="themenraster" />
			</content-attribute>
			<content-attribute name="hintergrund" type="content">
				<content-attribute-content name="weiss" />
				<content-attribute-content name="weiss-motive" />
				<content-attribute-content name="braun-hell" />
				<content-attribute-content name="braun-dunkel" />
				<content-attribute-content name="grau-warm" />
				<content-attribute-content name="himbeer" />
				<content-attribute-content name="bild-abdeckend" />
				<content-attribute-content name="bild-zentriert" />
				<content-attribute-content name="bild-wiederholt" />
			</content-attribute>
			<page-attribute name="hintergrund-bild-id" type="text" />
		</cms:content-attributes>
	</cms:description>

	<xsl:variable name="current_lang" select="/site:site/site:page/@page-language-iso" />
	<xsl:variable name="legacy" select="boolean( site:site/site:env/site:user-agent[@name='msie' and @version &lt; 9] )" />
	<xsl:variable name="dev_domain"><xsl:if test="/site:site/site:env/site:vars/dev = 'yes'"><xsl:value-of select="/site:site/site:website/@domain-standard-uri" /></xsl:if></xsl:variable>

	<xsl:variable name="cst_webdev_domain">http://master-channel-822-lydc.cst.mtg.w.og.vioma.de</xsl:variable>
	<xsl:variable name="cst_shareweb_http_domain">http://channel-822-lydc.clients.clearingstation.de</xsl:variable>
	<xsl:variable name="cst_shareweb_https_domain">https://cst-client-channel-822-lydc.viomassl.com</xsl:variable>

	<xsl:template match="site:site">
		<html lang="{$current_lang}">
			<head>
				<xsl:call-template name="site:page-head-tags"/>
				<meta name="viewport" content="initial-scale=1" />
				<meta property="og:title" content="{/site:site/site:website/@website-name}, {/site:site/site:page/@page-name}"/>
				<meta property="og:type" content="website" />
				<meta property="og:url" content="{/site:site/site:page/@page-url-canonical}"/>
				<link rel="icon" type="image/png" href="/static/template-{site:template/@template-id}/i/favicon.png"/>
				<link rel="stylesheet" type="text/css" site:combine="true" site:lib-versions="jQuery@1.11.0,jQuery-UI@1.11.4,jQuery-flexslider@2.5.0,Cookies@1.4.1">
					<site:combine action="include" lib="reset" />
					<site:combine action="include" lib="jQuery-UI" />
					<site:combine action="include" lib="fontawesome" />
					<site:combine action="include" lib="jQuery-fancybox" />
					<site:combine action="include" lib="jQuery-fancybox-helper-thumbs" />
					<site:combine action="include" lib="vsrh" /><!-- search result highlight -->
					<site:combine action="include" href="/static/template-{site:template/@template-id}/css/site.less" />
					<site:combine action="dismiss" href="/(cms)/module/static/customer/2/content/social_media/css/default.css" />
					<site:combine action="dismiss" href="/(cms)/module/static/customer/2/content/social_media/css/socialmedia-moz-webkit.css" />
					<site:combine action="dismiss" href="/(cms)/module/static/customer/2/content/weblog/css/weblog-layout-1.css" />
					<site:combine action="include" href="/(cms)/module/static/default/content/search_box1/css/search_box.css" />
					<site:combine action="dismiss" href="/(cms)/module/static/customer/2/content/social_media/css/default-buttons.css?v1" />
					<site:combine action="include" href="{$cst_webdev_domain}/css/html5.css" />
					<site:combine action="dismiss" href="{$cst_shareweb_http_domain}/css/html5.css" />
					<site:combine action="dismiss" href="{$cst_shareweb_https_domain}/css/html5.css" />
				</link>
				<link href="https://fonts.googleapis.com/css?family=Lato:400,300,400italic,300italic|Courgette" rel="stylesheet" type="text/css" />
				<xsl:if test="$legacy">
					<script site:shake="false" type="text/javascript" site:combine="true">
						<site:combine action="include" lib="html5shiv" />
					</script>
				</xsl:if>
				<script type="text/javascript" site:combine="true">
					<site:combine action="include" lib="ehandler" />
					<site:combine action="include" href="/(cms)/module/static/default/content/libs/js/general.js" />
					<site:combine action="include" lib="jQuery" />
					<site:combine action="include" lib="jQuery-UI" />
					<site:combine action="include" href="/static/template-{site:template/@template-id}/js/datepicker-{$current_lang}.js" />
					<site:combine action="include" lib="jQuery-flexslider" />
					<site:combine action="include" lib="jQuery-fancybox" />
					<site:combine action="include" lib="jQuery-fancybox-helper-thumbs" />
					<site:combine action="include" lib="Cookies" />
					<site:combine action="include" lib="dotdotdot" />
					<site:combine action="include" lib="vnh" />
					<site:combine action="include" lib="vsrh" /><!-- search result highlight -->
					<site:combine action="include" href="/static/template-{site:template/@template-id}/js/preistabelle.js" />
					<site:combine action="include" href="/static/template-{site:template/@template-id}/js/site.js" />
					<site:combine action="include" href="/(cms)/module/static/customer/2/content/social_media/js/social_media.js" />
					<site:combine action="include" href="/(cms)/module/static/customer/2/content/social_media/js/functions.js" />
					<site:combine action="include" href="/(cms)/module/static/customer/2/content/social_media/js/socialshareprivacy/jquery.socialshareprivacy.js" />
				</script>
				<script type="text/javascript">nst2015.opt.std_domain='<xsl:value-of select="$dev_domain" />';</script>
			</head>
			<body>
				<xsl:if test="boolean( site:env/site:user-agent[(@name='msie' and @version &lt; 9) or @name='firefox'] )">
					<xsl:attribute name="class">select-w</xsl:attribute>
				</xsl:if>
				<div id="site" class="site">
					<header id="header" class="header">
						<div class="banner">
							<nav id="nav_mobile">
								<div class="line line-n1"></div>
								<div class="line line-n2"></div>
								<div class="line line-n3"></div>
								<div class="menu"><xsl:value-of select="content:ls('menu')" /></div>
							</nav>
							<xsl:apply-templates select="site:content/site:content-item[@name='logo']"/>
							<nav id="nav_0" class="nav-level-0">
								<xsl:apply-templates select="site:content/site:content-item[@name='nav']"/>
							</nav>
						</div>
						<div class="tools">
							<xsl:apply-templates select="site:content/site:content-item[@name='tools']"/>
						</div>
						<div class="gallery">
							<xsl:if test="site:content/site:content-item[@name='gallery']/*[1]">
								<xsl:apply-templates select="site:content/site:content-item[@name='gallery']/*[position()=last()]"/>
							</xsl:if>
						</div>
						<xsl:if test="site:content/site:content-item[@name='widget']/*[1]">
							<div class="header-widget">
								<xsl:if test="string-length( /site:site/site:page/page-attributes/page-attribute[@name='buchen-anfragen-farbe']/@value ) &gt; 0">
									<xsl:attribute name="data-color"><xsl:value-of select="/site:site/site:page/page-attributes/page-attribute[@name='buchen-anfragen-farbe']/@value" /></xsl:attribute>
								</xsl:if>
								<a class="anchor-main" href="#main"><xsl:text /></a>
								<xsl:apply-templates select="site:content/site:content-item[@name='widget']"/>
							</div>
						</xsl:if>
					</header>
					<main id="main">
						<xsl:apply-templates select="site:content/site:content-item[@name='breadcrumb']/*[position()=last()]"/>
						<xsl:apply-templates select="site:content/site:content-item[@name='content']"/>
					</main>
					<footer class="footer">
						<div class="footer-infos">
							<xsl:apply-templates select="site:content/site:content-item[@name='footer']"/>
						</div>
						<div class="footer-partners">
							<xsl:apply-templates select="site:content/site:content-item[@name='partners']"/>
						</div>
					</footer>
				</div>
				<div id="layout"/>
				<!-- tracking -->
				<xsl:apply-templates select="site:content/site:content-item[@name='cookie-hint']"/>
				<xsl:call-template name="page-theme-cookie" />
				<xsl:call-template name="content:tao-pixel">
					<xsl:with-param name="tao-object" select="6" />
				</xsl:call-template>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="page-theme-cookie">
		<xsl:variable name="seitenthema" select="/site:site/site:page/page-attributes/*[@name='seitenthema']/@value" />
		<xsl:if test="string-length($seitenthema) &gt; 0">
			<xsl:variable name="single-quote">'</xsl:variable>
			<xsl:variable name="theme-cookie-js">
				nst2015.opt.page_theme = '<xsl:value-of select="translate($seitenthema,$single-quote,'’')" />';
			</xsl:variable>
			<script type="text/javascript"><xsl:value-of select="normalize-space($theme-cookie-js)" /></script>
		</xsl:if>
	</xsl:template>

	<!-- ######## CONTENT & FOOTER ######## -->

	<xsl:template name="internal-nav">
		<xsl:variable name="nodes" select="../*[@attr-sprungmarke]" />
		<xsl:variable name="this-anchor" select="@attr-sprungmarke" />
		<xsl:if test="count( $nodes ) &gt; 1 and string-length( $this-anchor ) &gt; 0">
			<nav class="internal-nav" id="{php:functionString('cms_fe_fw::str_clean_id',$this-anchor)}">
				<xsl:for-each select="$nodes">
					<span>
						<xsl:if test="@attr-sprungmarke = $this-anchor">
							<xsl:attribute name="class">active <xsl:if test="position()=last()">last</xsl:if></xsl:attribute>
						</xsl:if>
						<a href="#{php:functionString('cms_fe_fw::str_clean_id',@attr-sprungmarke)}"><xsl:value-of select="@attr-sprungmarke" /></a>
					</span>
				</xsl:for-each>
			</nav>
		</xsl:if>
	</xsl:template>

	<xsl:template match="site:content-item[@name='content' or @name='footer' or @name='partners']">
		<xsl:variable name="ignored-modules">site:calendar-view,content:calendar-display-options,content:weblog-post,content:weblog-post-list,content:weblog-post-list-nav,</xsl:variable>
		<xsl:variable name="content-items" select="*[ not( contains( concat( ',', $ignored-modules, ','), concat( ',', name(.), ',' ) ) ) ]" />

		<xsl:for-each select="$content-items">
			<xsl:call-template name="internal-nav" />
			<xsl:choose>
				<xsl:when test="name() = 'content:group'">
					<xsl:apply-templates select="." />
				</xsl:when>
				<xsl:when test="name() = 'content:gallery' and @attr-layout='schwarz-poster'">
					<xsl:apply-templates select="." />
				</xsl:when>
				<xsl:when test="name() = 'content:weblog-head'">
					<section class="grp">
						<xsl:call-template name="site:page-content-attributes"><xsl:with-param name="id" select="@id" /></xsl:call-template>
						<div class="grp-mem grp-mem-{@page-content-type}">
							<xsl:apply-templates select="." />
							<xsl:apply-templates select="../content:weblog-post" />
							<xsl:apply-templates select="../content:weblog-post-list" />
							<xsl:apply-templates select="../content:weblog-post-list-nav" />
						</div>
					</section>
				</xsl:when>
				<xsl:when test="name() = 'content:calendar-display-control'">
					<section class="grp">
						<xsl:call-template name="site:page-content-attributes"><xsl:with-param name="id" select="@id" /></xsl:call-template>
						<div class="grp-mem grp-mem-{@page-content-type}">
							<xsl:apply-templates select="." />
							<xsl:apply-templates select="../site:calendar-view" />
						</div>
					</section>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="this-hintergrund" select="@attr-hintergrund" />

					<xsl:variable name="grp-class">
						<xsl:if test="supplied-nodes/cst">
							<xsl:text> grp-single-cst</xsl:text>
						</xsl:if>
						<xsl:if test="@attr-layout"><xsl:text> grp-layout-</xsl:text><xsl:value-of select="@attr-layout" /></xsl:if>
						<xsl:if test="@attr-hintergrund"><xsl:text> grp-bg-</xsl:text><xsl:value-of select="@attr-hintergrund" /></xsl:if>
						<xsl:if test="not( @attr-hintergrund )"><xsl:text> grp-bg-none</xsl:text></xsl:if>
						<xsl:if test="name(..) = 'site:content-item' and ( preceding-sibling::*[1]/@attr-hintergrund = $this-hintergrund or ( preceding-sibling::*[1] and not(preceding-sibling::*[1]/@attr-hintergrund) and not($this-hintergrund) ) and not( starts-with( preceding-sibling::*[1]/@attr-layout, 'schwarz-' ) ) )">
							<xsl:text> grp-bg-repeat</xsl:text>
						</xsl:if>
					</xsl:variable>

					<section class="grp grp-single grp-{@id}{$grp-class}">
						<xsl:call-template name="site:page-content-attributes"><xsl:with-param name="id" select="@id" /></xsl:call-template>
						<xsl:if test="xml/map">
							<xsl:attribute name="data-attr-layout">karte</xsl:attribute>
						</xsl:if>
						<div class="grp-mem grp-mem-{@page-content-type}">
							<xsl:call-template name="site:page-content-attributes"><xsl:with-param name="id" select="@id" /></xsl:call-template>
							<xsl:apply-templates select="." />
						</div>
					</section>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>

		<xsl:variable name="bgpic-items" select="$content-items[ ( @attr-hintergrund = 'bild' or @attr-hintergrund = 'bild-wiederholt' ) and @attr-hintergrund-bild-id &gt; 0]" />
		<xsl:if test="count( $bgpic-items ) &gt; 0 ">
			<xsl:variable name="styles">
				<xsl:for-each select="$bgpic-items">
					.grp-<xsl:value-of select="@id" />{
						background-position: 50% 50%;
						<xsl:choose>
							<xsl:when test="@attr-hintergrund = 'bild'">
								background-size: cover;
								background-repeat: no-repeat;
							</xsl:when>
							<xsl:when test="@attr-hintergrund = 'bild-wiederholt'">
								<xsl:variable name="url"><xsl:value-of select="$dev_domain" />/(cms)/media/deliver/inline/<xsl:value-of select="@attr-hintergrund-bild-id" /></xsl:variable>
								background-image:url('<xsl:value-of select="normalize-space($url)" />');
								background-repeat: repeat;
							</xsl:when>
						</xsl:choose>
					}
				</xsl:for-each>
				<xsl:if test="count( $bgpic-items[@attr-hintergrund = 'bild'] ) &gt; 0">
					<xsl:variable name="bgpic-force-quality" select="true()" />
					<xsl:variable name="bgpic-interlace" select="true()" />
					<xsl:variable name="bgpic-default-quality" select="70" />
					<xsl:variable name="bgpic-ratio" select="16 div 9" />
					<xsl:variable name="bgpic-mq-def">
						<mq w="640" h="640">(max-width:640px)</mq>
						<mq w="768" h="768">(min-width:641px) and (max-width:768px)</mq>
						<mq w="1024" h="{round(1024 div $bgpic-ratio)}">(min-width:769px) and (max-width:1024px)</mq>
						<mq w="1280" h="{round(1280 div $bgpic-ratio)}">(min-width:1025px) and (max-width:1280px)</mq>
						<mq w="1600" h="{round(1600 div $bgpic-ratio)}">(min-width:1281px) and (max-width:1600px)</mq>
						<mq w="1920" h="{round(1920 div $bgpic-ratio)}">(min-width:1601px)</mq>
					</xsl:variable>
					<xsl:variable name="bgpic-mq" select="exslt:node-set($bgpic-mq-def)" />
					<xsl:for-each select="$bgpic-mq/*">
						<xsl:variable name="bgpic-currmq" select="." />
						@media <xsl:value-of select="text()" />{
						<xsl:for-each select="$bgpic-items[@attr-hintergrund = 'bild']">
							<xsl:variable name="quality"><xsl:choose>
								<xsl:when test="$bgpic-currmq/@q &gt; 0">,quality=<xsl:value-of select="$bgpic-currmq/@q" /></xsl:when>
								<xsl:when test="$bgpic-force-quality">,quality=<xsl:value-of select="$bgpic-default-quality" /></xsl:when>
							</xsl:choose></xsl:variable>
							<xsl:variable name="url">
								<xsl:value-of select="$dev_domain" />/(cms)/media/resize/size=<xsl:value-of select="$bgpic-currmq/@w" />x<xsl:value-of select="$bgpic-currmq/@h" />,scale=crop<xsl:value-of select="$quality" /><xsl:if test="$bgpic-interlace">,interlace=1</xsl:if>/<xsl:value-of select="@attr-hintergrund-bild-id" />
							</xsl:variable>
							.grp-<xsl:value-of select="@id" />{background-image:url('<xsl:value-of select="normalize-space($url)" />')}
						</xsl:for-each>
						}
					</xsl:for-each>
				</xsl:if>
			</xsl:variable>
			<style type="text/css"><xsl:value-of select="normalize-space($styles)" /></style>
		</xsl:if>
	</xsl:template>

	<xsl:template match="content:media-display[media/media_file_type='svg']">
		<xsl:variable name="link" select="(media_display/media_display_description_xml/xml//a)[1]" />
		<xsl:variable name="alt"><xsl:choose>
			<xsl:when test="string-length($link) &gt; 0"><xsl:value-of select="normalize-space($link)" /></xsl:when>
			<xsl:otherwise><xsl:value-of select="media_display/media_display_name" /></xsl:otherwise>
		</xsl:choose></xsl:variable>
		<xsl:variable name="img"><img src="{media_url}" alt="{$alt}">
			<xsl:if test="media_display/media_display_width &gt; 0">
				<xsl:attribute name="width"><xsl:value-of select="media_display/media_display_width" /></xsl:attribute>
			</xsl:if>
			<xsl:if test="media_display/media_display_height &gt; 0">
				<xsl:attribute name="height"><xsl:value-of select="media_display/media_display_height" /></xsl:attribute>
			</xsl:if>
			<xsl:if test="string-length(media_preview_url) &gt; 0">
				<xsl:attribute name="src"><xsl:value-of select="media_preview_url" /></xsl:attribute>
				<xsl:attribute name="srcset"><xsl:value-of select="media_url" /> 1x, <xsl:value-of select="media_url" /> 2x, <xsl:value-of select="media_url" /> 3x</xsl:attribute>
			</xsl:if>
		</img></xsl:variable>
		<xsl:choose>
			<xsl:when test="$link/@href">
				<a title="{$alt}">
					<xsl:for-each select="$link/@*">
						<xsl:attribute name="{name(.)}"><xsl:value-of select="."/></xsl:attribute>
					</xsl:for-each>
					<xsl:copy-of select="$img" />
				</a>
			</xsl:when>
			<xsl:otherwise><xsl:copy-of select="$img" /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ######## LOGO ######## -->

	<xsl:template match="content:article1[../@name='logo']" name="nst15-header-logo">
		<xsl:param name="media_id" select="content:media-extract-id((xml//img)[1]/@src)" />
		<xsl:param name="media_id_preview" select="content:media-extract-id((xml//img)[1]/@src)" />
		<xsl:param name="link" select="(xml//a[@href!=''])[1]" />
		<xsl:param name="title"><xsl:choose>
			<xsl:when test="string-length($link/@title)&gt;0"><xsl:value-of select="$link/@title" /></xsl:when>
			<xsl:otherwise><xsl:value-of select="content:ls('back home')" /></xsl:otherwise>
		</xsl:choose></xsl:param>
		<xsl:param name="alt" select="/site:site/site:website/@website-name" />
		<xsl:variable name="href">
			<xsl:choose>
				<xsl:when test="string-length($link/@href)&gt;0"><xsl:value-of select="$link/@href"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="/site:site/site:tree/menu[@level=0]/@url" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="logo_w">190</xsl:variable>
		<xsl:variable name="logo_m_w">100</xsl:variable>
		<div class="logo">
			<a href="{$href}" title="{normalize-space($title)}">
				<img class="desktop" src="{$dev_domain}/(cms)/media/resize/size={$logo_w}x0/{$media_id}"
						srcset="{$dev_domain}/(cms)/media/resize/size={$logo_w}x0/{$media_id} 1x, {$dev_domain}/(cms)/media/resize/size={$logo_w*2}x0/{$media_id} 2x"
						alt="{normalize-space($alt)}"/>
				<img class="mobile" src="{$dev_domain}/(cms)/media/resize/size={$logo_m_w}x0/{$media_id_preview}"
						srcset="{$dev_domain}/(cms)/media/resize/size={$logo_m_w}x0/{$media_id_preview} 1x, {$dev_domain}/(cms)/media/resize/size={$logo_m_w*2}x0/{$media_id_preview} 2x"
						alt="{normalize-space($alt)}"/>
			</a>
		</div>
	</xsl:template>

	<xsl:template match="content:media-display[../@name='logo']">
		<xsl:call-template name="nst15-header-logo">
			<xsl:with-param name="media_id" select="media/media_file_id" />
			<xsl:with-param name="media_id_preview" select="media_display/media_display_media_preview" />
			<xsl:with-param name="link" select="/site:site/site:tree/menu[@level=0]/@url" />
		</xsl:call-template>
	</xsl:template>

	<!-- ######## NAVIGATION ######## -->

	<xsl:template match="content:menu1[ancestor::site:content-item[@name='nav']]">
		<ul class="main-menu" id="nav_menu">
			<xsl:for-each select="/site:site/site:tree/menu[@level=0]/*">
				<li class="main-menu-item">
					<xsl:if test="@state='active'">
						<xsl:attribute name="class">main-menu-item active</xsl:attribute>
					</xsl:if>
					<div class="sub-menu-button"><xsl:text/></div>
					<a href="{@url}"><xsl:value-of select="." /></a>
					<xsl:variable name="struct" select="@struct" />
					<xsl:variable name="page" select="@id" />
					<xsl:variable name="struct_children" select="/site:site/site:tree/menu[@struct=$struct]/*" />
					<xsl:variable name="struct_children_num" select="count($struct_children)" />
					<xsl:if test="$struct_children_num &gt; 0">
						<div class="sub-menu">
							<div class="sub-menu-title"><a href="{@url}"><xsl:choose>
								<xsl:when test="/site:site/site:page/page-attributes/*[@name='menü-titel' and @page = $page]"><xsl:value-of select="/site:site/site:page/page-attributes/*[@name='menü-titel' and @page = $page]/@value" /></xsl:when>
								<xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
							</xsl:choose></a></div>
							<div class="sub-menu-overview"><a href="{@url}"><xsl:value-of select="content:ls('to main page')" /></a></div>
							<ul class="sub-menu-items">
								<xsl:for-each select="$struct_children[position() &lt; 4 or (position() = 4 and $struct_children_num = 4)]">
									<xsl:variable name="active"><xsl:if test="@state='active'"> active</xsl:if></xsl:variable>
									<li class="menu-item-media menu-item-media-{@struct}{$active}">
										<a href="{@url}"><xsl:value-of select="." /></a>
									</li>
								</xsl:for-each>
								<xsl:if test="$struct_children_num &gt; 4">
									<li class="menu-items-next">
										<ul>
											<xsl:for-each select="$struct_children[position() &gt; 4]">
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
			</xsl:for-each>
		</ul>
		<xsl:for-each select="/site:site/site:tree/menu[@level=0]/*">

		</xsl:for-each>
		<xsl:variable name="menu-images-css">
			@media (min-width: 1280px) {
				<xsl:for-each select="/site:site/site:page/page-attributes/*[@name='menü-bild' and @value &gt; 0]">
					.menu-item-media-<xsl:value-of select="@struct" /> {
						background-image: url( '<xsl:value-of select="$dev_domain" />/(cms)/media/resize/size=190x220,scale=crop,quality=80/<xsl:value-of select="@value" />' );
					}
				</xsl:for-each>
			}
			@media (min-width: 1280px) and (-webkit-min-device-pixel-ratio: 2), (min-width: 1280px) and (min-resolution: 192dpi) {
				<xsl:for-each select="/site:site/site:page/page-attributes/*[@name='menü-bild' and @value &gt; 0]">
					.menu-item-media-<xsl:value-of select="@struct" /> {
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

	<xsl:template match="content:menu1[ancestor::site:content-item[@name='breadcrumb']]">
		<xsl:variable name="start-struct-id" select="/site:site/site:tree/menu[@level=0]/@struct" />
		<nav class="grp breadcrumb">
			<div class="grp-mem">
				<ul class="separator-list">
					<li><a href="/{$current_lang}/"><xsl:value-of select="content:ls('home')" /></a></li>
					<xsl:for-each select="/site:site/site:page/path/*[@struct != $start-struct-id]">
						<li><a href="{@url}"><xsl:value-of select="." /></a></li>
					</xsl:for-each>
				</ul>
			</div>
		</nav>
	</xsl:template>

	<!-- ######## LANGUAGES NAV ######## -->

	<xsl:template match="content:menu1[ancestor::site:content-item[@name='footer'] or ancestor::site:content-item[@name='tools']]">
		<xsl:apply-templates select="/site:site/site:page/languages">
			<xsl:with-param name="short" select="false()" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="site:page/languages">
		<xsl:param name="short" select="true()" />
		<xsl:if test="count(*) &gt; 1">
			<ul class="lang-menu">
				<xsl:for-each select="*">
					<li class="{@state}">
						<a href="{@url}" title="{text()} ({@language-name})">
							<xsl:choose>
								<xsl:when test="$short"><xsl:value-of select="@language"/></xsl:when>
								<xsl:otherwise><xsl:value-of select="@language-name"/></xsl:otherwise>
							</xsl:choose>
						</a>
					</li>
				</xsl:for-each>
			</ul>
		</xsl:if>
	</xsl:template>

	<!-- ######## GALLERY ######## -->

	<xsl:template match="content:gallery[../@name='gallery']">
		<xsl:variable name="ratio" select="16 div 9" />
		<xsl:variable name="ratio-mobile" select="4 div 3" />
		<xsl:call-template name="gallery-flex">
			<xsl:with-param name="control-nav" select="false()" />
			<xsl:with-param name="direction-nav" select="true()" />
			<xsl:with-param name="prev-text" select="''" />
			<xsl:with-param name="next-text" select="''" />
			<xsl:with-param name="randomize" select="true()" />
			<xsl:with-param name="open-graph" select="true()" />
			<xsl:with-param name="domain" select="$dev_domain" />
			<xsl:with-param name="mq-def">
				<mq w="320" h="{round(320 div $ratio-mobile)}">(max-width:320px)</mq>
				<mq w="640" h="{round(640 div $ratio-mobile)}">(min-width:321px) and (max-width:640px)</mq>
				<mq w="768" h="{round(768 div $ratio-mobile)}">(min-width:641px) and (max-width:768px)</mq>
				<mq w="1024" h="{round(1024 div $ratio)}">(min-width:769px) and (max-width:1024px)</mq>
				<mq w="1280" h="{round(1280 div $ratio)}" fallback="yes">(min-width:1025px) and (max-width:1280px)</mq>
				<mq w="1600" h="{round(1600 div $ratio)}">(min-width:1281px) and (max-width:1600px)</mq>
				<mq w="1920" h="{round(1920 div $ratio)}">(min-width:1601px)</mq>
				<mq w="{2*320}" h="{round(2 * 320 div $ratio-mobile)}" q="60">(max-width:320px) and (-webkit-min-device-pixel-ratio: 2), (max-width:320px) and (min-resolution: 192dpi)</mq>
				<mq w="{2*640}" h="{round(2 * 640 div $ratio-mobile)}" q="60">(min-width:321px) and (max-width:640px) and (-webkit-min-device-pixel-ratio: 2), (min-width:321px) and (max-width:640px) and (min-resolution: 192dpi)</mq>
				<mq w="{2*768}" h="{round(2 * 768 div $ratio-mobile)}" q="60">(min-width:641px) and (max-width:768px) and (-webkit-min-device-pixel-ratio: 2), (min-width:641px) and (max-width:768px) and (min-resolution: 192dpi)</mq>
				<mq w="{2*1024}" h="{round(2 * 1024 div $ratio)}" q="60">(min-width:769px) and (max-width:1024px) and (-webkit-min-device-pixel-ratio: 2), (min-width:769px) and (max-width:1024px) and (min-resolution: 192dpi)</mq>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="content:proxy1[../@name='gallery' and count(xml/gallery-items/*) &gt; 0]">
		<xsl:call-template name="gallery-flex">
			<xsl:with-param name="items" select="xml/gallery-items/*" />
			<xsl:with-param name="control-nav" select="false()" />
			<xsl:with-param name="direction-nav" select="false()" />
		</xsl:call-template>
	</xsl:template>

	<!-- ######## CONTENT ######## -->

	<xsl:template match="content:group[ancestor::site:content-item[@name='content' or @name='footer' or @name='partners']]">
		<xsl:variable name="mode-rows" select="@attr-layout = 'spalten'" />
		<xsl:variable name="this-hintergrund" select="@attr-hintergrund" />
		<xsl:variable name="grp-class">
			<xsl:if test="@attr-layout"><xsl:text> grp-layout-</xsl:text><xsl:value-of select="@attr-layout" /></xsl:if>
			<xsl:if test="@attr-hintergrund"><xsl:text> grp-bg-</xsl:text><xsl:value-of select="@attr-hintergrund" /></xsl:if>
			<xsl:if test="not( @attr-hintergrund )"><xsl:text> grp-bg-none</xsl:text></xsl:if>
			<xsl:if test="ancestor::site:content-item[@name='footer'] and .//members/*[@attr-hintergrund = 'weiss']"><xsl:text> grp-has-buttons</xsl:text></xsl:if>
			<xsl:if test="name(..) = 'site:content-item' and ( preceding-sibling::*[1]/@attr-hintergrund = $this-hintergrund or ( preceding-sibling::*[1] and not(preceding-sibling::*[1]/@attr-hintergrund) and not($this-hintergrund) ) ) and not( starts-with( preceding-sibling::*[1]/@attr-layout, 'schwarz-' ) )">
				<xsl:text> grp-bg-repeat</xsl:text>
			</xsl:if>
		</xsl:variable>

		<section class="grp grp-{@id}{$grp-class}">
			<xsl:call-template name="site:page-content-attributes"><xsl:with-param name="id" select="@id" /></xsl:call-template>
			<xsl:if test="$mode-rows">
				<xsl:variable name="children-num" select="count( members/*[not( @attr-layout ) or @attr-layout != 'spalte-volle-breite'] ) + count( members/*[@attr-layout='spalte-doppelbreite'] )" />
				<xsl:attribute name="data-children"><xsl:value-of select="$children-num" /></xsl:attribute>
				<xsl:if test="$children-num = 3 and members/*[1]/@attr-layout='spalte-doppelbreite'"><xsl:attribute name="data-reverse">true</xsl:attribute></xsl:if>
			</xsl:if>
			<xsl:if test="contains( @attr-hintergrund, '-motive') and @attr-hintergrund-bild-id &gt; 0">
				<div class="motive motive-1"></div>
				<div class="motive motive-2"></div>
				<xsl:variable name="group-background-pattern-css">
					.grp-<xsl:value-of select="@id" /> .motive {
						background-image: url('<xsl:value-of select="$dev_domain" />/(cms)/media/resize/size=400x400,scale=fit/<xsl:value-of select="@attr-hintergrund-bild-id" />');
					}
				</xsl:variable>
				<style type="text/css"><xsl:value-of select="normalize-space($group-background-pattern-css)" /></style>
			</xsl:if>
			<xsl:for-each select="members/*">
				<xsl:variable name="row-class"><xsl:choose>
					<xsl:when test="$mode-rows and @attr-layout='spalte-volle-breite'"> grp-row-full</xsl:when>
					<xsl:when test="$mode-rows and @attr-layout='spalte-doppelbreite'"> grp-row grp-row-double</xsl:when>
					<xsl:when test="$mode-rows"> grp-row</xsl:when>
				</xsl:choose></xsl:variable>
				<div class="grp-mem grp-mem-{@page-content-type}{$row-class}">
					<xsl:call-template name="site:page-content-attributes"><xsl:with-param name="id" select="@id" /></xsl:call-template>
					<xsl:apply-templates select="." />
				</div>
			</xsl:for-each>
		</section>
	</xsl:template>

	<xsl:template match="content:gallery[@type='list' and ancestor::site:content-item[@name='content']]">
		<xsl:variable name="download_sizes" select="gallery/mcg_download_sizes=1" />
		<link rel="stylesheet" type="text/css" href="/(cms)/module/static/customer/2/content/gallery/css/gallery.css" />
		<style type="text/css">
			@media (min-width: 960px) { header .gallery .slide { max-height: 50vh } };
		</style>
		<div class="cms-module-gallery cms-module-gallery-list cms-module-gallery-list-{@id}">

			<xsl:if test="$download_sizes=1">
				<xsl:attribute name="class">cms-module-gallery cms-module-gallery-list cms-module-gallery-list-<xsl:value-of select="@id"/> cms-module-gallery-list-sizes</xsl:attribute>
			</xsl:if>
			<xsl:variable name="id" select="generate-id()" />
			<xsl:variable name="gallery" select="gallery" />
			<xsl:variable name="cols"><xsl:value-of select="gallery/mcg_list_cols" /></xsl:variable>
			<xsl:variable name="rows">
				<xsl:choose>
					<xsl:when test="gallery/mcg_list_rows &gt; 0">
						<xsl:value-of select="gallery/mcg_list_rows" />
					</xsl:when>
					<xsl:otherwise>3</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="count"><xsl:value-of select="$cols * $rows" /></xsl:variable>
			<xsl:variable name="images" select="count(gallery-items/*)"/>
			<xsl:variable name="skip">
				<xsl:choose>
					<xsl:when test="options/skip"><xsl:value-of select="options/skip" /></xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<!--<xsl:variable name="onclick">return hs.expand( this, { slideshowGroup: 'gallery_<xsl:value-of select="$id" />', numberPosition: 'caption', wrapperClassName: 'in-page controls-in-heading' });</xsl:variable>-->
			<xsl:variable name="strings" select="gallery-strings/string" />
			<xsl:variable name="url" select="/site:site/site:env/site:vars/url_action" />

			<xsl:if test="$gallery/mcg_lightbox=1">
				<script type="text/javascript">
					_lib_load( 'jQuery-fancybox', 'jQuery-fancybox-helper-thumbs' );
				</script>
			</xsl:if>
			<xsl:if test="string-length(gallery/mcg_name)&gt;0">
				<h2 class="gallery-name"><xsl:value-of select="gallery/mcg_name" /></h2>
			</xsl:if>
			<xsl:if test="string-length(gallery/mcg_subtitle)&gt;0">
				<span class="gallery-subtitle"><xsl:value-of select="gallery/mcg_subtitle" /></span>
			</xsl:if>
			<xsl:if test="gallery/mcg_slideshow = 1">
				<xsl:choose>
					<xsl:when test="gallery/mcg_lightbox = 0">
						<div class="gallery-top" align="right"><a href="{$url}?c[{@id}][action]=slideshow" target="_blank"><xsl:value-of select="$strings[@name='diashow.start']" /></a></div>
					</xsl:when>
					<xsl:otherwise>
						<script type="text/javascript">
							_lib_load( 'jQuery' );
						</script>
						<div class="gallery-top" align="right">
							<a href="#" onclick="jQuery( '#lyteshow_start_{$id}' ).trigger( 'click' ); return false;">
								<xsl:value-of select="$strings[@name='diashow.start']" />
							</a>
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="gallery/mcg_slideshow = 2">
				<div class="gallery-top" align="right">
					<xsl:choose>
						<xsl:when test="gallery/mcg_lightbox = 0">
							<a href="{$url}?c[{@id}][action]=slideshow-flash" target="_blank"><xsl:value-of select="$strings[@name='diashow.start']" /></a>
						</xsl:when>
						<xsl:otherwise>
							<script type="text/javascript">
								_lib_load( 'jQuery' );
							</script>
							<div class="gallery-top" align="right">
								<a href="#" onclick="jQuery( '#lyteshow_start_{$id}' ).trigger( 'click' ); return false;">
									<xsl:value-of select="$strings[@name='diashow.start']" />
								</a>
							</div>
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</xsl:if>
			<xsl:variable name="remember">
				<xsl:if test="gallery/mcg_send=1 or gallery/mcg_print=1 or gallery/mcg_print_service=1">1</xsl:if>
			</xsl:variable>
			<xsl:variable name="download" select="gallery/mcg_download=1" />

			<xsl:if test="$skip &gt; 0">
				<div style="display: none;">
					<xsl:for-each select="gallery-items/*[position() &lt;= ( $skip ) * $count]">
						<xsl:variable name="lytebox_text">
							<xsl:choose>
								<xsl:when test="string-length( mcgi_name ) > 0 and string-length( mcgi_text ) = 0">
									<xsl:value-of select="mcgi_name" />
								</xsl:when>
								<xsl:when test="string-length( mcgi_name ) = 0 and string-length( mcgi_text ) > 0">
									<xsl:value-of select="mcgi_text" />
								</xsl:when>
								<xsl:when test="string-length( mcgi_name ) > 0 and string-length( mcgi_text ) > 0">
									<xsl:value-of select="mcgi_name" /><xsl:text>|</xsl:text><xsl:value-of select="mcgi_text" />
								</xsl:when>
							</xsl:choose>
						</xsl:variable>

						<xsl:variable name="image_url_full">
							<xsl:call-template name="content:gallery-link-lytebox"/>
						</xsl:variable>

						<a href="{$dev_domain}{$image_url_full}" thumb="{$dev_domain}/(cms)/media/resize/size0x100/{mcgi_media}" onclick="{$onclick}" title="{$lytebox_text}" alt="{$lytebox_text}" class="cms-link-image">
							<img src="" class="cms-link-image" alt="" />
						</a>
						<div class="highslide-caption">
							<b>
								<xsl:value-of select="mcgi_name" />
							</b>
							<br/>
							<xsl:value-of select="mcgi_text" />
						</div>
					</xsl:for-each>
				</div>
			</xsl:if>

			<xsl:if test="$download_sizes=1">
				<xsl:apply-templates select="gallery-sizes-control">
					<xsl:with-param name="node" select="."/>
				</xsl:apply-templates>
			</xsl:if>

			<div class="gallery">
				<xsl:for-each select="gallery-items/*">
					<xsl:variable name="lytebox_text">
						<xsl:choose>
							<xsl:when test="string-length( mcgi_name ) > 0 and string-length( mcgi_text ) = 0">
								<xsl:value-of select="mcgi_name" />
							</xsl:when>
							<xsl:when test="string-length( mcgi_name ) = 0 and string-length( mcgi_text ) > 0">
								<xsl:value-of select="mcgi_text" />
							</xsl:when>
							<xsl:when test="string-length( mcgi_name ) > 0 and string-length( mcgi_text ) > 0">
								<xsl:value-of select="mcgi_name" /><xsl:text>|</xsl:text><xsl:value-of select="mcgi_text" />
							</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="pos-modulo"><xsl:if test="position() mod 2 = 1"><xsl:text> </xsl:text>first-of-2</xsl:if><xsl:if test="position() mod 3 = 1"><xsl:text> </xsl:text>first-of-3</xsl:if></xsl:variable>
					<div class="gallery-image-container{$pos-modulo}">
						<a href="{$url}?c[{../../@id}][action]=detail&amp;c[{../../@id}][item]={mcgi_media}" data-fancybox-group="fancybox_{$id}" data-fancybox-thumb="{$dev_domain}/(cms)/media/resize/size=100x100,scale=crop,quality=70/{mcgi_media}" class="fancybox-thumb" data-fancybox-type="image">
							<xsl:if test="$gallery/mcg_lightbox=1">
								<xsl:variable name="image_url_full"><xsl:value-of select="$dev_domain" /><xsl:call-template name="content:gallery-link-lytebox"/></xsl:variable>
								<xsl:attribute name="href"><xsl:value-of select="$image_url_full" /></xsl:attribute>

								<xsl:if test="position() = 1">
									<xsl:attribute name="id">lyteshow_start_<xsl:value-of select="$id" /></xsl:attribute>
								</xsl:if>
							</xsl:if>
							<xsl:variable name="image_url">
								<xsl:value-of select="$dev_domain" />
								<xsl:text>/(cms)/media/resize/</xsl:text>
								<!-- param size -->
								<xsl:text>size=480</xsl:text>
								<!--<xsl:value-of select="../../gallery/mcg_list_width" />-->
								<xsl:text>x270</xsl:text>
								<!--<xsl:value-of select="../../gallery/mcg_list_height" />-->
								<!--<xsl:if test="../../gallery/mcg_list_height &gt; 0 and ../../gallery/mcg_list_width &gt; 0">-->
								<xsl:text>,scale=crop</xsl:text>
								<!--</xsl:if>-->
								<!-- param wmi (watermark image) -->
								<xsl:if test="../../gallery/mcg_watermark_thumb_image &gt; 0">
									<xsl:text>,wmi=</xsl:text>
									<xsl:value-of select="../../gallery/mcg_watermark_thumb_image" />
								</xsl:if>
								<!-- param wmp (watermark position) -->
								<xsl:if test="../../gallery/mcg_watermark_thumb_image &gt; 0">
									<xsl:text>,wmp=</xsl:text>
									<xsl:value-of select="../../gallery/mcg_watermark_thumb_pos" />
								</xsl:if>
								<xsl:text>/</xsl:text>
								<xsl:value-of select="mcgi_media" />
							</xsl:variable>
							<img src="{$image_url}" alt="{normalize-space($lytebox_text)}" class="gallery cms-link-image" />
							<span class="fa fa-zoom"></span>
						</a>
						<xsl:if test="$remember=1">
							<br />
							<div class="gallery-remember-box">
								<xsl:if test="rem = 0 ">
									<a href="{$url}?c[{../../@id}][remember]=1&amp;c[{../../@id}][gallery]={mcgi_gallery}&amp;c[{../../@id}][item]={mcgi_media}&amp;c[{../../@id}][skip]={$skip}" class="gallery-remember"><img src="/(cms)/module/static/customer/2/content/gallery/i/box-no.gif" alt="" /></a>&#160;<xsl:value-of select="$strings[@name='remember']" />
								</xsl:if>
								<xsl:if test="rem = 1 ">
									<a href="{$url}?c[{../../@id}][remember]=0&amp;c[{../../@id}][gallery]={mcgi_gallery}&amp;c[{../../@id}][item]={mcgi_media}&amp;c[{../../@id}][skip]={$skip}" class="gallery-remember"><img src="/(cms)/module/static/customer/2/content/gallery/i/box-yes.gif" alt="" /></a>&#160;<xsl:value-of select="$strings[@name='remember']" />
								</xsl:if>
							</div>
						</xsl:if>
						<xsl:if test="$download_sizes=1">
							<xsl:apply-templates select="../../gallery-sizes">
								<xsl:with-param name="node" select="."/>
							</xsl:apply-templates>
						</xsl:if>

						<xsl:if test="$download=1">
							<div class="gallery-list-download">
								<a href="/(cms)/media/deliver/attachment/{mcgi_media}" class="cms-link-text"><span><xsl:value-of select="$strings[@name='download']" /></span></a>
							</div>
						</xsl:if>
					</div>
				</xsl:for-each>
			</div>

			<!--  script to check inputs/ send ajax request / change session etc. -->
			<xsl:if test="$download_sizes=1">
				<xsl:apply-templates select="gallery-sizes-script">
					<xsl:with-param name="node" select="."/>
					<xsl:with-param name="skip" select="$skip"/>
				</xsl:apply-templates>
			</xsl:if>

			<!--  dummy items fuer die lytebox, damit bei mehreren seiten diese bilder auch ansteuerbar sind -->
			<xsl:if test="$gallery/mcg_lightbox=1 and $count &lt; $images">
				<div style="display: none;">
					<xsl:for-each select="gallery-items/*[position() &gt; ( $skip + 1 ) * $count]">
						<xsl:variable name="lytebox_text">
							<xsl:choose>
								<xsl:when test="string-length( mcgi_name ) > 0 and string-length( mcgi_text ) = 0">
									<xsl:value-of select="mcgi_name" />
								</xsl:when>
								<xsl:when test="string-length( mcgi_name ) = 0 and string-length( mcgi_text ) > 0">
									<xsl:value-of select="mcgi_text" />
								</xsl:when>
								<xsl:when test="string-length( mcgi_name ) > 0 and string-length( mcgi_text ) > 0">
									<xsl:value-of select="mcgi_name" /><xsl:text>|</xsl:text><xsl:value-of select="mcgi_text" />
								</xsl:when>
							</xsl:choose>
						</xsl:variable>

						<xsl:variable name="image_url_full">
							<xsl:call-template name="content:gallery-link-lytebox"/>
						</xsl:variable>
						<a href="{$image_url_full}" data-fancybox-title="{normalize-space($lytebox_text)}" class="cms-link-image-fancybox" data-fancybox-group="fancybox_{$id}" data-fancybox-type="image" data-fancybox-thumb="{$gallery-domain}/(cms)/media/resize/size=0x50/{mcgi_media}">
							<img src="" class="cms-link-image" alt="{normalize-space($lytebox_text)}" />
						</a>
					</xsl:for-each>
				</div>
			</xsl:if>
			<div class="gallery-options">
				<xsl:if test="gallery-items-remember-count &gt; 0 or $download_sizes=1">
					<xsl:if test="( gallery/mcg_send = 1 ) or ( gallery/mcg_print = 1 ) or ( $download_sizes = 1 )">
						<xsl:value-of select="$strings[@name='remember.pictures']" />:<xsl:text> </xsl:text>
					</xsl:if>
					<xsl:if test="$download_sizes=1">
						<a class="gallery-download-button-selected cms-link-text" href="{$url}?c[{@id}][action]=download" rel="nofollow"><span>Download</span></a><span class="gallery-button-seperator"><xsl:text> | </xsl:text></span>
					</xsl:if>
					<xsl:if test="gallery/mcg_print = 1">
						<a class="gallery-button-print cms-link-text" href="{$url}?c[{@id}][action]=print" onclick="window.open(this.href,'popup','width=800,height=600,scrollbars=yes');return false;" rel="nofollow"><span><xsl:value-of select="$strings[@name='remember.print']" /></span></a>
					</xsl:if>
					<xsl:if test="gallery/mcg_send = 1">
						<xsl:if test="gallery/mcg_print = 1"> <span class="gallery-button-seperator"><xsl:text> | </xsl:text></span></xsl:if>
						<a class="gallery-button-send cms-link-text" href="{$url}?c[{@id}][action]=send" rel="nofollow"><span><xsl:value-of select="$strings[@name='remember.send']" /></span></a>
					</xsl:if>

				</xsl:if>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="content:group[@attr-layout='schwarz-poster']">
		<div class="grp content-poster-media content-poster-media-{(members/content:media-display)[1]/media/media_file_id}" id="content_poster_{@id}">
			<div class="gal" id="content_poster_{@id}_flex">
				<ul class="slides cf">
					<xsl:for-each select="members/content:article1">
						<li class="slide dotdotdot" data-media="{preceding-sibling::content:media-display[1]/media/media_file_id}">
							<xsl:copy-of select="xml/node()" />
						</li>
					</xsl:for-each>
				</ul>
			</div>
		</div>
		<xsl:call-template name="content-poster-scripts">
			<xsl:with-param name="id" select="@id" />
			<xsl:with-param name="media_files" select="members/content:media-display/media/media_file_id" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="content:gallery[@attr-layout='schwarz-themen']">
		<div class="theme-boxes">
			<xsl:for-each select="gallery-items/*">
				<xsl:variable name="link" select="(mcgi_text/xml//a)[1]/@href" />
				<xsl:variable name="href"><xsl:choose>
					<xsl:when test="substring($link,1,1) = '#'">#<xsl:value-of select="php:functionString('cms_fe_fw::str_clean_id',$link)" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="$link" /></xsl:otherwise>
				</xsl:choose></xsl:variable>
				<xsl:variable name="element-tagname"><xsl:choose>
					<xsl:when test="string-length($href) &gt; 0">A</xsl:when>
					<xsl:otherwise>DIV</xsl:otherwise>
				</xsl:choose></xsl:variable>
				<xsl:element name="{$element-tagname}">
					<xsl:attribute name="class">theme-box theme-box-<xsl:value-of select="media_file_id" /></xsl:attribute>
					<xsl:if test="$element-tagname = 'A'">
						<xsl:attribute name="href"><xsl:value-of select="$href" /></xsl:attribute>
					</xsl:if>
					<xsl:if test="string-length(mcgi_name) &gt; 0">
						<xsl:attribute name="data-theme"><xsl:value-of select="mcgi_name" /></xsl:attribute>
					</xsl:if>
					<div class="theme-box-overlay">
						<xsl:for-each select="mcgi_text/xml/*">
							<div class="overlay-line-{position()}"><xsl:apply-templates select="." /></div>
						</xsl:for-each>
					</div>
					<div class="theme-box-main-tag"><xsl:copy-of select="content:ls('my theme')" /></div>
				</xsl:element>
			</xsl:for-each>
		</div>
		<xsl:variable name="theme-box-css">
			<!-- TODO: responsive pictures -->
			<xsl:for-each select="gallery-items/*">
				.theme-box-<xsl:value-of select="media_file_id" /> {
					background: url('<xsl:value-of select="$dev_domain" />/(cms)/media/resize/size=960x720,scale=crop,quality=70,interlace=1/<xsl:value-of select="media_file_id" />') 50% 50% / cover no-repeat;
				}
				.theme-box-main.theme-box-<xsl:value-of select="media_file_id" /> {
					background-image: url('<xsl:value-of select="$dev_domain" />/(cms)/media/resize/size=1280x1280,scale=fit,quality=70,interlace=1/<xsl:value-of select="media_file_id" />');
				}
			</xsl:for-each>
		</xsl:variable>
		<style type="text/css"><xsl:value-of select="normalize-space($theme-box-css)" /></style>
	</xsl:template>

	<xsl:template match="gallery-items/*/mcgi_text/xml//*">
		<xsl:choose>
			<xsl:when test="self::text() or name(.) = 'a'">
				<xsl:value-of select="."/>
			</xsl:when>
			<xsl:when test="name(.) = 'br'">
				<br/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="node()" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="content:gallery[ancestor::*[@attr-layout='schwarz-versprechen']]">
		<xsl:variable name="id" select="@id" />
		<xsl:for-each select="gallery-items/*">
			<div class="item item-{$id}">
				<div class="item-image">
					<img src="{$dev_domain}/(cms)/media/resize/size=768x606%2Cscale=crop%2Cquality=70%2Cinterlace=1/{media_file_id}"
							sizes="100vw,(min-width: 768px) 33.333vw"
							srcset="{$dev_domain}/(cms)/media/resize/size=320x253%2Cscale=crop%2Cquality=70%2Cinterlace=1/{media_file_id} 320w, {$dev_domain}/(cms)/media/resize/size=640x505%2Cscale=crop%2Cquality=70%2Cinterlace=1/{media_file_id} 640w, {$dev_domain}/(cms)/media/resize/size=768x606%2Cscale=crop%2Cquality=70%2Cinterlace=1/{media_file_id} 768w, {$dev_domain}/(cms)/media/resize/size=1024x808%2Cscale=crop%2Cquality=70%2Cinterlace=1/{media_file_id} 1024w"
							width="640" height="505" alt="{normalize-space(mcgi_alt)}" />
					<xsl:for-each select="pois/*">
						<xsl:variable name="x" select="number( media_poi_left ) div number( media_poi_media_width )" />
						<xsl:variable name="y" select="number( media_poi_top ) div number( media_poi_media_height )" />
						<xsl:variable name="pos">
							<xsl:choose>
								<xsl:when test="$x &lt; 0.5">pos-left</xsl:when>
								<xsl:otherwise>pos-right</xsl:otherwise>
							</xsl:choose>
							<xsl:text> </xsl:text>
							<xsl:choose>
								<xsl:when test="$y &lt; 0.5">pos-top</xsl:when>
								<xsl:otherwise>pos-bottom</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<div class="item-poi {$pos} item-poi-img-{count( media_poi_text_xml//img )}">
							<xsl:copy-of select="media_poi_text_xml/node()" />
						</div>
					</xsl:for-each>
				</div>
				<div class="item-text">
					<xsl:copy-of select="mcgi_text/xml/node()" />
				</div>
			</div>
		</xsl:for-each>
		<script type="text/javascript">
			$('.item-<xsl:value-of select="$id" />').find('img[src^=cdata]').each(function(i,el){el.src=el.src.replace(/^.*#/,'')});
		</script>
	</xsl:template>

	<xsl:template match="content:gallery[@attr-layout='schwarz-poster']">
		<div class="grp">
			<div class="grp-mem content-poster-media content-poster-media-{gallery-items/*[1]/media_file_id}" id="content_poster_{@id}">
				<div class="gal" id="content_poster_{@id}_flex">
					<ul class="slides cf">
						<xsl:for-each select="gallery-items/*">
							<li class="slide dotdotdot" data-media="{media_file_id}">
								<h3><xsl:value-of select="mcgi_name" /></h3>
								<div><xsl:copy-of select="mcgi_text/xml/node()" /></div>
							</li>
						</xsl:for-each>
					</ul>
				</div>
			</div>
		</div>
		<xsl:call-template name="content-poster-scripts">
			<xsl:with-param name="id" select="@id" />
			<xsl:with-param name="media_files" select="gallery-items/*/media_file_id" />
		</xsl:call-template>
	</xsl:template>

	<func:function name="content:media-url">
		<xsl:param name="id"/>
		<xsl:param name="size">1024x768</xsl:param>
		<xsl:param name="scale">crop</xsl:param>
		<xsl:param name="quality">70</xsl:param>
		<func:result><xsl:value-of select="$dev_domain" />/(cms)/media/resize/size=<xsl:value-of select="$size" />,scale=<xsl:value-of select="$scale" />,interlace=1,quality=<xsl:value-of select="$quality" />/<xsl:value-of select="$id" /></func:result>
	</func:function>

	<xsl:template name="content-poster-scripts">
		<xsl:param name="id" />
		<xsl:param name="media_files" />

		<xsl:variable name="poster-css">
			<xsl:for-each select="$media_files">
				@media (max-width: 640px){
					.content-poster-media-<xsl:value-of select="." /> {
						background-image: url('<xsl:value-of select="content:media-url(text(),'640x640')" />');
					}
				}
				@media (min-width: 641px) and (max-width: 1024px){
					.content-poster-media-<xsl:value-of select="." /> {
						background-image: url('<xsl:value-of select="content:media-url(text(),'1024x600')" />');
					}
				}
				@media (min-width: 1025px) and (max-width: 1280px){
					.content-poster-media-<xsl:value-of select="." /> {
						background-image: url('<xsl:value-of select="content:media-url(text(),'1280x720')" />');
					}
				}
				@media (min-width: 1281px) and (max-width: 1600px){
					.content-poster-media-<xsl:value-of select="." /> {
						background-image: url('<xsl:value-of select="content:media-url(text(),'1600x900')" />');
					}
				}
				@media (min-width: 1601px){
					.content-poster-media-<xsl:value-of select="." /> {
						background-image: url('<xsl:value-of select="content:media-url(text(),'1920x1080')" />');
					}
				}
			</xsl:for-each>
		</xsl:variable>

		<xsl:variable name="poster-js">
			nst2015.flex( jQuery( '#content_poster_<xsl:value-of select="$id" />_flex' ).data('media', jQuery( '#content_poster_<xsl:value-of select="$id" />' ) ), 'schwarz-poster', true );
		</xsl:variable>

		<style type="text/css"><xsl:value-of select="normalize-space($poster-css)" /></style>
		<script type="text/javascript"><xsl:value-of select="normalize-space($poster-js)" /></script>
	</xsl:template>

	<xsl:template match="content:group[@attr-layout='mediagrid']">
		<xsl:variable name="total-items" select="count(members/content:gallery/gallery-items/*)+count(members/content:media-display)" />
		<xsl:variable name="id" select="@id" />
		<div class="grp gallery-list">
			<xsl:for-each select="members/*">
				<xsl:variable name="mediagrid-item" select="." />
				<xsl:choose>
					<xsl:when test="name() = 'content:gallery'">
						<xsl:for-each select="gallery-items/*">
							<xsl:variable name="pos" select="position() + count( $mediagrid-item/preceding-sibling::content:gallery/gallery-items/* ) + count( $mediagrid-item/preceding-sibling::content:media-display )" />
							<xsl:variable name="mcgi_text_flat"><xsl:value-of select="normalize-space(mcgi_text)" /></xsl:variable>
							<xsl:variable name="link"><xsl:choose>
								<xsl:when test="starts-with($mcgi_text_flat,'http')"><xsl:value-of select="$mcgi_text_flat" /></xsl:when>
								<xsl:when test="starts-with((mcgi_text//a)[1]/@href,'http')"><xsl:value-of select="(mcgi_text//a)[1]/@href" /></xsl:when>
							</xsl:choose></xsl:variable>
							<div>
								<!-- standard pattern: 2-1-1 1-1-2. the last line can be 2-2 instead if an item is missing -->
								<xsl:variable name="item-class">
									fancybox-thumb gallery-list-item gallery-list-item-<xsl:value-of select="media_file_id" />
									<xsl:choose>
										<xsl:when test="$pos mod 6 = 1 or $pos mod 6 = 0 or ( $total-items mod 3 = 2 and ( $pos = $total-items or $pos = $total-items - 1 ) ) or ( $total-items mod 3 = 1 and ( $pos = $total-items or $pos = $total-items - 1 or $pos = $total-items - 2 ) )">
											<xsl:text> gallery-list-item-doublewidth</xsl:text>
										</xsl:when>
										<xsl:otherwise> gallery-list-item-simple</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="contains($link,'panorama') or contains($link,'360')"> gallery-list-item-360</xsl:when>
										<xsl:when test="string-length($link) &gt; 1"> gallery-list-item-video</xsl:when>
										<xsl:otherwise> gallery-list-item-image</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:attribute name="class"><xsl:value-of select="normalize-space($item-class)" /></xsl:attribute>
								<xsl:choose>
									<xsl:when test="contains($link,'youtube')">
										<xsl:attribute name="data-fancybox-type">iframe</xsl:attribute>
										<xsl:attribute name="data-fancybox-href">https://www.youtube.com/embed/<xsl:value-of select="substring-after($link,'v=')" /></xsl:attribute>
									</xsl:when>
									<xsl:when test="string-length($link) &gt; 0">
										<xsl:attribute name="data-fancybox-type">iframe</xsl:attribute>
										<xsl:attribute name="data-fancybox-href"><xsl:value-of select="$link" /></xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="data-fancybox-group">gallery-list-<xsl:value-of select="$id" /></xsl:attribute>
										<xsl:attribute name="data-fancybox-title"><xsl:value-of select="mcgi_name" /><xsl:if test="string-length(mcgi_alt) &gt; 0"> – © <xsl:value-of select="mcgi_alt" /></xsl:if></xsl:attribute>
										<xsl:attribute name="data-fancybox-type">image</xsl:attribute>
										<xsl:attribute name="data-fancybox-href"><xsl:value-of select="$dev_domain" />/(cms)/media/resize/1920x1080,scale=fit,interlace=1,quality=70/<xsl:value-of select="media_file_id" /></xsl:attribute>
										<xsl:attribute name="data-fancybox-thumb"><xsl:value-of select="$dev_domain" />/(cms)/media/resize/50x50,scale=crop,quality=70/<xsl:value-of select="media_file_id" /></xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:if test="string-length(mcgi_name) &gt; 0">
									<div class="gallery-list-item-title">
										<div class="gallery-list-item-title-content"><xsl:value-of select="mcgi_name" /></div>
									</div>
								</xsl:if>
								<xsl:if test="string-length(mcgi_alt) &gt; 0">
									<div class="gallery-list-item-copyright">
										<xsl:value-of select="mcgi_alt" />
									</div>
								</xsl:if>
							</div>
						</xsl:for-each>
					</xsl:when>
					<xsl:when test="name() = 'content:media-display'">
						<xsl:variable name="pos" select="1 + count( $mediagrid-item/preceding-sibling::content:gallery/gallery-items/* ) + count( $mediagrid-item/preceding-sibling::content:media-display )" />
						<div data-fancybox-href="#mediadisplay_{@id}" data-width="1280">
							<xsl:variable name="item-class">
								fancybox gallery-list-item gallery-list-item-video gallery-list-item-preview-<xsl:value-of select="@id" />
								<xsl:choose>
									<xsl:when test="$pos mod 6 = 1 or $pos mod 6 = 0 or ( $total-items mod 3 = 2 and ( $pos = $total-items or $pos = $total-items - 1 ) ) or ( $total-items mod 3 = 1 and ( $pos = $total-items or $pos = $total-items - 1 or $pos = $total-items - 2 ) )">
									<xsl:text> gallery-list-item-doublewidth</xsl:text>
									</xsl:when>
									<xsl:otherwise> gallery-list-item-simple</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:attribute name="class"><xsl:value-of select="normalize-space($item-class)" /></xsl:attribute>
							<div class="gallery-list-item-overlay" id="mediadisplay_{@id}">
								<xsl:apply-templates select="." />
							</div>
						</div>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</div>
		<xsl:variable name="gallery-list-css">
			<xsl:for-each select="members/*">
				<xsl:variable name="mediagrid-item" select="." />
				<xsl:choose>
					<xsl:when test="name() = 'content:gallery'">
						<xsl:for-each select="gallery-items/*">
							.gallery-list-item-<xsl:value-of select="media_file_id" /> {
								background-image: url('<xsl:value-of select="$dev_domain" />/(cms)/media/resize/400x400,scale=crop,interlace=1,quality=70/<xsl:value-of select="media_file_id" />');
							}
							.gallery-list-item-<xsl:value-of select="media_file_id" />.gallery-list-item-doublewidth {
								background-image: url('<xsl:value-of select="$dev_domain" />/(cms)/media/resize/800x400,scale=crop,interlace=1,quality=70/<xsl:value-of select="media_file_id" />');
							}
						</xsl:for-each>
						@media (-webkit-min-device-pixel-ratio: 2), (min-resolution: 192dpi) {
							<xsl:for-each select="gallery-items/*">
								.gallery-list-item-<xsl:value-of select="media_file_id" /> {
									background-image: url('<xsl:value-of select="$dev_domain" />/(cms)/media/resize/800x800,scale=crop,interlace=1,quality=60/<xsl:value-of select="media_file_id" />');
								}
								.gallery-list-item-<xsl:value-of select="media_file_id" />.gallery-list-item-doublewidth {
									background-image: url('<xsl:value-of select="$dev_domain" />/(cms)/media/resize/1600x800,scale=crop,interlace=1,quality=60/<xsl:value-of select="media_file_id" />');
								}
							</xsl:for-each>
						}
					</xsl:when>
					<xsl:when test="name() = 'content:media-display'">
						<xsl:variable name="pos" select="1 + count( $mediagrid-item/preceding-sibling::content:gallery/gallery-items/* ) + count( $mediagrid-item/preceding-sibling::content:media-display )" />
						<xsl:variable name="width-factor"><xsl:choose>
							<xsl:when test="$pos mod 6 = 1 or $pos mod 6 = 0 or ($total-items mod 3 = 2 and $pos = $total-items )">2</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose></xsl:variable>
						.gallery-list-item-preview-<xsl:value-of select="@id" /> {
							background-image: url('<xsl:value-of select="$dev_domain" />/(cms)/media/resize/<xsl:value-of select="400 * $width-factor" />x400,scale=crop,interlace=1,quality=70/<xsl:value-of select="media_display/media_display_media_preview" />')
						}
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<style type="text/css"><xsl:value-of select="normalize-space($gallery-list-css)" /></style>
	</xsl:template>

	<xsl:template match="content:media-display[@type='video-html5']" name="responsive-media-display-video-html5">
		<xsl:variable name="id" select="generate-id()" />
		<xsl:variable name="ua" select="/site:site/site:env/site:user-agent" />
		<xsl:variable name="html5" select="not( ( $ua/@name = 'msie' and $ua/@version &lt; 9 ) or ( ( $ua/@name = 'gecko' or $ua/@name = 'firefox' ) and $ua/@version &lt; 3.5 ) )" />

		<div id="media_display_wrapper_{$id}" class="media_display_wrapper">
			<video id="media_display_{$id}" width="100%" height="100%" style="width: 100%; height: 100%;">
				<xsl:if test="media_preview_url"><xsl:attribute name="poster"><xsl:value-of select="media_preview_url" /></xsl:attribute></xsl:if>
				<xsl:if test="media_display/media_display_controls=1"><xsl:attribute name="controls">true</xsl:attribute></xsl:if>
				<xsl:if test="$ua/@mobile"><xsl:attribute name="preload">none</xsl:attribute></xsl:if>
				<!-- android startet videos mit autoplay im fullscreen, das will niemand.. -->
				<xsl:if test="not( $ua/@mobile ) and media_display/media_display_autoplay=1"><xsl:attribute name="autoplay">autoplay</xsl:attribute></xsl:if>

				<xsl:choose>
					<xsl:when test="$html5 or $ua/@name = 'gecko' or $ua/@name = 'firefox'">
						<source src="{$dev_domain}{media_url}" type="{media/media_file_mime}" />
						<xsl:for-each select="childs/*[media/media_file_class=3]">
							<xsl:sort order="descending" />
							<source src="{$dev_domain}{media_url}" type="{media/media_file_mime}" />
						</xsl:for-each>
					</xsl:when>

					<xsl:otherwise>
						<xsl:attribute name="src"><xsl:value-of select="$dev_domain" /><xsl:value-of select="media_url" /></xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</video>
		</div>

		<script type="text/javascript" src="/(cms)/module/static/default/content/libs/js/general.js"></script>
		<script type="text/javascript">_lib_load( 'jQuery', 'MediaElement' );</script>
		<script type="text/javascript">
			if ( !( 'last' in jQuery.fn ) ) {
				jQuery.fn.last = function(){
					return this.filter( ':last' );
				};
			};
			jQuery( '#media_display_<xsl:value-of select="$id" />' ).mediaelementplayer({
				<xsl:if test="media_display/media_display_mute=1">
					startVolume: 0,
				</xsl:if>
				<xsl:if test="media_preview_url">
					poster: '<xsl:value-of select="media_preview_url" />',
				</xsl:if>
				<xsl:if test="media_display/media_display_loop=1">
					loop: true,
				</xsl:if>
				<xsl:if test="media_display/media_display_controls=1">
					alwaysShowControls: true,
				</xsl:if>
				pluginPath: '/(cms)/module/static/default/content/libs/js/mediaelement-2.14.2/',
				videoWidth: -1,
				videoHeight: -1,
				audioWidth: 400,
				audioHeight: 30,
				//enableAutosize: true,
				features: ['playpause','progress','current','duration','tracks','volume','fullscreen'],
				iPadUseNativeControls: false,
				iPhoneUseNativeControls: false,
				AndroidUseNativeControls: false,
				alwaysShowHours: false,
				showTimecodeFrameCount: false,
				framesPerSecond: 25,
				enableKeyboard: false,
				pauseOtherPlayers: true,
				keyActions: [],
				<!-- dirty fix: in firefox medialement never stops loading -->
				success: function (mediaElement, domObject) {
					setTimeout(function(){
						mediaElement.play();
						mediaElement.pause();

						setTimeout(function(){
							jQuery( '#media_display_wrapper_<xsl:value-of select="$id" />' )
								.find( '.mejs-poster' )
								.css({ display: 'block' });
						}, 25 );
					}, 50 );
				}
			});
		</script>
	</xsl:template>

	<xsl:template match="content:gallery[ ancestor::site:content-item[@name='content'] and count(gallery-items/*)=1 and count( gallery-items/*[1]/pois/* )&gt;10]">
		<xsl:variable name="id" select="@id" />
		<xsl:variable name="media" select="gallery-items/*[1]" />
		<div class="schwarz-ausflugsziele">
			<xsl:if test="string-length(gallery/mcg_name) &gt; 0">
				<h3><xsl:value-of select="gallery/mcg_name" /></h3>
			</xsl:if>
			<xsl:if test="string-length(gallery/mcgi_text) &gt; 0">
				<p><xsl:value-of select="gallery/mcgi_text" /></p>
			</xsl:if>
			<div class="map-image" id="mip_{$id}">
				<img src="{$dev_domain}/media/{$media/media_file_folder}/{$media/media_file_name}-{$media/media_file_id}.{$media/media_file_type}" width="{$media/media_file_width}" height="{$media/media_file_height}" alt="{$media/media_file_alt}" />
				<xsl:for-each select="$media/pois/*">
					<div class="map-image-poi" id="mip_{$id}_{position()}">
						<div class="map-image-poi-hover"></div>
						<div class="map-image-poi-info">
							<xsl:copy-of select="media_poi_text_xml/node()" />
						</div>
					</div>
				</xsl:for-each>
			</div>
		</div>
		<xsl:variable name="map-css">
			<xsl:for-each select="$media/pois/*">
				<xsl:variable name="x" select="number( media_poi_left ) div number( media_poi_media_width )" />
				<xsl:variable name="y" select="number( media_poi_top ) div number( media_poi_media_height )" />
				#mip_<xsl:value-of select="$id" />_<xsl:value-of select="position()" /> .map-image-poi-info {
					-webkit-transform: translateX( <xsl:value-of select="format-number(-100*$x,'#.###')" />% );
					-moz-transform: translateX( <xsl:value-of select="format-number(-100*$x,'#.###')" />% );
					transform: translateX( <xsl:value-of select="format-number(-100*$x,'#.###')" />% );
				}
				#mip_<xsl:value-of select="$id" />_<xsl:value-of select="position()" />{
					left:<xsl:value-of select="format-number(100*$x,'#.###')" />%;
					top:<xsl:value-of select="format-number(100*$y,'#.###')" />%;
				}
			</xsl:for-each>
		</xsl:variable>
		<script type="text/javascript">
			$('#mip_<xsl:value-of select="$id" />').find('img[src^=cdata]').each(function(i,el){el.src=el.src.replace(/^.*#/,'')});
		</script>
		<style type="text/css"><xsl:value-of select="normalize-space($map-css)"/></style>
	</xsl:template>

	<!-- ### CALENDAR KALENDER -->

	<xsl:template match="content:calendar-display-options" />

	<xsl:template match="content:calendar-display-control">
		<xsl:variable name="id" select="@id" />
		<xsl:variable name="calendar-strings" select="calendar-strings" />
		<xsl:variable name="calendar-view" select="../site:calendar-view[@id=$id]" />

		<form name="control-views-form">
			<input type="hidden"  name="date" value="{substring(view/@display-from,0,11)}" />
		</form>
		<table class="calendar-display calendar-display-control">
			<tr>
				<td class="control-back">
					<xsl:if test="view/@display-type!='detail'">
						<a class="fa disabled">
							<xsl:if test="$calendar-view/offset/days &gt; -30">
								<xsl:attribute name="href"><xsl:value-of select="@url-back" /></xsl:attribute>
								<xsl:attribute name="class">fa</xsl:attribute>
							</xsl:if>
							&#xf053;
						</a>
					</xsl:if>
				</td>
				<td class="control-date">
					<h2>
						<xsl:variable name="view" select="view" />
						<xsl:choose>
							<xsl:when test="view/@display-part='year'"><xsl:value-of select="view/texts/year/@text" /></xsl:when>
							<xsl:when test="view/@display-part='halfyear'"><xsl:value-of select="//calendars/*/calendar_name" />&#160;<xsl:value-of select="view/texts/halfyear/@text" /></xsl:when>
							<xsl:when test="view/@display-part='quarter'"><xsl:value-of select="view/texts/quarter/@text" />. <xsl:value-of select="$calendar-strings/string[@name='quarter']" />&#160;<xsl:value-of select="view/texts/year/@text" /></xsl:when>
							<xsl:when test="view/@display-part='month'"><xsl:value-of select="$calendar-strings/string[@name=concat('month.',$view/texts/month/@value)]" />&#160;<xsl:value-of select="view/texts/year/@text" /></xsl:when>
							<xsl:when test="view/@display-part='week'"><a href="{view/texts/week/@url}"><xsl:value-of select="view/texts/week/@text" /></a>. <xsl:value-of select="$calendar-strings/string[@name='week']" />&#160;<xsl:value-of select="view/texts/year/@text" /></xsl:when>
							<xsl:when test="view/@display-part='day'"><xsl:value-of select="$calendar-strings/string[@name=concat('weekday.',$view/texts/weekday/@value)]" />, <xsl:value-of select="view/texts/day/@text" />. <a href="{view/texts/month/@url}"><xsl:value-of select="$calendar-strings/string[@name=concat('month.',$view/texts/month/@value)]" /></a>&#160;<xsl:value-of select="view/texts/year/@text" /></xsl:when>
						</xsl:choose>
					</h2>
				</td>
				<td class="control-next">
					<xsl:if test="view/@display-type!='detail'">
						<a class="fa disabled">
							<xsl:if test="$calendar-view/offset/days &lt; 365">
								<xsl:attribute name="href"><xsl:value-of select="@url-next" /></xsl:attribute>
								<xsl:attribute name="class">fa</xsl:attribute>
							</xsl:if>
							&#xf054;
						</a>
					</xsl:if>
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template match="site:calendar-view[view/@display-type='calendar' and view/@display-part='month']">
		<xsl:variable name="id" select="@id" />
		<xsl:variable name="calendar-control" select="../content:calendar-display-control[@id=$id]" />
		<xsl:variable name="calendar-strings" select="$calendar-control/calendar-strings" />

		<table class="calendar-display calendar-display-view calendar-display-view-calendar-month">
			<tr class="view-weekdays">
				<td class="view-weekdays-head-kw">KW</td>
				<xsl:for-each select="$calendar-strings/string[starts-with(@name,'weekday.short.')]">
					<xsl:variable name="wd-pos" select="position()" />
					<td class="view-weekdays-head-{$wd-pos}">
						<span class="mobi-show">
							<xsl:value-of select="."/>
						</span>
						<span class="mobi-hide">
							<xsl:value-of select="$calendar-strings/string[@name = concat( 'weekday.', $wd-pos )]"/>
						</span>
					</td>
				</xsl:for-each>
			</tr>
			<xsl:for-each select="dates/weeks/*">
				<tr>
					<xsl:if test="@current='true'"><xsl:attribute name="class">view-week-current</xsl:attribute></xsl:if>
					<td class="view-week">
						<xsl:value-of select="@week" />
					</td>
					<xsl:for-each select="day">
						<xsl:variable name="pos_day" select="position()" />
						<xsl:variable name="day" select="." />
						<xsl:variable name="dates" select="count(dates/*)" />
						<xsl:variable name="td-class">
							<!-- tag innerhalb des aktuellen monats? -->
							<xsl:if test="@state='in'">view-day-in</xsl:if>
							<!-- tag NICHT innerhalb des aktuellen monats? -->
							<xsl:if test="@state='out'">view-day-out</xsl:if>
							<!-- termine fuer heute? -->
							<xsl:if test="count(dates/*)&gt;0"><xsl:text> </xsl:text>view-day-dates</xsl:if>
							<!-- heute? -->
							<xsl:if test="@current='true'"><xsl:text> </xsl:text>view-day-current</xsl:if>
							<!-- timeframe? -->
							<xsl:if test="@timeframe"><xsl:text> </xsl:text>calendar-timeframe calendar-timeframe-<xsl:value-of select="@timeframe" /></xsl:if>
							<xsl:if test="$pos_day &gt;= 6"><xsl:text> </xsl:text>we</xsl:if>
						</xsl:variable>
						<td name="anchor-{@month}-{@day}" id="anchor-{@month}-{@day}" class="view-day {$td-class}">
							<!--<xsl:if test="$view/options/show-day-overlay='true'">
								<xsl:attribute name="onmouseover">if( typeof calendar_event_day_over == 'function' ) calendar_event_day_over(this,'<xsl:value-of select="@state" />','<xsl:value-of select="@day" />','<xsl:value-of select="@month" />','<xsl:value-of select="//calendar-strings/string[@name=concat('month.',$day/@month)]" />','<xsl:value-of select="@year" />',<xsl:value-of select="$pos_week" />,<xsl:value-of select="$pos_day" />);</xsl:attribute>
								<xsl:attribute name="onmouseout">if( typeof calendar_event_day_out == 'function' ) calendar_event_day_out(this);</xsl:attribute>
							</xsl:if>-->
							<!--<div class="view-day-current" id="view-day-current"><xsl:if test="@current='true'"> (<xsl:value-of select="//calendar-strings/string[@name='today']" />)</xsl:if></div>-->
							<div class="view-day">
								<span><xsl:value-of select="@day" /></span>
							</div>
							<xsl:if test="not(../../../../@hide-dates='true') and $dates&gt;0">
								<div class="view-day-has-event mobi-show">
									<a href="{@url}" class="fa">&#xf058;</a>
								</div>
								<div class="dates mobi-hide">
									<div class="dates-list">
										<xsl:for-each select="dates/*[position()&lt;=2]">
											<div class="date">
												<xsl:if test="position() &gt; 4">
													<xsl:attribute name="class">date date-overflow-4</xsl:attribute>
												</xsl:if>
												<xsl:choose>
													<xsl:when test="calendar_date_raw"><div class="date-time-raw" style="position: relative"><xsl:copy-of select="calendar_date_raw" /></div></xsl:when>
													<xsl:otherwise>
														<div class="date-time-from-hour">
															<xsl:choose>
																<xsl:when test="calendar_date_time_fulltime = 1">
																	<xsl:text>00:00 - 24:00</xsl:text>
																</xsl:when>

																<xsl:otherwise>
																	<xsl:value-of select="substring(calendar_date_time_from,12,5)" />
																	<xsl:if test="calendar_date_time_to != calendar_date_time_from and substring(calendar_date_time_to,1,10) = substring(calendar_date_time_from,1,10)">
																		- <xsl:value-of select="substring(calendar_date_time_to,12,5)" />
																	</xsl:if>
																</xsl:otherwise>
															</xsl:choose>
														</div>
														<div class="date-name"><a href="{$day/@url}" class="calendar-date-type-{calendar_date_type}" title="{calendar_date_name}"><xsl:value-of select="calendar_date_name" /></a></div>
														<div class="date-location"><xsl:value-of select="calendar_date_location" /></div>
														<div class="date-description"><xsl:value-of select="substring(calendar_date_description,0,100)" disable-output-escaping="yes" /><xsl:if test="string-length(calendar_date_description)&gt;100"> ..</xsl:if></div>
													</xsl:otherwise>
												</xsl:choose>
											</div>
										</xsl:for-each>
									</div>
								</div>
							</xsl:if>
							<div class="view-more">
								<xsl:if test="count(dates/*) &gt; 4">...</xsl:if>
							</div>
						</td>
					</xsl:for-each>
				</tr>
			</xsl:for-each>
		</table>
		<xsl:apply-templates select="@subpage-handled" />
	</xsl:template>

	<xsl:template match="site:calendar-view[view/@display-part='day']">
		<div class="calendar-display calendar-display-view calendar-display-view-list-day">
			<xsl:if test="dates/hours/fulltime/dates/*">
				<div class="fulltime">
					<h3>Events</h3>
					<xsl:for-each select="dates/hours/fulltime/dates/*">
						<div>
							<xsl:attribute name="class">date-fulltime<xsl:if test="position() = last()"> last</xsl:if></xsl:attribute>
							<h4><xsl:value-of select="calendar_date_name" /></h4>
							<p>Ganzen Tag</p>
							<xsl:if test="string-length(calendar_date_location)&gt;0"><p class="date-location">Ort: <xsl:value-of select="calendar_date_location" /></p></xsl:if>
							<xsl:if test="string-length(calendar_date_description)&gt;0"><div class="date-description"><h4>Beschreibung</h4><xsl:copy-of select="calendar_date_description" /></div></xsl:if>
						</div>
					</xsl:for-each>
				</div>
			</xsl:if>
			<xsl:if test="count(dates/hours/hour/dates/*)&gt;0">
				<h3>Tagesplanung</h3>
				<xsl:for-each select="dates/hours/hour[count(dates/*)&gt;0]">
					<xsl:variable name="hour" select="@hour" />
					<xsl:for-each select="dates/*">
						<div class="calendar-date-title">
							<xsl:value-of select="$hour" />:<xsl:value-of select="substring(calendar_date_time_from,15,2)" />
							<xsl:if test="calendar_date_time_to != calendar_date_time_from and substring(calendar_date_time_to,1,10) = substring(calendar_date_time_from,1,10)"> - <xsl:value-of select="substring(calendar_date_time_to,12,5)" /></xsl:if>
							&#160;<strong><xsl:value-of select="calendar_date_name" /></strong>
						</div>
						<div class="calendar-date-description"><xsl:value-of select="calendar_date_description" disable-output-escaping="yes" /></div>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:if>
			<p><a class="cta" href="{../content:calendar-display-control/view/texts/month/@url}">Zurück</a></p>
		</div>
		<xsl:apply-templates select="@subpage-handled" />
	</xsl:template>

	<xsl:template match="site:calendar-view/@subpage-handled">
		<!-- kalender unterseiten scrollen automatisch dahin -->
		<xsl:if test=".=1">
			<script type="text/javascript">
				nst2015.opt.window.scrollTop( nst2015.opt.main.offset().top );
			</script>
		</xsl:if>
	</xsl:template>

	<!-- ######## WEBLOG ######## -->

	<xsl:template match="content:weblog-teaser-list">
		<div class="weblog-teaser-title"><h2><a href="{posts/*/@url-weblog}"><xsl:value-of select="weblog-teaser/weblog_teaser_title" /></a></h2></div>
		<div class="weblog-teaser-list grp" data-attr-layout="spalten" data-children="{count(posts/*)}">
			<xsl:for-each select="posts/*">
				<a href="{@url}" class="grp-row weblog-teaser-post">
					<xsl:if test="weblog_post_date_new='1'">
						<div class="weblog-post-date-new"><xsl:text/></div>
					</xsl:if>
					<h3 class="weblog-teaser-post-name">
						<xsl:value-of select="weblog_post_name"/>
					</h3>
					<div class="weblog-teaser-post-teaser dotdotdot">
						<xsl:choose>
							<xsl:when test="weblog_post_teaser_html">
								<xsl:value-of select="weblog_post_teaser/node()" disable-output-escaping="yes"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="weblog_post_teaser/node()"/>
							</xsl:otherwise>
						</xsl:choose>
					</div>
					<div class="weblog-teaser-more"><xsl:value-of select="content:ls('read more')" /></div>
				</a>
			</xsl:for-each>
		</div>
	</xsl:template>

	<!--
		eingabe:    language string ID [, language iso code ]
		rückgabe    übersetzte string

		beispiel:   content:ls('back home')         content:ls('back home','','en')     content:ls('main page','Lorem Ipsum')
		            gibt: Zurück zur Startseite     gibt: Back to the Homepage          gibt: Lorem Ipsum Übersichtsseite
	-->
	<func:function name="content:ls">
		<xsl:param name="ls" />
		<xsl:param name="secondary-text" select="''" />
		<xsl:param name="lang" select="/site:site/site:page/@page-language-iso" />

		<func:result><xsl:choose>
			<xsl:when test="$ls='menu'">
				<xsl:choose>
					<xsl:when test="$lang='de'">Menü</xsl:when>
					<xsl:otherwise>Menu</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$ls='back home'">
				<xsl:choose>
					<xsl:when test="$lang='de'">Zurück zur Startseite</xsl:when>
					<xsl:when test="$lang='fr'">Retour à l’accueil</xsl:when>
					<xsl:otherwise>Back to the Homepage</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$ls='home'">
				<xsl:choose>
					<xsl:when test="$lang='de'">Startseite</xsl:when>
					<xsl:when test="$lang='fr'">Accueil</xsl:when>
					<xsl:otherwise>Homepage</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$ls='main page'">
				<xsl:choose>
					<xsl:when test="$lang='de'"><xsl:value-of select="$secondary-text" /> Übersichtsseite</xsl:when>
					<xsl:when test="$lang='fr'">Page principale <xsl:value-of select="$secondary-text" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="$secondary-text" /> main page</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$ls='to main page'">
				<xsl:choose>
					<xsl:when test="$lang='de'">Zur Übersichtsseite</xsl:when>
					<xsl:when test="$lang='fr'">À la page principale</xsl:when>
					<xsl:otherwise>To the main page</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$ls='back'">
				<xsl:choose>
					<xsl:when test="$lang='de'">Zurück</xsl:when>
					<xsl:when test="$lang='fr'">Retour</xsl:when>
					<xsl:otherwise>Back</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$ls='my theme'">
				<xsl:choose>
					<xsl:when test="$lang='de'"><span class="txt-my">Mein</span><span class="txt-theme">Thema</span><span class="txt-question">?</span></xsl:when>
					<xsl:when test="$lang='fr'"><span class="txt-my">Mon</span><span class="txt-theme">theme</span><span class="txt-question"> ?</span></xsl:when>
					<xsl:otherwise><span class="txt-my">My</span><span class="txt-theme">theme</span><span class="txt-question">?</span></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$ls='overview'">
				<xsl:choose>
					<xsl:when test="$lang='de'">Übersicht</xsl:when>
					<xsl:when test="$lang='fr'">Tout voir</xsl:when>
					<xsl:otherwise>Overview</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$ls='learn more'">
				<xsl:choose>
					<xsl:when test="$lang='de'">Mehr erfahren</xsl:when>
					<xsl:when test="$lang='fr'">En savoir plus</xsl:when>
					<xsl:when test="$lang='it'">Più informazioni</xsl:when>
					<xsl:when test="$lang='pt'">Mais informaçoes</xsl:when>
					<xsl:otherwise>Learn more</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$ls='read more'">
				<xsl:choose>
					<xsl:when test="$lang='de'">Weiterlesen</xsl:when>
					<xsl:when test="$lang='fr'">En savoir plus</xsl:when>
					<xsl:when test="$lang='it'">Più informazioni</xsl:when>
					<xsl:when test="$lang='pt'">Mais informaçoes</xsl:when>
					<xsl:otherwise>Read more</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$ls='arrival'">
				<xsl:choose>
					<xsl:when test="$lang='de'">Anreise</xsl:when>
					<xsl:when test="$lang='fr'">Arrivée</xsl:when>
					<xsl:when test="$lang='it'">Arrivo</xsl:when>
					<xsl:when test="$lang='pt'">Chegada</xsl:when>
					<xsl:otherwise>Arrival</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$ls='departure'">
				<xsl:choose>
					<xsl:when test="$lang='de'">Abreise</xsl:when>
					<xsl:when test="$lang='fr'">Départ</xsl:when>
					<xsl:when test="$lang='it'">Partenza</xsl:when>
					<xsl:when test="$lang='pt'">Partida</xsl:when>
					<xsl:otherwise>Departure</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$ls='book'">
				<xsl:choose>
					<xsl:when test="$lang='de'">Buchen</xsl:when>
					<xsl:when test="$lang='fr'">Réserver</xsl:when>
					<xsl:when test="$lang='it'">Prenota</xsl:when>
					<xsl:when test="$lang='pt'">Reservar</xsl:when>
					<xsl:when test="$lang='nl'">Boeken</xsl:when>
					<xsl:when test="$lang='ru'">Забронировать</xsl:when>
					<xsl:otherwise>Book</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$ls='inquire' or $ls='request'">
				<xsl:choose>
					<xsl:when test="$lang='de'">Anfragen</xsl:when>
					<xsl:when test="$lang='fr'">Demander</xsl:when>
					<xsl:when test="$lang='it'">Richiesta</xsl:when>
					<xsl:when test="$lang='nl'">Aanvragen</xsl:when>
					<xsl:when test="$lang='ru'">Запрос</xsl:when>
					<xsl:otherwise>Inquire</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$ls='search'">
				<xsl:choose>
					<xsl:when test="$lang='de'">Suchen</xsl:when>
					<xsl:when test="$lang='fr'">Chercher</xsl:when>
					<xsl:when test="$lang='it'">Cerca</xsl:when>
					<xsl:when test="$lang='pt'">Procurar</xsl:when>
					<xsl:otherwise>Search</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$ls='availability'">
				<xsl:choose>
					<xsl:when test="$lang='de'">Verfügbarkeiten prüfen</xsl:when>
					<xsl:when test="$lang='fr'">Voir les disponibilités</xsl:when>
					<xsl:when test="$lang='it'">Verifica la disponibilità</xsl:when>
					<xsl:when test="$lang='nl'">Beschikbaarheid</xsl:when>
					<xsl:when test="$lang='ru'">Забронировать</xsl:when>
					<xsl:otherwise>Check room availability</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$ls='voucher'">
				<xsl:choose>
					<xsl:when test="$lang='de'">Gutschein</xsl:when>
					<xsl:when test="$lang='fr'">Bon cadeau</xsl:when>
					<xsl:otherwise>Voucher</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$ls='book and request'">
				<xsl:choose>
					<xsl:when test="$lang='de'">Buchen &amp; Anfragen</xsl:when>
					<xsl:when test="$lang='fr'">Réserver &amp; Demander</xsl:when>
					<xsl:otherwise>Book &amp; Request</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$ls='map'">
				<xsl:choose>
					<xsl:when test="$lang='de'">Umgebungskarte</xsl:when>
					<xsl:when test="$lang='fr'">Carte des environs</xsl:when>
					<xsl:otherwise>Map of the Region</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$ls='address'">
				<xsl:choose>
					<xsl:when test="$lang='de'">Ihre Adresse</xsl:when>
					<xsl:when test="$lang='fr'">Votre adresse</xsl:when>
					<xsl:otherwise>Your address</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$ls='route-planner'">
				<xsl:choose>
					<xsl:when test="$lang='de'">Routenplaner</xsl:when>
					<xsl:when test="$lang='fr'">Calcul d’itinéraire</xsl:when>
					<xsl:when test="$lang='it'">Calcola il percorso</xsl:when>
					<xsl:when test="$lang='es'">Planeador de rutas</xsl:when>
					<xsl:when test="$lang='nl'">Routeplanner</xsl:when>
					<xsl:when test="$lang='ru'">Расчет маршрута</xsl:when>
					<xsl:otherwise>Route Planner</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$ls='route'">
				<xsl:choose>
					<xsl:when test="$lang='de'">Route</xsl:when>
					<xsl:when test="$lang='fr'">Itinéraire</xsl:when>
					<xsl:otherwise>Route</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$ls='adults.numerus'">
				<xsl:value-of select="$secondary-text" />
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="$lang='de'">
						<xsl:choose>
							<xsl:when test="$secondary-text = 1">Erwachsener</xsl:when>
							<xsl:otherwise>Erwachsene</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$lang='fr'">
						<xsl:choose>
							<xsl:when test="$secondary-text = 1">adulte</xsl:when>
							<xsl:otherwise>adultes</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$lang='it'">
						<xsl:choose>
							<xsl:when test="$secondary-text = 1">adulto</xsl:when>
							<xsl:otherwise>adulti</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$lang='es'">
						<xsl:choose>
							<xsl:when test="$secondary-text = 1">adulto</xsl:when>
							<xsl:otherwise>adultos</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$lang='nl'">
						<xsl:choose>
							<xsl:when test="$secondary-text = 1">volwassene</xsl:when>
							<xsl:otherwise>volwassenen</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$lang='ru'">
						<xsl:choose>
							<xsl:when test="$secondary-text = 1">взрослый</xsl:when>
							<xsl:otherwise>взрослых</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$secondary-text = 1">adult</xsl:when>
							<xsl:otherwise>adults</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$ls='children.numerus'">
				<xsl:choose>
					<xsl:when test="$lang='de'">
						<xsl:choose>
							<xsl:when test="$secondary-text = 0">Keine Kinder</xsl:when>
							<xsl:when test="$secondary-text = 1">1 Kind</xsl:when>
							<xsl:otherwise><xsl:value-of select="$secondary-text" /> Kinder</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$lang='fr'">
						<xsl:choose>
							<xsl:when test="$secondary-text = 0">Pas d’enfant</xsl:when>
							<xsl:when test="$secondary-text = 1">1 enfant</xsl:when>
							<xsl:otherwise><xsl:value-of select="$secondary-text" /> enfants</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$lang='nl'">
						<xsl:choose>
							<xsl:when test="$secondary-text = 0">Geen kinderen</xsl:when>
							<xsl:when test="$secondary-text = 1">1 kind</xsl:when>
							<xsl:otherwise><xsl:value-of select="$secondary-text" /> kinderen</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$lang='ru'">
						<xsl:choose>
							<xsl:when test="$secondary-text = 0">нет детей</xsl:when>
							<xsl:when test="$secondary-text = 1">1 ребенок</xsl:when>
							<xsl:when test="$secondary-text &lt;5"><xsl:value-of select="$secondary-text" /> ребенка</xsl:when>
							<xsl:otherwise><xsl:value-of select="$secondary-text" /> детей</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$secondary-text = 0">No children</xsl:when>
							<xsl:when test="$secondary-text = 1">1 child</xsl:when>
							<xsl:otherwise><xsl:value-of select="$secondary-text" /> children</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>Not found: <xsl:value-of select="$ls" /></xsl:otherwise>
		</xsl:choose></func:result>
	</func:function>

	<!-- Zeilseite SPA Anfrage wenn es im Warenkorb 1+ HP und 0 HRT/HPA gibt -->
	<xsl:template match="content:clearingstation-box-remember-vnh-events">
		cst_remember.layer_has_changed = function( layer ){
			var cookie = cst_remember.cookie_get();
			var items = {
				'hpa': 0,
				'hrt': 0,
				'hp': 0
			};
			for( var item_group in cookie ){
				for( var item in cookie[item_group]['items'] ){
					items[ cookie[item_group]['items'][item]['type'] ]++;
				}
			}
			var book_link = $(layer).parent().find('a.vnh-request');
			book_link.attr('href', book_link.attr('href').replace( /page\=[\d]\.page1/, 'page=' + ( items.hp != 0 ? (items.hpa + items.hrt == 0 ? 6 : 2 ) : 2 ) + '.page1' ) );
		};
	</xsl:template>

	<xsl:template match="content:social-media[@layout='button']">
		<div class="social-media-buttons">
			<xsl:for-each select="sources/*">
				<a href="{@url-absolute}" onclick="this.target='_blank'" class="social-media-button social-media-source-{settings/social_media_source_type_class}">
					<span><xsl:value-of select="settings/social_media_source_type_name" /></span>
				</a>
			</xsl:for-each>
		</div>
	</xsl:template>

	<xsl:template match="content:social-media[@layout='list']">
		<div class="social-media-list">
			<xsl:for-each select="sources/*">
				<div class="social-media-list-{settings/social_media_source_type_class}">
					<h3><xsl:value-of select="settings/social_media_source_type_name" /></h3>
					<div class="social-media-list-items">
						<xsl:for-each select="content/items/*">
							<a href="{url}" class="social-media-list-item">
								<xsl:if test="string-length( image/@src ) &gt; 0">
									<div class="social-media-list-item-image">
										<img src="{image/@src}" alt="{title}" />
									</div>
								</xsl:if>
								<div class="social-media-list-item-title"><xsl:value-of select="title" /></div>
								<div class="social-media-list-item-ts"><xsl:value-of select="date/text()" /></div>
							</a>
						</xsl:for-each>
					</div>
				</div>
			</xsl:for-each>
		</div>
	</xsl:template>

	<xsl:decimal-format name="vsp-currency" decimal-separator="," grouping-separator=" "  NaN="—" />

	<!-- vsp // vioma static prices -->
	<xsl:template match="content:article1[@attr-layout='preise']">
		<xsl:variable name="nbsp">&#160;</xsl:variable>
		<div id="prices_{@id}" class="vsp-wrap">
			<xsl:for-each select="xml/*">
				<xsl:choose>
					<xsl:when test="name() = 'table'">
						<xsl:variable name="lines" select=".//tr" />
						<xsl:variable name="season-name" select="normalize-space( $lines[1]/td[1] )" />
						<xsl:variable name="season-index" select="position()" />
						<xsl:variable name="season-start-col">
							<xsl:choose>
								<xsl:when test="$lines[1]/td[2] = 'Zimmer ID' and $lines[1]/td[3] = 'Belegung'">4</xsl:when>
								<xsl:when test="$lines[1]/td[2] = 'Room ID' and $lines[1]/td[3] = 'Occupancy'">4</xsl:when>
								<xsl:when test="$lines[1]/td[2] = 'Zimmer ID' and $lines[1]/td[3] != 'Belegung'">3</xsl:when>
								<xsl:when test="$lines[1]/td[2] = 'Room ID' and $lines[1]/td[3] != 'Occupancy'">3</xsl:when>
								<xsl:otherwise>2</xsl:otherwise>
							</xsl:choose></xsl:variable>
						<div class="vsp-season" data-cols="{$season-start-col}">
							<h3 class="vsp-season-name"><xsl:value-of select="$season-name" /></h3>
							<div class="vsp-season-prices" id="season_{$season-index}">
								<div class="vsp-roomtypes-head">
									<div class="vsp-roomtype-name-spacer vsp-column-fixed">&#160;</div>
									<div class="vsp-viewport">
										<div class="vsp-roomtype-prices">
											<xsl:for-each select="$lines[1]/td[position()&gt;=number($season-start-col)]">
												<div class="vsp-column">
													<xsl:copy-of select="." />
												</div>
											</xsl:for-each>
										</div>
									</div>
								</div>
								<xsl:for-each select="$lines[position()&gt;1 and string-length(td[1])&gt;1]">
									<xsl:variable name="hrt_name" select="td[1]" />
									<xsl:variable name="hrt_id"><xsl:choose>
										<xsl:when test="$season-start-col = 3 or $season-start-col = 4"><xsl:value-of select="td[2]" /></xsl:when>
										<xsl:otherwise>-1</xsl:otherwise>
									</xsl:choose></xsl:variable>
									<xsl:for-each select=".|following-sibling::*[td[2] = $hrt_id]">
										<div class="vsp-roomtype">
											<xsl:if test="$hrt_id != -1">
												<xsl:attribute name="data-hrt"><xsl:value-of select="translate( $hrt_id, $nbsp, ' ' )" /></xsl:attribute>
											</xsl:if>
											<xsl:if test="position()=last()">
												<xsl:attribute name="class">vsp-roomtype vsp-separator</xsl:attribute>
											</xsl:if>
											<div class="vsp-roomtype-head vsp-column-fixed">
												<xsl:if test="$season-start-col = 4 and td[3] &gt; 0">
													<div class="vsp-alloc"><xsl:value-of select="td[3]" /></div>
												</xsl:if>
												<xsl:if test="position()=1">
													<div class="vsp-roomtype-name">
														<xsl:copy-of select="$hrt_name" />
													</div>
												</xsl:if>
											</div>
											<div class="vsp-viewport">
												<div class="vsp-roomtype-prices">
													<xsl:for-each select="td[position() &gt;= $season-start-col]">
														<xsl:variable name="hrt_price" select="number( normalize-space( translate( translate( ., ',', '.' ), $nbsp, ' ' ) ) )" />
														<div class="vsp-roomtype-price vsp-column">
															<div class="vsp-price">
																<xsl:choose>
																	<xsl:when test="string($hrt_price) != 'NaN'">
																		<xsl:variable name="vsp-price-format"><xsl:choose>
																			<xsl:when test="$hrt_price - floor( $hrt_price ) = 0"># ##0,--</xsl:when>
																			<xsl:otherwise># ##0,00</xsl:otherwise>
																		</xsl:choose></xsl:variable>
																		<xsl:text>€ </xsl:text><xsl:value-of select="format-number( $hrt_price, $vsp-price-format, 'vsp-currency')" />
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:copy-of select="." />
																	</xsl:otherwise>
																</xsl:choose>
															</div>
														</div>
													</xsl:for-each>
												</div>
											</div>
										</div>
									</xsl:for-each>
								</xsl:for-each>
							</div>
						</div>
					</xsl:when>
					<xsl:otherwise><xsl:copy-of select="." /></xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</div>
		<script type="text/javascript">_lib_load('fontawesome')</script>
		<link rel="stylesheet" type="text/css" href="/static/2013/css/preistabelle.css" class="vsp-resources" />
		<script type="text/javascript" src="/static/2013/js/preistabelle.js" class="vsp-resources"></script>
		<script type="text/javascript">$('#prices_<xsl:value-of select="@id" />').find('.vsp-season').vsp({ collapse: '.vsp-season-prices', collapsed: false })</script>
	</xsl:template>

</xsl:stylesheet>
