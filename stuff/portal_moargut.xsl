<?xml version = "1.0" encoding = "UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:site="http://xmlns.webmaking.ms/site/" xmlns:cstc="http://xmlns.webmaking.ms/cstc/" exclude-result-prefixes="site cstc">

	<xsl:include href="../../nst/2015.xsl" />

	<xsl:template match="cstc:site">
		<div class="cst">
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<!--#### ROOMTYPELIST ####-->
	<xsl:template match="cstc:roomtype-list[/site:site/site:cms/content-attribute[starts-with(@value,'kacheln')] or /site:site/cstc:frame/@layout='kacheln']">
		<xsl:variable name="id" select="generate-id()" />
		<xsl:variable name="indicator-family-rooms" select="25155" />
		<!--Menüleiste zum Filtern der Gruppen-->
		<!-- <xsl:if test="count( roomtype-groups/roomtype-group ) &gt; 1">
			<ul id="hrg_toggle_{$id}" class="hrg-toggle">
				<xsl:for-each select="roomtype-groups/roomtype-group">
					<li data-hrg="{@group-id}"><xsl:value-of select="@group-name" /></li>
				</xsl:for-each>
				<li data-hrg="coi-{$indicator-family-rooms}"><xsl:value-of select="(roomtype-groups/roomtype-group/roomtypes/*/room-type/indicators/*[coi_id=$indicator-family-rooms])[1]/coi_name_str" /></li>
			</ul>
			<xsl:variable name="hrg-toggle-js">
				$( function() { $('#hrg_toggle_<xsl:value-of select="$id" />').find('li').click(function(){
				var $this = $(this);
				$this.addClass('active').siblings().removeClass('active');
				$('.tile-<xsl:value-of select="$id" />' ).hide()
				.filter('.tile-hrg-' + $this.data('hrg') ).show();
				}).eq(0).click() } );
			</xsl:variable>
			<script type="text/javascript"><xsl:value-of select="normalize-space($hrg-toggle-js)" /></script>
		</xsl:if>-->
		<xsl:for-each select="roomtype-groups/roomtype-group/roomtypes/*">
			<xsl:variable name="coi-class"><xsl:if test="count( room-type/indicators/*[coi_id=$indicator-family-rooms] ) &gt; 0"><xsl:text> </xsl:text>tile-hrg-coi-<xsl:value-of select="$indicator-family-rooms" /></xsl:if></xsl:variable>
			<div class="tile tile-roomtype tile-hrg-{room-type/hrt_group} tile-roomtype-{room-type/hrt_id} tile-{$id}{$coi-class}">
				<xsl:apply-templates select="." />
			</div>
		</xsl:for-each>
		<xsl:variable name="hrt_image_css">
			<xsl:for-each select="roomtype-groups/roomtype-group/roomtypes/*[room-type/hrt_image != 0]">
				.tile-roomtype-<xsl:value-of select="room-type/hrt_id" /> .tile-text { background-image: url('<xsl:value-of select="room-type/hrt_image"/>/640x400s'); }
			</xsl:for-each>
		</xsl:variable>
		<style type="text/css"><xsl:value-of select="normalize-space($hrt_image_css)" /></style>
	</xsl:template>

	<xsl:template match="cstc:roomtype-list/roomtype-groups/roomtype-group/roomtypes/*[/site:site/site:cms/content-attribute[starts-with(@value,'kacheln')] or /site:site/cstc:frame/@layout='kacheln']">
		<xsl:variable name="hrt-price-from">
			<xsl:choose>
				<xsl:when test="room-type/hrt_price_from_int &gt; 0"><xsl:value-of select="room-type/hrt_price_from_int" /></xsl:when>
				<xsl:when test="prices/price-min-int &gt; 0"><xsl:value-of select="prices/price-min-int" /></xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose></xsl:variable>
		<div class="roomtype-links">
			<a class="cta" href="transaction.php?items[]=hrt:{room-type/hrt_id}&amp;c[id_hotel]={room-type/hrt_hotel}&amp;vri_id=3821">[%txt.request]</a>
			<a class="cta" href="{@url-booking}">[%txt.book]</a>
		</div>
		<a href="{@url}" class="tile-text"></a>
		<div class="roomtype-teaser">
			<h3>
				<a href="{@url}"><xsl:value-of select="room-type/hrt_name"/></a>
			</h3>
			<xsl:if test="$hrt-price-from &gt;0">
				<div class="roomtype-price-from">
					<span class="roomtype-from">[%txt.from]</span>
					<span class="roomtype-price"><xsl:value-of select="/site:site/site:config/@currency-sign" />&#160;<xsl:value-of select="format-number( number( $hrt-price-from ), '#', 'european' )" /></span>
					<span class="roomtype-properson">[%txt.properson]</span>
				</div>
			</xsl:if>
			<div class="roomtype-teaser-text dotdotdot">
				<xsl:copy-of select="room-type/hrt_desc_teaser/node()" />
			</div>
		</div>
	</xsl:template>

	<xsl:template match="cstc:roomtype-detail">
		<!--#### gallery items ####-->
		<xsl:variable name="roomtype" select="." />
		<xsl:variable name="hrt_media" select="cstc:media-usages/*[ media_image_width &gt; 1280 and (@usage-type='image' or @usage-type='panorama' or @usage-type='embed' or @usage-type='plan')]" />
		<xsl:variable name="hrt_media_head" select="$hrt_media[not(@usage-type='plan')]" />
		<xsl:if test="count($hrt_media)&gt;0">
			<xsl:call-template name="header-gallery-items">
				<xsl:with-param name="items" select="$hrt_media_head/media_url" />
				<xsl:with-param name="overlay">
					<div class="cst-overlay-name"><xsl:value-of select="room-type/hrt_name" /></div>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<div class="cst-detail cst-detail-roomtype-info">
			<div class="cst-teaser-header">
				[%txt.room.details]
			</div>
			<div class="cst-teaser-strong">
				[%txt.room.size]/[%txt.room.alloc]
			</div>
			<div class="cst-teaser-text">
				<xsl:call-template name="cstc:formatted-text">
					<xsl:with-param name="text-node" select="room-type/hrt_desc_teaser"/>
				</xsl:call-template>
			</div>
			<div class="cst-teaser-strong">
				[%search.form.roomtype] / [%search.form.catering]:
			</div>
			<div class="cst-teaser-text">
				<xsl:if test="room-group/hrg_id" >
					<xsl:value-of select="room-group/hrg_name" />
				</xsl:if>
				<xsl:if test="count(room-type-pensions/*) &gt;0">
					/ <xsl:value-of select="room-type-pensions/*/hpt_name" />
				</xsl:if>
			</div>
			<div class="roomtype-image-gallery" data-attr-layout="content-gallery-view1">
				<div class="cst-teaser-strong">
					[%txt.gallery]:
				</div>
				<xsl:variable name="gallery_media" select="cstc:media-usages/*[@usage-type='image' or @usage-type='panorama' or @usage-type='embed']" />
				<xsl:variable name="gallery_media_plan" select="cstc:media-usages/*[@usage-type='plan']" />
				<xsl:variable name="group-id" select="generate-id()" />

				<div class="content-gallery content-gallery-wide">
					<xsl:for-each select="$gallery_media">
						<xsl:variable name="image_src" select="./media_url"/>
						<xsl:variable name="id" select="generate-id()"/>
						<div id="gallery-item-{$id}" class="slide gallery-item">
							<a class="fancybox" data-fancybox-type="image" data-fancybox-group="gallery-{$group-id}" href="{$image_src}/1024x0s" title="{media_title}"></a>
						</div>
						<xsl:variable name="image_css">
							#gallery-item-<xsl:value-of select="$id" />{ background-image: url('<xsl:value-of select="$image_src"/>/720x540sc'); }
						</xsl:variable>
						<style type="text/css"><xsl:value-of select="normalize-space($image_css)" /></style>
					</xsl:for-each>
					<!--Zimmerplan immer ans Ende setzen-->
					<xsl:if test="$gallery_media_plan">
						<xsl:variable name="image_plan" select="cstc:media-usages/*[@usage-type='plan']/media_url"/>
						<xsl:variable name="id" select="generate-id()"/>
						<div id="gallery-item-{$id}" class="slide gallery-item plan">
							<a class="fancybox" data-fancybox-type="image" data-fancybox-group="gallery-{$group-id}" href="{$image_plan}/1024x0s" title="{media_title}"></a>
						</div>
						<xsl:variable name="image_css">
							#gallery-item-<xsl:value-of select="$id" />{ background-image: url('<xsl:value-of select="$image_plan"/>/720x540sc'); }
						</xsl:variable>
						<style type="text/css"><xsl:value-of select="normalize-space($image_css)" /></style>
					</xsl:if>
				</div>
			</div>
		</div>
		<!--spalte-links-->
		<div class="cst-detail cst-detail-roomtype" id="cst-detail-roomtype-{room-type/hrt_id}">
			<div class="cst-detail cst-detail-roomtype" id="cst-detail-roomtype-{room-type/hrt_id}">
				<xsl:if test="room-group/hrg_id" >
					<div class="roomtype-group">
						<h1>
							<xsl:value-of select="room-group/hrg_name" />
						</h1>
					</div>
				</xsl:if>
				<div class="roomtype-name">
					<h2>
						<xsl:value-of select="room-type/hrt_name"/>
					</h2>
				</div>
				<div class="cst-box">
					<div class="cst-box-content">
						<div class="cst-description-text">
							<xsl:call-template name="cstc:formatted-text">
								<xsl:with-param name="text-node" select="room-type/hrt_desc_cms"/>
							</xsl:call-template>
							<div class="package-links">
								<a class="cta" href="transaction.php?items[]=hrt:{room-type/hrt_id}&amp;c[id_hotel]={room-type/hrt_hotel}&amp;vri_id=3821">[%txt.request]</a>
								<a class="cta" href="{@url-booking}">[%txt.book]</a>
							</div>
						</div>
					</div>
					<div class="clearfix"/>
				</div>

				<h1>Preistabelle SOMMER WINTER</h1>
				<xsl:apply-templates select="room-type/cstc:roomtype-prices">
					<xsl:with-param name="prices" select="room-type/prices" />
					<xsl:with-param name="price-type" select="room-type/hrt_price_type" />
					<xsl:with-param name="display-cols" select="@display-cols" />
				</xsl:apply-templates>

				<div class="package-links">
					<a class="cta" href="vsc.php?items[]=hrt:{room-type/hrt_id}&amp;c[id_hotel]={room-type/hrt_hotel}">[%txt.request]</a>
					<a class="cta" href="{@url-booking}">[%txt.book]</a>
				</div>
			</div>
		</div>	<!--//spalte rechts-->

		<!--#### roomtypes packages ####-->
		<xsl:variable name="package-slider-id" select="generate-id()" />
		<xsl:if test="count(packages/*) &gt; 0">
			<div class="cst-list cst-list-packages">
				<h2 class="cst-list-title">[%package.roomtype.offers]</h2>
				<div class="package-slider flexslider" id="package_slider_{$package-slider-id}">
					<ul class="slides cf">
						<xsl:for-each select="packages/*">
							<xsl:call-template name="theme-box-package">
								<xsl:with-param name="package" select="." />
								<xsl:with-param name="class"></xsl:with-param>
							</xsl:call-template>
						</xsl:for-each>
					</ul>
				</div>
			</div>
		</xsl:if>
		<xsl:variable name="package-slider-script">
			$(window).load(function() {
			    var columns = { '1920': 4, '1600': 4, '1280': 4, '959': 2, '768': 2, '640': 2, '480': 1, '320': 1 };
				$('#package_slider_<xsl:value-of select="$package-slider-id"/>').flexslider({
					animation: "slide",
					animationLoop: false,
					itemWidth: 250,
					controlNav: false,
					directionNav: true,
					prevText: '',
					nextText: '',
					minItems: columns[nst2015.opt.mq.width],
					maxItems: columns[nst2015.opt.mq.width],
					start: function( slider ){
						$(window).bind('resize orientationchange', function () {
										setTimeout(function(){
											slider.vars.minItems = columns[nst2015.opt.mq.width];
											slider.vars.maxItems = columns[nst2015.opt.mq.width];
											slider.resize();
										},100);
									});
						$('.dotdotdot').dotdotdot();
					}
				});
			});
		</xsl:variable>
	<script type="text/javascript"><xsl:value-of select="normalize-space($package-slider-script)" /></script>
