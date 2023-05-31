<?xml version = "1.0" encoding = "UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:site="http://xmlns.webmaking.ms/site/" xmlns:cstc="http://xmlns.webmaking.ms/cstc/" exclude-result-prefixes="site cstc">

	<xsl:variable name="legacy" select="boolean( /site:site/site:env/site:user-agent[( @name='msie' and @version &lt; 9)] ) " />
	<xsl:include href="svg.xsl"/>

	<xsl:template match="cstc:site">
		<div class="cst">
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<xsl:variable name="webdev" select="string-length( substring-after( /site:site/site:env/site:vars/@base-resources, '.webdev.' ) ) &gt; 0" />

	<!-- hrt, hp, hpa indicators ids -->
	<xsl:variable name="coi-lage">21052</xsl:variable>
	<xsl:variable name="coi-lage-paradies">21053</xsl:variable>
	<xsl:variable name="coi-lage-saentis">21054</xsl:variable>
	<xsl:variable name="coi-lage-hochgrat">21055</xsl:variable>
	<xsl:variable name="coi-packages">15516</xsl:variable>
	<xsl:variable name="coi-programs">15439</xsl:variable>

	<xsl:template match="search-form-js-custom">
		<script src="{$_base_res}customize/hotel-bergkristall2/js/book.js?version={$_version_cache}" type="text/javascript"/>
	</xsl:template>

	<xsl:template match="indicators"/>

	<xsl:template match="cstc:frame">
		<xsl:variable name="layout-fullwidth"><xsl:if test="count( /site:site/cstc:frame/cstc:site[@page-name='request']/cstc:user-request-add ) &gt; 0"> fullwidth</xsl:if></xsl:variable>
		<div class="cst cst-{../site:config/@language-str}{$layout-fullwidth}">
			<xsl:choose>
				<xsl:when test="/site:site/site:cms/@template-content-name='nl-cst' or  /site:site/site:cms/@template-content-name='nl-content'">
					<link rel="stylesheet" type="text/css" href="{$_base_res}css/cst-newsletter.css" />
				</xsl:when>
				<xsl:otherwise>
					<script type="text/javascript">
						var _base_res =	'<xsl:value-of select="$_base_res" />';
						var _version_cache = '<xsl:value-of select="$_version_cache" />';
					</script>
					<script type="text/javascript">
						_lib_load( 'cst_general', 'jQuery','Highslide' );
					</script>
					<script src="{$_base_res}js/general.js?v={$_version_cache}" type="text/javascript" />
					<script src="{$_base_res}js/html5.js?v={$_version_cache}" type="text/javascript" />
				</xsl:otherwise>
			</xsl:choose>

			<!--  matcht auf cstc:site und cstc:tao-tracking-pixel -->
			<xsl:apply-templates select="cstc:*"/>
		</div>
	</xsl:template>

	<xsl:template match="cstc:search-form[@layout=3]">
		<xsl:variable name="form_instance" select="generate-id()" />

		<site:cms-page-content-place template-content="content1_head" replace="all">
			<h1 class="cst-head">[%bgkrst.booking.header.h1]</h1>
			<h2>[%bgkrst.booking.header.h2]</h2>
		</site:cms-page-content-place>

		<div class="cst-book-container cst-book-container-{form/data_hotel/hotel_id} flex" id="cst-book-container-{$form_instance}"><div style="display:none">dummy</div><img src="{$_base_res}images/criterias-loading.gif" width="100" height="100" class="loading-placeholder" style="display: none" /><!-- book container --></div>

		<!--
		<script src="{$_base_res}js/jquery-1.2.3/jquery.js?version={$_version_cache}"></script>
		<script src="{$_base_res}js/jquery-1.1.3.1/jquery-history.js?version={$_version_cache}"></script>
		<script src="{$_base_res}js/jquery-1.1.3.1/jquery-custom.js?version={$_version_cache}"></script>
		<script src="{$_base_res}js/cst_calendar.js?version={$_version_cache}"></script>
		<script src="{$_base_res}js/cst_book.js?version={$_version_cache}"></script>
		<script src="{$_base_res}js/cst_i18n.js?version={$_version_cache}"></script>
		-->

		<script type="text/javascript">
			_lib_load( 'jQuery', 'jsoncookie', 'cst_helper', 'history', 'cst_book', 'Highslide', 'bgiframe', 'swfobject', 'jquery.json', 'vac'  );
			<!-- bei gutscheinen mit zeilenbeschr�nkung -->
			<xsl:if test="not(count(book-items/*[package-type=4]/properties/*[(property_name='cart_voucher_line_limit' or property_name='cart_voucher_char_limit') and property_value!=0])=0)">
				_lib_load( 'cst_textbox_limited' );
			</xsl:if>
		</script>

		<xsl:apply-templates select="//site:match-space/search-form-js-custom" />

		<script type="text/javascript">
			window.bc_<xsl:value-of select="$form_instance" /> = new cst_book_controller(
				document.getElementById( 'cst-book-container-<xsl:value-of select="$form_instance" />' ),
				'<xsl:value-of select="form/id_hotel" />',
				{
					hotel_id: '<xsl:value-of select="form/data_hotel/hotel_id" />',
					hotel_name: '<xsl:value-of select="form/data_hotel/hotel_name" />',
					hotel_nameaffix: '<xsl:value-of select="form/data_hotel/hotel_nameaffix" />',
					hotel_media_image: '<xsl:value-of select="form/data_hotel/hotel_media_image" />',
					hotel_media_logo: '<xsl:value-of select="form/data_hotel/hotel_media_logo" />',
					hotel_zip: '<xsl:value-of select="form/data_hotel/hotel_zip" />',
					hotel_city: '<xsl:value-of select="form/data_hotel/hotel_city" />',
					hotel_stars: '<xsl:value-of select="form/data_hotel/hotel_stars" />',
					hotel_tel: '<xsl:value-of select="form/data_hotel/hotel_telephone" />',
					<!--  nach dem server sync heisst die telephone, also gleich die nehmen :) -->
					hotel_telephone: '<xsl:value-of select="form/data_hotel/hotel_telephone" />',
					hotel_agb_url: '<xsl:value-of select="form/data_hotel/hotel_agb_url" />',
					<xsl:if test="form/data_hotel/hotel_setting_payment_types">
					hotel_setting_payment_types: <xsl:value-of select="form/data_hotel/hotel_setting_payment_types" />,
					</xsl:if>
					<xsl:if test="form/json_hotel_exchange_rate">
					exchange_rate: <xsl:value-of select="form/json_hotel_exchange_rate" />,
					</xsl:if>
					country_name: '<xsl:value-of select="form/data_hotel/country_name" />',
					country_id: '<xsl:value-of select="form/data_hotel/country_id" />'
				},
				{
					<xsl:apply-templates select="//site:match-space/booking/channel-settings">
						<xsl:with-param name="form" select="form" />
						<xsl:with-param name="settings" select="settings" />
					</xsl:apply-templates>
				},
				<xsl:choose><xsl:when test="//site:config/@hotel='false'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose>
				,<xsl:choose>
					<xsl:when test="channel-id and not(channel-id='')"><xsl:value-of select="channel-id" /></xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
				,{
						<xsl:for-each select="options/*">
							<xsl:value-of select="name(.)" />: '<xsl:value-of select="." />'
							<xsl:if test="position()!=last() or (position()=last() and count(params/*)!=0)">,</xsl:if>
						</xsl:for-each>
						<xsl:if test="count(params/*)!=0">
						params: {
							<xsl:for-each select="params/*">
								<xsl:value-of select="@name" />: '<xsl:value-of select="." />'
								<xsl:if test="position()!=last()">,</xsl:if>
							</xsl:for-each>
						}
						</xsl:if>
					}
			);
			<xsl:apply-templates select="//site:match-space/search-form-js-custom-instance">
				<xsl:with-param name="form_instance">bc_<xsl:value-of select="$form_instance" /></xsl:with-param>
			</xsl:apply-templates>
			bc_<xsl:value-of select="$form_instance" />.i18n.i18n_set( 'months', ['[%date.month.calendar.01;escape-single-quote]','[%date.month.calendar.02;escape-single-quote]','[%date.month.calendar.03;escape-single-quote]','[%date.month.calendar.04;escape-single-quote]','[%date.month.calendar.05;escape-single-quote]','[%date.month.calendar.06;escape-single-quote]','[%date.month.calendar.07;escape-single-quote]','[%date.month.calendar.08;escape-single-quote]','[%date.month.calendar.09;escape-single-quote]','[%date.month.calendar.10;escape-single-quote]','[%date.month.calendar.11;escape-single-quote]','[%date.month.calendar.12;escape-single-quote]'] );
			bc_<xsl:value-of select="$form_instance" />.i18n.i18n_set( 'weekdays', ['[%date.day.07;escape-single-quote]','[%date.day.01;escape-single-quote]','[%date.day.02;escape-single-quote]','[%date.day.03;escape-single-quote]','[%date.day.04;escape-single-quote]','[%date.day.05;escape-single-quote]','[%date.day.06;escape-single-quote]'] );
			bc_<xsl:value-of select="$form_instance" />.i18n.i18n_set( 'weekdays_short', ['[%date.shortday.07;escape-single-quote]','[%date.shortday.01;escape-single-quote]','[%date.shortday.02;escape-single-quote]','[%date.shortday.03;escape-single-quote]','[%date.shortday.04;escape-single-quote]','[%date.shortday.05;escape-single-quote]','[%date.shortday.06;escape-single-quote]'] );

			<xsl:variable name="privacy-link">
					<xsl:call-template name="privacy-link">
						<xsl:with-param name="url" select="form/data_hotel/hotel_url" />
					</xsl:call-template>
			</xsl:variable>

			bc_<xsl:value-of select="$form_instance" />.i18n.i18n_set(
				'book',
				{
					<xsl:apply-templates select="//site:match-space/booking/language-handles">
						<xsl:with-param name="form" select="form" />
					</xsl:apply-templates>
				}
			);

			bc_<xsl:value-of select="$form_instance" />.i18n.i18n_set(
			'bgkrst',
				{
					'txt_ecmaestro_hint': '[%bgkrst.txt_ecmaestro_hint]'
				}
			);

			<xsl:if test="book-items/*">
					<xsl:apply-templates select="//site:match-space/booking/book-items">
						<xsl:with-param name="book-items" select="book-items" />
						<xsl:with-param name="form_instance" select="$form_instance" />
					</xsl:apply-templates>
			</xsl:if>

			<xsl:if test="book-person-data/*">
				<xsl:for-each select="book-person-data/*">
					bc_<xsl:value-of select="$form_instance" />.booking_person_data_set( '<xsl:value-of select="@name" />', '<xsl:value-of select="." />');
				</xsl:for-each>
			</xsl:if>

			bc_<xsl:value-of select="$form_instance" />.controller_init( );
			bc_<xsl:value-of select="$form_instance" />.controller_init_custom( );
		</script>
		<script type="text/javascript">
			if( typeof hs != 'undefined' ) hs.maxHeight = 650;
		</script>
		<noscript><p>[%book.hint.javascript.required]</p></noscript>
	</xsl:template>

	<xsl:key name="key_coi_packages" match="cstc:package-teaser/package-indicators//coi_id" use="." />

	<xsl:template match="cstc:general-list[@type='package' and @item-type='1']">

		<site:cms-page-content-place template-content="content1_head" replace="none">
			<xsl:variable name="crits_hpa_indicator"><xsl:value-of select="../cstc:general-list-criterias/id_list_package_indicators" /></xsl:variable>
			<xsl:variable name="crits_hpa_indicator_url"><xsl:if test="$crits_hpa_indicator">c[id_list_package_indicators]=<xsl:value-of select="$crits_hpa_indicator" /></xsl:if></xsl:variable>
			<ul class="cst-hpa-links">
				<xsl:if test="$crits_hpa_indicator != ''">
					<li class="cst-hpa-link-back">
						<a class="cst-hpa-link" href="javascript:history.back()">��[%bgkrst.back.packages.overview]</a>
					</li>
				</xsl:if>
				<li class="cst-hpa-link-sort">
					<a class="cst-hpa-link" href="#" onclick="return false;">� [%bgkrst.sort.packages]</a>
					<ul class="cst-hpa-sort-menu">
						<li>
							<ul>
								<xsl:for-each select="../cstc:general-sidebar/boxes/cstc:box/cstc:package-box-criterias/ids_package_indicators/*[coi_visible=1 and coi_parent=$coi-packages]">
									<xsl:sort select="coi_name_str" data-type="text" order="ascending" />
									<li>
										<xsl:if test="$crits_hpa_indicator = ."><xsl:attribute name="class">active</xsl:attribute></xsl:if>
										<a href="package-list.php?c[id_list_package_indicators]={coi_id}"><xsl:value-of select="coi_name_str" /></a>
									</li>
								</xsl:for-each>
								<li>
									<xsl:if test="not( $crits_hpa_indicator ) or $crits_hpa_indicator = $coi-packages"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
									<a href="package-list.php?c[id_list_package_indicators]={$coi-packages}">[%bgkrst.all]</a>
								</li>
							</ul>
						</li>
					</ul>
				</li>
			</ul>
		</site:cms-page-content-place>

		<div class="cst-list cst-list-{@type}">
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
					<xsl:for-each select="*">
						<xsl:apply-templates select=".">
							<xsl:with-param name="pos" select="position()" />
						</xsl:apply-templates>
					</xsl:for-each>
					<xsl:call-template name="page-navigation"/>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="cstc:general-list[/site:site/site:cms/@template-content-name='block1'
	or /site:site/site:cms/@template-content-name='block2'
	or /site:site/site:cms/@template-content-name='block3'
	or /site:site/site:cms/@template-content-name='block4']">
		<xsl:variable name="id">packages_<xsl:value-of select="generate-id()" /></xsl:variable>
		<div id="{$id}">
			<ul class="slides">
				<xsl:choose>
					<xsl:when test="count(*)=0">
						<li class="cst-list cst-list-not-found">
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

						</li>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="*">
							<xsl:apply-templates select=".">
								<xsl:with-param name="pos" select="position()" />
							</xsl:apply-templates>
						</xsl:for-each>
						<xsl:if test="count(*) &gt; 1">
							<script type="text/javascript">
								jQuery( '#<xsl:value-of select="$id"/>' ).flexslider({
									animation: "slide",
									controlNav: false,
									prevText: "�",
									nextText: "�",
									slideshow: false
								});
							</script>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="cstc:packages-display-by-date[/site:site/site:cms/@template-content-name='block1' or /site:site/site:cms/@template-content-name='block2' or /site:site/site:cms/@template-content-name='block3' or /site:site/site:cms/@template-content-name='block4']">
	</xsl:template>

	<xsl:variable name="title_max_length">24</xsl:variable>

	<xsl:template match="cstc:package-teaser[/site:site/site:cms/@template-content-name='block1' or /site:site/site:cms/@template-content-name='block2' or /site:site/site:cms/@template-content-name='block3' or /site:site/site:cms/@template-content-name='block4']">
		<li class="slide cst-package-teaser">
			<xsl:variable name="title">
				<xsl:choose>
					<xsl:when test="package/custom-elements/variant-grouping/name">
						<xsl:value-of select="substring(package/custom-elements/variant-grouping/name,0, $title_max_length)" />
						<xsl:if test="string-length(package/custom-elements/variant-grouping/name)&gt; $title_max_length">�</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(package/hpa_name,0, $title_max_length)" />
						<xsl:if test="string-length(package/hpa_name)&gt; $title_max_length">�</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<h3><a title="{package/hpa_name}" href="{@url}"><xsl:value-of select="$title"/></a></h3>
			<a class="cst-image-link " href="{@url}" title="{$title}" style="background-image:url('{package/hpa_image}/225x153s');">&#160;</a>
		</li>
	</xsl:template>

	<xsl:template match="cstc:package-detail[/site:site/site:cms/@template-content-name='block1' or /site:site/site:cms/@template-content-name='block2' or /site:site/site:cms/@template-content-name='block3' or /site:site/site:cms/@template-content-name='block4']">
		<xsl:variable name="title">
			<xsl:call-template name="char-replace">
				<xsl:with-param name="string">
					<xsl:choose>
						<xsl:when test="package/custom-elements/variant-grouping/name"><xsl:value-of select="package/custom-elements/variant-grouping/name" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="package/hpa_name" /></xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
				<xsl:with-param name="needle">"</xsl:with-param>
				<xsl:with-param name="haystack"> </xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="src"><xsl:choose>
			<xsl:when test="count( cstc:media-usages/cstc:media-usage[@usage-type='embed'] ) &gt; 0">
				<xsl:value-of select="cstc:media-usages/cstc:media-usage[@usage-type='embed'][1]/media_url" /><xsl:text>/225x153s</xsl:text>
			</xsl:when>
			<xsl:when test="not(package/hpa_image=0)">
				<xsl:value-of select="package/hpa_image" /><xsl:text>/225x153s</xsl:text>
			</xsl:when>
		</xsl:choose></xsl:variable>

		<xsl:variable name="id">packages_<xsl:value-of select="generate-id()" /></xsl:variable>

		<div id="{$id}">
			<ul class="slides">
				<li class="slide cst-package-teaser">
					<xsl:variable name="title-short">
						<xsl:value-of select="substring($title,0, $title_max_length)" />
						<xsl:if test="string-length($title)&gt; $title_max_length">�</xsl:if>
					</xsl:variable>

					<h3><a title="{$title}" href="{@url}"><xsl:value-of select="$title-short"/></a></h3>
					<a class="cst-image-link " href="{@url}" title="{$title}" style="background-image:url('{$src}');">&#160;</a>
				</li>
			</ul>
		</div>

	</xsl:template>

	<xsl:template name="hrt-image-size">
		<xsl:param name="pos">0</xsl:param>
		<xsl:param name="total">0</xsl:param>
		<xsl:param name="return">size</xsl:param>
		<xsl:variable name="page"><xsl:if test="ceiling($pos div 3) = ceiling($total div 3)">last</xsl:if></xsl:variable>
		<xsl:choose>
			<xsl:when test="$return = 'class'">
				<xsl:if test="( $pos mod 3 ) = 1 and ( $total mod 3 ) = 1 and $page = 'last'"> fullwidth</xsl:if>
			</xsl:when>
			<xsl:when test="$return = 'size'">
				<xsl:choose>
					<xsl:when test="( $pos mod 3 ) = 1 and ( $total mod 3 ) = 1 and $page = 'last'">936x500</xsl:when>
					<xsl:when test="( $pos mod 3 ) = 1 and ( $total mod 3 ) != 1 and $page = 'last'">699x500</xsl:when>
					<xsl:when test="( $pos mod 3 ) = 1 and $page != 'last'">699x500</xsl:when>
					<xsl:when test="( $pos mod 3 ) = 2 and ( $total mod 3 ) = 2 and $page = 'last'">225x500</xsl:when>
					<xsl:when test="( $pos mod 3 ) = 2 and ( $total mod 3 ) != 2 and $page = 'last'">225x160</xsl:when>
					<xsl:when test="( $pos mod 3 ) = 2 and $page != 'last'">225x160</xsl:when>
					<xsl:when test="( $pos mod 3 ) = 0">225x328</xsl:when>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

