<?xml version = "1.0" encoding = "UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:site="http://xmlns.webmaking.ms/site/" xmlns:cstc="http://xmlns.webmaking.ms/cstc/" xmlns:exslt="http://exslt.org/common" exclude-result-prefixes="site cstc">
		
	<xsl:template match="cstc:site">
		<div class="cst">
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<xsl:template match="cstc:general-list[@type='package']">
		<xsl:variable name="id" select="generate-id()" />
		<xsl:variable name="package-start" select="/site:site/cstc:frame/@layout='start'" />
		<xsl:variable name="package-count" select="count( * )" />
		<xsl:variable name="package-classes">
			<xsl:choose>
				<xsl:when test="$package-start and $package-count &gt; 4">package-list-4</xsl:when>
				<xsl:otherwise>package-list-<xsl:value-of select="$package-count" /></xsl:otherwise>
			</xsl:choose>
			<xsl:if test="not( $package-start )"> package-list-normal</xsl:if>
			<xsl:if test="$package-start"> package-list-start</xsl:if>
		</xsl:variable>
		<xsl:variable name="criterias-str" select="concat(',',@item-indicator,',')" />
		<xsl:variable name="criterias" select="../cstc:general-list-criterias" />
		<xsl:variable name="criteria-date-from"><xsl:if test="string-length($criterias/date_from)&gt;0"><xsl:value-of select="concat( substring($criterias/date_from,9,2), '.', substring($criterias/date_from,6,2), '.', substring($criterias/date_from,1,4) )" /></xsl:if></xsl:variable>
		<!--<xsl:variable name="criteria-date-to"><xsl:if test="string-length($criterias/date_to)&gt;0"><xsl:value-of select="concat( substring($criterias/date_to,9,2), '.', substring($criterias/date_to,6,2), '.', substring($criterias/date_to,1,4) )" /></xsl:if></xsl:variable>-->
		<div class="schwarz-packages" id="schwarz_packages_{$id}">
			<xsl:if test="not($package-start) and /site:site/site:cms/content-attribute[@name='layout']/@value = 'indikator-filter'">
				<xsl:variable name="list-filter-indicators" select="../cstc:general-sidebar//ids_package_indicators/*[number( normalize-space(coi_teaser_str) ) &gt; 0 or contains($criterias-str,concat(',',coi_id,','))]" />
				<div class="schwarz-list-filter">
					<form action="package-list.php" method="get">
						<!--<label class="list-filter-date">
							<input class="list-filter-date-field" type="text" name="c[date_from]" aria-haspopup="true" id="list_filter_dp_{$id}" value="{$criteria-date-from}" placeholder="[%txt.arrival]" data-id="schwarz_packages_{$id}"/>
							<input class="list-filter-date-hidden" type="hidden" name="c[date_to]" id="package_filter_date_to_{$id}" value="$criteria-date-to" />
						</label>-->
						<fieldset class="list-filter-indicators">
							<xsl:for-each select="$list-filter-indicators">
								<xsl:sort select="normalize-space(coi_teaser_str)" order="ascending" data-type="number"/>
								<xsl:variable name="coi_id" select="coi_id"/>
								<label class="list-filter-indicator">
									<input type="checkbox" class="coi-checkbox" name="c[ids_package_indicators][{coi_id}]" value="{coi_id}" data-id="schwarz_packages_{$id}">
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
						<input type="hidden" name="type" value="{@item-type}"/>
						<noscript>
							<input type="submit" name="submit_button" value="Submit"/>
						</noscript>
					</form>
				</div>
				<xsl:variable name="filter-js">
					if(typeof jQuery.fn.datepicker=='function'){
						$('#list_filter_dp_<xsl:value-of select="$id" />').datepicker({
							onSelect: function( dateText, inst ) {
								$('#package_filter_date_to_<xsl:value-of select="$id" />').val( nst2015.date_convert( dateText, 'dmy', 'dmy', 8 ) );
								nst2015.remote_list_loader({'target':inst.input});
							},
						});
					}
					jQuery('input.coi-checkbox').bind('change', nst2015.remote_list_loader );
				</xsl:variable>
				<script type="text/javascript"><xsl:value-of select="normalize-space($filter-js)" /></script>
			</xsl:if>

			<div class="schwarz-package-list schwarz-list-filter-ajax {$package-classes}" id="schwarz_hpa_container_{$id}">
				<xsl:choose>
					<xsl:when test="$package-start">
						<xsl:apply-templates select="*[position() &lt;= 4]" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="*" />
					</xsl:otherwise>
				</xsl:choose>
			</div>
			<xsl:if test="$package-start and (*[5] or not(*[1]))">
				<p class="center">
					<a class="cta" href="package-list.php?type=1&amp;c[ids_package_indicators][]={@item-indicator}">
						<xsl:if test="not(*[1])">
							<xsl:attribute name="href">package-list.php?type=1</xsl:attribute>
						</xsl:if>
						<xsl:text>[%search.results.packages.more]</xsl:text>
					</a>
				</p>
			</xsl:if>
		</div>

	</xsl:template>

	<xsl:template match="cstc:package-teaser[@type=1 or @type=2]">
		<div class="schwarz-package-teaser schwarz-remote-list-item" style="background-image: url('{package/hpa_image}/960x640s');">
			<xsl:if test="@type=2">
				<xsl:attribute name="class">schwarz-package-teaser schwarz-package-last-minute-teaser schwarz-remote-list-item</xsl:attribute>
			</xsl:if>
			<a href="{@url}" class="schwarz-package-teaser-infos">
				<h2 class="schwarz-package-teaser-name"><xsl:choose>
					<xsl:when test="package/custom-elements/variant-grouping/name"><xsl:value-of select="package/custom-elements/variant-grouping/name" /></xsl:when>
					<xsl:when test="contains(package/hpa_name,'|')"><xsl:value-of select="substring-before(package/hpa_name,'|')" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="package/hpa_name" /></xsl:otherwise>
				</xsl:choose></h2>
				<div class="schwarz-package-teaser-stays">
					<span class=""><xsl:value-of select="package/hpa_stays" /></span>
					<xsl:text> </xsl:text>
					[%txt.stays.numerus/<xsl:value-of select="package/hpa_stays" />]
				</div>
				<!-- last minute pauschalen oder pauschalen mit restplaztbörse indikator (24840) und festem zeitraum -->
				<xsl:if test="( @type=2 or ../@item-indicator=24840 ) and count(package/tf-avail/*) &gt; 0 and (package/tf-avail/*/ht_to_display != '0000-00-00')">
					<ul class="cst-timeframes">
						<xsl:if test="count(package/tf-avail/*) &gt; 3">
							<xsl:attribute name="class">cst-timeframes cols</xsl:attribute>
						</xsl:if>
						<xsl:for-each select="package/tf-avail/*">
							<xsl:sort select="ht_from_ts" order="ascending"/>
							<li class="cst-timeframe">
								<xsl:if test="position()=last()">
									<xsl:attribute name="class">cst-timeframe cst-timeframe-left cst-timeframe-left-last</xsl:attribute>
								</xsl:if>
								<span class="cst-timeframe-from">
									<xsl:value-of select="./ht_from_display"/>
								</span>
								<span class="cst-binder">-</span>
								<span class="cst-timeframe-to">
									<xsl:value-of select="./ht_to_display"/>
								</span>
							</li>
						</xsl:for-each>
					</ul>
				</xsl:if>
			</a>
			<a href="{@url}" class="schwarz-package-teaser-price">
				<xsl:call-template name="cstc:package-price-teaser-schwarz"/>
			</a>
			<ul class="schwarz-package-teaser-buttons">
				<li><a href="{@url}">[%txt.details]</a></li>
				<xsl:choose>
					<xsl:when test="@service-booking = 'yes' and package/hpa_bookable = 1"><li><a href="{@url-booking}">[%txt.availability]</a></li></xsl:when>
					<xsl:otherwise><li><a href="{@url-request}">[%txt.request]</a></li></xsl:otherwise>
				</xsl:choose>
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="cstc:roomtype-list">
		<xsl:variable name="id" select="generate-id()" />

		<xsl:if test="count( roomtype-groups/roomtype-group ) &gt; 1">
			<ul id="hrg_toggle_{$id}" class="hrg-toggle">
				<xsl:for-each select="roomtype-groups/roomtype-group">
					<li data-hrg="{@group-id}"><xsl:value-of select="@group-name" /></li>
				</xsl:for-each>
			</ul>
			<xsl:variable name="hrg-toggle-js">
				( function( $, me ) {
					if( me ) {
						me.hrg_toggle('<xsl:value-of select="$id" />');
						$.each( me.opt.page_theme_cookie, function(k,v){
							if( k.indexOf( 'hrt.' ) == 0 ) {
								var hrt_data = k.split('.');
								$('.tile-roomtype-' + hrt_data[2] ).addClass('visited');
							}
						} );
					}
				} )( jQuery, nst2015 );
			</xsl:variable>
			<script type="text/javascript"><xsl:value-of select="normalize-space($hrg-toggle-js)" /></script>
		</xsl:if>
		<xsl:apply-templates select="cstc:revenue-navigator-search" />
		<div class="cst-list-tiles cst-roomtype-list-tiles cf">
			<xsl:for-each select="roomtype-groups/roomtype-group/roomtypes/*">
				<div class="tile tile-roomtype tile-hrg-{room-type/hrt_group} tile-roomtype-{room-type/hrt_id} tile-{$id}">
					<xsl:apply-templates select="." />
				</div>
			</xsl:for-each>
		</div>
		<xsl:variable name="hrt_image_css">
			<xsl:for-each select="roomtype-groups/roomtype-group/roomtypes/*[room-type/hrt_image != 0]">
				.tile-roomtype-<xsl:value-of select="room-type/hrt_id" /> { background-image: url('<xsl:value-of select="room-type/hrt_image"/>/640x400s'); }
			</xsl:for-each>
		</xsl:variable>
		<style type="text/css"><xsl:value-of select="normalize-space($hrt_image_css)" /></style>
	</xsl:template>

	<xsl:template match="cstc:roomtype-list/roomtype-groups/roomtype-group/roomtypes/*">
		<!-- Tagespreise So-Mi -->
		<xsl:variable name="seasons-midweek-dayprice" select="prices/season-groups/season-group/seasons/season[@key-short='71-0-0']" />
		<xsl:variable name="hrt-price-from"><xsl:choose>
			<xsl:when test="$seasons-midweek-dayprice[1]">
				<xsl:for-each select="$seasons-midweek-dayprice">
					<xsl:sort select="../../@price-int" order="ascending" data-type="number" />
					<xsl:if test="position()=1">
						<xsl:value-of select="../../@price" />
					</xsl:if>
				</xsl:for-each></xsl:when>
			<xsl:when test="room-type/hrt_price_from_int &gt; 0"><xsl:value-of select="room-type/hrt_price_from" /></xsl:when>
			<xsl:when test="prices/price-min-int &gt; 0"><xsl:value-of select="prices/price-min" /></xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose></xsl:variable>
		<a href="{@url}" class="tile-text">
			<h3>
				<xsl:value-of select="room-type/hrt_name"/>
			</h3>
			<xsl:if test="$hrt-price-from != 0">
				<div class="roomtype-price-from">
					<span class="roomtype-from">[%txt.from]</span>
					<xsl:text> </xsl:text>
					<span class="roomtype-price"><xsl:value-of select="$hrt-price-from" /></span>
					<xsl:text> </xsl:text>
					<xsl:choose>
						<xsl:when test="room-type/hrt_price_type = 2">[%txt.perroom]</xsl:when>
						<xsl:otherwise>[%txt.perperson]</xsl:otherwise>
					</xsl:choose>
				</div>
			</xsl:if>
		</a>
		<div class="roomtype-vrn">
			<xsl:apply-templates select="cstc:revenue-navigator" />
		</div>
		<div class="roomtype-links">
			<a href="{@url}">[%txt.detail]</a>
			<a href="{@url-request}">[%txt.request]</a>
			<a href="{@url-booking}">[%txt.book]</a>
		</div>
	</xsl:template>

	<xsl:template name="hrt_alloc">
		<xsl:param name="hrt_alloc_min">0</xsl:param>
		<xsl:param name="hrt_alloc_max">0</xsl:param>
		<xsl:param name="hrt_alloc_max_childs">0</xsl:param>
		<xsl:param name="txt_person"><xsl:choose>
			<xsl:when test="$hrt_alloc_max = 1">[%txt.adult]</xsl:when>
			<xsl:otherwise>[%txt.adults.numerus/<xsl:value-of select="$hrt_alloc_max" />]</xsl:otherwise>
		</xsl:choose></xsl:param>

		<xsl:choose>
			<xsl:when test="$hrt_alloc_min != 0 and $hrt_alloc_max = $hrt_alloc_min">
				<xsl:value-of select="$hrt_alloc_min" /><xsl:text> </xsl:text><xsl:value-of select="$txt_person" />
			</xsl:when>
			<xsl:when test="$hrt_alloc_min != 0 and $hrt_alloc_max != 0">
				<xsl:value-of select="$hrt_alloc_min" />-<xsl:value-of select="$hrt_alloc_max" /><xsl:text> </xsl:text><xsl:value-of select="$txt_person" />
			</xsl:when>
			<xsl:when test="$hrt_alloc_min = 0 and $hrt_alloc_max != 0">
				[%txt.until] <xsl:value-of select="$hrt_alloc_max" /><xsl:text> </xsl:text><xsl:value-of select="$txt_person" />
			</xsl:when>
			<xsl:when test="$hrt_alloc_min != 0 and $hrt_alloc_max = 0">
				[%txt.from] <xsl:value-of select="$hrt_alloc_max" /><xsl:text> </xsl:text><xsl:value-of select="$txt_person" />
			</xsl:when>
		</xsl:choose>
		<xsl:if test="$hrt_alloc_max_childs &gt; 0">
				[%txt.and] [%txt.up.to] <xsl:value-of select="$hrt_alloc_max_childs" /> [%txt.children.numerus/<xsl:value-of select="$hrt_alloc_max_childs" />]
		</xsl:if>
	</xsl:template>

	<xsl:template match="cstc:roomtype-detail">
		<xsl:variable name="roomtype" select="." />
		<xsl:variable name="hrt_media" select="cstc:media-usages/*[@usage-type='image' or @usage-type='panorama' or @usage-type='embed' or @usage-type='plan']" />
		<xsl:variable name="hrt_media_head" select="$hrt_media[not(@usage-type='plan')]" />

		<xsl:variable name="hrt_overlay">
			<div class="cst-overlay-name"><xsl:value-of select="room-type/hrt_name" /></div>
		</xsl:variable>

		<xsl:call-template name="header-gallery-items">
			<xsl:with-param name="items" select="$hrt_media_head/media_url" />
			<xsl:with-param name="overlay" select="$hrt_overlay" />
		</xsl:call-template>

		<xsl:if test="@service-booking = 'yes' or @service-request = 'yes'">
			<site:cms-page-content-place template-content="widget" replace="all">
				<ul>
					<xsl:if test="@service-booking = 'yes'">
						<li><a href="{@url-booking}">[%txt.book]</a></li>
					</xsl:if>
					<xsl:if test="@service-request = 'yes'">
						<li><a href="{@url-request}">[%txt.request]</a></li>
					</xsl:if>
					<li><a href="vsc.php?view=vouchers&amp;c%5Bids_hotels%5D%5B0%5D=1063">[%txt.vouchers]</a></li>
				</ul>
			</site:cms-page-content-place>
		</xsl:if>
		<xsl:variable name="seasons-midweek-dayprice" select="room-type/prices/season-groups/season-group/seasons/season[@key-short='71-0-0']" />
		<xsl:variable name="hrt-price-from"><xsl:choose>
			<xsl:when test="$seasons-midweek-dayprice[1]">
				<xsl:for-each select="$seasons-midweek-dayprice">
					<xsl:sort select="../../@price-int" order="ascending" data-type="number" />
					<xsl:if test="position()=1">
						<xsl:value-of select="../../@price" />
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="room-type/hrt_price_from_int &gt; 0"><xsl:value-of select="room-type/hrt_price_from" /></xsl:when>
			<xsl:when test="room-type/prices/season-groups/season-group[@price-int &gt; 0]">
				<xsl:for-each select="room-type/prices/season-groups/season-group[@price-int &gt; 0]">
					<xsl:sort select="@price-int" data-type="number" order="ascending" />
					<xsl:if test="position() = 1">
						<xsl:value-of select="@price" />
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose></xsl:variable>

		<div class="cst-detail cst-roomtype-detail cst-box">
			<div class="cst-detail-cols cst-roomtype-cols">
				<div class="cst-detail-informations cst-roomtype-informations" id="hrt_{room-type/hrt_id}_infos">
					<h1 class="cst-detail-name cst-roomtype-name"><xsl:value-of select="room-type/hrt_name" /></h1>
					<div class="cst-detail-teaser cst-roomtype-teaser">
						<xsl:copy-of select="room-type/hrt_desc_teaser/node()" />
					</div>
					<xsl:if test="$hrt-price-from != 0">
						<div class="cst-detail-price-from cst-roomtype-price-from">
							<span class="roomtype-from">[%txt.from]</span>
							<xsl:text> </xsl:text>
							<span class="roomtype-price"><xsl:value-of select="$hrt-price-from" /></span>
							<xsl:text> </xsl:text>
							<xsl:choose>
								<xsl:when test="room-type/hrt_price_type = 2">[%txt.perroom]</xsl:when>
								<xsl:otherwise>[%txt.perperson]</xsl:otherwise>
							</xsl:choose>
						</div>
					</xsl:if>
					<div class="cst-detail-description cst-roomtype-description">
						<xsl:copy-of select="room-type/hrt_desc_cms/node()" />
					</div>
					<div class="cst-detail-properties cst-roomtype-properties">
						<dl>
							<dt class="cst-roomtype-alloc">[%txt.alloc]</dt>
							<dd class="cst-roomtype-alloc">
								<xsl:call-template name="hrt_alloc">
									<xsl:with-param name="hrt_alloc_min" select="room-type/hrt_alloc_min" />
									<xsl:with-param name="hrt_alloc_max" select="room-type/hrt_alloc_max" />
									<xsl:with-param name="hrt_alloc_max_childs" select="room-type/hrt_alloc_max_childs - number(room-type/hrt_alloc_min)" />
								</xsl:call-template>
							</dd>
							<dt class="cst-roomtype-catering">[%txt.catering.title]</dt>
							<dd class="cst-roomtype-catering">[%txt.catering.<xsl:value-of select="room-type/hrt_catering" />]</dd>
							<dt class="cst-roomtype-category">[%txt.data.roomtype]</dt>
							<dd class="cst-roomtype-category"><xsl:value-of select="room-type/hrt_group_name" /></dd>
						</dl>
					</div>
				</div>
				<div class="cst-detail-actions cst-roomtype-actions">
					<div class="cst-detail-media cst-roomtype-media">
						<xsl:for-each select="$hrt_media">
							<xsl:sort select="@usage-type" order="ascending" data-type="text" />
							<xsl:variable name="alt">
								<xsl:choose>
									<xsl:when test="string-length(media_title)&gt;0">
										<xsl:value-of select="media_title" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$roomtype/room-type/hrt_name" />
									</xsl:otherwise>
								</xsl:choose>
								<xsl:text> </xsl:text>
								<xsl:value-of select="position()" />/<xsl:value-of select="count($hrt_media)" />
							</xsl:variable>
							<a title="{normalize-space($alt)}" href="{media_url}/1200x0q" class="fancybox" data-fancybox-type="image" data-fancybox-group="hrt.{$roomtype/hrt_id}">
								<img src="{media_url}/0x80q" alt="{normalize-space($alt)}" />
							</a>
						</xsl:for-each>
					</div>
					<div class="cst-detail-buttons cst-roomtype-buttons">
						<xsl:if test="@service-booking = 'yes'">
							<a class="cst-button cst-button-book" href="{@url-booking}">[%txt.book.room]</a>
						</xsl:if>
						<xsl:if test="@service-request = 'yes'">
							<a class="cst-button cst-button-enquire" href="{@url-request}">[%txt.request]</a>
						</xsl:if>
						<xsl:if test="/site:site/site:config/@remember='1' or /site:site/site:config/@remember-vnh='true'">
							<xsl:apply-templates select="/site:site/site:match-space/site-links/remember">
								<xsl:with-param name="id">hrt<xsl:value-of select="room-type/hrt_id" /></xsl:with-param>
								<xsl:with-param name="price"><xsl:value-of select="room-type/hrt_price" /></xsl:with-param>
								<xsl:with-param name="title"><xsl:value-of select="room-type/hrt_name" /></xsl:with-param>
								<xsl:with-param name="hotel"><xsl:value-of select="hotel/hotel_nameaffix" /></xsl:with-param>
								<xsl:with-param name="hotel-id"><xsl:value-of select="room-type/hrt_hotel" /></xsl:with-param>
								<xsl:with-param name="link"><xsl:text/></xsl:with-param>
								<xsl:with-param name="class">cst-button cst-button-remember</xsl:with-param>
							</xsl:apply-templates>
						</xsl:if>
						<xsl:if test="/site:site/site:config/@detail-button-back='true'">
							<a class="cst-button cst-button-back" href="./#group-{room-type/hrt_group}">[%txt.back]</a>
						</xsl:if>
					</div>
				</div>
			</div>
			<div class="cst-roomtype-vrn">
				<xsl:apply-templates select="cstc:revenue-navigator-search" />
				<xsl:apply-templates select="cstc:revenue-navigator" />
			</div>

			<div class="cst-roomtype-prices">
				<xsl:apply-templates select="room-type/cstc:roomtype-prices">
					<xsl:with-param name="prices" select="room-type/prices" />
					<xsl:with-param name="price-type" select="room-type/hrt_price_type" />
				</xsl:apply-templates>
			</div>
		</div>
		<xsl:variable name="breadcrumb-js">
			(function(){
				var bc = nst2015.opt.main.children('.breadcrumb');
				var infos = nst2015.id( 'hrt_<xsl:value-of select="room-type/hrt_id" />_infos' );
				infos.prepend( bc );
				var hrt_li = document.createElement('li');
				hrt_li.innerHTML = infos.find('h1').text();
				bc.find('ul').append( hrt_li );
			})();
			nst2015.opt.page_theme = 'hrt.<xsl:value-of select="room-type/hrt_group" />.<xsl:value-of select="room-type/hrt_id" />';
		</xsl:variable>
		<script type="text/javascript"><xsl:value-of select="normalize-space($breadcrumb-js)" /></script>
	</xsl:template>

	<xsl:template match="cstc:revenue-navigator-search" name="cst-revenue-navigator-search-custom">

		<xsl:param name="hotel_id"><xsl:value-of select="../hotel/hotel_id"/></xsl:param>

		<xsl:param name="type">
			<xsl:choose>
				<xsl:when test="name(..) = 'cstc:roomtype-list' or name(..) = 'cstc:roomtype-detail'">hrt</xsl:when>
				<xsl:when test="name(..) = 'cstc:package-detail'">hpa</xsl:when>
			</xsl:choose>
		</xsl:param>

		<xsl:param name="change-duration">
			<xsl:choose>
				<xsl:when test="$type = 'hpa'">0</xsl:when>
				<xsl:when test="$type = 'hrt'">1</xsl:when>
			</xsl:choose>
		</xsl:param>

		<xsl:param name="date-until">
			<xsl:choose>
				<xsl:when test="count( date_until ) &gt; 0">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:param>

		<xsl:param name="show-children">
			<xsl:choose>
				<xsl:when test="$type = 'hpa'">1</xsl:when>
				<xsl:when test="$type = 'hrt'">1</xsl:when>
			</xsl:choose>
		</xsl:param>

		<xsl:param name="show-catering"><xsl:choose>
			<xsl:when test="pension-select"><xsl:choose>
				<xsl:when test="$type = 'hpa'">0</xsl:when>
				<xsl:when test="$type = 'hrt'">1</xsl:when>
			</xsl:choose></xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose></xsl:param>

		<xsl:variable name="min_adults"><xsl:choose>
			<xsl:when test="name(..) = 'cstc:roomtype-detail'"><xsl:value-of select="../room-type/hrt_alloc_min" /></xsl:when>
			<xsl:when test="name(..) = 'cstc:roomtype-list'"><xsl:for-each select="../roomtype-groups/roomtype-group/roomtypes/*/room-type/hrt_alloc_min">
				<xsl:sort select="." data-type="number" order="ascending"/>
				<xsl:if test="position() = 1"><xsl:value-of select="."/></xsl:if>
			</xsl:for-each></xsl:when>
			<xsl:when test="name(..) = 'cstc:package-detail'"><xsl:for-each select="../package-room-types/room-type/hrt_alloc_min">
				<xsl:sort select="." data-type="number" order="ascending"/>
				<xsl:if test="position() = 1"><xsl:value-of select="."/></xsl:if>
			</xsl:for-each></xsl:when>
		</xsl:choose></xsl:variable>

		<xsl:variable name="max_adults"><xsl:choose>
			<xsl:when test="name(..) = 'cstc:roomtype-detail'"><xsl:value-of select="../room-type/hrt_alloc_max" /></xsl:when>
			<xsl:when test="name(..) = 'cstc:roomtype-list'"><xsl:for-each select="../roomtype-groups/roomtype-group/roomtypes/*/room-type/hrt_alloc_max">
				<xsl:sort select="." data-type="number" order="descending"/>
				<xsl:if test="position() = 1"><xsl:value-of select="."/></xsl:if>
			</xsl:for-each></xsl:when>
			<xsl:when test="name(..) = 'cstc:package-detail'"><xsl:for-each select="../package-room-types/room-type/hrt_alloc_max">
				<xsl:sort select="." data-type="number" order="descending"/>
				<xsl:if test="position() = 1"><xsl:value-of select="."/></xsl:if>
			</xsl:for-each></xsl:when>
		</xsl:choose></xsl:variable>

		<xsl:variable name="max_children"><xsl:choose>
			<xsl:when test="name(..) = 'cstc:roomtype-detail'"><xsl:value-of select="number( ../room-type/hrt_alloc_max_childs ) - number( $min_adults )" /></xsl:when>
			<xsl:when test="name(..) = 'cstc:roomtype-list'"><xsl:for-each select="../roomtype-groups/roomtype-group/roomtypes/*/room-type/hrt_alloc_max_childs">
				<xsl:sort select="." data-type="number" order="descending"/>
				<xsl:if test="position() = 1"><xsl:value-of select="number( . ) - number( $min_adults )"/></xsl:if>
			</xsl:for-each></xsl:when>
			<xsl:when test="name(..) = 'cstc:package-detail'"><xsl:for-each select="../package-room-types/room-type/hrt_alloc_max_childs">
				<xsl:sort select="." data-type="number" order="descending"/>
				<xsl:if test="position() = 1"><xsl:value-of select="number( . ) - number( $min_adults )"/></xsl:if>
			</xsl:for-each></xsl:when>
		</xsl:choose></xsl:variable>

		<xsl:if test="$hotel_id != '' and $type != '' and /site:site/cstc:frame/@layout != 'vrn-hide'">
			<script type="text/javascript">
				_lib_load( 'jQuery', 'cst_general', 'vrn', 'jQuery-UI' );
			</script>
			<xsl:variable name="id" select="generate-id()" />
			<div id="cst_revenue_navigator_search_{$id}" lang="{/site:site/site:config/@language-str}" class="cst_revenue_navigator_search">
				<label class="vrn-search vrn-search-from">
					<span>[%txt.revenuenavigator.search.from]</span>
					<input type="text" name="date_input" readonly="readonly" value="" size="10" class="inputtext inputtext-stay-date" id="hrt_stay_date_{$id}" />
				</label>
				<xsl:choose>
					<xsl:when test="$date-until = '1'">
						<label class="vrn-search vrn-search-to">
							<span>[%txt.revenuenavigator.search.to]</span>
							<input type="text" name="date_until" readonly="readonly" value="" size="10" class="inputtext inputtext-stay-until" id="hrt_stay_until_{$id}" />
							<input type="hidden" name="duration" id="hrt_stay_duration_{$id}" value="--" />
						</label>
					</xsl:when>
					<xsl:when test="$change-duration = '1'">
						<label class="vrn-search vrn-search-duration">
							<select name="duration" id="hrt_stay_duration_{$id}">
								<xsl:call-template name="range-vrn-custom">
									<xsl:with-param name="start">1</xsl:with-param>
									<xsl:with-param name="stop" select="28" />
									<xsl:with-param name="default">[%txt.revenuenavigator.search.stayduration]</xsl:with-param>
									<xsl:with-param name="default-value"><xsl:choose>
										<xsl:when test="$type='hrt'">
											<xsl:choose>
												<xsl:when test="../room-type/hrt_least_stays &gt; 0"><xsl:value-of select="../room-type/hrt_least_stays" /></xsl:when>
												<xsl:otherwise>1</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:when test="$type='hpa'"><xsl:value-of select="../package/hpa_stays" /></xsl:when>
									</xsl:choose></xsl:with-param>
									<xsl:with-param name="numerus">txt.stays.numerus</xsl:with-param>
								</xsl:call-template>
							</select>
						</label>
					</xsl:when>
				</xsl:choose>
				<xsl:if test="$show-catering = '1'">
					<span class="hrt_stay hrt_stay_catering">
						<label for="hrt_stay_catering_{$id}">[%txt.revenuenavigator.search.staycatering] </label><select name="pension" id="hrt_stay_catering_{$id}">
						<option value="">--</option>
						<xsl:for-each select="((../roomtype-groups/roomtype-group/roomtypes/*)[1]/pensions|../room-type-pensions)/*">
							<option value="{hpt_id}"><xsl:value-of select="hpt_name" /></option>
						</xsl:for-each>
					</select>
					</span>
				</xsl:if>
				<label class="vrn-search vrn-search-adults">
					<select name="adults" id="hrt_stay_adults_{$id}">
						<xsl:call-template name="range-vrn-custom">
							<xsl:with-param name="start" select="$min_adults" />
							<xsl:with-param name="stop" select="$max_adults" />
							<xsl:with-param name="default"><xsl:choose>
								<xsl:when test="$show-children = '1'">[%txt.revenuenavigator.search.adults] </xsl:when>
								<xsl:otherwise>[%txt.revenuenavigator.search.persons] </xsl:otherwise>
							</xsl:choose></xsl:with-param>
							<xsl:with-param name="default-value"><xsl:choose>
								<xsl:when test="$type='hrt'">
									<xsl:choose>
										<xsl:when test="../room-type/hrt_alloc_def &gt; 0"><xsl:value-of select="../room-type/hrt_alloc_def" /></xsl:when>
										<xsl:otherwise>1</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:when test="$type='hpa'"><xsl:value-of select="../package-detail/room/hrt_alloc_def" /></xsl:when>
							</xsl:choose></xsl:with-param>
							<xsl:with-param name="numerus"><xsl:choose>
								<xsl:when test="$show-children = '1'">txt.adults.numerus</xsl:when>
								<xsl:otherwise>txt.person.numerus</xsl:otherwise>
							</xsl:choose></xsl:with-param>
						</xsl:call-template>
					</select>
				</label>
				<xsl:if test="$show-children = '1' and $max_children &gt; 0">
					<label class="vrn-search vrn-search-children">
						<select name="children" id="hrt_stay_children_{$id}">
							<xsl:call-template name="range-vrn-custom">
								<xsl:with-param name="start" select="0" />
								<xsl:with-param name="stop" select="$max_children" />
								<xsl:with-param name="numerus">txt.children.numerus</xsl:with-param>
							</xsl:call-template>
						</select>
					</label>
					<div class="hrt_stay_children_ages" style="display: none;">
						<xsl:call-template name="cst-revenue-navigator-search-children">
							<xsl:with-param name="id" select="$id" />
							<xsl:with-param name="max_children" select="$max_children" />
						</xsl:call-template>
					</div>
				</xsl:if>
			</div>
			<xsl:variable name="vrn-search-js">
				if ( typeof cst_i18n != 'undefined' ) {
					var vrn_i18n = new cst_i18n;
					vrn_i18n.i18n['revenuenavigator'] = {
						loading:	'[%txt.revenuenavigator.loading;escape-single-quote]',
						price_for:	'[%txt.revenuenavigator.pricefor;escape-single-quote]',
						person:		'[%txt.revenuenavigator.person;escape-single-quote]',
						persons:	'[%txt.revenuenavigator.persons;escape-single-quote]',
						persons24:	'[%txt.revenuenavigator.persons24;escape-single-quote]',
						and:		'[%txt.revenuenavigator.and;escape-single-quote]',
						with_pension: '[%txt.revenuenavigator.with;escape-single-quote]',
						night:		'[%txt.revenuenavigator.night;escape-single-quote]',
						nights:		'[%txt.revenuenavigator.nights;escape-single-quote]',
						nights24:	'[%txt.revenuenavigator.nights24;escape-single-quote]',
						journey:	'[%txt.revenuenavigator.journey;escape-single-quote]',
						departure:	'[%txt.revenuenavigator.departure;escape-single-quote]',
						notbookable: '[%txt.revenuenavigator.not.bookable;escape-single-quote]',
						days:		[ '[%txt.revenuenavigator.sun;escape-single-quote]', '[%txt.revenuenavigator.mon;escape-single-quote]', '[%txt.revenuenavigator.tue;escape-single-quote]', '[%txt.revenuenavigator.wed;escape-single-quote]', '[%txt.revenuenavigator.thu;escape-single-quote]', '[%txt.revenuenavigator.fri;escape-single-quote]', '[%txt.revenuenavigator.sat;escape-single-quote]' ],
						symbol_dash: '[%txt.revenuenavigator.symbol.dash]',
						symbol_check: '[%txt.revenuenavigator.symbol.check]',
						symbol_back: '[%txt.revenuenavigator.symbol.back]',
						symbol_fwd: '[%txt.revenuenavigator.symbol.fwd]'
					};
					vrn_i18n.i18n['calendar'] = {
						currentText: '[%date.main.today]',
						monthNames: ['[%date.month.calendar.01]','[%date.month.calendar.02]','[%date.month.calendar.03]','[%date.month.calendar.04]','[%date.month.calendar.05]','[%date.month.calendar.06]','[%date.month.calendar.07]','[%date.month.calendar.08]','[%date.month.calendar.09]','[%date.month.calendar.10]','[%date.month.calendar.11]','[%date.month.calendar.12]'],
						monthNamesShort: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
						dayNames: ['[%date.day.07]', '[%date.day.01]', '[%date.day.02]', '[%date.day.03]', '[%date.day.04]', '[%date.day.05]', '[%date.day.06]'],
						dayNamesShort: ['[%date.shortday.07]', '[%date.shortday.01]', '[%date.shortday.02]', '[%date.shortday.03]', '[%date.shortday.04]', '[%date.shortday.05]', '[%date.shortday.06]'],
						dayNamesMin: ['[%date.shortday.07]', '[%date.shortday.01]', '[%date.shortday.02]', '[%date.shortday.03]', '[%date.shortday.04]', '[%date.shortday.05]', '[%date.shortday.06]'],
						dateFormat: '[%date.format.frontend]'
					};
					jQuery( '#cst_revenue_navigator_search_<xsl:value-of select="$id" />' ).vioma_revenue_navigator_search( {
						calendar: {
							id:		'hrt_stay_date_<xsl:value-of select="$id" />',
							<xsl:choose>
								<xsl:when test="count( ../package/tf-avail/* ) &gt; 0">
									tf:	[ <xsl:for-each select="../package/tf-avail/*">
									[ '<xsl:value-of select="ht_from" />', '<xsl:value-of select="ht_to" />' ]<xsl:if test="position() != last()">, </xsl:if>
								</xsl:for-each> ],
									minDate:	'<xsl:value-of select="../package/tf-avail/*[1]/ht_from" />',
									maxDate:	'<xsl:value-of select="../package/tf-avail/*[position() = last()]/ht_to" />',
									stays:		'<xsl:value-of select="../package/hpa_stays" />'
								</xsl:when>
								<xsl:otherwise>
									minDate: '0'
								</xsl:otherwise>
							</xsl:choose>
						}
					} );
				} else if( typeof console != 'undefined' ) {
					console.error( 'vrn: fatal error, i18n not loaded, check domshake.' );
				}
			</xsl:variable>
			<script type="text/javascript"><xsl:value-of select="normalize-space($vrn-search-js)" /></script>
		</xsl:if>
	</xsl:template>

	<xsl:template name="range-vrn-custom">
		<xsl:param name="start" />
		<xsl:param name="stop" />
		<xsl:param name="selected" select="false()" />
		<xsl:param name="default" select="false()" />
		<xsl:param name="default-value" select="$default" />
		<xsl:param name="numerus" select="false()" />

		<xsl:if test="$default">
			<option value="{$default-value}">
				<xsl:value-of select="string($default)" />
			</option>
		</xsl:if>
		<option value="{$start}">
			<xsl:if test="$start = $selected">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="$start" />
			<xsl:if test="$numerus">
				<xsl:text> </xsl:text>
				[%<xsl:value-of select="string($numerus)" />/<xsl:value-of select="$start" />]
			</xsl:if>
		</option>
		<xsl:if test="$start &lt; $stop">
			<xsl:call-template name="range-vrn-custom">
				<xsl:with-param name="start" select="$start + 1" />
				<xsl:with-param name="stop" select="$stop" />
				<xsl:with-param name="selected" select="$selected" />
				<xsl:with-param name="numerus" select="$numerus" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="cstc:roomtype-prices">
		<xsl:param name="prices" />
		<xsl:param name="price-type" />

		<div class="cst-detail-prices cst-detail-prices-parents">
			<xsl:apply-templates select="../cstc:roomtype-prices-parents">
				<xsl:with-param name="prices" select="$prices" />
				<xsl:with-param name="price-type" select="$price-type" />
			</xsl:apply-templates>
		</div>
	</xsl:template>

	<xsl:template match="cstc:roomtype-prices-parents">
		<xsl:param name="prices" />
		<xsl:param name="price-type" />

		<xsl:variable name="room_is_luxus_suite" select="contains(',9808,9810,9811,24458,', concat(',',$prices/../hrt_id,','))" />

		<xsl:variable name="seasons_2016" select="$prices/season-groups/season-group/seasons/season[@id='49690' or @id='49691']" />
		<xsl:variable name="rule_week_so-so_2016" select="$prices/rules/*[hru_id=6752375 and not($room_is_luxus_suite)]" />
		<xsl:variable name="days_3_2016" select="$prices/rules/*[hru_id=6752328 and not($room_is_luxus_suite)]" />
		<xsl:variable name="days_4_2016" select="$prices/rules/*[hru_id=6752327 and not($room_is_luxus_suite)]" />
		<xsl:variable name="days_5_2016" select="$prices/rules/*[hru_id=6752326 and not($room_is_luxus_suite)]" />

		<xsl:variable name="seasons_2017" select="$prices/season-groups/season-group/seasons/season[@id='55913' or @id='55914']" />
		<xsl:variable name="rule_week_so-so_2017" select="$prices/rules/*[hru_id=6951970 and not($room_is_luxus_suite)]" />
		<xsl:variable name="days_3_2017" select="$prices/rules/*[hru_id=6951969 and not($room_is_luxus_suite)]" />
		<xsl:variable name="days_4_2017" select="$prices/rules/*[hru_id=6951968 and not($room_is_luxus_suite)]" />
		<xsl:variable name="days_5_2017" select="$prices/rules/*[hru_id=6951967 and not($room_is_luxus_suite)]" />

		<xsl:if test="$prices/season-groups/*">
			<div class="cst-roomtype-prices-day">
				<xsl:if test="$price-type=1 or $price-type=3 or $price-type=4">
					<h3 class="price_type">[%hotel-schwarz.prices.day.headline]</h3>
					<p class="price-type-subtitle">[%txt.price.stay.adult/<xsl:value-of select="/site:site/site:config/@currency" />]</p>
				</xsl:if>
				<xsl:if test="$price-type=2"><h3>[%txt.price.room.adult/<xsl:value-of select="/site:site/site:config/@currency" />]</h3></xsl:if>
				<table class="roomtype-prices" cellpadding="0" cellspacing="0" border="0">

					<!-- Regeln für 2016 -->

					<tr>
						<td class="season" colspan="3">
							<div class="season-name">Preise 2016</div>
							<div class="season-date">
								<xsl:for-each select="$seasons_2016[1]">
									<div class="season-date"><xsl:value-of select="substring(hs_from,0,7)" /><xsl:value-of select="substring(hs_from,9)" /> - <xsl:value-of select="substring(hs_to,0,7)" /><xsl:value-of select="substring(hs_to,9)" /></div>
								</xsl:for-each>
							</div>
						</td>
					</tr>

					<xsl:if test="$rule_week_so-so_2016">
						<tr>
							<td class="season"><div class="season-name">Wochenpauschale</div></td>
							<td class="season">Sonntag - Sonntag</td>
							<td class="price">
								<div class="price">
									<xsl:value-of select="$rule_week_so-so_2016/hrui_change_value_display" />
								</div>
							</td>
						</tr>
					</xsl:if>

					<xsl:if test="$days_4_2016">
						<tr>
							<td class="season"><div class="season-name">4 Tages-Pauschale</div></td>
							<td class="season">Sonntag - Donnerstag</td>
							<td class="price">
								<div class="price">
									<xsl:value-of select="$days_4_2016/hrui_change_value_display" />
								</div>
							</td>
						</tr>
					</xsl:if>

					<xsl:if test="$days_3_2016">
						<tr>
							<td class="season"><div class="season-name">3 Tages-Pauschale</div></td>
							<td class="season">Wochenende</td>
							<td class="price">
								<div class="price">
									<xsl:value-of select="$days_3_2016/hrui_change_value_display" />
								</div>
							</td>
						</tr>
					</xsl:if>

					<!-- Saisonzeiten für 2016 -->

					<xsl:for-each select="$seasons_2016">
						<xsl:sort select="count(weekdays/*)" data-type="number" order="descending" />
						<tr>
							<td class="season">
								<div class="parent">
									<xsl:call-template name="cstc:roomtype-season-1" />
								</div>
							</td>

							<td class="season-weekdays">
								<xsl:if test="count(weekdays/*)!=7">
									<div class="season-weekdays">
										<xsl:for-each select="weekdays/*"><!-- only show the first and the last day -->
											<xsl:sort select="number(@num) mod 7" order="ascending" data-type="number" />
											<xsl:if test="position() = 1">
												[%date.day.<xsl:value-of select="@num" />]<xsl:text> - </xsl:text>
											</xsl:if>
											<xsl:if test="position() = last()">
												[%date.day.<xsl:value-of select="@num" />]
											</xsl:if>
										</xsl:for-each>
									</div>

									<xsl:if test="hs_stays_min!=0 or hs_stays_max!=0">
										<div class="season-stays">
											<xsl:if test="hs_stays_min!=0">
												[%txt.stays.length.from/<xsl:value-of select="hs_stays_min" />]
											</xsl:if>
											<xsl:if test="hs_stays_max!=0">
												[%txt.stays.length.to/<xsl:value-of select="hs_stays_max" />]
											</xsl:if>
										</div>
									</xsl:if>
								</xsl:if>
							</td>

							<td class="price">
								<div class="price-bottom">
									<div class="price">
										<xsl:value-of select="../../@price" />
										<!-- Task 114982: SUPPORT "Zimmerpreise - Bei Suiten mit Preis pro Suite Sternchen herausnehmen" from Elisabeth Höpperger <e.hoepperger@schwarz.at> -->
										<xsl:if test="not(../../../../../room-type[hrt_group=150 and hrt_price_type=2])"><!--  <span class="price-alloc-star"> *</span>--></xsl:if>
									</div>
								</div>
							</td>

						</tr>
					</xsl:for-each>

				</table>

				<!-- Regeln für 2017 -->
				<table class="roomtype-prices" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td class="season" colspan="3">
							<div class="season-name">Preise 2017</div>
							<div class="season-date">
								<xsl:for-each select="$seasons_2017[1]">
									<div class="season-date"><xsl:value-of select="substring(hs_from,0,7)" /><xsl:value-of select="substring(hs_from,9)" /> - <xsl:value-of select="substring(hs_to,0,7)" /><xsl:value-of select="substring(hs_to,9)" /></div>
								</xsl:for-each>
							</div>
						</td>
					</tr>

					<xsl:if test="$rule_week_so-so_2017">
						<tr>
							<td class="season"><div class="season-name">Wochenpauschale</div></td>
							<td class="season">Sonntag - Sonntag</td>
							<td class="price">
								<div class="price">
									<xsl:value-of select="$rule_week_so-so_2017/hrui_change_value_display" />
								</div>
							</td>
						</tr>
					</xsl:if>

					<xsl:if test="$days_4_2017">
						<tr>
							<td class="season"><div class="season-name">4 Tages-Pauschale</div></td>
							<td class="season">Sonntag - Donnerstag</td>
							<td class="price">
								<div class="price">
									<xsl:value-of select="$days_4_2017/hrui_change_value_display" />
								</div>
							</td>
						</tr>
					</xsl:if>

					<xsl:if test="$days_3_2017">
						<tr>
							<td class="season"><div class="season-name">3 Tages-Pauschale</div></td>
							<td class="season">Wochenende</td>
							<td class="price">
								<div class="price">
									<xsl:value-of select="$days_3_2017/hrui_change_value_display" />
								</div>
							</td>
						</tr>
					</xsl:if>

					<!-- Saisonzeiten für 2017 -->

					<xsl:for-each select="$seasons_2017">
						<xsl:sort select="count(weekdays/*)" data-type="number" order="descending" />
						<tr>
							<td class="season">
								<div class="parent">
									<xsl:call-template name="cstc:roomtype-season-1" />
								</div>
							</td>

							<td class="season-weekdays">
								<xsl:if test="count(weekdays/*)!=7">
									<div class="season-weekdays">
										<xsl:for-each select="weekdays/*"><!-- only show the first and the last day -->
											<xsl:sort select="number(@num) mod 7" order="ascending" data-type="number" />
											<xsl:if test="position() = 1">
												[%date.day.<xsl:value-of select="@num" />]<xsl:text> - </xsl:text>
											</xsl:if>
											<xsl:if test="position() = last()">
												[%date.day.<xsl:value-of select="@num" />]
											</xsl:if>
										</xsl:for-each>
									</div>

									<xsl:if test="hs_stays_min!=0 or hs_stays_max!=0">
										<div class="season-stays">
											<xsl:if test="hs_stays_min!=0">
												[%txt.stays.length.from/<xsl:value-of select="hs_stays_min" />]
											</xsl:if>
											<xsl:if test="hs_stays_max!=0">
												[%txt.stays.length.to/<xsl:value-of select="hs_stays_max" />]
											</xsl:if>
										</div>
									</xsl:if>
								</xsl:if>
							</td>

							<td class="price">
								<div class="price-bottom">
									<div class="price">
										<xsl:value-of select="../../@price" />
										<!-- Task 114982: SUPPORT "Zimmerpreise - Bei Suiten mit Preis pro Suite Sternchen herausnehmen" from Elisabeth Höpperger <e.hoepperger@schwarz.at> -->
										<xsl:if test="not(../../../../../room-type[hrt_group=150 and hrt_price_type=2])"><!--  <span class="price-alloc-star"> *</span>--></xsl:if>
									</div>
								</div>
							</td>

						</tr>
					</xsl:for-each>

				</table>
			</div>

			<!-- <xsl:choose>
				<xsl:when test="$rule_week or $rule_week_new or $rule_week_2013">
					<div class="cst-roomtype-prices-week">
						<table class="roomtype-prices roomtype-prices-week" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td class="head" colspan="{$display-cols}">
									<div class="price_type">[%hotel-schwarz.prices.week.headline]</div>
									[%hotel-schwarz.prices.week.headline.2]
								</td>
							</tr>
							<xsl:if test="$rule_week">
								<tr>
									<td class="rule_text" style="margin-top:95px;">
										<xsl:value-of select="$rule_week/hru_display_text" />
									</td>
								</tr>
								<tr>
									<td colspan="{$display-cols}">
										<xsl:for-each select="$rule_week/tf-avail/*">
											<div class="season-date">
												<xsl:value-of select="ht_from_display" />
												<xsl:text> - </xsl:text>
												<xsl:value-of select="ht_to_display" />
											</div>
										</xsl:for-each>
										<div class="price">
											<xsl:value-of select="$rule_week/hrui_change_value_display" />
										</div>
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="$rule_week_new">
								<tr>
									<td class="rule_text" style="margin-top:95px;">
										<xsl:value-of select="$rule_week_new/hru_display_text" />
									</td>
								</tr>
								<tr>
									<td colspan="{$display-cols}">
										<xsl:for-each select="$rule_week_new/tf-avail/*">
											<xsl:sort select="ht_from_ts" order="ascending"/>
											<div class="season-date">
												<xsl:value-of select="ht_from_display" />
												<xsl:text> - </xsl:text>
												<xsl:value-of select="ht_to_display" />
											</div>
										</xsl:for-each>
										<div class="price">
											<xsl:value-of select="$rule_week_new/hrui_change_value_display" />
										</div>
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="$rule_week_2013">
								<tr>
									<td class="rule_text" style="margin-top:95px;">
										<xsl:value-of select="$rule_week_2013/hru_display_text" />
									</td>
								</tr>
								<tr>
									<td colspan="{$display-cols}">
										<xsl:for-each select="$rule_week_2013/tf-avail/*">
											<xsl:sort select="ht_from_ts" order="ascending"/>
											<div class="season-date">
												<xsl:value-of select="ht_from_display" />
												<xsl:text> - </xsl:text>
												<xsl:value-of select="ht_to_display" />
											</div>
										</xsl:for-each>
										<div class="price">
											<xsl:value-of select="$rule_week_2013/hrui_change_value_display" />
										</div>
									</td>
								</tr>
							</xsl:if>
						</table>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<style>div.cst-roomtype-prices-day table{max-width:666px;}</style>
				</xsl:otherwise>
			</xsl:choose> -->
		</xsl:if>
	</xsl:template>

	<xsl:template name="cstc:roomtype-season-1">
		<xsl:if test="string-length(hs_name_public)&gt;0">
			<div class="season-name"><xsl:value-of select="hs_name_public" /></div>
		</xsl:if>

		<!--<xsl:for-each select="dates/*">
			<div class="season-date"><xsl:value-of select="substring(hs_from,0,7)" /><xsl:value-of select="substring(hs_from,9)" /> - <xsl:value-of select="substring(hs_to,0,7)" /><xsl:value-of select="substring(hs_to,9)" /></div>
		</xsl:for-each>-->

		<!--<div class="season-date"><xsl:value-of select="hs_from" /> - <xsl:value-of select="hs_to" /></div>-->

	</xsl:template>

	<xsl:template match="cstc:package-detail">
		<xsl:variable name="package" select="." />
		<xsl:variable name="hpa_media" select="cstc:media-usages/*[@usage-type='image' or @usage-type='embed']" />
		<xsl:variable name="hpa_title">
			<xsl:choose>
				<xsl:when test="contains( package/hpa_name, '|' )">
					<xsl:value-of select="substring-before( package/hpa_name, '|' )" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="package/hpa_name" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="hpa_overlay">
			<div class="cst-overlay-name"><xsl:value-of select="$hpa_title" /></div>
			<div class="cst-overlay-infos"><xsl:value-of select="package/hpa_stays" /> [%txt.stays.numerus/<xsl:value-of select="package/hpa_stays" />]</div>
		</xsl:variable>

		<xsl:call-template name="header-gallery-items">
			<xsl:with-param name="items" select="$package/package/hpa_image|$hpa_media/media_url" />
			<xsl:with-param name="overlay" select="$hpa_overlay" />
		</xsl:call-template>

		<xsl:if test="( @service-booking = 'yes' and package/hpa_bookable = 1 ) or @service-request = 'yes'">
			<site:cms-page-content-place template-content="widget" replace="all">
				<ul>
					<xsl:if test="@service-booking = 'yes' and package/hpa_bookable = 1">
						<li><a href="{@url-booking}">[%txt.book]</a></li>
					</xsl:if>
					<xsl:if test="@service-request = 'yes'">
						<!--<li><a href="transaction.php?items[]=hpa:{package/hpa_id}&amp;c[id_hotel]={package/hpa_hotel}&amp;vri_id=4463">[%txt.request]</a></li>-->
						<li><a href="{@url-request}">[%txt.request]</a></li>
					</xsl:if>
					<li><a href="vsc.php?view=vouchers&amp;c%5Bids_hotels%5D%5B0%5D=1063">[%txt.vouchers]</a></li>
				</ul>
			</site:cms-page-content-place>
		</xsl:if>

		<div class="cst-detail cst-package-detail">
			<div class="cst-detail-cols">
				<div class="cst-detail-informations" id="hpa_{package/hpa_id}_infos">
					<h1 class="cst-detail-name cst-package-detail-name"><xsl:value-of select="$hpa_title" /></h1>
					<div class="cst-detail-teaser">
						<xsl:if test="string-length(package/hpa_teaser) &gt;3">
							<xsl:call-template name="cstc:formatted-text">
								<xsl:with-param name="text-node" select="package/hpa_teaser" />
							</xsl:call-template>
						</xsl:if>
					</div>
					<xsl:if test="string-length(package/hpa_desc )&gt;5">
						<div class="cst-detail-description">
							<xsl:call-template name="cstc:formatted-text">
								<xsl:with-param name="text-node" select="package/hpa_desc" />
							</xsl:call-template>
						</div>
					</xsl:if>

					<xsl:if test="count(pensions/*)&gt;1">
						<div class="cst-detail-catering">
							<xsl:call-template name="pensions-container">
								<xsl:with-param name="type">package</xsl:with-param>
								<xsl:with-param name="url" select="package/@url" />
								<xsl:with-param name="url_param">?c[id_pension]=</xsl:with-param>
								<xsl:with-param name="pensions" select="pensions" />
								<xsl:with-param name="selected_pension" select="avail/hpa_pension_used" />
								<xsl:with-param name="hotel_currency" select="hotel-currency" />
							</xsl:call-template>
						</div>
					</xsl:if>
					<xsl:if test="package/weekdays_arrival">
						<xsl:call-template name="cstc:package-arrival"/>
					</xsl:if>
				</div>
				<div class="cst-detail-actions">
					<xsl:if test="avail/*[1]">
						<div class="cst-detail-price-from">
							<xsl:if test="avail/hpa_stays &gt;0">
								<div class="cst-stays">
									<span class="cst-stays-number">
										<xsl:value-of select="avail/hpa_stays"/>
									</span>
									<xsl:text> </xsl:text>
									<span class="cst-stays-text">[%txt.stays.numerus/
										<xsl:value-of select="avail/stays"/>]
									</span>
									<xsl:if test="package/hpa_stays_max &gt; package/hpa_stays">
										<span class="cst-stays-max">
											([%txt.up_to.nights.additional/<xsl:value-of select="package/hpa_stays_max"/>])
										</span>
									</xsl:if>
								</div>
							</xsl:if>
							<xsl:if test="count(package/tf-avail/*) &gt; 0 and (package/tf-avail/*/ht_to_display != '0000-00-00')">
								<ul class="cst-timeframes">
									<xsl:if test="count(package/tf-avail/*) &gt; 3">
										<xsl:attribute name="class">cst-timeframes cols</xsl:attribute>
									</xsl:if>
									<xsl:for-each select="package/tf-avail/*">
										<xsl:sort select="ht_from_ts" order="ascending"/>
										<li class="cst-timeframe">
											<xsl:if test="position()=last()">
												<xsl:attribute name="class">cst-timeframe cst-timeframe-left cst-timeframe-left-last</xsl:attribute>
											</xsl:if>
											<span class="cst-timeframe-from">
												<xsl:value-of select="./ht_from_display"/>
											</span>
											<span class="cst-binder">-</span>
											<span class="cst-timeframe-to">
												<xsl:value-of select="./ht_to_display"/>
											</span>
										</li>
									</xsl:for-each>
								</ul>
							</xsl:if>
							<div class="cst-package-variant-price">
								<xsl:call-template name="cstc:package-price-teaser-schwarz"/>
								<xsl:if test="package-room-types/*[../../avail/hpa_default_room_type=../../avail/hr_type and ../../avail/hpa_default_room_type=hrt_id]">
									<xsl:variable name="default-room-type" select="package-room-types/*[../../avail/hpa_default_room_type=hrt_id]"/>
									<span class="cst-default-roomtype">
										(<xsl:value-of select="$default-room-type/hrt_name_str"/>)
									</span>
								</xsl:if>
							</div>
						</div>
					</xsl:if>

					<div class="cst-detail-buttons cst-roomtype-buttons">
						<xsl:if test="@service-booking = 'yes' and package/hpa_bookable = 1">
							<a class="cst-button cst-button-book" href="{@url-booking}">[%txt.book]</a>
						</xsl:if>
						<xsl:if test="@service-request = 'yes'">
							<!--<a class="cst-button cst-button-enquire" href="transaction.php?items[]=hpa:{package/hpa_id}&amp;c[id_hotel]={package/hpa_hotel}&amp;vri_id=4463">[%txt.request]</a>-->
							<a class="cst-button cst-button-enquire" href="{@url-request}">[%txt.request]</a>
						</xsl:if>
						<xsl:if test="/site:site/site:config/@remember='1' or /site:site/site:config/@remember-vnh='true'">
							<xsl:apply-templates select="/site:site/site:match-space/site-links/remember">
								<xsl:with-param name="id">hpa<xsl:value-of select="package/hpa_id" /></xsl:with-param>
								<xsl:with-param name="price"><xsl:value-of select="package/hpa_price" /></xsl:with-param>
								<xsl:with-param name="title"><xsl:value-of select="package/hpa_name" /></xsl:with-param>
								<xsl:with-param name="hotel"><xsl:value-of select="hotel/hotel_nameaffix" /></xsl:with-param>
								<xsl:with-param name="hotel-id"><xsl:value-of select="package/hpa_hotel" /></xsl:with-param>
								<xsl:with-param name="link"><xsl:text/></xsl:with-param>
								<xsl:with-param name="class">cst-button cst-button-remember</xsl:with-param>
							</xsl:apply-templates>
						</xsl:if>
						<xsl:if test="/site:site/site:config/@detail-button-back='true'">
							<a class="cst-button cst-button-back" href="javascript:history.go(-1);">[%txt.back]</a>
						</xsl:if>
					</div>

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

				<xsl:if test="package/hpa_bookable = 1 and cstc:revenue-navigator">
					<div class="cst-detail-vrn">
						<xsl:apply-templates select="cstc:revenue-navigator-search" />
						<xsl:apply-templates select="cstc:revenue-navigator" />
					</div>
				</xsl:if>
			</div>
		</div>
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
		<xsl:variable name="breadcrumb-js">
			(function(){
				var bc = nst2015.opt.main.children('nav.breadcrumb');
				var infos = nst2015.id( 'hpa_<xsl:value-of select="package/hpa_id" />_infos' );
				var bc_new_li = $( document.createElement('li') ).text( infos.find('h1').text() );
				bc.find('ul').append( bc_new_li );
				infos.prepend( bc );
			})();
		</xsl:variable>
		<script type="text/javascript"><xsl:value-of select="normalize-space($breadcrumb-js)" /></script>
	</xsl:template>

	<xsl:template match="cstc:package-price-teaser" name="cstc:package-price-teaser-schwarz">
		<xsl:param name="type"/>

		<div class="cst-price">
			<xsl:if test="$type='normal'">
				<xsl:attribute name="class">cst-package-price-teaser cst-package-price-teaser-normal</xsl:attribute>
			</xsl:if>
			<span class="cst-price-from">[%txt.from]&#160;</span>
			<span class="cst-price-number">
				<xsl:variable name="package-price">
					<xsl:choose>
						<xsl:when test="info/hpa_price_min!=0">
							<xsl:value-of select="/site:site/site:config/@currency-sign" /><xsl:text> </xsl:text><xsl:value-of select="format-number(info/hpa_price_min,'##0,--','european')"></xsl:value-of>
						</xsl:when>
						<xsl:when test="info/hpa_programs_min!=0">
							<xsl:value-of select="/site:site/site:config/@currency-sign" /><xsl:text> </xsl:text><xsl:value-of select="format-number(info/hpa_programs_min,'##0,--','european')"></xsl:value-of>
						</xsl:when>
						<xsl:when test="not(avail/hpa_price_from_int=0)"><xsl:value-of select="avail/hpa_price_from" /></xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="avail/hpa_price" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:call-template name="cstc:formatted-text">
					<xsl:with-param name="text-node" select="$package-price" />
				</xsl:call-template>
			</span>
			<xsl:choose>
				<!-- list -->
				<xsl:when test="info/hpa_persons &gt; 1">&#160;<span class="cst-price-per-person">[%txt.price.perperson.short] <span class="cst-price-for-person">([%txt.for] <xsl:value-of select="info/hpa_persons" /> [%txt.persons])</span></span></xsl:when>
				<!-- detail -->
				<xsl:when test="package/hpa_persons &gt;1 ">&#160;<span class="cst-price-per-person">[%txt.price.perperson.short] <span class="cst-price-for-person">([%txt.for] <xsl:value-of select="package/hpa_persons" /> [%txt.persons])</span></span></xsl:when>
				<xsl:otherwise>&#160;<span class="cst-price-per-person">[%txt.price.perperson.short]</span></xsl:otherwise>
			</xsl:choose>
			<xsl:if test="avail/hpa_type &gt;1 and avail/hpa_price_discount_num &gt; 0.01">
				<span class="cst-price-save">
					[%package.price.save/<xsl:value-of select="avail/hpa_price_discount" />/<xsl:value-of select="/site:site/site:config/@currency" />]
				</span>
			</xsl:if>
		</div>
	</xsl:template>

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

		<div class="cst-list cst-list-programs" id="schwarz_programs_{$id}">
			<xsl:if test="/site:site/site:cms/content-attribute[@name='layout']/@value = 'indikator-filter'">
				<xsl:variable name="programs" select="." />
				<xsl:variable name="criterias" select="crits" />
				<xsl:variable name="assigned-indicators"><xsl:for-each select="programs/program-group[@group-id!='9999']">
					<xsl:variable name="coi_id" select="@group-id" />
					<xsl:copy-of select="$programs/indicators/*[coi_id=$coi_id]" />
				</xsl:for-each></xsl:variable>
				<xsl:variable name="list-filter-indicators" select="exslt:node-set($assigned-indicators)" />
				<div class="schwarz-list-filter">
					<form action="hotel-program-list.php" method="get">
						<fieldset class="list-filter-indicators">
							<xsl:for-each select="$list-filter-indicators/*">
								<xsl:sort select="normalize-space(coi_teaser_str)" order="ascending" data-type="number"/>
								<xsl:variable name="coi_id" select="coi_id"/>
								<label class="list-filter-indicator">
									<input type="checkbox" class="coi-checkbox" name="c[id_list_program_indicators][{coi_id}]" value="{coi_id}" data-id="schwarz_programs_{$id}">
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
			</xsl:if>

			<div class="schwarz-list-filter-ajax">
				<div class="schwarz-remote-list-item">
					<xsl:for-each select="programs/program-group">
						<xsl:sort select="@group-indicator-order" data-type="number" order="ascending" />
						<h2 class="accordion">
							<xsl:choose>
								<xsl:when test="/site:site/site:cms/content-attribute[@name='layout' and @value='programme-akkordeon-auf']"><xsl:attribute name="class">accordion open</xsl:attribute></xsl:when>
								<xsl:when test="( position() = 1 and position() = last() ) and not( /site:site/site:cms/content-attribute[@name='layout' and @value='programme-akkordeon-zu'] )"><xsl:attribute name="class">accordion open</xsl:attribute></xsl:when>
							</xsl:choose>
							<xsl:value-of select="@group-name" />
							<xsl:text> </xsl:text><span class="program-number">(<xsl:value-of select="count(*)" />)</span>
						</h2>
						<div class="cst-program-list">
							<xsl:apply-templates select="*" />
						</div>
					</xsl:for-each>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="cstc:program-list/programs/program-group/*">
		<xsl:variable name="program" select="." />
		<div class="cst-program cst-box">
			<div class="program-infos">
				<xsl:choose>
					<xsl:when test="contains(hp_name,'|')">
						<h3 class="program-variant"><xsl:value-of select="substring-before(hp_name,'|')" /></h3>
						<div class="program-variant-subtitle"><xsl:value-of select="substring-after(hp_name,'|')" /></div>
					</xsl:when>
					<xsl:otherwise>
						<h3><xsl:value-of select="hp_name" /></h3>
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
				<div class="program-price-from">
					<span class="program-price"><xsl:value-of select="hp_price" /></span>
				</div>
			</div>
			<div class="program-links">
				<xsl:if test="not( $program/@requestable ) or $program/@requestable = 'true'">
					<a class="cst-button cst-button-inquire" href="request.php?page=6.page1&amp;hotel_id={hp_hotel}&amp;remember[hp]={hp_id}">[%txt.request]</a>
				</xsl:if>
				<!--
							<xsl:if test="not( $program/@bookable ) or $program/@bookable = 'true'">
								<a class="cst-button cst-button-book" href="{@url-booking}">[%txt.book]</a>
							</xsl:if>
				-->
				<xsl:if test="/site:site/site:config/@remember='1' or /site:site/site:config/@remember-vnh='true'">
					<xsl:apply-templates select="/site:site/site:match-space/site-links/remember">
						<xsl:with-param name="id">hp<xsl:value-of select="$program/hp_id" /></xsl:with-param>
						<xsl:with-param name="price"><xsl:value-of select="$program/hp_price" /></xsl:with-param>
						<xsl:with-param name="title"><xsl:value-of select="$program/hp_name" /></xsl:with-param>
						<xsl:with-param name="hotel"><xsl:value-of select="hotel/hotel_nameaffix" /></xsl:with-param>
						<xsl:with-param name="hotel-id"><xsl:value-of select="$program/hp_hotel" /></xsl:with-param>
						<xsl:with-param name="link"><xsl:text/></xsl:with-param>
						<xsl:with-param name="class">cst-link cst-link-notice</xsl:with-param>
					</xsl:apply-templates>
				</xsl:if>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="cstc:user-request-add[@page=1 and @type = 2]" name="custom-user-request-add-page1-type2">
		<xsl:param name="action"><xsl:value-of select="$_self" />?page=2.page2&amp;hotel_id=<xsl:value-of select="@hotel_id" /></xsl:param>

		<xsl:if test="not(/site:site/site:cms/content-attribute[@name='header']/@value = 'nicht-verkleinern')">
			<style type="text/css">header .gal .slide{max-height: 50vh}</style>
		</xsl:if>

		<form method="post" action="{$action}" name="form" id="cst-frequest-form">
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
					<span class="cst-request-required-hint">* [%txt.field.required]</span>
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
					<span class="cst-request-required-hint">* [%txt.field.required]</span>
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
				[%txt.personaldata]
			</legend>
			<div class="cst-request-item cst-request-item-salutation">
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
							<!-- li class="cst-request-salutation-input-company">
								<input class="inputradio" id="sal_company" type="checkbox" name="form[request_user_title]" value="2" onclick="document.getElementById('cst-request-item-company').style.display == 'none'"/>
								<label class="" for="sal_company">[%txt.salutation.company]</label>
							</li-->
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
						<!-- xsl:call-template name="form-dropdown">
							<xsl:with-param name="name">form[request_user_title]</xsl:with-param>
							<xsl:with-param name="class">form_salutation</xsl:with-param>
							<xsl:with-param name="tabindex">1</xsl:with-param>
							<xsl:with-param name="options" select="salutations" />
							<xsl:with-param name="selected" select="form/request_user_title" />
						</xsl:call-template-->
					</xsl:otherwise>
				</xsl:choose>
			</div>
			<div class="cst-request-item cst-request-item-academic" id="cst-request-item-academic">
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

			<div class="cst-request-item cst-request-item-company" id="cst-request-item-company">
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
			</div>

			<div class="cst-request-item cst-request-item-firstname">
				<xsl:call-template name="form-element-required-attribute">
					<xsl:with-param name="field">request_user_firstname</xsl:with-param>
					<xsl:with-param name="class">firstname</xsl:with-param>
					<xsl:with-param name="form" select="$form" />
				</xsl:call-template>
				<label class="firstname" for="firstname">
					[%txt.firstname]
					<xsl:call-template name="form-element-required">
						<xsl:with-param name="field">request_user_firstname</xsl:with-param>
						<xsl:with-param name="form" select="$form" />
					</xsl:call-template>
				</label>
				<input type="text" id="firstname" name="form[request_user_firstname]" value="{$form/form/request_user_firstname}" class="inputtext inputtext-firstname" tabindex="3" />
			</div>
			<div class="cst-request-item cst-request-item-lastname">
				<xsl:call-template name="form-element-required-attribute">
					<xsl:with-param name="field">request_user_lastname</xsl:with-param>
					<xsl:with-param name="class">lastname</xsl:with-param>
					<xsl:with-param name="form" select="$form" />
				</xsl:call-template>
				<label class="title" for="lastname">
					[%txt.lastname]
					<xsl:call-template name="form-element-required">
						<xsl:with-param name="field">request_user_lastname</xsl:with-param>
						<xsl:with-param name="form" select="$form" />
					</xsl:call-template>
				</label>
				<input type="text" id="lastname" name="form[request_user_lastname]" value="{$form/form/request_user_lastname}" class="inputtext inputtext-lastname" tabindex="4" />
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
				<label for="email">
					[%txt.email]
					<xsl:call-template name="form-element-required">
						<xsl:with-param name="field">request_user_email</xsl:with-param>
						<xsl:with-param name="form" select="$form" />
					</xsl:call-template>
				</label>
				<input type="text" id="email" name="form[request_user_email]" value="{$form/form/request_user_email}" class="inputtext inputtext-email" tabindex="5" />
			</div>
			<div class="cst-request-item cst-request-item-phone">
				<xsl:call-template name="form-element-required-attribute">
					<xsl:with-param name="field">request_user_telefon</xsl:with-param>
					<xsl:with-param name="class">phone</xsl:with-param>
					<xsl:with-param name="form" select="$form" />
				</xsl:call-template>
				<label for="phone">
					[%txt.telefon]
					<xsl:call-template name="form-element-required">
						<xsl:with-param name="field">request_user_telefon</xsl:with-param>
						<xsl:with-param name="form" select="$form" />
					</xsl:call-template>
				</label>
				<input type="text" id="phone" name="form[request_user_telefon]" value="{$form/form/request_user_telefon}" class="inputtext inputtext-phone" tabindex="6" />
			</div>
			<div class="cst-request-item cst-request-item-telefax">
				<label for="telefax">
					<xsl:call-template name="form-element-required-attribute">
						<xsl:with-param name="field">request_user_telefax</xsl:with-param>
						<xsl:with-param name="class">telefax</xsl:with-param>
						<xsl:with-param name="form" select="$form" />
					</xsl:call-template>
					[%txt.telefax]
					<xsl:call-template name="form-element-required">
						<xsl:with-param name="field">request_user_telefax</xsl:with-param>
						<xsl:with-param name="form" select="$form" />
					</xsl:call-template>
				</label>
				<input type="text" id="telefax" name="form[request_user_telefax]" value="{$form/form/request_user_telefax}" class="inputtext inputtext-telefax" tabindex="7" />
			</div>
			<div class="cst-request-item cst-request-item-mobile">
				<xsl:call-template name="form-element-required-attribute">
					<xsl:with-param name="field">request_user_mobile_number</xsl:with-param>
					<xsl:with-param name="class">mobile</xsl:with-param>
					<xsl:with-param name="form" select="$form" />
				</xsl:call-template>
				<label for="mobile">
					[%txt.mobile.number]
					<xsl:call-template name="form-element-required">
						<xsl:with-param name="field">request_user_mobile_number</xsl:with-param>
						<xsl:with-param name="form" select="$form" />
					</xsl:call-template>
				</label>
				<input type="text" id="mobile" name="form[request_user_mobile_number]" value="{$form/form/request_user_mobile_number}" class="inputtext inputtext-telefax" tabindex="8" />
			</div>
		</fieldset>
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
				<label for="form_rd_from1_{$rd_id}">
					<xsl:value-of select="$field_name_from" />&#x00A0;<!-- ([%date.format.input])  -->
					<xsl:call-template name="form-element-required">
						<xsl:with-param name="field">rd_from1</xsl:with-param>
						<xsl:with-param name="form" select="$form" />
					</xsl:call-template>
				</label>
				<input type="text" id="form_rd_from1_{$rd_id}" name="form[rd_from1]" value="{form/rd_from1}" class="inputtext inputtext-arrival" />
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
				<label for="form_rd_to1_{$rd_id}">
					<xsl:value-of select="$field_name_to" />&#x00A0;<!-- ([%date.format.input]) -->
					<xsl:call-template name="form-element-required">
						<xsl:with-param name="field">rd_from1</xsl:with-param>
						<xsl:with-param name="form" select="$form" />
					</xsl:call-template>
				</label>
				<input type="text" id="form_rd_to1_{$rd_id}" name="form[rd_to1]" value="{form/rd_to1}" class="inputtext inputtext-arrival" />
				<xsl:apply-templates select="/site:site/site:match-space/calendar/jquery">
					<xsl:with-param name="obj_id">form_rd_to1_<xsl:value-of select="$rd_id" /></xsl:with-param>
					<xsl:with-param name="obj_range_start">form_rd_from1_<xsl:value-of select="$rd_id" /></xsl:with-param>
					<xsl:with-param name="form" select="$form" />
				</xsl:apply-templates>
			</div>
			<div class="cst-request-item cst-request-item-add-alternative-date">
				<a class="cst-request-add cst-request-add-alt-date" href="#">[%txt.add.icon][%txt.alternative.date.add]</a>
				<script type="text/javascript">
					jQuery( function( $ ) {
						$( '.cst-request-add-alt-date' ).click( function( ev ) {
							ev.preventDefault();
							$(this).contentToggle( '[%txt.add.icon][%txt.alternative.date.add]|[%txt.del.icon][%txt.alternative.date.del]', '.cst-request-travelling-data-alternate');
						});
					});
				</script>
			</div>
		</fieldset>
		<fieldset class="cst-request-travelling-data-alternate">
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
						<xsl:value-of select="$field_name_from" />&#x00A0;<!-- ([%date.format.input]) -->
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
						<xsl:value-of select="$field_name_to" />&#x00A0;<!-- ([%date.format.input]) -->
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
									<!--
									<a href="#">

										<div class="roomtype-info">
											<xsl:if test="hrt_image!='0'">
												<img src="{hrt_image}/100x100s"/>
											</xsl:if>
											<h2>
												<xsl:value-of select="hrt_name"/>
											</h2>
											<div class="teaser">
												<xsl:call-template name="filter-links">
													<xsl:with-param name="node" select="hrt_desc_teaser"/>
												</xsl:call-template>
											</div>
											<div class="description">
												<xsl:call-template name="filter-links">
													<xsl:with-param name="node" select="hrt_desc_cms"/>
												</xsl:call-template>
											</div>
										</div>
									</a>
									-->
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
						<!--<xsl:if test="$remember_image = 1"><td class="remember-items-img image"><xsl:text> </xsl:text></td></xsl:if>-->
						<td class="remember-item-name">[%txt.article]</td>
						<td class="remember-item-amount amount">[%txt.amount]</td>
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
								<input type="text" name="form[request-items][{$request-item-type}][{$request-item-id}][amount]" value="{amount}" class="inputtext remember-item-amount" />
							</td>
						</tr>
					</xsl:for-each>
				</table>
				<!--
					Warenkorb Teilen:
					=================
					- Abgekuertze URL generieren (bitly API)
					- Verlinkungen aufbauen
					- Link verfolgen
				-->
				<xsl:variable name="data-remembered-items">
					[<xsl:for-each select="$remember_items/*">
						{"type":"<xsl:value-of select="type" />","id":<xsl:value-of select="id" />,"amount":<xsl:value-of select="amount" />}<xsl:if test="position() != last()">,</xsl:if>
					</xsl:for-each>]
				</xsl:variable>

				<div class="remember-share" id="remember_share_{$id}">
					<xsl:attribute name="data-mailto-msg">[%custom.share.spa.message]</xsl:attribute>
					<h3>[%custom.share.spa.shopping.cart]</h3>
					<ul>
						<xsl:attribute name="data-remembered-items"><xsl:value-of select="normalize-space($data-remembered-items)" /></xsl:attribute>
						<li class="share-link-email"><a href="#" class="remember-share-link" data-type="email"><span class="fa">&#xf003;</span><span class="text">E-Mail</span></a></li>
						<li class="share-link-whatsapp"><a href="#" class="remember-share-link" data-type="whatsapp"><span class="fa">&#xf232;</span><span class="text">WhatsApp</span></a></li>
					</ul>
				</div>
				<xsl:variable name="remember-script">
					( function( $, me ){
						if( !me ) { return; }
						me.req_items_amount_change();
						me.req_items_share_links( $('#remember_share_<xsl:value-of select="$id" />').find('.remember-share-link') );
					} )( jQuery, window.nst2015 );
				</xsl:variable>
				<script type="text/javascript"><xsl:value-of select="normalize-space($remember-script)" /></script>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="cstc:user-request-spa-add[@page=1]">
		<xsl:variable name="form" select="." />

		<xsl:if test="not(/site:site/site:cms/content-attribute[@name='header']/@value = 'nicht-verkleinern')">
			<style type="text/css">header .gal .slide{max-height: 50vh}</style>
		</xsl:if>

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
					<span class="cst-request-required-hint">* [%txt.field.required]</span>
				</div>

				<xsl:if test="count(remember-items/*[hp_id]) &gt; 0">
					<xsl:variable name="custom-data" select="//cstc:user-request-custom-data"/>
					<xsl:variable name="persons"><xsl:choose>
						<xsl:when test="$custom-data/user-request-persons/*"><xsl:value-of select="count($custom-data/user-request-persons/*)"/></xsl:when>
						<xsl:otherwise>2</xsl:otherwise>
					</xsl:choose></xsl:variable>
					<div class="cst-request-spa">
						<h3>[%txt.personaldata]</h3>
						<xsl:choose>
							<xsl:when test="$custom-data/user-request-persons/*">
								<xsl:variable name="request_person_pos" select="position()" />
								<div class="cst-request-spa-person-{$request_person_pos}">
									<label class="dyn">[%txt.person] 1:</label><input name="form[messages][name_person_{$request_person_pos}]" class="inputtext inputtext-name-person{$request_person_pos}" value="{$form/form/messages/*[name()=concat('name_person_',$request_person_pos)]}"/>
								</div>
							</xsl:when>
							<xsl:otherwise>
								<div class="cst-request-spa-person-1">
									<label>[%txt.name] [%txt.person] 1:</label><input  name="form[messages][name_person_1]" class="inputtext inputtext-name-person1" value="{$form/form/messages/name_person_1}"/>
								</div>
								<div class="cst-request-spa-person-2">
									<label>[%txt.name] [%txt.person] 2:</label><input  name="form[messages][name_person_2]" class="inputtext inputtext-name-person2" value="{$form/form/messages/name_person_2}"/>
								</div>
							</xsl:otherwise>
						</xsl:choose>
						<h3>[%txt.programs]</h3>
						<xsl:for-each select="remember-items/*[hp_id and amount &gt; 0]">
							<fieldset class="item-{hp_id} item-new remember-items-alloc">
								<xsl:call-template name="remember-items-show">
									<xsl:with-param name="amount" select="amount"/>
									<xsl:with-param name="count">0</xsl:with-param>
									<xsl:with-param name="name" select="hp_name"/>
									<xsl:with-param name="id" select="hp_id"/>
									<xsl:with-param name="persons" select="$persons" />
								</xsl:call-template>
							</fieldset>
						</xsl:for-each>
					</div>
				</xsl:if>

				<xsl:apply-templates select="/site:site/site:match-space/site-headline">
					<xsl:with-param name="type">3</xsl:with-param>
					<xsl:with-param name="title">[%txt.request.6.desireddate]</xsl:with-param>
					<xsl:with-param name="class">cst cst-request cst-request-wishes</xsl:with-param>
				</xsl:apply-templates>

				<div class="cst-box cst-request-wishes">
					<textarea rows="7" cols="40" name="form[request_wishes]">
						<xsl:value-of select="form/request_wishes" />
					</textarea>
				</div>

				<div class="cst-box cst-request-user-data">
					<xsl:apply-templates select="/site:site/site:match-space/form/user-data">
						<xsl:with-param name="form" select="." />
					</xsl:apply-templates>
					<span class="cst-request-required-hint">* [%txt.field.required]</span>
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

</xsl:stylesheet>