</xsl:template>

	<!--#### Roomtype Prices ####-->
	<xsl:template match="cstc:roomtype-prices">
		<xsl:param name="prices" />
		<xsl:param name="price-type" />
		<xsl:param name="display-cols">4</xsl:param>
		<div class="cst-detail-prices cst-detail-prices-parents">
			<xsl:call-template name="cstc:headline">
				<xsl:with-param name="type">3</xsl:with-param>
				<xsl:with-param name="title">
					<xsl:if test="$price-type=1 or $price-type=3 or $price-type=4">[%txt.price.stay.adult/<xsl:value-of select="//site:config/@currency" />]</xsl:if>
					<xsl:if test="$price-type=2">[%txt.price.room.adult/<xsl:value-of select="//site:config/@currency" />]</xsl:if>
					<xsl:if test="../hrt_price_type=1 or ../hrt_price_type=3">
					</xsl:if>
				</xsl:with-param>
				<xsl:with-param name="class">cst cst-detail-prices</xsl:with-param>
			</xsl:call-template>

			<xsl:apply-templates select="../cstc:roomtype-prices-parents">
				<xsl:with-param name="prices" select="$prices" />
				<xsl:with-param name="price-type" select="$price-type" />
				<xsl:with-param name="display-cols" select="$display-cols" />
			</xsl:apply-templates>
		</div>
	</xsl:template>

    <!--#### Angebote im Slider ####-->
    <xsl:template match="cstc:general-list[@type='package' and /site:site/site:cms/content-attribute[@name='layout' and @value='kacheln']]">
	    <xsl:for-each select="cstc:package-teaser">
			<xsl:call-template name="theme-box-package">
				<xsl:with-param name="package" select="." />
				<xsl:with-param name="layout"></xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<!--#### Angebote als normale Kacheln und AJAX ####-->
	<xsl:template match="cstc:general-list[@type='package']">
		<xsl:variable name="package-list-id" select="generate-id()"/>
		<xsl:variable name="layout" select="/site:site/site:cms//content-attribute[@name='layout']/@value"/>
		<xsl:variable name="cstframe" select="/site:site/cstc:frame/@layout"/>
		<xsl:variable name="items" select="@item-count"/>

		<xsl:choose>
			<xsl:when test="$items &gt; 0">
				<xsl:choose>
					<xsl:when test="$layout='package-slider'">
						<div class="cst-list-packages">
							<div id="package_list_{$package-list-id}" class="package-slider flexslider loaded">
								<ul class="slides cf">
									<xsl:for-each select="cstc:package-teaser">
										<xsl:call-template name="theme-box-package">
											<xsl:with-param name="package" select="."/>
											<xsl:with-param name="layout">slider</xsl:with-param>
											<xsl:with-param name="class">slide</xsl:with-param>
										</xsl:call-template>
									</xsl:for-each>
								</ul>
							</div>
						</div>
						<script type="text/javascript">
						nst2015.opt.flex_layouts['moargut-package-slider'] = function () {
							var columns = { '1920': 4, '1600': 3, '1280': 3, '959': 2, '768': 2, '640': 1, '480': 1, '320': 1 };
							this.options = $.extend( {
							slideshow: true,
								animation: 'slide',
								prevText: '',
								nextText: '',
								controlNav: false,
								directionNav: true,
								itemWidth: 250,
								smoothHeight: ( columns[nst2015.opt.mq.width] == 1 ),
								minItems: columns[nst2015.opt.mq.width],
								maxItems: columns[nst2015.opt.mq.width],
								start: function (slider) {
											$(window).bind('resize orientationchange', function () {
												setTimeout(function(){
													slider.vars.minItems = columns[nst2015.opt.mq.width];
													slider.vars.maxItems = columns[nst2015.opt.mq.width];
													slider.resize();
												},100);
											});
											nst2015.opt.main.find('.dotdotdot').dotdotdot()
										}
							}, this.options );
						};
						nst2015.flex( jQuery( '#package_list_<xsl:value-of select="$package-list-id" />' ), 'moargut-package-slider', true );
					</script>
					</xsl:when>
					<xsl:when test="$cstframe='slider'">
						<div id="ajaxslider">
							<ul class="slides cf">
								<xsl:for-each select="cstc:package-teaser">
									<xsl:call-template name="theme-box-package">
										<xsl:with-param name="package" select="." />
										<xsl:with-param name="layout">slider</xsl:with-param>
										<xsl:with-param name="class">slide</xsl:with-param>
									</xsl:call-template>
								</xsl:for-each>
							</ul>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="cstc:package-teaser">
							<xsl:call-template name="theme-box-package">
								<xsl:with-param name="package" select="." />
								<xsl:with-param name="layout"></xsl:with-param>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<div class="cst-list cst-list-not-found">
					[%txt.no_packages_found]
					<a href="javascript:history.back();" class="cst-link cst-link-back">[%txt.back]</a>
				</div>
			</xsl:otherwise>
		</xsl:choose>


	</xsl:template>

	<xsl:template name="theme-box-package">
		<xsl:param name="package" select="."/>
		<xsl:param name="layout">slider</xsl:param>
		<xsl:param name="class">cst-package-detail-theme-box</xsl:param>
		<xsl:variable name="package-id" select="$package/package/hpa_id"/>
		<xsl:choose>
			<xsl:when test="$layout='slider'">
				<li class="{$class}">
					<div class="theme-box cf">
						<xsl:if test="$package/package/hpa_image!=0">
							<a href="{@url}">
								<xsl:variable name="package-image" select="$package/package/hpa_image"/>
								<div class="theme-box-img" id="hpa-{$package-id}">
									<style>
										#hpa-<xsl:value-of select="$package-id"/> {background:url('<xsl:value-of select="$package-image"/>/280x260s') no-repeat;}
									</style>
								</div>
							</a>
						</xsl:if>
						<div class="theme-box-info">
							<h3>
								<xsl:variable name="package-name" select="$package/package/hpa_name"/>
								<xsl:choose>
									<xsl:when test="contains($package-name,'|')">
										<xsl:value-of select="substring-before($package-name,'|')" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$package-name" />
									</xsl:otherwise>
								</xsl:choose>
							</h3>
							<p class="dotdotdot">
								<xsl:value-of select="package/hpa_teaser_str"/>
							</p>
							<xsl:call-template name="package-price-teaser-theme-box"/>
						</div>
					</div>
				</li>
			</xsl:when>
			<xsl:otherwise>
				<!--normale kacheln-->
				<div class="package-theme-box">
					<xsl:if test="$package/package/hpa_image!=0">
						<a href="{@url}">
							<xsl:variable name="package-image" select="$package/package/hpa_image"/>
							<div class="theme-box-img" id="hpa-{$package-id}">
								<style>
									#hpa-<xsl:value-of select="$package-id"/> {background:url('<xsl:value-of select="$package-image"/>/280x260s') no-repeat;}
								</style>
							</div>
						</a>
					</xsl:if>
					<div class="theme-box-info">
						<h3>
							<xsl:variable name="package-name" select="$package/package/hpa_name"/>
							<xsl:choose>
								<xsl:when test="contains($package-name,'|')">
									<xsl:value-of select="substring-before($package-name,'|')" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$package-name" />
								</xsl:otherwise>
							</xsl:choose>
							
							<div class="package-date">
								<xsl:for-each select="$package/package/tf-avail/*">
									<xsl:value-of select="ht_from_display" /><xsl:text> - </xsl:text><xsl:value-of select="ht_to_display" />
									<xsl:if test="position() != last()"><br /></xsl:if>
								</xsl:for-each>
							</div>
						</h3>
						<p class="dotdotdot">
							<xsl:value-of select="package/hpa_teaser_str"/>
						</p>
						<xsl:call-template name="package-price-teaser-theme-box"/>
					</div>
				</div>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template name="package-price-teaser-theme-box">
		<xsl:variable name="package-price">
			<xsl:choose>
				<xsl:when test="info/hpa_price_min!=0">
					<xsl:value-of select="/site:site/site:config/@currency-sign" /><xsl:text> </xsl:text><xsl:value-of select="format-number(number(info/hpa_price_min),'##0,--','european')" />
				</xsl:when>
				<xsl:when test="info/hpa_programs_min!=0">
					<xsl:value-of select="/site:site/site:config/@currency-sign" /><xsl:text> </xsl:text><xsl:value-of select="format-number(number(info/hpa_programs_min),'##0,--','european')" />
				</xsl:when>
				<xsl:when test="not(avail/hpa_price_from_int=0)"><xsl:value-of select="avail/hpa_price_from" /></xsl:when>
				<xsl:when test="string-length(avail/hpa_price)&gt;0">
					<xsl:value-of select="avail/hpa_price" />
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="string-length($package-price)&gt;0">
			<div class="theme-box-overlay">
				<div class="stays">
					<xsl:choose>
						<!-- list -->
						<xsl:when test="info/hpa_persons &gt; 1">
							<xsl:if test="package/hpa_stays != 0">
								<span class="cst-price-per-person"><xsl:value-of select="hpa_stays" /><xsl:value-of select="package/hpa_stays"/>&#160;[%txt.stays]</span>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="package/hpa_stays != 0">
								<span class="cst-price-per-person"><xsl:value-of select="hpa_stays" /><xsl:value-of select="package/hpa_stays"/>&#160;[%txt.stays]</span>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</div>
				<div class="cst-price">
					<span class="cst-price-number">
						[%txt.from]
						<xsl:call-template name="cstc:formatted-text">
							<xsl:with-param name="text-node" select="$package-price" />
						</xsl:call-template>
					</span>
					<xsl:if test="avail/hpa_type &gt;1 and avail/hpa_price_discount_num &gt; 0.01">
						<span class="cst-price-save">
							[%package.price.save/<xsl:value-of select="avail/hpa_price_discount" />/<xsl:value-of select="/site:site/site:config/@currency" />]
						</span>
					</xsl:if>
				</div>
				<div class="buttons">
					<xsl:if test="not( info/@requestable ) or info/@requestable = 'true'">
						<xsl:variable name="hpa_id" select="./package/hpa_id"/>
						<xsl:variable name="hotel_id" select="./package/hpa_hotel"/>
						<a href="transaction.php?items[]=hpa:{$hpa_id}&amp;c[id_hotel]={$hotel_id}&amp;vri_id=3821" class="cta">
							<span>[%txt.request]</span>
						</a>
					</xsl:if>

					<xsl:if test="not( info/@bookable ) or info/@bookable = 'true'">
						<xsl:variable name="book-url" select="@url-booking"/>
						<a href="{$book-url}" class="cta">
							<span>[%txt.book]</span>
						</a>
					</xsl:if>
				</div>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="cstc:package-detail[/site:site/site:cms/content-attribute[@name='layout' and @value='kacheln']] | cstc:package-detail">
	<!--<xsl:template match="cstc:package-detail">-->
		<!--#### REPLACE GALLERY IMAGES ####-->
		<xsl:if test="not(package/hpa_image=0)">
			<xsl:call-template name="header-gallery-items">
				<xsl:with-param name="items" select="package/hpa_image"/>
				<xsl:with-param name="overlay">
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<div class="detail-package">
			<div class="cst-detail cst-detail-package cst-detail-package-type-{package/hpa_type} cst-detail-package-hotel-{package/hpa_hotel}"
		     id="cst-detail-package-{package/hpa_id}">
			<xsl:if test="package-indicators/*/hpi_indicator!=''">
				<xsl:attribute name="class">cst-detail cst-detail-package cst-detail-package-type-<xsl:value-of select="package/hpa_type"/> cst-detail-package-hotel-<xsl:value-of select="package/hpa_hotel"/> cst-detail-package-indicator-<xsl:value-of select="package-indicators/*/hpi_indicator"/></xsl:attribute>
			</xsl:if>

			<xsl:if test="/site:site/site:config/@hotel='false' or count(avail/*)=0">
				<xsl:choose>
					<xsl:when test="count(avail/*)=0">
						<xsl:apply-templates select="/site:site/site:match-space/hotel/packages/not-bookable">
							<xsl:with-param name="hotel" select="hotel" />
							<xsl:with-param name="package" select="package" />
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<div class="cst-link-box cst-link-box-packages">
							<xsl:apply-templates select="boxes/*/cstc:package-links" />
						</div>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="/site:site/site:config/@hotel='false'">
					<div class="cst-detail-package-hotel">
						<xsl:apply-templates select="/site:site/site:match-space/hotel-teaser" />
					</div>
				</xsl:if>
			</xsl:if>
			<div class="cst-box">
				<xsl:variable name="package" select="package" />
				<xsl:if test="cstc:media-usages/cstc:media-usage[@usage-type='embed']">
					<xsl:for-each select="cstc:media-usages/cstc:media-usage[@usage-type='embed']">
						<xsl:call-template name="vjg_item">
							<xsl:with-param name="group">hpa<xsl:value-of select="$package/hpa_id" /></xsl:with-param>
							<xsl:with-param name="src" select="media_url" />
							<xsl:with-param name="alt" select="media_name" />
						</xsl:call-template>
					</xsl:for-each>
				</xsl:if>
				<div class="cst-box-content content-left">
					<div class="cst-package-variant-stays cst-stays">
						<xsl:if test="avail/hpa_stays &gt;0">
							<div class="cst-stays">
								<span class="cst-stays-number"><xsl:value-of select="avail/hpa_stays" /></span><xsl:text> </xsl:text>
								<span class="cst-stays-text">[%txt.stays.numerus/ <xsl:value-of select="avail/stays" />]</span>
								<xsl:if test="package/hpa_stays_max &gt; package/hpa_stays">
									<span class="cst-stays-max">
										([%txt.up_to.nights.additional/<xsl:value-of select="package/hpa_stays_max" />])
									</span>
								</xsl:if>
							</div>
						</xsl:if>
						<xsl:if test="count(package/tf-avail/*) &gt; 0 and (package/tf-avail/*/ht_to_display != '0000-00-00')">
							<div class="cst-timeframes cst-timeframes-left">
								<xsl:for-each select="package/tf-avail/*">
									<xsl:sort select="ht_from_ts" order="ascending"/>
									<div class="cst-timeframe">
										<xsl:if test="position()=last()">
											<xsl:attribute name="class">cst-timeframe cst-timeframe-left cst-timeframe-left-last</xsl:attribute>
										</xsl:if>
										<span class="cst-timeframe-from"><xsl:value-of select="./ht_from_display" /></span>
										<span class="cst-binder">-</span>
										<span class="cst-timeframe-to"><xsl:value-of select="./ht_to_display" /></span>
									</div>
								</xsl:for-each>
							</div>
						</xsl:if>
					</div><!--//cst-stays-->
					<div class="cst-package-variant-price">
						<xsl:call-template name="cstc:package-price-teaser"/>
						<xsl:if test="package-room-types/*[../../avail/hpa_default_room_type=../../avail/hr_type and ../../avail/hpa_default_room_type=hrt_id]">
							<xsl:variable name="default-room-type" select="package-room-types/*[../../avail/hpa_default_room_type=hrt_id]"/>
							<span class="cst-default-roomtype">
								(<xsl:value-of select="$default-room-type/hrt_name_str"/>)
							</span>
						</xsl:if>
					</div>
						<!--### rember link ###-->
						<!--<xsl:if test="/site:site/site:config/@remember='1' or /site:site/site:config/@remember-vnh='true'">-->
							<!--<xsl:apply-templates select="//site:match-space/site-links/remember">-->
								<!--<xsl:with-param name="id">hpa<xsl:value-of select="package/hpa_id" /></xsl:with-param>-->
								<!--<xsl:with-param name="price"><xsl:value-of select="package/hpa_price" /></xsl:with-param>-->
								<!--<xsl:with-param name="title"><xsl:value-of select="package/hpa_name" /></xsl:with-param>-->
								<!--<xsl:with-param name="hotel"><xsl:value-of select="hotel/hotel_nameaffix" /></xsl:with-param>-->
								<!--<xsl:with-param name="hotel-id"><xsl:value-of select="package/hpa_hotel" /></xsl:with-param>-->
								<!--<xsl:with-param name="link"></xsl:with-param>-->
								<!--<xsl:with-param name="class">cst-link cst-link-notice</xsl:with-param>-->
							<!--</xsl:apply-templates>-->
						<!--</xsl:if>-->
						<div class="package-links">
							<xsl:if test="@service-request = 'yes'">
								<xsl:variable name="request" select="@url-request"/>
								<xsl:variable name="hotel_id" select="package/hpa_hotel"/>
								<xsl:variable name="hpa_id"  select="package/hpa_id"/>
								<a href="transaction.php?items[]=hpa:{$hpa_id}&amp;c[id_hotel]={$hotel_id}&amp;vri_id=3821" class="cta">
									[%txt.request]
								</a>
							</xsl:if>
							<xsl:if test="@service-booking = 'yes' and package/hpa_bookable = 1">
								<xsl:variable name="book" select="@url-booking"/>
								<a href="{$book}" class="cta">
									[%txt.book]
								</a>
							</xsl:if>
						</div>
				</div>
				<div class="cst-box-content content-right">
					<xsl:call-template name="cstc:headline">
						<xsl:with-param name="type">1</xsl:with-param>
						<xsl:with-param name="title">
							<xsl:choose>
								<xsl:when test="package/custom-elements/variant-grouping/name"><xsl:value-of select="package/custom-elements/variant-grouping/name" /></xsl:when>
								<xsl:otherwise><xsl:value-of select="package/hpa_name" /></xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
						<xsl:with-param name="class">cst cst-detail-package</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="cstc:headline">
						<xsl:with-param name="type">3</xsl:with-param>
						<xsl:with-param name="title">
							<xsl:choose>
								<xsl:when test="package/custom-elements/variant-grouping/name"><xsl:value-of select="package/custom-elements/variant-grouping/name" /></xsl:when>
								<xsl:otherwise><xsl:value-of select="package/hpa_name" /></xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
						<xsl:with-param name="class">cst cst-detail-package</xsl:with-param>
					</xsl:call-template>
					<div class="cst-teaser-text">
						<xsl:if test="string-length(package/hpa_teaser) &gt;3">
							<xsl:call-template name="cstc:formatted-text">
								<xsl:with-param name="text-node" select="package/hpa_teaser" />
							</xsl:call-template>
						</xsl:if>
					</div>
					<xsl:if test="not(count(avail/*)=0)">
						<div class="cst-detail-infos">
							<xsl:if test="not(
								count(pensions/*)&gt;1 or
								string-length(package/hpa_desc )&gt;5 or
								package/weekdays_arrival or count(cstc:media-usages/*) &gt; 0)">
								<xsl:attribute name="class">cst-detail-infos cst-detail-infos-last-info</xsl:attribute>
							</xsl:if>
						</div>
					</xsl:if>
					<div id="cst-pensions-container">
						<xsl:if test="count(pensions/*)&gt;1">
							<xsl:call-template name="pensions-container">
								<xsl:with-param name="type">package</xsl:with-param>
								<xsl:with-param name="url" select="package/@url" />
								<xsl:with-param name="url_param">?c[id_pension]=</xsl:with-param>
								<xsl:with-param name="pensions" select="pensions" />
								<xsl:with-param name="selected_pension" select="avail/hpa_pension_used" />
								<xsl:with-param name="hotel_currency" select="hotel-currency" />
							</xsl:call-template>
						</xsl:if>
					</div>
					<xsl:if test="string-length(package/hpa_desc )&gt;5">
						<div class="cst-text-description">
							<xsl:call-template name="cstc:formatted-text">
								<xsl:with-param name="text-node" select="package/hpa_desc" />
							</xsl:call-template>
						</div>
					</xsl:if>
					<xsl:if test="package/weekdays_arrival">
						<xsl:call-template name="cstc:package-arrival"/>
					</xsl:if>

					<xsl:if test="package/hpa_bookable = 1">
						<xsl:apply-templates select="cstc:revenue-navigator-search" />
						<xsl:apply-templates select="cstc:revenue-navigator" />
					</xsl:if>

					<xsl:if test="count(cstc:media-usages/*) &gt; 0 and cstc:media-usages/cstc:media-usage[@usage-type!='embed']">
						<div class="package-additional-media">
							<span class="cst-additional-media">[%txt.additional-information-download]</span>
							<ul class="cst-media">
								<xsl:for-each select="cstc:media-usages/cstc:media-usage">
									<li class="cst-media-embed">
										<a href="{media_url_deliver}">
											<xsl:attribute name="class">
												<xsl:choose>
													<xsl:when test="media_ext = 'pdf'">cst-file-attachement cst-file-attachement-pdf</xsl:when>
													<xsl:when test="media_ext = 'doc'">cst-file-attachement cst-file-attachement-doc</xsl:when>
													<xsl:when test="media_ext = 'xls'">cst-file-attachement cst-file-attachement-xls</xsl:when>
													<xsl:otherwise>cst-file-attachement</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
											<xsl:value-of select="media_name" />
										</a>
									</li>
								</xsl:for-each>
							</ul>
						</div>
					</xsl:if>
				</div>
			</div>
		</div>
		</div>
		<!--#### packages per ajax nachladen ####-->
		<xsl:variable name="coi_parent" select="package-indicators/*[coi_parent !=0]/coi_parent"/>
		<xsl:if test="$coi_parent">
			<div class="cst-list-packages">
                <!--<xsl:for-each select="package-indicators/*[coi_parent !=0]">-->
                <!--#### roomtypes packages ####-->
				<xsl:variable name="package-slider-id" select="generate-id()" />
				<xsl:variable name="url"><xsl:value-of select="//site:site/site:env/site:vars/@base-resources"/></xsl:variable>
				<xsl:if test="$coi_parent">
					<h3>[%txt.more.packages]</h3>
					<div class="package-slider flexslider" id="ps_{$package-slider-id}"></div>
				</xsl:if>
				<script type="text/javascript" domshake="false">
				( function( $ ) {
					if( typeof nst2015 != 'undefined' ) {
						var options = {
							coi: <xsl:value-of select="$coi_parent"/>,
							slider: '<xsl:value-of select="$package-slider-id"/>',
							url: '<xsl:value-of select="$url"/>'
						};
						nst2015.opt.loadpackages(options);
					}
				} )( jQuery );
				</script>
			</div>
		</xsl:if>

		<xsl:if test="package-detail/programs/included or package-detail/programs/optional">
			<div class="cst-list cst-list-program">
				<xsl:if test="package-detail/programs/included">
					<xsl:call-template name="cstc:headline">
						<xsl:with-param name="type">2</xsl:with-param>
						<xsl:with-param name="title">[%package.programs.included]</xsl:with-param>
						<xsl:with-param name="class">cst cst-program</xsl:with-param>
					</xsl:call-template>
					<xsl:for-each select="package-detail/programs/included/*">
						<xsl:apply-templates select="/site:site/site:match-space/hotel/packages/programs">
							<xsl:with-param name="program" select="." />
							<xsl:with-param name="hide-price">yes</xsl:with-param>
							<xsl:with-param name="addpackage">no</xsl:with-param>
						</xsl:apply-templates>
					</xsl:for-each>
				</xsl:if>
				<xsl:if test="package-detail/programs/optional">
					<xsl:call-template name="cstc:headline">
						<xsl:with-param name="type">2</xsl:with-param>
						<xsl:with-param name="title">[%package.programs.optional]</xsl:with-param>
						<xsl:with-param name="class">cst cst-program</xsl:with-param>
					</xsl:call-template>
					<xsl:for-each select="package-detail/programs/optional/*">
						<xsl:apply-templates select="/site:site/site:match-space/hotel/packages/programs">
							<xsl:with-param name="program" select="." />
							<xsl:with-param name="hide-price">no</xsl:with-param>
							<xsl:with-param name="addpackage" select="../../../../package/hpa_id" />
						</xsl:apply-templates>
					</xsl:for-each>
				</xsl:if>
			</div>
		</xsl:if>
	</xsl:template>

	<!-- Preisuebersicht -->
	<xsl:template match="cstc:roomtype-list[/site:site/site:cms/content-attribute[starts-with(@value,'preise')]]">
		<xsl:variable name="layout" select="/site:site/site:cms/content-attribute/@value"/>
		<xsl:choose>
			<xsl:when test="$layout='preise-sommer'">
				<xsl:if test="roomtype-groups/*/roomtypes/*[2]/prices/season-groups/*/seasons/*[hs_id='15431' or hs_id='15430' or hs_id='15429']">
					<div class="roomtype cst-box cst-roomtype-overview cst-roomtype-overview-group-{@group-id}">
						<h3 class="cst-detail-prices">[%moargut.prices.summer]</h3>
						<table class="roomtype-prices roomtype-prices-parents roomtype-prices-overview roomtype-prices-seasons" cellpadding="0" cellspacing="0" border="0">
							<xsl:for-each select="roomtype-groups/*/roomtypes/*[2]/prices/season-groups/*/seasons/*[hs_id='15431' or hs_id='15430' or hs_id='15429']">
								<xsl:sort select="dates/*/hs_from_ts" />
								<tr>
									<td class="season-name"><div class="season-name"><xsl:value-of select="hs_name_public"/></div></td>
									<xsl:variable name="seasontime" select="hs_from"/>
									<td class="season"><xsl:call-template name="cstc:roomtype-season" /></td>
								</tr>
							</xsl:for-each>
						</table>
						<table class="roomtype-prices roomtype-prices-parents roomtype-prices-overview " cellpadding="5" cellspacing="0">
							<tr class="head">
								<td class="head">
									<!--<xsl:copy-of select="."/>-->
								</td>
								<xsl:for-each select="roomtype-groups/*/roomtypes/*[2]/prices/season-groups/*/seasons/*[hs_id='15431' or hs_id='15430' or hs_id='15429']">
									<xsl:sort select="hs_id" order="ascending" data-type="number"/>
									<td class="season">
										<xsl:value-of select="hs_name_public"/>
									</td>
								</xsl:for-each>
							</tr>
							<xsl:for-each select="roomtype-groups/*/roomtypes/*">
								<xsl:call-template name="prices-overview-summer">
									<xsl:with-param name="prices" select="prices" />
									<xsl:with-param name="hrt_id" select="room-type/hrt_id"></xsl:with-param>
								</xsl:call-template>
							</xsl:for-each>
						</table>
					</div>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$layout='preise-winter'">

					<xsl:if test="roomtype-groups/*/roomtypes/*[2]/prices/season-groups/*/seasons/*[hs_id='20231' or hs_id='20300' or hs_id='20223' or hs_id='20230']">
					<div class="roomtype cst-box cst-roomtype-overview cst-roomtype-overview-group-{@group-id}">
						<table class="roomtype-prices roomtype-prices-parents roomtype-prices-overview roomtype-prices-seasons" cellpadding="0" cellspacing="0" border="0">
							<xsl:for-each select="roomtype-groups/*/roomtypes/*[2]/prices/season-groups/*/seasons/*[hs_id='20231' or hs_id='20300' or hs_id='20223' or hs_id='20230']">
								<xsl:sort select="dates/*/hs_from_ts" />
								<tr>
									<td class="season-name"><div class="season-name"><xsl:value-of select="hs_name_public"/></div></td>
									<xsl:variable name="seasontime" select="hs_from"/>
									<td class="season"><xsl:call-template name="cstc:roomtype-season" /></td>
								</tr>
							</xsl:for-each>
						</table>
						<table class="roomtype-prices roomtype-prices-parents roomtype-prices-overview " cellpadding="5" cellspacing="0">
							<tr class="head">
								<td class="head">
									<!--<xsl:copy-of select="."/>-->
								</td>
								<xsl:for-each select="roomtype-groups/*/roomtypes/*[2]/prices/season-groups/*/seasons/*[hs_id='20231' or hs_id='20300' or hs_id='20223' or hs_id='20230']">
									<xsl:sort select="hs_id" order="ascending" data-type="number"/>
									<td class="season">
										<xsl:value-of select="hs_name_public"/>
									</td>
								</xsl:for-each>
							</tr>
							<xsl:for-each select="roomtype-groups/*/roomtypes/*">
								<xsl:call-template name="prices-overview-winter">
									<xsl:with-param name="prices" select="prices" />
									<xsl:with-param name="hrt_id" select="room-type/hrt_id"></xsl:with-param>
								</xsl:call-template>
							</xsl:for-each>
						</table>
					</div>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$layout='preise-kinder'">
				<xsl:variable name="prices" select="roomtype-groups/*[1]/roomtypes/*[1]/room-type-childrens/prices"/>
				<xsl:call-template name="roomtype-prices-children-seasons">
					<xsl:with-param name="prices" select="roomtype-groups/*[1]/roomtypes/*[1]/room-type-childrens/prices"/>
					<xsl:param name="price-type">3</xsl:param>
					<xsl:with-param name="season">Winter</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="roomtype-prices-children-seasons">
					<xsl:with-param name="prices" select="roomtype-groups/*[1]/roomtypes/*[1]/room-type-childrens/prices"/>
					<xsl:param name="price-type">3</xsl:param>
					<xsl:with-param name="season">Sommer</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!--nothing to do-->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="prices-overview-winter">
		<xsl:param name="prices" />
		<xsl:param name="hrt_id"></xsl:param>
		<xsl:choose>
			<xsl:when test="$prices/season-groups/*[seasons/season/dates/date[hs_id='20231' or hs_id='20300' or hs_id='20223' or hs_id='20230']]">
				<tr class="room-type">
					<td class="room-name"><a href="{@url}"><xsl:value-of select="room-type/hrt_name"	/></a></td>
					<xsl:for-each select="$prices/season-groups/*[seasons/season/dates/date[hs_id='20231' or hs_id='20300' or hs_id='20223' or hs_id='20230']]">
						<xsl:sort select="@season-min" order="ascending" data-type="number"/>
						<td class="price">
							<xsl:value-of select="@price" />
						</td>
					</xsl:for-each>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<tr class="room-type">
					<td class="room-name"><a href="{@url}"><xsl:value-of select="room-type/hrt_name"/></a></td>
					<td class="price">-</td>
					<td class="price">-</td>
					<td class="price">-</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="prices-overview-summer">
		<xsl:param name="prices" />
        <xsl:param name="hrt_id"></xsl:param>
		<xsl:choose>
			<xsl:when test="$prices/season-groups/*[seasons/season/dates/date[1][hs_id='15431' or hs_id='15430' or hs_id='15429']]">
				<tr class="room-type">
					<td class="room-name"> <a href="{@url}"><xsl:value-of select="room-type/hrt_name"	/></a></td>
					<xsl:for-each select="$prices/season-groups/*[seasons/season/dates/date[1][hs_id='15431' or hs_id='15430' or hs_id='15429']]">
						<xsl:sort select="seasons/season/dates/date[hs_id='15431' or hs_id='15430' or hs_id='15429']/hs_from_ts" order="ascending" data-type="number"/>
						<td class="price">
							<xsl:value-of select="@price" />
						</td>
					</xsl:for-each>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<tr class="room-type">
					<td class="room-name"><a href="{@url}"><xsl:value-of select="room-type/hrt_name"/></a></td>
					<td class="price">-</td>
					<td class="price">-</td>
					<td class="price">-</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template match="cstc:roomtype-prices-parents">
		<xsl:param name="prices" />
		<xsl:param name="price-type" />
		<xsl:param name="display-cols">2</xsl:param>
		<!--Sommerpreise -->
		<xsl:if test="$prices/season-groups/*[seasons/season/dates/date[hs_id='15431' or hs_id='15430' or hs_id='15429']]">
			<h3 class="cst cst-detail-prices">
				[%moargut.prices.summer]
			</h3>
			<table id="roomtype-prices-parents-summer" class="roomtype-prices roomtype-prices-parents" cellpadding="0" cellspacing="0" border="0">
				<tr class="head">
					<td class="season-head">[%txt.season]</td>
					<td class="price-head">[%txt.price.perperson.short]</td>
				</tr>
				<xsl:for-each select="$prices/season-groups/*[seasons/season/dates/date[hs_id='15431' or hs_id='15430' or hs_id='15429']]">
					<xsl:sort select="seasons/season/dates/date[hs_id='15431' or hs_id='15430' or hs_id='15429']/hs_from_ts" order="ascending" data-type="number"/>
					<tr>
						<xsl:if test="position() mod 2 = 0">
							<xsl:attribute name="class">even</xsl:attribute>
						</xsl:if>
						<td class="season">
							<xsl:for-each select="seasons/season/dates/date[1][hs_id='15431' or hs_id='15430' or hs_id='15429']">
								<xsl:if test="string-length(../../hs_name_public)&gt;0">
									<div class="season-name"><xsl:value-of select="../../hs_name_public"/></div>
								</xsl:if>
							</xsl:for-each>
							<xsl:for-each select="seasons/season/dates/date[hs_id='15431' or hs_id='15430' or hs_id='15429']">
								<div class="season-date"><xsl:value-of select="hs_from" /> - <xsl:value-of select="hs_to" /></div>
							</xsl:for-each>
						</td>
						<td class="price">
							<div class="price"><xsl:value-of select="@price" /></div>
							<xsl:if test="alloc-prices and $prices/../hrt_alloc_min_persons='1'">
								<div class="price-allocs">
									<xsl:for-each select="alloc-prices/*">
										<div class="price-alloc">
											<xsl:variable name="type">
												<xsl:choose>
													<xsl:when test="$price-type=3 or $price-type=4">allocation</xsl:when>
													<xsl:otherwise>person.plural</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:choose>
												<xsl:when test="@alloc=1">[%txt.price.alloc.person.singular/<xsl:value-of select="@alloc" />/<xsl:value-of select="@price" />]</xsl:when>
												<xsl:otherwise>[%txt.price.alloc.<xsl:value-of select="$type" />/<xsl:value-of select="@alloc" />/<xsl:value-of select="@price" />]</xsl:otherwise>
											</xsl:choose>
										</div>
									</xsl:for-each>
								</div>
							</xsl:if>
						</td>
					</tr>
				</xsl:for-each>
			</table>

			<!-- Aufruf Kinderpreise Sommer -->
			<xsl:if test="../../room-type-childrens/prices/season-groups/*">
				<div id="cst-detail-prices-childrens-summer" class="cst-detail-prices cst-detail-prices-childrens cst-detail-prices-childrens-summer">
					<xsl:call-template name="cstc:headline">
						<xsl:with-param name="type">3</xsl:with-param>
						<xsl:with-param name="title">
							[%txt.price.childrens]&#160;[%txt.season.summer]
						</xsl:with-param>
						<xsl:with-param name="class">cst cst-detail-prices cst-detail-prices-children</xsl:with-param>
					</xsl:call-template>

					<xsl:call-template name="roomtype-prices-children-seasons">
						<xsl:with-param name="prices" select="../../room-type-childrens/prices" />
						<xsl:with-param name="price-type" select="$price-type" />
						<xsl:with-param name="display-cols" select="$display-cols" />
						<xsl:with-param name="season">Sommer</xsl:with-param>
					</xsl:call-template>
                </div>
			</xsl:if>
		</xsl:if>

		<xsl:if test="$prices/season-groups/*[seasons/season/dates/date[hs_id='20231' or hs_id='20300' or hs_id='20223' or hs_id='20230']]">
			<h3 id="cst-detail-prices-winter" class="cst-detail-prices">[%moargut.prices.winter]</h3>
			<!-- Winterpreise -->
			<table id="roomtype-prices-parents-winter" class="roomtype-prices roomtype-prices-parents" cellpadding="0" cellspacing="0" border="0">
				<tr class="head">
					<td class="season-head">[%txt.season]</td>
					<td class="price-head">[%txt.price.perperson.short]</td>
				</tr>

				<xsl:for-each select="$prices/season-groups/*[seasons/season/dates/date[hs_id='20231' or hs_id='20300' or hs_id='20223' or hs_id='20230']]">
					<tr>
						<xsl:if test="position() mod 2 = 0">
							<xsl:attribute name="class">even</xsl:attribute>
						</xsl:if>
						<td class="season">
							<xsl:for-each select="seasons/*[hs_id='20231' or hs_id='20300' or hs_id='20223' or hs_id='20230']">
								<xsl:call-template name="cstc:roomtype-season" />
							</xsl:for-each>
						</td>
						<td class="price">
							<div class="price"><xsl:value-of select="@price" /></div>
							<xsl:if test="alloc-prices and $prices/../hrt_alloc_min_persons='1'">
								<div class="price-allocs">
									<xsl:for-each select="alloc-prices/*">
										<div class="price-alloc">
											<xsl:variable name="type">
												<xsl:choose>
													<xsl:when test="$price-type=3 or $price-type=4">allocation</xsl:when>
													<xsl:otherwise>person.plural</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:choose>
												<xsl:when test="@alloc=1">[%txt.price.alloc.person.singular/<xsl:value-of select="@alloc" />/<xsl:value-of select="@price" />]</xsl:when>
												<xsl:otherwise>[%txt.price.alloc.<xsl:value-of select="$type" />/<xsl:value-of select="@alloc" />/<xsl:value-of select="@price" />]</xsl:otherwise>
											</xsl:choose>
										</div>
									</xsl:for-each>
								</div>
							</xsl:if>
						</td>
					</tr>
				</xsl:for-each>
			</table>
			<!-- Aufruf Kinderpreise Winter -->
			<xsl:if test="../../room-type-childrens/prices">
				<div id="cst-detail-prices-childrens-winter" class="cst-detail-prices cst-detail-prices-childrens cst-detail-prices-childrens-winter">
					<xsl:call-template name="cstc:headline">
						<xsl:with-param name="type">3</xsl:with-param>
						<xsl:with-param name="title">
							[%txt.price.childrens]&#160;[%txt.season.winter]
						</xsl:with-param>
						<xsl:with-param name="class">cst cst-detail-prices cst-detail-prices-children  cst-detail-prices-children-winter</xsl:with-param>
					</xsl:call-template>

					<xsl:call-template name="roomtype-prices-children-seasons">
						<xsl:with-param name="prices" select="../../room-type-childrens/prices" />
						<xsl:with-param name="price-type" select="$price-type" />
						<xsl:with-param name="display-cols" select="$display-cols" />
						<xsl:with-param name="season">Winter</xsl:with-param>
					</xsl:call-template>
				</div>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<!-- Task 137122 Da Kinderpreise unabhängig von der Saison sind, nur 1 Zeile ohne Saisonzeit ausgeben -->
	<!-- Kinderpreise Sommer -->
	<xsl:template name="cstc:roomtype-prices-childrens-summer">
		<xsl:param name="prices" />
		<xsl:if test="$prices/season-groups/* and $prices/childrens/*">
			<table class="roomtype-prices roomtype-prices-children" cellpadding="0" cellspacing="0" border="0">
				<tr class="head">
					<xsl:for-each select="$prices/childrens/*">
						<xsl:sort select="hch_from" order="ascending" data-type="number"/>
						<td class="price-head">
							<xsl:value-of select="hch_from" /> - <xsl:value-of select="hch_to" /> [%txt.years]
						</td>
					</xsl:for-each>
				</tr>
				<xsl:for-each select="$prices/season-group-unique-date-froms/*">
					<xsl:sort select="@timestamp" data-type="number" />
					<xsl:variable name="season-unique-from"><xsl:value-of select="." /></xsl:variable>
					<xsl:if test="position()=1">
						<tr>
							<xsl:if test="position() mod 2 = 0">
								<xsl:attribute name="class">even</xsl:attribute>
							</xsl:if>
							<xsl:for-each select="$prices/childrens/*">
								<xsl:sort select="hch_from" order="ascending" data-type="number"/>
								<xsl:variable name="child" select="hch_id" />
								<xsl:variable name="childrenprice" select="$prices/season-groups/*[seasons/season/dates/date/hs_id ='15429' and @children=$child]/@price" />
								<td class="price">
									<xsl:if test="position() mod 2 = 0">
										<xsl:attribute name="class">price even</xsl:attribute>
									</xsl:if>
									<div class="price"><xsl:value-of select="$childrenprice" /></div>
									<xsl:if test="not($childrenprice)">-</xsl:if>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
				</xsl:for-each>
			</table>
		</xsl:if>
	</xsl:template>

	<!-- Kinderpreise Winter -->
	<xsl:template name="cstc:roomtype-prices-childrens-winter">
		<xsl:param name="prices" />
		<xsl:if test="$prices/season-groups/* and $prices/childrens/*">
			<table class="roomtype-prices roomtype-prices-children" cellpadding="0" cellspacing="0" border="0">
				<tr class="head">
					<xsl:for-each select="$prices/childrens/*">
						<xsl:sort select="hch_from" order="ascending" data-type="number"/>
						<td class="price-head">
							<xsl:value-of select="hch_from" /> - <xsl:value-of select="hch_to" /> [%txt.years]
						</td>
					</xsl:for-each>
				</tr>
				<xsl:for-each select="$prices/season-group-unique-date-froms/*">
					<xsl:sort select="@timestamp" data-type="number" />
					<xsl:variable name="season-unique-from"><xsl:value-of select="." /></xsl:variable>
					<xsl:if test="position()=1">
						<tr>
							<xsl:if test="position() mod 2 = 0">
								<xsl:attribute name="class">even</xsl:attribute>
							</xsl:if>
							<xsl:for-each select="$prices/childrens/*">
								<xsl:sort select="hch_from" order="ascending" data-type="number"/>
								<xsl:variable name="child" select="hch_id" />
								<xsl:variable name="childrenprice" select="$prices/season-groups/*[seasons/season/dates/date/hs_id = '20300' and @children=$child]/@price" />
								<td class="price">
									<xsl:if test="position() mod 2 = 0">
										<xsl:attribute name="class">price even</xsl:attribute>
									</xsl:if>
									<div class="price"><xsl:value-of select="$childrenprice" /></div>
									<xsl:if test="not($childrenprice)">-</xsl:if>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
				</xsl:for-each>
			</table>
		</xsl:if>
	</xsl:template>

	<xsl:template match="cstc:roomtype-prices-childrens" name="roomtype-prices-children-seasons">
		<xsl:param name="prices" />
		<xsl:param name="price-type" />
		<xsl:param name="display-cols">4</xsl:param>
		<xsl:param name="season">Sommer</xsl:param><!-- Sommer, Winter -->
		<xsl:variable name="roomtype-pensions" select="../../room-type-pensions"/>
		<xsl:choose>
			<xsl:when test="$season='Sommer'">
				<h3 class="cst-detail-prices">[%moargut.prices.summer]</h3>
			</xsl:when>
			<xsl:when test="$season='Winter'">
				<h3 class="cst-detail-prices">[%moargut.prices.winter]</h3>
			</xsl:when>
			<xsl:otherwise>
				<h3 class="cst-detail-prices">[%moargut.prices.winter]</h3>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="$prices/season-groups/* and $prices/childrens/*">
			<table class="roomtype-prices roomtype-prices-children test-table" cellpadding="0" cellspacing="0" border="0">
				<xsl:if test="count($prices/season-group-unique-ids-new/*) &gt; 1">
					<tr class="head">
						<td class="td-first"><div class="children-age test">[%txt.age]</div></td>
						<xsl:for-each select="$prices/childrens/*">
							<xsl:sort select="hch_from" order="ascending" data-type="number"/>

							<td class="child td-content"><xsl:value-of select="hch_from" /> - <xsl:value-of select="hch_to" />&#160;<span>[%txt.years]</span></td>
						</xsl:for-each>
					</tr>
				</xsl:if>

				<xsl:for-each select="$prices/season-group-unique-ids-new/*/season">
					<xsl:sort select="@name-public" order="ascending" data-type="text"/>
					<xsl:variable name="seasons-uniq-id" select="text()" />
					<xsl:variable name="season-data" select="($prices/season-groups/*[contains(@seasons,$seasons-uniq-id)]/seasons/*[@id=$seasons-uniq-id])[1]" />
					<xsl:if test="starts-with($season-data/hs_name, $season )">
						<tr>
							<td class="season">
								<xsl:for-each select="$season-data">
									<xsl:call-template name="cstc:roomtype-season" />
								</xsl:for-each>
							</td>
							<xsl:for-each select="$prices/childrens/*">
								<xsl:sort select="hch_from" order="ascending" data-type="number"/>
								<xsl:variable name="child" select="hch_id" />
								<td class="price">
									<xsl:variable name="price">
										<xsl:choose>
											<xsl:when test="count($roomtype-pensions/*)&gt;1">
												<xsl:choose>
													<xsl:when test="$prices/season-groups/*[contains(@seasons,$seasons-uniq-id) and @children=$child]/seasons/*[1]/pension/modified_price/*[1]/price='-1'">
														[%txt.not.bookable]
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="$prices/season-groups/*[contains(@seasons,$seasons-uniq-id) and @children=$child]/seasons/*[1]/pension/modified_price/*[1]/price_display" />
													</xsl:otherwise>
												</xsl:choose>
											</xsl:when>
											<xsl:otherwise>

												<xsl:value-of select="$prices/season-groups/*[contains(@seasons,$seasons-uniq-id) and @children=$child]/@price" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<div class="price"><xsl:value-of select="$price" /></div>
									<xsl:if test="not($price)">-</xsl:if>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
				</xsl:for-each>
			</table>
		</xsl:if>
	</xsl:template>

	<xsl:template name="cstc:roomtype-season-1">
		<xsl:if test="string-length(hs_name_public)&gt;0">
			<div class="season-name"><xsl:value-of select="hs_name_public" /></div>
		</xsl:if>
		<xsl:for-each select="dates/*">
			<div class="season-date"><xsl:value-of select="substring(hs_from,0,7)" /><xsl:value-of select="substring(hs_from,9)" /> - <xsl:value-of select="substring(hs_to,0,7)" /><xsl:value-of select="substring(hs_to,9)" /></div>
		</xsl:for-each>
	</xsl:template>

	<!--#### CHANNEL 822 ####-->
	<xsl:template match="site:match-space/site-links/remember">
		<xsl:param name="id" />
		<xsl:param name="title" />
		<xsl:param name="description" />
		<xsl:param name="price" />
		<xsl:param name="class">cst-button</xsl:param>
		<xsl:param name="hotel" />
		<xsl:param name="hotel-id" />
		<xsl:param name="url" />
		<xsl:param name="vars" />
		<xsl:param name="text">[%txt.remember]</xsl:param>
		<xsl:choose>
			<xsl:when test="/site:site/site:config/@remember-vnh='true'">
				<xsl:variable name="url_use">
					<xsl:if test="string-length( $url ) &gt; 0">
						<xsl:value-of select="$url" />
					</xsl:if>
					<xsl:if test="$vars != ''">
						<xsl:value-of select="$vars"/>
					</xsl:if>
				</xsl:variable>
				<xsl:variable name="single_quote">'</xsl:variable>
				<xsl:variable name="onclick">
					cst_remember.group_add( this, '<xsl:value-of select="$hotel-id" />', '<xsl:value-of select="translate( $hotel, $single_quote, ' ' )" />' );
					<xsl:if test="string-length( $id ) &gt; 0">
						cst_remember.group_item_add( '<xsl:value-of select="$id" />', '<xsl:value-of select="translate( $title, $single_quote, ' ' )" />', '<xsl:value-of select="$hotel-id" />', '<xsl:value-of select="$url_use" />', '<xsl:value-of select="$price" />', '<xsl:value-of select="translate( $description, $single_quote, ' ' )" />' );
					</xsl:if>
					return false;
				</xsl:variable>
				<a href="#remember" class="{$class}" onclick="{normalize-space($onclick)}">
					<span><xsl:value-of select="$text" /></span>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="urluse">
					<xsl:choose>
						<xsl:when test="not($url)">location.href</xsl:when>
						<xsl:otherwise>'<xsl:value-of select="$url" />'</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="$vars != ''">
						<xsl:value-of select="$vars"/>
					</xsl:if>
				</xsl:variable>
				<xsl:variable name="single_quote">'</xsl:variable>
				<xsl:variable name="title_use" select="translate($title,$single_quote,' ')" />
				<a href="#remember" onclick="remember_item_add('{$id}','{$price}','{$title_use}',{$urluse},'{$hotel}','{$hotel-id}'); return false;" class="{$class}">
					<xsl:value-of select="$text" />
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="cstc:program-list">
		<xsl:variable name="id" select="generate-id()" />
		<div class="cst-list cst-list-programs" id="moargut_programs_{$id}">
			<xsl:variable name="layout" select="/site:site/site:cms/content-attribute[@name='layout']/@value"/>
			<xsl:choose>
				<xsl:when test="$layout='single'">
					<xsl:for-each select="programs/program-group">
						<xsl:sort select="@group-indicator-order" data-type="number" order="ascending" />
						<!--<h2><xsl:value-of select="@group-name" /><xsl:text> </xsl:text><span class="program-number">(<xsl:value-of select="count(*)" />)</span></h2>-->
							<!--<xsl:copy-of select="."/>-->
							<xsl:for-each select="./*">
								<xsl:variable name="program" select="." />
								<xsl:variable name="hp_id" select="hp_id"/>
								<xsl:variable name="hp_image" select="hp_image"/>
								<div class="list-item" id="hpid-{$hp_id}">
									<div class="list-item-bar">
										<h3><xsl:value-of select="hp_name"/></h3>
										<a href="#" class="cst-link"></a>
										<div class="program-links">
											<xsl:if test="not( $program/@requestable ) or $program/@requestable = 'true'">
												<a class="cst-button cst-button-inquire" href="request.php?page=6.page1&amp;hotel_id={hp_hotel}&amp;remember[hp]={hp_id}">[%txt.request]</a>
											</xsl:if>
											<xsl:if test="/site:site/site:config/@remember='1' or /site:site/site:config/@remember-vnh='true'">
												<xsl:apply-templates select="/site:site/site:match-space/site-links/remember">
													<xsl:with-param name="id">hp<xsl:value-of select="$program/hp_id" /></xsl:with-param>
													<xsl:with-param name="price"><xsl:value-of select="$program/hp_price" /></xsl:with-param>
													<xsl:with-param name="title"><xsl:value-of select="$program/hp_name" /></xsl:with-param>
													<xsl:with-param name="hotel"><xsl:value-of select="hotel/hotel_nameaffix" /></xsl:with-param>
													<xsl:with-param name="hotel-id"><xsl:value-of select="$program/hp_hotel" /></xsl:with-param>
													<xsl:with-param name="link"></xsl:with-param>
													<xsl:with-param name="class">cst-link cst-link-notice</xsl:with-param>
												</xsl:apply-templates>
											</xsl:if>
										</div>
									</div>
								</div>
								<style type="text/css">#hpid-<xsl:value-of select="$hp_id" /> {background-image: url('<xsl:value-of select="$hp_image"/>/300x300s'); }</style>
							</xsl:for-each>
					</xsl:for-each>
						<script type="text/javascript">
							_lib_load('jQuery', 'jsoncookie');
						</script>
					<script>

					</script>
				</xsl:when>
				<!--#### INDIKATOR FILTER CHANNEL-822 ####-->
				<xsl:when test="$layout='indikator-filter'">
					<xsl:variable name="programs" select="." />
					<xsl:variable name="criterias" select="crits" />
					<xsl:variable name="assigned-indicators"><xsl:for-each select="programs/program-group[@group-id!='9999']">
						<xsl:variable name="coi_id" select="@group-id" />
						<xsl:copy-of select="$programs/indicators/*[coi_id=$coi_id]" />
					</xsl:for-each></xsl:variable>
					<xsl:variable name="list-filter-indicators" select="exslt:node-set($assigned-indicators)" />
					<div class="moargut-list-filter">
						<form action="hotel-program-list.php" method="get">
							<fieldset class="list-filter-indicators">
								<xsl:for-each select="$list-filter-indicators/*">
									<xsl:sort select="normalize-space(coi_teaser_str)" order="ascending" data-type="number"/>
									<xsl:variable name="coi_id" select="coi_id"/>
									<label class="list-filter-indicator">
										<input type="checkbox" class="coi-checkbox" name="c[id_list_program_indicators][{coi_id}]" value="{coi_id}" data-id="maorgut_programs_{$id}">
											<xsl:if test="$criterias/ids_package_indicators/*[. = $coi_id]">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</input>
										<span class="list-filter-name">
											<xsl:value-of select="coi_name"/>
										</span>
									</label>
								</xsl:for-each>
							</fieldset>
							<input type="hidden" name="type" value="1"/>
							<noscript>
								<input type="submit" name="submit_button" value="Submit"/>
							</noscript>
						</form>
					</div>
					<xsl:variable name="filter-js">
						jQuery('input.coi-checkbox').bind('change', nst2015.remote_list_loader );
					</xsl:variable>
					<script type="text/javascript"><xsl:value-of select="normalize-space($filter-js)" /></script>
				</xsl:when>
				<!--#### ACCORDION AUS PROGRAMMEN ####-->
				<xsl:otherwise>
					<div class="moargut-list">
						<div class="moargut-list-item">
							<xsl:for-each select="programs/program-group">
								<xsl:sort select="@group-indicator-order" data-type="number" order="ascending" />
								<h2 class="accordion">
									<xsl:value-of select="@group-name" />
									<xsl:text> </xsl:text><span class="program-number">(<xsl:value-of select="count(*)" />)</span>
								</h2>
								<div class="cst-program-list">
									<xsl:apply-templates select="*" />
								</div>
							</xsl:for-each>
						</div>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="cstc:program-list/programs/program-group/*">
		<xsl:variable name="program" select="." />
		<xsl:variable name="hp_price_type" select="./hp_price_type" />
		<xsl:variable name="hp_price" select="./hp_price" />
		<div class="cst-program cst-box">
			<div class="program-infos hp-{hp_id} />">
				<xsl:choose>
					<xsl:when test="contains(hp_name,'|')">
						<h3><xsl:value-of select="substring-before(hp_name,'|')" /></h3>
						<div class="hp-price-from-top">&#160;</div>
						<div class="program-variant-subtitle"><xsl:value-of select="substring-after(hp_name,'|')" /></div>
					</xsl:when>

					<xsl:otherwise>
						<h3><xsl:value-of select="hp_name" /></h3>
						<div class="hp-price-from-top">&#160;</div>
					</xsl:otherwise>
				</xsl:choose>
				<div class="program-description">
					<xsl:if test="string-length( hp_desc_teaser_str ) &gt; 3">
						<div class="program-teaser"><xsl:copy-of select="hp_desc_teaser_str/node()" /></div>
					</xsl:if>
					<xsl:if test="string-length( hp_desc_cms ) &gt; 3">
						<div class="program-detail"><xsl:copy-of select="hp_desc_cms/node()" /></div>
					</xsl:if>
				</div>
				<!--<div class="program-price-from">-->
					<!--<span class="program-price"><xsl:value-of select="hp_price" /></span>-->
				<!--</div>-->
			</div>
			<div class="program-links">
				<xsl:if test="$program/hp_duration &gt; 0">
					<div class="cst-program-duration">
						[%txt.stayduration.min]: <xsl:value-of select="$program/hp_duration" />
						<xsl:choose>
							<xsl:when test="$program/hp_duration=1"> [%txt.stay]</xsl:when>
							<xsl:otherwise> [%txt.stays]</xsl:otherwise>
						</xsl:choose>
					</div>
				</xsl:if>
				<xsl:if test="$program/hp_treatment_length &gt; 0">
					<div class="cst-program-treatment-length">
						[%txt.duration/<xsl:value-of select="$program/hp_treatment_length" />]
					</div>
				</xsl:if>

				<xsl:choose>
					<xsl:when test="$hp_price_type=0">
						<div class="hp-price-from">
							<span class="hp-price"><xsl:value-of select="hp_price" /></span>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<div class="hp-price-from">
							<span class="hp-price"><xsl:value-of select="hp_price" /></span>
						</div>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:if test="not( $program/@requestable ) or $program/@requestable = 'true'">
					<a class="cta cst-button-inquire" href="transaction.php?items[]=hp:{$program/hp_id}&amp;c[id_hotel]={$program/hp_hotel}&amp;vri_id=3821">[%txt.request]</a>
				</xsl:if>
				<xsl:if test="not( $program/@bookable ) or $program/@bookable = 'true'">
					<a class="cta cst-button-book" href="{@url-booking}">[%txt.book]</a>
				</xsl:if>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="cstc:user-request-add[@page=1 and @type = 2]" name="custom-user-request-add-page1-type2">
		<xsl:param name="action"><xsl:value-of select="$_self" />?page=2.page2&amp;hotel_id=<xsl:value-of select="@hotel_id" /></xsl:param>
		<form method="post" action="{$action}" name="form" id="cst-request-form">
			<div class="cst-request cst-request-type-2">
				<xsl:apply-templates select="/site:site/site:match-space/site-headline">
					<xsl:with-param name="type">1</xsl:with-param>
					<xsl:with-param name="title">
						<xsl:choose>
							<xsl:when test="hotel/hotel_setting_female=2">
								[%txt.request.sendhotel3/<xsl:value-of select="translate(concat(hotel/hotel_nameaffix,' ',hotel/hotel_name),'/','&#182;')" />]
							</xsl:when>
							<xsl:when test="hotel/hotel_setting_female=1">
								[%txt.request.sendhotel2/<xsl:value-of select="translate(concat(hotel/hotel_nameaffix,' ',hotel/hotel_name),'/','&#182;')" />]
							</xsl:when>
							<xsl:otherwise>
								[%txt.request.sendhotel/<xsl:value-of select="translate(concat(hotel/hotel_nameaffix,' ',hotel/hotel_name),'/','&#182;')" />]
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="class">cst cst-request</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="count(errors/*) &gt; 0">
					<xsl:call-template name="cstc:errors">
						<xsl:with-param name="errors" select="errors" />
					</xsl:call-template>
				</xsl:if>
				<div class="cst-request-note">
					[%page_add_1.note_<xsl:value-of select="@type" />]
				</div>
				<xsl:if test="remember-items/*">
					<xsl:apply-templates select="/site:site/site:match-space/form/remember-items">
						<xsl:with-param name="remember_items" select="remember-items" />
					</xsl:apply-templates>
				</xsl:if>
				<xsl:variable name="form" select="." />
				<div class="cst-box cst-request-user-data">
					<xsl:apply-templates select="/site:site/site:match-space/form/user-data">
						<xsl:with-param name="form" select="." />
					</xsl:apply-templates>
					<fieldset>
						<legend>
							[%txt.addressdata]
						</legend>
						<div class="cst-request-item cst-request-item-street">
							<xsl:call-template name="form-element-required-attribute">
								<xsl:with-param name="field">request_user_street</xsl:with-param>
								<xsl:with-param name="class">street</xsl:with-param>
								<xsl:with-param name="form" select="$form" />
							</xsl:call-template>
							<label for="street">
								[%txt.street]
								<xsl:call-template name="form-element-required">
									<xsl:with-param name="field">request_user_street</xsl:with-param>
									<xsl:with-param name="form" select="$form" />
								</xsl:call-template>
							</label>
							<input type="text" id="street" name="form[request_user_street]" value="{form/request_user_street}" class="inputtext inputtext-street" tabindex="6" />
						</div>
						<div class="cst-request-item cst-request-item-zip">
							<xsl:call-template name="form-element-required-attribute">
								<xsl:with-param name="field">request_user_zip</xsl:with-param>
								<xsl:with-param name="class">zip</xsl:with-param>
								<xsl:with-param name="form" select="$form" />
							</xsl:call-template>
							<label for="zipcode">
								[%txt.zip]
								<xsl:call-template name="form-element-required">
									<xsl:with-param name="field">request_user_zip</xsl:with-param>
									<xsl:with-param name="form" select="$form" />
								</xsl:call-template>
							</label>
							<input type="text" id="zipcode" name="form[request_user_zip]" value="{form/request_user_zip}" class="inputtext inputtext-zip" tabindex="7" />
						</div>
						<div class="cst-request-item cst-request-item-city">
							<xsl:call-template name="form-element-required-attribute">
								<xsl:with-param name="field">request_user_city</xsl:with-param>
								<xsl:with-param name="class">city</xsl:with-param>
								<xsl:with-param name="form" select="$form" />
							</xsl:call-template>
							<label for="city">
								[%txt.city]
								<xsl:call-template name="form-element-required">
									<xsl:with-param name="field">request_user_city</xsl:with-param>
									<xsl:with-param name="form" select="$form" />
								</xsl:call-template>
							</label>
							<input type="text" id="city" name="form[request_user_city]" value="{form/request_user_city}" class="inputtext inputtext-city" tabindex="8" />
						</div>
						<div class="cst-request-item cst-request-item-country">
							<xsl:call-template name="form-element-required-attribute">
								<xsl:with-param name="field">request_user_country</xsl:with-param>
								<xsl:with-param name="class">country</xsl:with-param>
								<xsl:with-param name="form" select="$form" />
							</xsl:call-template>
							<label for="country">
								[%txt.country]
								<xsl:call-template name="form-element-required">
									<xsl:with-param name="field">request_user_country</xsl:with-param>
									<xsl:with-param name="form" select="$form" />
								</xsl:call-template>
							</label>
							<input type="text" id="country" name="form[request_user_country]" value="{form/request_user_country}" class="inputtext inputtext-country" tabindex="9" />
						</div>
					</fieldset>
					<div class="cst-request-required-hint">* [%txt.field.required]</div>
				</div>
				<xsl:apply-templates select="/site:site/site:match-space/site-headline">
					<xsl:with-param name="type">2</xsl:with-param>
					<xsl:with-param name="title">[%page_add_1.tripinfos]</xsl:with-param>
					<xsl:with-param name="class">cst cst-request cst-request-trip-infos</xsl:with-param>
				</xsl:apply-templates>

				<div class="cst-box cst-request-trip-infos">
					<xsl:call-template name="custom-cst-request-travelling-persons" />
					<xsl:call-template name="custom-cst-request-roomtype"><xsl:with-param name="request" select="." /></xsl:call-template>
					<xsl:call-template name="custom-cst-request-travelling-date" />
					<div class="cst-request-required-hint">* [%txt.field.required]</div>
				</div>

				<xsl:if test="count(roomtype-preference/*)&gt;0">
					<div class="cst-request-roomtype-preference">
						<xsl:apply-templates select="/site:site/site:match-space/site-headline">
							<xsl:with-param name="type">2</xsl:with-param>
							<xsl:with-param name="title">[%request.roomtype.preference]</xsl:with-param>
							<xsl:with-param name="class">cst cst-request cst-request-roomtype-preference</xsl:with-param>
						</xsl:apply-templates>
						<span class="cst-request-roomtype-preference">
							[%txt.room]: <xsl:value-of select="$form/form/roomtype-preference" />
						</span>
						<select name="form[roomtype-preference]">
							<option value="--">--</option>
							<xsl:for-each select="roomtype-preference/*">
								<option value="{.}">
									<xsl:if test=". = $form/form/roomtype-preference">
										<xsl:attribute name="selected">selected</xsl:attribute>
									</xsl:if>
									<xsl:value-of select="." />
								</option>
							</xsl:for-each>
						</select>
					</div>
				</xsl:if>

				<xsl:if test="count(package-preference/*)&gt;0">
					<div class="cst-request-package-preference">
						<xsl:apply-templates select="/site:site/site:match-space/site-headline">
							<xsl:with-param name="type">2</xsl:with-param>
							<xsl:with-param name="title">[%request.package.preference]</xsl:with-param>
							<xsl:with-param name="class">cst cst-request cst-request-package-preference</xsl:with-param>
						</xsl:apply-templates>
						<span class="cst-request-package-preference">
							[%txt.room]: <xsl:value-of select="$form/form/package-preference" />
						</span>
						<select name="form[package-preference]">
							<option value="--">--</option>
							<xsl:for-each select="package-preference/*">
								<option value="{.}">
									<xsl:if test=". = $form/form/package-preference">
										<xsl:attribute name="selected">selected</xsl:attribute>
									</xsl:if>
									<xsl:value-of select="." />
								</option>
							</xsl:for-each>
						</select>
					</div>
				</xsl:if>

				<xsl:if test="not(remember-items/*/hpa_id) and count(package-preference/*)=0 and count(hotel-packages/*)&gt;0">
					<h2 class="cst cst-request cst-request-room-types">[%txt.packages]</h2>
					<div class="cst-box cst-request-room-types">
						<!-- span class="packages-hint">[%txt.request.packages.hint]</span -->
						<ul class="cst-request-package-list">
							<li class="amount-hint"><h3 class="cst cst-request">[%txt.amount]</h3></li>
							<li class="amount-hint"><h3 class="cst cst-request">[%txt.amount]</h3></li>
							<xsl:for-each select="hotel-packages/*">
								<xsl:sort data-type="text" select="hpa_name" order="ascending" />
								<xsl:sort data-type="number" select="hpa_order" order="ascending" />
								<xsl:if test="not(hpa_variant_group = preceding-sibling::*/hpa_variant_group)">
									<li>
										<input type="text" name="form[request-items][hpa][{hpa_id}][amount]" />
										<a href="#">
											<xsl:variable name="hpa_name">
												<xsl:choose>
													<xsl:when test="contains( hpa_name, '|' )">
														<xsl:value-of select="substring-before( hpa_name, '|' )" />
													</xsl:when>

													<xsl:otherwise>
														<xsl:value-of select="hpa_name" />
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>

											<xsl:value-of select="$hpa_name" />
											<div class="package-info">
												<xsl:if test="hpa_image!='0'">
													<img src="{hpa_image}/100x100s" />
												</xsl:if>
												<h2><xsl:value-of select="$hpa_name" /></h2>
												<div class="teaser">
													<xsl:call-template name="filter-links">
														<xsl:with-param name="node" select="hpa_teaser_str" />
													</xsl:call-template>
												</div>
											</div>
										</a>
									</li>
								</xsl:if>
							</xsl:for-each>
						</ul>
					</div>
					<script type="text/javascript">
						_lib_load('jQuery', 'jsoncookie');
					</script>
					<script type="text/javascript">
						$('ul.cst-request-package-list a').click(function(){ return false; })
						$(window).unload(function() {
							var saved_values = {}
							$('ul.cst-request-package-list input').each( function() {
								if( this.value != '' ) {
									saved_values[this.name] = this.value
								}
							});
							$.JSONCookie('package-preference', saved_values, { expires: 1 });
						});
						var saved_values = $.JSONCookie('package-preference');
						$('ul.cst-request-package-list input').each( function() {
							if( saved_values[this.name] ) {
								this.value = saved_values[this.name];
							}
						});
					</script>
				</xsl:if>

				<xsl:if test="count(material/*) &gt; 0 or @newsletter or marketing-actions/*">
					<xsl:apply-templates select="/site:site/site:match-space/site-headline">
						<xsl:with-param name="type">2</xsl:with-param>
						<xsl:with-param name="title">[%txt.other]</xsl:with-param>
						<xsl:with-param name="class">cst cst-request cst-request-wishes</xsl:with-param>
					</xsl:apply-templates>
					<div class="cst-request cst-request-more cst-request-newsletter-marketing cst-box">
						<xsl:call-template name="custom-cst-request-newsletter-marketing">
							<!--<xsl:with-param name="form" select="." />-->
						</xsl:call-template>
					</div>
				</xsl:if>

				<xsl:apply-templates select="/site:site/site:match-space/site-headline">
					<xsl:with-param name="type">2</xsl:with-param>
					<xsl:with-param name="title">[%txt.wishes]</xsl:with-param>
					<xsl:with-param name="class">cst cst-request cst-request-wishes</xsl:with-param>
				</xsl:apply-templates>
				<div class="cst-box cst-request-wishes">
					<xsl:if test="@lng_preference and count(languages/*[checked=1]) &gt; 0">
						<xsl:apply-templates select="/site:site/site:match-space/site-headline">
							<xsl:with-param name="type">3</xsl:with-param>
							<xsl:with-param name="title">[%txt.request.language.hint]</xsl:with-param>
							<xsl:with-param name="class">cst cst-language-hint</xsl:with-param>
						</xsl:apply-templates>
						<xsl:for-each select="languages/*">
							<xsl:if test="checked = 1">
								<div class="cst-language-hint-language">
									<input id="request_language_{sl_id}" type="radio" name="form[lng_preference]" value="{sl_name}">
										<xsl:if test="/site:site/site:config/@language = sl_id">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if>
									</input>
									<label for="request_language_{sl_id}">
										<img src="{/site:site/site:env/site:vars/@base-resources}images/flags/{sl_short}.gif" style="margin-right: 5px"/>
										<xsl:choose>
											<xsl:when test="sl_name_str!=''">
												<xsl:value-of select="sl_name_str" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="sl_name" />
											</xsl:otherwise>
										</xsl:choose>
									</label>
								</div>
							</xsl:if>
						</xsl:for-each>
					</xsl:if>
					<textarea rows="7" cols="40" name="form[request_wishes]">
						<xsl:value-of select="form/request_wishes" />
					</textarea>
				</div>
				<xsl:if test="custom-elements/*">
					<xsl:apply-templates select="custom-elements" />
				</xsl:if>

				<xsl:if test="/site:site/site:config/@privacy='true'">
					<xsl:apply-templates select="/site:site/site:match-space/site-headline">
						<xsl:with-param name="type">2</xsl:with-param>
						<xsl:with-param name="title">[%txt.privacy]</xsl:with-param>
						<xsl:with-param name="class">cst cst-request cst-request-privacy</xsl:with-param>
					</xsl:apply-templates>
					<div class="cst cst-request cst-request-privacy">
						[%txt.privacy.statement]
					</div>
				</xsl:if>
				<!-- spam protection dummy request_detail_text -->
				<div class="cst-request-detail-text">
					<input name="form[request_detail_text]" value="" />
				</div>
				<div class="cst-request cst-request-submit">
					<input class="inputbutton" type="submit" value="[%txt.commit]" id="sbutton" />
				</div>
			</div>
		</form>
		<xsl:call-template name="user-request-form-script" />
		<xsl:apply-templates select="track-element-form-view" />
		<xsl:variable name="breadcrumb-js">
			(function(){
			var bc = nst2015.opt.main.children('.breadcrumb');
			var li = document.createElement('li');
			li.innerHTML = nst2015.opt.main.find( 'h1.cst-request' ).text();
			bc.find('ul').append( li );
			})();
		</xsl:variable>
		<script type="text/javascript"><xsl:value-of select="normalize-space($breadcrumb-js)" /></script>
	</xsl:template>

	<xsl:template match="/site:site/site:match-space/form/user-data" name="custom-cst-request-user-data">
		<xsl:param name="form" />
		<script type="text/javascript">_lib_load( 'vct' );</script>
		<fieldset class="cst-request-personal-data">
			<legend>
				[%txt.personaldata] ([%txt.child])
			</legend>
			<input type="hidden" name="form[request_user_title]" value="-1" />
			<!--<div class="cst-request-item cst-request-item-salutation">
				<xsl:choose>
					<xsl:when test="/site:site/site:config/@language-str='ru'">
						<input type="hidden" name="form[request_user_title]" value="0" />
					</xsl:when>
					<xsl:otherwise>
						<label for="salutation">[%txt.salutation]</label>
						<ul class="cst-request-salutation-inputs">
							<li class="cst-request-salutation-input-male">
								<input class="inputradio" id="sal_male" type="radio" name="form[request_user_title]" value="0">
									<xsl:if test="$form/form/request_user_title=0">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
								<label class="" for="sal_male">[%txt.salutation.mr]</label>
							</li>
							<li class="cst-request-salutation-input-female">
								<input class="inputradio" id="sal_female" type="radio" name="form[request_user_title]" value="1">
									<xsl:if test="$form/form/request_user_title=1">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
								<label class="" for="sal_female">[%txt.salutation.mrs]</label>
							</li>
							&lt;!&ndash; li class="cst-request-salutation-input-company">
								<input class="inputradio" id="sal_company" type="checkbox" name="form[request_user_title]" value="2" onclick="document.getElementById('cst-request-item-company').style.display == 'none'"/>
								<label class="" for="sal_company">[%txt.salutation.company]</label>
							</li&ndash;&gt;
							<li class="cst-request-salutation-input-family">
								<input class="inputradio" id="sal_family" type="radio" name="form[request_user_title]" value="3">
									<xsl:if test="$form/form/request_user_title=3">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
								<label class="" for="sal_family">[%txt.salutation.family]</label>
							</li>
						</ul>
						<a class="cst-request-add cst-request-add-company" href="#">[%txt.add.icon][%txt.add.company]</a>
						<script>
							$(function() {
							jQuery( '.cst-request-add-company' ).click( function() {
							$(this).contentToggle( '[%txt.add.icon][%txt.add.company]|[%txt.del.icon][%txt.del.company]', '#cst-request-item-company' );
							return false;
							});
							});
						</script>
						<div class="clearfix" />
						&lt;!&ndash; xsl:call-template name="form-dropdown">
							<xsl:with-param name="name">form[request_user_title]</xsl:with-param>
							<xsl:with-param name="class">form_salutation</xsl:with-param>
							<xsl:with-param name="tabindex">1</xsl:with-param>
							<xsl:with-param name="options" select="salutations" />
							<xsl:with-param name="selected" select="form/request_user_title" />
						</xsl:call-template&ndash;&gt;
					</xsl:otherwise>
				</xsl:choose>
			</div>-->
			<!--<div class="cst-request-item cst-request-item-academic" id="cst-request-item-academic">
				<xsl:call-template name="form-element-required">
					<xsl:with-param name="field">request_user_title_academic</xsl:with-param>
					<xsl:with-param name="class">academic</xsl:with-param>
					<xsl:with-param name="form" select="$form" />
				</xsl:call-template>
				<label class="title" for="title">
					[%txt.title]
					<xsl:call-template name="form-element-required">
						<xsl:with-param name="field">request_user_title_academic</xsl:with-param>
						<xsl:with-param name="form" select="$form" />
					</xsl:call-template>
				</label>
				<input type="text" name="form[request_user_title_academic]" value="{$form/form/request_user_title_academic}" class="inputtext inputtext-academic" tabindex="1" />
			</div>
-->
			<!--<div class="cst-request-item cst-request-item-company" id="cst-request-item-company">
				<xsl:call-template name="form-element-required-attribute">
					<xsl:with-param name="field">request_user_company</xsl:with-param>
					<xsl:with-param name="class">company</xsl:with-param>
					<xsl:with-param name="form" select="$form" />
				</xsl:call-template>
				<label class="company" for="company">
					[%txt.salutation.company]
					<xsl:call-template name="form-element-required">
						<xsl:with-param name="field">request_user_company</xsl:with-param>
						<xsl:with-param name="form" select="$form" />
					</xsl:call-template>
				</label>
				<input type="text" id="company" name="form[request_user_company]" value="{$form/form/request_user_company}" class="inputtext inputtext-company" tabindex="2" />
			</div>-->

			<div class="cst-request-item cst-request-item-firstname">
				<xsl:call-template name="form-element-required-attribute">
					<xsl:with-param name="field">request_user_firstname</xsl:with-param>
					<xsl:with-param name="class">firstname</xsl:with-param>
					<xsl:with-param name="form" select="$form" />
				</xsl:call-template>
				<!--<label class="firstname" for="firstname">
					[%txt.firstname]
					<xsl:call-template name="form-element-required">
						<xsl:with-param name="field">request_user_firstname</xsl:with-param>
						<xsl:with-param name="form" select="$form" />
					</xsl:call-template>
				</label>-->
				<input type="text" id="firstname" name="form[request_user_firstname]" value="{$form/form/request_user_firstname}" class="inputtext inputtext-firstname" tabindex="3" placeholder="*[%txt.firstname]" />
			</div>
			<div class="cst-request-item cst-request-item-lastname">
				<xsl:call-template name="form-element-required-attribute">
					<xsl:with-param name="field">request_user_lastname</xsl:with-param>
					<xsl:with-param name="class">lastname</xsl:with-param>
					<xsl:with-param name="form" select="$form" />
				</xsl:call-template>
				<!--<label class="title" for="lastname">
					[%txt.lastname]
					<xsl:call-template name="form-element-required">
						<xsl:with-param name="field">request_user_lastname</xsl:with-param>
						<xsl:with-param name="form" select="$form" />
					</xsl:call-template>
				</label>-->
				<input type="text" id="lastname" name="form[request_user_lastname]" value="{$form/form/request_user_lastname}" class="inputtext inputtext-lastname" tabindex="4" placeholder="*[%txt.lastname]"/>
			</div>
			<xsl:variable name="children_box_id" select="generate-id()"/>
			<div class="cst-request-item cst-request-item-add-children">
				<a class="cst-request-add cst-request-add-child" href="#">[%txt.add.icon][%txt.children.children.add]</a>
				<script>
					$(function() {
						jQuery( '.cst-request-add-child' ).click( function() {
							if($(this).hasClass('open')) {$('.child-age0').val('');
							} else {$('.child-age0').val(0);
							};
							$(this).contentToggle( '[%txt.add.icon][%txt.children.children.add]|[%txt.del.icon][%txt.children.children.del]', '#<xsl:value-of select="$children_box_id" />' );
							return false;
						});
					});
				</script>
			</div>

			<div class="cst-request-item cst-request-item-child" id="{$children_box_id}">
				<xsl:if test="count(form/rc_age/*/rc_age[not(.='-')]) &gt; 0">
					<xsl:attribute name="class">cst-request-item cst-request-item-child cst-request-item-child-prefilled</xsl:attribute>
				</xsl:if>
				<!--[%request.age.of.child]-->
				<xsl:call-template name="request-form-children-boxes-moargut">
					<xsl:with-param name="max">4</xsl:with-param>
					<xsl:with-param name="names" select="true()" />
				</xsl:call-template>
			</div>
		</fieldset>
		<fieldset class="cst-request-communication-data">
			<legend>[%txt.communicationdata]</legend>
			<div class="cst-request-item cst-request-item-email">
				<xsl:call-template name="form-element-required-attribute">
					<xsl:with-param name="field">request_user_email</xsl:with-param>
					<xsl:with-param name="class">email</xsl:with-param>
					<xsl:with-param name="form" select="$form" />
				</xsl:call-template>
				<!--<label for="email">
					[%txt.email]
					<xsl:call-template name="form-element-required">
						<xsl:with-param name="field">request_user_email</xsl:with-param>
						<xsl:with-param name="form" select="$form" />
					</xsl:call-template>
				</label>-->
				<input type="text" id="email" name="form[request_user_email]" value="{$form/form/request_user_email}" class="inputtext inputtext-email" tabindex="5" placeholder="*[%txt.email]"/>
			</div>
			<div class="cst-request-item cst-request-item-phone">
				<xsl:call-template name="form-element-required-attribute">
					<xsl:with-param name="field">request_user_telefon</xsl:with-param>
					<xsl:with-param name="class">phone</xsl:with-param>
					<xsl:with-param name="form" select="$form" />
				</xsl:call-template>
				<!--<label for="phone">
					[%txt.telefon]
					<xsl:call-template name="form-element-required">
						<xsl:with-param name="field">request_user_telefon</xsl:with-param>
						<xsl:with-param name="form" select="$form" />
					</xsl:call-template>
				</label>-->
				<input type="text" id="phone" name="form[request_user_telefon]" value="{$form/form/request_user_telefon}" class="inputtext inputtext-phone" tabindex="6" placeholder="[%txt.telefon]"/>
			</div>
			<!--<div class="cst-request-item cst-request-item-telefax">-->
				<!--<label for="telefax">-->
					<!--<xsl:call-template name="form-element-required-attribute">-->
						<!--<xsl:with-param name="field">request_user_telefax</xsl:with-param>-->
						<!--<xsl:with-param name="class">telefax</xsl:with-param>-->
						<!--<xsl:with-param name="form" select="$form" />-->
					<!--</xsl:call-template>-->
					<!--[%txt.telefax]-->
					<!--<xsl:call-template name="form-element-required">-->
						<!--<xsl:with-param name="field">request_user_telefax</xsl:with-param>-->
						<!--<xsl:with-param name="form" select="$form" />-->
					<!--</xsl:call-template>-->
				<!--</label>-->
				<!--<input type="text" id="telefax" name="form[request_user_telefax]" value="{$form/form/request_user_telefax}" class="inputtext inputtext-telefax" tabindex="7" />-->
			<!--</div>-->
			<div class="cst-request-item cst-request-item-mobile">
				<xsl:call-template name="form-element-required-attribute">
					<xsl:with-param name="field">request_user_mobile_number</xsl:with-param>
					<xsl:with-param name="class">mobile</xsl:with-param>
					<xsl:with-param name="form" select="$form" />
				</xsl:call-template>
				<!--<label for="mobile">
					[%txt.mobile.number]
					<xsl:call-template name="form-element-required">
						<xsl:with-param name="field">request_user_mobile_number</xsl:with-param>
						<xsl:with-param name="form" select="$form" />
					</xsl:call-template>
				</label>-->
				<input type="text" id="mobile" name="form[request_user_mobile_number]" value="{$form/form/request_user_mobile_number}" class="inputtext inputtext-telefax" tabindex="8" placeholder="[%txt.mobile.number]"/>
			</div>
			<span class="cst-request-required-hint">* [%txt.field.required]</span>
		</fieldset>
	</xsl:template>

	<xsl:template name="request-form-children-boxes-moargut">
		<xsl:param name="count">0</xsl:param>
		<xsl:param name="max">0</xsl:param>
		<xsl:param name="names" select="false()" />
		<xsl:if test="$count &lt; $max">
			<xsl:variable name="children_id" select="generate-id()"></xsl:variable>
			<xsl:variable name="box_id" >request-form-children-boxes-<xsl:value-of select="$count + 1" />-<xsl:value-of select="$children_id" /></xsl:variable>
			<xsl:variable name="box_id_follow" >request-form-children-boxes-<xsl:value-of select="$count + 2" />-<xsl:value-of select="$children_id" /></xsl:variable>
			<div class="request-form-children-boxes request-form-children-boxes-{$count + 1}" id="{$box_id}">
				<input type="hidden" id="form[rc_age][{$count}][rc_age]" name="form[rc_age][{$count}][rc_age]" value="" class="child-age{$count}"/>
				<!--<label for="form[rc_age][{$count}][rc_age]">
				<select class="request-form-children-age" id="form[rc_age][{$count}][rc_age]" name="form[rc_age][{$count}][rc_age]">
					<option value="-">[%txt.child] ([%txt.age])</option>
					<option value="0">0</option>
					<option value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
					<option value="4">4</option>
					<option value="5">5</option>
					<option value="6">6</option>
					<option value="7">7</option>
					<option value="8">8</option>
					<option value="9">9</option>
					<option value="10">10</option>
					<option value="11">11</option>
					<option value="12">12</option>
					<option value="13">13</option>
					<option value="14">14</option>
					<option value="15">15</option>
					<option value="16">16</option>
					<option value="17">17</option>
					<option value="18">18</option>
				</select>
				</label>-->
				<xsl:if test="$names">
					<label class="request-form-children-name">
						<!--<span>[%txt.name]</span>-->
						<input name="form[rc_age][{$count}][rc_name]" value="{form/rc_age/*[$count + 1]/rc_name}" type="text" placeholder="[%txt.name]"/>
					</label>
				</xsl:if>
				<xsl:if test="$count +1 &lt; $max">
					<a class="cst-request-add cst-request-child-link-{$count + 1}" href="#">[%txt.add.icon][%txt.more.children.add]</a>
					<script>
						$(function() {
						jQuery( '.cst-request-child-link-<xsl:value-of select="$count + 1" />', $('#<xsl:value-of select="$box_id" />') ).click( function() {
							if($(this).hasClass('open')) {
							$('.child-age<xsl:value-of select="$count+1" />').val('');
							} else {
								$('.child-age<xsl:value-of select="$count+1" />').val(0);
							};
							$(this).contentToggle( '[%txt.add.icon][%txt.more.children.add]|[%txt.del.icon][%txt.more.children.del]', '#<xsl:value-of select="$box_id_follow" />' );
							return false;
						});
						});
					</script>
				</xsl:if>
			</div>

			<xsl:call-template name="request-form-children-boxes-moargut">
				<xsl:with-param name="max" select="$max" />
				<xsl:with-param name="names" select="$names" />
				<xsl:with-param name="count" select="$count + 1" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="custom-cst-request-travelling-persons">
		<xsl:variable name="form" select="."/>
		<script type="text/javascript">_lib_load( 'vct' );</script>
		<fieldset class="cst-request-travelling-persons">
			<legend>
				[%txt.persons]
			</legend>
			<div class="cst-request-item cst-request-item-adults">
				<xsl:call-template name="form-element-required-attribute">
					<xsl:with-param name="field">request_adults</xsl:with-param>
					<xsl:with-param name="class">adults</xsl:with-param>
					<xsl:with-param name="form" select="$form" />
				</xsl:call-template>
				<label for="adults">
					[%request.count.adults]
					<xsl:call-template name="form-element-required">
						<xsl:with-param name="field">request_adults</xsl:with-param>
						<xsl:with-param name="form" select="$form" />
					</xsl:call-template>
				</label>
				<select id="adults" name="form[request_adults]">
					<xsl:call-template name="range">
						<xsl:with-param name="start">1</xsl:with-param>
						<xsl:with-param name="stop" select="settings/config-request-adult-count-max" />
						<xsl:with-param name="default">--</xsl:with-param>
						<xsl:with-param name="selected" select="form/request_adults" />
					</xsl:call-template>
				</select>
			</div>
			<xsl:if test="settings/config-search-num-children-boxes &gt; 0">
				<xsl:variable name="children_box_id" select="generate-id()"/>
				<div class="cst-request-item cst-request-item-add-children">
					<a class="cst-request-add cst-request-add-child" href="#">[%txt.add.icon][%txt.children.children.add]</a>
					<script>
						$(function() {
							jQuery( '.cst-request-add-child' ).click( function() {
								$(this).contentToggle( '[%txt.add.icon][%txt.children.children.add]|[%txt.del.icon][%txt.children.children.del]', '#<xsl:value-of select="$children_box_id" />' );
								return false;
							});
						});
					</script>
				</div>
				<div class="cst-request-item cst-request-item-child" id="{$children_box_id}">
					<xsl:if test="count(form/rc_age/*/rc_age[not(.='-')]) &gt; 0">
						<xsl:attribute name="class">cst-request-item cst-request-item-child cst-request-item-child-prefilled</xsl:attribute>
					</xsl:if>
					[%request.age.of.child]
					<xsl:call-template name="request-form-children-boxes">
						<xsl:with-param name="max"><xsl:value-of select="settings/config-search-num-children-boxes" /></xsl:with-param>
						<xsl:with-param name="names" select="settings/config-request-children-names = 'true'" />
					</xsl:call-template>
				</div>
			</xsl:if>
		</fieldset>
	</xsl:template>

	<xsl:template name="custom-cst-request-travelling-date">
		<xsl:param name="title">[%txt.travellingdata]</xsl:param>
		<xsl:param name="title_alt">[%txt.travellingdata.alternative]</xsl:param>
		<xsl:param name="field_name_from">[%txt.arrival]</xsl:param>
		<xsl:param name="field_name_to">[%txt.departure]</xsl:param>
		<xsl:variable name="form" select="."/>
		<script type="text/javascript">_lib_load( 'vct' );</script>

		<xsl:variable name="rd_id" select="generate-id()" />
		<fieldset class="cst-request-travelling-data">
			<legend>
				<xsl:value-of select="$title" />
			</legend>
			<div class="cst-request-item cst-request-item-arrival">
				<xsl:call-template name="form-element-required-attribute">
					<xsl:with-param name="field">rd_from1</xsl:with-param>
					<xsl:with-param name="class">arrival</xsl:with-param>
					<xsl:with-param name="form" select="$form" />
				</xsl:call-template>
				<!--<label for="form_rd_from1_{$rd_id}">
					<xsl:value-of select="$field_name_from" />&#x00A0;&lt;!&ndash; ([%date.format.input])  &ndash;&gt;
					<xsl:call-template name="form-element-required">
						<xsl:with-param name="field">rd_from1</xsl:with-param>
						<xsl:with-param name="form" select="$form" />
					</xsl:call-template>
				</label>-->
				<div class="date-icon">
					<input type="text" id="form_rd_from1_{$rd_id}" name="form[rd_from1]" value="{form/rd_from1}" class="inputtext inputtext-arrival" placeholder="{$field_name_from}" />
				</div>
					<xsl:apply-templates select="/site:site/site:match-space/calendar/jquery">
						<xsl:with-param name="obj_id">form_rd_from1_<xsl:value-of select="$rd_id" /></xsl:with-param>
						<xsl:with-param name="obj_range_end">form_rd_to1_<xsl:value-of select="$rd_id" /></xsl:with-param>
						<xsl:with-param name="form" select="$form" />
					</xsl:apply-templates>
			</div>
			<div class="cst-request-item cst-request-item-departure">
				<xsl:call-template name="form-element-required-attribute">
					<xsl:with-param name="field">rd_from1</xsl:with-param>
					<xsl:with-param name="class">departure</xsl:with-param>
					<xsl:with-param name="form" select="$form" />
				</xsl:call-template>
				<!--<label for="form_rd_to1_{$rd_id}">
					<xsl:value-of select="$field_name_to" />&#x00A0;&lt;!&ndash; ([%date.format.input]) &ndash;&gt;
					<xsl:call-template name="form-element-required">
						<xsl:with-param name="field">rd_from1</xsl:with-param>
						<xsl:with-param name="form" select="$form" />
					</xsl:call-template>
				</label>-->
				<div class="date-icon">
					<input type="text" id="form_rd_to1_{$rd_id}" name="form[rd_to1]" value="{form/rd_to1}" class="inputtext inputtext-arrival" placeholder="{$field_name_to}"/>
				</div>
				<xsl:apply-templates select="/site:site/site:match-space/calendar/jquery">
					<xsl:with-param name="obj_id">form_rd_to1_<xsl:value-of select="$rd_id" /></xsl:with-param>
					<xsl:with-param name="obj_range_start">form_rd_from1_<xsl:value-of select="$rd_id" /></xsl:with-param>
					<xsl:with-param name="form" select="$form" />
				</xsl:apply-templates>
			</div>
			<!--<div class="cst-request-item cst-request-item-add-alternative-date">
				<a class="cst-request-add cst-request-add-alt-date" href="#">[%txt.add.icon][%txt.alternative.date.add]</a>
				<script type="text/javascript">
					jQuery( function( $ ) {
					$( '.cst-request-add-alt-date' ).click( function( ev ) {
					ev.preventDefault();
					$(this).contentToggle( '[%txt.add.icon][%txt.alternative.date.add]|[%txt.del.icon][%txt.alternative.date.del]', '.cst-request-travelling-data-alternate');
					});
					});
				</script>
			</div>-->
		</fieldset>
		<!--<fieldset class="cst-request-travelling-data-alternate">
			<legend>
				<xsl:value-of select="$title_alt" />
			</legend>
			<div class="cst-request-item cst-request-alternatedate" id="cst-request-alternatedate">
				<div class="cst-request-item cst-request-item-arrival-alternative">
					<xsl:call-template name="form-element-required-attribute">
						<xsl:with-param name="field">rd_from2</xsl:with-param>
						<xsl:with-param name="class">arrival-alternative</xsl:with-param>
						<xsl:with-param name="form" select="$form" />
					</xsl:call-template>
					<label for="form_rd_from2">
						<xsl:value-of select="$field_name_from" />&#x00A0;&lt;!&ndash; ([%date.format.input]) &ndash;&gt;
						<xsl:call-template name="form-element-required">
							<xsl:with-param name="field">rd_from2</xsl:with-param>
							<xsl:with-param name="form" select="$form" />
						</xsl:call-template>
					</label>
					<input type="text" id="form_rd_from2" name="form[rd_from2]" value="{form/rd_from2}" class="inputtext inputtext-arrival-alternative"/>
					<xsl:apply-templates select="/site:site/site:match-space/calendar/jquery">
						<xsl:with-param name="obj_id">form_rd_from2</xsl:with-param>
						<xsl:with-param name="obj_range_end">form_rd_to2</xsl:with-param>
						<xsl:with-param name="form" select="$form" />
					</xsl:apply-templates>
				</div>
				<div class="cst-request-item cst-request-item-departure-alternative">
					<xsl:call-template name="form-element-required-attribute">
						<xsl:with-param name="field">rd_to2</xsl:with-param>
						<xsl:with-param name="class">departure</xsl:with-param>
						<xsl:with-param name="form" select="$form" />
					</xsl:call-template>
					<label for="form_rd_to2">
						<xsl:value-of select="$field_name_to" />&#x00A0;&lt;!&ndash; ([%date.format.input]) &ndash;&gt;
						<xsl:call-template name="form-element-required">
							<xsl:with-param name="field">rd_to2</xsl:with-param>
							<xsl:with-param name="form" select="$form" />
						</xsl:call-template>
					</label>
					<input type="text" id="form_rd_to2" name="form[rd_to2]" value="{form/rd_to2}" class="inputtext inputtext-departure-alternative" />
					<xsl:apply-templates select="/site:site/site:match-space/calendar/jquery">
						<xsl:with-param name="obj_id">form_rd_to2</xsl:with-param>
						<xsl:with-param name="obj_range_start">form_rd_from2</xsl:with-param>
					</xsl:apply-templates>
				</div>
			</div>
		</fieldset>-->
	</xsl:template>

	<xsl:template name="custom-cst-request-newsletter-marketing">
		<!--<xsl:param name="form" />-->
		<xsl:if test="count(material/*)&gt;0">
			<xsl:call-template name="custom-cst-request-marketing-hotel">
				<xsl:with-param name="material" select="material" />
				<xsl:with-param name="selected-material" select="form/material" />
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="count(hotels-materials/*/*)&gt;0">
			<fieldset class="cst-request-material">
				<legend>
					[%request.material]
				</legend>
				<div class="cst-request-item cst-request-item-material">
					<xsl:for-each select="hotels-materials/*">
						<xsl:if test="count(./*)&gt;0">
							<div class="cst-hotel-request-material">
								<h3 class="cst cst-request cst-request-request-material-hotel"><xsl:value-of select="../../hotels/*[hotel_id=current()/@hotel]/hotel_name" /></h3>
								<ul class="cst-request-material">
									<xsl:for-each select="./*">
										<li class="cst-request-material-item">
											<input id="request_material_{hrm_id}" class="inputcheckbox inputcheckbox-request-material" type="checkbox" name="form[material][{../@hotel}][{hrm_id}]" value="{hrm_name}">
												<xsl:if test="count(../../../form/material/*/*[name(.)=concat('int-',current()/hrm_id)])&gt;0">
													<xsl:attribute name="checked">checked</xsl:attribute>
												</xsl:if>
											</input>
											<label for="request_material_{hrm_id}"><xsl:value-of select="hrm_name" /></label>

											<xsl:if test="cstc:media-usages/*">
												<span class="cst-request-material-download">
													<xsl:text> (</xsl:text>
													<xsl:for-each select="cstc:media-usages/*">
														<a href="{media_url_deliver}" target="_blank">[%txt.download]</a>
														<xsl:if test="position()!=last()">, </xsl:if>
													</xsl:for-each>
													<xsl:text>)</xsl:text>
												</span>
											</xsl:if>
										</li>
									</xsl:for-each>
								</ul>
							</div>
						</xsl:if>
					</xsl:for-each>
				</div>
			</fieldset>
		</xsl:if>
		<xsl:if test="@newsletter">
			<fieldset class="cst-request-newsletter">
				<legend>
					[%txt.newsletter]
				</legend>
				<div class="cst-request-item cst-request-item-newsletter">
					<input class="inputcheckbox request-newsletter" id="request_newsletter" type="checkbox" name="newsletter_subscribe" value="1">
						<!-- or  -->
						<xsl:if test="@newsletter-auto"><xsl:attribute name="checked" value="checked" /></xsl:if>
					</input>
					<label class="label-request-newsletter" for="request_newsletter">[%txt.newsletter.subscribe]</label>

				</div>
			</fieldset>
		</xsl:if>

		<xsl:if test="marketing-actions/*">
			<xsl:variable name="form" select="."/>
			<fieldset class="cst-request-marketing-actions">
				<legend>
					[%request.referer]
					<xsl:call-template name="form-element-required">
						<xsl:with-param name="field">request_referer</xsl:with-param>
						<xsl:with-param name="form" select="$form" />
					</xsl:call-template>
				</legend>
				<div class="cst-request-item cst-request-item-marketing-action">

					<ul class="cst-request-item-marketing-actions">
						<xsl:for-each select="marketing-actions/*">
							<li class="cst-request-marketing-action">
								<input type="radio" class="inputradio" id="request_marketing_action_{hma_id}" name="form[request_marketing_action]" value="{hma_id}">
									<xsl:if test="hma_id = ../../form/request_marketing_action">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
								<label for="request_marketing_action_{hma_id}"><xsl:value-of select="hma_name" /></label>
							</li>
						</xsl:for-each>
					</ul>
					<span class="cst-request-details">[%txt.other]: &#160;</span>
					<input name="form[request_referer]" class="inputtext inputtext-marketing-details">
						<xsl:attribute name="value">
							<xsl:value-of select="$form/referer" />
						</xsl:attribute>
					</input>
				</div>
			</fieldset>
		</xsl:if>
	</xsl:template>

	<xsl:template name="custom-cst-request-marketing-hotel">
		<xsl:param name="material" />
		<xsl:param name="selected-material" />
		<fieldset class="cst-request-material">
			<legend>
				[%request.material]
			</legend>
			<div class="cst-request-item cst-request-item-material">
				<ul class="cst-request-material">
					<xsl:for-each select="$material/*">
						<li class="cst-request-material-item">
							<input id="request_material_{hrm_id}" class="inputcheckbox inputcheckbox-request-material" type="checkbox" name="form[material][]" value="{hrm_name}">
								<xsl:if test="hrm_name = $selected-material/*">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</input>
							<label for="request_material_{hrm_id}"><xsl:value-of select="hrm_name" /></label>

							<xsl:if test="cstc:media-usages/*">
								<span class="cst-request-material-download">
									<xsl:text> (</xsl:text>
									<xsl:for-each select="cstc:media-usages/*">
										<a href="{media_url_deliver}" target="_blank">[%txt.download]</a>
										<xsl:if test="position()!=last()">, </xsl:if>
									</xsl:for-each>
									<xsl:text>)</xsl:text>
								</span>
							</xsl:if>
						</li>
					</xsl:for-each>
				</ul>
			</div>
		</fieldset>
	</xsl:template>

	<xsl:template name="custom-cst-request-roomtype">
		<xsl:param name="request" />
		<xsl:if test="not($request/remember-items/*/hrt_id) and count($request/roomtype-preference/*)=0 and count($request/hotel-roomtypes/*)&gt;0">
			<fieldset class="cst-request-roomtypes">
				<legend>[%txt.data.roomtypes]</legend>
				<div class="cst-box cst-request-room-types">
					<!--<div class="roomtypes-hint">[%txt.request.roomtypes.hint]</div>-->
					<xsl:for-each select="$request/hotel-roomtypes-groups/*">
						<xsl:sort data-type="number" select="hrg_order" order="ascending" />
						<xsl:variable name="hrg_id" select="hrg_id" />
						<h3 class="cst-request-roomtype-group"><xsl:value-of select="hrg_name" /></h3>
						<ul class="cst-request-roomtype-list">
							<!--<li class="amount-hint">[%txt.amount]</li>-->
							<xsl:for-each select="$request/hotel-roomtypes/*[hrt_group=$hrg_id]">
								<xsl:sort data-type="number" select="hrt_order" order="ascending" />
								<li class="cst-request-roomtype">
									<input type="text" name="form[request-items][hrt][{hrt_id}][amount]" id="request_item_hrt_{hrt_id}"/>
									<label for="request_item_hrt_{hrt_id}"><xsl:value-of select="hrt_name"/></label>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:for-each>
				</div>
			</fieldset>
			<script type="text/javascript">
				_lib_load('jQuery', 'jsoncookie');
			</script>
			<script type="text/javascript">
				$('ul.cst-request-roomtype-list a').click(function(){ return false; })
					$(window).unload(function() {
					var saved_values = {}
					$('ul.cst-request-roomtype-list input').each( function() {
						if( this.value != '' ) {
						saved_values[this.name] = this.value
						}
					});
					$.JSONCookie('roomtype-preference', saved_values, { expires: 1 });
				});

				var saved_values = $.JSONCookie('roomtype-preference');
				$('ul.cst-request-roomtype-list input').each( function() {
					if( saved_values[this.name] ) {
					this.value = saved_values[this.name];
					}
				});
			</script>
		</xsl:if>
	</xsl:template>

	<xsl:template match="site:match-space/form/remember-items" name="custom-remember-items-display">
		<xsl:param name="remember_items" />
		<xsl:param name="table_colspan">1</xsl:param>
		<xsl:param name="remember_image">1</xsl:param>
		<xsl:param name="remember_image_width">50</xsl:param>
		<xsl:param name="remember_image_height">50</xsl:param>
		<xsl:variable name="id" select="generate-id()" />

		<xsl:if test="count($remember_items/*) &gt; 0">
			<script type="text/javascript">_lib_load( 'jQuery', 'vil' );</script>
			<div class="cst-request cst-box cst-request-remember-items">
				<table class="cst-request-remember-items" cellspacing="0" cellpadding="0">
					<tr class="cst-remember-items-header">
						<xsl:if test="$remember_image = 1"><td class="remember-items-img image"><xsl:text> </xsl:text></td></xsl:if>
						<td class="remember-item-name"></td>
						<td class="remember-item-amount amount">[%txt.delete]</td>
					</tr>
					<xsl:for-each select="$remember_items/*">
						<xsl:variable name="request-item-id">
							<xsl:choose>
								<xsl:when test="hpa_id"><xsl:value-of select="hpa_id" /></xsl:when>
								<xsl:when test="hp_id"><xsl:value-of select="hp_id" /></xsl:when>
								<xsl:when test="hrt_id"><xsl:value-of select="hrt_id" /></xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="remember-hotel">
							<xsl:choose>
								<xsl:when test="hpa_hotel"><xsl:value-of select="hpa_hotel" /></xsl:when>
								<xsl:when test="hp_hotel"><xsl:value-of select="hp_hotel" /></xsl:when>
								<xsl:when test="hrt_hotel"><xsl:value-of select="hrt_hotel" /></xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="remember-name">
							<xsl:choose>
								<xsl:when test="hpa_id">
									<xsl:if test="hpa_type='4'"><span class="item-type item-type-voucher">[%txt.voucher]: </span></xsl:if>
									<xsl:variable name="package_name" select="hpa_name"/>
									<xsl:choose>
										<xsl:when test="contains($package_name,'|')">
											<xsl:value-of select="substring-before($package_name,'|')" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$package_name"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:when test="hp_id"><xsl:value-of select="hp_name" /></xsl:when>
								<xsl:when test="hrt_id"><xsl:value-of select="hrt_name" /></xsl:when>
							</xsl:choose>
						</xsl:variable>
						<tr class="cst-remember-items-list">
							<xsl:if test="position() = last()">
								<xsl:attribute name="class">cst-remember-items-list cst-remember-items-list-last</xsl:attribute>
							</xsl:if>
							<xsl:if test="$remember_image = 1">
								<td class="remember-items-img">
									<xsl:variable name="image-url">
										<xsl:choose>
											<xsl:when test="hpa_id"><xsl:value-of select="hpa_image" /></xsl:when>
											<xsl:when test="hp_id"><xsl:value-of select="hp_image" /></xsl:when>
											<xsl:when test="hrt_id"><xsl:value-of select="hrt_image" /></xsl:when>
										</xsl:choose>
									</xsl:variable>
									<xsl:choose>
										<xsl:when test="not( $image-url = 0 )">
											<a href="{$image-url}/1024x0s" class="fancybox" data-fancybox-type="image" data-fancybox-title="{$remember-name}"><img class="cst-image" alt="$remember-name" src="{$image-url}/{$remember_image_width}x{$remember_image_height}s" width="{$remember_image_width}" height="{$remember_image_height}" /></a>
										</xsl:when>
										<xsl:otherwise>
											<ul class="cst-media">
												<xsl:choose>
													<xsl:when test="hpa_id"><img class="remember-item-dummy" src="{/site:site/site:env/site:vars/@base-resources}images/cst_remember_package_dummy.jpg" alt="{$remember-name}" /></xsl:when>
													<xsl:when test="hp_id"><img class="remember-item-dummy" src="{/site:site/site:env/site:vars/@base-resources}images/cst_remember_program_dummy.jpg" alt="{$remember-name}" /></xsl:when>
													<xsl:when test="hrt_id"><img class="remember-item-dummy" src="{/site:site/site:env/site:vars/@base-resources}images/cst_remember_room_dummy.jpg" alt="{$remember-name}" /></xsl:when>
												</xsl:choose>
											</ul>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</xsl:if>
							<td class="remember-item-name remember-item-name-{$request-item-id}">
								<xsl:value-of select="$remember-name" />
							</td>
							<td class="remember-item-amount" id="{type}{$request-item-id}-{$remember-hotel}" rel="{$request-item-id}">
								<xsl:variable name="request-item-type">
									<xsl:choose>
										<xsl:when test="hpa_id">hpa</xsl:when>
										<xsl:when test="hp_id">hp</xsl:when>
										<xsl:when test="hrt_id">hrt</xsl:when>
									</xsl:choose>
								</xsl:variable>
								<input type="hidden" name="form[request-items][{$request-item-type}][{$request-item-id}][amount]" value="{amount}" class="inputtext remember-item-amount" />
							</td>
						</tr>
					</xsl:for-each>
				</table>

				<xsl:variable name="remember-script">
					( function( $ ){
						<xsl:variable name="form_type"><xsl:choose>
							<xsl:when test="count($remember_items/*[hp_id])&gt;0 and count($remember_items/*[hpa_id or hrt_id])=0">6</xsl:when>
							<xsl:otherwise>2</xsl:otherwise>
						</xsl:choose></xsl:variable>
						var form_url = ([
							document.location.protocol,
							'//',
							document.location.hostname,
							document.location.pathname,
							(document.location.pathname.indexOf( 'request.php' )==-1?'request.php':''),
							'?page=<xsl:value-of select="$form_type" />.page1&amp;hotel=<xsl:value-of select="/site:site/site:config/@hotel" />']).join('');
						var form_url_items = form_url;
						<xsl:for-each select="$remember_items/*">
							<xsl:variable name="request-item-type">
								<xsl:choose>
									<xsl:when test="hpa_id">hpa</xsl:when>
									<xsl:when test="hp_id">hp</xsl:when>
									<xsl:when test="hrt_id">hrt</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="request-item-id">
								<xsl:choose>
									<xsl:when test="hpa_id"><xsl:value-of select="hpa_id" /></xsl:when>
									<xsl:when test="hp_id"><xsl:value-of select="hp_id" /></xsl:when>
									<xsl:when test="hrt_id"><xsl:value-of select="hrt_id" /></xsl:when>
								</xsl:choose>
							</xsl:variable>

							form_url_items += '&amp;remember%5B<xsl:value-of select="$request-item-type" />%5D=<xsl:value-of select="$request-item-id" />';
						</xsl:for-each>
						form_url = form_url.replace(/amp;/g,'');
						var share_links = $('#remember_share_<xsl:value-of select="$id" />').find('.remember-share-link');
						share_links.on( 'click.bitly', function( ev ){
							ev.preventDefault();
							var link = $(this);
							link.addClass('loading');
							$.getJSON('http://api.bitly.com/v3/shorten?callback=?',
								{
									format: "json",
									apiKey: "R_b1636e350b3f4e568fdc702e889d2737",
									login: "mtgvioma",
									longUrl: form_url_items
								},
								function( response ) {
									var short_url = encodeURIComponent( response.status_code == 200 ? response.data.url : form_url_items );
									var share_links_contents = {
										'email': 'mailto:?body=[%custom.share.spa.message]'+short_url,
										'whatsapp': 'whatsapp://send?text=[%custom.share.spa.message]'+short_url,
										'fb': 'http://www.facebook.com/dialog/send?app_id=1540498789593564&amp;link='+short_url+'&amp;redirect_uri='+form_url
									};
									share_links.off('click.bitly').each( function( i, el ){
										el.href = share_links_contents[ $(el).attr('data-type') ].replace(/amp;/g,'');
									} );
									link.removeClass('loading');
									document.location.href = link[0].href;
								}
							);
						} );

						$('input.remember-item-amount').each( function() {
							var $remove_link = $( document.createElement('a') ).attr('href','#remove').addClass('remember-item-remove-link');
							$remove_link.insertAfter( this );
							$remove_link.click( function( ev ) {
								ev.preventDefault();
								if( typeof cst_remember == 'function' ){
									var parent_rel = $(this).parent().attr('id');
									var splited_rel = parent_rel.split('-');
									cst_remember.group_item_delete( splited_rel[1], splited_rel[0] );
								}
								var remember_container = $(this).closest('table.cst-request-remember-items');
								$.ajax({
									type: "GET",
									url: document.location.pathname + '?rem_item_clear=' + $(this).parent().attr('rel'),
									complete: function(){
										window.nst2015.req_items_amount_change({target:remember_container.get(0)});
									}
								});
								$(this).closest('tr').remove();
								if( !remember_container.find( 'tr.cst-remember-items-list' ).length ){
									remember_container.hide();
								}
							} );
						} );
					} )( jQuery );
				</xsl:variable>
				<script type="text/javascript"><xsl:value-of select="normalize-space($remember-script)" /></script>
				<!--<style type="text/css">header .gal .slide{max-height: 50vh}</style>-->
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="cstc:user-request-spa-add[@page=1]">
		<xsl:variable name="form" select="." />
		<!--Kinder einfügen-->
		<form method="post" action="{$_self}?page=6.page2&amp;hotel_id={@hotel_id}" name="form" id="cst-request-form">
			<div class="cst-request cst-request-type-6">
				<xsl:apply-templates select="/site:site/site:match-space/site-headline">
					<xsl:with-param name="type">1</xsl:with-param>
					<xsl:with-param name="title">[%request.spa]</xsl:with-param>
					<xsl:with-param name="class">cst cst-request</xsl:with-param>
				</xsl:apply-templates>

				<div class="cst-request-note">[%txt.request.6.sendhotel]</div>

				<xsl:if test="count(errors/*) &gt; 0">
					<xsl:call-template name="cstc:errors">
						<xsl:with-param name="errors" select="errors" />
					</xsl:call-template>
				</xsl:if>

				<xsl:if test="remember-items/*">
					<xsl:apply-templates select="/site:site/site:match-space/form/remember-items">
						<xsl:with-param name="remember_items" select="remember-items" />
					</xsl:apply-templates>
				</xsl:if>

				<div class="cst-box cst-request-trip-infos">
					<xsl:call-template name="custom-cst-request-travelling-date" />
					<!--<span class="cst-request-required-hint">* [%txt.field.required]</span>-->
				</div>

				<div class="cst-box cst-request-user-data">
					<xsl:apply-templates select="/site:site/site:match-space/form/user-data">
						<xsl:with-param name="form" select="." />
					</xsl:apply-templates>
				</div>
				<!--<xsl:apply-templates select="/site:site/site:match-space/site-headline">-->
					<!--<xsl:with-param name="type">3</xsl:with-param>-->
					<!--<xsl:with-param name="title">[%vri.request.wishes.header]</xsl:with-param>-->
					<!--<xsl:with-param name="class">cst cst-request cst-request-wishes</xsl:with-param>-->
				<!--</xsl:apply-templates>-->
				<div class="cst-box cst-request-wishes">
					<fieldset>
						<legend>[%vri.request.wishes.header]</legend>
						<textarea rows="7" cols="40" name="form[request_wishes]">
							<xsl:value-of select="form/request_wishes" />
						</textarea>
					</fieldset>
				</div>
				<!-- spam protection dummy request_detail_text -->
				<div class="cst-request-detail-text">
					<input name="form[request_detail_text]" value="" />
				</div>
				<div class="cst-request cst-request-submit">
					<input class="inputbutton" type="submit" value="[%txt.commit]" id="sbutton" />
				</div>
			</div>
		</form>
		<xsl:call-template name="user-request-form-script" />
		<xsl:apply-templates select="track-element-form-view" />
	</xsl:template>

	<xsl:template name="remember-items-show">
		<xsl:param name="amount"/>
		<xsl:param name="count"/>
		<xsl:param name="name"/>
		<xsl:param name="id"/>
		<xsl:param name="persons"/>
		<xsl:if test="$count &lt; $amount">
			<xsl:if test="$count = 0">
				<legend>
					<xsl:value-of select="$name"/>
				</legend>
			</xsl:if>

			<div id="remember-item-{$id}" class="cst-remember-item">
				<xsl:if test="position() = last()">
					<xsl:attribute name="class">cst-remember-item cst-remember-items-list-last</xsl:attribute>
				</xsl:if>
				<div class="person-select-container">
					<div class="remember-selectable_persons" rel="item-{$id}">
						<label>[%txt.request.person.choose]</label>
						<select name="form[data][person][1][value][person_item][{$id}][value][item_count][{$count}][value]" id="item-{$id}">
							<xsl:variable name="onchange_event">
								(function(select,spa_req_person){
									$(select).closest('.person-select-container').find('input,select').each(
									function(i,el){
										el.name=el.name.replace(/\[person\]\[[\d]+\]/,'[person]['+spa_req_person+']');
									}
								);
								})(this,this.options[this.selectedIndex].value);</xsl:variable>
							<xsl:attribute name="onchange"><xsl:value-of select="normalize-space($onchange_event)" /></xsl:attribute>
							<xsl:call-template name="remember-items-persons">
								<xsl:with-param name="amount" select="$persons"/>
								<xsl:with-param name="count">0</xsl:with-param>
								<xsl:with-param name="item_count" select="$count"/>
								<xsl:with-param name="id" select="$id"/>
							</xsl:call-template>
						</select>
					</div>
					<div class="remember-weekday">
						<label>[%txt.request.program.custom.weekday]</label>
						<select id="week-{$id}" class="remember-weekday-select" name="form[data][person][1][value][person_item][{$id}][value][item_count][{$count}][value][day][value]">
							<option id="week-{$id}-1" value="Montag">[%date.day.01]</option>
							<option id="week-{$id}-2" value="Dienstag">[%date.day.02]</option>
							<option id="week-{$id}-3" value="Mittwoch">[%date.day.03]</option>
							<option id="week-{$id}-4" value="Donnerstag">[%date.day.04]</option>
							<option id="week-{$id}-5" value="Freitag">[%date.day.05]</option>
							<option id="week-{$id}-6" value="Samstag">[%date.day.06]</option>
							<option id="week-{$id}-7" value="Sonntag">[%date.day.07]</option>
						</select>
					</div>
					<div class="remember-timestamp">
						<label>[%txt.request.program.custom.when]</label>
						<select id="time-{$id}" class="remember-timestamp-select" name="form[data][person][1][value][person_item][{$id}][value][item_count][{$count}][value][time][value]">
							<option id="time-{$id}-1" value="vormittag">[%txt.request.program.custom.am]</option>
							<option id="time-{$id}-2" value="nachmittag">[%txt.request.program.custom.pm]</option>
						</select>
					</div>
					<input class="remember-program-name" type="hidden" name="form[data][person][1][value][person_item][{$id}][display_str]" value="{$name}"/>
				</div>
				<div class="clearfix"/>
			</div>
			<xsl:variable name="inc_count" select="$count + 1" />
			<xsl:call-template name="remember-items-show">
				<xsl:with-param name="amount" select="$amount"/>
				<xsl:with-param name="count" select="$inc_count"/>
				<xsl:with-param name="name" select="$name"/>
				<xsl:with-param name="id" select="$id"/>
				<xsl:with-param name="persons" select="$persons"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="remember-items-persons">
		<xsl:param name="amount"/>
		<xsl:param name="count"/>
		<xsl:param name="id"/>
		<xsl:param name="item_count"/>
		<xsl:if test="$count &lt; $amount">
			<option value="{$count+1}" id="{$id}-{$item_count}-{$count+1}">
				<xsl:if test="$count = 0">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="$count + 1"></xsl:value-of>
			</option>
			<xsl:variable name="inc_count" select="$count + 1"></xsl:variable>
			<xsl:call-template name="remember-items-persons">
				<xsl:with-param name="amount" select="$amount"/>
				<xsl:with-param name="count" select="$inc_count"/>
				<xsl:with-param name="id" select="$id"/>
				<xsl:with-param name="item_count" select="$item_count"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="custom-cst-request-travelling-date-compact">
		<xsl:param name="title">[%txt.travellingdata]</xsl:param>
		<xsl:variable name="form" select="."/>
		<script type="text/javascript">_lib_load( 'vct' );</script>
		<fieldset class="cst-request-travelling-data">
			<legend>
				<xsl:value-of select="$title" />
			</legend>
			<div class="cst-request-item cst-request-item-arrival">
				<xsl:call-template name="form-element-required-attribute">
					<xsl:with-param name="field">rd_from1</xsl:with-param>
					<xsl:with-param name="class">arrival</xsl:with-param>
					<xsl:with-param name="form" select="$form" />
				</xsl:call-template>
				<label for="form_rd_from1">
					[%txt.arrival]&#x00A0;<!-- ([%date.format.input])  -->
					<xsl:call-template name="form-element-required">
						<xsl:with-param name="field">rd_from1</xsl:with-param>
						<xsl:with-param name="form" select="$form" />
					</xsl:call-template>
				</label>
				<input type="text" id="form_rd_from1" name="form[rd_from1]" value="{form/rd_from1}" class="inputtext inputtext-arrival" />
				<xsl:apply-templates select="/site:site/site:match-space/calendar/jquery">
					<xsl:with-param name="obj_id">form_rd_from1</xsl:with-param>
					<xsl:with-param name="obj_range_end">form_rd_to1</xsl:with-param>
					<xsl:with-param name="form" select="$form" />
				</xsl:apply-templates>
			</div>
			<div class="cst-request-item cst-request-item-departure">
				<xsl:call-template name="form-element-required-attribute">
					<xsl:with-param name="field">rd_from1</xsl:with-param>
					<xsl:with-param name="class">departure</xsl:with-param>
					<xsl:with-param name="form" select="$form" />
				</xsl:call-template>
				<label for="form_rd_to1">
					[%txt.departure]&#x00A0;<!-- ([%date.format.input]) -->
					<xsl:call-template name="form-element-required">
						<xsl:with-param name="field">rd_from1</xsl:with-param>
						<xsl:with-param name="form" select="$form" />
					</xsl:call-template>
				</label>
				<input type="text" id="form_rd_to1" name="form[rd_to1]" value="{form/rd_to1}" class="inputtext inputtext-arrival" />
				<xsl:apply-templates select="/site:site/site:match-space/calendar/jquery">
					<xsl:with-param name="obj_id">form_rd_to1</xsl:with-param>
					<xsl:with-param name="obj_range_start">form_rd_from1</xsl:with-param>
					<xsl:with-param name="form" select="$form" />
				</xsl:apply-templates>
			</div>
			<div class="cst-request-item cst-request-item-add-alternative-date">
				<a class="cst-request-add cst-request-add-alt-date" href="#">[%txt.add.icon][%txt.alternative.date.add]</a>
				<script>
					$(function() {
					jQuery( '.cst-request-add-alt-date' ).click( function() {
					$(this).contentToggle( '[%txt.add.icon][%txt.alternative.date.add]|[%txt.del.icon][%txt.alternative.date.del]', '#cst-request-alternatedate');
					return false;
					});
					});
				</script>
			</div>
			<div class="cst-request-item cst-request-alternatedate" id="cst-request-alternatedate">
				<div class="cst-request-item cst-request-item-arrival-alternative">
					<xsl:call-template name="form-element-required-attribute">
						<xsl:with-param name="field">rd_from2</xsl:with-param>
						<xsl:with-param name="class">arrival-alternative</xsl:with-param>
						<xsl:with-param name="form" select="$form" />
					</xsl:call-template>
					<label for="form_rd_from2">
						[%txt.arrival]&#x00A0;<!-- ([%date.format.input]) -->
						<xsl:call-template name="form-element-required">
							<xsl:with-param name="field">rd_from2</xsl:with-param>
							<xsl:with-param name="form" select="$form" />
						</xsl:call-template>
					</label>
					<input type="text" id="form_rd_from2" name="form[rd_from2]" value="{form/rd_from2}" class="inputtext inputtext-arrival-alternative"/>
					<xsl:apply-templates select="/site:site/site:match-space/calendar/jquery">
						<xsl:with-param name="obj_id">form_rd_from2</xsl:with-param>
						<xsl:with-param name="obj_range_end">form_rd_to2</xsl:with-param>
						<xsl:with-param name="form" select="$form" />
					</xsl:apply-templates>
				</div>
				<div class="cst-request-item cst-request-item-departure-alternative">
					<xsl:call-template name="form-element-required-attribute">
						<xsl:with-param name="field">rd_to2</xsl:with-param>
						<xsl:with-param name="class">departure</xsl:with-param>
						<xsl:with-param name="form" select="$form" />
					</xsl:call-template>
					<label for="form_rd_to2">
						[%txt.departure]&#x00A0;<!-- ([%date.format.input]) -->
						<xsl:call-template name="form-element-required">
							<xsl:with-param name="field">rd_to2</xsl:with-param>
							<xsl:with-param name="form" select="$form" />
						</xsl:call-template>
					</label>
					<input type="text" id="form_rd_to2" name="form[rd_to2]" value="{form/rd_to2}" class="inputtext inputtext-departure-alternative" />
					<xsl:apply-templates select="/site:site/site:match-space/calendar/jquery">
						<xsl:with-param name="obj_id">form_rd_to2</xsl:with-param>
						<xsl:with-param name="obj_range_start">form_rd_from2</xsl:with-param>
					</xsl:apply-templates>
				</div>
			</div>
		</fieldset>
	</xsl:template>

	<xsl:template name="cstc:user-calendar-jquery-moar" match="site:match-space/calendar/jquery">
		<xsl:param name="obj_id" select="false()" />
		<xsl:param name="obj_range_start" />
		<xsl:param name="obj_range_end" />
		<xsl:param name="date_format">[%date.format.frontend]</xsl:param>

		<script type="text/javascript">
			_lib_load( 'jQuery', 'jQuery-UI' );
		</script>
		<!--
		<link rel="stylesheet" type="text/css" href="{$_base_res}js/datepicker-3.3/ui.datepicker.css?version={$_version_cache}" />
		<script src="{$_base_res}js/jquery-1.2.2/jquery.js" language="JavaScript" />
		<script src="{$_base_res}js/jquery-1.1.3.1/jquery-custom.js" language="JavaScript" />
		<script src="{$_base_res}js/datepicker-3.3/ui.datepicker.js" type="text/javascript" language="JavaScript" />
		 -->
		<xsl:if test="$obj_id">
			<script type="text/javascript">
				jQuery(function(jQuery){
				jQuery('#<xsl:value-of select="$obj_id" />').datepicker({
				minDate: '0',
				beforeShow: function( input ) {
				return cst_datepicker_custom_range(input, '<xsl:value-of select="$obj_id" />','<xsl:value-of select="$obj_range_start" />','<xsl:value-of select="$obj_range_end" />')
				},
				closeText: 'X',
				prevText: '&lt;&lt;',
				nextText: '&gt;&gt;',
				currentText: '[%date.main.today]',
				monthNames: ['[%date.month.calendar.01]','[%date.month.calendar.02]','[%date.month.calendar.03]','[%date.month.calendar.04]','[%date.month.calendar.05]','[%date.month.calendar.06]','[%date.month.calendar.07]','[%date.month.calendar.08]','[%date.month.calendar.09]','[%date.month.calendar.10]','[%date.month.calendar.11]','[%date.month.calendar.12]'],
				monthNamesShort: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
				dayNames: ['[%date.day.07]', '[%date.day.01]', '[%date.day.02]', '[%date.day.03]', '[%date.day.04]', '[%date.day.05]', '[%date.day.06]'],
				dayNamesShort: ['[%date.shortday.07]', '[%date.shortday.01]', '[%date.shortday.02]', '[%date.shortday.03]', '[%date.shortday.04]', '[%date.shortday.05]', '[%date.shortday.06]'],
				dayNamesMin: ['[%date.shortday.07]', '[%date.shortday.01]', '[%date.shortday.02]', '[%date.shortday.03]', '[%date.shortday.04]', '[%date.shortday.05]', '[%date.shortday.06]'],
				dateFormat: '<xsl:value-of select="$date_format" />',
				firstDay: 1,
				isRTL: false
				} );

				});
			</script>
		</xsl:if>
	</xsl:template>

	<xsl:template match="cstc:general-list[@type = 'review']">
		<xsl:choose>
			<xsl:when test="count(*)=0">
				<div class="cst-list cst-list-not-found">
					<xsl:choose>
						<xsl:when test="@type='job'">
							[%generallist.nofound/[%txt.jobs]]
							<a href="javascript:history.back();" class="cst-link cst-link-back">[%txt.back]</a>
						</xsl:when>
						<xsl:otherwise>
							[%generallist.nofound/<xsl:value-of select="@item-name" />/]
							<a href="javascript:history.back();" class="cst-link cst-link-back">[%txt.back]</a>
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div id="review-slider">
					<xsl:for-each select="*">
							<xsl:apply-templates select=".">
								<xsl:with-param name="pos" select="position()"></xsl:with-param>
							</xsl:apply-templates>
					</xsl:for-each>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="cstc:review">
		<div class="cst-teaser cst-review-teaser">
			<xsl:variable name="customer_name">
				<xsl:choose>
					<xsl:when test="string-length( survey/customer_title ) > 0 and string-length( survey/customer_surname ) > 0">
						<xsl:value-of select="survey/customer_title" />&#160;<xsl:value-of select="substring( survey/customer_surname, 1, 1 )" />.
					</xsl:when>
					<xsl:otherwise><xsl:text>[%signet_detail.ratings_guest_rating_label_anonymous] </xsl:text></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<div class="cst-review-teaser-guest">
				<div class="cst-review-teaser-inner">
					<table>
						<tr>
							<td>
								<p class="user_date_review"><xsl:value-of select="$customer_name" /> <xsl:if test="string-length( survey/customer_city ) > 0">[%signet_detail.ratings_guest_rating_label_location_prefix] <xsl:value-of select="substring( survey/customer_city, 1, 1 )" />.&#160;</xsl:if>[%signet_detail.ratings_guest_rating_label_date_prefix] <xsl:value-of select="survey/survey_date_last_format" />:</p>
								&#8222;<xsl:value-of select="survey/survey_answer_text_text" />"
							</td>
							<td class="review-score"><xsl:value-of select="survey/survey_score_score_format" />%</td>
						</tr>
					</table>
				</div>
			</div>
			<xsl:if test="string-length( survey/survey_response_public_text ) > 0">
				<div class="cst-review-teaser-hotel">
					<div class="cst-review-teaser-inner">
						<table>
							<tr>
								<td>
									 <p>[%signet_detail.ratings.hotel.answer] [%signet_detail.ratings_guest_rating_label_date_prefix] <xsl:value-of select="survey/survey_response_public_date_format" />:</p>
									&#8222;<xsl:value-of select="survey/survey_response_public_text" />"
								</td>
							</tr>
						</table>
					</div>
				</div>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="cstc:indicator-list">
		match
	</xsl:template>
</xsl:stylesheet>