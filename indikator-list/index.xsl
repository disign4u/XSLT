<?xml version = "1.0" encoding = "UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:site="http://xmlns.webmaking.ms/site/"
				xmlns:cstc="http://xmlns.webmaking.ms/cstc/"
				exclude-result-prefixes="site cstc">

	<xsl:output method="html"/>

	<xsl:template match="cstc:indicator-teaser_">
		<xsl:variable name="url-type">
			<xsl:choose>
				<xsl:when test="../../@hotel=''">program-list.php</xsl:when>
				<xsl:otherwise>hotel-program-list.php</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="package-url">
			<xsl:choose>
				<xsl:when test="package-count=1 and package-id"><xsl:value-of select="$url-type" />?id=<xsl:value-of select="package-id" /></xsl:when>
				<xsl:otherwise><xsl:value-of select="$url-type" />?c[id_list_package_indicators][]=<xsl:value-of select="coi_id" />&amp;type=<xsl:value-of select="package-count-types/*[1]/@id" /><xsl:if test="../../@hotel and not(../../@hotel=0)"><xsl:if test="../../@hotel!=''">&amp;c[id_hotel]=<xsl:value-of select="../../@hotel" /></xsl:if></xsl:if></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<div class="cst-box cst-indicator cst-general-list-item cst-indicator-teaser cst-teaser cst-indicator-{coi_id}">
			<div class="cst-media cst-image-box cst-image-box-indicator">
				<xsl:attribute name="style">background-image:url('<xsl:value-of select="coi_image" />/462x462s');</xsl:attribute>
				<a href="{$url-type}?c[ids_program_indicators][]={coi_id}" title="{coi_name}">&#160;</a>
			</div>
			<div class="cst-box-content cst-indicator-teaser-text">
				<div class="cst-coi-title">
					<xsl:apply-templates select="//site:match-space/site-headline">
						<xsl:with-param name="type">3</xsl:with-param>
						<xsl:with-param name="title" select="coi_name/node()" />
						<xsl:with-param name="class">cst cst-indicator</xsl:with-param>
						<xsl:with-param name="href"><xsl:value-of select="$url-type" />?c[ids_program_indicators][]=<xsl:value-of select="coi_id" /></xsl:with-param>
					</xsl:apply-templates>
				</div>

				<div class="cst-indicator-description cst-description">
					<xsl:if test="string-length( coi_teaser ) &gt; 3">
						<div class="separator"></div>
						<xsl:value-of select="coi_teaser"/>
					</xsl:if>
				</div>

				<xsl:if test="package-count">
					<ul class="cst-buttons">
						<xsl:for-each select="package-count-types/*">
							<xsl:apply-templates select="//site:match-space/site-links/normal">
								<xsl:with-param name="url"><xsl:value-of select="$package-url"/></xsl:with-param>
								<xsl:with-param name="class">cst-indicator-link cst-indicator-packages-link cst-indicator-packages-link-<xsl:value-of select="name(.)" /></xsl:with-param>
								<xsl:with-param name="title">[%txt.packages.count/<xsl:value-of select="name(.)" />/<xsl:value-of select="." />]</xsl:with-param>
							</xsl:apply-templates>
						</xsl:for-each>
					</ul>
					<xsl:if test="package-count-types/normal">
					</xsl:if>
				</xsl:if>
				<xsl:if test="program-count">
					<div class="cst-indicator-programs-link-wrap">
						<a href="{$url-type}?c[ids_program_indicators][]={coi_id}" class="bgk-cta-text cst-indicator-link cst-indicator-programs-link">
							[%txt.programs.count/<xsl:value-of select="program-count" />]
						</a>
					</div>
				</xsl:if>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="cstc:indicator-teaser">
		<xsl:variable name="url-type">
			<xsl:choose>
				<xsl:when test="../../@hotel=''">program-list.php</xsl:when>
				<xsl:otherwise>hotel-program-list.php</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="package-url">
			<xsl:choose>
				<xsl:when test="package-count=1 and package-id"><xsl:value-of select="$url-type" />?id=<xsl:value-of select="package-id" /></xsl:when>
				<xsl:otherwise><xsl:value-of select="$url-type" />?c[id_list_package_indicators][]=<xsl:value-of select="coi_id" />&amp;type=<xsl:value-of select="package-count-types/*[1]/@id" /><xsl:if test="../../@hotel and not(../../@hotel=0)"><xsl:if test="../../@hotel!=''">&amp;c[id_hotel]=<xsl:value-of select="../../@hotel" /></xsl:if></xsl:if></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<section class="grp grp- grp-layout-spalten" data-attr-layout="spalten" data-children="3">
			<xsl:variable name="id" select="@id"/>
			<xsl:variable name="parent" select="@parent"/>
			<xsl:variable name="image" select="coi_image" />
			<xsl:variable name="title" select="coi_name" />
			<!--<xsl:variable name="url-type">
				<xsl:choose>
					<xsl:when test="../../@hotel=''">program-list.php</xsl:when>
					<xsl:otherwise>hotel-program-list.php</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="package-url">
				<xsl:choose>
					<xsl:when test="package-count=1 and package-id"><xsl:value-of select="$url-type" />?id=<xsl:value-of select="package-id" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="$url-type" />?c[id_list_package_indicators][]=<xsl:value-of select="coi_id" />&amp;type=<xsl:value-of select="package-count-types/*[1]/@id" /><xsl:if test="../../@hotel and not(../../@hotel=0)"><xsl:if test="../../@hotel!=''">&amp;c[id_hotel]=<xsl:value-of select="../../@hotel" /></xsl:if></xsl:if></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>-->
			<div class="grp-mem grp-mem-{$id} grp-row" data-parent="{$parent}">
				<a href="{$image}/size=1024x0,quality=70,interlace=1/"
				   data-fancybox-title="{normalize-space($title)}"
				   data-fancybox-type="image" class="fancybox animated" rel="group1">
					<img src="{$image}/size=380x250,scale=crop,interlace=1"
						 class="responsive"
						 srcset="{$image}/size=380x250,scale=crop 1x, {$image}/size=760x500,scale=crop 2x"
						 alt="{$title}"/>
					<ul class="external">
						<li class="zoom"></li>
					</ul>
				</a>
			</div>
			<div class="grp-mem grp-mem- grp-row grp-row-double" data-attr-layout="spalte-doppelbreite">
				<div class="flex-column">
					<h2 class="name"><xsl:value-of select="coi_name"/></h2>
					<div class="description"><xsl:copy-of select="coi_description"/></div>
					<div class="url">
						<a href="{$url-type}?c[ids_program_indicators][]={coi_id}" title="{coi_name}">
							<xsl:value-of select="program-count"/> Programme
						</a>
					</div>
				</div>
				<div style="display:none">
					<xsl:copy-of select="."/>
				</div>
			</div>
		</section>

	</xsl:template>

	<xsl:template match="cstc:site">
		<html xmlns="http://www.w3.org/1999/xhtml" lang="de" xml:lang="de" class="no-touchevents noquirks">
			<head>
				<title>Prokulus</title>
				<meta name="robots" content="index, follow, noodp, noydir"/>
				<meta name="generator" content="Condeon 1.6.5"/>
				<link rel="canonical" href="http://3051-671.sites.condeon.net/de/hotel-prokulus/wissenswertes/"/>
				<meta name="theme-color" content="#930000"/>
				<meta name="viewport" content="initial-scale=1"/>
				<meta property="og:title" content=", Wissenswertes"/>
				<meta property="og:type" content="website"/>
				<link rel="stylesheet" type="text/css"
					  href="./prokulus_files/site.css"/>

				<link href="./prokulus_files/wtf.css" rel="stylesheet" type="text/css"/>
				<style>
					main .grp[data-children='3']>.grp-row-double {
						width: calc((200% - 50px)/ 3);
					}
				</style>
			</head>
			<body class="social-media-png">
				<div id="site" class="site subnav-true" data-template="1801" data-variant="A" data-smoothscroll="yes">
					<main id="main">
						<xsl:apply-templates select="/site:site/cstc:frame/cstc:site/cstc:indicator-list/cstc:general-list/cstc:indicator-teaser">

						</xsl:apply-templates>

						<section class="grp grp- grp-layout-spalten" data-attr-layout="spalten" data-children="3">
							<div class="grp-mem grp-mem- grp-row">
								image
							</div>
							<div class="grp-mem grp-mem- grp-row grp-row-double" data-attr-layout="spalte-doppelbreite">
								<h2>2 Spalten</h2>
							</div>
						</section>
					</main>
				</div>
				<div id="layout"></div>
				<script type="text/javascript">var _lib_load_libs_loaded = {
					"reset": true,
					"jQuery-UI": true,
					"fontawesome": true,
					"jQuery-fancybox": true,
					"jQuery-fancybox-helper-thumbs": true,
					"ehandler": true,
					"jQuery": true,
					"jQuery-flexslider": true,
					"Cookies": true,
					"dotdotdot": true
					}</script>
				<script type="text/javascript"
						src="./prokulus_files/site.Download.js"></script>
				<script type="text/javascript">if (window.nst2015 !== undefined) {
					nst2015.opt.std_domain = 'http://3051-671.sites.condeon.net';
					}</script>
				<script type="text/javascript">jQuery('#g-header-gallery').flexslider(jQuery.extend({
					slideshowSpeed: 5000,
					animationSpeed: 1000,
					controlNav: false,
					slideshow: true,
					slideshowSpeed: 5000,
					animationSpeed: 1000,
					directionNav: true,
					prevText: '',
					nextText: '',
					animationLoop: true,
					before: function (s) {
					var next_slide = $(s.slides.slice(s.animatingTo - 1, s.animatingTo + 2)).addClass('on');
					next_slide.find('img.slide-img-lazy').each(function (i, el) {
					var $el = $(el);
					$el.attr({
					"src": $el.data('src'),
					"srcset": $el.data('srcset'),
					"sizes": $el.data('sizes'),
					"data-src": null,
					"data-srcset": null,
					"data-sizes": null
					}).removeClass('slide-img-lazy');
					});
					},
					animation: 'fade'
					}, {
					start: function (slider) {
					if (nst2015.opt.page_theme) {
					console.log(nst2015.opt.page_theme);
					$.each(slider.slides, function (i, el) {
					var theme = $(el).data('name');
					console.log("Slider Theme: " + theme);
					if (theme !== nst2015.opt.page_theme) {
					slider.removeSlide();
					}
					});
					slider.flexslider(0);
					} else {
					$.each(slider.slides, function (i, el) {
					var theme = $(el).data('name');
					console.log("Slider Theme: " + theme);
					if (theme !== '') {
					slider.removeSlide();
					}
					});
					slider.flexslider(0);
					}
					}
					}));</script>
				<script type="text/javascript">jQuery(function (jQuery) {
					jQuery('#widget_idm45973473583088_date_from').datepicker({
					closeText: 'X',
					prevText: '',
					nextText: '',
					currentText: 'Heute',
					monthNames: ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'],
					monthNamesShort: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
					dayNames: ['So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa'],
					dayNamesShort: ['So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa'],
					dayNamesMin: ['So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa'],
					dateFormat: 'dd.mm.yy',
					firstDay: 1,
					initStatus: 'Select a date',
					beforeShowDay: nst2015.cal_avail,
					isRTL: false,
					minDate: typeof calendar_avail_tf != 'undefined' ? nst2015.date_convert(calendar_avail_tf[0][0], 'ymd', 'Date') : '0',
					beforeShow: function (input, inst) {
					var endDate = jQuery('#widget_idm45973473583088_date_to').datepicker("getDate");
					if (endDate) {
					inst.settings.maxDate = endDate;
					}
					},
					onClose: function (dateText, inst) {
					var date_to = jQuery('#widget_idm45973473583088_date_to');
					if (date_to.val() == '') {
					setTimeout(function () {
					date_to.datepicker('show')
					}, 300);
					}
					},
					}).bind('change', function (ev) {
					$(ev.target.labels).addClass('changed')
					});
					});
					jQuery(function (jQuery) {
					jQuery('#widget_idm45973473583088_date_to').datepicker({
					closeText: 'X',
					prevText: '',
					nextText: '',
					currentText: 'Heute',
					monthNames: ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'],
					monthNamesShort: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
					dayNames: ['So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa'],
					dayNamesShort: ['So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa'],
					dayNamesMin: ['So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa'],
					dateFormat: 'dd.mm.yy',
					firstDay: 1,
					initStatus: 'Select a date',
					beforeShowDay: nst2015.cal_avail,
					isRTL: false,
					minDate: (function () {
					var today = new Date();
					return new Date(today.getFullYear(), today.getMonth(), today.getDate() + 1, 12, 0, 0, 0);
					})(),
					beforeShow: function (input, inst) {
					var startDate = jQuery('#widget_idm45973473583088_date_from').datepicker("getDate");
					if (startDate) {
					inst.settings.minDate = new Date(startDate.getFullYear(), startDate.getMonth(), startDate.getDate() + 1, 12, 0, 0, 0);
					inst.settings.maxDate = new Date(startDate.getFullYear() + 1, startDate.getMonth(), startDate.getDate() + 28, 12, 0, 0, 0);
					}
					}
					}).bind('change', function (ev) {
					$(ev.target.labels).addClass('changed')
					});
					});</script>
				<script type="text/javascript">
					if (typeof sml != 'undefined') {
					sml.settings.layer = '#social-media-source-layer';
					sml.settings.position_x = 0;
					sml.settings.position_y = 0;

					}
				</script>
				<div id="social-media-source-layer" class="social-media-source-layer">
					<div class="social-media-source-layer-box">
						<div class="social-media-source-layer-box-top-center"></div>
						<div class="social-media-source-layer-box-top-left"></div>
						<div class="social-media-source-layer-box-top-right"></div>
						<div class="social-media-source-layer-box-middle-left">
							<div class="social-media-source-layer-box-middle-right">
								<div class="social-media-source-layer-box-content"><a
										href="http://3051.condeon.dgi.w.og.vioma.de/de/hotel-prokulus/wissenswertes/#"
										class="social-media-source-layer-close"><span>x</span></a>
									<div id="social-media-source-layer-box-content-sources"></div>
								</div>
							</div>
						</div>
						<div class="social-media-source-layer-box-bottom-left"></div>
						<div class="social-media-source-layer-box-bottom-right"></div>
						<div class="social-media-source-layer-box-bottom-center"></div>
					</div>
				</div>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>