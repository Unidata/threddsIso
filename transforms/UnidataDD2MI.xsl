<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gmi="http://www.isotc211.org/2005/gmi"
  xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:gmx="http://www.isotc211.org/2005/gmx"
  xmlns:gsr="http://www.isotc211.org/2005/gsr" xmlns:gss="http://www.isotc211.org/2005/gss"
  xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gml="http://www.opengis.net/gml/3.2"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:nc="http://www.unidata.ucar.edu/namespaces/netcdf/ncml-2.2">
  <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b>April 15, 2011</xd:p>
      <xd:p><xd:b>Author:</xd:b>ted.habermann@noaa.gov</xd:p>
      <xd:p><xd:b>Modified on:</xd:b> June 13, 2011</xd:p>
      <xd:p><xd:b>Author:</xd:b>david.neufeld@noaa.gov</xd:p>
      <xd:p><xd:b>Modified on:</xd:b> June 23, 2011</xd:p>
      <xd:p><xd:b>Author:</xd:b>daniel.armel@noaa.gov</xd:p>      
      <xd:p/>
    </xd:desc>
  </xd:doc>
  <xsl:variable name="stylesheetVersion" select="'2.1.2'"/>
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>  
  <xsl:variable name="globalAttributeCnt" select="count(/nc:netcdf/nc:attribute)"/>
  <xsl:variable name="variableCnt" select="count(/nc:netcdf/nc:variable)"/>
  <xsl:variable name="variableAttributeCnt" select="count(/nc:netcdf/nc:variable/nc:attribute)"/>
  <xsl:variable name="standardNameCnt"
    select="count(/nc:netcdf/nc:variable/nc:attribute[@name='standard_name'])"/>
  <xsl:variable name="dimensionCnt" select="count(/nc:netcdf/nc:dimension)"/>
  <!-- Identifier Fields: 4 possible -->
  <xsl:variable name="idCnt">
    <xsl:choose>
      <xsl:when test="count(/nc:netcdf/nc:attribute[@name='id']) > 0">
        <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='id'])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='id'])"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="identifierNameSpaceCnt">
    <xsl:choose>
      <xsl:when test="count(/nc:netcdf/nc:attribute[@name='naming_authority']) > 0">
        <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='naming_authority'])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='authority'])"
        />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="metadataConventionCnt">
    <xsl:choose>
      <xsl:when test="count(/nc:netcdf/nc:attribute[@name='Metadata_Conventions']) > 0">
        <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='Metadata_Conventions'])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='documentation']/nc:group[@name='document']/nc:attribute[@type='Metadata_Conventions'])"
        />
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
          <xsl:when
            test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='documentation']/nc:group[@name='document']/nc:attribute[@name='xlink']) > 0">
            <xsl:value-of select="1"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="0"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="identifierTotal"
    select="$idCnt + $identifierNameSpaceCnt + $metadataConventionCnt + $metadataLinkCnt"/>
  <xsl:variable name="identifierMax">4</xsl:variable>
  <!-- Service Fields: 4 possible -->
  <xsl:variable name="thredds_netcdfsubsetCnt"
    select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='services']/nc:attribute[@name='nccs_service'])"/>
  <xsl:variable name="thredds_opendapCnt"
    select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='services']/nc:attribute[@name='opendap_service'])"/>
  <xsl:variable name="thredds_wcsCnt"
    select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='services']/nc:attribute[@name='wcs_service'])"/>
  <xsl:variable name="thredds_wmsCnt"
    select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='services']/nc:attribute[@name='wms_service'])"/>
  <xsl:variable name="thredds_sosCnt"
    select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='services']/nc:attribute[@name='sos_service'])"/>
  <xsl:variable name="serviceTotal"
    select="$thredds_netcdfsubsetCnt + $thredds_opendapCnt + $thredds_wcsCnt + $thredds_wmsCnt + $thredds_sosCnt"/>
  <xsl:variable name="serviceMax">5</xsl:variable>
  <!-- Text Search Fields: 7 possible -->
  <xsl:variable name="titleCnt">
    <xsl:choose>
      <xsl:when test="count(/nc:netcdf/nc:attribute[@name='title']) > 0">
        <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='title'])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='full_name'])"
        />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="summaryCnt">
    <xsl:choose>
      <xsl:when test="count(/nc:netcdf/nc:attribute[@name='summary']) > 0">
        <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='summary'])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='documentation']/nc:group[@name='document']/nc:attribute[@type='summary'])"
        />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="keywordsCnt">
    <xsl:choose>
      <xsl:when test="count(/nc:netcdf/nc:attribute[@name='keywords']) > 0">
        <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='keywords'])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='keywords'])"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="keywordsVocabCnt">
    <xsl:choose>
      <xsl:when test="count(/nc:netcdf/nc:attribute[@name='keywords_vocabulary']) > 0">
        <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='keywords_vocabulary'])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='keywords']/nc:attribute[@name='vocab'])"
        />
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
          <xsl:when
            test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='standard_name_vocabulary']) > 0">
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
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='documentation'])"
        />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="historyCnt">
    <xsl:choose>
      <xsl:when test="count(/nc:netcdf/nc:attribute[@name='history']) > 0">
        <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='history'])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='documentation']/nc:group[@name='document']/nc:attribute[@type='history'])"
        />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="textSearchTotal"
    select="$titleCnt + $summaryCnt + $keywordsCnt + $keywordsVocabCnt      + $stdNameVocabCnt + $commentCnt + $historyCnt"/>
  <xsl:variable name="textSearchMax">7</xsl:variable>

  <!-- Extent Search Fields: 17 possible -->
  <xsl:variable name="geospatial_lat_minCnt">
    <xsl:choose>
      <xsl:when
        test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lat_min']) > 0">
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lat_min'])"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when
            test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lat_min']) > 0">
            <xsl:value-of
              select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lat_min'])"
            />
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
      <xsl:when
        test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lat_max']) > 0">
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lat_max'])"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when
            test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lat_max']) > 0">
            <xsl:value-of
              select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lat_max'])"
            />
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
      <xsl:when
        test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lon_min']) > 0">
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lon_min'])"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when
            test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lon_min']) > 0">
            <xsl:value-of
              select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lon_min'])"
            />
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
      <xsl:when
        test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lon_max']) > 0">
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lon_max'])"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when
            test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lon_max']) > 0">
            <xsl:value-of
              select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lon_max'])"
            />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='geospatial_lon_max'])"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="timeStartCnt">
    <xsl:choose>
      <xsl:when
        test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='time_coverage_start']) > 0">
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='time_coverage_start'])"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when
            test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='time_coverage_start']) > 0">
            <xsl:value-of
              select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='time_coverage_start'])"
            />
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
      <xsl:when
        test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='time_coverage_end']) > 0">
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='time_coverage_end'])"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when
            test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='time_coverage_end']) > 0">
            <xsl:value-of
              select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='time_coverage_end'])"
            />
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
      <xsl:when
        test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_min']) > 0">
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_min'])"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when
            test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_vertical_min']) > 0">
            <xsl:value-of
              select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_vertical_min'])"
            />
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
      <xsl:when
        test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_max']) > 0">
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_max'])"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when
            test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_vertical_max']) > 0">
            <xsl:value-of
              select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_vertical_max'])"
            />
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
      <xsl:when
        test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lat_units']) > 0">
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lat_units'])"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when
            test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lat_units']) > 0">
            <xsl:value-of
              select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lat_units'])"
            />
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
      <xsl:when
        test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lon_units']) > 0">
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lon_units'])"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when
            test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lon_units']) > 0">
            <xsl:value-of
              select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lon_units'])"
            />
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
      <xsl:when
        test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lat_resolution']) > 0">
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lat_resolution'])"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when
            test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lat_resolution']) > 0">
            <xsl:value-of
              select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lat_resolution'])"
            />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='geospatial_lat_resolution'])"
            />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="geospatial_lon_resolutionCnt">
    <xsl:choose>
      <xsl:when
        test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lon_resolution']) > 0">
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lon_resolution'])"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when
            test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lon_resolution']) > 0">
            <xsl:value-of
              select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lon_resolution'])"
            />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='geospatial_lon_resolution'])"
            />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="timeResCnt">
    <xsl:choose>
      <xsl:when
        test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='time_coverage_resolution']) > 0">
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='time_coverage_resolution'])"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when
            test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='time_coverage_resolution']) > 0">
            <xsl:value-of
              select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='time_coverage_resolution'])"
            />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='time_coverage_resolution'])"
            />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="timeDurCnt">
    <xsl:choose>
      <xsl:when
        test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='time_coverage_duration']) > 0">
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='time_coverage_duration'])"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when
            test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='time_coverage_duration']) > 0">
            <xsl:value-of
              select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='time_coverage_duration'])"
            />
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
      <xsl:when
        test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_units']) > 0">
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_units'])"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when
            test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_vertical_units']) > 0">
            <xsl:value-of
              select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_vertical_units'])"
            />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='geospatial_vertical_units'])"
            />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="vertical_resolutionCnt">
    <xsl:choose>
      <xsl:when
        test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_resolution']) > 0">
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_resolution'])"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when
            test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_vertical_resolution']) > 0">
            <xsl:value-of
              select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_vertical_resolution'])"
            />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of
              select="count(/nc:netcdf/nc:attribute[@name='geospatial_vertical_resolution'])"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="vertical_positiveCnt">
    <xsl:choose>
      <xsl:when
        test="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_positive']) > 0">
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_positive'])"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when
            test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_vertical_positive']) > 0">
            <xsl:value-of
              select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_vertical_positive'])"
            />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of
              select="count(/nc:netcdf/nc:attribute[@name='geospatial_vertical_positive'])"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!--  Extent Totals -->
  <xsl:variable name="extentTotal"
    select="$geospatial_lat_minCnt + $geospatial_lat_maxCnt + $geospatial_lon_minCnt + $geospatial_lon_maxCnt     + $timeStartCnt + $timeEndCnt + $vertical_minCnt + $vertical_maxCnt"/>
  <xsl:variable name="extentMax">8</xsl:variable>
  <xsl:variable name="otherExtentTotal"
    select="$geospatial_lat_resolutionCnt + $geospatial_lat_unitsCnt     + $geospatial_lon_resolutionCnt + $geospatial_lon_unitsCnt     + $timeResCnt + $timeDurCnt     + $vertical_unitsCnt + $vertical_resolutionCnt + $vertical_positiveCnt"/>
  <xsl:variable name="otherExtentMax">9</xsl:variable>

  <!-- Responsible Party Fields: 14 possible -->
  <xsl:variable name="creatorNameCnt">
    <xsl:choose>
      <xsl:when test="count(/nc:netcdf/nc:attribute[@name='creator_name']) > 0">
        <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='creator_name'])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='creators']/nc:group[@name='creator']/nc:attribute[@name='name'])"
        />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="creatorURLCnt">
    <xsl:choose>
      <xsl:when test="count(/nc:netcdf/nc:attribute[@name='creator_url']) > 0">
        <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='creator_url'])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='creators']/nc:group[@name='creator']/nc:attribute[@name='url'])"
        />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="creatorEmailCnt">
    <xsl:choose>
      <xsl:when test="count(/nc:netcdf/nc:attribute[@name='creator_email']) > 0">
        <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='creator_email'])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='creators']/nc:group[@name='creator']/nc:attribute[@name='email'])"
        />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="creatorDateCnt">
    <xsl:choose>
      <xsl:when test="count(/nc:netcdf/nc:attribute[@name='date_created']) > 0">
        <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='date_created'])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='dates']/nc:attribute[@type='created'])"
        />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="modifiedDateCnt">
    <xsl:choose>
      <xsl:when test="count(/nc:netcdf/nc:attribute[@name='date_modified']) > 0">
        <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='date_modified'])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='dates']/nc:attribute[@type='modified'])"
        />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="issuedDateCnt">
    <xsl:choose>
      <xsl:when test="count(/nc:netcdf/nc:attribute[@name='date_issued']) > 0">
        <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='date_issued'])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='dates']/nc:attribute[@type='issued'])"
        />
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
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='projects'])"/>
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
          <xsl:when
            test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='documentation']/nc:group[@name='document']/nc:attribute[@type='funding']) > 0">
            <xsl:value-of select="1"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="0"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="dateCnt" select="$creatorDateCnt + $modifiedDateCnt + $issuedDateCnt"/>
  <xsl:variable name="creatorTotal"
    select="$creatorNameCnt + $creatorURLCnt + $creatorEmailCnt + $creatorDateCnt       + $modifiedDateCnt + $issuedDateCnt + $creatorInstCnt + $creatorProjCnt + $creatorAckCnt"/>
  <xsl:variable name="creatorMax">9</xsl:variable>
  <!--  -->
  <xsl:variable name="contributorNameCnt">
    <xsl:choose>
      <xsl:when test="count(/nc:netcdf/nc:attribute[@name='contributor_name']) > 0">
        <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='contributor_name'])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when
            test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='contributors']/nc:group[@name='contributor']/nc:attribute[@name='name']) > 0">
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
          <xsl:when
            test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='contributors']/nc:group[@name='contributor']/nc:attribute[@name='role']) > 0">
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
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='publishers']/nc:group[@name='publisher']/nc:attribute[@type='name'])"
        />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="publisherURLCnt">
    <xsl:choose>
      <xsl:when test="count(/nc:netcdf/nc:attribute[@name='publisher_url']) > 0">
        <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='publisher_url'])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='publishers']/nc:group[@name='publisher']/nc:attribute[@type='url'])"
        />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="publisherEmailCnt">
    <xsl:choose>
      <xsl:when test="count(/nc:netcdf/nc:attribute[@name='publisher_email']) > 0">
        <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='publisher_email'])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='publishers']/nc:group[@name='publisher']/nc:attribute[@type='email'])"
        />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="publisherTotal"
    select="$publisherNameCnt + $publisherURLCnt + $publisherEmailCnt"/>
  <xsl:variable name="publisherMax">3</xsl:variable>
  <!--  -->
  <xsl:variable name="responsiblePartyCnt"
    select="$creatorNameCnt + $contributorNameCnt + $publisherNameCnt"/>
  <xsl:variable name="responsiblePartyTotal"
    select="$creatorTotal + $contributorTotal + $publisherTotal"/>
  <xsl:variable name="responsiblePartyMax">14</xsl:variable>
  <!-- Other Fields: 2 possible -->
  <xsl:variable name="cdmTypeCnt">
    <xsl:choose>
      <xsl:when test="count(/nc:netcdf/nc:attribute[@name='cdm_data_type']) > 0">
        <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='cdm_data_type'])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of
          select="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='data_type'])"
        />
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
          <xsl:when
            test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='documentation']/nc:group[@name='document']/nc:attribute[@type='processing_level']) > 0">
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
        <xsl:value-of select="count(/nc:netcdf/nc:attribute[@name='processing_level'])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when
            test="count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='documentation']/nc:group[@name='document']/nc:attribute[@type='rights']) > 0">
            <xsl:value-of select="1"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="0"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="otherTotal" select="$cdmTypeCnt + $procLevelCnt + $licenseCnt"/>
  <xsl:variable name="otherMax">3</xsl:variable>

  <xsl:variable name="spiralTotal"
    select="$identifierTotal + $textSearchTotal + $extentTotal + $otherExtentTotal + $otherTotal + $responsiblePartyTotal"/>
  <xsl:variable name="spiralMax"
    select="$identifierMax + $otherMax + $textSearchMax + $creatorMax + $extentMax + $responsiblePartyMax"/>

  <!--                        -->
  <!--    Write ISO Metadata  -->
  <!--                        -->
  <xsl:template match="/">
    <gmi:MI_Metadata>
      <xsl:attribute name="xsi:schemaLocation">
        <xsl:value-of
          select="'http://www.isotc211.org/2005/gmi http://www.ngdc.noaa.gov/metadata/published/xsd/schema.xsd'"
        />
      </xsl:attribute>
      <gmd:fileIdentifier>
        <xsl:choose>
          <xsl:when test="$idCnt">
            <gco:CharacterString>
              <!-- Thredds id takes precedence -->
              <xsl:choose>
                <xsl:when
                  test="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='id']">
                  <xsl:value-of
                    select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='id']/@value"
                  />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="/nc:netcdf/nc:attribute[@name='naming_authority']">
                      <xsl:value-of
                        select="/nc:netcdf/nc:attribute[@name='naming_authority']/@value"/>: </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="/nc:netcdf/nc:attribute[@name='id']/@value"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </gco:CharacterString>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="gco:nilReason">
              <xsl:value-of select="'missing'"/>
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </gmd:fileIdentifier>
      <gmd:language>
        <xsl:call-template name="writeCodelist">
          <xsl:with-param name="codeListName" select="'gmd:LanguageCode'"/>
          <xsl:with-param name="codeListValue" select="'eng'"/>
        </xsl:call-template>
      </gmd:language>
      <gmd:characterSet>
        <xsl:call-template name="writeCodelist">
          <xsl:with-param name="codeListName" select="'gmd:MD_CharacterSetCode'"/>
          <xsl:with-param name="codeListValue" select="'UTF8'"/>
        </xsl:call-template>
      </gmd:characterSet>
      <gmd:hierarchyLevel>
        <xsl:call-template name="writeCodelist">
          <xsl:with-param name="codeListName" select="'gmd:MD_ScopeCode'"/>
          <xsl:with-param name="codeListValue" select="'dataset'"/>
        </xsl:call-template>
      </gmd:hierarchyLevel>
      <xsl:if test="$serviceTotal">
        <gmd:hierarchyLevel>
          <xsl:call-template name="writeCodelist">
            <xsl:with-param name="codeListName" select="'gmd:MD_ScopeCode'"/>
            <xsl:with-param name="codeListValue" select="'service'"/>
          </xsl:call-template>
        </gmd:hierarchyLevel>
      </xsl:if>
      <gmd:contact>
        <xsl:attribute name="gco:nilReason">
          <xsl:value-of select="'unknown'"/>
        </xsl:attribute>
      </gmd:contact>
      <gmd:dateStamp>
        <gco:Date>
          <xsl:value-of
            select="/nc:netcdf/nc:group[@name='NCISOMetadata']/nc:attribute[@name='metadata_creation']/@value"
          />
        </gco:Date>
      </gmd:dateStamp>
      <gmd:metadataStandardName>
        <gco:CharacterString>ISO 19115-2 Geographic Information - Metadata Part 2 Extensions for
          imagery and gridded data</gco:CharacterString>
      </gmd:metadataStandardName>
      <gmd:metadataStandardVersion>
        <gco:CharacterString>ISO 19115-2:2009(E)</gco:CharacterString>
      </gmd:metadataStandardVersion>
      <gmd:spatialRepresentationInfo>
        <xsl:choose>
          <xsl:when test="$dimensionCnt">
            <gmd:MD_GridSpatialRepresentation>
              <gmd:numberOfDimensions>
                <gco:Integer>
                  <xsl:value-of
                    select="$dimensionCnt + $geospatial_lon_unitsCnt + $geospatial_lat_unitsCnt + $vertical_unitsCnt + $timeResCnt"
                  />
                </gco:Integer>
              </gmd:numberOfDimensions>
              <xsl:if test="$geospatial_lon_unitsCnt">
                <xsl:call-template name="writeDimension">
                  <xsl:with-param name="dimensionType" select="'column'"/>
                  <xsl:with-param name="dimensionUnits"
                    select="/nc:netcdf/nc:attribute[@name='geospatial_lon_units']/@value"/>
                  <xsl:with-param name="dimensionResolution"
                    select="/nc:netcdf/nc:attribute[@name='geospatial_lon_resolution']/@value"/>
                </xsl:call-template>
              </xsl:if>
              <xsl:if test="$geospatial_lat_unitsCnt">
                <xsl:call-template name="writeDimension">
                  <xsl:with-param name="dimensionType" select="'row'"/>
                  <xsl:with-param name="dimensionUnits"
                    select="/nc:netcdf/nc:attribute[@name='geospatial_lat_units']/@value"/>
                  <xsl:with-param name="dimensionResolution"
                    select="/nc:netcdf/nc:attribute[@name='geospatial_lat_resolution']/@value"/>
                </xsl:call-template>
              </xsl:if>
              <xsl:if test="$vertical_unitsCnt">
                <xsl:call-template name="writeDimension">
                  <xsl:with-param name="dimensionType" select="'vertical'"/>
                  <xsl:with-param name="dimensionUnits"
                    select="/nc:netcdf/nc:attribute[@name='geospatial_vertical_units']/@value"/>
                  <xsl:with-param name="dimensionResolution"
                    select="/nc:netcdf/nc:attribute[@name='geospatial_vertical_resolution']/@value"
                  />
                </xsl:call-template>
              </xsl:if>
              <xsl:if test="$timeResCnt">
                <xsl:call-template name="writeDimension">
                  <xsl:with-param name="dimensionType" select="'temporal'"/>
                  <xsl:with-param name="dimensionUnits" select="'unknown'"/>
                  <xsl:with-param name="dimensionResolution"
                    select="/nc:netcdf/nc:attribute[@name='time_coverage_resolution']/@value"/>
                </xsl:call-template>
              </xsl:if>
              <xsl:for-each select="/nc:netcdf/nc:dimension">
                <xsl:call-template name="writeDimension">
                  <xsl:with-param name="dimensionName" select="@name"/>
                  <xsl:with-param name="dimensionType" select="'unknown'"/>
                  <xsl:with-param name="dimensionUnits"/>
                  <xsl:with-param name="dimensionResolution"/>
                  <xsl:with-param name="dimensionSize" select="@length"/>
                </xsl:call-template>
              </xsl:for-each>
              <gmd:cellGeometry>
                <xsl:call-template name="writeCodelist">
                  <xsl:with-param name="codeListName" select="'gmd:MD_CellGeometryCode'"/>
                  <xsl:with-param name="codeListValue" select="'area'"/>
                </xsl:call-template>
              </gmd:cellGeometry>
              <gmd:transformationParameterAvailability gco:nilReason="unknown"/>
            </gmd:MD_GridSpatialRepresentation>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="gco:nilReason">
              <xsl:value-of select="'missing'"/>
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </gmd:spatialRepresentationInfo>
      <gmd:identificationInfo>
        <gmd:MD_DataIdentification id="DataIdentification">
          <gmd:citation>
            <gmd:CI_Citation>
              <gmd:title>
                <!-- Netcdf takes precedence -->
                <xsl:choose>
                  <xsl:when test="/nc:netcdf/nc:attribute[@name='title']">
                    <xsl:call-template name="writeCharacterString">
                      <xsl:with-param name="testValue" select="$titleCnt"/>
                      <xsl:with-param name="stringToWrite"
                        select="/nc:netcdf/nc:attribute[@name='title']/@value"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="writeCharacterString">
                      <xsl:with-param name="testValue" select="$titleCnt"/>
                      <xsl:with-param name="stringToWrite"
                        select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='full_name']/@value"
                      />
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
              </gmd:title>
              <xsl:choose>
                <xsl:when test="$dateCnt">
                  <xsl:if test="/nc:netcdf/nc:attribute[@name='date_created']">
                    <xsl:call-template name="writeDate">
                      <xsl:with-param name="testValue" select="$creatorDateCnt"/>
                      <xsl:with-param name="dateToWrite"
                        select="/nc:netcdf/nc:attribute[@name='date_created']/@value"/>
                      <xsl:with-param name="dateType" select="'creation'"/>
                    </xsl:call-template>
                  </xsl:if>
                  <xsl:if
                    test="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='dates']/nc:attribute[@type='created']">
                    <xsl:call-template name="writeDate">
                      <xsl:with-param name="testValue" select="$creatorDateCnt"/>
                      <xsl:with-param name="dateToWrite"
                        select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='dates']/nc:attribute[@type='created']/@value"/>
                      <xsl:with-param name="dateType" select="'creation'"/>
                    </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="/nc:netcdf/nc:attribute[@name='date_issued']">
                    <xsl:call-template name="writeDate">
                      <xsl:with-param name="testValue" select="$issuedDateCnt"/>
                      <xsl:with-param name="dateToWrite"
                        select="/nc:netcdf/nc:attribute[@name='date_issued']/@value"/>
                      <xsl:with-param name="dateType" select="'issued'"/>
                    </xsl:call-template>
                  </xsl:if>
                  <xsl:if
                    test="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='dates']/nc:attribute[@type='issued']">
                    <xsl:call-template name="writeDate">
                      <xsl:with-param name="testValue" select="$creatorDateCnt"/>
                      <xsl:with-param name="dateToWrite"
                        select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='dates']/nc:attribute[@type='created']/@value"/>
                      <xsl:with-param name="dateType" select="'creation'"/>
                    </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="/nc:netcdf/nc:attribute[@name='date_modified']">
                    <xsl:call-template name="writeDate">
                      <xsl:with-param name="testValue" select="$modifiedDateCnt"/>
                      <xsl:with-param name="dateToWrite"
                        select="substring(/nc:netcdf/nc:attribute[@name='date_modified']/@value,1,10)"/>
                      <xsl:with-param name="dateType" select="'revision'"/>
                    </xsl:call-template>
                  </xsl:if>
                  <xsl:if
                    test="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='dates']/nc:attribute[@type='modified']">
                    <xsl:call-template name="writeDate">
                      <xsl:with-param name="testValue" select="$modifiedDateCnt"/>
                      <xsl:with-param name="dateToWrite"
                        select="substring(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='dates']/nc:attribute[@type='modified']/@value,1,10)"/>
                      <xsl:with-param name="dateType" select="'revision'"/>
                    </xsl:call-template>
                  </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                  <gmd:date>
                    <xsl:attribute name="gco:nilReason">
                      <xsl:value-of select="'missing'"/>
                    </xsl:attribute>
                  </gmd:date>
                </xsl:otherwise>
              </xsl:choose>
              <gmd:identifier>
                <xsl:choose>
                  <xsl:when test="$idCnt">
                    <gmd:MD_Identifier>
                      <xsl:choose>
                        <xsl:when test="/nc:netcdf/nc:attribute[@name='naming_authority']">
                          <gmd:authority>
                            <gmd:CI_Citation>
                              <gmd:title>
                                <gco:CharacterString>
                                  <xsl:value-of
                                    select="/nc:netcdf/nc:attribute[@name='naming_authority']/@value"
                                  />
                                </gco:CharacterString>
                              </gmd:title>
                              <gmd:date>
                                <xsl:attribute name="gco:nilReason">
                                  <xsl:value-of select="'inapplicable'"/>
                                </xsl:attribute>
                              </gmd:date>
                            </gmd:CI_Citation>
                          </gmd:authority>
                        </xsl:when>
                        <xsl:otherwise>
                          <gmd:authority>
                            <gmd:CI_Citation>
                              <gmd:title>
                                <gco:CharacterString>
                                  <xsl:value-of
                                    select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='authority']/@value"
                                  />
                                </gco:CharacterString>
                              </gmd:title>
                              <gmd:date>
                                <xsl:attribute name="gco:nilReason">
                                  <xsl:value-of select="'inapplicable'"/>
                                </xsl:attribute>
                              </gmd:date>
                            </gmd:CI_Citation>
                          </gmd:authority>
                        </xsl:otherwise>
                      </xsl:choose>
                      <gmd:code>
                        <!--  Just use THREDDs id as it's guaranteed to be unique -->
                        <gco:CharacterString>
                          <xsl:value-of
                            select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='id']/@value"
                          />
                        </gco:CharacterString>
                      </gmd:code>
                    </gmd:MD_Identifier>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="gco:nilReason">
                      <xsl:value-of select="'missing'"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </gmd:identifier>
              <xsl:choose>
                <xsl:when test="$creatorTotal + $contributorTotal">
                  <xsl:if test="$creatorTotal">
                    <xsl:if test="/nc:netcdf/nc:attribute[@name='creator_name']">
                      <xsl:call-template name="writeResponsibleParty">
                        <xsl:with-param name="tagName" select="'gmd:citedResponsibleParty'"/>
                        <xsl:with-param name="testValue" select="$creatorTotal"/>
                        <xsl:with-param name="individualName"
                          select="/nc:netcdf/nc:attribute[@name='creator_name']/@value"/>
                        <xsl:with-param name="organisationName"
                          select="/nc:netcdf/nc:attribute[@name='institution']/@value"/>
                        <xsl:with-param name="email"
                          select="/nc:netcdf/nc:attribute[@name='creator_email']/@value"/>
                        <xsl:with-param name="url"
                          select="/nc:netcdf/nc:attribute[@name='creator_url']/@value"/>
                        <xsl:with-param name="roleCode" select="'originator'"/>
                      </xsl:call-template>
                    </xsl:if>
                    <xsl:if
                      test="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='creators']/nc:group[@name='creator']/nc:attribute[@name='name']">
                      <xsl:call-template name="writeResponsibleParty">
                        <xsl:with-param name="tagName" select="'gmd:citedResponsibleParty'"/>
                        <xsl:with-param name="testValue" select="$creatorTotal"/>
                        <xsl:with-param name="individualName"
                          select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='creators']/nc:group[@name='creator']/nc:attribute[@name='name']/@value"/>
                        <xsl:with-param name="organisationName"
                          select="/nc:netcdf/nc:attribute[@name='institution']/@value"/>
                        <xsl:with-param name="email"
                          select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='creators']/nc:group[@name='creator']/nc:attribute[@name='email']/@value"/>
                        <xsl:with-param name="url"
                          select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='creators']/nc:group[@name='creator']/nc:attribute[@name='url']/@value"/>
                        <xsl:with-param name="roleCode" select="'originator'"/>
                      </xsl:call-template>
                    </xsl:if>
                  </xsl:if>
                  <xsl:if test="$contributorTotal">
                    <xsl:if test="/nc:netcdf/nc:attribute[@name='contributor_name']">
                      <xsl:call-template name="writeResponsibleParty">
                        <xsl:with-param name="tagName" select="'gmd:citedResponsibleParty'"/>
                        <xsl:with-param name="testValue" select="$contributorTotal"/>
                        <xsl:with-param name="individualName"
                          select="/nc:netcdf/nc:attribute[@name='contributor_name']/@value"/>
                        <xsl:with-param name="organisationName"/>
                        <xsl:with-param name="email"/>
                        <xsl:with-param name="url"/>
                        <xsl:with-param name="roleCode"
                          select="/nc:netcdf/nc:attribute[@name='contributor_role']/@value"/>
                      </xsl:call-template>
                    </xsl:if>
                    <xsl:for-each
                      select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='contributors']/nc:group[@name='contributor']">
                      <xsl:call-template name="writeResponsibleParty">
                        <xsl:with-param name="tagName" select="'gmd:citedResponsibleParty'"/>
                        <xsl:with-param name="testValue" select="$contributorTotal"/>
                        <xsl:with-param name="individualName"
                          select="nc:attribute[@name='name']/@value"/>
                        <xsl:with-param name="organisationName"/>
                        <xsl:with-param name="email"/>
                        <xsl:with-param name="url"/>
                        <xsl:with-param name="roleCode" select="nc:attribute[@name='role']/@value"/>
                      </xsl:call-template>
                    </xsl:for-each>
                  </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                  <gmd:citedResponsibleParty>
                    <xsl:attribute name="gco:nilReason">
                      <xsl:value-of select="'missing'"/>
                    </xsl:attribute>
                  </gmd:citedResponsibleParty>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:if test="$commentCnt">
                <gmd:otherCitationDetails>
                  <gco:CharacterString>
                    <xsl:choose>
                      <xsl:when test="count(/nc:netcdf/nc:attribute[@name='comment']) > 0">
                        <xsl:value-of select="/nc:netcdf/nc:attribute[@name='comment']/@value"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of
                          select="c/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='documentation']/@value"
                        />
                      </xsl:otherwise>
                    </xsl:choose>
                  </gco:CharacterString>
                </gmd:otherCitationDetails>
              </xsl:if>
            </gmd:CI_Citation>
          </gmd:citation>
          <gmd:abstract>
            <xsl:choose>
              <xsl:when test="count(/nc:netcdf/nc:attribute[@name='summary']) > 0">
                <xsl:call-template name="writeCharacterString">
                  <xsl:with-param name="testValue" select="$summaryCnt"/>
                  <xsl:with-param name="stringToWrite"
                    select="/nc:netcdf/nc:attribute[@name='summary']/@value"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="writeCharacterString">
                  <xsl:with-param name="testValue" select="$summaryCnt"/>
                  <xsl:with-param name="stringToWrite"
                    select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='documentation']/nc:group[@name='document']/nc:attribute[@type='summary']/@value"
                  />
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </gmd:abstract>
          <gmd:credit>
            <xsl:choose>
              <xsl:when test="count(/nc:netcdf/nc:attribute[@name='acknowledgment']) > 0">
                <xsl:call-template name="writeCharacterString">
                  <xsl:with-param name="testValue" select="$creatorAckCnt"/>
                  <xsl:with-param name="stringToWrite"
                    select="/nc:netcdf/nc:attribute[@name='acknowledgment']/@value"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="writeCharacterString">
                  <xsl:with-param name="testValue" select="$creatorAckCnt"/>
                  <xsl:with-param name="stringToWrite"
                    select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='documentation']/nc:group[@name='document']/nc:attribute[@type='funding']/@value"
                  />
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </gmd:credit>
          <xsl:if
            test="count(/nc:netcdf/nc:attribute[@name='keywords']) > 0 or count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='keywords']/nc:attribute[@name='keyword']) > 0">
            <gmd:descriptiveKeywords>
              <gmd:MD_Keywords>
                <xsl:choose>
                  <xsl:when test="count(/nc:netcdf/nc:attribute[@name='keywords']) > 0">
                    <gmd:keyword>
                      <gco:CharacterString>
                        <xsl:value-of select="/nc:netcdf/nc:attribute[@name='keywords']/@value"/>
                      </gco:CharacterString>
                    </gmd:keyword>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:for-each
                      select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='keywords']/nc:attribute[@name='keyword']">
                      <gmd:keyword>
                        <gco:CharacterString>
                          <xsl:value-of select="@value"/>
                        </gco:CharacterString>
                      </gmd:keyword>
                    </xsl:for-each>
                  </xsl:otherwise>
                </xsl:choose>
                <gmd:type>
                  <xsl:call-template name="writeCodelist">
                    <xsl:with-param name="codeListName" select="'gmd:MD_KeywordTypeCode'"/>
                    <xsl:with-param name="codeListValue" select="'theme'"/>
                  </xsl:call-template>
                </gmd:type>
                <gmd:thesaurusName>
                  <gmd:CI_Citation>
                    <gmd:title>
                      <gco:CharacterString>
                        <xsl:choose>
                          <xsl:when
                            test="count(/nc:netcdf/nc:attribute[@name='keywords_vocabulary']) > 0">
                            <xsl:value-of
                              select="/nc:netcdf/nc:attribute[@name='keywords_vocabulary']/@value"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of
                              select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='keywords']/nc:attribute[@name='vocab']/@value"
                            />
                          </xsl:otherwise>
                        </xsl:choose>
                      </gco:CharacterString>
                    </gmd:title>
                    <gmd:date>
                      <xsl:attribute name="gco:nilReason">
                        <xsl:value-of select="'unknown'"/>
                      </xsl:attribute>
                    </gmd:date>
                  </gmd:CI_Citation>
                </gmd:thesaurusName>
              </gmd:MD_Keywords>
            </gmd:descriptiveKeywords>
          </xsl:if>
          <xsl:if
            test="count(/nc:netcdf/nc:attribute[@name='project']) > 0 or count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='projects']/nc:attribute[@name='project']) > 0">
            <gmd:descriptiveKeywords>
              <gmd:MD_Keywords>
                <xsl:choose>
                  <xsl:when test="count(/nc:netcdf/nc:attribute[@name='project']) > 0">
                    <gmd:keyword>
                      <gco:CharacterString>
                        <xsl:value-of select="/nc:netcdf/nc:attribute[@name='project']/@value"/>
                      </gco:CharacterString>
                    </gmd:keyword>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:for-each
                      select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='projects']/nc:attribute[@name='project']">
                      <gmd:keyword>
                        <gco:CharacterString>
                          <xsl:value-of select="@value"/>
                        </gco:CharacterString>
                      </gmd:keyword>
                    </xsl:for-each>
                  </xsl:otherwise>
                </xsl:choose>
                <gmd:type>
                  <xsl:call-template name="writeCodelist">
                    <xsl:with-param name="codeListName" select="'gmd:MD_KeywordTypeCode'"/>
                    <xsl:with-param name="codeListValue" select="'project'"/>
                  </xsl:call-template>
                </gmd:type>
                <gmd:thesaurusName>
                  <xsl:attribute name="gco:nilReason">
                    <xsl:value-of select="'unknown'"/>
                  </xsl:attribute>
                </gmd:thesaurusName>
              </gmd:MD_Keywords>
            </gmd:descriptiveKeywords>
          </xsl:if>
          <xsl:if
            test="count(/nc:netcdf/nc:attribute[@name='publisher_name']) > 0 or count(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='publisher']) > 0">
            <gmd:descriptiveKeywords>
              <gmd:MD_Keywords>
                <xsl:choose>
                  <xsl:when test="count(/nc:netcdf/nc:attribute[@name='publisher_name']) > 0">
                    <gmd:keyword>
                      <gco:CharacterString>
                        <xsl:value-of
                          select="/nc:netcdf/nc:attribute[@name='publisher_name']/@value"/>
                      </gco:CharacterString>
                    </gmd:keyword>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:for-each
                      select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='projects']/nc:group[@name='publisher']">
                      <gmd:keyword>
                        <gco:CharacterString>
                          <xsl:value-of select="nc:attribute[@type='name']/@value"/>
                        </gco:CharacterString>
                      </gmd:keyword>
                    </xsl:for-each>
                  </xsl:otherwise>
                </xsl:choose>
                <gmd:type>
                  <xsl:call-template name="writeCodelist">
                    <xsl:with-param name="codeListName" select="'gmd:MD_KeywordTypeCode'"/>
                    <xsl:with-param name="codeListValue" select="'dataCenter'"/>
                  </xsl:call-template>
                </gmd:type>
                <gmd:thesaurusName>
                  <xsl:attribute name="gco:nilReason">
                    <xsl:value-of select="'unknown'"/>
                  </xsl:attribute>
                </gmd:thesaurusName>
              </gmd:MD_Keywords>
            </gmd:descriptiveKeywords>
          </xsl:if>
          <xsl:if test="$standardNameCnt">
            <gmd:descriptiveKeywords>
              <gmd:MD_Keywords>
                <xsl:for-each select="/nc:netcdf/nc:variable/nc:attribute[@name='standard_name']">
                  <gmd:keyword>
                    <gco:CharacterString>
                      <xsl:value-of select="./@value"/>
                    </gco:CharacterString>
                  </gmd:keyword>
                </xsl:for-each>
                <gmd:type>
                  <xsl:call-template name="writeCodelist">
                    <xsl:with-param name="codeListName" select="'gmd:MD_KeywordTypeCode'"/>
                    <xsl:with-param name="codeListValue" select="'theme'"/>
                  </xsl:call-template>
                </gmd:type>
                <gmd:thesaurusName>
                  <gmd:CI_Citation>
                    <gmd:title>
                      <xsl:call-template name="writeCharacterString">
                        <xsl:with-param name="testValue" select="$stdNameVocabCnt"/>
                        <xsl:with-param name="stringToWrite"
                          select="/nc:netcdf/nc:attribute[@name='standard_name_vocabulary']/@value"
                        />
                      </xsl:call-template>
                    </gmd:title>
                    <gmd:date gco:nilReason="unknown"/>
                  </gmd:CI_Citation>
                </gmd:thesaurusName>
              </gmd:MD_Keywords>
            </gmd:descriptiveKeywords>
          </xsl:if>
          <xsl:if test="$licenseCnt">
            <gmd:resourceConstraints>
              <gmd:MD_LegalConstraints>
                <gmd:useLimitation>
                  <gco:CharacterString>
                    <xsl:choose>
                      <xsl:when test="count(/nc:netcdf/nc:attribute[@name='license']) > 0">
                        <xsl:value-of select="/nc:netcdf/nc:attribute[@name='license']/@value"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of
                          select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='documentation']/nc:group[@name='document']/nc:attribute[@type='rights']"
                        />
                      </xsl:otherwise>
                    </xsl:choose>
                  </gco:CharacterString>
                </gmd:useLimitation>
              </gmd:MD_LegalConstraints>
            </gmd:resourceConstraints>
          </xsl:if>
          <xsl:if test="$creatorProjCnt">
            <gmd:aggregationInfo>
              <gmd:MD_AggregateInformation>
                <xsl:choose>
                  <xsl:when test="count(/nc:netcdf/nc:attribute[@name='project']) > 0">
                    <gmd:aggregateDataSetName>
                      <gmd:CI_Citation>
                        <gmd:title>
                          <gco:CharacterString>
                            <xsl:value-of select="/nc:netcdf/nc:attribute[@name='project']/@value"/>
                          </gco:CharacterString>
                        </gmd:title>
                        <gmd:date gco:nilReason="inapplicable"/>
                      </gmd:CI_Citation>
                    </gmd:aggregateDataSetName>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:for-each
                      select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='projects']/nc:attribute[@name='project']">
                      <gmd:aggregateDataSetName>
                        <gmd:CI_Citation>
                          <gmd:title>
                            <gco:CharacterString>
                              <xsl:value-of select="@value"/>
                            </gco:CharacterString>
                          </gmd:title>
                          <gmd:date gco:nilReason="inapplicable"/>
                        </gmd:CI_Citation>
                      </gmd:aggregateDataSetName>
                    </xsl:for-each>
                  </xsl:otherwise>
                </xsl:choose>
                <gmd:associationType>
                  <xsl:call-template name="writeCodelist">
                    <xsl:with-param name="codeListName" select="'gmd:DS_AssociationTypeCode'"/>
                    <xsl:with-param name="codeListValue" select="'largerWorkCitation'"/>
                  </xsl:call-template>
                </gmd:associationType>
                <gmd:initiativeType>
                  <xsl:call-template name="writeCodelist">
                    <xsl:with-param name="codeListName" select="'gmd:DS_InitiativeTypeCode'"/>
                    <xsl:with-param name="codeListValue" select="'project'"/>
                  </xsl:call-template>
                </gmd:initiativeType>
              </gmd:MD_AggregateInformation>
            </gmd:aggregationInfo>
          </xsl:if>
          <xsl:if test="$cdmTypeCnt">
            <gmd:aggregationInfo>
              <gmd:MD_AggregateInformation>
                <gmd:aggregateDataSetIdentifier>
                  <gmd:MD_Identifier>
                    <gmd:authority>
                      <gmd:CI_Citation>
                        <gmd:title>
                          <gco:CharacterString>Unidata Common Data Model</gco:CharacterString>
                        </gmd:title>
                        <gmd:date gco:nilReason="inapplicable"/>
                      </gmd:CI_Citation>
                    </gmd:authority>
                    <gmd:code>
                      <gco:CharacterString>
                        <xsl:choose>
                          <xsl:when test="count(/nc:netcdf/nc:attribute[@name='cdm_data_type']) > 0">
                            <xsl:value-of
                              select="/nc:netcdf/nc:attribute[@name='cdm_data_type']/@value"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of
                              select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='data_type']"
                            />
                          </xsl:otherwise>
                        </xsl:choose>
                      </gco:CharacterString>
                    </gmd:code>
                  </gmd:MD_Identifier>
                </gmd:aggregateDataSetIdentifier>
                <gmd:associationType>
                  <xsl:call-template name="writeCodelist">
                    <xsl:with-param name="codeListName" select="'gmd:DS_AssociationTypeCode'"/>
                    <xsl:with-param name="codeListValue" select="'largerWorkCitation'"/>
                  </xsl:call-template>
                </gmd:associationType>
                <gmd:initiativeType>
                  <xsl:call-template name="writeCodelist">
                    <xsl:with-param name="codeListName" select="'gmd:DS_InitiativeTypeCode'"/>
                    <xsl:with-param name="codeListValue" select="'project'"/>
                  </xsl:call-template>
                </gmd:initiativeType>
              </gmd:MD_AggregateInformation>
            </gmd:aggregationInfo>
          </xsl:if>
          <gmd:language>
            <gco:CharacterString>eng</gco:CharacterString>
          </gmd:language>
          <gmd:topicCategory>
            <gmd:MD_TopicCategoryCode>climatologyMeteorologyAtmosphere</gmd:MD_TopicCategoryCode>
          </gmd:topicCategory>
          <gmd:extent>
            <xsl:choose>
              <xsl:when test="$extentTotal">
                <gmd:EX_Extent>
                  <xsl:attribute name="id">
                    <xsl:value-of select="'boundingExtent'"/>
                  </xsl:attribute>
                  <xsl:if test="$geospatial_lat_minCnt > 0">
                    <gmd:geographicElement>
                      <gmd:EX_GeographicBoundingBox id="boundingGeographicBoundingBox">
                        <gmd:extentTypeCode>
                          <gco:Boolean>1</gco:Boolean>
                        </gmd:extentTypeCode>
                        <gmd:westBoundLongitude>
                          <gco:Decimal>
                            <xsl:choose>
                              <xsl:when
                                test="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lon_min']">
                                <xsl:value-of
                                  select="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lon_min']/@value"
                                />
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:if
                                  test="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lon_min']">
                                  <xsl:value-of
                                    select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lon_min']/@value"
                                  />
                                </xsl:if>
                              </xsl:otherwise>
                            </xsl:choose>
                          </gco:Decimal>
                        </gmd:westBoundLongitude>
                        <gmd:eastBoundLongitude>
                          <gco:Decimal>
                            <xsl:choose>
                              <xsl:when
                                test="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lon_max']">
                                <xsl:value-of
                                  select="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lon_max']/@value"
                                />
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of
                                  select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lon_max']/@value"
                                />
                              </xsl:otherwise>
                            </xsl:choose>
                          </gco:Decimal>
                        </gmd:eastBoundLongitude>
                        <gmd:southBoundLatitude>
                          <gco:Decimal>
                            <xsl:choose>
                              <xsl:when
                                test="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lat_min']">
                                <xsl:value-of
                                  select="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lat_min']/@value"
                                />
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of
                                  select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lat_min']/@value"
                                />
                              </xsl:otherwise>
                            </xsl:choose>
                          </gco:Decimal>
                        </gmd:southBoundLatitude>
                        <gmd:northBoundLatitude>
                          <gco:Decimal>
                            <xsl:choose>
                              <xsl:when
                                test="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lat_max']">
                                <xsl:value-of
                                  select="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lat_max']/@value"
                                />
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of
                                  select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lat_max']/@value"
                                />
                              </xsl:otherwise>
                            </xsl:choose>
                          </gco:Decimal>
                        </gmd:northBoundLatitude>
                      </gmd:EX_GeographicBoundingBox>
                    </gmd:geographicElement>
                  </xsl:if>
                  <xsl:if test="$timeStartCnt">
                    <gmd:temporalElement>
                      <gmd:EX_TemporalExtent>
                        <xsl:attribute name="id">
                          <xsl:value-of select="'boundingTemporalExtent'"/>
                        </xsl:attribute>
                        <gmd:extent>
                          <gml:TimePeriod gml:id="timePeriod_id">
                            <gml:beginPosition>
                              <xsl:choose>
                                <xsl:when
                                  test="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='time_coverage_start']">
                                  <xsl:value-of
                                    select="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='time_coverage_start']/@value"
                                  />
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:value-of
                                    select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='time_coverage_start']/@value"
                                  />
                                </xsl:otherwise>
                              </xsl:choose>
                            </gml:beginPosition>
                            <gml:endPosition>
                              <xsl:choose>
                                <xsl:when
                                  test="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='time_coverage_end']">
                                  <xsl:value-of
                                    select="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='time_coverage_end']/@value"
                                  />
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:value-of
                                    select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='time_coverage_end']/@value"
                                  />
                                </xsl:otherwise>
                              </xsl:choose>
                            </gml:endPosition>
                          </gml:TimePeriod>
                        </gmd:extent>
                      </gmd:EX_TemporalExtent>
                    </gmd:temporalElement>
                  </xsl:if>
                  <xsl:if test="$vertical_minCnt > 0">
                    <gmd:verticalElement>
                      <gmd:EX_VerticalExtent>
                        <gmd:minimumValue>
                          <gco:Real>
                            <xsl:choose>
                              <xsl:when
                                test="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_positive']">
                                <xsl:choose>
                                  <xsl:when
                                    test="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_positive']/@value = 'down'">
                                    <xsl:value-of
                                      select="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_min']/@value * -1"
                                    />
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of
                                      select="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_min']/@value"
                                    />
                                  </xsl:otherwise>
                                </xsl:choose>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:choose>
                                  <xsl:when
                                    test="/nc:netcdf/nc:group[@name='THREDDSMetadata']//nc:attribute[@name='geospatial_vertical_positive']/@value = 'down'">
                                    <xsl:value-of
                                      select="/nc:netcdf/nc:group[@name='THREDDSMetadata']//nc:attribute[@name='geospatial_vertical_min']/@value * -1"
                                    />
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of
                                      select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_vertical_min']/@value"
                                    />
                                  </xsl:otherwise>
                                </xsl:choose>
                              </xsl:otherwise>
                            </xsl:choose>
                          </gco:Real>
                        </gmd:minimumValue>
                        <gmd:maximumValue>
                          <gco:Real>
                            <xsl:choose>
                              <xsl:when
                                test="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_positive']">
                                <xsl:choose>
                                  <xsl:when
                                    test="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_positive']/@value = 'down'">
                                    <xsl:value-of
                                      select="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_max']/@value * -1"
                                    />
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of
                                      select="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_max']/@value"
                                    />
                                  </xsl:otherwise>
                                </xsl:choose>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:choose>
                                  <xsl:when
                                    test="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_vertical_positive']/@value = 'down'">
                                    <xsl:value-of
                                      select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_vertical_max']/@value * -1"
                                    />
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of
                                      select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_vertical_max']/@value"
                                    />
                                  </xsl:otherwise>
                                </xsl:choose>
                              </xsl:otherwise>
                            </xsl:choose>
                          </gco:Real>
                        </gmd:maximumValue>
                        <gmd:verticalCRS>
                          <xsl:attribute name="gco:nilReason">
                            <xsl:value-of select="'missing'"/>
                          </xsl:attribute>
                        </gmd:verticalCRS>
                      </gmd:EX_VerticalExtent>
                    </gmd:verticalElement>
                  </xsl:if>
                </gmd:EX_Extent>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="gco:nilReason">
                  <xsl:value-of select="'missing'"/>
                </xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
          </gmd:extent>
        </gmd:MD_DataIdentification>
      </gmd:identificationInfo>
      <xsl:if test="$thredds_opendapCnt">
        <xsl:call-template name="writeService">
          <xsl:with-param name="serviceID" select="'OPeNDAP'"/>
          <xsl:with-param name="serviceTypeName" select="'THREDDS OPeNDAP'"/>
          <xsl:with-param name="serviceOperationName" select="'OPeNDAPDatasetQueryAndAccess'"/>
          <xsl:with-param name="operationURL"
            select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='services']/nc:attribute[@name='opendap_service']/@value"
          />
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="$thredds_wcsCnt">
        <xsl:call-template name="writeService">
          <xsl:with-param name="serviceID" select="'OGC-WCS'"/>
          <xsl:with-param name="serviceTypeName"
            select="'Open Geospatial Consortium Web Coverage Service (WCS)'"/>
          <xsl:with-param name="serviceOperationName" select="'GetCapabilities'"/>
          <xsl:with-param name="operationURL"
            select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='services']/nc:attribute[@name='wcs_service']/@value"
          />
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="$thredds_wmsCnt">
        <xsl:call-template name="writeService">
          <xsl:with-param name="serviceID" select="'OGC-WMS'"/>
          <xsl:with-param name="serviceTypeName"
            select="'Open Geospatial Consortium Web Map Service (WMS)'"/>
          <xsl:with-param name="serviceOperationName" select="'GetCapabilities'"/>
          <xsl:with-param name="operationURL"
            select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='services']/nc:attribute[@name='wms_service']/@value"
          />
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="$thredds_sosCnt">
        <xsl:call-template name="writeService">
          <xsl:with-param name="serviceID" select="'OGC-SOS'"/>
          <xsl:with-param name="serviceTypeName"
            select="'Open Geospatial Consortium Sensor Observation Service (SOS)'"/>
          <xsl:with-param name="serviceOperationName" select="'GetCapabilities'"/>
          <xsl:with-param name="operationURL"
            select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='services']/nc:attribute[@name='sos_service']/@value"
          />
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="$thredds_netcdfsubsetCnt">
        <xsl:call-template name="writeService">
          <xsl:with-param name="serviceID" select="'THREDDS_NetCDF_Subset'"/>
          <xsl:with-param name="serviceTypeName" select="'THREDDS NetCDF Subset Service'"/>
          <xsl:with-param name="serviceOperationName" select="'NetCDFSubsetService'"/>
          <xsl:with-param name="operationURL"
            select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='services']/nc:attribute[@name='netcdfsubset_service']/@value"
          />
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="$variableCnt">
        <gmd:contentInfo>
          <gmi:MI_CoverageDescription>
            <gmd:attributeDescription>
              <xsl:attribute name="gco:nilReason">
                <xsl:value-of select="'unknown'"/>
              </xsl:attribute>
            </gmd:attributeDescription>
            <gmd:contentType>
              <xsl:attribute name="gco:nilReason">
                <xsl:value-of select="'unknown'"/>
              </xsl:attribute>
            </gmd:contentType>
            <xsl:for-each select="/nc:netcdf/nc:variable">
              <xsl:call-template name="writeVariable">
                <xsl:with-param name="variableName" select="./@name"/>
                <xsl:with-param name="variableLongName"
                  select="./nc:attribute[@name='long_name']/@value"/>
                <xsl:with-param name="variableType" select="./@type"/>
                <xsl:with-param name="variableUnits" select="./nc:attribute[@name='units']/@value"/>
              </xsl:call-template>
            </xsl:for-each>
          </gmi:MI_CoverageDescription>
        </gmd:contentInfo>
      </xsl:if>
      <xsl:if test="$publisherTotal or $thredds_opendapCnt">
        <gmd:distributionInfo>
          <gmd:MD_Distribution>
            <gmd:distributor>
              <gmd:MD_Distributor>
                <xsl:choose>
                  <xsl:when test="$publisherTotal">
                    <xsl:choose>
                      <xsl:when test="/nc:netcdf/nc:attribute[@name='publisher_name']">
                        <xsl:call-template name="writeResponsibleParty">
                          <xsl:with-param name="tagName" select="'gmd:distributorContact'"/>
                          <xsl:with-param name="testValue" select="$publisherTotal"/>
                          <xsl:with-param name="individualName"/>
                          <xsl:with-param name="organisationName"
                            select="/nc:netcdf/nc:attribute[@name='publisher_name']/@value"/>
                          <xsl:with-param name="email"
                            select="/nc:netcdf/nc:attribute[@name='publisher_email']/@value"/>
                          <xsl:with-param name="url"
                            select="/nc:netcdf/nc:attribute[@name='publisher_url']/@value"/>
                          <xsl:with-param name="urlName" select="'URL for the data publisher'"/>
                          <xsl:with-param name="urlDescription"
                            select="'This URL provides contact information for the publisher of this dataset'"/>
                          <xsl:with-param name="roleCode" select="'publisher'"/>
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:call-template name="writeResponsibleParty">
                          <xsl:with-param name="tagName" select="'gmd:distributorContact'"/>
                          <xsl:with-param name="testValue" select="$publisherTotal"/>
                          <xsl:with-param name="individualName"/>
                          <xsl:with-param name="organisationName"
                            select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='publishers']/nc:group[@name='publisher']/nc:attribute[@name='name']/@value"/>
                          <xsl:with-param name="email"
                            select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='publishers']/nc:group[@name='publisher']/nc:attribute[@name='email']/@value"/>
                          <xsl:with-param name="url"
                            select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='publishers']/nc:group[@name='publisher']/nc:attribute[@name='url']/@value"/>
                          <xsl:with-param name="urlName" select="'URL for the data publisher'"/>
                          <xsl:with-param name="urlDescription"
                            select="'This URL provides contact information for the publisher of this dataset'"/>
                          <xsl:with-param name="roleCode" select="'publisher'"/>
                        </xsl:call-template>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
                    <gmd:distributorContact gco:nilReason="missing"/>
                  </xsl:otherwise>
                </xsl:choose>
                <gmd:distributorFormat>
                  <gmd:MD_Format>
                    <gmd:name>
                      <gco:CharacterString>OPeNDAP</gco:CharacterString>
                    </gmd:name>
                    <gmd:version gco:nilReason="unknown"/>
                  </gmd:MD_Format>
                </gmd:distributorFormat>
                <xsl:if test="$thredds_opendapCnt">
                  <gmd:distributorTransferOptions>
                    <gmd:MD_DigitalTransferOptions>
                      <gmd:onLine>
                        <gmd:CI_OnlineResource>
                          <gmd:linkage>
                            <gmd:URL>
                              <xsl:value-of
                                select="concat(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='services']/nc:attribute[@name='opendap_service']/@value,'.html')"
                              />
                            </gmd:URL>
                          </gmd:linkage>
                          <gmd:name>
                            <gco:CharacterString>File Information</gco:CharacterString>
                          </gmd:name>
                          <gmd:description>
                            <gco:CharacterString>This URL provides a standard OPeNDAP html interface
                              for selecting data from this dataset. Change the extension to .info
                              for a description of the dataset.</gco:CharacterString>
                          </gmd:description>
                          <gmd:function>
                            <gmd:CI_OnLineFunctionCode
                              codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_OnLineFunctionCode"
                              codeListValue="download">download</gmd:CI_OnLineFunctionCode>
                          </gmd:function>
                        </gmd:CI_OnlineResource>
                      </gmd:onLine>
                    </gmd:MD_DigitalTransferOptions>
                  </gmd:distributorTransferOptions>
                </xsl:if>
              </gmd:MD_Distributor>
            </gmd:distributor>
          </gmd:MD_Distribution>
        </gmd:distributionInfo>
      </xsl:if>
      <xsl:if test="$historyCnt">
        <gmd:dataQualityInfo>
          <gmd:DQ_DataQuality>
            <gmd:scope>
              <gmd:DQ_Scope>
                <gmd:level>
                  <xsl:call-template name="writeCodelist">
                    <xsl:with-param name="codeListName" select="'gmd:MD_ScopeCode'"/>
                    <xsl:with-param name="codeListValue" select="'dataset'"/>
                  </xsl:call-template>
                </gmd:level>
              </gmd:DQ_Scope>
            </gmd:scope>
            <gmd:lineage>
              <gmd:LI_Lineage>
                <gmd:statement>
                  <gco:CharacterString>
                    <xsl:choose>
                      <xsl:when test="/nc:netcdf/nc:attribute[@name='history']">
                        <xsl:value-of select="/nc:netcdf/nc:attribute[@name='history']/@value"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of
                          select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='documentation']/nc:group[@name='document']/nc:attribute[@type='history']/@value"
                        />
                      </xsl:otherwise>
                    </xsl:choose>
                  </gco:CharacterString>
                </gmd:statement>
              </gmd:LI_Lineage>
            </gmd:lineage>
          </gmd:DQ_DataQuality>
        </gmd:dataQualityInfo>
      </xsl:if>
      <gmd:metadataMaintenance>
        <gmd:MD_MaintenanceInformation>
          <gmd:maintenanceAndUpdateFrequency gco:nilReason="unknown"/>
          <gmd:maintenanceNote>
            <gco:CharacterString>This record was translated from NcML using UnidataDD2MI.xsl Version
                <xsl:value-of select="$stylesheetVersion"/></gco:CharacterString>
          </gmd:maintenanceNote>
        </gmd:MD_MaintenanceInformation>
      </gmd:metadataMaintenance>
    </gmi:MI_Metadata>
  </xsl:template>
  <xsl:template name="writeCodelist">
    <xsl:param name="codeListName"/>
    <xsl:param name="codeListValue"/>
    <xsl:variable name="codeListLocation"
      select="'http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml'"/>
    <xsl:element name="{$codeListName}">
      <xsl:attribute name="codeList">
        <xsl:value-of select="$codeListLocation"/>
        <xsl:value-of select="'#'"/>
        <xsl:value-of select="$codeListName"/>
      </xsl:attribute>
      <xsl:attribute name="codeListValue">
        <xsl:value-of select="$codeListValue"/>
      </xsl:attribute>
      <xsl:value-of select="$codeListValue"/>
    </xsl:element>
  </xsl:template>
  <xsl:template name="writeCharacterString">
    <xsl:param name="testValue"/>
    <xsl:param name="stringToWrite"/>
    <xsl:choose>
      <xsl:when test="$testValue">
        <gco:CharacterString>
          <xsl:value-of select="$stringToWrite"/>
        </gco:CharacterString>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="gco:nilReason">
          <xsl:value-of select="'missing'"/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="writeDate">
    <xsl:param name="testValue"/>
    <xsl:param name="dateToWrite"/>
    <xsl:param name="dateType"/>
    <xsl:if test="$testValue">
      <xsl:choose>
        <xsl:when test="contains($dateToWrite, 'T' ) ">
          <gmd:date>
            <gmd:CI_Date>
              <gmd:date>
                <gco:DateTime>
                  <xsl:value-of select="$dateToWrite"/>
                </gco:DateTime>
              </gmd:date>
              <gmd:dateType>
                <xsl:call-template name="writeCodelist">
                  <xsl:with-param name="codeListName" select="'gmd:CI_DateTypeCode'"/>
                  <xsl:with-param name="codeListValue" select="$dateType"/>
                </xsl:call-template>
              </gmd:dateType>
            </gmd:CI_Date>
          </gmd:date>
        </xsl:when>
        <xsl:otherwise>
          <gmd:date>
            <gmd:CI_Date>
              <gmd:date>
                <gco:Date>
                  <xsl:value-of select="$dateToWrite"/>
                </gco:Date>
              </gmd:date>
              <gmd:dateType>
                <xsl:call-template name="writeCodelist">
                  <xsl:with-param name="codeListName" select="'gmd:CI_DateTypeCode'"/>
                  <xsl:with-param name="codeListValue" select="$dateType"/>
                </xsl:call-template>
              </gmd:dateType>
            </gmd:CI_Date>
          </gmd:date>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  <xsl:template name="writeResponsibleParty">
    <xsl:param name="tagName"/>
    <xsl:param name="testValue"/>
    <xsl:param name="individualName"/>
    <xsl:param name="organisationName"/>
    <xsl:param name="email"/>
    <xsl:param name="url"/>
    <xsl:param name="urlName"/>
    <xsl:param name="urlDescription"/>
    <xsl:param name="roleCode"/>
    <xsl:choose>
      <xsl:when test="$testValue">
        <xsl:element name="{$tagName}">
          <gmd:CI_ResponsibleParty>
            <gmd:individualName>
              <xsl:call-template name="writeCharacterString">
                <xsl:with-param name="testValue" select="$individualName"/>
                <xsl:with-param name="stringToWrite" select="$individualName"/>
              </xsl:call-template>
            </gmd:individualName>
            <gmd:organisationName>
              <xsl:call-template name="writeCharacterString">
                <xsl:with-param name="testValue" select="$organisationName"/>
                <xsl:with-param name="stringToWrite" select="$organisationName"/>
              </xsl:call-template>
            </gmd:organisationName>
            <gmd:contactInfo>
              <xsl:choose>
                <xsl:when test="$email or $url">
                  <gmd:CI_Contact>
                    <xsl:if test="$email">
                      <gmd:address>
                        <gmd:CI_Address>
                          <gmd:electronicMailAddress>
                            <gco:CharacterString>
                              <xsl:value-of select="$email"/>
                            </gco:CharacterString>
                          </gmd:electronicMailAddress>
                        </gmd:CI_Address>
                      </gmd:address>
                    </xsl:if>
                    <xsl:if test="$url">
                      <gmd:onlineResource>
                        <gmd:CI_OnlineResource>
                          <gmd:linkage>
                            <gmd:URL>
                              <xsl:value-of select="$url"/>
                            </gmd:URL>
                          </gmd:linkage>
                          <gmd:protocol>
                            <gco:CharacterString>http</gco:CharacterString>
                          </gmd:protocol>
                          <gmd:applicationProfile>
                            <gco:CharacterString>web browser</gco:CharacterString>
                          </gmd:applicationProfile>
                          <gmd:name>
                            <gco:CharacterString>
                              <xsl:value-of select="$urlName"/>
                            </gco:CharacterString>
                          </gmd:name>
                          <gmd:description>
                            <gco:CharacterString>
                              <xsl:value-of select="$urlDescription"/>
                            </gco:CharacterString>
                          </gmd:description>
                          <gmd:function>
                            <xsl:call-template name="writeCodelist">
                              <xsl:with-param name="codeListName"
                                select="'gmd:CI_OnLineFunctionCode'"/>
                              <xsl:with-param name="codeListValue" select="'information'"/>
                            </xsl:call-template>
                          </gmd:function>
                        </gmd:CI_OnlineResource>
                      </gmd:onlineResource>
                    </xsl:if>
                  </gmd:CI_Contact>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="gco:nilReason">
                    <xsl:value-of select="'missing'"/>
                  </xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
            </gmd:contactInfo>
            <gmd:role>
              <xsl:call-template name="writeCodelist">
                <xsl:with-param name="codeListName" select="'gmd:CI_RoleCode'"/>
                <xsl:with-param name="codeListValue" select="$roleCode"/>
              </xsl:call-template>
            </gmd:role>
          </gmd:CI_ResponsibleParty>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="writeDimension">
    <xsl:param name="dimensionName"/>
    <xsl:param name="dimensionType"/>
    <xsl:param name="dimensionUnits"/>
    <xsl:param name="dimensionResolution"/>
    <xsl:param name="dimensionSize"/>
    <gmd:axisDimensionProperties>
      <gmd:MD_Dimension>
        <xsl:if test="$dimensionName">
          <xsl:attribute name="id">
            <xsl:value-of select="$dimensionName"/>
          </xsl:attribute>
        </xsl:if>
        <gmd:dimensionName>
          <xsl:call-template name="writeCodelist">
            <xsl:with-param name="codeListName" select="'gmd:MD_DimensionNameTypeCode'"/>
            <xsl:with-param name="codeListValue" select="$dimensionType"/>
          </xsl:call-template>
        </gmd:dimensionName>
        <xsl:choose>
          <xsl:when test="$dimensionSize">
            <gmd:dimensionSize>
              <gco:Integer>
                <xsl:value-of select="$dimensionSize"/>
              </gco:Integer>
            </gmd:dimensionSize>
          </xsl:when>
          <xsl:otherwise>
            <gmd:dimensionSize>
              <xsl:attribute name="gco:nilReason">
                <xsl:value-of select="'unknown'"/>
              </xsl:attribute>
            </gmd:dimensionSize>
          </xsl:otherwise>
        </xsl:choose>
        <gmd:resolution>
          <xsl:choose>
            <xsl:when test="contains($dimensionResolution,' ')">
              <gco:Measure>
                <xsl:attribute name="uom">
                  <xsl:value-of select="substring-after($dimensionResolution,' ')"/>
                </xsl:attribute>
                <xsl:value-of select="substring-before($dimensionResolution,' ')"/>
              </gco:Measure>
            </xsl:when>
            <xsl:when test="contains($dimensionResolution,'PT')">
              <gco:Measure>
                <xsl:attribute name="uom">
                  <xsl:if test="substring($dimensionResolution, 4)='S'">
                    <xsl:value-of
                      select="translate(substring($dimensionResolution, 4),$uppercase, $smallcase)"
                    />
                  </xsl:if>
                  <xsl:if test="substring($dimensionResolution, 4)='M'">minutes</xsl:if>
                </xsl:attribute>
                <xsl:value-of select="substring($dimensionResolution,3,1)"/>
              </gco:Measure>
            </xsl:when>
            <xsl:when test="$dimensionUnits and $dimensionResolution">
              <gco:Measure>
                <xsl:attribute name="uom">
                  <xsl:value-of select="$dimensionUnits"/>
                </xsl:attribute>
                <xsl:value-of select="$dimensionResolution"/>
              </gco:Measure>
            </xsl:when>
            <xsl:when test="$dimensionUnits and not($dimensionResolution)">
              <gco:Measure>
                <xsl:attribute name="uom">
                  <xsl:value-of select="$dimensionUnits"/>
                </xsl:attribute>
                <xsl:value-of select="'99999'"/>
              </gco:Measure>
            </xsl:when>
            <xsl:when test="not($dimensionUnits) and $dimensionResolution">
              <gco:Measure>
                <xsl:attribute name="uom">
                  <xsl:value-of select="'unknown'"/>
                </xsl:attribute>
                <xsl:value-of select="$dimensionResolution"/>
              </gco:Measure>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="gco:nilReason">
                <xsl:value-of select="'missing'"/>
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
        </gmd:resolution>
      </gmd:MD_Dimension>
    </gmd:axisDimensionProperties>
  </xsl:template>
  <xsl:template name="writeVariable">
    <xsl:param name="variableName"/>
    <xsl:param name="variableLongName"/>
    <xsl:param name="variableType"/>
    <xsl:param name="variableUnits"/>
    <gmd:dimension>
      <gmd:MD_Band>
        <gmd:sequenceIdentifier>
          <gco:MemberName>
            <gco:aName>
              <gco:CharacterString>
                <xsl:value-of select="$variableName"/>
              </gco:CharacterString>
            </gco:aName>
            <gco:attributeType>
              <gco:TypeName>
                <gco:aName>
                  <gco:CharacterString>
                    <xsl:value-of select="$variableType"/>
                  </gco:CharacterString>
                </gco:aName>
              </gco:TypeName>
            </gco:attributeType>
          </gco:MemberName>
        </gmd:sequenceIdentifier>
        <gmd:descriptor>
          <xsl:call-template name="writeCharacterString">
            <xsl:with-param name="testValue" select="$variableLongName"/>
            <xsl:with-param name="stringToWrite" select="$variableLongName"/>
          </xsl:call-template>
        </gmd:descriptor>
        <gmd:units>
          <xsl:attribute name="xlink:href">
            <xsl:value-of select="'http://someUnitsDictionary.xml#'"/>
            <xsl:value-of select="$variableUnits"/>
          </xsl:attribute>
        </gmd:units>
      </gmd:MD_Band>
    </gmd:dimension>
  </xsl:template>
  <xsl:template name="writeService">
    <xsl:param name="serviceID"/>
    <xsl:param name="serviceTypeName"/>
    <xsl:param name="serviceOperationName"/>
    <xsl:param name="operationURL"/>
    <gmd:identificationInfo>
      <xsl:element name="srv:SV_ServiceIdentification">
        <xsl:attribute name="id">
          <xsl:value-of select="$serviceID"/>
        </xsl:attribute>
        <gmd:citation>
          <gmd:CI_Citation>
            <gmd:title>
              <xsl:choose>
                <xsl:when test="/nc:netcdf/nc:attribute[@name='title']">
                  <xsl:call-template name="writeCharacterString">
                    <xsl:with-param name="testValue" select="$titleCnt"/>
                    <xsl:with-param name="stringToWrite"
                      select="concat(/nc:netcdf/nc:attribute[@name='title']/@value,' ',$serviceTypeName)"
                    />
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="writeCharacterString">
                    <xsl:with-param name="testValue" select="$titleCnt"/>
                    <xsl:with-param name="stringToWrite"
                      select="concat(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='full_name']/@value,' ',$serviceTypeName)"
                    />
                  </xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
            </gmd:title>
            <xsl:choose>
              <xsl:when test="$dateCnt">
                <xsl:if test="/nc:netcdf/nc:attribute[@name='date_created']">
                  <xsl:call-template name="writeDate">
                    <xsl:with-param name="testValue" select="$creatorDateCnt"/>
                    <xsl:with-param name="dateToWrite"
                      select="/nc:netcdf/nc:attribute[@name='date_created']/@value"/>
                    <xsl:with-param name="dateType" select="'creation'"/>
                  </xsl:call-template>
                </xsl:if>
                <xsl:if
                  test="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='dates']/nc:attribute[@type='created']">
                  <xsl:call-template name="writeDate">
                    <xsl:with-param name="testValue" select="$creatorDateCnt"/>
                    <xsl:with-param name="dateToWrite"
                      select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='dates']/nc:attribute[@type='created']/@value"/>
                    <xsl:with-param name="dateType" select="'creation'"/>
                  </xsl:call-template>
                </xsl:if>
                <xsl:if test="/nc:netcdf/nc:attribute[@name='date_issued']">
                  <xsl:call-template name="writeDate">
                    <xsl:with-param name="testValue" select="$issuedDateCnt"/>
                    <xsl:with-param name="dateToWrite"
                      select="/nc:netcdf/nc:attribute[@name='date_issued']/@value"/>
                    <xsl:with-param name="dateType" select="'issued'"/>
                  </xsl:call-template>
                </xsl:if>
                <xsl:if
                  test="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='dates']/nc:attribute[@type='issued']">
                  <xsl:call-template name="writeDate">
                    <xsl:with-param name="testValue" select="$creatorDateCnt"/>
                    <xsl:with-param name="dateToWrite"
                      select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='dates']/nc:attribute[@type='created']/@value"/>
                    <xsl:with-param name="dateType" select="'creation'"/>
                  </xsl:call-template>
                </xsl:if>
                <xsl:if test="/nc:netcdf/nc:attribute[@name='date_modified']">
                  <xsl:call-template name="writeDate">
                    <xsl:with-param name="testValue" select="$modifiedDateCnt"/>
                    <xsl:with-param name="dateToWrite"
                      select="substring(/nc:netcdf/nc:attribute[@name='date_modified']/@value,1,10)"/>
                    <xsl:with-param name="dateType" select="'revision'"/>
                  </xsl:call-template>
                </xsl:if>
                <xsl:if
                  test="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='dates']/nc:attribute[@type='modified']">
                  <xsl:call-template name="writeDate">
                    <xsl:with-param name="testValue" select="$modifiedDateCnt"/>
                    <xsl:with-param name="dateToWrite"
                      select="substring(/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='dates']/nc:attribute[@type='modified']/@value,1,10)"/>
                    <xsl:with-param name="dateType" select="'revision'"/>
                  </xsl:call-template>
                </xsl:if>
              </xsl:when>
              <xsl:otherwise>
                <gmd:date>
                  <xsl:attribute name="gco:nilReason">
                    <xsl:value-of select="'missing'"/>
                  </xsl:attribute>
                </gmd:date>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
              <xsl:when test="$responsiblePartyCnt">
                <xsl:if test="$creatorTotal">
                  <xsl:if test="/nc:netcdf/nc:attribute[@name='creator_name']">
                    <xsl:call-template name="writeResponsibleParty">
                      <xsl:with-param name="tagName" select="'gmd:citedResponsibleParty'"/>
                      <xsl:with-param name="testValue" select="$creatorTotal"/>
                      <xsl:with-param name="individualName"
                        select="/nc:netcdf/nc:attribute[@name='creator_name']/@value"/>
                      <xsl:with-param name="organisationName"
                        select="/nc:netcdf/nc:attribute[@name='institution']/@value"/>
                      <xsl:with-param name="email"
                        select="/nc:netcdf/nc:attribute[@name='creator_email']/@value"/>
                      <xsl:with-param name="url"
                        select="/nc:netcdf/nc:attribute[@name='creator_url']/@value"/>
                      <xsl:with-param name="roleCode" select="'originator'"/>
                    </xsl:call-template>
                  </xsl:if>
                  <xsl:if
                    test="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='creators']/nc:group[@name='creator']/nc:attribute[@name='name']">
                    <xsl:call-template name="writeResponsibleParty">
                      <xsl:with-param name="tagName" select="'gmd:citedResponsibleParty'"/>
                      <xsl:with-param name="testValue" select="$creatorTotal"/>
                      <xsl:with-param name="individualName"
                        select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='creators']/nc:group[@name='creator']/nc:attribute[@name='name']/@value"/>
                      <xsl:with-param name="organisationName"
                        select="/nc:netcdf/nc:attribute[@name='institution']/@value"/>
                      <xsl:with-param name="email"
                        select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='creators']/nc:group[@name='creator']/nc:attribute[@name='email']/@value"/>
                      <xsl:with-param name="url"
                        select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='creators']/nc:group[@name='creator']/nc:attribute[@name='url']/@value"/>
                      <xsl:with-param name="roleCode" select="'originator'"/>
                    </xsl:call-template>
                  </xsl:if>
                </xsl:if>
                <xsl:if test="$contributorTotal">
                  <xsl:if test="/nc:netcdf/nc:attribute[@name='contributor_name']">
                    <xsl:call-template name="writeResponsibleParty">
                      <xsl:with-param name="tagName" select="'gmd:citedResponsibleParty'"/>
                      <xsl:with-param name="testValue" select="$contributorTotal"/>
                      <xsl:with-param name="individualName"
                        select="/nc:netcdf/nc:attribute[@name='contributor_name']/@value"/>
                      <xsl:with-param name="organisationName"/>
                      <xsl:with-param name="email"/>
                      <xsl:with-param name="url"/>
                      <xsl:with-param name="roleCode"
                        select="/nc:netcdf/nc:attribute[@name='contributor_role']/@value"/>
                    </xsl:call-template>
                  </xsl:if>
                  <xsl:for-each
                    select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='contributors']/nc:group[@name='contributor']">
                    <xsl:call-template name="writeResponsibleParty">
                      <xsl:with-param name="tagName" select="'gmd:citedResponsibleParty'"/>
                      <xsl:with-param name="testValue" select="$contributorTotal"/>
                      <xsl:with-param name="individualName"
                        select="nc:attribute[@name='name']/@value"/>
                      <xsl:with-param name="organisationName"/>
                      <xsl:with-param name="email"/>
                      <xsl:with-param name="url"/>
                      <xsl:with-param name="roleCode" select="nc:attribute[@name='role']/@value"/>
                    </xsl:call-template>
                  </xsl:for-each>
                </xsl:if>
              </xsl:when>
              <xsl:otherwise>
                <gmd:citedResponsibleParty>
                  <xsl:attribute name="gco:nilReason">
                    <xsl:value-of select="'missing'"/>
                  </xsl:attribute>
                </gmd:citedResponsibleParty>
              </xsl:otherwise>
            </xsl:choose>
          </gmd:CI_Citation>
        </gmd:citation>
        <gmd:abstract>
          <xsl:choose>
            <xsl:when test="count(/nc:netcdf/nc:attribute[@name='summary']) > 0">
              <xsl:call-template name="writeCharacterString">
                <xsl:with-param name="testValue" select="$summaryCnt"/>
                <xsl:with-param name="stringToWrite"
                  select="/nc:netcdf/nc:attribute[@name='summary']/@value"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="writeCharacterString">
                <xsl:with-param name="testValue" select="$summaryCnt"/>
                <xsl:with-param name="stringToWrite"
                  select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:group[@name='documentation']/nc:group[@name='document']/nc:attribute[@type='summary']/@value"
                />
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </gmd:abstract>
        <srv:serviceType>
          <gco:LocalName>
            <xsl:value-of select="$serviceTypeName"/>
          </gco:LocalName>
        </srv:serviceType>
        <srv:extent>
          <xsl:choose>
            <xsl:when test="$extentTotal">
              <gmd:EX_Extent>
                <xsl:if test="$geospatial_lat_minCnt > 0">
                  <gmd:geographicElement>
                    <gmd:EX_GeographicBoundingBox>
                      <gmd:extentTypeCode>
                        <gco:Boolean>1</gco:Boolean>
                      </gmd:extentTypeCode>
                      <gmd:westBoundLongitude>
                        <gco:Decimal>
                          <xsl:choose>
                            <xsl:when
                              test="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lon_min']">
                              <xsl:value-of
                                select="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lon_min']/@value"
                              />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:if
                                test="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lon_min']">
                                <xsl:value-of
                                  select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lon_min']/@value"
                                />
                              </xsl:if>
                            </xsl:otherwise>
                          </xsl:choose>
                        </gco:Decimal>
                      </gmd:westBoundLongitude>
                      <gmd:eastBoundLongitude>
                        <gco:Decimal>
                          <xsl:choose>
                            <xsl:when
                              test="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lon_max']">
                              <xsl:value-of
                                select="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lon_max']/@value"
                              />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of
                                select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lon_max']/@value"
                              />
                            </xsl:otherwise>
                          </xsl:choose>
                        </gco:Decimal>
                      </gmd:eastBoundLongitude>
                      <gmd:southBoundLatitude>
                        <gco:Decimal>
                          <xsl:choose>
                            <xsl:when
                              test="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lat_min']">
                              <xsl:value-of
                                select="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lat_min']/@value"
                              />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of
                                select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lat_min']/@value"
                              />
                            </xsl:otherwise>
                          </xsl:choose>
                        </gco:Decimal>
                      </gmd:southBoundLatitude>
                      <gmd:northBoundLatitude>
                        <gco:Decimal>
                          <xsl:choose>
                            <xsl:when
                              test="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lat_max']">
                              <xsl:value-of
                                select="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_lat_max']/@value"
                              />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of
                                select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_lat_max']/@value"
                              />
                            </xsl:otherwise>
                          </xsl:choose>
                        </gco:Decimal>
                      </gmd:northBoundLatitude>
                    </gmd:EX_GeographicBoundingBox>
                  </gmd:geographicElement>
                </xsl:if>
                <xsl:if test="$timeStartCnt > 0">
                  <gmd:temporalElement>
                    <gmd:EX_TemporalExtent>
                      <gmd:extent>
                        <gml:TimePeriod>
                          <xsl:attribute name="gml:id">
                            <xsl:value-of select="concat($serviceID,'_time_period')"/>
                          </xsl:attribute>
                          <gml:beginPosition>
                            <xsl:choose>
                              <xsl:when
                                test="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='time_coverage_start']">
                                <xsl:value-of
                                  select="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='time_coverage_start']/@value"
                                />
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of
                                  select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='time_coverage_start']/@value"
                                />
                              </xsl:otherwise>
                            </xsl:choose>
                          </gml:beginPosition>
                          <gml:endPosition>
                            <xsl:choose>
                              <xsl:when
                                test="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='time_coverage_end']">
                                <xsl:value-of
                                  select="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='time_coverage_end']/@value"
                                />
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of
                                  select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='time_coverage_end']/@value"
                                />
                              </xsl:otherwise>
                            </xsl:choose>
                          </gml:endPosition>
                        </gml:TimePeriod>
                      </gmd:extent>

                    </gmd:EX_TemporalExtent>
                  </gmd:temporalElement>
                </xsl:if>
                <xsl:if test="$vertical_minCnt > 0">
                  <gmd:verticalElement>
                    <gmd:EX_VerticalExtent>
                      <gmd:minimumValue>
                        <gco:Real>
                          <xsl:choose>
                            <xsl:when
                              test="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_positive']">
                              <xsl:choose>
                                <xsl:when
                                  test="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_positive']/@value = 'down'">
                                  <xsl:value-of
                                    select="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_min']/@value * -1"
                                  />
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:value-of
                                    select="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_min']/@value"
                                  />
                                </xsl:otherwise>
                              </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:choose>
                                <xsl:when
                                  test="/nc:netcdf/nc:group[@name='THREDDSMetadata']//nc:attribute[@name='geospatial_vertical_positive']/@value = 'down'">
                                  <xsl:value-of
                                    select="/nc:netcdf/nc:group[@name='THREDDSMetadata']//nc:attribute[@name='geospatial_vertical_min']/@value * -1"
                                  />
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:value-of
                                    select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_vertical_min']/@value"
                                  />
                                </xsl:otherwise>
                              </xsl:choose>
                            </xsl:otherwise>
                          </xsl:choose>
                        </gco:Real>
                      </gmd:minimumValue>
                      <gmd:maximumValue>
                        <gco:Real>
                          <xsl:choose>
                            <xsl:when
                              test="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_positive']">
                              <xsl:choose>
                                <xsl:when
                                  test="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_positive']/@value = 'down'">
                                  <xsl:value-of
                                    select="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_max']/@value * -1"
                                  />
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:value-of
                                    select="/nc:netcdf/nc:group[@name='CFMetadata']/nc:attribute[@name='geospatial_vertical_max']/@value"
                                  />
                                </xsl:otherwise>
                              </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:choose>
                                <xsl:when
                                  test="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_vertical_positive']/@value = 'down'">
                                  <xsl:value-of
                                    select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_vertical_max']/@value * -1"
                                  />
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:value-of
                                    select="/nc:netcdf/nc:group[@name='THREDDSMetadata']/nc:attribute[@name='geospatial_vertical_max']/@value"
                                  />
                                </xsl:otherwise>
                              </xsl:choose>
                            </xsl:otherwise>
                          </xsl:choose>
                        </gco:Real>
                      </gmd:maximumValue>
                      <gmd:verticalCRS>
                        <xsl:attribute name="gco:nilReason">
                          <xsl:value-of select="'missing'"/>
                        </xsl:attribute>
                      </gmd:verticalCRS>
                    </gmd:EX_VerticalExtent>
                  </gmd:verticalElement>
                </xsl:if>
              </gmd:EX_Extent>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="gco:nilReason">
                <xsl:value-of select="'missing'"/>
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
        </srv:extent>
        <srv:couplingType>
          <srv:SV_CouplingType
            codeList="http://www.tc211.org/ISO19139/resources/codeList.xml#SV_CouplingType"
            codeListValue="tight">tight</srv:SV_CouplingType>
        </srv:couplingType>
        <srv:containsOperations>
          <srv:SV_OperationMetadata>
            <srv:operationName>
              <gco:CharacterString>
                <xsl:value-of select="$serviceOperationName"/>
              </gco:CharacterString>
            </srv:operationName>
            <srv:DCP gco:nilReason="unknown"/>
            <srv:connectPoint>
              <gmd:CI_OnlineResource>
                <gmd:linkage>
                  <gmd:URL>
                    <xsl:value-of select="$operationURL"/>
                  </gmd:URL>
                </gmd:linkage>
                <gmd:name>
                  <gco:CharacterString>
                    <xsl:value-of select="$serviceID"/>
                  </gco:CharacterString>
                </gmd:name>
                <gmd:description>
                  <gco:CharacterString>
                    <xsl:value-of select="$serviceTypeName"/>
                  </gco:CharacterString>
                </gmd:description>
                <gmd:function>
                  <gmd:CI_OnLineFunctionCode
                    codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_OnLineFunctionCode"
                    codeListValue="download">download</gmd:CI_OnLineFunctionCode>
                </gmd:function>
              </gmd:CI_OnlineResource>
            </srv:connectPoint>
          </srv:SV_OperationMetadata>
        </srv:containsOperations>
        <srv:operatesOn xlink:href="#DataIdentification"/>
      </xsl:element>
    </gmd:identificationInfo>
  </xsl:template>
</xsl:stylesheet>