<!--	<xsl:key name="hrt-indicator" match="/site:site/cstc:frame/cstc:site/cstc:roomtype-list/roomtype-groups//coi_name_str/text()" use="." /> -->

	<xsl:template match="cstc:roomtype-list">

		<site:cms-page-content-place template-content="content1_head" replace="all">
			<xsl:variable name="crit_coi_id" select="crits/id_list_roomtype_indicators" />
			<xsl:choose>
				<xsl:when test="$crit_coi_id">
					<xsl:variable name="hrti" select="(roomtype-groups/*/roomtypes/*)[1]/room-type/indicators/*[coi_id = $crit_coi_id]" />
					<h1 class="cst-head"><xsl:value-of select="$hrti/coi_name_str" /></h1>
					<h2>[%bgkrst.overview]</h2>
					<p><xsl:value-of select="$hrti/coi_teaser_str" /></p>
				</xsl:when>
				<xsl:otherwise>
					<h1 class="cst-head">[%bgkrst.our.rooms]</h1>
					<h2>[%bgkrst.overview]</h2>
				</xsl:otherwise>
			</xsl:choose>
		</site:cms-page-content-place>

		<site:cms-page-content-place template-content="content1_head" replace="none">
			<xsl:variable name="crits_hrt_group"><xsl:if test="crits/id_list_room_groups">c[id_list_room_groups]=<xsl:value-of select="crits/id_list_room_groups" />&amp;</xsl:if></xsl:variable>
			<xsl:variable name="crits_hrt_indicator"><xsl:if test="crits/id_list_roomtype_indicators">c[id_list_roomtype_indicators]=<xsl:value-of select="crits/id_list_roomtype_indicators" />&amp;</xsl:if></xsl:variable>
			<xsl:variable name="crits_hrt_price_sort"><xsl:choose>
				<xsl:when test="crits/price_sort">c[price_sort]=<xsl:value-of select="crits/price_sort" />&amp;</xsl:when>
				<xsl:otherwise>c[price_sort]=&amp;</xsl:otherwise>
			</xsl:choose></xsl:variable>

			<ul class="cst-hrt-links">
				<xsl:if test="$crits_hrt_group != '' or $crits_hrt_indicator != ''">
					<li class="cst-hrt-link-back">
						<a class="cst-hrt-link" href="javascript:history.back()">��[%bgkrst.back.rooms.overview]</a>
					</li>
				</xsl:if>
				<li class="cst-hrt-link-sort">
					<a class="cst-hrt-link" href="#" onclick="return false;">� [%bgkrst.sort.rooms]</a>
					<ul class="cst-hrt-sort-menu">
						<li>
							<h3>[%bgkrst.building]</h3>
							<ul>
<!--								<xsl:for-each select="roomtype-groups//coi_name_str/text()[generate-id() = generate-id(key('hrt-indicator',.)[1])]">
								</xsl:for-each> -->
								<li>
									<xsl:if test="crits/id_list_roomtype_indicators = $coi-lage-paradies"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
									<a href="hotel-room-list.php?{$crits_hrt_group}{$crits_hrt_price_sort}c[id_list_roomtype_indicators]={$coi-lage-paradies}">
										<xsl:text>Paradies</xsl:text>
									</a>
								</li>
								<li>
									<xsl:if test="crits/id_list_roomtype_indicators = $coi-lage-hochgrat"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
									<a href="hotel-room-list.php?{$crits_hrt_group}{$crits_hrt_price_sort}c[id_list_roomtype_indicators]={$coi-lage-hochgrat}">
										<xsl:text>Hochgrat</xsl:text>
									</a>
								</li>
								<li>
									<xsl:if test="crits/id_list_roomtype_indicators = $coi-lage-saentis"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
									<a href="hotel-room-list.php?{$crits_hrt_group}{$crits_hrt_price_sort}c[id_list_roomtype_indicators]={$coi-lage-saentis}">
										<xsl:text>S�ntis</xsl:text>
									</a>
								</li>
								<li>
									<xsl:if test="not( crits/id_list_roomtype_indicators )"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
									<a href="hotel-room-list.php?{$crits_hrt_group}{$crits_hrt_price_sort}">[%bgkrst.all]</a>
								</li>
							</ul>
						</li>
						<li>
							<h3>[%bgkrst.roomtype]</h3>
							<ul>
								<li>
									<xsl:if test="crits/id_list_room_groups = 364"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
									<a href="hotel-room-list.php?{$crits_hrt_indicator}{$crits_hrt_price_sort}c[id_list_room_groups]=364">[%bgk.hrt.groups.suites]</a>
								</li>
								<li>
									<xsl:if test="crits/id_list_room_groups = 363"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
									<a href="hotel-room-list.php?{$crits_hrt_indicator}{$crits_hrt_price_sort}c[id_list_room_groups]=363">[%bgk.hrt.groups.doublerooms]</a>
								</li>
								<li>
									<xsl:if test="crits/id_list_room_groups = 365"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
									<a href="hotel-room-list.php?{$crits_hrt_indicator}{$crits_hrt_price_sort}c[id_list_room_groups]=365">[%bgk.hrt.groups.apartments]</a>
								</li>
								<li>
									<xsl:if test="crits/id_list_room_groups = 362"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
									<a href="hotel-room-list.php?{$crits_hrt_indicator}{$crits_hrt_price_sort}c[id_list_room_groups]=362">[%bgk.hrt.groups.singlerooms]</a>
								</li>
								<li>
									<xsl:if test="not( crits/id_list_room_groups )"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
									<a href="hotel-room-list.php?{$crits_hrt_indicator}{$crits_hrt_price_sort}">[%bgkrst.all]</a>
								</li>
							</ul>
						</li>
						<li>
							<h3>[%txt.price]</h3>
							<ul>
								<li>
									<xsl:if test="crits/price_sort = 'up'"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
									<a href="hotel-room-list.php?{$crits_hrt_indicator}{$crits_hrt_group}c[price_sort]=up">[%bgkrst.price.ascending]</a>
								</li>
								<li>
									<xsl:if test="crits/price_sort = 'down'"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
									<a href="hotel-room-list.php?{$crits_hrt_indicator}{$crits_hrt_group}c[price_sort]=down">[%bgkrst.price.descending]</a>
								</li>
								<li>
									<xsl:if test="not( crits/price_sort ) or crits/price_sort = ''"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
									<a href="hotel-room-list.php?{$crits_hrt_indicator}{$crits_hrt_group}">[%bgkrst.price.cstorder]</a>
								</li>
							</ul>
						</li>
					</ul>
				</li>
			</ul>
		</site:cms-page-content-place>

<!--		zimmer zuordnen mit dem preise der billigste saison, auf- und absteigend -->
		<div class="cst-list cst-list-roomtype">
			<xsl:choose>
				<xsl:when test="crits/price_sort = 'up'">
					<xsl:for-each select="roomtype-groups/*/roomtypes/*">
						<xsl:sort select="prices/season-groups/season-group/@price-int[ not( . &gt; ../../season-group/@price-int ) ][1]" data-type="number" order="ascending" />
						<xsl:apply-templates select="/site:site/site:match-space/hotel/rooms/teaser">
							<xsl:with-param name="room" select="." />
						</xsl:apply-templates>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="crits/price_sort = 'down'">
					<xsl:for-each select="roomtype-groups/*/roomtypes/*">
						<xsl:sort select="prices/season-groups/season-group/@price-int[ not( . &gt; ../../season-group/@price-int ) ][1]" data-type="number" order="descending" />
						<xsl:apply-templates select="/site:site/site:match-space/hotel/rooms/teaser">
							<xsl:with-param name="room" select="." />
						</xsl:apply-templates>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="roomtype-groups/*/roomtypes/*">
						<xsl:sort select="room-type/hrt_order" data-type="number" order="ascending" />
						<xsl:apply-templates select="/site:site/site:match-space/hotel/rooms/teaser">
							<xsl:with-param name="room" select="." />
						</xsl:apply-templates>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="/site:site/site:match-space/hotel/rooms/teaser">
		<xsl:param name="room" />
		<xsl:param name="class" />
		<xsl:variable name="src"><xsl:choose>
			<xsl:when test="not($room/room-type/hrt_image=0)">
				<xsl:value-of select="$room/room-type/hrt_image" />
			</xsl:when>
			<xsl:when test="$room/room-type/hrt_image=0 and $room/room-type/hrt_image_plan!=0">
				<xsl:value-of select="$room/room-type/hrt_image_plan" />
			</xsl:when>
		</xsl:choose></xsl:variable>
		<div id="cst-box-room-type-{$room/room-type/hrt_id}" class="cst-box {$class}">
			<xsl:if test="not($src='')">
				<div class="cst-media">
					<xsl:attribute name="style">background-image:url(<xsl:value-of select="$src" />/462x462s);</xsl:attribute>
					<a href="{$room/@url}" title="{$room/room-type/hrt_name}">&#160;</a>
				</div>
			</xsl:if>
			<div class="cst-box-content">
				<xsl:apply-templates select="/site:site/site:match-space/hotel/rooms/content">
					<xsl:with-param name="room" select="$room"/>
				</xsl:apply-templates>
				<ul class="cst-links">
					<xsl:call-template name="cstc:button">
						<xsl:with-param name="type">detail</xsl:with-param>
						<xsl:with-param name="url"><xsl:value-of select="$room/@url"/></xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="cstc:button">
						<xsl:with-param name="type">request</xsl:with-param>
						<xsl:with-param name="url"><xsl:value-of select="$room/@url-request"/></xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="cstc:button">
						<xsl:with-param name="type">book</xsl:with-param>
						<xsl:with-param name="url">search.php?book_item[]=hrt_<xsl:value-of select="$room/room-type/hrt_id"/>,step_skip:20&amp;c[ids_hotels][]=<xsl:value-of select="$room/room-type/hrt_hotel"/></xsl:with-param>
						<!--<xsl:value-of select="$room/@url-booking"/>-->
					</xsl:call-template>
				</ul>
			</div>
			<div class="clearfix"></div>
		</div>
	</xsl:template>

	<xsl:template match="/site:site/site:match-space/hotel/rooms/content" name="bgk-roomtype-content">
		<xsl:param name="room" />

		<div class="cst-hrt-title">
			<div class="cst-hrt-indicator"><xsl:value-of select="$room/room-type/indicators/*[coi_parent = $coi-lage]/coi_name_str" /></div>
			<xsl:call-template name="cstc:headline">
				<xsl:with-param name="type">3</xsl:with-param>
				<xsl:with-param name="title" select="$room/room-type/hrt_name" />
				<xsl:with-param name="class">cst cst-list-roomtype</xsl:with-param>
				<xsl:with-param name="href"><xsl:value-of select="$room/@url"/></xsl:with-param>
			</xsl:call-template>
			<div class="separator"></div>
		</div>
		<div class="cst-hrt-teaser">
			<div class="cst-teaser-text">
				<xsl:call-template name="cstc:formatted-text">
					<xsl:with-param name="text-node" select="$room/room-type/hrt_desc_teaser"/>
				</xsl:call-template>
			</div>
			<div class="cst-extra-infos">
				<div class="cst-alloc">
					<xsl:call-template name="hrt_alloc">
						<xsl:with-param name="hrt_alloc_min" select="$room/room-type/hrt_alloc_min" />
						<xsl:with-param name="hrt_alloc_max" select="$room/room-type/hrt_alloc_max" />
					</xsl:call-template>
				</div>

				<xsl:apply-templates select="/site:site/site:match-space/hotel/rooms/price">
					<xsl:with-param name="room" select="$room"/>
					<xsl:with-param name="price-type" select="$room/room-type/hrt_price_type" />
				</xsl:apply-templates>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="hrt_alloc">
		<xsl:param name="hrt_alloc_min">0</xsl:param>
		<xsl:param name="hrt_alloc_max">0</xsl:param>
		<xsl:param name="txt_person"><xsl:choose>
			<xsl:when test="$hrt_alloc_max = 1">[%txt.person]</xsl:when>
			<xsl:otherwise>[%txt.persons]</xsl:otherwise>
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
	</xsl:template>

	<xsl:template match="/site:site/site:match-space/hotel/rooms/price" name="bgk-roomtype-price">
		<xsl:param name="room"/>
		<xsl:param name="price-type" />
		<xsl:variable name="currency" select="/site:site/site:config/@currency-sign" />

		<xsl:if test="$room/prices/season-groups/*[@price-int] or $room/hrt_price_from_int or $room/hrt_price_from_int or $room/room-type/hrt_price_from_int">
			<xsl:choose>
				<!-- Teaser -->
				<xsl:when test="$room/room-type/hrt_price_from_int &gt; 0">
					<div class="cst-price">
						<span class="cst-price-from">[%txt.from]<xsl:text> </xsl:text></span>
						<span class="cst-price-number">
							<xsl:value-of select="$room/room-type/hrt_price_from_int" />
							<xsl:value-of select="$currency" />
						</span><xsl:text> </xsl:text>
						<span class="cst-price-per-person">[%bgkrst.perperson] [%bgkrst.roomtype.price.hint]</span>
					</div>
				</xsl:when>
				<!-- Detail -->
				<xsl:when test="$room/hrt_price_from_int &gt; 0">
					<div class="cst-price">
						<span class="cst-price-from">[%txt.from]</span><xsl:text> </xsl:text>
						<span class="cst-price-number"><xsl:value-of select="$room/hrt_price_from" /></span><xsl:text> </xsl:text>
						<!-- <span class="cst-price-per-person">[%bgkrst.perperson]</span> -->
					</div>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="$room/prices/season-groups/*">
						<xsl:sort select="@price-int" order="ascending" data-type="number"/>
						<xsl:if test="position()=1">
							<div class="cst-price">
								<span class="cst-price-from">[%txt.from]</span><xsl:text> </xsl:text>
								<span class="cst-price-number">
									<xsl:value-of select="format-number( number(@price-int), '0.##' )" />
									<xsl:text> </xsl:text>
									<xsl:value-of select="$currency" />
								</span><xsl:text> </xsl:text>
								<span class="cst-price-per-person">
									<xsl:if test="$price-type=1 or $price-type=3 or $price-type=4">[%bgkrst.perperson] [%bgkrst.roomtype.price.hint]</xsl:if>
									<xsl:if test="$price-type=2">[%txt.price.perroom.short] [%bgkrst.roomtype.price.hint]</xsl:if>
									<!--<xsl:if test="../hrt_price_type=1 or ../hrt_price_type=3"></xsl:if>-->
								</span>
							</div>
						</xsl:if>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="cstc:roomtype-detail">
		<xsl:variable name="roomtype-image-total" select="count( room-type/hrt_image[../hrt_image != 0] ) + count( cstc:media-usages/cstc:media-usage[@usage-type='embed'] )" />
		<xsl:variable name="title">
			<xsl:call-template name="char-replace">
				<xsl:with-param name="string" select="room-type/hrt_name" />
				<xsl:with-param name="needle">"</xsl:with-param>
				<xsl:with-param name="haystack"> </xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<site:cms-page-content-place template-content="content1_head" replace="all">
			<h1 class="cst-head">
				<xsl:value-of select="room-type/indicators/*[coi_parent = $coi-lage]/coi_name_str" />
			</h1>
			<h2><xsl:value-of select="room-type/hrt_name" /></h2>
		</site:cms-page-content-place>
		<site:cms-page-content-place template-content="content1_head" replace="none">
			<xsl:variable name="url">/(cms)/module/pass/3/redir-struct/88917/<xsl:value-of select="/site:site/site:config/@language-str" /></xsl:variable>
			<ul class="cst-hrt-links">
				<li class="cst-link-back cst-hrt-link-back"><a href="{$url}" class="cst-hrt-link">
					<span class="default">�</span>
					<span class="mobile">�</span>
					<xsl:text> [%bgkrst.back.rooms.overview]</xsl:text>
				</a></li>
			</ul>
		</site:cms-page-content-place>

		<div class="cst-detail cst-detail-roomtype" id="cst-detail-roomtype-{room-type/hrt_id}">
			<xsl:if test="not(room-type/hrt_image=0) or count( cstc:media-usages/cstc:media-usage[@usage-type='embed'] ) &gt; 0">
				<xsl:variable name="id">cst-roomtype-gallery-<xsl:value-of select="generate-id()" /></xsl:variable>
				<div class="cst-roomtype-gallery" id="{$id}">
					<xsl:variable name="imageindex">
						<xsl:choose>
							<xsl:when test="room-type/hrt_image = 0">0</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
<!--					<xsl:text disable-output-escaping="yes">&lt;div class="cst-roomtype-gallery-item"&gt;</xsl:text> -->
					<xsl:if test="not(room-type/hrt_image=0)">
						<xsl:variable name="src">
							<xsl:value-of select="room-type/hrt_image" /><xsl:text>/</xsl:text>
							<xsl:call-template name="hrt-image-size">
								<xsl:with-param name="pos">1</xsl:with-param>
								<xsl:with-param name="total" select="$roomtype-image-total" />
							</xsl:call-template>
							<xsl:text>s</xsl:text>
						</xsl:variable>
						<img src="{$src}" alt="{$title}">
							<xsl:attribute name="class">
								<xsl:text>pos1</xsl:text>
								<xsl:call-template name="hrt-image-size">
									<xsl:with-param name="pos">1</xsl:with-param>
									<xsl:with-param name="total" select="$roomtype-image-total" />
									<xsl:with-param name="return">class</xsl:with-param>
								</xsl:call-template>
							</xsl:attribute>
						</img>
					</xsl:if>
					<xsl:for-each select="cstc:media-usages/cstc:media-usage[@usage-type='embed' and ( position() + $imageindex ) &lt;= 3 ]">
						<xsl:variable name="src">
							<xsl:value-of select="media_url" /><xsl:text>/</xsl:text>
							<xsl:call-template name="hrt-image-size">
								<xsl:with-param name="pos" select="position() + $imageindex" />
								<xsl:with-param name="total" select="$roomtype-image-total" />
							</xsl:call-template>
							<xsl:text>s</xsl:text>
						</xsl:variable>
						<img src="{$src}" alt="{$title}">
							<xsl:attribute name="class">
								<xsl:text>pos</xsl:text><xsl:value-of select="( position() + $imageindex ) mod 3" />
								<xsl:call-template name="hrt-image-size">
									<xsl:with-param name="pos" select="position() + $imageindex" />
									<xsl:with-param name="total" select="$roomtype-image-total" />
									<xsl:with-param name="return">class</xsl:with-param>
								</xsl:call-template>
							</xsl:attribute>
						</img>
