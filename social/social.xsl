<?xml version = "1.0" encoding = "UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:site="http://xmlns.webmaking.ms/site/"
                xmlns:cstc="http://xmlns.webmaking.ms/cstc/"
                xmlns:content="http://xmlns.webmaking.ms/content/"
                exclude-result-prefixes="site cstc content">
	
	<xsl:output method="html"/>
	
	
	<xsl:template match="site:site">
		<html xmlns="http://www.w3.org/1999/xhtml" lang="de" xml:lang="de" class="no-touchevents noquirks">
			<head>
				<title>????</title>
				<meta name="robots" content="index, follow, noodp, noydir"/>
				<meta name="generator" content="Condeon 1.6.5"/>
				<link rel="canonical" href="http://3051-671.sites.condeon.net/de/hotel-prokulus/wissenswertes/"/>
				<meta name="theme-color" content="#930000"/>
				<meta name="viewport" content="initial-scale=1"/>
				<meta property="og:title" content=", Wissenswertes"/>
				<meta property="og:type" content="website"/>
				<link rel="stylesheet" type="text/css"
				      href="./sonnenhof/style.css"/>
				
				<!--<link href="./prokulus_files/wtf.css" rel="stylesheet" type="text/css"/>-->
				<style type="text/css" rel="stylesheet">
					main .grp[data-children='3'] > .grp-row-double {
						width: calc((200% - 50px) / 3);
					}
					
					.social-flex > * {
						box-sizing: border-box;
					}
					
					.social-flex {
						display: flex;
						flex-flow: row wrap;
						max-width: 1280px;
						margin: -4px;
					}
					
					.social-flex .source {
						flex: 0 1 -webkit-calc(25% - 16px);
						margin: 4px;
						overflow:hidden;
						position: relative;
						background: lightgrey;
						box-sizing: border-box;
					}
					
					.social-flex .source:first-child {
						flex: 0 1 -webkit-calc(50% - 16px);
						margin: 4px;
						box-sizing: border-box;
					}
					
					.social-flex::after {
						/*content: '';
						display: flex;
						flex: auto;
						background: white;*/
					}
					.weblog-layout1-post-meta {
						position:absolute;
						top:0;
						right:0;
					}
					.source-content {
						padding: 20px 20px 0 20px;
					}
					.source-image {
						display: block;
					}
					.source-image img {
						position: relative;
						left:50%;
						transform: translateX(-50%);
					}
					.read-more {
						margin: 10px 0;
					}
					.icon.weblog::after {
						
						content: '\f143';
					}
				</style>
			</head>
			<body class="social-media-png">
				<div id="site" class="site subnav-true" data-template="1801" data-variant="A" data-smoothscroll="yes">
					<main id="main">
						<xsl:apply-templates select="site:content['content']"/>
						<section class="grp grp- grp-layout-spalten" data-attr-layout="spalten" data-children="3">
							
							<div class="grp-mem grp-mem- grp-row">
								image
							</div>
							<div class="grp-mem grp-mem- grp-row grp-row-double" data-attr-layout="spalte-doppelbreite">
								<h2>2 Spalten</h2>
							</div>
						</section>
						<img src="social.jpg" width="1280"/>
					</main>
				</div>
				<div id="layout"></div>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="site:content['content']">
		<xsl:variable name="default_image">http://3277.condeon.dgi.w.og.vioma.de/static/template-1810/i/default_logo.jpg</xsl:variable>
		<!-- 2w  = 640 / 280 1w  = 320 / 280 -->
		<h1>List Style</h1>
		<div class="social-flex">
			<xsl:for-each select="./site:content-item/content:social-media[@layout='list']/sources/*">
				<xsl:variable name="name" select="name()"/>
				<!--<br/>-->
				<xsl:choose>
					<xsl:when test="$name='content:social-media-source-weblog'">
						<xsl:call-template name="social-media-source">
							<xsl:with-param name="source">weblog</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$name='content:social-media-source-facebook'">
						<xsl:call-template name="social-media-source">
							<xsl:with-param name="source">facebook</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$name='content:social-media-source-youtube'">
						<xsl:call-template name="social-media-source">
							<xsl:with-param name="source">youtube</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$name='content:social-media-source-instagram'">
						<xsl:call-template name="social-media-source">
							<xsl:with-param name="source">instagram</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$name='content:social-media-source-pinterest'">
						<xsl:call-template name="social-media-source">+
							<xsl:with-param name="source">pinterest</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<div class="source">
							Quelle: <xsl:value-of select="$name"/> nicht erkannt<br/>
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</div>
	</xsl:template>
	
	<xsl:template name="social-media-source">
		<xsl:param name="source"/>
		<xsl:variable name="default_image">http://3277.condeon.dgi.w.og.vioma.de/static/template-1810/i/default_logo.jpg</xsl:variable>
		<xsl:variable name="image" select="./content/items/item/image[1]"/>
		<xsl:variable name="item" select="./content/items/item[1]"/>
		<xsl:variable name="item-url">
			<xsl:choose>
				<xsl:when test="$source='pinterest'">
					<xsl:value-of select="$item/original-item/url"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$item/url"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="item-target">
			<xsl:choose>
				<xsl:when test="$source='weblog'">_self</xsl:when>
				<xsl:otherwise>_blank</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<div class="source">
				<a class="source-image" name="blog-bild" target="{$item-target}">
					<xsl:if test="string-length($item-url) &gt; 0">
						<xsl:attribute name="href">
							<xsl:value-of select="$item-url"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="$image/@media">
							<xsl:variable name="src">
								http://3277-682.sites.condeon.net/(cms)/media/resize/size=640x280,scale=crop/<xsl:value-of
									select="$image/@media"/>
							</xsl:variable>
							<img src="{$src}" alt="{./content/items/item/title}"/>
						</xsl:when>
						<xsl:when test="$image/@src">
							<img src="http://3277-682.sites.condeon.net/{$image/@src}" height="280" alt="{./content/items/item/title}"/>
						</xsl:when>
						<xsl:otherwise>
							<img src="{$default_image}" alt="{./content/items/item/title}"/>
						</xsl:otherwise>
					</xsl:choose>
				</a>
				<div class="source-content">
					<div class="content dotdotdot">
						<h3>
							<xsl:value-of select="./content/items/item/title"/>
						</h3>
						<xsl:value-of select="./content/items/item/content"/>
					</div>
					
					<xsl:if test="string-length($item-url) &gt; 0">
						<div class="read-more">
							<a href="{$item-url}" class="cta" target="{$item-target}">Weiterlesen</a>
						</div>
					</xsl:if>
				</div>
				<xsl:call-template name="meta">
					<xsl:with-param name="source" select="$source"/>
				</xsl:call-template>
			</div>
	</xsl:template>
	
	<xsl:template name="meta">
		<xsl:param name="source"/>
		<div class="weblog-layout1-post-meta">
			<div class="weblog-layout1-post-date">
				<span class="day">1.</span>
				<span class="month-year">
					<span class="month">Feb</span>
					<span class="year">2017</span>
				</span>
				<span class="icon {$source}"></span>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>