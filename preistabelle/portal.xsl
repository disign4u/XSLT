<?xml version = "1.0" encoding = "UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:site="http://xmlns.webmaking.ms/site/" xmlns:cstc="http://xmlns.webmaking.ms/cstc/"
                exclude-result-prefixes="site cstc">
		
	<xsl:template match="cstc:site">
		<xsl:if test="not( //site:cms/@template-content-name='nl-cst') and not( //site:cms/@template-content-name='nl-content' )">
			<!-- <link rel="stylesheet" type="text/css" href="{$_base_res}css/themes/html5/silver.css?version={$_version_cache}" />
			<link rel="stylesheet" type="text/css" href="{$_base_res}customize/skel/css/style.css" /> -->
		</xsl:if>
		
		<xsl:apply-templates />
		
	</xsl:template>

	<xsl:template match="search-form-js-custom">
		<script src="{$_base_res}customize/hotel-mirabell-hafling/js/portal.js?version={$_version_cache}" />
	</xsl:template>
	
	<xsl:template match="cstc:package-teaser[/site:site/site:cms/@template-content-name='top-offers']">
		<div class="box-top-offers">
			<h2><xsl:value-of select="package/hpa_name" /></h2>
			<xsl:if test="not( package/hpa_image = 0 ) and /site:site/site:config/@list-images='true'">
				<div class="img-top-offers" style="background-image: url({package/hpa_image}/604x400s);"></div>
			</xsl:if>
			
			<xsl:for-each select="avail/custom-elements/variant-groupings/*[1]">
				<xsl:sort select="avail/ht_from_ts" order="ascending" />
				<div class="details-top-offers">
					<div class="stay-top-offers">
						<strong>
							<xsl:value-of select="avail/hpa_stays" /> [%txt.stays.numerus/<xsl:value-of select="avail/hpa_stays" />]
						</strong>
					</div>
					<div class="date-top-offers">
						<xsl:value-of select="tf-avail/*[1]/ht_from_display" /> - <xsl:value-of select="tf-avail/*[1]/ht_to_display" />
					</div>
					<div class="price-top-offers">
						[%txt.price.from] <strong><xsl:value-of select="avail/hpa_price" /></strong> [%txt.perperson]
					</div>
				</div>
				<ul class="cst-buttons">
					<xsl:call-template name="cstc:button">
						<xsl:with-param name="type">detail</xsl:with-param>
					</xsl:call-template>
				</ul>
			</xsl:for-each>
		</div>
	</xsl:template>
	
	<xsl:template match="cstc:package-teaser[/site:site/site:cms/@template-content-name='slider']">
		<div class="box-slider-offers">
			<xsl:if test="not( package/hpa_image = 0 ) and /site:site/site:config/@list-images='true'">
				<a href="{@url}"><span class="img-slider-offers" style="background-image: url({package/hpa_image}/180x100s);"/></a>
			</xsl:if>
			<div class="text-slider-offers">
				<!--<ul class="cst-buttons">-->
					<!--<xsl:call-template name="cstc:button">-->
						<!--<xsl:with-param name="type">detail</xsl:with-param>-->
					<!--</xsl:call-template>-->
				<!--</ul>-->
				<h2><xsl:value-of select="package/hpa_name" /></h2>
				<xsl:for-each select="avail/custom-elements/variant-groupings/*[1]">
					<xsl:sort select="avail/ht_from_ts" order="ascending" />
					<p class="details-slider-offers">
						<xsl:value-of select="avail/hpa_stays" /> [%txt.stays.numerus/<xsl:value-of select="avail/hpa_stays" />]
						/
						<xsl:value-of select="tf-avail/*[1]/ht_from_display" /> - <xsl:value-of select="tf-avail/*[1]/ht_to_display" />
						/
						
						[%txt.price.from] <strong><xsl:value-of select="avail/hpa_price" /></strong> [%txt.perperson]
					</p>
				</xsl:for-each>
				<div class="details_link">
					<a href="{@url}"/>
				</div>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="cstc:roomtype-prices-childrens">
		<xsl:param name="prices" />
		<xsl:param name="price-type" />
		<xsl:param name="display-cols">4</xsl:param>
		<xsl:variable name="roomtype-pensions" select="../../room-type-pensions"/> 
		<xsl:if test="$prices/season-groups/* and $prices/childrens/*">
		<div class="children-table">
			<table class="roomtype-prices roomtype-prices-children" cellpadding="0" cellspacing="0" border="0">
					<xsl:if test="count($prices/season-group-unique-ids-new/*) &gt; 1">
						<tr class="head">
							<td><div class="children-age">[%txt.age]</div></td>
							<xsl:for-each select="$prices/childrens/*[hch_from != 14]"><!-- Task 467347 - kinder alter 14-19 ausblenden -->
								<xsl:sort select="hch_from" order="ascending" data-type="number"/>
								<td class="child"><xsl:value-of select="hch_from" /> - <xsl:value-of select="hch_to" />&#160;<span>[%txt.years]</span></td>												
							</xsl:for-each>
						</tr>	
					</xsl:if>

					<xsl:for-each select="$prices/season-group-unique-date-froms/*">
						<xsl:sort select="@timestamp" order="ascending" data-type="number" />
						<xsl:variable name="season_ts" select="@timestamp" />
						<xsl:variable name="season" select="$prices/season-groups/season-group/seasons/season[hs_from_ts = $season_ts]" />
						<xsl:if test="$season">
							<xsl:variable name="seasons-uniq-id" select="$season[1]/hs_id" />
							<tr>
								<td class="season">
									<xsl:for-each select="$season[1]">
										<xsl:call-template name="mh-roomtype-season" />
									</xsl:for-each>
								</td>
								<xsl:for-each select="$prices/childrens/*[hch_from != 14]"><!-- Task 467347 - kinder alter 14-19 ausblenden -->
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
		</div>
		</xsl:if>
	</xsl:template>  	
	
	<xsl:template name="mh-roomtype-season">

		<div class="season-name">
			<xsl:choose>
				<xsl:when test="string-length(hs_name_public)&gt;0">
					<xsl:value-of select="hs_name_public" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="hs_name" />
				</xsl:otherwise>
			</xsl:choose>
		</div>

		<xsl:for-each select="dates/*">
			<!--<xsl:sort select="hs_from_ts" order="ascending" data-type="number"/>-->
			<div class="season-date"><xsl:value-of select="hs_from" /> - <xsl:value-of select="hs_to" /></div>
		</xsl:for-each>
		
		<xsl:if test="count(weekdays/*)!=7">
			<div class="season-weekdays">
				[%txt.arrival]
				<xsl:for-each select="weekdays/*">
					[%date.day.<xsl:value-of select="@num" />]<xsl:if test="position()!=last()">, </xsl:if>
				</xsl:for-each>
			</div>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="cstc:general-list[/site:site/site:cms/@template-content-name='slider' or /site:site/site:cms/@template-content-name='top-offers' ]">	
		<div class="cst-list cst-list-{@type}">						
			<xsl:if test="@type='package' and @item-indicator!=''">
				<xsl:attribute name="class">cst-list cst-list-<xsl:value-of select="@type"/> cst-list-package-indicator-<xsl:value-of select="@item-indicator"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="@type='package' and @item-type='4'">
				<xsl:attribute name="class">cst-list cst-list-voucher</xsl:attribute>
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
					<xsl:variable name="max"><xsl:choose>
						<xsl:when test="/site:site/site:cms/@template-content-name='top-offers'">4</xsl:when>
						<xsl:otherwise>12</xsl:otherwise>
					</xsl:choose>
					</xsl:variable>
					<xsl:for-each select="*[position() &lt;= $max]">						
						<xsl:apply-templates select=".">
							<xsl:with-param name="pos" select="position()"></xsl:with-param>
						</xsl:apply-templates>						
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

    <xsl:template match="/site:site/site:match-space/hotel/programs/content-variants">
        <xsl:param name="program" />

        <xsl:if test="$program/tf-avail/*">
            <ul class="cst-timeframes">
                <xsl:for-each select="$program/tf-avail/*">
                    <li class="cst-timeframe">
                        <span class="cst-timeframe-from"><xsl:value-of select="ht_from_display"/></span>
                        <span class="cst-binder">-</span>
                        <span class="cst-timeframe-to"><xsl:value-of select="ht_to_display"/></span>
                    </li>
                </xsl:for-each>
            </ul>
        </xsl:if>

        <xsl:if test="string-length($program/hp_desc_teaser) &gt; 1 or $program/hp_duration &gt; 0">
            <div class="cst-teaser-text cst-teaser-text-variant">
                <xsl:if test="string-length($program/hp_desc_teaser) &gt; 1">
                    <xsl:copy-of select="$program/hp_desc_teaser/node()" />
                </xsl:if>

                <xsl:if test="$program/hp_duration &gt; 0">
                    <div class="cst-program-duration">
                        [%txt.stayduration.min]: <xsl:value-of select="$program/hp_duration" />
                        <xsl:choose>
                            <xsl:when test="$program/hp_duration=1"> [%txt.stay]</xsl:when>
                            <xsl:otherwise> [%txt.stays]</xsl:otherwise>
                        </xsl:choose>
                    </div>
                </xsl:if>
            </div>
        </xsl:if>
        <xsl:for-each select="$program/custom-elements/variant-groupings/*">
            <xsl:sort select="info/hp_order" order="ascending" data-type="number" />
            <div class="cst-program-variant">
                <xsl:variable name="pos" select="position()"/>
                <xsl:if test="$pos mod 2 = 0">
                    <xsl:attribute name="class">cst-program-variant cst-odd</xsl:attribute>
                </xsl:if>
                <xsl:if test="$pos=last()">
                    <xsl:attribute name="class">cst-program-variant cst-program-variant-last</xsl:attribute>
                </xsl:if>
                <xsl:if test="$pos=last() and $pos mod 2=0">
                    <xsl:attribute name="class">cst-program-variant cst-program-variant-last cst-odd</xsl:attribute>
                </xsl:if>
                <xsl:if test="string-length(type) &gt; 2">
                    <div class="cst-program-variant-type"><xsl:value-of select="type" /></div>
                </xsl:if>
                <xsl:if test="info/hp_treatment_length &gt; 0">
                    [%txt.duration/<xsl:value-of select="info/hp_treatment_length" />]<br/>
                </xsl:if>
                <xsl:if test="string-length(info/hp_desc_cms) &gt; '5'">
                    <div class="cst-description-text">
                        <div class="cst-teaser cst-program-teaser-description"  id="cst-teaser-description-{info/hp_id}">
                            <xsl:attribute name="style">
                                <xsl:text>display: none;</xsl:text>
                            </xsl:attribute>
                            <xsl:copy-of select="info/hp_desc_cms/node()" />
                        </div>
                    </div>
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
                    <xsl:when test="avail/ht_to='0000-00-00' and avail/ht_from = avail/from">
                        <div class="cst-timeframe cst-timeframe-special">
                            [%txt.from] <xsl:value-of select="substring(avail/ht_from,9,2)" />.<xsl:value-of select="substring(string(avail/ht_from),6,2)" />
                        </div>
                    </xsl:when>
                </xsl:choose>
                <div class="cst-price">
                    <span class="cst-price-number">
                        <xsl:value-of select="info/hp_price" /><span>&#160;[%txt.perperson]</span>
                    </span>
                    <xsl:if test="string-length(info/hp_desc_cms) &gt; 10">
                        <script type="text/javascript">
                            _lib_load( 'jQuery', 'vct' );
                        </script>
                        <xsl:variable name="onclick">jQuery( this ).contentToggle('[%txt.details;escape-single-quote]|[%txt.info.less]', '#cst-teaser-description-<xsl:value-of select="info/hp_id" />' ); return false;</xsl:variable>
                            <a href="" class="cst-program-more-link" onclick="{$onclick}"><span>[%txt.details]</span></a>
                    </xsl:if>
                </div>
                <ul class="cst-buttons">
                    <xsl:if test="/site:site/site:config/@remember='1' or /site:site/site:config/@remember-vnh='true'">
                        <xsl:apply-templates select="//site:match-space/site-links/remember">
                            <xsl:with-param name="id">hp<xsl:value-of select="info/hp_id" /></xsl:with-param>
                            <xsl:with-param name="price"><xsl:value-of select="info/hp_price" /></xsl:with-param>
                            <xsl:with-param name="title"><xsl:value-of select="info/hp_name" /></xsl:with-param>
                            <xsl:with-param name="hotel"><xsl:value-of select="hotel/hotel_nameaffix" /></xsl:with-param>
                            <xsl:with-param name="hotel-id"><xsl:value-of select="info/hp_hotel" /></xsl:with-param>
                            <xsl:with-param name="link"></xsl:with-param>
                            <xsl:with-param name="class">cst-link cst-link-notice</xsl:with-param>
                        </xsl:apply-templates>
                    </xsl:if>

                    <xsl:if test="not( info/@requestable ) or info/@requestable = 'true'">
                        <xsl:call-template name="cstc:button">
                            <xsl:with-param name="type">request</xsl:with-param>
                            <xsl:with-param name="url">request.php?page=5.page1<xsl:value-of select="substring-after(info/@url-request,'2.page1')"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:if>

                    <!-- <xsl:if test="not( info/@bookable ) or info/@bookable = 'true'">
                        <xsl:call-template name="cstc:button">
                            <xsl:with-param name="type">book</xsl:with-param>
                            <xsl:with-param name="url"><xsl:value-of select="info/@url-booking"/></xsl:with-param>
                        </xsl:call-template>
                    </xsl:if> -->
                </ul>
                <div class="clearfix"/>
            </div>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="cstc:program-list[not(../cstc:remote-config) and not(programs//hp_id = '51342')]"><!-- [count(programs/*) > 1] -->
        <div class="cst-list cst-list-program">
            <xsl:for-each select="programs/*">
                <!-- <xsl:sort select="@group-id" order="ascending" data-type='number'/> -->
                <xsl:variable name="indicator_id" select="@group-id"/>
                <xsl:variable name="parent_indicator_id" select="../program-group/*/indicators/*/coi_parent"/>

                <!-- <xsl:if test="position()=1 and not($parent_indicator_id = 20705) and not(../../indicators/*[coi_id=$parent_indicator_id]/coi_name = '')">
                    <xsl:call-template name="cstc:headline">
                        <xsl:with-param name="type">1</xsl:with-param>
                        <xsl:with-param name="class">clearfix</xsl:with-param>
                        <xsl:with-param name="title"><xsl:value-of select="../../indicators/*[coi_id=$parent_indicator_id]/coi_name"/></xsl:with-param>
                    </xsl:call-template>
                </xsl:if> -->
                <div class="slider-group">

                    <!-- <xsl:call-template name="cstc:headline">
                        <xsl:with-param name="type">2</xsl:with-param>
                        <xsl:with-param name="title"><xsl:value-of select="@group-name"	/></xsl:with-param>
                        <xsl:with-param name="class">acordeon cst cst-list-program-indicator cst-list-program-indicator-<xsl:value-of select="$indicator_id"/></xsl:with-param>
                    </xsl:call-template> -->
                    <h3 class="slider"><xsl:value-of select="@group-name"	/></h3>

                    <div class="slider cst-group cst-group-program">
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
                                    <xsl:when test="position() mod 2 = 0 and string-length(hp_image = 1)">
                                        <xsl:attribute name="class">cst-box cst-box-even cst-box-no-media</xsl:attribute>
                                    </xsl:when>
                                    <xsl:when test="position() mod 2 = 0">
                                        <xsl:attribute name="class">cst-box cst-box-even</xsl:attribute>
                                    </xsl:when>
                                    <xsl:when test="string-length(hp_image = 1)">
                                        <xsl:attribute name="class">cst-box cst-box-no-media</xsl:attribute>
                                    </xsl:when>
                                </xsl:choose>
                                <xsl:apply-templates select="/site:site/site:match-space/hotel/programs/teaser">
                                    <xsl:with-param name="program" select="." />
                                </xsl:apply-templates>
                            </div>
                        </xsl:for-each>
                    </div>
                </div>
            </xsl:for-each>
        </div>
        <xsl:if test="not(programs/*)">
            <div class="cst-not-found">
                [%generallist.nofound/[%txt.programs]]
            </div>
        </xsl:if>

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
        <div class="cst-detail cst-detail-voucher">
            <xsl:call-template name="cstc:headline">
                <xsl:with-param name="type">1</xsl:with-param>
                <xsl:with-param name="title">
                    <xsl:choose>
                        <xsl:when test="package/custom-elements/variant-grouping">
                            <xsl:value-of select="package/custom-elements/variant-grouping/name"></xsl:value-of>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="package/hpa_name/node()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="class">cst cst-detail-voucher</xsl:with-param>
            </xsl:call-template>
            <div class="cst-box">
                <ul class="cst-media">
                    <xsl:call-template name="cstc:image">
                        <xsl:with-param name="src" >
                            <xsl:choose>
                                <xsl:when test="not(package/hpa_image=0)"><xsl:value-of select="package/hpa_image"></xsl:value-of></xsl:when>
                                <xsl:otherwise><xsl:value-of select="//site:vars/@base-resources"/>images/cst-voucher-default.png</xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                        <xsl:with-param name="alt">
                            <xsl:value-of select="package/hpa_name" />
                        </xsl:with-param>
                        <xsl:with-param name="img-class">cst-image reflect ropacity40</xsl:with-param>
                        <xsl:with-param name="group">voucher</xsl:with-param>
                        <xsl:with-param name="thumbs">1</xsl:with-param>
                    </xsl:call-template>
                </ul>
                <div class="cst-box-content">
                    <xsl:call-template name="cstc:headline">
                        <xsl:with-param name="type">3</xsl:with-param>
                        <xsl:with-param name="title" select="package/hpa_name/node()" />
                        <xsl:with-param name="class">cst cst-detail-voucher</xsl:with-param>
                    </xsl:call-template>
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

                    <div class="clearfix"/>
                    <div class="cst-background-box">
                        <div class="cst-voucher-price-sum">
                            <xsl:choose>
                                <xsl:when test="count( package-detail/programs/optional/* ) &gt; 0 or count( package-room-types/* ) &gt; 0">
                                    <xsl:call-template name="cstc:headline">
                                        <xsl:with-param name="type">3</xsl:with-param>
                                        <xsl:with-param name="title">[%txt.amount.money]</xsl:with-param>
                                        <xsl:with-param name="class">cst cst-voucher-detail</xsl:with-param>
                                    </xsl:call-template>
                                    <div class="cst-price">
                                        <span class="cst-price-number" id="{$voucher-sum}"><xsl:value-of select="package/hpa_price_normal" /><xsl:text> </xsl:text> <xsl:value-of select="//site:config/@currency-sign" /></span>
                                    </div>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:call-template name="cstc:headline">
                                        <xsl:with-param name="type">3</xsl:with-param>
                                        <xsl:with-param name="title">[%txt.amount.money]</xsl:with-param>
                                        <xsl:with-param name="class">cst cst-voucher-detail</xsl:with-param>
                                    </xsl:call-template>
                                    <xsl:choose>
                                        <xsl:when test="package/hpa_price_selectable=1">
                                            <span class="voucher-amount"><input id="{$voucher-amount}" class="inputtext inputtext-vocher-amount" name="voucher_amount" type="text" value="{package/hpa_price_normal}" style="text-align: right;" onkeydown="var e = event || window.event; if(event.keyCode==13) return false;" onblur="{$voucher-form}.voucher_check('preview')" onchange="{$voucher-form}.sum_update()" /></span>
                                            <span class="voucher-currency-sign"><xsl:value-of select="/site:site/site:config/@currency-sign" /></span>
                                            <div class="voucher-edit-hint">[%txt.amount.money.edit/<xsl:value-of select="/site:site/site:config/@currency-sign" />]</div>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <span id="{$voucher-amount}" class="cst-voucher-amount cst-price-number"><xsl:value-of select="package/hpa_price_normal" /><xsl:text> </xsl:text><xsl:value-of select="/site:site/site:config/@currency-sign" /></span>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </div>
                        <xsl:if test="package/hpa_price_selectable=1 and (package/hpa_price_max!=0 or package/hpa_price_min!=0 or package/hpa_programs_max!=0 or package/hpa_programs_min!=0)">
                            <div class="cst-voucher-value-range">
                                <xsl:call-template name="cstc:headline">
                                    <xsl:with-param name="type">3</xsl:with-param>
                                    <xsl:with-param name="title">[%txt.value.range]</xsl:with-param>
                                    <xsl:with-param name="class">cst cst-voucher-detail</xsl:with-param>
                                </xsl:call-template>
                                <span class="cst-voucher-range-hint cst-voucher-range-hint-voucher">
                                    <xsl:choose>
                                        <xsl:when test="package/hpa_price_min!=0 and package/hpa_price_max!=0">
                                            [%txt.voucher.range/<xsl:value-of select="format-number(package/hpa_price_min,'##0,00','european')" />/<xsl:value-of select="/site:site/site:config/@currency-sign" />/<xsl:value-of select="format-number(package/hpa_price_max,'##0,00','european')" />/<xsl:value-of select="/site:site/site:config/@currency-sign" />]
                                        </xsl:when>
                                        <xsl:when test="package/hpa_price_min!=0">
                                            [%txt.voucher.range.min/<xsl:value-of select="format-number(package/hpa_price_min,'##0,00','european')" />/<xsl:value-of select="/site:site/site:config/@currency-sign" />]
                                        </xsl:when>
                                        <xsl:when test="package/hpa_price_max!=0">
                                            [%txt.voucher.range.max/<xsl:value-of select="format-number(package/hpa_price_max,'##0,00','european')" />/<xsl:value-of select="/site:site/site:config/@currency-sign" />]
                                        </xsl:when>
                                    </xsl:choose>
                                </span>
                                <xsl:if test="package-detail/programs">
                                    <span class="cst-voucher-range-hint cst-voucher-range-hint-programs">
                                        <xsl:choose>
                                            <xsl:when test="package/hpa_programs_min!=0 and package/hpa_programs_max!=0">
                                                [%txt.voucher.programs.range/<xsl:value-of select="format-number(package/hpa_programs_min,'##0,00','european')" />/<xsl:value-of select="/site:site/site:config/@currency-sign" />/<xsl:value-of select="format-number(package/hpa_programs_max,'##0,00','european')" />/<xsl:value-of select="/site:site/site:config/@currency-sign" />]
                                            </xsl:when>
                                            <xsl:when test="package/hpa_programs_min!=0">
                                                [%txt.voucher.programs.range.min/<xsl:value-of select="format-number(package/hpa_programs_min,'##0,00','european')" />/<xsl:value-of select="/site:site/site:config/@currency-sign" />]
                                            </xsl:when>
                                            <xsl:when test="package/hpa_programs_max!=0">
                                                [%txt.voucher.programs.range.max/<xsl:value-of select="format-number(package/hpa_programs_max,'##0,00','european')" />/<xsl:value-of select="/site:site/site:config/@currency-sign" />]
                                            </xsl:when>
                                        </xsl:choose>
                                    </span>
                                </xsl:if>
                            </div>
                        </xsl:if>
                    </div>
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
                        <div class="clearfix"/>
                        <form id="{$voucher-form}" method="get">

                            <!--
                            <xsl:if test="count( package-room-types/* ) = 1">
                                <xsl:for-each select="package-room-types/*">
                                    <div class="cst-voucher-roomtype cst-package-roomtype">
                                        <span class="cst-name cst-name-voucher cst-name-package">
                                            <xsl:value-of select="hrt_name"/>
                                        </span>
                                        <span class="cst-price cst-price-voucher cst-price-package">
                                            <xsl:value-of select="//site:config/@currency-sign" /> <xsl:value-of select="hpapr_price" />
                                        </span>
                                        <script type="text/javascript">
                                            <xsl:value-of select="$voucher-form" />.voucher_roomtypes[<xsl:value-of select="hrt_id"/>] = {type: 'static', price: <xsl:value-of select="hpapr_price"/>, id: <xsl:value-of select="hrt_id"/>};
                                        </script>
                                    </div>
                                </xsl:for-each>
                            </xsl:if>
                             -->
                            <xsl:choose>
                                <xsl:when test="count( package-detail/programs/optional/* ) &gt; 0 or count( package-room-types/* ) &gt; 0">
                                    <xsl:if test="count( package-room-types/* ) &gt; 0">
                                        <div class="cst-background-box cst-voucher-detail-roomtypes cst-package-detail-roomtypes">
                                            <xsl:call-template name="cstc:headline">
                                                <xsl:with-param name="type">3</xsl:with-param>
                                                <xsl:with-param name="title">[%book.step.20]</xsl:with-param>
                                                <xsl:with-param name="class">cst cst-voucher-detail</xsl:with-param>
                                            </xsl:call-template>
                                            <xsl:variable name="persons">
                                                <xsl:choose>
                                                    <xsl:when test="package/hpa_persons&lt;2">1</xsl:when>
                                                    <xsl:otherwise><xsl:value-of select="package/hpa_persons" /></xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:variable>
                                            <xsl:choose>
                                                <xsl:when test="package/hpa_persons=0">
                                                    <div class="cst-voucher-persons">
                                                        <select name="{$voucher-person-amount}" id="{$voucher-person-amount}" onchange="{$voucher-form}.sum_update()">
                                                            <xsl:call-template name="voucher_person_options">
                                                                <xsl:with-param name="limit" select="@voucher-persons-max" />
                                                                <xsl:with-param name="count" select="$persons" />
                                                                <xsl:with-param name="step" select="$persons" />
                                                                <xsl:with-param name="selected" select="package/hpa_persons" />
                                                            </xsl:call-template>
                                                        </select>
                                                        <span class="cst-voucher-persons-hint">[%txt.adults]</span>
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
                                                                                        <xsl:with-param name="width">160</xsl:with-param>
                                                                                        <xsl:with-param name="height">120</xsl:with-param>
                                                                                    </xsl:apply-templates>
                                                                                </xsl:if>
                                                                                <xsl:if test="substring(hrt_image_plan,1,4)='http'">
                                                                                    <xsl:apply-templates select="//site:match-space/images">
                                                                                        <xsl:with-param name="src" select="hrt_image_plan" />
                                                                                        <xsl:with-param name="width">160</xsl:with-param>
                                                                                        <xsl:with-param name="height">120</xsl:with-param>
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
                                                                <xsl:value-of select="hpapr_price_sum"/>
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
                                                <xsl:when test="count( package-detail/programs/optional/* ) &lt; package-program-tree/@voucher-programs-show-list-count or not(count(package-program-tree/*))">
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

                            <xsl:if test="cstc:media-usages[@item-type='hotel-package']/cstc:media-usage[@usage-type='embed']">
                                <div class="cst-background-box cst-voucher-image">
                                    <xsl:apply-templates select="//site:match-space/site-headline">
                                        <xsl:with-param name="type">3</xsl:with-param>
                                        <xsl:with-param name="title">[%txt.voucher.image.select.title]</xsl:with-param>
                                        <xsl:with-param name="class">cst cst-voucher-detail</xsl:with-param>
                                    </xsl:apply-templates>
                                    <div class="cst-voucher-image-select-hint">
                                        [%txt.voucher.image.select.hint]
                                    </div>
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
                                                        <img src="{media_url}/100x100s" />
                                                    </a>
                                                    <input type="radio" name="{$voucher-image}-radio" id="{$voucher-image}-{media_id}" value="{media_id}">
                                                        <xsl:if test="media_id=$voucher-image-default">
                                                            <xsl:attribute name="checked">checked</xsl:attribute>
                                                        </xsl:if>
                                                    </input>
                                                    <label for="{$voucher-image}-{media_id}">[%txt.voucher.image.select]</label>
                                                </div>
                                            </xsl:for-each>
                                            <script>
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
                                            <div class="clearfix" />
                                        </div>
                                    </div>
                                </div>
                            </xsl:if>
                            <div class="cst-voucher-recipient">
                                <h2 class="cst cst-voucher cst-voucher-recipient">[%txt.donee]</h2>
                                <span class="cst-voucher-recipient-salutation">
                                    [%txt.salutation]
                                    <xsl:call-template name="form-dropdown">
                                        <xsl:with-param name="name">voucher-recipient-salutation</xsl:with-param>
                                        <xsl:with-param name="id"><xsl:value-of select="$voucher-recipient-salutation"  /></xsl:with-param>
                                        <xsl:with-param name="tabindex">1</xsl:with-param>
                                        <xsl:with-param name="options" select="salutations" />
                                        <xsl:with-param name="selected" select="0" />
                                    </xsl:call-template>
                                </span>
                                <span class="cst-voucher-recipient-firstname">
                                    [%txt.data.firstname] <input type="text" id="{$voucher-recipient-firstname}" name="voucher-recipient-firstname" />
                                </span>
                                <span class="cst-voucher-recipient-lastname">
                                    [%txt.data.lastname] <input type="text" id="{$voucher-recipient-lastname}" name="voucher-recipient-lastname" />
                                </span>
                            </div>
                            <div class="cst-voucher-comment">
                                <xsl:call-template name="cstc:headline">
                                    <xsl:with-param name="type">3</xsl:with-param>
                                    <xsl:with-param name="title">[%txt.comment.personal]</xsl:with-param>
                                    <xsl:with-param name="class">cst cst-voucher-detail</xsl:with-param>
                                </xsl:call-template>
                                <xsl:if test="voucher-template/hvt_line_limit != 0 or voucher-template/hvt_char_limit != 0">
                                    <div class="voucher-text-limits">
                                        <span>[%txt.voucher.line.limit/<xsl:value-of select="$voucher-line-limit" />/<xsl:value-of select="voucher-template/hvt_line_limit" />]</span>
                                    </div>
                                </xsl:if>
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

                                <xsl:if test="@service-booking = 'yes'">
                                    <xsl:call-template name="cstc:button">
                                        <xsl:with-param name="type">book</xsl:with-param>
                                        <xsl:with-param name="id"><xsl:value-of select="$voucher-book-link" /></xsl:with-param>
                                        <xsl:with-param name="onclick">return <xsl:value-of select="$voucher-form" />.voucher_check('book');</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:if>
                            </ul>
                            <script type="text/javascript">
                                <xsl:value-of select="$voucher-form" />.sum_update();
                            </script>
                        </form>

                    </xsl:when>
                    <xsl:otherwise>
                        <h2>[%package.not.bookable]</h2>
                        [%package.not.bookable.text]
                    </xsl:otherwise>
                </xsl:choose>
            </div>
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
            $('#<xsl:value-of select="$voucher-comment" />').keyup( function(e) {
            <xsl:value-of select="$voucher-form" />.text_update( e.keyCode );
            });
            $('#cst-voucher-comment-line-hint').hide();
            $('#<xsl:value-of select="$voucher-comment" />').focus( function(e) {
            $('#cst-voucher-comment-line-hint').show();
            });
            $('#<xsl:value-of select="$voucher-comment" />').blur( function(e) {
            $('#cst-voucher-comment-line-hint').hide();
            });
            });
            })(jQuery);
            function preview_jpg(a) {
            if( !<xsl:value-of select="$voucher-form" />.voucher_check('preview') ) { return false };
            hs.expand(a);
            return false;
            }

        </script>
    </xsl:template>

    <xsl:template match="cstc:roomtype-detail">
        <xsl:variable name="vjg-item-count" select="count( room-type/hrt_image[../hrt_image != 0] ) + count( room-type/hrt_image_panorama[../hrt_image_panorama != 0] ) + count( room-type/hrt_image_plan[../hrt_image_plan != 0] ) + count( cstc:media-usages/cstc:media-usage[@usage-type='embed'] )" />
        <div class="cst-detail cst-detail-roomtype" id="cst-detail-roomtype-{room-type/hrt_id}">
            <xsl:call-template name="cstc:headline">
                <xsl:with-param name="type">1</xsl:with-param>
                <xsl:with-param name="title" select="room-type/hrt_name"></xsl:with-param>
                <xsl:with-param name="class">cst cst-detail-roomtype</xsl:with-param>
            </xsl:call-template>

            <div class="cst-box">
                <xsl:if test="not(room-type/hrt_image=0) or not(room-type/hrt_image_panorama=0) or not(room-type/hrt_image_plan=0) or count( cstc:media-usages/cstc:media-usage[@usage-type='embed'] ) &gt; 0">
                    <xsl:call-template name="vjg">
                        <xsl:with-param name="group">hrt</xsl:with-param>
                        <xsl:with-param name="item-count" select="$vjg-item-count" />
                    </xsl:call-template>

                    <xsl:variable name="title">
                        <xsl:call-template name="char-replace">
                            <xsl:with-param name="string" select="room-type/hrt_name" />
                            <xsl:with-param name="needle">"</xsl:with-param>
                            <xsl:with-param name="haystack"> </xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>

                    <xsl:if test="not(room-type/hrt_image=0)">
                        <xsl:call-template name="vjg_item">
                            <xsl:with-param name="group">hrt</xsl:with-param>
                            <xsl:with-param name="src" select="room-type/hrt_image" />
                            <xsl:with-param name="alt" select="$title" />
                            <xsl:with-param name="item-count" select="$vjg-item-count" />
                        </xsl:call-template>
                    </xsl:if>

                    <xsl:if test="not(room-type/hrt_image_panorama=0)">
                        <xsl:call-template name="vjg_item">
                            <xsl:with-param name="group">hrt</xsl:with-param>
                            <xsl:with-param name="src" select="room-type/hrt_image_panorama" />
                            <xsl:with-param name="alt" select="$title" />
                            <xsl:with-param name="item-count" select="$vjg-item-count" />
                        </xsl:call-template>
                    </xsl:if>

                    <xsl:if test="not(room-type/hrt_image_plan=0)">
                        <xsl:call-template name="vjg_item">
                            <xsl:with-param name="group">hrt</xsl:with-param>
                            <xsl:with-param name="src" select="room-type/hrt_image_plan" />
                            <xsl:with-param name="alt" select="$title" />
                            <xsl:with-param name="item-count" select="$vjg-item-count" />
                        </xsl:call-template>
                    </xsl:if>

                    <xsl:if test="cstc:media-usages/cstc:media-usage[@usage-type='embed']">
                        <xsl:for-each select="cstc:media-usages/cstc:media-usage[@usage-type='embed']">
                            <xsl:call-template name="vjg_item">
                                <xsl:with-param name="group">hrt</xsl:with-param>
                                <xsl:with-param name="src" select="media_url" />
                                <xsl:with-param name="alt" select="media_name" />
                                <xsl:with-param name="item-count" select="$vjg-item-count" />
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:if>
                </xsl:if>

                <div class="cst-box-content">
                    <xsl:call-template name="cstc:headline">
                        <xsl:with-param name="type">3</xsl:with-param>
                        <xsl:with-param name="title" select="room-type/hrt_name"></xsl:with-param>
                        <xsl:with-param name="class">cst cst-detail-roomtype</xsl:with-param>
                    </xsl:call-template>

                    <div class="cst-teaser-text">
                        <xsl:call-template name="cstc:formatted-text">
                            <xsl:with-param name="text-node" select="room-type/hrt_desc_teaser"/>
                        </xsl:call-template>

                        <xsl:apply-templates select="/site:site/site:match-space/hotel/rooms/price">
                            <xsl:with-param name="room" select="room-type"/>
                            <xsl:with-param name="price-type" select="room-type/hrt_price_type" />
                        </xsl:apply-templates>

                    </div>

                    <xsl:apply-templates select="cstc:revenue-navigator-search" />
                    <xsl:apply-templates select="cstc:revenue-navigator" />

                    <ul class="cst-buttons">
                        <!--
                        <xsl:if test="/site:site/site:config/@remember='1' or /site:site/site:config/@remember-vnh='true'">
                            <xsl:apply-templates select="//site:match-space/site-links/remember">
                                <xsl:with-param name="id">hrt<xsl:value-of select="room-type/hrt_id" /></xsl:with-param>
                                <xsl:with-param name="price"><xsl:value-of select="room-type/hrt_price" /></xsl:with-param>
                                <xsl:with-param name="title"><xsl:value-of select="room-type/hrt_name" /></xsl:with-param>
                                <xsl:with-param name="hotel"><xsl:value-of select="hotel/hotel_nameaffix" /></xsl:with-param>
                                <xsl:with-param name="hotel-id"><xsl:value-of select="room-type/hrt_hotel" /></xsl:with-param>
                                <xsl:with-param name="link"></xsl:with-param>
                            </xsl:apply-templates>
                        </xsl:if>
                        -->
                        <xsl:if test="/site:site/site:config/@view360='true'">
                            <xsl:apply-templates select="//site:match-space/hotel/rooms/view360">
                                <xsl:with-param name="room-type"><xsl:value-of select="room-type/hrt_id" /></xsl:with-param>
                            </xsl:apply-templates>
                        </xsl:if>

                        <xsl:call-template name="cstc:button">
                            <xsl:with-param name="type">request</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="cstc:button">
                            <xsl:with-param name="type">book</xsl:with-param>
                        </xsl:call-template>

                        <xsl:if test="/site:site/site:config/@detail-button-back='true'">
                            <xsl:call-template name="cstc:button">
                                <xsl:with-param name="type">back</xsl:with-param>
                            </xsl:call-template>
                        </xsl:if>

                    </ul>

                    <div class="clearfix"/>

                    <div class="cst-description-text">
                        <xsl:call-template name="cstc:formatted-text">
                            <xsl:with-param name="text-node" select="room-type/hrt_desc_cms"/>
                        </xsl:call-template>

                        <ul class="cst-list cst-room-features">
                            <xsl:if test="room-type/hrt_alloc_def &gt; 0">
                                <li class="cst-roomtype-detail-alloc">
                                    <div class="cst-alloc-headline">[%mh.room.alloc]</div>
                                    <div class="cst-alloc-images">
	                                    <xsl:choose>
		                                    <xsl:when test="room-type/hrt_group = '1130'">
			                                    <xsl:call-template name="cstc:image-repeat">
				                                    <xsl:with-param name="count">2</xsl:with-param>
				                                    <xsl:with-param name="image">cst-image-adult</xsl:with-param>
			                                    </xsl:call-template>
			                                    <xsl:call-template name="cstc:image-repeat">
				                                    <xsl:with-param name="count">2</xsl:with-param>
				                                    <xsl:with-param name="image">cst-image-child</xsl:with-param>
			                                    </xsl:call-template>
		                                    </xsl:when>
		                                    <xsl:when test="room-type/hrt_id = '16465'">
			                                    <xsl:call-template name="cstc:image-repeat">
				                                    <xsl:with-param name="count">1</xsl:with-param>
				                                    <xsl:with-param name="image">cst-image-adult</xsl:with-param>
			                                    </xsl:call-template>
		                                    </xsl:when>
		                                    <xsl:otherwise>
			                                    <xsl:call-template name="cstc:image-repeat">
				                                    <xsl:with-param name="count">2</xsl:with-param>
				                                    <xsl:with-param name="image">cst-image-adult</xsl:with-param>
			                                    </xsl:call-template>
		                                    </xsl:otherwise>
	                                    </xsl:choose>

	                                    <!--<xsl:call-template name="cstc:image-repeat">-->
		                                    <!--<xsl:with-param name="count" select="room-type/hrt_alloc_def" />-->
		                                    <!--<xsl:with-param name="image">cst-image-adult</xsl:with-param>-->
	                                    <!--</xsl:call-template>-->

                                    </div>
                                    <div class="clearfix"/>
                                </li>
                            </xsl:if>
                            <!-- <xsl:if test="room-type/hrt_alloc_max &gt;0 and room-type/hrt_alloc_max_childs &gt;0">
                                <li class="cst-roomtype-detail-alloc">
                                    <div class="cst-alloc-headline">[%txt.room.alloc]</div>
                                    <div class="cst-alloc-images">
                                        <xsl:call-template name="cstc:image-repeat">
                                            <xsl:with-param name="count" select="room-type/hrt_alloc_max" />
                                            <xsl:with-param name="image">cst-image-adult</xsl:with-param>
                                        </xsl:call-template>
                                        <xsl:call-template name="cstc:image-repeat">
                                            <xsl:with-param name="count" select="room-type/hrt_alloc_max_childs - room-type/hrt_alloc_max" />
                                            <xsl:with-param name="image">cst-image-child</xsl:with-param>
                                        </xsl:call-template>
                                    </div>
                                    <div class="clearfix"/>
                                </li>
                            </xsl:if> -->

                            <xsl:if test="count(room-type-pensions/*)=0">
                                <li class="cst-roomtype-detail-catering">
                                    [%search.form.catering] [%txt.catering.<xsl:value-of select="room-type/hrt_catering" />]
                                </li>
                            </xsl:if>
                            <xsl:choose>
                                <xsl:when test="room-group/hrg_id or room-type/hrt_beds &gt;0">
                                    <li class="cst-roomtype-detail-roomtype">
                                        <xsl:choose>
                                            <xsl:when test="room-group/hrg_id">
                                                [%search.form.roomtype]<xsl:text> </xsl:text><xsl:value-of select="room-group/hrg_name" />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                [%search.form.roomtype] [%txt.room.<xsl:value-of select="room-type/hrt_beds" />]
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </li>
                                </xsl:when>
                            </xsl:choose>

                            <xsl:if test="room-type/weekdays_arrival">
                                <li class="cst-roomtype-detail-weekdays">
                                    <div class="weekdays-intro">[%package.arrival.intro]</div>
                                    <div class="weekdays-weekdays"><xsl:value-of select="room-type/weekdays_arrival" /></div>
                                </li>
                            </xsl:if>
                            <xsl:if test="room-type/hrt_room_size != '0'">
                                <li class="cst-roomtype-detail-size">
                                    [%txt.room.size.value/<xsl:value-of select="room-type/hrt_room_size" />]
                                    <xsl:if test="room-type/hrt_rooms != '0'">
                                        <span>(<xsl:value-of select="room-type/hrt_rooms" /> [%txt.rooms.numerus/<xsl:value-of select="room-type/hrt_rooms" />])</span>
                                    </xsl:if>
                                </li>
                            </xsl:if>
                        </ul>
                    </div>
                </div>
                <!--
                        <xsl:apply-templates select="/site:site/site:match-space/site-links/normal">
                            <xsl:with-param name="url">search.php?remember[hrt]=<xsl:value-of select="room-type/hrt_id" />&amp;c[ids_hotels][]=<xsl:value-of select="room-type/hrt_hotel" />&amp;book_item[]=hrt_<xsl:value-of select="room-type/hrt_id" />
                                <xsl:choose>
                                    <xsl:when test="@pension-id!=''">&amp;pension_id=<xsl:value-of select="@pension-id" /></xsl:when>
                                    <xsl:when test="@pension-type!=''">&amp;pension_type=<xsl:value-of select="@pension-type" /></xsl:when>
                                    <xsl:otherwise></xsl:otherwise>
                                </xsl:choose>
                            </xsl:with-param>
                            <xsl:with-param name="class">cst-link cst-link-book</xsl:with-param>
                            <xsl:with-param name="title">[%book.submit.book]</xsl:with-param>
                        </xsl:apply-templates>

                 -->
                <div class="clearfix"/>
            </div>

            <div class="phone-hidden">
                <xsl:apply-templates select="room-type/cstc:roomtype-prices">
                    <xsl:with-param name="prices" select="room-type/prices" />
                    <xsl:with-param name="price-type" select="room-type/hrt_price_type" />
                    <xsl:with-param name="display-cols" select="@display-cols" />
                </xsl:apply-templates>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="/site:site/site:match-space/hotel/packages/variants" name="mh-package-variants">
        <xsl:param name="package"/>
        <table class="cst-package-variants" cellspacing="0" cellpadding="0">
            <xsl:for-each select="$package/avail/custom-elements/variant-groupings/*">
                <xsl:sort select="avail/ht_from_ts" order="ascending" />

                <tr class="cst-package-variant">
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

                    <td class="cst-package-variant-stays cst-stays">

                        <xsl:if test="info/hpa_stays &gt; 0">

                            <div class="cst-stays">

                                <span class="cst-stays-number">
                                    <xsl:value-of select="avail/hpa_stays" />
                                </span>
                                <span class="cst-stays-text">
                                    [%txt.stays.numerus/<xsl:value-of select="avail/stays" />]
                                </span>
                            </div>

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
                                                <!--<xsl:value-of select="substring-before(./ht_to, '-')" />-->
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
                    </td>
                    <td class="package-variant-price">
                        <xsl:call-template name="cstc:package-price-teaser">
                            <xsl:with-param name="type">variants</xsl:with-param>
                        </xsl:call-template>
                        <div class="cst-default-roomtype">
                            <xsl:choose>
                                <xsl:when test="/site:site/cstc:frame/cstc:site/cstc:package-table/cstc:general-list[@item-type='4']">
                                    (<xsl:value-of select="../../../../room-type/hrt_name"/>)
                                </xsl:when>
                                <xsl:otherwise>
                                    (<xsl:value-of select="../../../../cstc:package-price-teaser/room-type/hrt_name"/>)
                                </xsl:otherwise>
                            </xsl:choose>
                        </div>
                    </td>
                    <td class="package-variant-link">
                        <ul class="cst-buttons">
                            <xsl:call-template name="cstc:button">
                                <xsl:with-param name="type">detail</xsl:with-param>
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
                    </td>
                </tr>
            </xsl:for-each>
        </table>
    </xsl:template>


    <xsl:template match="cstc:package-detail">
        <div class="cst-detail cst-detail-package cst-detail-package-type-{package/hpa_type}" id="cst-detail-package-{package/hpa_id}">
            <xsl:if test="package-indicators/*/hpi_indicator!=''">
                <xsl:attribute name="class">cst-detail cst-detail-package cst-detail-package-type-<xsl:value-of select="package/hpa_type"/> cst-detail-package-indicator-<xsl:value-of select="package-indicators/*/hpi_indicator"/></xsl:attribute>
            </xsl:if>
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
                <xsl:if test="not(package/hpa_image=0) or (cstc:media-usages/cstc:media-usage[@usage-type='embed'])">
                    <xsl:call-template name="vjg">
                        <xsl:with-param name="group">hpa<xsl:value-of select="package/hpa_id" /></xsl:with-param>
                        <xsl:with-param name="item-count" select="count( package/hpa_image[../hpa_image != 0] ) + count( cstc:media-usages/cstc:media-usage[@usage-type='embed'] )" />
                    </xsl:call-template>
                </xsl:if>

                <xsl:if test="not(package/hpa_image = 0)">
                    <xsl:call-template name="vjg_item">
                        <xsl:with-param name="group">hpa<xsl:value-of select="package/hpa_id" /></xsl:with-param>
                        <xsl:with-param name="src" select="package/hpa_image" />
                        <xsl:with-param name="alt">
                            <xsl:call-template name="char-replace">
                                <xsl:with-param name="string" select="package/hpa_name" />
                                <xsl:with-param name="needle">"</xsl:with-param>
                                <xsl:with-param name="haystack"> </xsl:with-param>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
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
                <div class="cst-box-content">
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
                    <xsl:if test="not(count(avail/*))=0">
                        <div class="cst-detail-infos">
                            <xsl:if test="not(
								count(pensions/*)&gt;1 or
								string-length(package/hpa_desc )&gt;5 or
								package/weekdays_arrival or count(cstc:media-usages/*) &gt; 0)">
                                <xsl:attribute name="class">cst-detail-infos cst-detail-infos-last-info</xsl:attribute>
                            </xsl:if>
                            <table class="cst-detail-stays" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="cst-package-variant-stays cst-stays">
                                        <xsl:if test="avail/hpa_stays &gt;0">
                                            <div class="cst-stays">
                                                <span class="cst-stays-number"><xsl:value-of select="avail/hpa_stays" /></span><xsl:text> </xsl:text>
                                                <span class="cst-stays-text">[%txt.stays.numerus/ <xsl:value-of select="avail/stays" />]</span>
                                            </div>
                                        </xsl:if>
                                        <xsl:if test="count(package/tf-avail/*) &gt; 0 and (package/tf-avail/*/ht_to_display != '0000-00-00')">
                                            <ul class="cst-timeframes cst-timeframes-left">
                                                <xsl:for-each select="package/tf-avail/*">
                                                    <xsl:sort select="ht_from_ts" order="ascending"/>
                                                    <li class="cst-timeframe">
                                                        <xsl:if test="position()=last()">
                                                            <xsl:attribute name="class">cst-timeframe cst-timeframe-left cst-timeframe-left-last</xsl:attribute>
                                                        </xsl:if>
                                                        <span class="cst-timeframe-from"><xsl:value-of select="./ht_from_display" /></span>
                                                        <span class="cst-binder">-</span>
                                                        <span class="cst-timeframe-to">
                                                            <xsl:value-of select="./ht_to_display" />
                                                        </span>
                                                    </li>
                                                </xsl:for-each>
                                            </ul>
                                        </xsl:if>
                                    </td>
                                    <td class="cst-package-variant-price">
                                        <xsl:call-template name="cstc:package-price-teaser"/>

                                        <xsl:if test="package-room-types/*[../../avail/hpa_default_room_type=../../avail/hr_type and ../../avail/hpa_default_room_type=hrt_id]">
                                            <xsl:variable name="default-room-type" select="package-room-types/*[../../avail/hpa_default_room_type=hrt_id]"/>
                                            <span class="cst-default-roomtype">
                                                (<xsl:value-of select="$default-room-type/hrt_name_str"/>)
                                            </span>
                                        </xsl:if>

                                    </td>
                                    <td class="cst-package-variant-buttons">
                                        <xsl:if test="avail">
                                            <ul class="cst-buttons">
                                                <!--
                                                <xsl:if test="/site:site/site:config/@remember='1' or /site:site/site:config/@remember-vnh='true'">
                                                    <xsl:apply-templates select="//site:match-space/site-links/remember">
                                                        <xsl:with-param name="id">hpa<xsl:value-of select="package/hpa_id" /></xsl:with-param>
                                                        <xsl:with-param name="price"><xsl:value-of select="package/hpa_price" /></xsl:with-param>
                                                        <xsl:with-param name="title"><xsl:value-of select="package/hpa_name" /></xsl:with-param>
                                                        <xsl:with-param name="hotel"><xsl:value-of select="hotel/hotel_nameaffix" /></xsl:with-param>
                                                        <xsl:with-param name="hotel-id"><xsl:value-of select="package/hpa_hotel" /></xsl:with-param>
                                                        <xsl:with-param name="link"></xsl:with-param>
                                                        <xsl:with-param name="class">cst-link cst-link-notice</xsl:with-param>
                                                    </xsl:apply-templates>
                                                </xsl:if>
                                                -->
                                                <xsl:if test="@service-request = 'yes'">
                                                    <xsl:call-template name="cstc:button">
                                                        <xsl:with-param name="type">request</xsl:with-param>
                                                    </xsl:call-template>
                                                </xsl:if>

                                                <xsl:if test="@service-booking = 'yes' and not(package-indicators/*/coi_id = 21017)">
                                                    <xsl:call-template name="cstc:button">
                                                        <xsl:with-param name="type">book</xsl:with-param>
                                                    </xsl:call-template>
                                                </xsl:if>

                                                <xsl:if test="/site:site/site:config/@detail-button-back='true'">
                                                    <xsl:call-template name="cstc:button">
                                                        <xsl:with-param name="type">back</xsl:with-param>
                                                    </xsl:call-template>
                                                </xsl:if>

                                            </ul>
                                        </xsl:if>
                                    </td>
                                </tr>
                            </table>
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

                    <xsl:apply-templates select="cstc:revenue-navigator-search" />
                    <xsl:apply-templates select="cstc:revenue-navigator" />

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

    <xsl:template match="cstc:roomtype-prices-parents" name="parents-prices">
        <xsl:param name="prices" />
        <xsl:param name="price-type" />
        <xsl:param name="display-cols">4</xsl:param>
        <xsl:if test="$prices/season-groups/*">
            <table class="roomtype-prices roomtype-prices-parents" cellpadding="0" cellspacing="0" border="0">
                <tr class="head stripe">
                    <td class="season">
                        [%txt.season]
                    </td>
                    <td class="roomtype-price-stays">
                        1 [%txt.to] 3 [%txt.nights]
                    </td>
                    <td class="roomtype-price-stays">
                        4 [%txt.to] 6 [%txt.nights]
                    </td>
                    <td class="roomtype-price-stays">
                        [%txt.from] 7 [%txt.nights]
                    </td>
                </tr>
                <xsl:variable name="currency" select="//site:site/site:config/@currency-sign" />
                <xsl:variable name="rules" select="$prices/rules" />
                <xsl:for-each select="$prices/season-groups/season-group/*/season[(hs_stays_min = '7' or hs_stays_min = '0') and hs_stays_max = '0']">
                    <xsl:sort select="hs_name"/>
	                <xsl:variable name="winter2016" select="hs_id=47104"/>
					<xsl:if test="$winter2016">
						<tr class="head stripe">
							<td class="season">
								[%txt.season]
							</td>
							<td class="roomtype-price-stays">
								1 [%txt.to] 2 [%txt.nights]
							</td>
							<td class="roomtype-price-stays">
								3 [%txt.to] 6 [%txt.nights]
							</td>
							<td class="roomtype-price-stays">
								[%txt.from] 7 [%txt.nights]
							</td>
						</tr>
					</xsl:if>
                    <!--<xsl:sort select="dates/*/hs_from_ts[count(../../*)=1 or .&lt;../../*/hs_from_ts]"/>-->
                    <xsl:variable name="seasontime" select="hs_from"/>
                    <xsl:variable name="hs" select="."/>
                    <tr>
                        <xsl:if test="position() mod 2 = 0"><xsl:attribute name="class">stripe</xsl:attribute></xsl:if>
                        <td class="season">
                            <xsl:if test="hs_name_public != ''">
                                <div class="season-name">
	                                <xsl:value-of select="hs_name_public"/>
                                    <!--<xsl:choose>-->
                                        <!--<xsl:when test="contains(hs_name_public, '1')">-->
                                            <!--<xsl:value-of select="substring-before(hs_name_public, '1')"/>-->
                                        <!--</xsl:when>-->
                                        <!--<xsl:otherwise><xsl:value-of select="hs_name_public"/></xsl:otherwise>-->
                                    <!--</xsl:choose>-->
                                </div>
                            </xsl:if>
                            <xsl:for-each select="dates/*">
                                <xsl:sort select="hs_from_ts"/>
                                <div class="season-date"><xsl:value-of select="hs_from" /> - <xsl:value-of select="hs_to" /></div>
                            </xsl:for-each>
                        </td>
                        <td class="price">
                            <div class="price">
                                <xsl:variable name="weekprice" select="$prices/season-groups/*/seasons/*/dates/*[hs_from=$seasontime and ../../hs_stays_min = 1 or (../../hs_stays_min=0 and ../../hs_stays_max=0)]/../../../../@price-int" />
                                <xsl:choose>
                                    <xsl:when test="not(string-length($weekprice)=0)"> € <xsl:value-of select="format-number($weekprice * 1,'##0,00','european')"/></xsl:when>
                                    <xsl:otherwise> - </xsl:otherwise>
                                </xsl:choose>
                            </div>
                        </td>
                        <td class="price">
                            <div class="price">
                                <xsl:variable name="weekprice" select="$prices/season-groups/*/seasons/*/dates/*[hs_from=$seasontime and ../../hs_stays_max = 6 or (../../hs_stays_min=0 and ../../hs_stays_max=0)]/../../../../@price-int" />
                                <xsl:choose>
                                    <xsl:when test="not(string-length($weekprice)=0)"> € <xsl:value-of select="format-number($weekprice * 1,'##0,00','european')"/>
                                    </xsl:when>
                                    <xsl:otherwise> - </xsl:otherwise>
                                </xsl:choose>
                            </div>
                        </td>
                        <td class="price">
                            <div class="price">
                                <xsl:variable name="weekprice" select="$prices/season-groups/*/seasons/*/dates/*[hs_from=$seasontime and ../../hs_stays_max = 0 and ../../hs_stays_min = 7 or (../../hs_stays_min=0 and ../../hs_stays_max=0)]/../../../../@price-int" />
                                <xsl:choose>
                                    <xsl:when test="not(string-length($weekprice)=0)">€ <xsl:value-of select="format-number($weekprice * 1,'##0,00','european')"/></xsl:when>
                                    <xsl:otherwise> - </xsl:otherwise>
                                </xsl:choose>
                            </div>
                        </td>
                    </tr>
                </xsl:for-each>
            </table>
            <br/>
        </xsl:if>
    </xsl:template>
    
    	<!--Task 261152: @ck Hotel Mirabell Resort Hafling: Programmierung Newsletter Template [Lieferdatum]-->
	<xsl:template match="cstc:package-detail[//site:cms/@template-content-name='nl-content' or //site:cms/@template-content-name='nl-content2' or //site:cms/@template-content-name='nl-content-bottom']">
		<xsl:variable name="nl-package-url">
			<xsl:value-of select="package-detail/hpa_newsletter_url"/>package-detail.php?id=<xsl:value-of select="package/hpa_id" />
		</xsl:variable>
		<table border="0" cellspacing="0" cellpadding="0" class="nl-cst-package-detail-content nl-cst-package-detail nl nl-package-detail" width="100%">
			<tr>
				<xsl:if test="package-detail/hpa_newsletter_image_align = 'left'">
					<td valign="top" class="nl-cst-image-content nl-cst-image cst-image nl" width="{package-detail/hpa_newsletter_image_size}" style="width: {package-detail/hpa_newsletter_image_size}px;">
						<xsl:if test="not(package/hpa_image = 0 )">
							<a href="{$nl-package-url}" target="_blank" class="nl-cst-image-content nl-cst-image cst-image nl" alt="{package/hpa_name}">
								<img src="{package/hpa_image}/{package-detail/hpa_newsletter_image_size}x0q" class="nl-{package-detail/hpa_newsletter_image_align} nl-cst-image nl-cst-image-content"  alt="{package/hpa_name}" align="{package-detail/hpa_newsletter_image_align}" width="{package-detail/hpa_newsletter_image_size}" border="0"/>
							</a>
						</xsl:if>
						<p class="nl-cst-package-detail-links nl-package-detail-links nl-package-detail-links-content nl">
							<xsl:variable name="url_booking">
								<xsl:choose>
									<xsl:when test="//site:config/@search-layout='3'">
										<xsl:value-of select="package-detail/hpa_newsletter_url"/>search.php?c[id_hotel]=<xsl:value-of select="hotel/hotel_id" />&amp;book_item[]=<xsl:value-of select="package/hpa_id" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="package-detail/hpa_newsletter_url"/>package-book.php?hotel=<xsl:value-of select="hotel/hotel_id" />&amp;id=<xsl:value-of select="package/hpa_id" />&amp;from=<xsl:value-of select="avail/from" />&amp;to=<xsl:value-of select="avail/to" />&amp;stays=<xsl:value-of select="avail/stays" />&amp;room-type=<xsl:value-of select="avail/room_type" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
						</p>
						<table>
							<tr><td style="height:30px; line-height:30px;"><xsl:text>&#160;</xsl:text></td></tr>
							<tr>
								<td align="left">
									<xsl:choose>
										<xsl:when test="@service-request = 'yes' and //site:site/site:config/@language='it'">
											<img height="32" width="128" src="/media/38420/button-1369201.gif" alt="dettagli"/>
										</xsl:when>
										<xsl:when test="@service-request = 'yes'">
											<table border="0" cellspacing="0" cellpadding="0" width="130" height="30" class="nl-detailoffer-content nl" >
												<tr class="button-line">
													<td valign="middle" style="width:128px; padding-top:0; padding-bottom:0; padding-right:0;"><a style="text-decoration: none; margin-top:5px;" href="{$nl-package-url}" target="_blank" class="nl-detailoffer-content nl-detailoffer nl">[%txt.nl.package.details]</a></td>
													<td class="button-icon" style="text-align:right;"><img style="vertical-align: middle;" src="/static/i/newsletter/button-icon.png"/></td>
												</tr>
											</table>
										</xsl:when>
									</xsl:choose>
								</td>
							</tr>
						</table>
					</td>
				</xsl:if>
				<td class="package-info">
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
					<xsl:copy-of select="package/hpa_teaser/node()"/>
					<!-- <xsl:copy-of select="package/hpa_desc/node()" /> -->
					<table  border="0" cellspacing="0" cellpadding="0" style="vertical-align: bottom; width: 300px;">
						<tr><td height="20" width="300" style="height: 20px; width:100%; line-height: 20px;">&#160;</td></tr>
						<tr>
							<td class="td-cst-stays" style="padding-left:0; width: 300px;">
								<div class="cst-stays">
									<xsl:if test="avail/hpa_stays &gt;0">
										<span class="cst-stays-number"><xsl:value-of select="avail/hpa_stays" /><xsl:text> </xsl:text>[%txt.stays.numerus/<xsl:value-of select="avail/stays" />]</span>
									</xsl:if>
									<xsl:if test="count(package/tf-avail/*) &gt; 0 and (package/tf-avail/*/ht_to_display != '0000-00-00')">
										<xsl:for-each select="package/tf-avail/*">
											<xsl:sort select="ht_from_ts" order="ascending"/>
											<p style="margin: 0; padding: 0;">
											<span class="cst-timeframe-from"><xsl:value-of select="./ht_from_display" /></span>
											<span class="cst-binder"> - </span>
											<span class="cst-timeframe-to"><xsl:value-of select="./ht_to_display" /></span>
											</p>
										</xsl:for-each>
									</xsl:if>
									</div>
								</td>
							</tr>
							<tr>
							<td class="nl-cst-description-content nl-cst-description nl" valign="right" style="vertical-align: bottom; width: 100%;">
								<xsl:if test="avail">
									<table class="nl-cst-preis-detail" style="width: 100%;">
										<tr>
											<xsl:if test="avail/hpa_price">
												<td class="nl-cst-price-content nl-cst-price nl" style="padding: 0px;" align="left">
													<xsl:call-template name="cstc:package-price-teaser-nl"/>
												</td>
											</xsl:if>
										</tr>

									</table>
								</xsl:if>
							</td>
						</tr>
					</table>
				</td>
				<xsl:if test="package-detail/hpa_newsletter_image_align = 'right'">
					<td rowspan="2" valign="top" class="nl-cst-image-content nl-cst-image cst-image nl" width="280" style="width:280px;">
						<xsl:if test="not(package/hpa_image = 0 )">
							<a href="{$nl-package-url}" target="_blank" class="nl-cst-image-content nl-cst-image cst-image nl" alt="{package/hpa_name}">
								<img src="{package/hpa_image}/280x0q" class="nl-{package-detail/hpa_newsletter_image_align} nl-cst-image nl-cst-image-content"  alt="{package/hpa_name}" align="{package-detail/hpa_newsletter_image_align}" width="{package-detail/hpa_newsletter_image_size}" border="0"/>
							</a>
						</xsl:if>
					</td>
					<table>
						<tr><td style="height:30px; line-height:30px;"><xsl:text>&#160;</xsl:text></td></tr>
						<tr>
							<td align="left">
								<xsl:if test="@service-request = 'yes'">
									<table border="0" cellspacing="0" cellpadding="0" width="130" height="30" class="nl-detailoffer-content nl" >
										<tr class="button-line">
											<td valign="middle" style="width:128px; padding-top:0; padding-bottom:0; padding-right:0;"><a style="text-decoration: none; margin-top:5px;" href="{$nl-package-url}" target="_blank" class="nl-detailoffer-content nl-detailoffer nl">[%txt.nl.package.details]</a></td>
											<td class="button-icon" style="text-align:right;"><img style="vertical-align: middle;" src="/static/i/newsletter/button-icon.png"/></td>
										</tr>
									</table>
								</xsl:if>
							</td>
						</tr>
					</table>
				</xsl:if>
			</tr>
		</table>
	</xsl:template>
	
	<xsl:template match="cstc:package-price-teaser-nl" name="cstc:package-price-teaser-nl">
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
				<xsl:when test="info/hpa_persons &gt; 1">&#160;<span class="cst-price-per-person">[%txt.for] <xsl:value-of select="info/hpa_persons" /> [%txt.price.perperson.short]</span></xsl:when>
				<!-- detail -->
				<xsl:when test="package/hpa_persons &gt;1 ">&#160;<span class="cst-price-per-person">[%txt.for] <xsl:value-of select="package/hpa_persons" /> [%txt.price.perperson.short]</span></xsl:when>
				<xsl:otherwise>&#160;<span class="cst-price-per-person">[%txt.price.perperson.short]</span></xsl:otherwise>
			</xsl:choose>
			<xsl:if test="avail/hpa_type &gt;1 and avail/hpa_price_discount_num &gt; 0">
				<span class="cst-price-save">
					[%package.price.save/<xsl:value-of select="avail/hpa_price_discount" />/<xsl:value-of select="/site:site/site:config/@currency" />]
				</span>
			</xsl:if>
		</div>
	</xsl:template>

    <xsl:template match="cstc:user-request-quick-add[@page=1]">
        <xsl:variable name="form" select="."/>
	    <div class="cst-request">
        <form method="post" action="{$_self}?page=5.page2&amp;hotel_id={@hotel_id}" name="form" id="cst-request-form" class="cst-quick-request-form">
            <div class="cst-request cst-request-quick-head">

                <xsl:choose>
                    <xsl:when test="hotel/hotel_setting_female=1">
                        <xsl:apply-templates select="//site:match-space/site-headline">
                            <xsl:with-param name="type">1</xsl:with-param>
                            <xsl:with-param name="title">[%txt.request.sendhotel2/<xsl:value-of select="translate(concat(hotel/hotel_nameaffix,' ',hotel/hotel_name),'/','&#182;')" />]</xsl:with-param>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="//site:match-space/site-headline">
                            <xsl:with-param name="type">1</xsl:with-param>
                            <xsl:with-param name="title">[%txt.request.sendhotel/<xsl:value-of select="translate(concat(hotel/hotel_nameaffix,' ',hotel/hotel_name),'/','&#182;')" />]</xsl:with-param>
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
                <div class="cst-request-quick-comment">
                    [%request.quick.comment]
                </div>
            </div>
			<br />
            <div class="cst-request-userdata-quickrequest">
                <xsl:if test="count(errors/*) &gt; 0">
                    <div class="cst-request-item cst-request-item-errors">
                        <xsl:call-template name="cstc:errors">
                            <xsl:with-param name="errors" select="errors" />
                        </xsl:call-template>
                    </div>
                </xsl:if>

                <xsl:if test="remember-items/*">
                    <br/>
                    <xsl:apply-templates select="//site:match-space/form/remember-items">
                        <xsl:with-param name="remember_items" select="remember-items" />
                    </xsl:apply-templates>
                </xsl:if>

	            <div class="cst-box">

                <xsl:apply-templates select="/site:site/site:match-space/form/user-data">
                    <xsl:with-param name="form" select="." />
                </xsl:apply-templates>

                <fieldset class="quick-cst-request-wishes">
                    <legend>
                        <xsl:apply-templates select="//site:match-space/site-headline">
                            <xsl:with-param name="type">3</xsl:with-param>
                            <xsl:with-param name="title">[%request.quick.message]</xsl:with-param>
                        </xsl:apply-templates>
                    </legend>
                    <textarea rows="7" cols="40" name="form[request_wishes]">
                        <xsl:value-of select="form/request_wishes" />
                    </textarea>
                </fieldset>

                <xsl:if test="@newsletter">
                    <fieldset class="cst-request-newsletter quick-cst-request-newsletter">
                        <legend>
                            <xsl:apply-templates select="//site:match-space/site-headline">
                                <xsl:with-param name="type">3</xsl:with-param>
                                <xsl:with-param name="title">[%txt.newsletter]</xsl:with-param>
                            </xsl:apply-templates>
                        </legend>
                        <input type="checkbox" name="newsletter_subscribe" value="1" id="newsletter">
                            <xsl:if test="@newsletter-auto"><xsl:attribute name="checked" value="checked" /></xsl:if>
                        </input>
                        <label for="newsletter">[%txt.newsletter.subscribe]</label>
                    </fieldset>
                </xsl:if>

                <xsl:if test="//site:config/@privacy='true'">
                    <div class="cst-privacy">
                        <xsl:apply-templates select="//site:match-space/site-headline">
                            <xsl:with-param name="type">2</xsl:with-param>
                            <xsl:with-param name="title">[%txt.privacy]</xsl:with-param>
                        </xsl:apply-templates>
                        <span class="cst-privacy-statement">[%txt.privacy.statement]</span>
                        <xsl:call-template name="privacy-link">
                            <xsl:with-param name="url" select="hotel/hotel_url" />
                        </xsl:call-template>
                    </div>
                </xsl:if>
                <span class="cst-request-required-hint">*[%txt.field.required]</span>
		    </div>
            <!-- spam protection dummy request_detail_text -->
            <div class="cst-request-detail-text">
                <input name="form[request_detail_text]" value="" />
            </div>
            <div class="cst-request cst-request-submit">
                <input type="submit" value="[%txt.commit]" id="sbutton" class="inputbutton"  />
            </div>
	        </div>
        </form>
	    </div>
        <xsl:apply-templates select="track-element-form-view" />
    </xsl:template>

	<xsl:template match="cstc:program-detail">
		<div class="cst-list cst-list-program">
			<div id="cst-box-program-{program/hp_id}" class="cst-box">
				<xsl:if test="not(program/hp_image=0)">
					<ul class="cst-media">
						<xsl:call-template name="cstc:image">
							<xsl:with-param name="src" select="program/hp_image" />
							<xsl:with-param name="alt" select="program/hp_name" />
							<xsl:with-param name="title" select="program/hp_name" />
							<xsl:with-param name="thumbs">1</xsl:with-param>
						</xsl:call-template>
					</ul>
				</xsl:if>
				<div class="cst-box-content">
					<xsl:call-template name="cstc:headline">
						<xsl:with-param name="type">3</xsl:with-param>
						<xsl:with-param name="title"><xsl:value-of select="program/hp_name"/></xsl:with-param>
						<xsl:with-param name="class">cst cst-list-program</xsl:with-param>
					</xsl:call-template>

					<xsl:if test="string-length(program/hp_desc_teaser) &gt; 1 or program/hp_duration &gt; 0 or program/hp_treatment_length &gt; 0">
						<div class="cst-teaser-text">
							<xsl:if test="string-length(program/hp_desc_teaser) &gt; 1">
								<xsl:copy-of select="program/hp_desc_teaser/node()" />
							</xsl:if>

							<xsl:if test="program/hp_duration &gt; 0">
								<div class="cst-program-duration">
									[%txt.stayduration.min]: <xsl:value-of select="program/hp_duration" />
									<xsl:choose>
										<xsl:when test="program/hp_duration=1"> [%txt.day]</xsl:when>
										<xsl:otherwise> [%txt.days]</xsl:otherwise>
									</xsl:choose>
								</div>
							</xsl:if>
							<xsl:if test="program/hp_treatment_length &gt; 0">
								<div class="cst-program-treatment-length">
									[%txt.duration/<xsl:value-of select="program/hp_treatment_length" />]
								</div>
							</xsl:if>
						</div>
					</xsl:if>

					<xsl:if test="string-length(program/hp_desc_cms) &gt; '5'">
						<div class="cst-description-text">
							<div class="cst-teaser cst-program-teaser-description"  id="cst-teaser-description-{program/hp_id}">
								<xsl:copy-of select="program/hp_desc_cms/node()" />
							</div>
						</div>
					</xsl:if>
					<xsl:if test="program/hp_price">
						<div class="cst-price">
							<span class="cst-price-number">
								<xsl:value-of select="program/hp_price" />
							</span>
						</div>
					</xsl:if>

				</div>
				<ul class="cst-buttons">
					<xsl:variable name="lang" select="/site:site/site:site/site:config/@language-str"/>
					<xsl:choose>
						<xsl:when test="program/hp_id = 48918">
							<!--
							<xsl:call-template name="cstc:button">
								<xsl:with-param name="type">request</xsl:with-param>
								<xsl:with-param name="url">request.php?page=5.page1<xsl:value-of select="substring-after(@url-request,'2.page1')"/></xsl:with-param>
							</xsl:call-template> -->
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="cstc:button">
								<xsl:with-param name="type">back</xsl:with-param>
							</xsl:call-template>
							<xsl:if test="not( @bookable ) or @bookable = 'true'">
								<xsl:call-template name="cstc:button">
									<xsl:with-param name="type">book</xsl:with-param>
									<xsl:with-param name="url"><xsl:value-of select="@url-booking"/></xsl:with-param>
								</xsl:call-template>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</ul>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="cstc:package-teaser[@type=4]">
		<div id="cst-box-package-{package/hpa_id}" class="cst-box">
			<ul class="cst-media">
				<xsl:apply-templates select="//site:match-space/images">
					<xsl:with-param name="src" >
						<xsl:choose>
							<xsl:when test="not(package/hpa_image=0)"><xsl:value-of select="package/hpa_image"></xsl:value-of></xsl:when>
							<xsl:otherwise><xsl:value-of select="//site:vars/@base-resources"/>images/cst-voucher-default.png</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="alt">
						<xsl:value-of select="package/hpa_name" />
					</xsl:with-param>

					<xsl:with-param name="href" select="@url" />
					<xsl:with-param name="popup-type">4</xsl:with-param>
				</xsl:apply-templates>
			</ul>
			<div class="cst-box-content">
				<xsl:call-template name="cstc:headline">
					<xsl:with-param name="type">3</xsl:with-param>
					<xsl:with-param name="title">
						<xsl:choose>
							<xsl:when test="count(avail/custom-elements/variant-groupings/*)&gt;1">
								<xsl:value-of select="avail/custom-elements/variant-groupings/*[1]/name" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="package/hpa_name" disable-output-escaping="yes" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="class">cst cst-list-voucher</xsl:with-param>
					<xsl:with-param name="href"><xsl:value-of select="@url"/></xsl:with-param>
				</xsl:call-template>
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
				<xsl:apply-templates select="cstc:package-price-teaser"></xsl:apply-templates>
			</div>
			<xsl:if test="not(count(avail/custom-elements/variant-groupings/*)&gt;1)">
				<ul class="cst-buttons">
					<xsl:call-template name="cstc:button">
						<xsl:with-param name="class">indicator-link</xsl:with-param>
						<xsl:with-param name="type">detail</xsl:with-param>
					</xsl:call-template>
				</ul>
			</xsl:if>
		</div>
	</xsl:template>

	<!-- gutschein aufenthalt preis -->
	<xsl:template match="cstc:package-price-teaser[../@type=4 and ../package/hpa_default_room_type=0 and count(avail/custom-elements/variant-groupings/*)&gt;1]">
		<div class="cst-price">
			<xsl:choose>
				<xsl:when test="count(avail/custom-elements/variant-groupings/*) &gt; 1">
					<xsl:attribute name="class">cst-price cst-price-variant</xsl:attribute>
					<xsl:call-template name="mh-package-variants-dayspa">
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

	<xsl:template match="/site:site/site:match-space/hotel/packages/variants" name="mh-package-variants-dayspa">
		<xsl:param name="package"/>
		<table class="cst-package-variants" cellspacing="0" cellpadding="0">
			<xsl:for-each select="$package/avail/custom-elements/variant-groupings/*">
				<xsl:sort select="avail/ht_from_ts" order="ascending" />

				<tr class="cst-package-variant">
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

					<td class="cst-package-variant-stays cst-stays">
						<xsl:if test="count(type) &gt; 0 and string-length(type) &gt; 1">
							<div class="cst-stays">
								<xsl:value-of select="type" />
							</div>
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
												<!--<xsl:value-of select="substring-before(./ht_to, '-')" />-->
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
					</td>
					<td class="package-variant-price">
						<xsl:call-template name="cstc:package-price-teaser">
							<xsl:with-param name="type">variants</xsl:with-param>
						</xsl:call-template>
						<div class="cst-default-roomtype">
							<xsl:choose>
								<xsl:when test="/site:site/cstc:frame/cstc:site/cstc:package-table/cstc:general-list[@item-type='4']">
									(<xsl:value-of select="../../../../room-type/hrt_name"/>)
								</xsl:when>
								<xsl:otherwise>
									(<xsl:value-of select="../../../../cstc:package-price-teaser/room-type/hrt_name"/>)
								</xsl:otherwise>
							</xsl:choose>
						</div>
					</td>
					<td class="package-variant-link">
						<ul class="cst-buttons">
							<xsl:call-template name="cstc:button">
								<xsl:with-param name="type">detail</xsl:with-param>
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
					</td>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>

	<xsl:template match="cstc:roomtype-list">
		<xsl:variable name="rtl-booking-button" select="@service-booking" />
		<xsl:variable name="rtl-request-button" select="@service-request" />
		<xsl:variable name="hotel-id" select="@hotel" />
		<div id="rtl-{$hotel-id}" class="cst-roomtype-list">
			<xsl:for-each select="roomtype-groups/*[name()='roomtype-group']">
				<div id="rtg-{@group-id}" class="cst-roomtype-group">
					<div class="rtg-header"><h2 class="rtg-name"><xsl:value-of select="@group-name" /></h2></div>
					<div class="room-type-container">
						<xsl:for-each select="roomtypes/*">
							<xsl:call-template name="mh-roomtype-item">
								<xsl:with-param name="room" select="." />
								<xsl:with-param name="cols" select="../../../../@display-cols" />
								<xsl:with-param name="booking" select="$rtl-booking-button" />
								<xsl:with-param name="request" select="$rtl-request-button" />
							</xsl:call-template>
						</xsl:for-each>
					</div>
				</div>
			</xsl:for-each>
		</div>
		<script>
			jQuery('.rcb-detail').click(function(){
				var oID = jQuery(this).data('rid');
				jQuery('#ri-'+oID).addClass('show-details');
			});

			jQuery('.rcb-detail-close').click(function(){
				var oID = jQuery(this).attr('data-rid');
				jQuery('#ri-'+oID).removeClass('show-details');
			});
		</script>

	</xsl:template>

	<!--vri-id - remote ID des Anfrageformulars als Condeon Attribut "vri-id"-->
	<!--target-url - gewünschte Zielseite der Anfrage/Buchung  als Condeon Attribut "target-url"-->

	<xsl:template name="mh-roomtype-item">
		<xsl:param name="room" />
		<xsl:param name="cols" >4</xsl:param>
		<xsl:param name="booking">no</xsl:param>
		<xsl:param name="request">no</xsl:param>

		<xsl:variable name="rid" select="$room/room-type/hrt_id" />

		<div id="ri-{$rid}" class="cst-room">
			<div class="cst-room-media">
				<xsl:if test="not($room/room-type/hrt_image=0) or not($room/room-type/hrt_image_plan=0) or not($room/room-type/hrt_image_panorama=0) or count($room/cstc:media-usages/cstc:media-usage[@usage-type='embed'])&gt;0">
					<ul class="slides cf clearfix">
						<xsl:if test="not($room/room-type/hrt_image=0)">
							<li class="slide"><img class="cst-room-img" src="{$room/room-type/hrt_image}/960x540s" alt="room-image-{$rid} {$room/room-type/hrt_image_alt}" /></li>
						</xsl:if>
						<xsl:if test="not($room/room-type/hrt_image_plan=0)">
							<li class="slide"><img class="cst-room-img" src="{$room/room-type/hrt_image_plan}/960x540s" alt="room-image-plan-{$rid} {$room/room-type/hrt_image_plan_alt}" /></li>
						</xsl:if>
						<xsl:if test="not($room/room-type/hrt_image_panorama=0)">
							<li class="slide"><img class="cst-room-img" src="{$room/room-type/hrt_image_panorama}/960x540s" alt="room-image-panorama-{$rid}" /></li>
						</xsl:if>
						<xsl:if test="count( $room/cstc:media-usages/cstc:media-usage[@usage-type='embed'] ) &gt; 0">
							<xsl:for-each select="$room/cstc:media-usages/cstc:media-usage[@usage-type='embed']">
								<li class="slide"><img class="cst-room-img" src="{media_url}/960x540s" alt="{media_name}" /></li>
							</xsl:for-each>
						</xsl:if>
					</ul>
					<script type="text/javascript">
						jQuery('#ri-<xsl:value-of select="$rid" /> .cst-room-media').flexslider({
							directionNav: 'true',
							controlNav: 'false',
							prevText: '',
							nextText: ''
						});
					</script>
				</xsl:if>
			</div>
			<div class="cst-room-title"><h3 class="cst-room-title-name"><xsl:value-of select="$room/room-type/hrt_name" /></h3></div>
			<div class="cst-room-teaser">
				<xsl:copy-of select="$room/room-type/hrt_desc_teaser_str/node()" />
				<xsl:call-template name="mh-roomtype-info"><xsl:with-param name="room" select="$room/room-type" /></xsl:call-template>
			</div>
			<xsl:call-template name="mh-roomtype-control-bar">
				<xsl:with-param name="booking-url">
					<xsl:if test="$booking='yes'"><xsl:value-of select="/site:site/site:cms/content-attribute[@name='target-url']/@value" /><xsl:value-of select="@url-booking" /></xsl:if>
				</xsl:with-param>
				<xsl:with-param name="request-url">
					<xsl:if test="$request='yes'">
						<xsl:choose>
							<xsl:when test="string-length(/site:site/site:cms/content-attribute[@name='vri-id']/@value)&gt;0">
								<xsl:value-of select="/site:site/site:cms/content-attribute[@name='target-url']/@value" /><xsl:text>transaction.php?items[]=hrt:{$rid}&amp;c[id_hotel]={$room/room-type/hrt_hotel}&amp;vri_id=</xsl:text><xsl:value-of select="/site:site/site:cms/content-attribute[@name='vri-id']/@value" />
							</xsl:when>
							<xsl:otherwise><xsl:value-of select="/site:site/site:cms/content-attribute[@name='target-url']/@value" /><xsl:value-of select="@url-request" /></xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:with-param>
				<xsl:with-param name="class-info">top</xsl:with-param>
				<xsl:with-param name="price">
					<xsl:apply-templates select="/site:site/site:match-space/hotel/rooms/price">
						<xsl:with-param name="room" select="$room"/>
						<xsl:with-param name="price-type" select="$room/room-type/hrt_price_type" />
					</xsl:apply-templates>
				</xsl:with-param>
				<xsl:with-param name="rid" select="$rid" />
			</xsl:call-template>
			<div class="cst-room-detail">
				<div class="cst-room-detail-teaser">
					<xsl:copy-of select="$room/room-type/hrt_desc_teaser_str/node()" />
				</div>
				<xsl:call-template name="mh-roomtype-info"><xsl:with-param name="room" select="$room/room-type" /></xsl:call-template>
				<div class="cst-room-detail-description">
					<xsl:copy-of select="$room/room-type/hrt_desc_cms_str/node()" />
				</div>
				<div class="price-tables" data-type="{$room/room-type/hrt_price_type}">
					<xsl:apply-templates select="$room/room-type/cstc:roomtype-prices">
						<xsl:with-param name="prices" select="$room/prices" />
						<xsl:with-param name="price-type" select="$room/room-type/hrt_price_type" />
						<xsl:with-param name="display-cols" select="$cols" />
					</xsl:apply-templates>
				</div>
				<xsl:call-template name="mh-roomtype-control-bar">
					<xsl:with-param name="booking-url">
						<xsl:if test="$booking='yes'"><xsl:value-of select="/site:site/site:cms/content-attribute[@name='target-url']/@value" /><xsl:value-of select="@url-booking" /></xsl:if>
					</xsl:with-param>
					<xsl:with-param name="request-url">
						<xsl:if test="$request='yes'">
							<xsl:choose>
								<xsl:when test="string-length(/site:site/site:cms/content-attribute[@name='vri-id']/@value)&gt;0">
									<xsl:value-of select="/site:site/site:cms/content-attribute[@name='target-url']/@value" /><xsl:text>transaction.php?items[]=hrt:{$rid}&amp;c[id_hotel]={$room/room-type/hrt_hotel}&amp;vri_id=</xsl:text><xsl:value-of select="/site:site/site:cms/content-attribute[@name='vri-id']/@value" />
								</xsl:when>
								<xsl:otherwise><xsl:value-of select="/site:site/site:cms/content-attribute[@name='target-url']/@value" /><xsl:value-of select="@url-request" /></xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</xsl:with-param>
					<xsl:with-param name="class-info">bottom</xsl:with-param>
					<xsl:with-param name="price">
						<xsl:apply-templates select="/site:site/site:match-space/hotel/rooms/price">
							<xsl:with-param name="room" select="$room/room-type"/>
							<xsl:with-param name="price-type" select="$room/room-type/hrt_price_type" />
						</xsl:apply-templates>
					</xsl:with-param>
					<xsl:with-param name="rid" select="$rid" />
				</xsl:call-template>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="mh-roomtype-control-bar">
		<xsl:param name="booking-url"></xsl:param>
		<xsl:param name="request-url"></xsl:param>
		<xsl:param name="class-info"></xsl:param>
		<xsl:param name="price" />
		<xsl:param name="rid" />

		<div class="cst-room-control-bar rcb-{$rid} {$class-info}">
			<div class="price-info">
				<xsl:copy-of select="$price" />
			</div>
			<div class="rcb-buttons">
				<div class="rcb-button rcb-detail" data-rid="{$rid}"><span>[%txt.details]</span></div>
				<div class="rcb-button rcb-detail-close" data-rid="{$rid}"><span>[%txt.details.hide]</span></div>
				<xsl:if test="string-length($booking-url)&gt;0">
					<div class="rcb-button rcb-booking" data-rid="{$rid}"><a href="{$booking-url}">[%txt.book;]</a></div>
				</xsl:if>
				<xsl:if test="string-length($request-url)&gt;0">
					<div class="rcb-button rcb-request" data-rid="{$rid}"><a href="{$request-url}">[%txt.request]</a></div>
				</xsl:if>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="mh-roomtype-info">
		<xsl:param name="room" />
		<div class="rt-info">
			<div class="rt-info-alloc">
				<span class="alloc alloc-{$room/hrt_alloc_def}"></span>
			</div>
			<div class="rt-info-size">
				<span class="bm-text">[%txt.room.size]: </span><xsl:value-of select="$room/hrt_room_size" /><span class="bm"> m<span class="bm-sup">2</span></span>
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>