<!--						<xsl:if test="( position() + $imageindex ) mod 3 = 0 and position() != last()"><xsl:text disable-output-escaping="yes">&lt;/div&gt;&lt;div class="cst-roomtype-gallery-item"&gt;</xsl:text></xsl:if> -->
					</xsl:for-each>
					<div class="clearfix"></div>
<!--					<xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text> -->
				</div>
<!--				<xsl:if test="$roomtype-image-total &gt; 3">
					<script type="text/javascript">
						jQuery( '#<xsl:value-of select="$id"/>' ).vjg2({
							type:		'html',
							autostart: true,
							resizeable: true,
							dimensions: {
								container: {
									ratio: 1.872,
									max: {
										width: 936
									}
								}
							}
						});
					</script>
				</xsl:if> -->
			</xsl:if>

			<div class="cst-box-content flex">
				<div class="cst-hrt-row">
					<div class="cst-hrt-col cst-hrt-col1">
						<div class="cst-hrt-infos">
							<h3>[%txt.room.size]:</h3>
							<p>
								<xsl:if test="room-type/hrt_room_size != '0'">
									<span class="cst-hrt-surface"><xsl:value-of select="room-type/hrt_room_size" />m�</span><span class="cst-hrt-separator"><xsl:text> / </xsl:text></span>
								</xsl:if>
								<span class="cst-hrt-alloc"><xsl:call-template name="hrt_alloc">
									<xsl:with-param name="hrt_alloc_min" select="room-type/hrt_alloc_min" />
									<xsl:with-param name="hrt_alloc_max" select="room-type/hrt_alloc_max" />
									<xsl:with-param name="txt_person">[%bgkrst.person.abrev]</xsl:with-param>
								</xsl:call-template></span>
							</p>
							<h3>[%bgkrst.roomtype]:</h3>
							<p>
								<xsl:value-of select="room-type/hrt_group_name" />
							</p>
						</div>

						<ul class="cst-links">
							<li><a href="#" onclick="jQuery( '#hrt-{room-type/hrt_id}-images').children('a:first-child').trigger('click');return false">[%txt.gallery]</a></li>
							<xsl:choose>
								<xsl:when test="room-type/hrt_id = 19759"><!-- hotel-zimmer-19759-wellness-suite-falken.html -->
									<li>
										<!--<a href="http://api.silberstern.net/ondemand.php?mode=query&amp;id=105-4-5561" onclick="return hs.htmlExpand(this, {{ width: 620, height: 365, objectType: 'iframe'}} )">[%bgkrst.room.video]</a>-->
										<a href="http://api.silberstern.net/ondemand.php?mode=query&amp;id=105-4-5561" class="fancybox"
										   data-width="576" data-height="324" data-fancybox-type="iframe">[%bgkrst.room.video]</a>
									</li>
								</xsl:when>
								<xsl:when test="room-type/hrt_id = 19760"><!-- hotel-zimmer-19760-wellness-suite-adlerhorst.html -->
									<li>
										<!--<a href="http://api.silberstern.net/ondemand.php?mode=query&amp;id=105-4-6038" onclick="return hs.htmlExpand(this, {{ width: 620, height: 365, objectType: 'iframe'}} )">[%bgkrst.room.video]</a>-->
										<a href="http://api.silberstern.net/ondemand.php?mode=query&amp;id=105-4-6038"  class="fancybox"
										   data-width="576" data-height="324" data-fancybox-type="iframe">[%bgkrst.room.video]</a>
									</li>
								</xsl:when>
							</xsl:choose>
							<xsl:if test="not(room-type/hrt_image_plan=0)">
								<li><a href="#" onclick="jQuery( '#hrt-{room-type/hrt_id}-plan').children('a:first-child').trigger('click');return false">[%bgkrst.plan]</a></li>
							</xsl:if>
							<li>
								<a href="#" onclick="return hs.htmlExpand( this, {{ width: Math.min( 960, jQuery( document ).width() * 0.8 ) }} )">[%bgkrst.roomsoverview]</a>
								<div style="display:none" class="highslide-maincontent">
									<xsl:call-template name="svg-graphics">
										<xsl:with-param name="id">aerial-view</xsl:with-param>
									</xsl:call-template>
								</div>
							</li>
						</ul>
					</div>

					<div class="cst-hrt-col cst-hrt-col3">
						<xsl:apply-templates select="room-type/cstc:roomtype-prices">
							<xsl:with-param name="prices" select="room-type/prices" />
							<xsl:with-param name="price-type" select="room-type/hrt_price_type" />
							<xsl:with-param name="display-cols" select="@display-cols" />
						</xsl:apply-templates>
						<ul class="cst-buttons">
							<xsl:call-template name="cstc:button">
								<xsl:with-param name="type">request</xsl:with-param>
							</xsl:call-template>
							<xsl:call-template name="cstc:button">
								<xsl:with-param name="type">book</xsl:with-param>
								<xsl:with-param name="url">search.php?book_item[]=hrt_<xsl:value-of select="room-type/hrt_id"/>,step_skip:20&amp;c[ids_hotels][]=<xsl:value-of select="room-type/hrt_hotel"/></xsl:with-param>
							</xsl:call-template>
						</ul>
					</div>
				</div>

				<div class="cst-hrt-col cst-hrt-col2">
					<div class="cst-description-text">
						<h3>[%bgkrst.short.description]</h3>
						<xsl:call-template name="cstc:formatted-text">
							<xsl:with-param name="text-node" select="room-type/hrt_desc_cms"/>
						</xsl:call-template>
					</div>
				</div>

				<div class="cst-see-also">
					<!--[%bgkrst.hrt.hint]-->
				</div>

				<div class="cst-back-mobile">
					<ul class="cst-hrt-links">
						<li class="cst-link-back cst-hrt-link-back"><a href="./" class="cst-hrt-link">
							<span class="default">�</span>
							<span class="mobile">�</span>
							<xsl:text> [%bgkrst.back.rooms.overview]</xsl:text>
						</a></li>
					</ul>
				</div>
			</div>

			<div style="display:none" id="hrt-{room-type/hrt_id}-images">
				<xsl:variable name="slideshowGroup">hrt<xsl:value-of select="room-type/hrt_id"/>_images</xsl:variable>
				<script type="text/javascript">_lib_load('Highslide')</script>
				<script type="text/javascript">highslide_group_add('<xsl:value-of select="$slideshowGroup" />')</script>
				<xsl:variable name="onclick">return hs.expand( this, { numberPosition: 'caption', slideshowGroup: '<xsl:value-of select="$slideshowGroup" />', wrapperClassName: 'in-page controls-in-heading' })</xsl:variable>
				<xsl:if test="not(room-type/hrt_image=0)">
					<a href="{room-type/hrt_image}/1280x0s" thumb="{room-type/hrt_image}/50x0s" onclick="{$onclick}"/>
				</xsl:if>
				<xsl:for-each select="cstc:media-usages/cstc:media-usage[@usage-type='embed']">
					<a href="{media_url}/1280x0s" thumb="{media_url}/50x0s" onclick="{$onclick}"/>
				</xsl:for-each>
			</div>

			<xsl:if test="not(room-type/hrt_image=0)">
				<div style="display:none" id="hrt-{room-type/hrt_id}-plan">
					<a href="{room-type/hrt_image_plan}/1280x0s" thumb="{room-type/hrt_image_plan}/50x0s" onclick="return hs.expand( this )"/>
				</div>
			</xsl:if>
		</div>
		<script type="text/javascript">
			if( typeof hs != 'undefined' ) hs.maxHeight = 695;
		</script>
	</xsl:template>

	<xsl:template match="cstc:roomtype-prices">
		<xsl:param name="prices" />
		<xsl:param name="price-type" />
		<xsl:param name="display-cols">4</xsl:param>
		<div class="cst-detail-prices cst-detail-prices-parents">
			<xsl:call-template name="cstc:headline">
				<xsl:with-param name="type">3</xsl:with-param>
				<xsl:with-param name="title">
					<xsl:if test="$price-type=1 or $price-type=3 or $price-type=4">[%txt.price.stay.adult/<xsl:value-of select="//site:config/@currency" />] [%bgkrst.roomtype.price.hint]</xsl:if>
					<xsl:if test="$price-type=2">[%txt.price.room.adult/<xsl:value-of select="//site:config/@currency" />] [%bgkrst.roomtype.price.hint]</xsl:if>
					<!--<xsl:if test="../hrt_price_type=1 or ../hrt_price_type=3"></xsl:if>-->
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

	<xsl:template match="cstc:roomtype-prices-parents">
		<xsl:param name="prices" />
		<xsl:param name="price-type" />
		<xsl:param name="display-cols">2</xsl:param>
		<xsl:variable name="pensionid" select="../../@pension-id"/>
		<xsl:variable name="id">hrt_prices_<xsl:value-of select="generate-id()" /></xsl:variable>
		<script type="text/javascript">_lib_load('qtip')</script>

		<xsl:if test="count( $prices/season-groups/* ) &gt; 0">
			<xsl:if test="$prices/season-group-unique-date-froms/*[2]">
				<div class="cst-hrt-prices-nav">
					<a href="#" class="nav-prev" id="{$id}_prev">� [%search.cal.nav.prev]</a>
					<a href="#" class="nav-next" id="{$id}_next">[%search.cal.nav.next] �</a>
				</div>
			</xsl:if>
			<div class="cst-hrt-prices" id="{$id}">
				<xsl:for-each select="$prices/season-group-unique-date-froms/*">
					<xsl:variable name="date_from_ts" select="@timestamp" />
					<div class="season">
						<xsl:attribute name="data-length"><xsl:value-of select="count( $prices/season-groups/*/*/season[hs_from_ts = $date_from_ts] )" /></xsl:attribute>
						<table class="cst-price">
							<tr><th>[%txt.date.from]:</th><td><xsl:value-of select="." /></td></tr>
							<tr><th>[%txt.date.to]:</th><td><xsl:value-of select="$prices/season-groups/*/*/season[hs_from_ts = $date_from_ts]/hs_to" /></td></tr>
							<xsl:for-each select="$prices/season-groups/*/*/season[hs_from_ts = $date_from_ts]">
								<xsl:sort select="hs_stays_min + ( 0.01 * number( hs_stays_max ))" data-type="number" order="ascending" />
								<xsl:variable name="nights_separator"><xsl:choose>
									<xsl:when test="/site:site/site:config/@language-str = 'de'"><xsl:text> �N</xsl:text></xsl:when>
									<xsl:when test="/site:site/site:config/@language-str = 'en'"><xsl:text> nights</xsl:text></xsl:when>
								</xsl:choose></xsl:variable>
								<xsl:variable name="season_extension" select="substring-after( hs_name_public_str, $nights_separator )" />
								<tr>
									<th>
										<xsl:if test="string-length( $season_extension ) &gt; 0"><xsl:attribute name="class">has-qtip</xsl:attribute></xsl:if>
										<span class="season-title">
											<xsl:value-of select="substring-before( hs_name_public_str, $nights_separator )" /><xsl:text> [%bgkrst.nights.abrev]</xsl:text>
											<xsl:if test="string-length( $season_extension ) &gt; 0"><xsl:text> *</xsl:text></xsl:if>
										</span>
										<div class="qtip" style="display:none;"><xsl:value-of select="$season_extension" /></div>
									</th>
									<td>
										<xsl:value-of select="alloc-prices/*[@alloc = $prices/../hrt_alloc_def]/@price" />
									</td>
								</tr>
							</xsl:for-each>
						</table>
					</div>
				</xsl:for-each>
			</div>
			<script type="text/javascript">_lib_load('vjg2');</script>
			<script type="text/javascript">
				var pricescroller = jQuery( '#<xsl:value-of select="$id"/>' );
				pricescroller.find( 'th.has-qtip span' ).each( function(){
					jQuery(this).qtip({
						content: jQuery(this).siblings('.qtip').html()
					});
				});
				<xsl:if test="$prices/season-group-unique-date-froms/*[2]">
					var pricescroller_width = pricescroller.width();
					var pricescroller_lines = ( 2 + Math.max.apply(null, pricescroller.find('.season').map( function(){ return jQuery( this ).attr('data-length'); }).get() ) );
					pricescroller.vjg2({
						effect:	'scroll',
						type:	'html',
						autostart:	false,
						resizeable: true,
						dimensions: {
							container: {
								ratio: pricescroller_width/(24*pricescroller_lines),
								max: {
									width: pricescroller_width,
									height: 24*pricescroller_lines
								}
							}
						},
						links: {
							prev: '#<xsl:value-of select="$id"/>_prev',
							next: '#<xsl:value-of select="$id"/>_next'
						}
					});
				</xsl:if>
			</script>
		</xsl:if>
	</xsl:template>

	<xsl:template match="cstc:package-teaser">
		<xsl:param name="pos"/>
		<div id="cst-box-package-{package/hpa_id}" class="cst-box">
			<xsl:if test="$pos mod 2 = 0">
				<xsl:attribute name="class">cst-box cst-box-even</xsl:attribute>
			</xsl:if>

			<xsl:variable name="src"><xsl:if test="not(package/hpa_image=0) and /site:site/site:config/@list-images='true'">
				<xsl:value-of select="package/hpa_image" />
			</xsl:if></xsl:variable>

			<xsl:if test="not($src='')">
				<div class="cst-media">
					<xsl:attribute name="style">background-image:url(<xsl:value-of select="$src" />/462x462s);</xsl:attribute>
					<a href="{@url}" title="{package/hpa_name}">&#160;</a>
				</div>
			</xsl:if>

			<div class="cst-box-content">
				<xsl:apply-templates select="/site:site/site:match-space/hotel/packages/content">
					<xsl:with-param name="package" select="."/>
				</xsl:apply-templates>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="/site:site/site:match-space/hotel/packages/content">
		<xsl:param name="package"/>

		<div class="cst-hpa-title">
			<div class="cst-hrt-indicator"><xsl:value-of select="$package/package-indicators/*[coi_parent = $coi-packages]/coi_name_str" /></div>
			<xsl:call-template name="cstc:headline">
				<xsl:with-param name="type">3</xsl:with-param>
				<xsl:with-param name="title">
					<xsl:choose>
						<xsl:when test="$package/package/custom-elements/variant-grouping/name"><xsl:value-of select="$package/package/custom-elements/variant-grouping/name" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="$package/package/hpa_name" /></xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
				<xsl:with-param name="class">cst cst-list-package</xsl:with-param>
				<xsl:with-param name="href"><xsl:value-of select="$package/package/@url"/></xsl:with-param>
			</xsl:call-template>
			<div class="separator"></div>
		</div>

		<div class="cst-hpa-teaser">
			<div class="cst-teaser-text">
				<xsl:call-template name="cstc:formatted-text">
					<xsl:with-param name="text-node" select="$package/package/hpa_teaser" />
				</xsl:call-template>
			</div>
			<div class="cst-extra-infos">
				<div class="cst-stays">
					<xsl:value-of select="$package/avail/stays" /> [%txt.stays.numerus/<xsl:value-of select="$package/avail/stays" />]
				</div>
				<div class="cst-date">
					<xsl:for-each select="$package/package/tf-avail/*">
						<xsl:value-of select="ht_from_display" /><xsl:text> - </xsl:text><xsl:value-of select="ht_to_display" />
						<xsl:if test="position() != last()"><br /></xsl:if>
					</xsl:for-each>
				</div>
			</div>
		</div>

		<ul class="cst-links">
			<li class="cst-button-detail">
				<a href="{$package/package/@url}">[%package.tooffer]</a>
			</li>
		</ul>
	</xsl:template>

	<xsl:template match="cstc:package-detail">
		<xsl:variable name="roomtype-image-total" select="count( package/hpa_image[../hpa_image != 0] ) + count( cstc:media-usages/cstc:media-usage[@usage-type='embed'] )" />
		<xsl:variable name="title">
			<xsl:call-template name="char-replace">
				<xsl:with-param name="string">
					<xsl:choose>
						<xsl:when test="package/custom-elements/variant-grouping/name"><xsl:value-of select="package/custom-elements/variant-grouping/name" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="package/hpa_name" /></xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
				<xsl:with-param name="needle">"</xsl:with-param>
				<xsl:with-param name="haystack"> </xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<site:cms-page-content-place template-content="content1_head" replace="all">
			<xsl:variable name="package_coi" select="package/package-indicators/*[coi_parent = $coi-packages]/coi_name_str" />
			<xsl:choose>
				<xsl:when test="string-length( $package_coi ) &gt; 1">
					<h1 class="cst-head"><xsl:value-of select="package/package-indicators/*[coi_parent = $coi-packages]/coi_name_str" /></h1>
					<h2>
						<xsl:choose>
							<xsl:when test="package/custom-elements/variant-grouping/name"><xsl:value-of select="package/custom-elements/variant-grouping/name" /></xsl:when>
							<xsl:otherwise><xsl:value-of select="package/hpa_name" /></xsl:otherwise>
						</xsl:choose>
					</h2>
				</xsl:when>
				<xsl:otherwise>
					<h1 class="cst-head">
						<xsl:choose>
							<xsl:when test="package/custom-elements/variant-grouping/name"><xsl:value-of select="package/custom-elements/variant-grouping/name" /></xsl:when>
							<xsl:otherwise><xsl:value-of select="package/hpa_name" /></xsl:otherwise>
						</xsl:choose>
					</h1>
				</xsl:otherwise>
			</xsl:choose>
		</site:cms-page-content-place>

		<site:cms-page-content-place template-content="content1_head" replace="none">
			<ul class="cst-hrt-links">
				<li class="cst-link-back cst-hrt-link-back"><a href="./" class="cst-hrt-link">
					<span class="default">�</span>
					<span class="mobile">�</span>
					<xsl:text> [%bgkrst.back.packages.overview]</xsl:text>
				</a></li>
			</ul>
		</site:cms-page-content-place>

		<div class="cst-detail cst-detail-package" id="cst-detail-package-{package/hpa_id}">
			<xsl:if test="not(package/hpa_image=0) or count( cstc:media-usages/cstc:media-usage[@usage-type='embed'] ) &gt; 0">
				<xsl:variable name="id">cst-package-gallery-<xsl:value-of select="generate-id()" /></xsl:variable>
				<div class="cst-package-gallery" id="{$id}">
					<xsl:choose>
						<xsl:when test="count( cstc:media-usages/cstc:media-usage[@usage-type='embed'] ) &gt; 0">
							<xsl:variable name="src">
								<xsl:value-of select="cstc:media-usages/cstc:media-usage[@usage-type='embed'][1]/media_url" /><xsl:text>/960x500s</xsl:text>
							</xsl:variable>
							<img src="{$src}" alt="secondary {$title}" />
						</xsl:when>
						<xsl:when test="not(package/hpa_image=0)">
							<xsl:variable name="src">
								<xsl:value-of select="package/hpa_image" /><xsl:text>/960x500s</xsl:text>
							</xsl:variable>
							<img src="{$src}" alt="{$title}" />
						</xsl:when>
					</xsl:choose>
				</div>
			</xsl:if>

			<div class="cst-box-content flex">
				<div class="cst-hpa-row">
					<div class="cst-hpa-col cst-hpa-col1">
						<div class="cst-hpa-infos">
