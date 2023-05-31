<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:site="http://xmlns.webmaking.ms/site/"
                xmlns:cstc="http://xmlns.webmaking.ms/cstc/"
                exclude-result-prefixes="site cstc">

    <xsl:output method="html"/>

    <xsl:template match="cstc:site">
        <xsl:apply-templates select="//cstc:general-list[@type='package']"/>
    </xsl:template>

    <xsl:template match="cstc:general-list[@type='package']">
        <xsl:variable name="id" select="generate-id()"/>
        <xsl:variable name="count" select="count(*)"/>
        <xsl:variable name="criterias-str" select="@item-indicator"/>
        <xsl:variable name="criterias" select="../cstc:general-list-criterias" />
        <xsl:variable name="criterias-string" select="concat(',',@item-indicator,',')" />
        <xsl:variable name="list-filter-indicators" select="../cstc:general-sidebar//ids_package_indicators/*[number( normalize-space(coi_teaser_str) ) &gt; 0 or contains($criterias-str,concat(',',coi_id,','))]" />

        <h1>general list type package</h1>
        <table style="margin:100px;" border="1" cellpadding="10">
            <tr>
                <th>ID:</th>
                <td><xsl:value-of select="$id"/></td>
            </tr>
            <tr>
                <th>count:</th>
                <td><xsl:value-of select="$count"/></td>
            </tr>
            <tr>
                <th>item-indicator:</th>
                <td><xsl:value-of select="$criterias-str"/></td>
            </tr>
            <tr>
                <th>item-indicator-list criterias:</th>
                <td><xsl:value-of select="$criterias"/></td>
            </tr>
            <tr>
                <th>criterias-str:</th>
                <td><xsl:value-of select="$criterias-string"/></td>
            </tr>
            <tr>
                <th>list-filter-indicators:</th>
                <td><xsl:value-of select="$list-filter-indicators"/></td>
            </tr>
        </table>
        <xsl:for-each select="$list-filter-indicators">
            <xsl:sort select="normalize-space(coi_teaser_str)"
                      order="ascending" data-type="number"/>
            <xsl:variable name="coi_id" select="coi_id"/>
            <xsl:value-of select="$coi_id"/>

            <hr/>
        </xsl:for-each>


    </xsl:template>

</xsl:stylesheet>