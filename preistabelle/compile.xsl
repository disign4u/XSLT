<?xml version = "1.0" encoding = "UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:site="http://xmlns.webmaking.ms/site/"
                xmlns:cstc="http://xmlns.webmaking.ms/cstc/"
                xmlns:math="http://exslt.org/math"
                exclude-result-prefixes="site cstc math">
    <xsl:output media-type="html"/>

    <xsl:template match="cstc:site">
        <html>
            <body>
                <div>
                    <h1>Zimmer .</h1>
                </div>
                <xsl:for-each select="/site:site/cstc:frame/cstc:site/cstc:roomtype-detail/room-type/prices/*">
                    <xsl:value-of select="position()"/> -- <xsl:value-of select="name()"/><br/>
                </xsl:for-each>
                <hr/>
                <xsl:for-each select="/site:site/cstc:frame/cstc:site/cstc:roomtype-detail/room-type/prices/season-groups/*">
                    <xsl:value-of select="./seasons/season/hs_from"/> -- <xsl:value-of select="./seasons/season/hs_name_public"/> -- <xsl:value-of select="name()"/><br/>
                </xsl:for-each>
                <hr/>
                <table cellpadding="10" border="1">
                    <tr>
                        <th>empty</th>
                        <xsl:for-each select="/site:site/cstc:frame/cstc:site/cstc:roomtype-detail/room-type/prices/season-groups/season-group/*/season[(hs_stays_min = '7' or hs_stays_min = '0') and hs_stays_max = '0']">
                            <xsl:sort select="hs_from_ts" order="ascending"/>
                            <th>
                                <xsl:value-of select="hs_name_public"/><br/>
                                <span style="font-size:10px"><xsl:value-of select="hs_from"/> - <xsl:value-of select="hs_to"/></span>
                            </th>
                        </xsl:for-each>
                    </tr>
                    <tr>
                        <th>1-3 Nächte</th>
                        <xsl:for-each select="/site:site/cstc:frame/cstc:site/cstc:roomtype-detail/room-type/prices/season-groups/season-group/*/season[(hs_stays_min = '7' or hs_stays_min = '0') and hs_stays_max = '0']">
                            <xsl:sort select="hs_from_ts" order="ascending"/>
                            <th>
                                <xsl:value-of select="hs_name_public"/><br/>
                                <!--<xsl:value-of select="./seasons/season/hs_from"/> &#45;&#45;
                                <xsl:value-of select="./seasons/season/hs_to"/><br/>-->
                            </th>
                        </xsl:for-each>
                    </tr>

                </table>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="cstc:roomtype-detail">

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

</xsl:stylesheet>