<!--
							<h3 class="new-info-text">[%txt.price.perperson.short]</h3>
-->
							<h3 class="new-info-text">[%bgkrst.package-detail.pricephrase]</h3>
							<p>
								<xsl:for-each select="package-room-types/*">
									<div class="cst-hpa-roomtypes">
										<span class="price">
											<xsl:value-of select="format-number( number(hpapr_price_sum_int), '0.##' )" />
											<xsl:text> </xsl:text>
											<xsl:value-of select="/site:site/site:config/@currency-sign" />
										</span>
										<span class="name">
											<xsl:value-of select="hrt_name" />
										</span>
									</div>
								</xsl:for-each>
							</p>
						</div>
					</div>

					<div class="cst-hpa-col cst-hpa-col3">
						<div class="cst-detail-prices cst-detail-prices-parents">
							<xsl:call-template name="cstc:headline">
								<xsl:with-param name="type">3</xsl:with-param>
								<xsl:with-param name="title"><xsl:choose>
									<xsl:when test="count( package/tf-avail/* ) &gt; 1">[%txt.timeframes]</xsl:when>
									<xsl:otherwise>[%txt.timeframe]</xsl:otherwise>
								</xsl:choose></xsl:with-param>
								<xsl:with-param name="class">cst cst-detail-prices</xsl:with-param>
							</xsl:call-template>

							<div class="cst-hpa-prices">
								<div class="season">
									<table class="cst-price">
										<xsl:for-each select="package/tf-avail/*">
											<tr><th>[%txt.date.from]:<br />[%txt.date.to]:</th><td><xsl:value-of select="ht_from_display" /><br /><xsl:value-of select="ht_to_display" /></td></tr>
										</xsl:for-each>
									</table>
								</div>
							</div>
						</div>

						<ul class="cst-buttons">
							<!-- <xsl:call-template name="cstc:button">
								<xsl:with-param name="type">request</xsl:with-param>
							</xsl:call-template> -->
							<xsl:call-template name="cstc:button">
								<xsl:with-param name="type">book</xsl:with-param>
								<xsl:with-param name="title">[%bgkrst.book]</xsl:with-param>
							</xsl:call-template>
						</ul>
					</div>
				</div>

				<div class="cst-hpa-col cst-hpa-col2">
					<div class="cst-description-text">
						<h3>[%bgkrst.short.description]</h3>
						<div class="cst-hpa-detail-teaser">
							<xsl:call-template name="cstc:formatted-text">
								<xsl:with-param name="text-node" select="package/hpa_teaser"/>
							</xsl:call-template>
						</div>
						<div class="cst-hpa-desc">
							<xsl:call-template name="cstc:formatted-text">
								<xsl:with-param name="text-node" select="package/hpa_desc"/>
							</xsl:call-template>
						</div>
					</div>
				</div>

				<div class="cst-see-also">
					<!--Dies k�nnte Ihnen ebenfalls gefallen:-->
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="cstc:user-request-add[@page=1 and @type = 2]">
		<site:cms-page-content-place template-content="content1_head" replace="all">
			<h1 class="cst-head">[%txt.request]</h1>
		</site:cms-page-content-place>

		<form method="post" action="{$_self}?page=2.page2&amp;hotel_id={@hotel_id}" name="form" id="cst-request-form">
		<div class="cst-request cst-request-type-2">
			<xsl:if test="remember-items/*">
				<xsl:apply-templates select="//site:match-space/form/remember-items">
					<xsl:with-param name="remember_items" select="remember-items" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:apply-templates select="//site:match-space/site-headline">
				<xsl:with-param name="type">2</xsl:with-param>
				<xsl:with-param name="title">[%bgkrst.enter.personal.info]</xsl:with-param>
				<xsl:with-param name="class">cst cst-request</xsl:with-param>
			</xsl:apply-templates>
			<xsl:if test="count(errors/*) &gt; 0">
				<xsl:call-template name="cstc:errors">
					<xsl:with-param name="errors" select="errors" />
				</xsl:call-template>
			</xsl:if>
			<xsl:variable name="form" select="." />
			<div class="cst-box cst-request-user-data">
				<xsl:apply-templates select="/site:site/site:match-space/form/user-data">
					<xsl:with-param name="form" select="." />
				</xsl:apply-templates>
				<fieldset>
					<legend>
						<xsl:apply-templates select="//site:match-space/site-headline">
							<xsl:with-param name="type">3</xsl:with-param>
							<xsl:with-param name="title">[%txt.addressdata]</xsl:with-param>
							<xsl:with-param name="class">cst cst-request cst-request-addressdata</xsl:with-param>
						</xsl:apply-templates>
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
			<xsl:apply-templates select="//site:match-space/site-headline">
				<xsl:with-param name="type">2</xsl:with-param>
				<xsl:with-param name="title">[%page_add_1.tripinfos]</xsl:with-param>
				<xsl:with-param name="class">cst cst-request cst-request-trip-infos</xsl:with-param>
			</xsl:apply-templates>
			<div class="cst-box cst-request-trip-infos">
				<xsl:call-template name="cst-request-travelling-persons" />
				<xsl:call-template name="cst-request-travelling-date" />
			</div>

			<xsl:if test="count(material/*) &gt; 0 or @newsletter or marketing-actions/*">
				<xsl:apply-templates select="//site:match-space/site-headline">
					<xsl:with-param name="type">2</xsl:with-param>
					<xsl:with-param name="title">[%bgkrst.request.prospekte]</xsl:with-param>
					<xsl:with-param name="class">cst cst-request cst-request-wishes</xsl:with-param>
				</xsl:apply-templates>
				<div class="cst-request cst-request-more cst-request-newsletter-marketing cst-box">
					<xsl:call-template name="bgk-cst-request-newsletter-marketing" />
				</div>
			</xsl:if>

			<xsl:apply-templates select="//site:match-space/site-headline">
				<xsl:with-param name="type">2</xsl:with-param>
				<xsl:with-param name="title">[%bgkrst.holiday.interests]</xsl:with-param>
				<xsl:with-param name="class">cst cst-request cst-request-wishes</xsl:with-param>
			</xsl:apply-templates>
			<div class="cst-request cst-request-more cst-request-holiday-interests cst-box">
				<fieldset>
					<ul>
						<li><input type="checkbox" class="inputcheckbox" value="[%bgkrst.holiday.auftanken]" name="form[messages][holiday_interests][]" id="hi_auftanken" />&#160;<label for="hi_auftanken">[%bgkrst.holiday.auftanken]</label></li>
						<li><input type="checkbox" class="inputcheckbox" value="[%bgkrst.holiday.aktiv]" name="form[messages][holiday_interests][]" id="hi_aktiv" />&#160;<label for="hi_aktiv">[%bgkrst.holiday.aktiv]</label></li>
						<li><input type="checkbox" class="inputcheckbox" value="[%bgkrst.holiday.entspannung]" name="form[messages][holiday_interests][]" id="hi_entspannung" />&#160;<label for="hi_entspannung">[%bgkrst.holiday.entspannung]</label></li>
						<li><input type="checkbox" class="inputcheckbox" value="[%bgkrst.holiday.wandern]" name="form[messages][holiday_interests][]" id="hi_wandern" />&#160;<label for="hi_wandern">[%bgkrst.holiday.wandern]</label></li>
						<li><input type="checkbox" class="inputcheckbox" value="[%bgkrst.holiday.gourmet]" name="form[messages][holiday_interests][]" id="hi_gourmet" />&#160;<label for="hi_gourmet">[%bgkrst.holiday.gourmet]</label></li>
						<li><input type="checkbox" class="inputcheckbox" value="[%bgkrst.holiday.golf]" name="form[messages][holiday_interests][]" id="hi_golf" />&#160;<label for="hi_golf">[%bgkrst.holiday.golf]</label></li>
						<li><input type="checkbox" class="inputcheckbox" value="[%bgkrst.holiday.ernaehrung]" name="form[messages][holiday_interests][]" id="hi_ernaehrung" />&#160;<label for="hi_ernaehrung">[%bgkrst.holiday.ernaehrung]</label></li>
						<li><input type="checkbox" class="inputcheckbox" value="[%bgkrst.holiday.yoga]" name="form[messages][holiday_interests][]" id="hi_yoga" />&#160;<label for="hi_yoga">[%bgkrst.holiday.yoga]</label></li>
						<li><input type="checkbox" class="inputcheckbox" value="[%bgkrst.holiday.schrothkur]" name="form[messages][holiday_interests][]" id="hi_schrothkur" />&#160;<label for="hi_schrothkur">[%bgkrst.holiday.schrothkur]</label></li>
						<li><input type="checkbox" class="inputcheckbox" value="[%bgkrst.holiday.wintersport]" name="form[messages][holiday_interests][]" id="hi_wintersport" />&#160;<label for="hi_wintersport">[%bgkrst.holiday.wintersport]</label></li>
						<li><input type="checkbox" class="inputcheckbox" value="[%bgkrst.holiday.wellness]" name="form[messages][holiday_interests][]" id="hi_wellness" />&#160;<label for="hi_wellness">[%bgkrst.holiday.wellness]</label></li>
						<li><input type="checkbox" class="inputcheckbox" value="[%bgkrst.holiday.kultur]" name="form[messages][holiday_interests][]" id="hi_kultur" />&#160;<label for="hi_kultur">[%bgkrst.holiday.kultur]</label></li>
						<li><input type="checkbox" class="inputcheckbox" value="[%bgkrst.holiday.ayurveda]" name="form[messages][holiday_interests][]" id="hi_ayurveda" />&#160;<label for="hi_ayurveda">[%bgkrst.holiday.ayurveda]</label></li>
						<li><input type="checkbox" class="inputcheckbox" value="[%bgkrst.holiday.advent]" name="form[messages][holiday_interests][]" id="hi_advent" />&#160;<label for="hi_advent">[%bgkrst.holiday.advent]</label></li>
						<li><input type="checkbox" class="inputcheckbox" value="[%bgkrst.holiday.kosmetik]" name="form[messages][holiday_interests][]" id="hi_kosmetik" />&#160;<label for="hi_kosmetik">[%bgkrst.holiday.kosmetik]</label></li>
						<li><input type="checkbox" class="inputcheckbox" value="[%bgkrst.holiday.geburtstag]" name="form[messages][holiday_interests][]" id="hi_geburtstag" />&#160;<label for="hi_geburtstag">[%bgkrst.holiday.geburtstag]</label></li>
						<li><input type="checkbox" class="inputcheckbox" value="[%bgkrst.holiday.freunde]" name="form[messages][holiday_interests][]" id="hi_freunde" />&#160;<label for="hi_freunde">[%bgkrst.holiday.freunde]</label></li>
					</ul>
				</fieldset>
			</div>

			<xsl:apply-templates select="//site:match-space/site-headline">
				<xsl:with-param name="type">2</xsl:with-param>
				<xsl:with-param name="title">[%bgkrst.request.attention]</xsl:with-param>
				<xsl:with-param name="class">cst cst-request cst-request-wishes</xsl:with-param>
			</xsl:apply-templates>
			<div class="cst-request cst-request-more cst-request-attention cst-box">
				<textarea rows="3" cols="40" name="form[messages][wie_aufmerksam_geworden]">
				</textarea>
			</div>

			<xsl:apply-templates select="//site:match-space/site-headline">
				<xsl:with-param name="type">2</xsl:with-param>
				<xsl:with-param name="title">[%txt.wishes]</xsl:with-param>
				<xsl:with-param name="class">cst cst-request cst-request-wishes</xsl:with-param>
			</xsl:apply-templates>
			<div class="cst-box cst-request-wishes">
				<xsl:if test="@lng_preference and count(languages/*[checked=1]) &gt; 0">
					<xsl:apply-templates select="//site:match-space/site-headline">
						<xsl:with-param name="type">3</xsl:with-param>
						<xsl:with-param name="title">[%txt.request.language.hint]</xsl:with-param>
						<xsl:with-param name="class">cst cst-language-hint</xsl:with-param>
					</xsl:apply-templates>
					<xsl:for-each select="languages/*">
						<xsl:if test="checked = 1">
							<div class="cst-language-hint-language">
								<input id="request_language_{sl_id}" type="radio" name="form[lng_preference]" value="{sl_name}">
									<xsl:if test="//site:config/@language = sl_id">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
								<label for="request_language_{sl_id}">
									<img src="{//site:vars/@base-resources}images/flags/{sl_short}.gif" style="margin-right: 5px"/>
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
				<span class="cst-request-required-hint">* [%txt.field.required]</span>

			<xsl:if test="//site:config/@privacy='true'">
				<xsl:apply-templates select="//site:match-space/site-headline">
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
	</xsl:template>

	<xsl:template match="site:match-space/form/remember-items">
		<xsl:param name="remember_items" />
		<xsl:param name="table_colspan">1</xsl:param>
		<xsl:param name="remember_image_width">50</xsl:param>
		<xsl:param name="remember_image_height">50</xsl:param>
		<xsl:if test="count($remember_items/*) &gt; 0">
			<script type="text/javascript">_lib_load( 'jQuery', 'vil' );</script>
			<div class="cst-request cst-box cst-request-remember-items">
				<xsl:apply-templates select="//site:match-space/site-headline">
					<xsl:with-param name="type">2</xsl:with-param>
					<xsl:with-param name="title">[%bgkrst.interest.in]</xsl:with-param>
					<xsl:with-param name="class">cst cst-request</xsl:with-param>
				</xsl:apply-templates>
				<table class="cst-request-remember-items" cellspacing="0" cellpadding="0">
					<tr class="cst-remember-items-header">
						<td class="remember-items-img image"><xsl:text> </xsl:text></td>
						<td class="remember-item-name"><xsl:text> </xsl:text></td>
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
						<xsl:variable name="remember-desc">
							<xsl:choose>
								<xsl:when test="hpa_id">
									<xsl:if test="hpa_type='4'"><span class="item-type item-type-voucher">[%txt.voucher]: </span></xsl:if>
									<xsl:value-of select="string-length(hpa_desc)" />
								</xsl:when>
								<xsl:when test="hp_id"><xsl:value-of select="string-length(hp_desc)" /></xsl:when>
								<xsl:when test="hrt_id"><xsl:value-of select="string-length(hrt_desc)" /></xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="remember-hotel">
							<xsl:choose>
								<xsl:when test="hpa_hotel"><xsl:value-of select="hpa_hotel" /></xsl:when>
								<xsl:when test="hp_hotel"><xsl:value-of select="hp_hotel" /></xsl:when>
								<xsl:when test="hrt_hotel"><xsl:value-of select="hrt_hotel" /></xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="remember-teaser">
							<xsl:choose>
								<xsl:when test="hpa_id">
									<xsl:if test="hpa_type='4'"><span class="item-type item-type-voucher">[%txt.voucher]: </span></xsl:if>
									<xsl:value-of select="string-length(hrt_desc_teaser)" />
								</xsl:when>
								<xsl:when test="hp_id"><xsl:value-of select="string-length(hrt_desc_teaser)" /></xsl:when>
								<xsl:when test="hrt_id"><xsl:value-of select="string-length(hrt_desc_teaser)" /></xsl:when>
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
										<ul class="cst-media">
											<xsl:call-template name="cstc:image">
												<xsl:with-param name="src" select="$image-url" />
												<xsl:with-param name="alt" select="$remember-name" />
												<xsl:with-param name="href" select="$image-url" />
												<xsl:with-param name="width" select="$remember_image_width"/>
												<xsl:with-param name="height" select="$remember_image_height"/>
												<xsl:with-param name="zoom-icon">false</xsl:with-param>
											</xsl:call-template>
										</ul>
									</xsl:when>

									<xsl:otherwise>
										<ul class="cst-media">
											<xsl:choose>
												<xsl:when test="hpa_id"><img class="remember-item-dummy" src="{//site:vars/@base-resources}images/cst_remember_package_dummy.jpg" alt="{$remember-name}" /></xsl:when>
												<xsl:when test="hp_id"><span class="remember-item-hp" title="{$remember-name}">&#160;</span></xsl:when>
												<xsl:when test="hrt_id"><span class="remember-item-hrt" title="{$remember-name}">&#160;</span></xsl:when>
											</xsl:choose>
										</ul>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<td class="remember-item-name remember-item-name-{$request-item-id}">
								<xsl:variable name="link-url">
									<xsl:choose>
										<xsl:when test="hpa_id">package-detail.php?id=<xsl:value-of select="$request-item-id"/></xsl:when>
										<xsl:when test="hp_id">program-detail.php?id=<xsl:value-of select="$request-item-id"/></xsl:when>
										<xsl:when test="hrt_id">room-type-detail.php?id=<xsl:value-of select="$request-item-id"/></xsl:when>
									</xsl:choose>
								</xsl:variable>
								<a href="#" rev="">
									<xsl:attribute name="class">
										<xsl:choose>
											<xsl:when test="$remember-desc &gt; 3 or $remember-teaser &gt; 3 ">vil_link</xsl:when>
										</xsl:choose>
									</xsl:attribute>
									<xsl:attribute name="href">
										<xsl:choose>
											<xsl:when test="$remember-desc &lt; 3 or $remember-teaser &gt; 3"><xsl:value-of select="$link-url" /></xsl:when>
											<xsl:otherwise>#</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<xsl:value-of select="$remember-name" />
								</a>
								<xsl:if test="$remember-desc &gt; 3 or $remember-teaser &gt; 3">
									<table class="remember-item-vil">
										<tr>
											<td>
												<xsl:choose>
													<xsl:when test="hpa_id">
														<xsl:if test="hpa_type='4'"><span class="item-type item-type-voucher">[%txt.voucher]: </span></xsl:if>
														<xsl:copy-of select="hpa_desc_teaser/node()" /><xsl:copy-of select="hpa_desc/node()" />
													</xsl:when>
													<xsl:when test="hp_id"><xsl:copy-of select="hp_desc_teaser/node()" /><xsl:copy-of select="hp_desc/node()" /></xsl:when>
													<xsl:when test="hrt_id"><xsl:copy-of select="hrt_desc_teaser/node()" /><xsl:copy-of select="hrt_desc/node()" /></xsl:when>
												</xsl:choose>
											</td>
										</tr>
									</table>
								</xsl:if>
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
				<script type="text/javascript">
					_lib_load('jQuery');
				</script>
				<script type="text/javascript">
					cst_remember_item_delete( );
				</script>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="cstc:hotel-detail-routing[@output-type=0 or @output-type=2]">
		<site:cms-page-content-place template-content="gallery" replace="all">
			<div id="bg2_map"></div>
		</site:cms-page-content-place>
		<div id="delete_me" />

		<script type="text/javascript" src="//maps.google.com/maps/api/js?sensor=false"></script>
		<script type="text/javascript" src="{$_base_res}customize/hotel-bergkristall2/js/googlemap.js"></script>
		<script type="text/javascript">
			map_create(
				new google.maps.LatLng( parseFloat('<xsl:value-of select="hotel/hotel_geo_lat" />'), parseFloat('<xsl:value-of select="hotel/hotel_geo_long" />') ),
				'<xsl:if test="hotel/hotel_nameaffix != ''"><xsl:value-of select="hotel/hotel_nameaffix" />&#160;</xsl:if><xsl:value-of select="hotel/hotel_name" />'
			);
		</script>
	</xsl:template>

	<xsl:template match="cstc:program-teaser|/site:site/site:match-space/hotel/programs/teaser">
		<xsl:param name="program" select="." />

		<xsl:variable name="currency" select="/site:site/site:config/@currency-sign" />

		<div class="cst-hp">
			<div class="cst-hp-left">
				<div class="cst-hp-indicator"><xsl:value-of select="$program/indicators/*[coi_parent = $coi-programs]/coi_name_str" /></div>
				<div class="cst-hp-name">
					<xsl:value-of select="$program/hp_name" />
				</div>
			</div>

			<div class="cst-hp-right">
				<div class="cst-hp-desc">
					<xsl:copy-of select="$program/hp_desc_cms/node()" />
				</div>
				<div class="cst-hp-price-hint">[%bgkrst.price.per.person]:</div>
				<div class="cst-hp-request">
					<a class="bgk-cta-text" href="{$program/@url-request}">
						[%txt.request]
					</a>
				</div>
				<div class="cst-hp-price">
					<xsl:value-of select="format-number( number( $program/hp_price_int ), '0.##' )" />
					<xsl:text> </xsl:text>
					<xsl:value-of select="$currency" />
				</div>
			</div>
			<div class="clearfix"></div>
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

	<xsl:template match="cstc:job-teaser">
		<div class="cst-box">
			<div class="cst-media">
				<xsl:attribute name="style"><xsl:choose>
					<xsl:when test="hj_image != '0'">background-image:url(<xsl:value-of select="hj_image" />/462x462s);</xsl:when>
					<xsl:otherwise>background-color: #dbe8c8</xsl:otherwise>
				</xsl:choose></xsl:attribute>
				<a href="{@url}" title="{hj_position}">&#160;</a>
			</div>
			<div class="cst-box-content">
				<xsl:apply-templates select="//site:match-space/site-headline">
					<xsl:with-param name="type">3</xsl:with-param>
					<xsl:with-param name="title" select="hj_name" />
					<xsl:with-param name="class">cst cst-list-job</xsl:with-param>
				</xsl:apply-templates>
				<div class="cst-teaser-text">
					<div class="cst-job-category">
						<xsl:call-template name="cstc:formatted-text">
							<xsl:with-param name="text-node" select="hjc_name" />
						</xsl:call-template>
					</div>
					<div class="cst-job-position">
						<xsl:call-template name="cstc:formatted-text">
							<xsl:with-param name="text-node" select="hj_position" />
						</xsl:call-template>
					</div>
					<div class="cst-job-begin">
						[%txt.job.begin]:
						<xsl:choose>
							<xsl:when test="hj_begin_display = '0000-00-00'">
								<b>[%txt.job.avail.instant]</b>
							</xsl:when>
							<xsl:otherwise>
								<b>
									<xsl:call-template name="cstc:formatted-text">
										<xsl:with-param name="text-node" select="hj_begin_display" />
									</xsl:call-template>
								</b></xsl:otherwise>
						</xsl:choose>
					</div>
					<xsl:if test="/site:site/site:config/@link-hotel='true'">
						<div class="cst-job-hotel">
							<xsl:value-of select="hotel/hotel_nameaffix" /><xsl:text> </xsl:text><xsl:value-of select="hotel/hotel_name" /><br />
							<xsl:value-of select="hotel/hotel_zip" /><xsl:text> </xsl:text>
							<xsl:value-of select="hotel/hotel_city" /><xsl:text> (</xsl:text>
							<xsl:value-of select="hotel/state_name" /><xsl:text>, </xsl:text>
							<xsl:value-of select="hotel/country_name" /><xsl:text>)</xsl:text>
						</div>
					</xsl:if>
				</div>
				<ul class="cst-links">
					<xsl:apply-templates select="//site:match-space/site-links/normal">
						<xsl:with-param name="url"><xsl:value-of select="@url" /></xsl:with-param>
						<xsl:with-param name="class">cst-link cst-link-detail cst-job-link</xsl:with-param>
						<xsl:with-param name="title">[%txt.details]</xsl:with-param>
						<xsl:with-param name="type">more</xsl:with-param>
					</xsl:apply-templates>
				</ul>
				<div class="clearfix"/>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="cstc:package-teaser[@type=4]">

		<xsl:variable name="package-title-raw"><xsl:choose>
			<xsl:when test="count(avail/custom-elements/variant-groupings/*)&gt;1">
				<xsl:value-of select="avail/custom-elements/variant-groupings/*[1]/name" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="package/hpa_name" disable-output-escaping="yes" />
			</xsl:otherwise>
		</xsl:choose></xsl:variable>

		<xsl:variable name="package-title"><xsl:choose>
			<xsl:when test="contains( package/hpa_name/node(), ' - ' ) and contains( package/hpa_name/node(), '|' )"><xsl:value-of select="substring-after( substring-before( package/hpa_name/node(), '|' ), ' - ' )" /></xsl:when>
			<xsl:when test="contains( package/hpa_name/node(), ' - ' )"><xsl:value-of select="substring-after( package/hpa_name/node(), ' - ' )" /></xsl:when>
			<xsl:when test="contains( package/hpa_name/node(), '|' )"><xsl:value-of select="substring-before( package/hpa_name/node(), '|' )" /></xsl:when>
			<xsl:otherwise><xsl:value-of select="package/hpa_name/node()" /></xsl:otherwise>
		</xsl:choose></xsl:variable>

		<xsl:variable name="package-subtitle"><xsl:choose>
			<xsl:when test="contains( package/hpa_name/node(), ' - ' )"><xsl:value-of select="substring-before( package/hpa_name/node(), ' - ' )" /></xsl:when>
		</xsl:choose></xsl:variable>

		<div id="cst-box-package-{package/hpa_id}" class="cst-box">
			<div class="cst-box-title">
				<xsl:call-template name="cstc:headline">
					<xsl:with-param name="type">4</xsl:with-param>
					<xsl:with-param name="title" select="$package-subtitle" />
					<xsl:with-param name="class">cst cst-list-voucher</xsl:with-param>
					<xsl:with-param name="href"><xsl:value-of select="@url"/></xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="cstc:headline">
					<xsl:with-param name="type">3</xsl:with-param>
					<xsl:with-param name="title" select="$package-title" />
					<xsl:with-param name="class">cst cst-list-voucher</xsl:with-param>
					<xsl:with-param name="href"><xsl:value-of select="@url"/></xsl:with-param>
				</xsl:call-template>
			</div>
			<div class="cst-box-content">
				<xsl:if test="not(package/hpa_default_room_type=0) and not (count(avail/custom-elements/variant-groupings/*)&gt;1)">
					<xsl:if test="package/hpa_stays != 0">
						<div class="cst-teaser-text">
							<span class="cst-voucher-stays"><xsl:value-of select="package/hpa_stays" /></span> [%txt.stays.numerus/<xsl:value-of select="package/hpa_stays" />]
						</div>
					</xsl:if>
				</xsl:if>
				<xsl:if test="string-length(package/hpa_teaser/node())&gt;3">
					<div class="cst-description-text">
						<xsl:copy-of select="package/hpa_teaser/node()" />
					</div>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="not(count(avail/custom-elements/variant-groupings/*)&gt;1)">
						<h4>[%txt.price]:</h4>
						<div class="cst-voucher-price">
							<xsl:apply-templates select="cstc:package-price-teaser" />
							<ul class="cst-links">
								<xsl:call-template name="cstc:button">
									<xsl:with-param name="class">indicator-link bgk-cta-text</xsl:with-param>
									<xsl:with-param name="type">detail</xsl:with-param>
									<xsl:with-param name="title">[%bgkrst.order.voucher]</xsl:with-param>
								</xsl:call-template>
							</ul>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<h4>[%txt.price]:</h4>
						<div class="cst-voucher-prices">
							<xsl:apply-templates select="cstc:package-price-teaser" />
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="cstc:general-list[@type='package' and @item-type=4]">
		<site:cms-page-content-place template-content="gallery" replace="all">empty</site:cms-page-content-place>

		<div class="cst-list cst-list-{@type}">
			<xsl:if test="@type='package' and @item-indicator!=''">
				<xsl:attribute name="class">cst-list cst-list-<xsl:value-of select="@type"/> cst-list-package-indicator-<xsl:value-of select="@item-indicator"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="@type='package' and @item-type='4'">
				<xsl:attribute name="class">cst-list cst-list-voucher cst-list-voucher-<xsl:value-of select="../cstc:package-indicators/*/coi_id" /></xsl:attribute>
			</xsl:if>
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
					<xsl:if test="@item-indicator!=''">
						<xsl:variable name="item-indicator" select="@item-indicator"/>
						<xsl:call-template name="cstc:headline">
							<xsl:with-param name="type">2</xsl:with-param>
							<xsl:with-param name="title">
								<xsl:value-of select="../cstc:package-indicators/*[coi_id=$item-indicator]/coi_name" />
							</xsl:with-param>
							<xsl:with-param name="class">cst cst-list-package-indicator cst-list-package-indicator-<xsl:value-of select="$item-indicator"/></xsl:with-param>
						</xsl:call-template>
						<xsl:choose>
							<xsl:when test="string-length(../cstc:package-indicators/*[coi_id=$item-indicator]/coi_teaser)&gt;1">
								<div class="cst-list-package-indicator-teaser">
									<xsl:call-template name="cstc:formatted-text">
										<xsl:with-param name="text-node" select="../cstc:package-indicators/*[coi_id=$item-indicator]/coi_teaser"/>
									</xsl:call-template>
								</div>
							</xsl:when>
							<xsl:otherwise>
								<div class="cst-list-indicator-border"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>

					<xsl:for-each select="*">
						<xsl:apply-templates select=".">
							<xsl:with-param name="pos" select="position()" />
						</xsl:apply-templates>
					</xsl:for-each>
					<xsl:call-template name="page-navigation"/>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="cstc:package-price-teaser[../@type=4]" name="voucher-package-price-teaser">
		<xsl:param name="type"/>
		<xsl:variable name="hpa_id" select="avail/hpa_id" />
		<xsl:variable name="variants-grouping" select="../avail/custom-elements/variant-groupings/*[info/hpa_id = $hpa_id]" />

		<div class="cst-price">
			<xsl:if test="$type='normal'">
				<xsl:attribute name="class">cst-package-price-teaser cst-package-price-teaser-normal</xsl:attribute>
			</xsl:if>
			<span class="cst-price-from">[%txt.from]&#160;</span>
			<span class="cst-price-number">
				<xsl:variable name="package-price">
					<xsl:choose>
						<xsl:when test="$variants-grouping and $variants-grouping/info/hpa_price_min!=0">
							<xsl:value-of select="/site:site/site:config/@currency-sign" /><xsl:text> </xsl:text><xsl:value-of select="format-number($variants-grouping/info/hpa_price_min,'##0,--','european')"></xsl:value-of>
						</xsl:when>
						<xsl:when test="$variants-grouping and $variants-grouping/info/hpa_programs_min!=0">
							<xsl:value-of select="/site:site/site:config/@currency-sign" /><xsl:text> </xsl:text><xsl:value-of select="format-number($variants-grouping/info/hpa_programs_min,'##0,--','european')"></xsl:value-of>
						</xsl:when>
						<xsl:when test="info/hpa_price_min and info/hpa_price_min!=0">
							<xsl:value-of select="/site:site/site:config/@currency-sign" /><xsl:text> </xsl:text><xsl:value-of select="format-number(info/hpa_price_min,'##0,--','european')"></xsl:value-of>
						</xsl:when>
						<xsl:when test="info/hpa_price_min and info/hpa_price_min!=0">
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
				<xsl:when test="info/hpa_persons &gt; 1">&#160;<span class="cst-price-per-person">[%txt.for] <xsl:value-of select="info/hpa_persons" /> [%txt.persons]</span></xsl:when>
				<!-- detail -->
				<xsl:when test="package/hpa_persons &gt;1 ">&#160;<span class="cst-price-per-person">[%txt.for] <xsl:value-of select="package/hpa_persons" /> [%txt.persons]</span></xsl:when>
				<xsl:otherwise>&#160;<span class="cst-price-per-person">[%bgkrst.perperson]</span></xsl:otherwise>
			</xsl:choose>
			<xsl:if test="avail/hpa_type &gt;1 and avail/hpa_price_discount_num &gt; 0">
				<span class="cst-price-save">
					[%package.price.save/<xsl:value-of select="avail/hpa_price_discount" />/<xsl:value-of select="/site:site/site:config/@currency" />]
				</span>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="cstc:package-price-teaser[../@type=4 and ../package/hpa_default_room_type!=0]">
		<div class="cst-price">
			<xsl:choose>
				<xsl:when test="count(avail/custom-elements/variant-groupings/*) &gt; 1">
					<xsl:attribute name="class">cst-price cst-price-variant</xsl:attribute>
					<xsl:call-template name="bgk-package-variants">
						<xsl:with-param name="package" select="."/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="avail/hpa_price_int &gt; 0">
							<span class="cst-price-number"><xsl:value-of select="avail/hpa_price" /></span>
							<div class="cst-voucher-price-roomtype">( [%txt.room]: <xsl:value-of select="room-type/hrt_name" />)</div>
						</xsl:when>
						<xsl:when test="../package/hpa_price_min &gt; 0">
							<span class="cst-price-from">[%txt.from]</span>&#160;<span class="cst-price-number"><xsl:value-of select="/site:site/site:config/@currency-sign" /><xsl:text> </xsl:text><xsl:value-of select="format-number(../package/hpa_price_min,'#')" />,--</span>
						</xsl:when>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="/site:site/site:match-space/hotel/packages/variants[/site:site/cstc:frame/cstc:site/cstc:package-table/cstc:general-list/@item-type=4]" name="bgk-package-variants">
		<xsl:param name="package"/>
		<xsl:for-each select="$package/avail/custom-elements/variant-groupings/*">
			<xsl:sort select="avail/ht_from_ts" order="ascending" />

			<div class="cst-package-variant">
				<xsl:variable name="pos" select="position()"/>

				<xsl:if test="$pos mod 2 = 0">
					<xsl:attribute name="class">cst-package-variant cst-odd</xsl:attribute>
				</xsl:if>

				<xsl:if test="$pos=last()">
					<xsl:attribute name="class">cst-package-variant cst-package-variant-last</xsl:attribute>
				</xsl:if>

				<xsl:if test="$pos=last() and $pos mod 2=0">
					<xsl:attribute name="class">cst-package-variant cst-package-variant-last cst-odd</xsl:attribute>
				</xsl:if>

				<div class="package-variant-link">
					<ul class="cst-links">
						<xsl:call-template name="cstc:button">
							<xsl:with-param name="class">indicator-link bgk-cta-text</xsl:with-param>
							<xsl:with-param name="type">detail</xsl:with-param>
							<xsl:with-param name="title">[%bgkrst.order.voucher]</xsl:with-param>
						</xsl:call-template>
						<!-- <xsl:if test="../../../../@service-request = 'yes'">
							<xsl:call-template name="cstc:button">
								<xsl:with-param name="type">request</xsl:with-param>
								<xsl:with-param name="url"><xsl:value-of select="../../../..//@url-request"/></xsl:with-param>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="../../../../@service-booking = 'yes'">
							<xsl:call-template name="cstc:button">
								<xsl:with-param name="type">book</xsl:with-param>
								<xsl:with-param name="url"><xsl:value-of select="../../../..//@url-booking"/></xsl:with-param>
							</xsl:call-template>
						</xsl:if> -->
					</ul>
				</div>

				<span class="cst-package-variant-stays cst-stays">
					<xsl:if test="info/hpa_stays &gt; 0">
						<span class="cst-stays">
							<span class="cst-stays-number">
								<xsl:value-of select="avail/hpa_stays" />
							</span>
							<span class="cst-stays-text">
								[%txt.stays.numerus/<xsl:value-of select="avail/stays" />]
							</span>
						</span><br />
					</xsl:if>
					<xsl:choose>
						<xsl:when test="tf-avail/*">
							<ul class="cst-timeframes">
								<xsl:for-each select="tf-avail/*">
									<xsl:sort select="ht_from_ts" order="ascending"/>
									<li class="cst-timeframe">
										<xsl:if test="position()=last()">
											<xsl:attribute name="class">cst-timeframe cst-timeframe-last</xsl:attribute>
										</xsl:if>
										<xsl:if test="./ht_from_display = '0000-00-00'" >
											<xsl:attribute name="style">display: none;</xsl:attribute>
										</xsl:if>
										<span class="cst-timeframe-from">
											<xsl:value-of select="./ht_from_display" />
										</span>
										<span class="cst-binder"> - </span>
										<span class="cst-timeframe-to">
											<xsl:value-of select="./ht_to_display" />
										</span>
									</li>
								</xsl:for-each>
							</ul>
						</xsl:when>
						<!--
						<xsl:when test="avail/ht_to='0000-00-00' and avail/ht_from = avail/from">
							<div class="cst-timeframe cst-timeframe-special">
								[%txt.from] <xsl:value-of select="substring(avail/ht_from,9,2)" />.<xsl:value-of select="substring(string(avail/ht_from),6,2)" />
							</div>
						</xsl:when>
						 -->
					</xsl:choose>
				</span>
				<span class="package-variant-price">
					<xsl:call-template name="voucher-package-price-teaser">
						<xsl:with-param name="type">variants</xsl:with-param>
					</xsl:call-template>
				</span>
			</div>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="cstc:package-detail[@package-type=4]">
		<script type="text/javascript">
			_lib_load( 'jQuery', 'voucher_calculate', 'Highslide', 'cst_helper' );
		</script>
		<xsl:variable name="voucher-form">vc_<xsl:value-of select="generate-id()" /></xsl:variable>
		<xsl:variable name="voucher-sum">vc_sum_<xsl:value-of select="generate-id()" /></xsl:variable>
		<xsl:variable name="voucher-book-link">vc_book_link_<xsl:value-of select="generate-id()" /></xsl:variable>
		<xsl:variable name="voucher-preview-link">vc_preview_link_<xsl:value-of select="generate-id()" /></xsl:variable>
		<xsl:variable name="voucher-comment">vc_comment_<xsl:value-of select="generate-id()" /></xsl:variable>
		<xsl:variable name="voucher-person-amount">vc_person_amount_<xsl:value-of select="generate-id()" /></xsl:variable>
		<xsl:variable name="voucher-line-limit">vc_line_limit_<xsl:value-of select="generate-id()" /></xsl:variable>
		<xsl:variable name="voucher-amount">vc_amount_<xsl:value-of select="generate-id()" /></xsl:variable>
		<xsl:variable name="voucher-image">vc_image_<xsl:value-of select="generate-id()" /></xsl:variable>
		<xsl:variable name="voucher-recipient-firstname">vc_rc_firstname_<xsl:value-of select="generate-id()" /></xsl:variable>
		<xsl:variable name="voucher-recipient-lastname">vc_rc_lastname_<xsl:value-of select="generate-id()" /></xsl:variable>
		<xsl:variable name="voucher-recipient-salutation">vc_rc_salutation_<xsl:value-of select="generate-id()" /></xsl:variable>

		<xsl:variable name="package-title"><xsl:choose>
			<xsl:when test="contains( package/hpa_name/node(), ' - ' ) and contains( package/hpa_name/node(), '|' )"><xsl:value-of select="substring-after( substring-before( package/hpa_name/node(), '|' ), ' - ' )" /></xsl:when>
			<xsl:when test="contains( package/hpa_name/node(), ' - ' )"><xsl:value-of select="substring-after( package/hpa_name/node(), ' - ' )" /></xsl:when>
			<xsl:when test="contains( package/hpa_name/node(), '|' )"><xsl:value-of select="substring-before( package/hpa_name/node(), '|' )" /></xsl:when>
			<xsl:otherwise><xsl:value-of select="package/hpa_name/node()" /></xsl:otherwise>
		</xsl:choose></xsl:variable>

		<xsl:variable name="package-subtitle"><xsl:choose>
			<xsl:when test="contains( package/hpa_name/node(), ' - ' )"><xsl:value-of select="substring-before( package/hpa_name/node(), ' - ' )" /></xsl:when>
		</xsl:choose></xsl:variable>

		<site:cms-page-content-place template-content="content1_head" replace="all">
			<h1 class="cst-head"><xsl:value-of select="$package-title" /></h1>
			<xsl:if test="string-length( $package-subtitle ) &gt; 0"><h2><xsl:value-of select="$package-subtitle" /></h2></xsl:if>
		</site:cms-page-content-place>

		<div class="cst-detail cst-detail-voucher">
			<form id="{$voucher-form}" method="get">
				<xsl:if test="cstc:media-usages[@item-type='hotel-package']/cstc:media-usage[@usage-type='embed']">
					<div class="cst-voucher-image-list">
						<xsl:apply-templates select="//site:match-space/site-headline">
							<xsl:with-param name="type">3</xsl:with-param>
							<xsl:with-param name="title">[%txt.voucher.image.select.title]</xsl:with-param>
							<xsl:with-param name="class">cst cst-voucher-detail</xsl:with-param>
						</xsl:apply-templates>
						<div class="cst-voucher-image-select-hint">[%txt.voucher.image.select.hint]</div>
						<div class="cst-voucher-image-select">
							<xsl:variable name="voucher-image-default" select="cstc:media-usages[@item-type='hotel-package']/cstc:media-usage[@usage-type='embed'][position()=1]/media_id" />
							<select id="{$voucher-image}" style="display: none">
								<xsl:for-each select="cstc:media-usages[@item-type='hotel-package']/cstc:media-usage[@usage-type='embed']">
									<option value="{media_id}">
										<xsl:if test="media_id=$voucher-image-default">
											<xsl:attribute name="selected">selected</xsl:attribute>
										</xsl:if>
										<xsl:value-of select="media_name" /> (<xsl:value-of select="media_id" />)
									</option>
								</xsl:for-each>
							</select>
							<div class="cst-voucher-images">
								<xsl:for-each select="cstc:media-usages[@item-type='hotel-package']/cstc:media-usage[@usage-type='embed']">
									<div id="{media_id}" class="cst-voucher-image">
										<a href="#" class="cst-voucher-image-link">
											<img src="{media_url}/232x108s" />
										</a>
										<input type="radio" name="{$voucher-image}-radio" id="{$voucher-image}-{media_id}" value="{media_id}">
											<xsl:if test="media_id=$voucher-image-default">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</input>
										<label for="{$voucher-image}-{media_id}">[%txt.voucher.image.select]</label>
									</div>
								</xsl:for-each>
								<script type="text/javascript">
									jQuery('div.cst-voucher-images div.cst-voucher-image').each( function() {
										jQuery(this).click( function(e) {
											var $this = jQuery(this);
											jQuery('div', $this.parent()).removeClass('cst-voucher-image-selected');
											jQuery('input', $this.parent()).removeAttr("checked");
											jQuery('input', $this).attr("checked", "checked");
											$this.addClass('cst-voucher-image-selected');
											jQuery('#<xsl:value-of select="$voucher-image" />').val($this.attr('id'));
											if( e.target.tagName != 'INPUT' ) {
												return false;
											}
										});
									});
								</script>
							</div>
						</div>
					</div>
				</xsl:if>
				<div class="cst-box">
					<div class="cst-box-content">
						<xsl:if test="package/hpa_default_room_type !=0">
							<xsl:if test="package/hpa_stays != 0">
								<div class="cst-voucher-stays">
									<span class="cst-stay-days"><xsl:value-of select="package/hpa_stays"/></span>
									<span class="cst-stay-text">
										<xsl:choose>
											<xsl:when test="package/hpa_stays = 1">
												[%txt.stay]
											</xsl:when>
											<xsl:otherwise>
												[%txt.stays]
											</xsl:otherwise>
										</xsl:choose>
									</span>
								</div>
							</xsl:if>
						</xsl:if>
						<xsl:if test="string-length(package/hpa_teaser)&gt;3">
							<div class="cst-teaser-text">
								<xsl:call-template name="cstc:formatted-text">
									<xsl:with-param name="text-node" select="package/hpa_teaser" />
								</xsl:call-template>
							</div>
						</xsl:if>
						<xsl:choose>
							<xsl:when test="string-length(package/hpa_desc)&gt;3">
								<div class="cst-description-text">
									<xsl:call-template name="cstc:formatted-text">
										<xsl:with-param name="text-node" select="package/hpa_desc" />
									</xsl:call-template>

									<xsl:if test="package/hpa_persons &gt; 1">
										<span class="cst-voucher-persons">
											[%txt.valid] [%txt.for] <xsl:value-of select="package/hpa_persons" /> [%txt.persons]
										</span>
									</xsl:if>
								</div>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="package/hpa_persons &gt; 1">
									<div class="cst-description-text">
										<span class="cst-voucher-persons">
											[%txt.valid] [%txt.for] <xsl:value-of select="package/hpa_persons" /> [%txt.persons]
										</span>
									</div>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</div>

					<xsl:choose>
						<xsl:when test="not(count(avail/*)=0)">
							<script type="text/javascript">
								<xsl:variable name="voucher_type">
									<xsl:choose>
										<xsl:when test="package/hpa_default_room_type=0 and count( package-detail/programs )=0">0</xsl:when>
										<xsl:when test="package-detail/room">2</xsl:when>
										<xsl:otherwise>1</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								var <xsl:value-of select="$voucher-form" /> = new voucher_calculator( <xsl:value-of select="$voucher_type" />, '<xsl:value-of select="$voucher-form" />', '<xsl:value-of select="$voucher-book-link" />', '<xsl:value-of select="$voucher-preview-link" />', '<xsl:value-of select="$voucher-sum" />', '<xsl:value-of select="$voucher-comment" />' , '<xsl:value-of select="$voucher-person-amount" />' , '<xsl:value-of select="$voucher-amount" />', '<xsl:value-of select="$voucher-line-limit" />', '<xsl:value-of select="//site:config/@currency-sign" />', '<xsl:value-of select="package/hpa_hotel" />', '<xsl:value-of select="package/hpa_id" />', '<xsl:value-of select="package/hpa_price_normal" />', { voucher_min: '[%txt.voucher.range.min;escape-single-quote]', voucher_max: '[%txt.voucher.range.max;escape-single-quote]', programs_min: '[%txt.voucher.programs.range.min;escape-single-quote]', programs_max: '[%txt.voucher.programs.range.max;escape-single-quote]' }, '<xsl:value-of select="voucher-template/hvt_line_limit" />', '<xsl:value-of select="voucher-template/hvt_char_limit" />','<xsl:value-of select="$voucher-image" />',<xsl:value-of select="package/hpa_persons" />, '<xsl:value-of select="$voucher-recipient-firstname" />', '<xsl:value-of select="$voucher-recipient-lastname" />', '<xsl:value-of select="$voucher-recipient-salutation" />');
								<xsl:value-of select="$voucher-form" />.hotel_id = <xsl:value-of select="package/hpa_hotel"/>;
								<xsl:value-of select="$voucher-form" />.package_id = <xsl:value-of select="package/hpa_id"/>;
								<xsl:if test="package/hpa_price_selectable=1">
									<xsl:if test="package/hpa_price_min!=0">
										<xsl:value-of select="$voucher-form" />.voucher_amount_min = <xsl:value-of select="package/hpa_price_min" />;
									</xsl:if>
									<xsl:if test="package/hpa_price_max!=0">
										<xsl:value-of select="$voucher-form" />.voucher_amount_max = <xsl:value-of select="package/hpa_price_max" />;
									</xsl:if>
									<xsl:if test="package/hpa_programs_min!=0 and package-detail/programs">
										<xsl:value-of select="$voucher-form" />.voucher_program_amount_min = <xsl:value-of select="package/hpa_programs_min" />;
									</xsl:if>
									<xsl:if test="package/hpa_programs_max!=0 and package-detail/programs">
										<xsl:value-of select="$voucher-form" />.voucher_program_amount_max = <xsl:value-of select="package/hpa_programs_max" />;
									</xsl:if>
								</xsl:if>
							</script>
							<xsl:choose>
								<xsl:when test="count( package-detail/programs/optional/* ) &gt; 0 or count( package-room-types/* ) &gt; 0">
									<xsl:if test="count( package-room-types/* ) &gt; 0">
										<div class="cst-background-box cst-voucher-detail-roomtypes cst-package-detail-roomtypes">
											<xsl:variable name="persons">
												<xsl:choose>
													<xsl:when test="package/hpa_persons&lt;2">1</xsl:when>
													<xsl:otherwise><xsl:value-of select="package/hpa_persons" /></xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:choose>
												<xsl:when test="package/hpa_persons=0">
													<div class="cst-voucher-persons">
														<label class="cst-voucher-persons-hint">[%txt.adults]</label>
														<select name="{$voucher-person-amount}" id="{$voucher-person-amount}" onchange="{$voucher-form}.sum_update()">
															<xsl:call-template name="voucher_person_options">
																<xsl:with-param name="limit" select="@voucher-persons-max" />
																<xsl:with-param name="count" select="$persons" />
																<xsl:with-param name="step" select="$persons" />
																<xsl:with-param name="selected" select="package/hpa_persons" />
															</xsl:call-template>
														</select>
													</div>
												</xsl:when>
												<xsl:otherwise>
													<input type="hidden" name="{$voucher-person-amount}" id="{$voucher-person-amount}" value="{package/hpa_persons}" />
												</xsl:otherwise>
											</xsl:choose>
											<table class="cst-voucher-roomtypes" cellspacing="0">
												<xsl:for-each select="package-room-types/*[hpapr_price != '']">
													<xsl:variable name="striping">
														<xsl:choose>
															<xsl:when test="position()mod 2=0">even</xsl:when>
															<xsl:otherwise>odd</xsl:otherwise>
														</xsl:choose>
													</xsl:variable>
													<tr class="cst-voucher-roomtype cst-package-roomtype cst-voucher-roomtype-{$striping} cst-voucher-striping-{$striping}">
														<td class="cst-voucher-selector">
															<input type="radio" name="voucher-roomtypes" id="hrt_{hrt_id}"  onclick="{$voucher-form}.sum_update()">
																<xsl:if test="position()=1">
																	<xsl:attribute name="checked">checked</xsl:attribute>
																</xsl:if>
															</input>
														</td>
														<td>
															<span class="cst-name cst-name-voucher cst-name-room cst-name-voucher-info">
																<label for="hrt_{hrt_id}"><xsl:value-of select="hrt_name"/></label>
															</span>
															<div class="cst-voucher-item-description">
																<table class="cst-voucher-item-description">
																	<tr>
																		<td class="cst-voucher-item-description-image">
																			<ul class="cst-media">
																				<xsl:if test="substring(hrt_image,1,4)='http'">
																					<xsl:apply-templates select="//site:match-space/images">
																						<xsl:with-param name="src" select="hrt_image" />
																						<xsl:with-param name="width">83</xsl:with-param>
																					</xsl:apply-templates>
																				</xsl:if>
																				<xsl:if test="substring(hrt_image_plan,1,4)='http'">
																					<xsl:apply-templates select="//site:match-space/images">
																						<xsl:with-param name="src" select="hrt_image_plan" />
																						<xsl:with-param name="width">83</xsl:with-param>
																					</xsl:apply-templates>
																				</xsl:if>
																			</ul>
																		</td>
																		<td class="cst-voucher-item-description-text">
																			<xsl:apply-templates select="//site:match-space/site-headline">
																				<xsl:with-param name="type">3</xsl:with-param>
																				<xsl:with-param name="title" select="hrt_name" />
																				<xsl:with-param name="class">cst cst-voucher-detail</xsl:with-param>
																			</xsl:apply-templates>
																			<xsl:copy-of select="hrt_desc_teaser/node()" />
																		</td>
																	</tr>
																</table>
															</div>
														</td>
														<td class="cst-voucher-price">
															<xsl:variable name="room-price" select="hpapr_price" />
															<span class="cst-price cst-price-voucher cst-price-package">
																<xsl:value-of select="//site:config/@currency-sign" /><xsl:text> </xsl:text><xsl:value-of select="$room-price" />,--
															</span>
															<script type="text/javascript">
																<xsl:value-of select="$voucher-form" />.voucher_roomtypes[<xsl:value-of select="hrt_id"/>] = {type: 'variable', price: <xsl:value-of select="hpapr_price"/>, id: <xsl:value-of select="hrt_id"/>};
															</script>
														</td>
													</tr>
												</xsl:for-each>
											</table>
										</div>
									</xsl:if>
									<xsl:if test="count( package-detail/programs/optional/* )&gt;0">
										<div class="cst-background-box cst-voucher-detail-programs">
											<xsl:choose>
												<xsl:when test="count( package-detail/programs/optional/* ) &lt; number( package-program-tree/@voucher-programs-show-list-count ) or not(count(package-program-tree/*) &gt; 0)">
													<table class="cst-voucher-programs cst-voucher-programs" cellspacing="0">
														<xsl:for-each select="package-detail/programs/optional/*">
															<tr class="cst-voucher-program">
																<td class="cst-voucher-selector">
																	<select name="voucher_programs" id="hpr_{hp_id}" onchange="{$voucher-form}.programs_changed()">
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
																	</select>
																</td>
																<td class="cst-voucher-text">
																	<span class="cst-detail cst-name-voucher cst-name-program cst-name-voucher-info">
																		<xsl:value-of select="hp_name_str" />
																	</span>
																	<div class="cst-voucher-item-description">
																		<table class="cst-voucher-item-description">
																			<tr>
																				<td class="cst-voucher-item-description-text">
																					<xsl:apply-templates select="//site:match-space/site-headline">
																						<xsl:with-param name="type">2</xsl:with-param>
																						<xsl:with-param name="title" select="hp_name" />
																						<xsl:with-param name="class">cst cst-voucher-description cst-voucher-program-description</xsl:with-param>
																					</xsl:apply-templates>
																					<xsl:copy-of select="hp_desc_teaser/node()" /><br />
																					<xsl:copy-of select="hp_desc_cms/node()" />
																				</td>
																			</tr>
																		</table>
																	</div>
																</td>
																<td class="cst-voucher-price">
																	<span class="cst-price cst-price-voucher cst-price-package">
																		<xsl:value-of select="hp_price" />
																	</span>
																	<script type="text/javascript">
																		<xsl:value-of select="$voucher-form" />.voucher_programs[<xsl:value-of select="hp_id"/>] = {type: 'variable', price: <xsl:value-of select="hp_price_int"/>, id: <xsl:value-of select="hp_id"/>};
																	</script>
																</td>
															</tr>
														</xsl:for-each>
													</table>
												</xsl:when>
												<xsl:otherwise>

													<div class="cst-voucher-detail-programs">
														<div class="cst-program-voucher">
															<xsl:for-each select="package-program-tree/*">
																<xsl:if test="program_count&gt;0">
																	<xsl:apply-templates select="//site:match-space/voucher/voucher-programs-branch">
																		<xsl:with-param name="branch" select="." />
																		<xsl:with-param name="show-content" select="count(../../package-program-tree/*[program_count!=0])=1" />
																		<xsl:with-param name="voucher-form" select="$voucher-form" />
																	</xsl:apply-templates>
																</xsl:if>
															</xsl:for-each>
														</div>
														<script type="text/javascript">
															$(function() {$('a.cst-program-toggler').click( function() {
															$('div.indicator-' +this.id).toggle();
															return false;
															})});
														</script>
													</div>
												</xsl:otherwise>
											</xsl:choose>
										</div>
									</xsl:if>
								</xsl:when>
							</xsl:choose>

							<xsl:if test="count( package-detail/programs/included/* ) &gt; 0">
								<div class="cst-background-box cst-voucher-detail-programs cst-package-detail-programs cst-voucher-detail-programs-included">
									<h2 class="cst cst-voucher-programs cst-voucher-programs-included">[%txt.programs] [%txt.inclusive]</h2>
									<xsl:for-each select="package-detail/programs/included/*">
										<xsl:variable name="striping">
											<xsl:choose>
												<xsl:when test="position()mod 2=0">even</xsl:when>
												<xsl:otherwise>odd</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<div class="cst-program cst-voucher-program cst-program-included cst-voucher-program-{$striping}">
											<table cellspacing="0">
												<tr>
													<td valign="top">
														<xsl:if test="( not( hp_image = 0 ))">
															<ul class="cst-media">
																<xsl:apply-templates select="//site:match-space/images">
																	<xsl:with-param name="src" select="hp_image" />
																	<xsl:with-param name="alt">
																		<xsl:value-of select="package/hpa_name" />
																	</xsl:with-param>
																	<xsl:with-param name="width">120</xsl:with-param>
																</xsl:apply-templates>
															</ul>
														</xsl:if>
													</td>
													<td>
														<div class="cst-price cst-program-price cst-program-price-voucher">
															<xsl:value-of select="hp_price" />
														</div>
														<xsl:apply-templates select="//site:match-space/site-headline">
															<xsl:with-param name="type">3</xsl:with-param>
															<xsl:with-param name="title"><xsl:value-of select="hp_name_str" /></xsl:with-param>
															<xsl:with-param name="class">cst-detail cst-name-program</xsl:with-param>
														</xsl:apply-templates>
														<div class="cst-teaser">
															<xsl:copy-of select="hp_desc_teaser/node()" />
														</div>
														<div class="cst-description">
															<xsl:copy-of select="hp_desc_cms/node()" />
														</div>
														<script type="text/javascript">
															<xsl:value-of select="$voucher-form" />.voucher_programs[<xsl:value-of select="hp_id"/>] = {type: 'static', price: <xsl:value-of select="hp_price_int"/>, id: <xsl:value-of select="hp_id"/>};
														</script>
													</td>
												</tr>
											</table>
										</div>
									</xsl:for-each>
								</div>
							</xsl:if>

							<div class="cst-background-box">
								<div class="cst-voucher-price-sum">
									<xsl:if test="package/hpa_price_selectable=1">
										<xsl:attribute name="class">cst-voucher-price-sum cst-voucher-price-sum-selectable clearfix</xsl:attribute>
									</xsl:if>
									<xsl:choose>
										<xsl:when test="count( package-detail/programs/optional/* ) &gt; 0 or count( package-room-types/* ) &gt; 0">
											<xsl:call-template name="cstc:headline">
												<xsl:with-param name="type">3</xsl:with-param>
												<xsl:with-param name="title">[%txt.price]: </xsl:with-param>
												<xsl:with-param name="class">cst cst-voucher-detail</xsl:with-param>
											</xsl:call-template>
											<div class="cst-price">
												<span class="cst-price-number" id="{$voucher-sum}"><xsl:value-of select="package/hpa_price_normal" /><xsl:text> </xsl:text> <xsl:value-of select="//site:config/@currency-sign" /></span>
											</div>
											<xsl:if test="package/hpa_price_selectable=1 and (package/hpa_price_max!=0 or package/hpa_price_min!=0 or package/hpa_programs_max!=0 or package/hpa_programs_min!=0)">
												<xsl:if test="package-detail/programs">
													<span class="cst-voucher-range-hint cst-voucher-range-hint-programs">
														<xsl:choose>
															<xsl:when test="package/hpa_programs_min!=0 and package/hpa_programs_max!=0">
																[%txt.voucher.programs.range/<xsl:value-of select="format-number(number(package/hpa_programs_min),'##0,00','european')" />/<xsl:value-of select="/site:site/site:config/@currency-sign" />/<xsl:value-of select="format-number(package/hpa_programs_max,'##0,00','european')" />/<xsl:value-of select="/site:site/site:config/@currency-sign" />]
															</xsl:when>
															<xsl:when test="package/hpa_programs_min!=0">
																[%txt.voucher.programs.range.min/<xsl:value-of select="format-number(number(package/hpa_programs_min),'##0,00','european')" />/<xsl:value-of select="/site:site/site:config/@currency-sign" />]
															</xsl:when>
															<xsl:when test="package/hpa_programs_max!=0">
																[%txt.voucher.programs.range.max/<xsl:value-of select="format-number(number(package/hpa_programs_max),'##0,00','european')" />/<xsl:value-of select="/site:site/site:config/@currency-sign" />]
															</xsl:when>
														</xsl:choose>
													</span>
												</xsl:if>
											</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="package/hpa_price_selectable=1">
													<xsl:call-template name="cstc:headline">
														<xsl:with-param name="type">3</xsl:with-param>
														<xsl:with-param name="title">[%txt.amount.money]: </xsl:with-param>
														<xsl:with-param name="class">cst cst-voucher-detail</xsl:with-param>
													</xsl:call-template>
													<input id="{$voucher-amount}" class="inputtext inputtext-vocher-amount" name="voucher_amount" type="text" value="{package/hpa_price_normal}" style="text-align: right;" onkeydown="var e = event || window.event; if(event.keyCode==13) return false;" onblur="{$voucher-form}.voucher_check('preview')" onchange="{$voucher-form}.sum_update()" /><span class="voucher-currency-sign"><xsl:value-of select="/site:site/site:config/@currency-sign" /></span>
													<!--<div class="voucher-edit-hint">[%txt.amount.money.edit/<xsl:value-of select="/site:site/site:config/@currency-sign" />]</div>-->
													<span class="cst-voucher-range-hint cst-voucher-range-hint-voucher">
														<xsl:choose>
															<xsl:when test="package/hpa_price_min!=0 and package/hpa_price_max!=0">
																[%txt.voucher.range/<xsl:value-of select="format-number(number(package/hpa_price_min),'##0,00','european')" />/<xsl:value-of select="/site:site/site:config/@currency-sign" />/<xsl:value-of select="format-number(package/hpa_price_max,'##0,00','european')" />/<xsl:value-of select="/site:site/site:config/@currency-sign" />]
															</xsl:when>
															<xsl:when test="package/hpa_price_min!=0">
																[%txt.voucher.range.min/<xsl:value-of select="format-number(number(package/hpa_price_min),'##0,00','european')" />/<xsl:value-of select="/site:site/site:config/@currency-sign" />]
															</xsl:when>
															<xsl:when test="package/hpa_price_max!=0">
																[%txt.voucher.range.max/<xsl:value-of select="format-number(number(package/hpa_price_max),'##0,00','european')" />/<xsl:value-of select="/site:site/site:config/@currency-sign" />]
															</xsl:when>
														</xsl:choose>
													</span>
												</xsl:when>
												<xsl:otherwise>
													<xsl:call-template name="cstc:headline">
														<xsl:with-param name="type">3</xsl:with-param>
														<xsl:with-param name="title">[%txt.price]: </xsl:with-param>
														<xsl:with-param name="class">cst cst-voucher-detail</xsl:with-param>
													</xsl:call-template>
													<span id="{$voucher-amount}" class="cst-voucher-amount cst-price-number"><xsl:value-of select="package/hpa_price_normal" /><xsl:text> </xsl:text><xsl:value-of select="/site:site/site:config/@currency-sign" /></span>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</div>
							</div>

								<div class="cst-voucher-recipient">
									<h2 class="cst cst-voucher cst-voucher-recipient">[%txt.donee]</h2>
									<span class="cst-voucher-recipient-salutation">
										<label for="{$voucher-recipient-salutation}">[%txt.salutation]</label>
										<xsl:call-template name="form-dropdown">
											<xsl:with-param name="name">voucher-recipient-salutation</xsl:with-param>
											<xsl:with-param name="id"><xsl:value-of select="$voucher-recipient-salutation"  /></xsl:with-param>
											<xsl:with-param name="tabindex">1</xsl:with-param>
											<xsl:with-param name="options" select="salutations" />
											<xsl:with-param name="selected" select="0" />
										</xsl:call-template>
									</span>
									<span class="cst-voucher-recipient-firstname">
										<label for="{$voucher-recipient-firstname}">[%txt.data.firstname]</label> <input type="text" id="{$voucher-recipient-firstname}" name="voucher-recipient-firstname" />
									</span>
									<span class="cst-voucher-recipient-lastname">
										<label for="{$voucher-recipient-lastname}">[%txt.data.lastname]</label> <input type="text" id="{$voucher-recipient-lastname}" name="voucher-recipient-lastname" />
									</span>
								</div>
								<div class="cst-voucher-comment clearfix">
									<label class="cst cst-voucher-detail">[%txt.comment.personal]</label>
									<div class="cst-voucher-comment-wrapper">
										<textarea class="cst-voucher" name="voucher_comment" id="{$voucher-comment}" onchange="{$voucher-form}.sum_update()" cols="{voucher-template/hvt_char_limit}" rows="{voucher-template/hvt_line_limit}"><xsl:choose><xsl:when test="package/hpa_greeting!=''"><xsl:value-of select="package/hpa_greeting" /></xsl:when><xsl:otherwise>[%txt.voucher.default.text]</xsl:otherwise></xsl:choose></textarea>
										<xsl:if test="voucher-template/hvt_line_limit != 0 or voucher-template/hvt_char_limit != 0">
											<xsl:variable name="hint-width" select="voucher-template/hvt_char_limit" />
											<xsl:variable name="hint-height" select="voucher-template/hvt_line_limit" />
											<textarea id="cst-voucher-comment-line-hint" class="cst-voucher-comment-line-hint" cols="{$hint-width}" rows="{$hint-height}">
												<xsl:attribute name="style">
													<xsl:choose>
														<xsl:when test="not($hint-height=0) and not($hint-width=0)">width: 100%; height: auto</xsl:when>
														<xsl:when test="not($hint-width=0)">width: 100%</xsl:when>
														<xsl:when test="not($hint-height=0)">height: auto</xsl:when>
													</xsl:choose>
												</xsl:attribute>
											</textarea>
										</xsl:if>
									</div>
									<xsl:if test="voucher-template/hvt_line_limit != 0 or voucher-template/hvt_char_limit != 0">
										<div class="voucher-text-limits">
											<span>[%txt.voucher.line.limit/<xsl:value-of select="$voucher-line-limit" />/<xsl:value-of select="voucher-template/hvt_line_limit" />]</span>
										</div>
									</xsl:if>
								</div>
								<ul class="cst-buttons">
									<xsl:call-template name="cstc:button">
										<xsl:with-param name="url">#</xsl:with-param>
										<xsl:with-param name="class">voucher-preview-link</xsl:with-param>
										<xsl:with-param name="id"><xsl:value-of select="$voucher-preview-link" /></xsl:with-param>
										<xsl:with-param name="target">_blank</xsl:with-param>
										<xsl:with-param name="onclick">return preview_jpg(this)</xsl:with-param>
										<xsl:with-param name="type">preview</xsl:with-param>
									</xsl:call-template>
								</ul>
								<ul class="cst-buttons">
									<xsl:if test="@service-booking = 'yes'">
										<xsl:call-template name="cstc:button">
											<xsl:with-param name="type">book</xsl:with-param>
											<xsl:with-param name="title">[%bgkrst.order.voucher]</xsl:with-param>
											<xsl:with-param name="id"><xsl:value-of select="$voucher-book-link" /></xsl:with-param>
											<xsl:with-param name="onclick">return <xsl:value-of select="$voucher-form" />.voucher_check('book');</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
								</ul>
								<script type="text/javascript">
									<xsl:value-of select="$voucher-form" />.sum_update();
								</script>
							</xsl:when>
							<xsl:otherwise>
								<h2>[%package.not.bookable]</h2>
								[%package.not.bookable.text]
							</xsl:otherwise>
						</xsl:choose>
					</div>
			</form>
			<script type="text/javascript">
				if( typeof hs != 'undefined' ) hs.maxHeight = 650;
			</script>
			<div class="clearfix"/>
		</div>

		<script type="text/javascript">
			(function($) {
				$( function() {
					$('.cst-name-voucher-info').hover(
						function() {
							$(this).siblings( '.cst-voucher-item-description' ).fadeIn( 'fast' );
							$(this).addClass( 'selected');
						},
						function() {
							$(this).siblings( '.cst-voucher-item-description' ).fadeOut( 'fast' );
							$(this).removeClass( 'selected');
						}
					);
					$('#<xsl:value-of select="$voucher-comment"/>').keyup( function(e) {
						<xsl:value-of select="$voucher-form"/>.text_update( e.keyCode );
					});
					$('#cst-voucher-comment-line-hint').hide();
					$('#<xsl:value-of select="$voucher-comment"/>').focus( function(e) {
						$('#cst-voucher-comment-line-hint').show();
					});
					$('#<xsl:value-of select="$voucher-comment"/>').blur( function(e) {
						$('#cst-voucher-comment-line-hint').hide();
					});
				});
			})(jQuery);

			function preview_jpg(a) {
				if( !<xsl:value-of select="$voucher-form"/>.voucher_check('preview') ) { return false };
				hs.expand(a);
				return false;
			}

		</script>
	</xsl:template>

	<xsl:template name="bgk-cst-request-newsletter-marketing">
		<!--<xsl:param name="form" />-->
		<xsl:if test="count(material/*)&gt;0">
			<xsl:call-template name="bgk-cst-request-marketing-hotel">
				<xsl:with-param name="material" select="material" />
				<xsl:with-param name="selected-material" select="form/material" />
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="count(hotels-materials/*/*)&gt;0">
			<fieldset class="cst-request-material">
				<legend>
					<xsl:apply-templates select="//site:match-space/site-headline">
						<xsl:with-param name="type">3</xsl:with-param>
						<xsl:with-param name="title">[%request.material]</xsl:with-param>
						<xsl:with-param name="class">cst cst-request cst-request-request-material</xsl:with-param>
					</xsl:apply-templates>
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
					<xsl:call-template name="cstc:headline">
						<xsl:with-param name="type">3</xsl:with-param>
						<xsl:with-param name="title">[%txt.newsletter]</xsl:with-param>
						<xsl:with-param name="class">cst cst-request cst-request-newsletter</xsl:with-param>
					</xsl:call-template>
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

					<xsl:apply-templates select="//site:match-space/site-headline">
						<xsl:with-param name="type">3</xsl:with-param>
						<xsl:with-param name="title">
							[%request.referer]
							<xsl:call-template name="form-element-required">
								<xsl:with-param name="field">request_referer</xsl:with-param>
								<xsl:with-param name="form" select="$form" />
							</xsl:call-template>
						</xsl:with-param>
						<xsl:with-param name="class">cst cst-request cst-request-marketing</xsl:with-param>
					</xsl:apply-templates>
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

	<xsl:template match="cstc:user-request-advertising-material-add[@page=1]">
		<xsl:variable name="form" select="." />
		<form method="post" action="{$_self}?page=3.page2&amp;hotel_id={@hotel_id}" name="form" id="cst-request-form">
			<div class="cst-request cst-request-advertising">
				<xsl:if test="count(errors/*) &gt; 0">
					<xsl:call-template name="cstc:errors">
						<xsl:with-param name="errors" select="errors" />
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="count(material/*)&gt;0 or count(marketing-actions/*) &gt; 0 or @newsletter">
					<div class="cst-box cst-request cst-request-newsletter-marketing">
						<xsl:call-template name="bgk-cst-request-newsletter-marketing">
							<!--<xsl:with-param name="form" select="." />-->
						</xsl:call-template>
						<xsl:if test="custom-elements/*">
							<xsl:apply-templates select="custom-elements" />
						</xsl:if>
					</div>
				</xsl:if>
				<div class="cst-request-advertising cst-hint">
					[%bgkrst.request.ads.comment]
				</div>
				<xsl:apply-templates select="//site:match-space/site-headline">
					<xsl:with-param name="type">2</xsl:with-param>
					<xsl:with-param name="title">[%page_add_1.data]</xsl:with-param>
					<xsl:with-param name="class">cst cst-request cst-request-advertising</xsl:with-param>
				</xsl:apply-templates>
				<div class="cst-box cst-request cst-request-user-data">
					<xsl:apply-templates select="/site:site/site:match-space/form/user-data">
						<xsl:with-param name="form" select="." />
					</xsl:apply-templates>
					<fieldset>
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
				<xsl:apply-templates select="//site:match-space/site-headline">
					<xsl:with-param name="type">3</xsl:with-param>
					<xsl:with-param name="title">[%txt.wishes]</xsl:with-param>
					<xsl:with-param name="class">cst cst-request cst-request-wishes</xsl:with-param>
				</xsl:apply-templates>
				<div class="cst-box cst-request cst-request-wishes">

					<xsl:if test="@lng_preference and count(languages/*[checked=1]) &gt; 0">
						<xsl:apply-templates select="//site:match-space/site-headline">
							<xsl:with-param name="type">3</xsl:with-param>
							<xsl:with-param name="title">[%txt.request.language.hint]</xsl:with-param>
							<xsl:with-param name="class">cst cst-language-hint</xsl:with-param>
						</xsl:apply-templates>
						<xsl:for-each select="languages/*">
							<xsl:if test="checked = 1">
								<div class="cst-language-hint-language">
									<input id="request_language_{sl_id}" type="radio" name="form[lng_preference]" value="{sl_name}">
										<xsl:if test="//site:config/@language = sl_id">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if>
									</input>
									<label for="request_language_{sl_id}">
										<img src="{//site:vars/@base-resources}images/flags/{sl_short}.gif" style="margin-right: 5px"/>
										<xsl:value-of select="sl_name" />
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

				<xsl:if test="//site:config/@privacy='true'">
					<xsl:apply-templates select="//site:match-space/site-headline">
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
					<input class="inputbutton bgk-cta" type="submit" value="� [%txt.commit]" id="sbutton" />
				</div>
			</div>
		</form>
		<xsl:call-template name="user-request-form-script" />
		<xsl:apply-templates select="track-element-form-view" />
	</xsl:template>


	<xsl:template name="bgk-cst-request-marketing-hotel">
		<xsl:param name="material" />
		<xsl:param name="selected-material" />
		<fieldset class="cst-request-material">
			<div class="cst-request-item cst-request-item-material">
				<div class="cst-request-item-images">
				<!--	<img src="{$_base_res}customize/hotel-bergkristall2/i/broschuere1.jpg" alt="" />
					<img src="{$_base_res}customize/hotel-bergkristall2/i/spa_2015.jpg" alt="" />
					<img src="{$_base_res}customize/hotel-bergkristall2/i/broschuere3.jpg" alt="" />-->
					<img src="{$_base_res}customize/hotel-bergkristall2/i/broschueren/broschuere.png" alt="" />
					<img src="{$_base_res}customize/hotel-bergkristall2/i/broschueren/infos-und-preise.png" alt="" />
					<img src="{$_base_res}customize/hotel-bergkristall2/i/broschueren/kristall-spa.png" alt="" />
				</div>
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
	
	<xsl:template match="cstc:user-request-callback-add[@page=1]">
		<xsl:variable name="form" select="." /> 
		<script type="text/javascript">_lib_load( 'vct' );</script>
		<div class="cst-request cst-request-callback"> 		
			[%request.ads.comment]
			
			<site:cms-page-content-place template-content="content1_head" replace="all">
				<h1 class="cst-head">[%request.callback]</h1>
			</site:cms-page-content-place>
			
			<form method="post" action="{$_self}?page=4.page2&amp;hotel_id={@hotel_id}" name="form" id="cst-request-form">
				<xsl:if test="count(errors/*) &gt; 0">
					<xsl:call-template name="cstc:errors">
						<xsl:with-param name="errors" select="errors" />
					</xsl:call-template>
				</xsl:if>
				<xsl:apply-templates select="//site:match-space/site-headline">
		 			<xsl:with-param name="type">2</xsl:with-param>
			 		<xsl:with-param name="title">[%request.callback.hotel.add.data]</xsl:with-param>
			 		<xsl:with-param name="class">cst cst-request</xsl:with-param>
		 		</xsl:apply-templates>
					<div class="cst-box cst-request-callback-user-data">
						<fieldset>
							<legend>
								<xsl:apply-templates select="//site:match-space/site-headline">
						 			<xsl:with-param name="type">3</xsl:with-param>
							 		<xsl:with-param name="title">[%txt.personaldata]</xsl:with-param>
							 		<xsl:with-param name="class">cst cst-request</xsl:with-param>
						 		</xsl:apply-templates>
							</legend>
							<div class="cst-request-item cst-request-item-salutation">
							<xsl:choose>
								<xsl:when test="//site:config/@language-str='ru'">
									<input type="hidden" name="form[request_user_title]" value="0" />
								</xsl:when>
								<xsl:otherwise>
								<label for="salutation">[%txt.salutation]</label>
								<ul class="cst-request-salutation-inputs">
									<li class="cst-request-salutation-input-male">
										<input class="inputradio" id="sal_male" type="radio" name="form[request_user_title]" value="0" tabindex="1"/>
										<label class="" for="sal_male">[%txt.salutation.mr]</label>
									</li>
									<li class="cst-request-salutation-input-female">
										<input class="inputradio" id="sal_female" type="radio" name="form[request_user_title]" value="1" tabindex="2"/>
										<label class="" for="sal_female">[%txt.salutation.mrs]</label>
									</li>
									<!-- li class="cst-request-salutation-input-company">
										<input class="inputradio" id="sal_company" type="checkbox" name="form[request_user_title]" value="2" onclick="document.getElementById('cst-request-item-company').style.display == 'none'"/>
										<label class="" for="sal_company">[%txt.salutation.company]</label>
									</li-->
									<li class="cst-request-salutation-input-family">
										<input class="inputradio" id="sal_family" type="radio" name="form[request_user_title]" value="3" tabindex="3"/>
										<label class="" for="sal_family">[%txt.salutation.family]</label>
									</li>
								</ul>
								<a class="cst-request-add cst-request-add-company" href="#" tabindex="5">[%txt.add.icon][%txt.add.company]</a>
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
							<input type="text" name="form[request_user_title_academic]" value="{form/request_user_title_academic}" class="inputtext inputtext-academic" tabindex="6" />
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
							<input type="text" id="company" name="form[request_user_company]" value="{form/request_user_company}" class="inputtext inputtext-company" tabindex="7" />
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
							<input type="text" id="firstname" name="form[request_user_firstname]" value="{form/request_user_firstname}" class="inputtext inputtext-firstname" tabindex="9" />
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
							<input type="text" id="lastname" name="form[request_user_lastname]" value="{form/request_user_lastname}" class="inputtext inputtext-lastname" tabindex="10" />
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
							<input type="text" id="country" name="form[request_user_country]" value="{form/request_user_country}" class="inputtext inputtext-country" tabindex="11" />
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
							<input type="text" id="phone" name="form[request_user_telefon]" value="{form/request_user_telefon}" class="inputtext inputtext-phone" tabindex="12" />																					
						</div>		
					</fieldset>
					<fieldset>
						<legend>
							<xsl:apply-templates select="//site:match-space/site-headline">
					 			<xsl:with-param name="type">3</xsl:with-param>
						 		<xsl:with-param name="title">[%request.callback.hotel.add.date]</xsl:with-param>
						 		<xsl:with-param name="class">cst cst-request</xsl:with-param>
					 		</xsl:apply-templates>
						</legend>
						<div class="cst-request-item cst-request-item-callback-date">
							<label for="date">
								[%request.callback.hotel.date.label]
								<xsl:call-template name="form-element-required">
									<xsl:with-param name="field">callbackdate</xsl:with-param>
									<xsl:with-param name="form" select="$form" />
								</xsl:call-template>
							</label>
							<input type="text" name="form[callbackdate]" value="{form/callbackdate}" size="7" class="inputtext inputtext-callback-date" tabindex="13" id="callbackDate" />										
							<xsl:call-template name="cstc:user-calendar-jquery">
								<xsl:with-param name="obj_id">callbackDate</xsl:with-param>
							</xsl:call-template>
						</div>
						
						<div class="cst-request-item cst-request-item-callback-time">
							<label for="time">[%request.callback.hotel.time.label]
								<xsl:call-template name="form-element-required">
									<xsl:with-param name="field">callbacktime</xsl:with-param>
									<xsl:with-param name="form" select="$form" />
								</xsl:call-template>	
							</label>
							<input type="text" name="form[callbacktime]" value="{form/callbacktime}" size="7" class="inputtext inputtext-callback-time" tabindex="14" id="callbackTime" />&#160;<span class="hint">[%request.callback.hotel.time.example]</span>
						</div>
					</fieldset>
				</div>
				<div class="cst-box cst-request-wishes">
					<fieldset>
						<legend>
							<xsl:apply-templates select="//site:match-space/site-headline">
					 			<xsl:with-param name="type">3</xsl:with-param>
						 		<xsl:with-param name="title">[%request.callback.hotel.wishes]</xsl:with-param>
						 		<xsl:with-param name="class">cst cst-request</xsl:with-param>
					 		</xsl:apply-templates>
						</legend>
						<div class="cst-request-item cst-request-item-wishes">
							<textarea rows="7" cols="40" name="form[request_wishes]" class="form-whishes" tabindex="15">
								<xsl:value-of select="form/request_wishes" />
							</textarea>		
						</div>
					</fieldset>
				</div>											 
			 	
			 	<!-- Custom elements -->
				<xsl:if test="custom-elements/*">
					<div class="user_data"><xsl:apply-templates select="custom-elements" /></div>
				</xsl:if>
				
				<xsl:if test="//site:config/@privacy='true'">
					<div class="cst-privacy user_data">
						<xsl:apply-templates select="//site:match-space/site-headline">
							<xsl:with-param name="type">3</xsl:with-param>
							<xsl:with-param name="title">[%txt.privacy]</xsl:with-param>
						</xsl:apply-templates>
						<span class="cst-privacy-statement">[%txt.privacy.statement]</span>
						<xsl:if test="hotel/hotel_url">
							<xsl:call-template name="privacy-link">
								<xsl:with-param name="url" select="hotel/hotel_url" />
							</xsl:call-template>
						</xsl:if>
					</div>
				</xsl:if>	
				
				<div class="request-button">
					<!-- spam protection dummy request_detail_text -->
					<div class="cst-request-detail-text">
						<input name="form[request_detail_text]" value="" />
					</div>
					<input type="submit" class="inputbutton" value="[%txt.commit]" id="sbutton" />
				</div>		
			</form>
		</div>
		<xsl:apply-templates select="track-element-form-view" />
	</xsl:template>

	<xsl:template match="cstc:job-detail">

		<xsl:if test="not( job/hj_image = 0 )">
			<site:cms-page-content-place template-content="gallery" replace="all">
				<div class="content-placed-image"><img src="{job/hj_image}/936x520s" alt="{job/hj_name}" /></div>
			</site:cms-page-content-place>
		</xsl:if>

		<div class="cst-detail cst-job-detail">

			<div class="cst-box cst-box-job-info">
				<xsl:apply-templates select="//site:match-space/site-headline">
					<xsl:with-param name="type">2</xsl:with-param>
					<xsl:with-param name="title" select="job/hj_name" />
					<xsl:with-param name="class">cst cst-detail-job</xsl:with-param>
				</xsl:apply-templates>

				<div class="cst-teaser-text">
					<div class="cst-job-category">
						<xsl:call-template name="cstc:formatted-text">
							<xsl:with-param name="text-node" select="job/hjc_name" />
						</xsl:call-template>
					</div>
					<div class="cst-job-position">
						<xsl:call-template name="cstc:formatted-text">
							<xsl:with-param name="text-node" select="job/hj_position" />
						</xsl:call-template>
					</div>
					<div class="cst-job-begin">
						[%txt.job.begin]:
						<xsl:choose>
							<xsl:when test="job/hj_begin_display = '0000-00-00'">
								<b>[%txt.job.avail.instant]</b>
							</xsl:when>
							<xsl:otherwise>
								<b>
									<xsl:call-template name="cstc:formatted-text">
										<xsl:with-param name="text-node" select="job/hj_begin_display" />
									</xsl:call-template>
								</b>
							</xsl:otherwise>
						</xsl:choose>
					</div>
					<div class="cst-job-text">
						<xsl:call-template name="cstc:formatted-text">
							<xsl:with-param name="text-node" select="job/hj_text" />
						</xsl:call-template>
					</div>
				</div>
			</div>

			<div class="cst-box cst-box-job-contact">
				<div class="cst-job-contact">
					<xsl:apply-templates select="//site:match-space/site-headline">
						<xsl:with-param name="type">2</xsl:with-param>
						<xsl:with-param name="title">[%txt.job.contact]</xsl:with-param>
						<xsl:with-param name="class">cst cst-job-contact</xsl:with-param>
					</xsl:apply-templates>
					<xsl:if test="job/hj_contact_name != ''">
						<div class="cst-job-contact-name"><xsl:value-of select="job/hj_contact_name" /></div>
					</xsl:if>
					<xsl:if test="job/hj_contact_email != ''">
						<div class="cst-job-contact-email">[%txt.email]: <a href="mailto:{job/hj_contact_email}"><xsl:value-of select="job/hj_contact_email" /></a></div>
					</xsl:if>
					<xsl:if test="job/hj_contact_tel != ''">
						<div class="cst-job-contact-tel">[%txt.telefon]: <xsl:value-of select="job/hj_contact_tel" /></div>
					</xsl:if>

					<xsl:if test="cstc:hotel-teaser/hotel_nameaffix !=''"><div class="cst-job-hotel-name-affix"><xsl:value-of select="cstc:hotel-teaser/hotel_nameaffix" />&#160;</div></xsl:if>
					<xsl:if test="cstc:hotel-teaser/hotel_name !=''"><div class="cst-job-hotel-name"><xsl:value-of select="cstc:hotel-teaser/hotel_name" /></div></xsl:if>
					<xsl:if test="cstc:hotel-teaser/hotel_street !=''"><div class="cst-job-hotel-street"><xsl:value-of select="cstc:hotel-teaser/hotel_street" /></div></xsl:if>


					<xsl:if test="cstc:hotel-teaser/hotel_zip !=''"><div class="cst-job-hotel-zip"><xsl:value-of select="cstc:hotel-teaser/hotel_zip" />&#160;</div></xsl:if>
					<xsl:if test="cstc:hotel-teaser/hotel_city !=''"><div class="cst-job-hotel-city"><xsl:value-of select="cstc:hotel-teaser/hotel_city" /><xsl:text> </xsl:text>(</div></xsl:if>
					<xsl:if test="cstc:hotel-teaser/state_name !=''"><div class="cst-job-hotel-state"><xsl:value-of select="cstc:hotel-teaser/state_name" /><xsl:text>, </xsl:text></div></xsl:if>
					<xsl:if test="cstc:hotel-teaser/country_name !=''"><div class="cst-job-hotel-country"><xsl:value-of select="cstc:hotel-teaser/country_name" /><xsl:text>)</xsl:text></div></xsl:if>
				</div>
				<ul class="cst-buttons">
					<xsl:apply-templates select="//site:match-space/site-links/normal">
						<xsl:with-param name="url">javascript:history.back(-1);</xsl:with-param>
						<xsl:with-param name="class">cst-link cst-link-back</xsl:with-param>
						<xsl:with-param name="title">[%txt.back]</xsl:with-param>
						<xsl:with-param name="type">back</xsl:with-param>
					</xsl:apply-templates>
				</ul>
			</div>

		</div>
	</xsl:template>

	<xsl:template match="cstc:program-list">
		<xsl:if test="count( crits/ids_program_indicators/* ) &gt; 0">
			<xsl:variable name="crit_coi_id" select="crits/ids_program_indicators/*[1]" />
			<site:cms-page-content-place template-content="content1_head" replace="all">
				<h1 class="cst-head"><xsl:value-of select="indicators/*[coi_id = $crit_coi_id]/coi_name_str" /> [%txt.programs]</h1>
				<h2>[%bgkrst.overview]</h2>
			</site:cms-page-content-place>
			<site:cms-page-content-place template-content="content1_head" replace="none">
				<ul class="cst-hrt-links">
					<li class="cst-link-back cst-hrt-link-back"><a href="./" class="cst-hrt-link">
						<span class="default">�</span>
						<span class="mobile">�</span>
						<xsl:text> [%txt.back]</xsl:text>
					</a></li>
				</ul>
			</site:cms-page-content-place>
			<xsl:if test="not( indicators/*[coi_id = $crit_coi_id]/coi_image = 0 )">
				<site:cms-page-content-place template-content="gallery" replace="all">empty</site:cms-page-content-place>
				<site:cms-page-content-place template-content="content1_head" replace="none">
					<div class="content-placed-image no-padding"><img src="{indicators/*[coi_id = $crit_coi_id]/coi_image}/960x404s" alt="{indicators/*[coi_id = $crit_coi_id]/coi_name}" /></div>
				</site:cms-page-content-place>
			</xsl:if>
		</xsl:if>

		<div class="cst-list cst-list-program">
			<xsl:for-each select="programs/*">
				<!-- <xsl:sort select="@group-id" order="ascending" data-type='number'/> -->
				<xsl:variable name="indicator_id" select="@group-id"/>
				<xsl:variable name="parent_indicator_id" select="../program-group/*/indicators/*/coi_parent"/>

				<xsl:if test="position()=1">
					<xsl:call-template name="cstc:headline">
						<xsl:with-param name="type">1</xsl:with-param>
						<xsl:with-param name="class">cst cst-list-program-indicator-parent cst-list-program-indicator-parent-<xsl:value-of select="$parent_indicator_id"/></xsl:with-param>
						<xsl:with-param name="title"><xsl:value-of select="../../indicators/*[coi_id=$parent_indicator_id]/coi_name"/></xsl:with-param>
					</xsl:call-template>
				</xsl:if>

				<div class="cst-group cst-group-program cst-group-program-{@group-id}">

					<xsl:if test="position()=last()">
						<xsl:attribute name="class">cst-group cst-group-program cst-group-program-<xsl:value-of select="@group-id"/> cst-group-program-last</xsl:attribute>
					</xsl:if>

					<xsl:call-template name="cstc:headline">
						<xsl:with-param name="type">2</xsl:with-param>
						<xsl:with-param name="title"><xsl:value-of select="@group-name"	/></xsl:with-param>
						<xsl:with-param name="class">cst cst-list-program-indicator cst-list-program-indicator-<xsl:value-of select="$indicator_id"/></xsl:with-param>
					</xsl:call-template>

					<xsl:if test="$indicator_id!=''">
						<xsl:choose>
							<xsl:when test="string-length(../../indicators/*[coi_id=$indicator_id]/coi_teaser)&gt;1">
								<div class="cst-list-program-indicator-teaser">
									<xsl:call-template name="cstc:formatted-text">
										<xsl:with-param name="text-node" select="../../indicators/*[coi_id=$indicator_id]/coi_teaser"/>
									</xsl:call-template>
								</div>
							</xsl:when>
							<xsl:otherwise>
								<div class="cst-list-indicator-border"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>

					<xsl:for-each select="*">
						<xsl:sort select="hp_order" order="ascending" data-type='number'/>
						<div id="cst-box-program-{hp_id}" class="cst-box">
							<xsl:choose>
								<xsl:when test="position() mod 2 = 0 and string-length(hp_image) = 1">
									<xsl:attribute name="class">cst-box cst-box-even cst-box-no-media</xsl:attribute>
								</xsl:when>
								<xsl:when test="position() mod 2 = 0">
									<xsl:attribute name="class">cst-box cst-box-even</xsl:attribute>
								</xsl:when>
								<xsl:when test="string-length(hp_image) = 1">
									<xsl:attribute name="class">cst-box cst-box-no-media</xsl:attribute>
								</xsl:when>
							</xsl:choose>
							<xsl:apply-templates select="/site:site/site:match-space/hotel/programs/teaser">
								<xsl:with-param name="program" select="." />
							</xsl:apply-templates>
						</div>
					</xsl:for-each>
				</div>
			</xsl:for-each>
		</div>
		<xsl:if test="not(programs/*)">
			<div class="cst-not-found">
				[%generallist.nofound/[%txt.programs]]
			</div>
		</xsl:if>

	</xsl:template>


</xsl:stylesheet>
