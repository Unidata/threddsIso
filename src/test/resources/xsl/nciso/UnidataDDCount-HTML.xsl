<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:nc="http://www.unidata.ucar.edu/namespaces/netcdf/ncml-2.2">
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> April 14, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b>ted.habermann@noaa.gov</xd:p>
            <xd:p><xd:b>Modified on:</xd:b> May 26, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b>david.neufeld@noaa.gov</xd:p>
            <xd:p><xd:b>Modified on:</xd:b> July 27, 2016</xd:p>
            <xd:p><xd:b>Author:</xd:b>Roland.Schweitzer@noaa.gov</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:variable name="rubricVersion" select="'1.4'"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template name="showScore">
        <xsl:param name="score"/>
        <xsl:choose>
            <xsl:when test="$score=0">
                <td class="report alert alert-danger" align="center">
                    <xsl:value-of select="$score"/>
                </td>
            </xsl:when>
            <xsl:otherwise>
                <td class="report alert alert-success" align="center">
                    <xsl:value-of select="$score"/>
                </td>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="showColumn">
        <xsl:param name="name"/>
        <xsl:param name="total"/>
        <xsl:param name="max"/>
        <xsl:variable name="column">
            <xsl:choose>
                <xsl:when test="$total=0">0</xsl:when>
                <xsl:when test="$total=$max">4</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="floor(number(number($total) * 3 div number($max))) + 1"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr>
            <td width="20%">
                <a href="#{$name}">
                    <xsl:value-of select="$name"/>
                </a>
            </td>
            <xsl:choose>
                <xsl:when test="$column=0">
                    <td align="center" bgcolor="CC00CC">X</td>
                </xsl:when>
                <xsl:otherwise>
                    <td/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="$column=1">
                    <td align="center" bgcolor="CC00CC">X</td>
                </xsl:when>
                <xsl:otherwise>
                    <td/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="$column=2">
                    <td align="center" bgcolor="CC00CC">X</td>
                </xsl:when>
                <xsl:otherwise>
                    <td/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="$column=3">
                    <td align="center" bgcolor="CC00CC">X</td>
                </xsl:when>
                <xsl:otherwise>
                    <td/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="$column=4">
                    <td align="center" bgcolor="CC00CC">X</td>
                </xsl:when>
                <xsl:otherwise>
                    <td/>
                </xsl:otherwise>
            </xsl:choose>
        </tr>
    </xsl:template>
    <xsl:template name="showStars">
        <xsl:param name="name"/>
        <xsl:param name="total"/>
        <xsl:param name="max"/>
        <xsl:variable name="column">
            <xsl:choose>
                <xsl:when test="$total=0">0</xsl:when>
                <xsl:when test="$total=$max">4</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="floor(number(number($total) * 3 div number($max)))+1"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <a href="#{$name}">
            <xsl:value-of select="$name"/>
        </a>
        <xsl:choose>
            <xsl:when test="$column=0">
                <span class="sprite star_0_0"/>
            </xsl:when>
            <xsl:when test="$column=1">
                <span class="sprite star_1_0"/>
            </xsl:when>
            <xsl:when test="$column=2">
                <span class="sprite star_2_0"/>
            </xsl:when>
            <xsl:when test="$column=3">
                <span class="sprite star_3_0"/>
            </xsl:when>
            <xsl:otherwise>
                <span class="sprite star_4_0"/>
            </xsl:otherwise>
        </xsl:choose>
        <br/>
    </xsl:template>
    <xsl:template match="/">
        <xsl:variable name="globalAttributeCnt" select="count(/nc:netcdf/nc:attribute)"/>
        <xsl:variable name="variableCnt" select="count(/nc:netcdf/nc:variable)"/>
        <xsl:variable name="variableAttributeCnt" select="count(/nc:netcdf/nc:variable/nc:attribute)"/>
        <xsl:variable name="standardNameCnt" select="count(/nc:netcdf/nc:variable/nc:attribute[@name='standard_name'])"/>
        <!-- Identifier Fields: 4 possible -->
        <xsl:variable name="idCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='id']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='id'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='id'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="identifierNameSpaceCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='naming_authority']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='naming_authority'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='authority'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="metadataConventionCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='Metadata_Conventions']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='Metadata_Conventions'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='documentation']/nc:group[@name='document']/nc:attribute[@type='Metadata_Conventions'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- Choose the Conventions attribute as well as the Metadata_Conventions (which applies to ADDC only). -->
        <xsl:variable name="conventionCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='Conventions']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='Conventions'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='documentation']/nc:group[@name='document']/nc:attribute[@type='Conventions'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="metadataLinkCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='Metadata_Link']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='Metadata_Link'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='documentation']/nc:group[@name='document']/nc:attribute[@name='xlink']) > 0">
                            <xsl:value-of select="1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="0"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="identifierTotal" select="$idCnt + $identifierNameSpaceCnt + $metadataLinkCnt + $conventionCnt"/>
        <xsl:variable name="identifierMax">4</xsl:variable>
        <!-- Text Search Fields: 7 possible -->
        <xsl:variable name="titleCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='title']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='title'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='full_name'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="summaryCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='summary']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='summary'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='documentation']/nc:group[@name='document']/nc:attribute[@type='summary'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="keywordsCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='keywords']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='keywords'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='keywords'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="keywordsVocabCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='keywords_vocabulary']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='keywords_vocabulary'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='keywords']/nc:attribute[@name='vocab'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="stdNameVocabCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='standard_name_vocabulary']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='standard_name_vocabulary'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='standard_name_vocabulary']) > 0">
                            <xsl:value-of select="1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="0"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="commentCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='comment']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='comment'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='documentation'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="historyCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='history']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='history'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='documentation']/nc:group[@name='document']/nc:attribute[@type='history'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="textSearchTotal" select="$titleCnt + $summaryCnt + $keywordsCnt + $keywordsVocabCnt      + $stdNameVocabCnt + $commentCnt + $historyCnt"/>
        <xsl:variable name="textSearchMax">7</xsl:variable>

        <!-- Extent Search Fields: 20 possible -->
        <xsl:variable name="geospatial_lat_minCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lat_min']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lat_min'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lat_min']) > 0">
                            <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lat_min'])"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='geospatial_lat_min'])"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="geospatial_lat_maxCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lat_max']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lat_max'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lat_max']) > 0">
                            <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lat_max'])"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='geospatial_lat_max'])"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="geospatial_lon_minCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lon_min']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lon_min'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lon_min']) > 0">
                            <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lon_min'])"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='geospatial_lon_min'])"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="geospatial_lon_maxCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lon_max']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lon_max'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lon_max']) > 0">
                            <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lon_max'])"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='geospatial_lon_max'])"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- I have no idea where these will be encoded in the NCML since it seems like the ncISO code fancies up the metadata before writing it. -->
        <xsl:variable name="geospatial_boundsCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_bounds']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_bounds'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_bounds']) > 0">
                            <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_bounds'])"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='geospatial_bounds'])"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="timeStartCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='time_coverage_start']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='time_coverage_start'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='time_coverage_start']) > 0">
                            <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='time_coverage_start'])"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='time_coverage_start'])"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="timeEndCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='time_coverage_end']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='time_coverage_end'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='time_coverage_end']) > 0">
                            <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='time_coverage_end'])"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='time_coverage_end'])"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="vertical_minCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_min']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_min'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_vertical_min']) > 0">
                            <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_vertical_min'])"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='geospatial_vertical_min'])"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="vertical_maxCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_max']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_max'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_vertical_max']) > 0">
                            <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_vertical_max'])"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='geospatial_vertical_max'])"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="geospatial_lat_unitsCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lat_units']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lat_units'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lat_units']) > 0">
                            <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lat_units'])"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='geospatial_lat_units'])"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="geospatial_lon_unitsCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lon_units']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lon_units'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lon_units']) > 0">
                            <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lon_units'])"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='geospatial_lon_units'])"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="geospatial_lat_resolutionCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lat_resolution']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lat_resolution'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lat_resolution']) > 0">
                            <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lat_resolution'])"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='geospatial_lat_resolution'])"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="geospatial_lon_resolutionCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lon_resolution']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lon_resolution'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lon_resolution']) > 0">
                            <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lon_resolution'])"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='geospatial_lon_resolution'])"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="geospatial_bounds_crsCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_bounds_crs']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_bounds_crs'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_bounds_crs']) > 0">
                            <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_bounds_crs'])"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='geospatial_bounds_crs'])"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="geospatial_bounds_vertical_crsCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_bounds_vertical_crs']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_bounds_vertical_crs'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_bounds_vertical_crs']) > 0">
                            <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_bounds_vertical_crs'])"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='geospatial_bounds_vertical_crs'])"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="timeResCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='time_coverage_resolution']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='time_coverage_resolution'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='time_coverage_resolution']) > 0">
                            <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='time_coverage_resolution'])"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='time_coverage_resolution'])"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="timeDurCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='time_coverage_duration']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='time_coverage_duration'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='time_coverage_duration']) > 0">
                            <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='time_coverage_duration'])"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='time_coverage_duration'])"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="vertical_unitsCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_units']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_units'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_vertical_units']) > 0">
                            <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_vertical_units'])"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='geospatial_vertical_units'])"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="vertical_resolutionCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_resolution']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_resolution'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_vertical_resolution']) > 0">
                            <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_vertical_resolution'])"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='geospatial_vertical_resolution'])"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="vertical_positiveCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_positive']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_positive'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_vertical_positive']) > 0">
                            <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_vertical_positive'])"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='geospatial_vertical_positive'])"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!--  Extent Totals -->
        <xsl:variable name="extentTotal" select="$geospatial_lat_minCnt + $geospatial_lat_maxCnt + $geospatial_lon_minCnt + $geospatial_lon_maxCnt     + $timeStartCnt + $timeEndCnt + $vertical_minCnt + $vertical_maxCnt"/>
        <xsl:variable name="extentMax">8</xsl:variable>
        <xsl:variable name="otherExtentTotal" select="$geospatial_lat_resolutionCnt + $geospatial_lat_unitsCnt     + $geospatial_lon_resolutionCnt + $geospatial_lon_unitsCnt     + $timeResCnt + $timeDurCnt     + $vertical_unitsCnt + $vertical_resolutionCnt + $vertical_positiveCnt + $geospatial_boundsCnt + $geospatial_bounds_crsCnt + $geospatial_bounds_vertical_crsCnt"/>
        <xsl:variable name="otherExtentMax">12</xsl:variable>

        <!-- Responsible Party Fields: 15 possible -->
        <xsl:variable name="creatorNameCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='creator_name']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='creator_name'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='creators']/nc:group[@name='creator']/nc:attribute[@name='name'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="creatorInstitutionCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='creator_institution']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='creator_institution'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='creators']/nc:group[@name='creator']/nc:attribute[@name='name'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="creatorURLCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='creator_url']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='creator_url'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='creators']/nc:group[@name='creator']/nc:attribute[@name='url'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="creatorEmailCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='creator_email']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='creator_email'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='creators']/nc:group[@name='creator']/nc:attribute[@name='email'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="creatorTypeCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='creator_type']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='creator_type'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='creators']/nc:group[@name='creator']/nc:attribute[@name='type'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="creatorDateCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='date_created']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='date_created'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='dates']/nc:attribute[@type='created'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="modifiedDateCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='date_modified']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='date_modified'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='dates']/nc:attribute[@type='modified'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="metadataModifiedDateCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='metadata_date_modified']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='metadata_date_modified'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='dates']/nc:attribute[@type='modified'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="issuedDateCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='date_issued']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='date_issued'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='dates']/nc:attribute[@type='issued'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="creatorInstCnt" select="count(/nc:netcdf/nc:attribute[@name='institution'])"/>
        <xsl:variable name="creatorProjCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='project']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='project'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='projects'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="creatorAckCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='acknowledgment']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='acknowledgment'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='documentation']/nc:group[@name='document']/nc:attribute[@type='funding']) > 0">
                            <xsl:value-of select="1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="0"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="creatorTotal" select="$creatorNameCnt + $creatorURLCnt + $creatorEmailCnt + $creatorDateCnt + $creatorTypeCnt + $creatorInstitutionCnt + $modifiedDateCnt + $issuedDateCnt + $creatorInstCnt + $creatorProjCnt + $creatorAckCnt + $metadataModifiedDateCnt"/>
        <xsl:variable name="creatorMax">12</xsl:variable>
        <!--  -->
        <xsl:variable name="contributorNameCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='contributor_name']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='contributor_name'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='contributors']/nc:group[@name='contributor']/nc:attribute[@name='name']) > 0">
                            <xsl:value-of select="1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="0"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="contributorRoleCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='contributor_role']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='contributor_role'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='contributors']/nc:group[@name='contributor']/nc:attribute[@name='role']) > 0">
                            <xsl:value-of select="1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="0"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="contributorTotal" select="$contributorNameCnt + $contributorRoleCnt"/>
        <xsl:variable name="contributorMax">2</xsl:variable>
        <!--  -->
        <xsl:variable name="publisherNameCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='publisher_name']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='publisher_name'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='publishers']/nc:group[@name='publisher']/nc:attribute[@type='name'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="publisherURLCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='publisher_url']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='publisher_url'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='publishers']/nc:group[@name='publisher']/nc:attribute[@type='url'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="publisherEmailCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='publisher_email']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='publisher_email'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='publishers']/nc:group[@name='publisher']/nc:attribute[@type='email'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="publisherTypeCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='publisher_type']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='publisher_type'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='publishers']/nc:group[@name='publisher']/nc:attribute[@type='type'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="publisherInstCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='publisher_institution']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='publisher_institution'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='publishers']/nc:group[@name='publisher']/nc:attribute[@type='institution'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="publisherTotal" select="$publisherNameCnt + $publisherURLCnt + $publisherEmailCnt + $publisherTypeCnt + $publisherInstCnt"/>
        <xsl:variable name="publisherMax">5</xsl:variable>
        <!--  -->
        <xsl:variable name="responsiblePartyTotal" select="$creatorTotal + $contributorTotal + $publisherTotal"/>
        <xsl:variable name="responsiblePartyMax">16</xsl:variable>
        <!-- Other Fields: 2 possible -->
        <xsl:variable name="cdmTypeCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='cdm_data_type']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='cdm_data_type'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='data_type'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="productVersionCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='product_version']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='product_version'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <!-- This will never happen AFAIK -->
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='product_version'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="referencesCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='references']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='references'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <!-- This will never happen AFAIK -->
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='references'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="programCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='program']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='program'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <!-- This will never happen AFAIK -->
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='program'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="instrumentTypeCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='instrument_type']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='instrument_type'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <!-- This will never happen AFAIK -->
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='instrument_type'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="instrumentVocabCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='instrument_vocabulary']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='instrument_vocabulary'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <!-- This will never happen AFAIK -->
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='instrument_vocabularty'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="platformCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='platform']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='platform'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <!-- This will never happen AFAIK -->
                    <xsl:value-of select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='platform'])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="procLevelCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='processing_level']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='processing_level'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='documentation']/nc:group[@name='document']/nc:attribute[@type='processing_level']) > 0">
                            <xsl:value-of select="1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="0"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="sourceCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='source']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='source'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='documentation']/nc:group[@name='document']/nc:attribute[@type='source']) > 0">
                            <xsl:value-of select="1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="0"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="licenseCnt">
            <xsl:choose>
                <xsl:when test="count(/nc:netcdf/nc:attribute[@name='license']) > 0">
                    <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='license'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='documentation']/nc:group[@name='document']/nc:attribute[@type='rights']) > 0">
                            <xsl:value-of select="1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="0"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="otherTotal" select="$cdmTypeCnt + $procLevelCnt + $licenseCnt + $cdmTypeCnt + $instrumentTypeCnt + $instrumentVocabCnt + $platformCnt + $productVersionCnt + $programCnt + $referencesCnt"/>
        <xsl:variable name="otherMax">10</xsl:variable>

        <xsl:variable name="spiralTotal" select="$identifierTotal + $textSearchTotal + $extentTotal + $otherExtentTotal + $otherTotal + $responsiblePartyTotal"/>
        <xsl:variable name="spiralMax" select="$identifierMax + $otherMax + $textSearchMax + $creatorMax + $extentMax + $responsiblePartyMax"/>
        <!-- Display Results Fields -->
        <html>
            <head>
                <!-- Latest compiled and minified CSS -->
                <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous"/>
                <style type="text/css">
                    table {
                    empty-cells:show;
                    }
                    body {
                    margin-left: 23px;
                    margin-left: 16px;
                    }
                    table {
                    margin: 16px;
                    border: 1px solid blue;
                    }
                    td {
                    padding: 8px;
                    }
                    th {
                    padding: 8px;
                    }
                    table.report {
                    width: 97%;
                    border-collapse: collapse;
                    table-layout: fixed;
                    word-wrap: break-word;
                    margin: 16px;
                    border: 1px solid blue;
                    }
                    td.report:first-child {
                    width: 65px;
                    padding: 8px;
                    border: 1px solid blue;
                    }
                    td.report {
                    padding: 8px;
                    width: auto;
                    border: 1px solid blue;
                    }
                    th.report:first-child {
                    width: 65px;
                    padding: 8px;
                    border: 1px solid blue;
                    }
                    th.report {
                    padding: 8px;
                    width: auto;
                    border: 1px solid blue;
                    }
                </style>
            </head>
            <h1>NetCDF Attribute Convention for Dataset Discovery Report</h1>
            <xsl:variable name="titleAttribute" select="/nc:netcdf/nc:attribute[@name='title']"/> The Unidata Attribute Convention for Data Discovery provides recommendations for netCDF attributes that can be added to netCDF files to
            facilitate discovery of those files using standard metadata searches. This tool tests conformance with those recommendations using this <a href="http://www.ngdc.noaa.gov/metadata/published/xsl/UnidataDDCount-HTML.xsl">stylesheet</a>. More <a
                href="https://geo-ide.noaa.gov/wiki/index.php?title=NetCDF_Attribute_Convention_for_Dataset_Discovery#Conformance_Test">Information on Convention and Tool</a>. <h2> Title: <xsl:value-of
                select="$titleAttribute/@value"/>
        </h2>
            <h2>Total Score: <xsl:value-of select="$spiralTotal"/>/<xsl:value-of select="$spiralMax"/></h2>
            <h2>General File Characteristics</h2>
            <table>
                <tr>
                    <td>Number of Global Attributes</td>
                    <td>
                        <xsl:value-of select="$globalAttributeCnt"/>
                    </td>
                </tr>
                <tr>
                    <td>Number of Variables</td>
                    <td>
                        <xsl:value-of select="$variableCnt"/>
                    </td>
                </tr>
                <tr>
                    <td>Number of Variable Attributes</td>
                    <td>
                        <xsl:value-of select="$variableAttributeCnt"/>
                    </td>
                </tr>
                <tr>
                    <td>Number of Standard Names</td>
                    <td>
                        <xsl:value-of select="$standardNameCnt"/>
                    </td>
                </tr>
            </table>
            <table width="95%" border="1" cellpadding="2" cellspacing="2">
                <tr>
                    <th>Spiral</th>
                    <th>None</th>
                    <th>1-33%</th>
                    <th>34-66%</th>
                    <th>67-99%</th>
                    <th>All</th>
                </tr>
                <xsl:call-template name="showColumn">
                    <xsl:with-param name="name" select="'Total'"/>
                    <xsl:with-param name="total" select="$spiralTotal"/>
                    <xsl:with-param name="max" select="$spiralMax"/>
                </xsl:call-template>
                <xsl:call-template name="showColumn">
                    <xsl:with-param name="name" select="'Identification and Metadata Reference'"/>
                    <xsl:with-param name="total" select="$identifierTotal"/>
                    <xsl:with-param name="max" select="$identifierMax"/>
                </xsl:call-template>
                <xsl:call-template name="showColumn">
                    <xsl:with-param name="name" select="'Text Search'"/>
                    <xsl:with-param name="total" select="$textSearchTotal"/>
                    <xsl:with-param name="max" select="$textSearchMax"/>
                </xsl:call-template>
                <xsl:call-template name="showColumn">
                    <xsl:with-param name="name" select="'Extent Search'"/>
                    <xsl:with-param name="total" select="$extentTotal"/>
                    <xsl:with-param name="max" select="$extentMax"/>
                </xsl:call-template>
                <xsl:call-template name="showColumn">
                    <xsl:with-param name="name" select="'Other Extent Information'"/>
                    <xsl:with-param name="total" select="$otherExtentTotal"/>
                    <xsl:with-param name="max" select="$otherExtentMax"/>
                </xsl:call-template>
                <xsl:call-template name="showColumn">
                    <xsl:with-param name="name" select="'Creator'"/>
                    <xsl:with-param name="total" select="$creatorTotal"/>
                    <xsl:with-param name="max" select="$creatorMax"/>
                </xsl:call-template>
                <xsl:call-template name="showColumn">
                    <xsl:with-param name="name" select="'Contributor'"/>
                    <xsl:with-param name="total" select="$contributorTotal"/>
                    <xsl:with-param name="max" select="$contributorMax"/>
                </xsl:call-template>
                <xsl:call-template name="showColumn">
                    <xsl:with-param name="name" select="'Publisher'"/>
                    <xsl:with-param name="total" select="$publisherTotal"/>
                    <xsl:with-param name="max" select="$publisherMax"/>
                </xsl:call-template>
                <xsl:call-template name="showColumn">
                    <xsl:with-param name="name" select="'Other Attributes'"/>
                    <xsl:with-param name="total" select="$otherTotal"/>
                    <xsl:with-param name="max" select="$otherMax"/>
                </xsl:call-template>
            </table>
            <a href="#Identification">Identification</a> | <a href="#Text Search">Text Search</a> | <a href="#Extent Search">Extent Search</a> | <a href="#Other Extent Information">Other Extent Information</a> | <a href="#Creator Search">Creator Search</a> | <a href="#Contributor Search">Contributor Search</a> | <a href="#Publisher">Publisher Search</a> | <a href="#Other Attributes">Other Attributes</a>

            <h2 class="link">Attributes are marked below according the the following convention</h2>
            <table>
                <tr>
                    <td class="alert alert-info" valign="top"><strong>Highly recommended</strong></td>
                    <td class="alert alert-info" valign="top">Recommended</td>
                    <td class="alert">Suggested</td>
                    <td class="alert alert-warning" valign="top">Deprecated</td>
                </tr>
            </table>
            <a id="Identification">
                <h2>Identification / Metadata Reference Score: <xsl:value-of select="$identifierTotal"/>/<xsl:value-of select="$identifierMax"/></h2></a>
            <p>As metadata are shared between National and International repositories it is becoming increasing important to be able to unambiguously identify and refer to specific records. This is facilitated by including an identifier in
                the metadata. Some mechanism must exist for ensuring that these identifiers are unique. This is accomplished by specifying the naming authority or namespace for the identifier. It is the responsibility of the manager of the
                namespace to ensure that the identifiers in that namespace are unique. Identifying the Metadata Convention being used in the file and providing a link to more complete metadata, possibly using a different convention, are
                also important.</p>
            <table class="report">
                <tr class="report">
                    <th class="report" valign="top">Score</th>
                    <th class="report" valign="top">Attribute</th>
                    <th class="report" valign="top">Description</th>
                    <th class="report" valign="top">THREDDS</th>
                    <th class="report" valign="top">ISO 19115-2</th>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$conventionCnt"/>
                    </xsl:call-template>
                    <td class="report alert alert-info" valign="top"><strong>Conventions</strong></td>
                    <td class="report alert alert-info" valign="top"><strong>A comma-separated list of the conventions that are followed by the dataset. For files that follow ACDD 1.3, include the string 'ACDD-1.3'.</strong></td>
                    <td class="report alert alert-info" valign="top"/>
                    <td class="report alert alert-info" valign="top"/>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$idCnt"/>
                    </xsl:call-template>
                    <td class="report alert alert-info" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#id">id</a>
                        <br/>
                    </td>
                    <td class="report alert alert-info" rowspan="2" valign="top">The combination of the "naming authority" and the "id" should be a globally unique identifier for the dataset.<br/>
                    </td>
                    <td class="report alert alert-info" valign="top">dataset@id<br/></td>
                    <td class="report alert alert-info" colspan="1" valign="top">/gmi:MI_Metadata/gmd:fileIdentifier/gco:CharacterString<br/></td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$identifierNameSpaceCnt"/>
                    </xsl:call-template>
                    <td class="report alert alert-info" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#naming_authority">naming_authority</a>
                        <br/>
                    </td>
                    <td class="report alert alert-info" valign="top"/>
                    <td class="report alert alert-info" colspan="1" valign="top">/gmi:MI_Metadata/gmd:fileIdentifier/gco:CharacterString<br/></td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$metadataLinkCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">Metadata_Link or metadata_link</td>
                    <td class="report" valign="top">This attribute provides a link to a complete metadata record for this dataset or the collection that contains this dataset. <i>This attribute is not included in Version 1 of the Unidata Attribute
                        Convention for Data Discovery. It is recommended here because a complete metadata collection for a dataset will likely contain more information than can be included in granule formats. This attribute contains a
                        link to that information.</i></td>
                    <td class="report" valign="top"/>
                    <td class="report" valign="top"/>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$metadataConventionCnt"/>
                    </xsl:call-template>
                    <td class="report alert alert-warning" valign="top">Metadata_Conventions</td>
                    <td class="report alert alert-warning" valign="top">This attribute is <strong>depreicated</strong> in favor of the "Conventions" attribute. The absence of Metadata_Conventions does count against your score.</td>
                    <td class="report alert alert-warning" valign="top"/>
                    <td class="report alert alert-warning" valign="top"/>
                </tr>
            </table>
            <a href="#Identification">Identification</a> | <a href="#Text Search">Text Search</a> | <a href="#Extent Search">Extent Search</a> | <a href="#Other Extent Information">Other Extent Information</a> | <a href="#Creator Search">Creator Search</a> | <a href="#Contributor Search">Contributor Search</a> | <a href="#Publisher">Publisher Search</a> | <a href="#Other Attributes">Other Attributes</a>
            <a name="Text Search">
                <h2 id="Text Search">Text Search Score: <xsl:value-of select="$textSearchTotal"/>/<xsl:value-of select="$textSearchMax"/></h2></a>
            <p>Text searches are a very important mechanism for data discovery. This group includes attributes that contain descriptive text that could be the target of these searches. Some of these attributes, for example title and
                summary, might also be displayed in the results of text searches.</p>
            <table class="report">
                <tr class="report">
                    <th class="report" valign="top">Score</th>
                    <th class="report" valign="top">Attribute</th>
                    <th class="report" valign="top">Description</th>
                    <th class="report" valign="top">THREDDS</th>
                    <th class="report" valign="top">ISO 19115-2</th>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$titleCnt"/>
                    </xsl:call-template>
                    <td class="report alert alert-info" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#title"><strong>title</strong></a>
                        <br/>
                    </td>
                    <td class="report alert alert-info" valign="top"><strong>A short description of the dataset.</strong><br/></td>
                    <td class="report alert alert-info" valign="top"><strong>dataset@name</strong><br/></td>
                    <td class="report alert alert-info" valign="top"><strong>/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString</strong><br/></td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$summaryCnt"/>
                    </xsl:call-template>
                    <td class="report alert alert-info" valign="top">
                        <strong>
                            <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#summary">summary</a>
                        </strong>
                        <br/>
                    </td>
                    <td class="report alert alert-info" valign="top"><strong>A paragraph describing the dataset.</strong><br/>
                    </td>
                    <td class="report alert alert-info" valign="top"><strong>metadata/documentation[@type="summary"]</strong><br/>
                    </td>
                    <td class="report alert alert-info" valign="top"><strong>/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString</strong><br/>
                    </td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$keywordsCnt"/>
                    </xsl:call-template>
                    <td class="report alert alert-info" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#keywords"><strong>keywords</strong></a>
                        <br/>
                    </td>
                    <td class="report alert alert-info" valign="top"><strong>A comma separated list of key words and phrases.</strong><br/>
                    </td>
                    <td class="report alert alert-info" valign="top"><strong>metadata/keyword</strong><br/>
                    </td>
                    <td class="report alert alert-info" valign="top"><strong>/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString</strong><br/>
                    </td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$stdNameVocabCnt"/>
                    </xsl:call-template>
                    <td class="report alert alert-info" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#standard_name_vocabulary">standard_name_vocabulary</a>
                        <br/>
                    </td>
                    <td class="report alert alert-info" valign="top">The name of the controlled vocabulary from which variable standard names are taken.<br/>
                    </td>
                    <td class="report alert alert-info" valign="top">metadata/variables@vocabulary</td>
                    <td class="report alert alert-info" valign="top">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString <br/></td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$historyCnt"/>
                    </xsl:call-template>
                    <td class="report alert alert-info" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#history">history</a>
                        <br/>
                    </td>
                    <td class="report alert alert-info" valign="top">Provides an audit trail for modifications to the original data.</td>
                    <td class="report alert alert-info" valign="top">metadata/documentation[@type="history"]</td>
                    <td class="report alert alert-info" valign="top">/gmi:MI_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:statement/gco:CharacterString</td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$commentCnt"/>
                    </xsl:call-template>
                    <td class="report alert alert-info" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#comment">comment</a>
                        <br/>
                    </td>
                    <td class="report alert alert-info" valign="top">Miscellaneous information about the data.</td>
                    <td class="report alert alert-info" valign="top">metadata/documentation<br/>
                    </td>
                    <td class="report alert alert-info" valign="top">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:supplementalInformation<br/>
                    </td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$keywordsVocabCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#keywords_vocabulary">keywords_vocabulary</a>
                        <br/>
                    </td>
                    <td class="report" valign="top">If you are following a guideline for the words/phrases in your "keywords" attribute, put the name of that guideline here.<br/>
                    </td>
                    <td class="report" valign="top">metadata/keyword@vocabulary</td>
                    <td class="report" valign="top">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString <br/>
                    </td>
                </tr>
            </table>
            <a href="#Identification">Identification</a> | <a href="#Text Search">Text Search</a> | <a href="#Extent Search">Extent Search</a> | <a href="#Other Extent Information">Other Extent Information</a> | <a href="#Creator Search">Creator Search</a> | <a href="#Contributor Search">Contributor Search</a> | <a href="#Publisher">Publisher Search</a> | <a href="#Other Attributes">Other Attributes</a>

            <a name="Extent Search">
                <h2 id="Extent Search">Extent Search Score: <xsl:value-of select="$extentTotal"/>/<xsl:value-of select="$extentMax"/></h2></a>
            <p>This basic extent information supports spatial/temporal searches that are increasingly important as the number of map based search interfaces increases. Many of the attributes included in this spiral can be calculated from
                the data if the file is compliant with the <a href="http://cf-pcmdi.llnl.gov/">NetCDF Climate and Forecast (CF) Metadata Convention</a>. </p>
            <table class="report">
                <tr class="report">
                    <th  class="report" valign="top">Score</th>
                    <th  class="report" valign="top">Attribute</th>
                    <th  class="report" valign="top">Description</th>
                    <th  class="report" valign="top">THREDDS</th>
                    <th  class="report" valign="top">ISO 19115-2</th>
                </tr>
                <tr class="report alert alert-info">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$geospatial_lat_minCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#geospatial_lat_min">geospatial_lat_min</a>
                        <br/>
                    </td>
                    <td class="report" rowspan="13" colspan="1" valign="top">Describes a simple latitude, longitude, vertical and temporal bounding box. For a more detailed geospatial coverage, see the <a
                            href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#suggested_geospatial">suggested geospatial attributes</a>.<br/> Further refinement of the geospatial bounding box can
                        be provided by using these units and resolution attributes.<br/>
                    </td>
                    <td class="report" valign="top">metadata/geospatialCoverage/northsouth/start<br/></td>
                    <td class="report" valign="top">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:southBoundLatitude/gco:Decimal<br/></td>
                </tr>
                <tr class="report alert alert-info">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$geospatial_lat_maxCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#geospatial_lat_max">geospatial_lat_max</a>
                    </td>
                    <td class="report" valign="top">metadata/geospatialCoverage/northsouth/size</td>
                    <td class="report" valign="top">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:northBoundLatitude/gco:Decimal<br/></td>
                </tr>
                <tr class="report alert alert-info">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$geospatial_lon_minCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#geospatial_lon_min">geospatial_lon_min</a>
                    </td>
                    <td class="report" valign="top">metadata/geospatialCoverage/eastwest/start</td>
                    <td class="report" valign="top">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude/gco:Decimal<br/></td>
                </tr>
                <tr class="report alert alert-info">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$geospatial_lon_maxCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#geospatial_lon_max">geospatial_lon_max</a>
                    </td>
                    <td class="report" valign="top">metadata/geospatialCoverage/eastwest/size</td>
                    <td class="report" valign="top">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:eastBoundLongitude/gco:Decimal<br/></td>
                </tr>
                <tr class="report alert alert-info">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$timeStartCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#time_coverage_start">time_coverage_start</a>
                    </td>
                    <td class="report" valign="top">metadata/timeCoverage/start</td>
                    <td class="report" valign="top">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:beginPosition</td>
                </tr>
                <tr class="report alert alert-info">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$timeEndCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#time_coverage_end">time_coverage_end</a>
                    </td>
                    <td class="report" valign="top">metadata/timeCoverage/end</td>
                    <td class="report" valign="top">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:endPosition</td>
                </tr>
                <tr class="report alert alert-info">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$vertical_minCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#geospatial_vertical_min">geospatial_vertical_min</a>
                        <br/>
                    </td>
                    <td class="report" valign="top">metadata/geospatialCoverage/updown/start</td>
                    <td class="report" valign="top">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent/gmd:minimumValue/gco:Real</td>
                </tr>
                <tr class="report alert alert-info">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$vertical_maxCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#geospatial_vertical_max">geospatial_vertical_max</a>
                    </td>
                    <td class="report" valign="top">metadata/geospatialCoverage/updown/size</td>
                    <td class="report" valign="top">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent/gmd:maximumValue/gco:Real</td>
                </tr>
            </table>
            <a href="#Identification">Identification</a> | <a href="#Text Search">Text Search</a> | <a href="#Extent Search">Extent Search</a> | <a href="#Other Extent Information">Other Extent Information</a> | <a href="#Creator Search">Creator Search</a> | <a href="#Contributor Search">Contributor Search</a> | <a href="#Publisher">Publisher Search</a> | <a href="#Other Attributes">Other Attributes</a>

            <a name="Other Extent Information">
                <h2 id="Other Extent Information">Other Extent Information Score: <xsl:value-of select="$otherExtentTotal"/>/<xsl:value-of select="$otherExtentMax"/></h2></a>
            <p>This information provides more details on the extent attributes than the basic information included in the Extent Spiral. Many of the attributes included in this spiral can be calculated from the data if the file is compliant
                with the <a href="http://cf-pcmdi.llnl.gov/">NetCDF Climate and Forecast (CF) Metadata Convention</a> .</p>
            <table class="report">
                <tr class="report">
                    <th  class="report" valign="top">Score</th>
                    <th  class="report" valign="top">Attribute</th>
                    <th  class="report" valign="top">Description</th>
                    <th  class="report" valign="top">THREDDS</th>
                    <th  class="report" valign="top">ISO 19115-2</th>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$geospatial_boundsCnt"/>
                    </xsl:call-template>
                    <td class="report alert alert-info" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#geospatial_bounds">geospatial_bounds</a>
                    </td>
                    <td class="report alert alert-info" valign="top">
                        The north, south, east, west bouding box.
                    </td>
                    <td class="report alert alert-info" valign="top">There is no direct THREDDS metadata attribute, but the bounding box can be dervied the the THREDDS metadata listed above. </td>
                    <td class="report alert alert-info" valign="top">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:eastBoundLongitude/gco:Decimal<br/></td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$geospatial_bounds_crsCnt"/>
                    </xsl:call-template>
                    <td class="report alert alert-info" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#geospatial_bounds_crs">geospatial_bounds_crs</a>
                    </td>
                    <td class="report alert alert-info" valign="top">The coordinate reference system (CRS) of the point coordinates in the geospatial_bounds attribute. This CRS may be 2-dimensional or 3-dimensional, but together with geospatial_bounds_vertical_crs, if that attribute is supplied, must match the dimensionality, order, and meaning of point coordinate values in the geospatial_bounds attribute. If geospatial_bounds_vertical_crs is also present then this attribute must only specify a 2D CRS. EPSG CRSs are strongly recommended. If this attribute is not specified, the CRS is assumed to be EPSG:4326. Examples: 'EPSG:4979' (the 3D WGS84 CRS), 'EPSG:4047'.</td>
                    <td class="report alert alert-info" valign="top">There is no THREDDS metadata attribute for the CRS.</td>
                    <td class="report alert alert-info">The MD_CRS from ISO 19111 is not included in ISO 19115</td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$geospatial_bounds_vertical_crsCnt"/>
                    </xsl:call-template>
                    <td class="report alert alert-info" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#geospatial_bounds_vertical_crs">geospatial_bounds_vertical_crs</a>
                    </td>
                    <td class="report alert alert-info" valign="top">The vertical coordinate reference system (CRS) for the Z axis of the point coordinates in the geospatial_bounds attribute. This attribute cannot be used if the CRS in geospatial_bounds_crs is 3-dimensional; to use this attribute, geospatial_bounds_crs must exist and specify a 2D CRS. EPSG CRSs are strongly recommended. There is no default for this attribute when not specified. Examples: 'EPSG:5829' (instantaneous height above sea level), "EPSG:5831" (instantaneous depth below sea level), or 'EPSG:5703' (NAVD88 height).</td>
                    <td class="report alert alert-info" valign="top">There is no THREDDS metadata attribute for the vercial CRS. </td>
                    <td class="report alert alert-info">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent/gmd:verticalCRS</td>

                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$timeDurCnt"/>
                    </xsl:call-template>
                    <td class="report alert alert-info" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#time_coverage_duration">time_coverage_duration</a>
                    </td>
                    <td class="report alert alert-info" valign="top">Describes the duration of the data set. Use ISO 8601:2004 duration format, preferably the extended format.</td>
                    <td class="report alert alert-info" valign="top">metadata/timeCoverage/duration</td>
                    <td class="report alert alert-info" valign="top">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:beginPosition provides an ISO8601
                        compliant description of the time period covered by the dataset. This standard supports descriptions of <a href="http://en.wikipedia.org/wiki/ISO_8601#Durations">durations</a>.</td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$timeResCnt"/>
                    </xsl:call-template>
                    <td class="report alert alert-info" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#time_coverage_resolution">time_coverage_resolution</a>
                    </td>
                    <td class="report alert alert-info">Describes the targeted time period between each value in the data set. Use ISO 8601:2004 duration format. N.B. the ISO value is an interger with units, so a conversion must be done.</td>
                    <td class="report alert alert-info" valign="top">metadata/timeCoverage/resolution</td>
                    <td class="report alert alert-info">"/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:timeInterval
                        WHERE: /gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:timeInterval[@unit=""units""]"</td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$geospatial_lon_unitsCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#geospatial_lon_units">geospatial_lon_units</a>
                        <br/>
                    </td>
                    <td class="report alert alert-info">Units for the longitude axis described in "geospatial_lon_min" and "geospatial_lon_max" attributes. These are presumed to be "degree_east"; other options from udunits may be specified instead.</td>
                    <td class="report" valign="top">metadata/geospatialCoverage/eastwest/units</td>
                    <td class="report" valign="top">/gmi:MI_Metadata/gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:axisDimensionProperties/gmd:MD_Dimension/gmd:resolution/gco:Measure/@uom</td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$geospatial_lon_resolutionCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#geospatial_lon_resolution">geospatial_lon_resolution</a>
                    </td>
                    <td class="report alert alert-info">Information about the targeted spacing of points in longitude. Recommend describing resolution as a number value followed by units. Examples: '100 meters', '0.1 degree'</td>
                    <td class="report" valign="top">metadata/geospatialCoverage/eastwest/resolution</td>
                    <td class="report" valign="top">/gmi:MI_Metadata/gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:axisDimensionProperties/gmd:MD_Dimension/gmd:resolution/gco:Measure</td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$geospatial_lat_unitsCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#geospatial_lat_units">geospatial_lat_units</a>
                        <br/>
                    </td>
                    <td class="report alert alert-info">Units for the latitude axis described in "geospatial_lat_min" and "geospatial_lat_max" attributes. These are presumed to be "degree_north"; other options from udunits may be specified instead.</td>
                    <td class="report" valign="top">metadata/geospatialCoverage/northsouth/units</td>
                    <td class="report" valign="top">/gmi:MI_Metadata/gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:axisDimensionProperties/gmd:MD_Dimension/gmd:resolution/gco:Measure/@uom</td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$geospatial_lat_resolutionCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#geospatial_lat_resolution">geospatial_lat_resolution</a>
                    </td>
                    <td class="report alert alert-info">Information about the targeted spacing of points in latitude. Recommend describing resolution as a number value followed by the units. Examples: '100 meters', '0.1 degree'.</td>
                    <td class="report" valign="top">metadata/geospatialCoverage/northsouth/resolution</td>
                    <td class="report" valign="top">/gmi:MI_Metadata/gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:axisDimensionProperties/gmd:MD_Dimension/gmd:resolution/gco:Measure</td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$vertical_unitsCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#geospatial_vertical_units">geospatial_vertical_units</a>
                        <br/>
                    </td>
                    <td class="report alert alert-info">Units for the vertical axis described in "geospatial_vertical_min" and "geospatial_vertical_max" attributes. The default is EPSG:4979 (height above the ellipsoid, in meters); other vertical coordinate reference systems may be specified. Note that the common oceanographic practice of using pressure for a vertical coordinate, while not strictly a depth, can be specified using the unit bar. Examples: 'EPSG:5829' (instantaneous height above sea level), 'EPSG:5831' (instantaneous depth below sea level).</td>
                    <td class="report" valign="top">metadata/geospatialCoverage/updown/units</td>
                    <td class="report" valign="top" rowspan="3">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent/gmd:verticalCRS</td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$vertical_resolutionCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#geospatial_vertical_resolution">geospatial_vertical_resolution</a>
                        <br/>
                    </td>
                    <td class="report alert alert-info">Information about the targeted vertical spacing of points. Example: '25 meters'</td>
                    <td class="report" valign="top">metadata/geospatialCoverage/updown/resolution<br/></td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$vertical_positiveCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#geospatial_vertical_positive">geospatial_vertical_positive</a>
                        <br/>
                    </td>
                    <td class="report alert alert-info">One of 'up' or 'down'. If up, vertical values are interpreted as 'altitude', with negative values corresponding to below the reference datum (e.g., under water). If down, vertical values are interpreted as 'depth', positive values correspond to below the reference datum. Note that if geospatial_vertical_positive is down ('depth' orientation), the geospatial_vertical_min attribute specifies the data's vertical location furthest from the earth's center, and the geospatial_vertical_max attribute specifies the location closest to the earth's center.</td>
                    <td class="report" valign="top">metadata/geospatialCoverage@zpositive<br/></td>
                </tr>
            </table>
            <a href="#Identification">Identification</a> | <a href="#Text Search">Text Search</a> | <a href="#Extent Search">Extent Search</a> | <a href="#Other Extent Information">Other Extent Information</a> | <a href="#Creator Search">Creator Search</a> | <a href="#Contributor Search">Contributor Search</a> | <a href="#Publisher">Publisher Search</a> | <a href="#Other Attributes">Other Attributes</a>

            <a name="Creator Search">
                <h2 id="Creator Search">Creator Search Score (Highly Recomended): <xsl:value-of select="$creatorTotal"/>/<xsl:value-of select="$creatorMax"/></h2></a>
            <p>This group includes attributes that could support searches for people/institutions/projects that are responsible for datasets. This information is also critical for the correct attribution of the people and institutions that
                produce datasets.</p>
            <table class="report">
                <tr class="report">
                    <th  class="report" valign="top">Score</th>
                    <th  class="report" valign="top">Attribute</th>
                    <th  class="report" valign="top">Description</th>
                    <th  class="report" valign="top">THREDDS</th>
                    <th  class="report" valign="top">ISO 19115-2</th>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$creatorAckCnt"/>
                    </xsl:call-template>
                    <td class="report alert alert-info" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#acknowledgement">acknowledgment</a>
                    </td>
                    <td class="report alert alert-info" valign="top">A place to acknowledge various type of support for the project that produced this data.<br/></td>
                    <td class="report alert alert-info" valign="top">metadata/documentation[@type="funding"]</td>
                    <td class="report alert alert-info" valign="top">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:credit/gco:CharacterString</td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$creatorNameCnt"/>
                    </xsl:call-template>
                    <td class="report alert alert-info" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#creator_name">creator_name</a>
                        <br/>
                    </td>
                    <td class="report alert alert-info" rowspan="5" colspan="1" valign="top">The data creator's name, URL, and email. The "institution" attribute will be used if the "creator_name" attribute does not exist.<br/></td>
                    <td class="report alert alert-info" valign="top">metadata/creator/name<br/></td>
                    <td class="report alert alert-info" valign="top">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString<br/>
                        CI_RoleCode="originator"</td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$creatorURLCnt"/>
                    </xsl:call-template>
                    <td class="report alert alert-info" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#creator_url">creator_url</a>
                        <br/>
                    </td>
                    <td class="report alert alert-info" valign="top">metadata/creator/contact@url<br/></td>
                    <td class="report alert alert-info" valign="top"
                    >/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL<br/></td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$creatorEmailCnt"/>
                    </xsl:call-template>
                    <td class="report alert alert-info" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#creator_email">creator_email</a>
                        <br/>
                    </td>
                    <td class="report alert alert-info" valign="top">metadata/creator/contact@email</td>
                    <td class="report alert alert-info" valign="top"
                    >/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString</td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$creatorInstCnt"/>
                    </xsl:call-template>
                    <td class="report alert alert-info" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#institution">institution</a>
                        <br/>
                    </td>
                    <td class="report alert alert-info" valign="top">metadata/creator/name</td>
                    <td class="report alert alert-info" valign="top">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString</td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$creatorInstitutionCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#institution">creator_institution</a>
                        <br/>
                    </td>
                    <td class="report" valign="top">metadata/creator/name</td>
                    <td class="report" valign="top">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString<br/>
                        CI_RoleCode="originator"</td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$creatorDateCnt"/>
                    </xsl:call-template>
                    <td class="report alert alert-info" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#date_created">date_created</a>
                    </td>
                    <td class="report alert alert-info" valign="top">The date on which the data was created.<br/></td>
                    <td class="report alert alert-info" valign="top">metadata/date[@type="created"]</td>
                    <td class="report alert alert-info" valign="top">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date<br/> /gmd:dateType/gmd:CI_DateTypeCode="creation"</td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$creatorProjCnt"/>
                    </xsl:call-template>
                    <td class="report alert alert-info" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#project">project</a>
                        <br/>
                    </td>
                    <td class="report alert alert-info" valign="top">The scientific project that produced the data.<br/></td>
                    <td class="report alert alert-info" valign="top">metadata/project<br/></td>
                    <td class="report alert alert-info" valign="top">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:aggregationInfo/gmd:MD_AggregateInformation/gmd:aggregateDataSetName/gmd:CI_Citation/gmd:title/gco:CharacterString<br/>
                        DS_AssociationTypeCode="largerWorkCitation" and DS_InitiativeTypeCode="project"<br/>and/or<br/>
                        /gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString with gmd:MD_KeywordTypeCode="project" </td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$creatorTypeCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        creator_type
                    </td>
                    <td class="report" valign="top">Specifies type of creator with one of the following: 'person', 'group', 'institution', or 'position'. If this attribute is not specified, the creator is assumed to be a person.<br/></td>
                    <td class="report" valign="top">metadata</td>
                    <td class="report" valign="top">N/A</td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$modifiedDateCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#date_modified">date_modified</a>
                        <br/>
                    </td>
                    <td class="report" valign="top">The date on which this data was last modified.<br/></td>
                    <td class="report" valign="top">metadata/date[@type="modified"]</td>
                    <td class="report" valign="top">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date<br/> /gmd:dateType/gmd:CI_DateTypeCode="revision"</td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <!-- fix me -->
                        <xsl:with-param name="score" select="$metadataModifiedDateCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#date_metadata_modified">date_metadata_modified</a>
                        <br/>
                    </td>
                    <td class="report" valign="top">The date on which this data was last modified.<br/></td>
                    <td class="report" valign="top">metadata/date[@type="modified"]</td>
                    <td class="report" valign="top">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date<br/> /gmd:dateType/gmd:CI_DateTypeCode="revision"</td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$issuedDateCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#date_issued">date_issued</a>
                        <br/>
                    </td>
                    <td class="report" valign="top">The date on which this data was formally issued.<br/></td>
                    <td class="report" valign="top">metadata/date[@type="issued"]</td>
                    <td class="report" valign="top">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date<br/> /gmd:dateType/gmd:CI_DateTypeCode="publication"</td>
                </tr>
            </table>
            <a href="#Identification">Identification</a> | <a href="#Text Search">Text Search</a> | <a href="#Extent Search">Extent Search</a> | <a href="#Other Extent Information">Other Extent Information</a> | <a href="#Creator Search">Creator Search</a> | <a href="#Contributor Search">Contributor Search</a> | <a href="#Publisher">Publisher Search</a> | <a href="#Other Attributes">Other Attributes</a>

            <a name="Contributor Search">
                <h2 id="Contributor Search">Contributor Search Score: <xsl:value-of select="$contributorTotal"/>/<xsl:value-of select="$contributorMax"/></h2></a>
            <p>This section allows a data provider to include information about those that contribute to a data product in the metadata for the product. This is important for many reasons.</p>
            <table class="report">
                <tr class="report">
                    <th class="report" valign="top">Score</th>
                    <th class="report" valign="top">Attribute</th>
                    <th class="report" valign="top">Description</th>
                    <th class="report" valign="top">THREDDS</th>
                    <th class="report" valign="top">ISO 19115-2</th>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$contributorNameCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#contributor_name">contributor_name</a>
                        <br/>
                    </td>
                    <td class="report" rowspan="2" colspan="1" valign="top">The name and role of any individuals or institutions that contributed to the creation of this data.<br/></td>
                    <td class="report" valign="top">metadata/contributor<br/></td>
                    <td class="report" valign="top">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString<br/></td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$contributorRoleCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#contributor_role">contributor_role</a>
                        <br/>
                    </td>
                    <td class="report" valign="top">metadata/contributor@role</td>
                    <td class="report" valign="top">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode<br/> ="principalInvestigator" |
                        "author"</td>
                </tr>
            </table>
            <a href="#Identification">Identification</a> | <a href="#Text Search">Text Search</a> | <a href="#Extent Search">Extent Search</a> | <a href="#Other Extent Information">Other Extent Information</a> | <a href="#Creator Search">Creator Search</a> | <a href="#Contributor Search">Contributor Search</a> | <a href="#Publisher">Publisher Search</a> | <a href="#Other Attributes">Other Attributes</a>

            <a name="Publisher">
                <h2 id="Publisher">Publisher Search Score: <xsl:value-of select="$publisherTotal"/>/<xsl:value-of select="$publisherMax"/></h2></a>
            <p>This section allows a data provider to include contact information for the publisher of a data product in the metadata for the product.</p>
            <table class="report">
                <tr class="report">
                    <th class="report" valign="top">Score</th>
                    <th class="report" valign="top">Attribute</th>
                    <th class="report" valign="top">Description</th>
                    <th class="report" valign="top">THREDDS</th>
                    <th class="report" valign="top">ISO 19115-2</th>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$publisherNameCnt"/>
                    </xsl:call-template>
                    <td class="report alert alert-info" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#publisher_name">publisher_name</a>
                        <br/>
                    </td>
                    <td class="report alert alert-info" rowspan="3" colspan="1" valign="top">The data publisher's name, URL, and email. The publisher may be an individual or an institution.</td>
                    <td class="report alert alert-info" valign="top">metadata/publisher/name<br/></td>
                    <td class="report alert alert-info" valign="top">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString<br/>
                        CI_RoleCode="publisher"<br/>and/or<br/>
                        /gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString with gmd:MD_KeywordTypeCode="dataCenter" </td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$publisherURLCnt"/>
                    </xsl:call-template>
                    <td class="report alert alert-info" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#publisher_url">publisher_url</a>
                        <br/>
                    </td>
                    <td class="report alert alert-info" valign="top">metadata/publisher/contact@url<br/></td>
                    <td class="report alert alert-info" valign="top"
                    >/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL<br/>
                        CI_RoleCode="publisher"</td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$publisherEmailCnt"/>
                    </xsl:call-template>
                    <td class="report alert alert-info" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#publisher_email">publisher_email</a>
                        <br/>
                    </td>
                    <td class="report alert alert-info" valign="top">There is no THREDDS metadata attribute for publisher email.</td>
                    <td class="report alert alert-info" valign="top">
                        /gmi:MI_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString<br/>
                        and/or<br/>
                        /gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString<br/>CI_RoleCode="publisher"
                    </td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <!-- fix me-->
                        <xsl:with-param name="score" select="$publisherTypeCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#publisher_type">publisher_type</a>
                        <br/>
                    </td>
                    <td class="report">Specifies type of publisher with one of the following: 'person', 'group', 'institution', or 'position'. If this attribute is not specified, the publisher is assumed to be a person.</td>
                    <td class="report" valign="top">There is no THREDDS metadata attribute for publisher type.</td>
                    <td class="report" valign="top">N/A</td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <!-- fix me-->
                        <xsl:with-param name="score" select="$publisherInstCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#publisher_institution">publisher_institution</a>
                        <br/>
                    </td>
                    <td class="report">The email address of the person (or other entity specified by the publisher_type attribute) responsible for publishing the data file or product to users, with its current metadata and format.</td>
                    <td class="report" valign="top">There is no THREDDS metadata attribute for publisher institution.</td>
                    <td class="report" valign="top">"/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString
                        WHERE: /gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode = ""publisher"""</td>
                </tr>
            </table>
            <a href="#Identification">Identification</a> | <a href="#Text Search">Text Search</a> | <a href="#Extent Search">Extent Search</a> | <a href="#Other Extent Information">Other Extent Information</a> | <a href="#Creator Search">Creator Search</a> | <a href="#Contributor Search">Contributor Search</a> | <a href="#Publisher">Publisher Search</a> | <a href="#Other Attributes">Other Attributes</a>

            <a name="Other Attributes">
                <h2 id="Other Attributes">Other Attributes Score: <xsl:value-of select="$otherTotal"/>/<xsl:value-of select="$otherMax"/></h2></a>
            <p>This group includes attributes that don't seem to fit in the other categories.</p>
            <table class="report">
                <tr class="report">
                    <th  class="report" valign="top">Score</th>
                    <th  class="report" valign="top">Attribute</th>
                    <th  class="report" valign="top">Description</th>
                    <th  class="report" valign="top">THREDDS</th>
                    <th  class="report" valign="top">ISO 19115-2</th>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$procLevelCnt"/>
                    </xsl:call-template>
                    <td class="report alert alert-info" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#processing_level">processing_level</a>
                    </td>
                    <td class="report alert alert-info" valign="top">A textual description of the processing (or quality control) level of the data.<br/></td>
                    <td class="report alert alert-info" valign="top">metadata/documentation[@type="processing_level"]</td>
                    <td class="report alert alert-info" valign="top">/gmi:MI_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:processStep/gmi:LE_ProcessStep/gmi:output/gmi:LE_Source/gmi:processedLevel/gmd:MD_Identifier/gmd:code/gco:CharacterString</td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$licenseCnt"/>
                    </xsl:call-template>
                    <td class="report alert alert-info" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#license">license</a>
                    </td>
                    <td class="report alert alert-info" valign="top">Describe the restrictions to data access and distribution. </td>
                    <td class="report alert alert-info" valign="top">metadata/documentation[@type="rights"]</td>
                    <td class="report alert alert-info" valign="top">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:useLimitation/gco:CharacterString<br/></td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <!-- fix me -->
                        <xsl:with-param name="score" select="$sourceCnt"/>
                    </xsl:call-template>
                    <td class="report alert alert-info" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#source">source</a>
                    </td>
                    <td class="report alert alert-info" valign="top">The method of production of the original data. If it was model-generated, source should name the model and its version. If it is observational, source should characterize it. This attribute is defined in the CF Conventions. Examples: 'temperature from CTD #1234'; 'world model v.0.1'.</td>
                    <td class="report alert alert-info" valign="top">There is no THREDDS metadata attribute for source.</td>
                    <td class="report alert alert-info" valign="top">/gmi:MI_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:processStep/gmi:LE_ProcessStep/gmd:source/gmi:LE_Source/gmd:description/gco:CharacterString</td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <xsl:with-param name="score" select="$cdmTypeCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#cdm_data_type">cdm_data_type</a>
                        <br/>
                    </td>
                    <td class="report" valign="top">The <a href="http://www.unidata.ucar.edu/projects/THREDDS/tech/catalog/InvCatalogSpec.html#dataType">THREDDS data type</a> appropriate for this dataset.</td>
                    <td class="report" valign="top">metadata/dataType</td>
                    <td class="report" valign="top">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode<br/> May need some extensions to this codelist. Current values:
                        vector, grid, textTable, tin, stereoModel, video.</td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <!-- fix me -->
                        <xsl:with-param name="score" select="$instrumentTypeCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#instrument_type">instrument</a>
                        <br/>
                    </td>
                    <td class="report" valign="top">Name of the contributing instrument(s) or sensor(s) used to create this data set or product. Indicate controlled vocabulary used in instrument_vocabulary.</td>
                    <td class="report" valign="top">There is no THREDDS metadata attribute for instrument.</td>
                    <td class="report" valign="top">"/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString
                        WHERE: gmd:MD_KeywordTypeCode = 'instrument' "</td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <!-- fix me -->
                        <xsl:with-param name="score" select="$instrumentVocabCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#instrument_vocabulary">instrument_vocabulary</a>
                        <br/>
                    </td>
                    <td class="report" valign="top">Controlled vocabulary for the names used in the "instrument" attribute.</td>
                    <td class="report" valign="top">There is no THREDDS metadata attribute for instrument vocabulary.</td>
                    <td class="report" valign="top">//gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString</td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <!-- fix me -->
                        <xsl:with-param name="score" select="$platformCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#platform">platform</a>
                        <br/>
                    </td>
                    <td class="report" valign="top">Name of the platform(s) that supported the sensor data used to create this data set or product. Platforms can be of any type, including satellite, ship, station, aircraft or other. Indicate controlled vocabulary used in platform_vocabulary.</td>
                    <td class="report" valign="top">There is no THREDDS metadata attribute for platform.</td>
                    <td class="report" valign="top">"/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString
                        WHERE: gmd:MD_KeywordTypeCode = 'platform' "</td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <!-- fix me -->
                        <xsl:with-param name="score" select="$productVersionCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#product_version">product_version</a>
                        <br/>
                    </td>
                    <td class="report" valign="top">Version identifier of the data file or product as assigned by the data creator. For example, a new algorithm or methodology could result in a new product_version.</td>
                    <td class="report" valign="top">There is no THREDDS metadata attribute for product version.</td>
                    <td class="report" valign="top">"/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString
                        WHERE: gmd:MD_KeywordTypeCode = 'platform' "</td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <!-- fix me -->
                        <xsl:with-param name="score" select="$programCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#program">program</a>
                        <br/>
                    </td>
                    <td class="report" valign="top">The overarching program(s) of which the dataset is a part. A program consists of a set (or portfolio) of related and possibly interdependent projects that meet an overarching objective. Examples: 'GHRSST', 'NOAA CDR', 'NASA EOS', 'JPSS', 'GOES-R'.</td>
                    <td class="report" valign="top">There is no THREDDS metadata attribute for program.</td>
                    <td class="report" valign="top">"/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString
                        WHERE: gmd:MD_KeywordTypeCode = 'project' "</td>
                </tr>
                <tr class="report">
                    <xsl:call-template name="showScore">
                        <!-- fix me -->
                        <xsl:with-param name="score" select="$referencesCnt"/>
                    </xsl:call-template>
                    <td class="report" valign="top">
                        <a href="http://wiki.esipfed.org/index.php/Attribute_Convention_for_Data_Discovery_1-3#references">references</a>
                        <br/>
                    </td>
                    <td class="report" valign="top">Published or web-based references that describe the data or methods used to produce it. Recommend URIs (such as a URL or DOI) for papers or other references. This attribute is defined in the CF conventions.</td>
                    <td class="report" valign="top">There is no THREDDS metadata attribute for references`.</td>
                    <td class="report" valign="top">/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:aggregationInfo/gmd:MD_AggregateInformation/gmd:aggregateDataSetName/gmd:CI_Citation/gmd:title/gco:CharacterString</td>
                </tr>
            </table>
            <a href="#Identification">Identification</a> | <a href="#Text Search">Text Search</a> | <a href="#Extent Search">Extent Search</a> | <a href="#Other Extent Information">Other Extent Information</a> | <a href="#Creator Search">Creator Search</a> | <a href="#Contributor Search">Contributor Search</a> | <a href="#Publisher">Publisher Search</a> | <a href="#Other Attributes">Other Attributes</a>

            <hr/>
            Rubric Version: <xsl:value-of select="$rubricVersion"/><br/>
            <a href="https://geo-ide.noaa.gov/wiki/index.php?title=NetCDF_Convention_for_Dataset_Discovery">More Information</a>
        </html>
    </xsl:template>
</xsl:stylesheet>