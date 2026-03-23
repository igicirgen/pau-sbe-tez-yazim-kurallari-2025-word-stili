<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt"	xmlns:b="http://schemas.openxmlformats.org/officeDocument/2006/bibliography" xmlns:t="http://www.microsoft.com/temp">
  <xsl:output method="html" encoding="us-ascii"/>

  <xsl:template match="*" mode="outputHtml2">
      <xsl:apply-templates mode="outputHtml"/>
  </xsl:template>

  <xsl:template name="StringFormatDot">
    <xsl:param name="format" />
    <xsl:param name="parameters" />

    <xsl:variable name="prop_EndChars">
      <xsl:call-template name="templ_prop_EndChars"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$format = ''"></xsl:when>
      <xsl:when test="substring($format, 1, 2) = '%%'">
        <xsl:text>%</xsl:text>
        <xsl:call-template name="StringFormatDot">
          <xsl:with-param name="format" select="substring($format, 3)" />
          <xsl:with-param name="parameters" select="$parameters" />
        </xsl:call-template>
        <xsl:if test="string-length($format)=2">
          <xsl:call-template name="templ_prop_Dot"/>
        </xsl:if>
      </xsl:when>
      <xsl:when test="substring($format, 1, 1) = '%'">
        <xsl:variable name="pos" select="substring($format, 2, 1)" />
        <xsl:apply-templates select="msxsl:node-set($parameters)/t:params/t:param[position() = $pos]" mode="outputHtml2"/>
        <xsl:call-template name="StringFormatDot">
          <xsl:with-param name="format" select="substring($format, 3)" />
          <xsl:with-param name="parameters" select="$parameters" />
        </xsl:call-template>
        <xsl:if test="string-length($format)=2">
          <xsl:variable name="temp2">
            <xsl:call-template name="handleSpaces">
              <xsl:with-param name="field" select="msxsl:node-set($parameters)/t:params/t:param[position() = $pos]"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="lastChar">
            <xsl:value-of select="substring($temp2, string-length($temp2))"/>
          </xsl:variable>

          <xsl:if test="not(contains($prop_EndChars, $lastChar))">
            <xsl:call-template name="templ_prop_Dot"/>
          </xsl:if>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring($format, 1, 1)" />
        <xsl:call-template name="StringFormatDot">
          <xsl:with-param name="format" select="substring($format, 2)" />
          <xsl:with-param name="parameters" select="$parameters" />
        </xsl:call-template>
        <xsl:if test="string-length($format)=1">
          <xsl:if test="not(contains($prop_EndChars, $format))">
            <xsl:call-template name="templ_prop_Dot"/>
          </xsl:if>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="StringFormat">
    <xsl:param name="format" />
    <xsl:param name="parameters" />
    <xsl:choose>
      <xsl:when test="$format = ''"></xsl:when>
      <xsl:when test="substring($format, 1, 2) = '%%'">
        <xsl:text>%</xsl:text>
        <xsl:call-template name="StringFormat">
          <xsl:with-param name="format" select="substring($format, 3)" />
          <xsl:with-param name="parameters" select="$parameters" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="substring($format, 1, 1) = '%'">
        <xsl:variable name="pos" select="substring($format, 2, 1)" />
        <xsl:apply-templates select="msxsl:node-set($parameters)/t:params/t:param[position() = $pos]" mode="outputHtml2"/>
        <xsl:call-template name="StringFormat">
          <xsl:with-param name="format" select="substring($format, 3)" />
          <xsl:with-param name="parameters" select="$parameters" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring($format, 1, 1)" />
        <xsl:call-template name="StringFormat">
          <xsl:with-param name="format" select="substring($format, 2)" />
          <xsl:with-param name="parameters" select="$parameters" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="localLCID">
    <xsl:param name="LCID"/>

    <xsl:variable name="_LCID1">
      <xsl:choose>
        <xsl:when test="$LCID!='0' and $LCID!=''">
          <xsl:value-of select="$LCID"/>
        </xsl:when>
        <xsl:when test="/b:Citation">
          <xsl:value-of select="/*/b:Locals/b:DefaultLCID"/>
        </xsl:when>
        <xsl:when test="b:LCID">
          <xsl:value-of select="b:LCID"/>
        </xsl:when>
        <xsl:when test="../b:LCID">
          <xsl:value-of select="../b:LCID"/>
        </xsl:when>
        <xsl:when test="../../b:LCID">
          <xsl:value-of select="../../b:LCID"/>
        </xsl:when>
        <xsl:when test="../../../b:LCID">
          <xsl:value-of select="../../../b:LCID"/>
        </xsl:when>
        <xsl:when test="../../../../b:LCID">
          <xsl:value-of select="../../../../b:LCID"/>
        </xsl:when>
        <xsl:when test="../../../../b:LCID">
          <xsl:value-of select="../../../../b:LCID"/>
        </xsl:when>
        <xsl:when test="../../../../../b:LCID">
          <xsl:value-of select="../../../../../b:LCID"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="/*/b:Locals/b:DefaultLCID"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$_LCID1!='0' and string-length($_LCID1)>0">
        <xsl:value-of select="$_LCID1"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/*/b:Locals/b:DefaultLCID"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="templ_prop_APA_CitationLong_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%L %f.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_CitationLong_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%L %f.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_CitationLong_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%L %m.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_CitationLong_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%L %f.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_CitationShort_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%L</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_CitationShort_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%L</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_CitationShort_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%L</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_CitationShort_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%L</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_OnlineCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Çevrimiçi</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_OnlineUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>çevrimiçi</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_FiledCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Dosyalandı</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_PatentFiledCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Patent Dosyalandı</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_InCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>İçinde</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_OnAlbumTitleCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%1 albümünde</xsl:text>
  </xsl:template>


  
  <xsl:template name="templ_str_InNameCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%1 İçinde</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_WithUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>ile</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_VersionShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Sürüm</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_InterviewCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Röportaj</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_InterviewWithCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Röportaj yapılan</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_InterviewByCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Röportajı yapan</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_ByCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Tarafından</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_AndUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>ve</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_AndOthersUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>vd.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_MotionPictureCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Sinema Filmi</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_PatentCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Patent</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_EditionShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%1 bs.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_EditionUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%1. Baskı</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_RetrievedFromCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%1 tarihinde %2 adresinden erişildi</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_RetrievedCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%1 tarihinde erişildi</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_FromCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <!-- "retrieved from" should be omitted if there is no date -->
    <xsl:text>%1</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_FromUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>adresinden</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_NoDateShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>t.y.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_NumberShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>No.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_NumberShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>no.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_PatentNumberShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Patent No. %1</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_PagesCountinousShort" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text></xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_PageShort" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text></xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_SineNomineShort" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>y.y.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_SineLocoShort" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>y.y.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_SineLocoSineNomineShort" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>y.y.: y.y.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_VolumeOfShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Cilt</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_VolumesOfShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Ciltler</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_VolumeShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Cilt: %1</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_VolumeShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>cilt: %1</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_VolumesShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>ciltler: %1</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_VolumesShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Ciltler: %1</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_VolumeCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Cilt</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_AuthorShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>yazar</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_BookAuthorShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>kitap yazarı</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_ArtistShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>sanatçı</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_WriterCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Yazar</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_WritersCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Yazarlar</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_WriterShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>yazar</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_ConductedByCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Yöneten</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_ConductedByUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>yöneten</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_ConductorCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Orkestra Şefi</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_ConductorsCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Orkestra Şefleri</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_ConductorShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Şef</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_ConductorShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>şef</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_ConductorsShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Şefler</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_ConductorsShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>şefler</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_CounselShortUnCapIso" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>danışman</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_CounselShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>danışman</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_DirectedByCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Yönetmen</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_DirectedByUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>yönetmen</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_DirectorCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Yönetmen</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_DirectorsCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Yönetmenler</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_DirectorShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Ynt.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_DirectorShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>ynt.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_DirectorsShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Ynt.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_DirectorsShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>ynt.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_EditedByCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Editör</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_EditedByUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>editör</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_EditorCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Editör</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_EditorsCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Editörler</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_EditorShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Ed.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_EditorShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>ed.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_EditorsShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Ed.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_EditorsShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>ed.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_IntervieweeShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>görüşülen</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_InterviewerCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Görüşmeci</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_InterviewersCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Görüşmeciler</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_InventorShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>mucit</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_PerformedByCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Sergileyen</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_PerformedByUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>sergileyen</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_PerformerCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Sanatçı</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_PerformersCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Sanatçılar</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_PerformerShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Snt.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_PerformerShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>snt.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_PerformersShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Snt.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_PerformersShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>snt.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_ProducedByCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Yapımcı</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_ProducedByUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>yapımcı</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_ProducerCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Yapımcı</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_ProducersCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Yapımcılar</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_ProductionCompanyShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Yapım Şirketi</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_ProducerShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Ypm.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_ProducersShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Ypm.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_ProducerShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>ypm.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_RecordedByCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Kaydeden</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_TranslatedByCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Çeviren</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_TranslatedByUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>çeviren</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_TranslatorCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Çevirmen</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_TranslatorsCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Çevirmenler</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_TranslatorShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Çev.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_TranslatorShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>çev.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_TranslatorsShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Çev.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_TranslatorsShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>çev.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_ComposerCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Besteci</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_ComposersCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Besteciler</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_ComposerShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Bes.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_ComposersShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Bes.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_ComposerShortUnCapIso" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>bes.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_CompiledByCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Derleyen</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_CompiledByUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>derleyen</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_CompilerCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Derleyici</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_CompilersCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Derleyiciler</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_CompilerShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Der.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_CompilerShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>der.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_CompilersShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>Der.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_CompilersShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>der.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_str_CompilerShortUnCapIso" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>der.</xsl:text>
  </xsl:template>


  

  
  <xsl:template name="templ_prop_Culture" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>tr-TR</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_Direction" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>ltr</xsl:text>
  </xsl:template>


  

  
  <xsl:template name="templ_prop_NoItalics" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>no</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_TitleOpen" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text></xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_TitleClose" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text></xsl:text>
  </xsl:template>  

  
  <xsl:template name="templ_prop_EndChars" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>.,;?!</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_NormalizeSpace" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>no</xsl:text>
    
  </xsl:template>

  
  <xsl:template name="templ_prop_Space" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>&#32;</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_NonBreakingSpace" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>&#160;</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_ListSeparator" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>, </xsl:text>
  </xsl:template>

  <xsl:template name="formatMediumInBrackets">
    <xsl:if test="string-length(b:Medium) > 0">
      <xsl:call-template name="templ_prop_Space"/>
      <xsl:call-template name="templ_prop_APA_SecondaryOpen"/>
      <xsl:value-of select="b:Medium"/>
      <xsl:call-template name="templ_prop_APA_SecondaryClose"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="templ_prop_Dot" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_DotInitial" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_GroupSeparator" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>, </xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_EnumSeparator" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>, </xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_Equal" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>=</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_Enum" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>, </xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_OpenQuote" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>“</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_CloseQuote" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>”</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_OpenBracket" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>(</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_CloseBracket" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>)</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_FromToDash" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>-</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_OpenLink" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>&lt;</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_CloseLink" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>&gt;</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_AuthorsSeparator" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>, </xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_NoAndBeforeLastAuthor" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>yes</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_NoCommaBeforeAnd" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>yes</xsl:text>
  </xsl:template>

  <xsl:template name="templ_prop_SimpleAuthor_F" >
  <xsl:text>%F</xsl:text>
  
  </xsl:template>

  
  <xsl:template name="templ_prop_SimpleAuthor_M" >
  <xsl:text>%M</xsl:text>
  
  </xsl:template>

  
  <xsl:template name="templ_prop_SimpleAuthor_L" >
  <xsl:text>%L</xsl:text>
  
  </xsl:template>

  
  <xsl:template name="templ_prop_SimpleDate_D" >
  <xsl:text>%D</xsl:text>
  
  </xsl:template>

  
  <xsl:template name="templ_prop_SimpleDate_M" >
  <xsl:text>%M</xsl:text>
  
  </xsl:template>

  
  <xsl:template name="templ_prop_SimpleDate_Y" >
  <xsl:text>%Y</xsl:text>
  
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_MainAuthors_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%L %f.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_MainAuthors_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%L %f.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_MainAuthors_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%L %m.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_MainAuthors_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%L %f.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_SecondaryAuthors_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%L %f.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_SecondaryAuthors_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%L %f.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_SecondaryAuthors_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%L %m.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_SecondaryAuthors_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%L %f.</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_BeforeLastAuthor" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>ve</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_GeneralOpen" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>(</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_GeneralClose" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>)</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_SecondaryOpen" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>[</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_SecondaryClose" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>]</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_Hyphens" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>-</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_Date_DMY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%Y, %M %D</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_Date_DM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%M %D</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_Date_MY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%Y, %M</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_Date_DY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%Y, %D</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_DateAccessed_DMY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%D.%M.%Y</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_DateAccessed_DM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%D.%M</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_DateAccessed_MY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%M.%Y</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_DateAccessed_DY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%D.%Y</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_DateCourt_DMY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%D.%M.%Y</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_DateCourt_DM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%D.%M</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_DateCourt_MY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%M.%Y</xsl:text>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_DateCourt_DY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>%D.%Y</xsl:text>
  </xsl:template>

  <!-- Template for formatting a string as a functional hyperlink -->
  <xsl:template name="formatHyperlink">
    <xsl:param name="url"/>
    <a href="{$url}" target="_blank">
      <xsl:value-of select="$url"/>
    </a>
  </xsl:template>

  <xsl:template name="findAndFormatHyperlink">
    <xsl:param name="original"/>
    <xsl:param name="url"/>
    <xsl:choose>
      <xsl:when test="contains($original,$url)">
        <xsl:value-of select="substring-before($original,$url)"/>
        <xsl:call-template name="formatHyperlink">
          <xsl:with-param name="url" select="$url"/>
        </xsl:call-template>
        <xsl:value-of select="substring-after($original,$url)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$original"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="/">

    <xsl:choose>

      <xsl:when test="b:Version">
        <xsl:text>2025</xsl:text>
      </xsl:when>

      <xsl:when test="b:OfficeStyleKey">
        <xsl:text>PAU</xsl:text>
      </xsl:when>

      <xsl:when test="b:XslVersion">
        <xsl:text>2025</xsl:text>
      </xsl:when>

      <xsl:when test="b:StyleNameLocalized">
        <xsl:text>PAÜ SBE Tez Yazım Kuralları</xsl:text>
      </xsl:when>

      <xsl:when test="b:GetImportantFields">
        <b:ImportantFields>
          <xsl:choose>
            <xsl:when test="b:GetImportantFields/b:SourceType='Book'">
              <b:ImportantField><xsl:text>b:Author/b:Author/b:NameList</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Publisher</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:City</xsl:text></b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='BookSection'">
              <b:ImportantField><xsl:text>b:Author/b:Author/b:NameList</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Author/b:BookAuthor/b:NameList</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:BookTitle</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Pages</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Editor</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Publisher</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:City</xsl:text></b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='JournalArticle'">
              <b:ImportantField><xsl:text>b:Author/b:Author/b:NameList</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:JournalName</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Pages</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Volume</xsl:text></b:ImportantField>              
              <b:ImportantField><xsl:text>b:Issue</xsl:text></b:ImportantField>              
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='ArticleInAPeriodical'">
              <b:ImportantField><xsl:text>b:Author/b:Author/b:NameList</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:PeriodicalTitle</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Month</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Day</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Pages</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:URL</xsl:text></b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='ConferenceProceedings'">
              <b:ImportantField><xsl:text>b:Author/b:Author/b:NameList</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
      	      <b:ImportantField><xsl:text>b:ConferenceName</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
	            <b:ImportantField><xsl:text>b:Month</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Day</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:City</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Publisher</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:URL</xsl:text></b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='Report'">
              <b:ImportantField><xsl:text>b:Author/b:Author/b:NameList</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:ThesisType</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Institution</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Department</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Publisher</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:City</xsl:text></b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='SoundRecording'">
              <b:ImportantField><xsl:text>b:Author/b:Composer/b:NameList</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Author/b:Performer/b:NameList</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:City</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:CountryRegion</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:StateProvince</xsl:text></b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='Performance'">
              <b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Author/b:Writer/b:NameList</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Author/b:Performer/b:NameList</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Theater</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:City</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:CountryRegion</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:StateProvince</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Month</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Day</xsl:text></b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='Art'">
              <b:ImportantField><xsl:text>b:Author/b:Artist/b:NameList</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Institution</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:PublicationTitle</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:City</xsl:text></b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='DocumentFromInternetSite'">
              <b:ImportantField><xsl:text>b:Author/b:Author/b:NameList</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:InternetSiteTitle</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:URL</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:YearAccessed</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:MonthAccessed</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:DayAccessed</xsl:text></b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='InternetSite'">
              <b:ImportantField><xsl:text>b:Author/b:Author/b:NameList</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:InternetSiteTitle</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:URL</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:YearAccessed</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:MonthAccessed</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:DayAccessed</xsl:text></b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='Film'">
              <b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Author/b:Director/b:NameList</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='Interview'">
              <b:ImportantField><xsl:text>b:Author/b:Interviewee/b:NameList</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Author/b:Interviewer/b:NameList</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Month</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Day</xsl:text></b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='Patent'">
              <b:ImportantField><xsl:text>b:Author/b:Inventor/b:NameList</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:CountryRegion</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:PatentNumber</xsl:text></b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='ElectronicSource'">
              <b:ImportantField><xsl:text>b:Author/b:Author/b:NameList</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:URL</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:YearAccessed</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:MonthAccessed</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:DayAccessed</xsl:text></b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='Case'">
              <b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:CaseNumber</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Court</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Month</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Day</xsl:text></b:ImportantField>
            </xsl:when>

            <xsl:when test="b:GetImportantFields/b:SourceType='Misc'">
              <b:ImportantField><xsl:text>b:Author/b:Author/b:NameList</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:PublicationTitle</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Month</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Day</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:City</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:CountryRegion</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:StateProvince</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Publisher</xsl:text></b:ImportantField>
            </xsl:when>

            <xsl:otherwise>
              <!-- Varsayılan Alanlar -->
              <b:ImportantField><xsl:text>b:Author/b:Author/b:NameList</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
              <b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
            </xsl:otherwise>

          </xsl:choose>
        </b:ImportantFields>
      </xsl:when>


			<xsl:when test="b:Citation">

				<xsl:variable name="ListPopulatedWithMain">
						<xsl:call-template name="populateMain">
							<xsl:with-param name="Type">b:Citation</xsl:with-param>
						</xsl:call-template>
				</xsl:variable>

				<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:w="urn:schemas-microsoft-com:office:word" xmlns="http://www.w3.org/TR/REC-html40">
					<head>
					</head>
					<body>
						<xsl:variable name="LCID">
							<xsl:choose>
								<xsl:when test="b:LCID='0' or b:LCID='' or not(b:LCID)">
									<xsl:value-of select="/*/b:Locals/b:DefaultLCID"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="b:LCID"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<xsl:element name="p">

						<xsl:attribute name="lang">
							<xsl:value-of select="/*/b:Locals/b:Local[@LCID=$LCID]/@Culture"/>
						</xsl:attribute>

						<xsl:attribute name="dir">
							<xsl:value-of select="/*/b:Locals/b:Local[@LCID=$LCID]/b:Properties/b:Direction"/>
						</xsl:attribute>

						<xsl:variable name="type">
							<xsl:value-of select="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Source/b:SourceType"/>
						</xsl:variable>

						<xsl:variable name="title0">
							<xsl:choose>
								<xsl:when test="string-length(msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Source/b:ShortTitle)>0">
									<xsl:value-of select="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Source/b:ShortTitle" />
								</xsl:when>

								<xsl:otherwise>
									<xsl:value-of select="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Source/b:Title" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<xsl:variable name="year0">
							<xsl:value-of select="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Source/b:Year" />
						</xsl:variable>

						<xsl:variable name="authorMain">
							<xsl:copy-of select="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Source/b:Author/b:Main"/>
						</xsl:variable>

						<xsl:variable name="patentNumber">
							<xsl:value-of select="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Source/b:PatentNumber"/>
						</xsl:variable>

						<xsl:variable name="countryRegion">
							<xsl:value-of select="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Source/b:CountryRegion"/>
						</xsl:variable>

						<xsl:variable name="patent">
							<xsl:if test="string-length($patentNumber)>0">
								<xsl:if test="string-length($countryRegion) > 0">
									<xsl:value-of select="$countryRegion"/>
									<xsl:call-template name="templ_prop_Space"/>
								</xsl:if>

								<xsl:variable name="str_PatentNumberShortCap">
									<xsl:call-template name="templ_str_PatentNumberShortCap"/>
								</xsl:variable>

								<xsl:call-template name="StringFormat">
									<xsl:with-param name="format" select="$str_PatentNumberShortCap"/>
									<xsl:with-param name="parameters">
										<t:params>
											<t:param>
												<xsl:value-of select="$patentNumber"/>
											</t:param>
										</t:params>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
						</xsl:variable>

						<xsl:variable name="maxCitationAuthors" select="2"/>

						<xsl:variable name="author0">
							<xsl:choose>
								<xsl:when test="string-length(msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Source/b:Author/b:Main/b:Corporate) > 0">
									<xsl:value-of select="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Source/b:Author/b:Main/b:Corporate" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="cAuthors">
										<xsl:value-of select="count(msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Source/b:Author/b:Main/b:NameList/b:Person)" />
									</xsl:variable>

									<xsl:for-each select="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Source/b:Author/b:Main/b:NameList/b:Person">
										<xsl:if test="position() = 1">
											<xsl:call-template name="formatNameCore">
												<xsl:with-param name="FML">
													<xsl:choose>
														<xsl:when test="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:NonUniqueLastName">
															<xsl:call-template name="templ_prop_APA_CitationLong_FML"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:call-template name="templ_prop_APA_CitationShort_FML"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:with-param>
												<xsl:with-param name="FM">
													<xsl:choose>
														<xsl:when test="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:NonUniqueLastName">
															<xsl:call-template name="templ_prop_APA_CitationLong_FM"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:call-template name="templ_prop_APA_CitationShort_FM"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:with-param>
												<xsl:with-param name="ML">
													<xsl:choose>
														<xsl:when test="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:NonUniqueLastName">
															<xsl:call-template name="templ_prop_APA_CitationLong_ML"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:call-template name="templ_prop_APA_CitationShort_ML"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:with-param>
												<xsl:with-param name="FL">
													<xsl:choose>
														<xsl:when test="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:NonUniqueLastName">
															<xsl:call-template name="templ_prop_APA_CitationLong_FL"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:call-template name="templ_prop_APA_CitationShort_FL"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:with-param>
												<xsl:with-param name="upperLast">no</xsl:with-param>
												<xsl:with-param name="withDot">no</xsl:with-param>
											</xsl:call-template>
										</xsl:if>

										<xsl:if test="position() > 1 and $cAuthors &lt;= $maxCitationAuthors">
											<xsl:call-template name="formatNameCore">
												<xsl:with-param name="FML"><xsl:call-template name="templ_prop_APA_CitationShort_FML"/></xsl:with-param>
												<xsl:with-param name="FM"><xsl:call-template name="templ_prop_APA_CitationShort_FM"/></xsl:with-param>
												<xsl:with-param name="ML"><xsl:call-template name="templ_prop_APA_CitationShort_ML"/></xsl:with-param>
												<xsl:with-param name="FL"><xsl:call-template name="templ_prop_APA_CitationShort_FL"/></xsl:with-param>
												<xsl:with-param name="upperLast">no</xsl:with-param>
												<xsl:with-param name="withDot">no</xsl:with-param>
											</xsl:call-template>
										</xsl:if>

										<xsl:if test="$cAuthors > $maxCitationAuthors">
											<xsl:if test="position() = 1">
												<xsl:variable name="noCommaBeforeAnd">
													<xsl:call-template name="templ_prop_NoCommaBeforeAnd" />
												</xsl:variable>

												<xsl:choose>
													<xsl:when test="$noCommaBeforeAnd != 'yes'">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:otherwise>
												</xsl:choose>

												<xsl:call-template name="templ_str_AndOthersUnCap"/>
											</xsl:if>
										</xsl:if>

										<xsl:if test="$cAuthors &lt;= $maxCitationAuthors">
											<xsl:if test="position() = $cAuthors - 1">
												<xsl:if test="$cAuthors = 2">
													<xsl:call-template name="templ_prop_Space"/>
													<xsl:call-template name="templ_prop_APA_BeforeLastAuthor"/>
													<xsl:call-template name="templ_prop_Space"/>
												</xsl:if>

												<xsl:if test="$cAuthors > 2">
													<xsl:variable name="noCommaBeforeAnd">
														<xsl:call-template name="templ_prop_NoCommaBeforeAnd" />
													</xsl:variable>

													<xsl:variable name="noAndBeforeLastAuthor">
														<xsl:call-template name="templ_prop_NoAndBeforeLastAuthor"/>
													</xsl:variable>

													<xsl:choose>
														<xsl:when test="$noCommaBeforeAnd != 'yes' or $noAndBeforeLastAuthor = 'yes'">
															<xsl:call-template name="templ_prop_AuthorsSeparator"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:call-template name="templ_prop_Space"/>
														</xsl:otherwise>
													</xsl:choose>

													<xsl:if test="$noAndBeforeLastAuthor != 'yes'">
														<xsl:call-template name="templ_prop_APA_BeforeLastAuthor"/>
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>
												</xsl:if>
											</xsl:if>

											
										</xsl:if>
									</xsl:for-each>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<xsl:variable name="title">
							<xsl:choose>
								<xsl:when test="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:NoTitle">
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$title0" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<xsl:variable name="year">
							<xsl:choose>
								<xsl:when test="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:NoYear">
								</xsl:when>

								<xsl:when test="$type='InternetSite'">
									<xsl:if test="string-length($year0) > 0">
										<xsl:value-of select="$year0" />
									</xsl:if>
									<xsl:if test="string-length($year0) = 0">
										<xsl:call-template name="templ_str_NoDateShortUnCap"/>
									</xsl:if>
								</xsl:when>

								<xsl:otherwise>
									<xsl:value-of select="$year0" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<xsl:variable name="author">
							<xsl:choose>
								<xsl:when test="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:NoAuthor">
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$author0" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<xsl:variable name="prop_APA_Hyphens">
							<xsl:call-template name="templ_prop_Hyphens"/>
						</xsl:variable>

						<xsl:variable name="volume" select="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Volume"/>

						<xsl:variable name="volVolume">
							<xsl:if test="string-length($volume) > 0">
								<xsl:call-template name="StringFormat">
									<xsl:with-param name="format">
										<xsl:choose>
											<xsl:when test="not(string-length($volume)=string-length(translate($volume, ',', '')))">
												<xsl:call-template name="templ_str_VolumesShortUnCap"/>
											</xsl:when>
											<xsl:when test="string-length($volume)=string-length(translate($volume, $prop_APA_Hyphens, ''))">
												<xsl:call-template name="templ_str_VolumeShortUnCap"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="templ_str_VolumesShortUnCap"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:with-param>
									<xsl:with-param name="parameters">
										<t:params>
											<t:param>
												<xsl:value-of select="$volume"/>
											</t:param>
										</t:params>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
						</xsl:variable>

						<xsl:variable name="pages" select="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Pages"/>

						<xsl:variable name="ppPages">
							<xsl:if test="string-length($pages)>0">
								<xsl:choose>
									<xsl:when test="0!=string-length(translate($pages, concat(',0123456789 ', $prop_APA_Hyphens), ''))"/>
									<xsl:when test="not(string-length($pages)=string-length(translate($pages, ',', '')))">
										<xsl:call-template name="templ_str_PagesCountinousShort"/>
									</xsl:when>
									<xsl:when test="string-length($pages)=string-length(translate($pages, $prop_APA_Hyphens, ''))">
										<xsl:call-template name="templ_str_PageShort"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="templ_str_PagesCountinousShort"/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:call-template name="templ_prop_Space"/>
								<xsl:value-of select="$pages"/>
							</xsl:if>
						</xsl:variable>

						<xsl:variable name="displayAuthor">
							<xsl:choose>
								<xsl:when test="$type='Patent' and string-length($patent) > 0">
									<xsl:value-of select="$patent" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$author" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<xsl:variable name="displayTitle">
							<xsl:choose>
								<xsl:when test="string-length($displayAuthor) = 0">
									<xsl:value-of select="$title" />
								</xsl:when>
								<xsl:when test="$type='Patent' and string-length($patent) > 0">
								</xsl:when>
								<xsl:when test="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:RepeatedAuthor">
									<xsl:value-of select="$title" />
								</xsl:when>
							</xsl:choose>
						</xsl:variable>

						<xsl:if test="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:FirstAuthor">
							<xsl:call-template name="templ_prop_OpenBracket"/>
						</xsl:if>

						<xsl:if test="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:PagePrefix">
							<xsl:value-of select="/b:Citation/b:PagePrefix"/>
						</xsl:if>

						<xsl:value-of select="$displayAuthor" />

						<xsl:if test="string-length($displayTitle) > 0">
							<xsl:if test="string-length($displayAuthor) > 0">
								<xsl:call-template name="templ_prop_ListSeparator"/>
							</xsl:if>
							<xsl:if test="string-length($displayTitle)>0">
								<xsl:value-of select="$displayTitle"/>
							</xsl:if>
						</xsl:if>

						<xsl:if test="string-length($year) > 0">
							<xsl:if test="string-length($author0) > 0 or string-length($title0) > 0 or string-length($year0) > 0">
								<xsl:if test="string-length($displayAuthor) > 0 or string-length($displayTitle) > 0">
									<xsl:call-template name="templ_prop_ListSeparator"/>
								</xsl:if>
								<xsl:value-of select="$year"/>
							</xsl:if>
						</xsl:if>

						<xsl:if test="string-length($author0) = 0 and string-length($title0) = 0 and string-length($year0) = 0">
							<xsl:value-of select="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Source/b:Tag"/>
						</xsl:if>

            <!-- PAÜ Metin İçi Sayfa Referans Ayracı: İki nokta üst üste ve boşluk -->
						<xsl:if test="string-length($volume) > 0 or string-length($pages) > 0">
							<xsl:if test="string-length($displayAuthor) > 0 or string-length($displayTitle) > 0 or string-length($year) > 0">
								<xsl:text>: </xsl:text>
							</xsl:if>

							<xsl:choose>
								<xsl:when test="string-length($volume) > 0 and string-length($pages) > 0">
									<xsl:value-of select="$volume"/>
									<xsl:text>:</xsl:text>
									<xsl:value-of select="$pages"/>
								</xsl:when>
								<xsl:when test="string-length($volume) > 0">
									<xsl:value-of select="$volume"/>
								</xsl:when>
								<xsl:when test="string-length($pages) > 0">
									<xsl:value-of select="$pages"/>
								</xsl:when>
							</xsl:choose>
						</xsl:if>

						<xsl:if test="/b:Citation/b:PageSuffix">
							<xsl:value-of select="/b:Citation/b:PageSuffix"/>
						</xsl:if>
						<xsl:if test="/b:Citation/b:LastAuthor">
							<xsl:call-template name="templ_prop_CloseBracket"/>
						</xsl:if>
						<xsl:if test="not(/b:Citation/b:LastAuthor)">
							<xsl:call-template name="templ_prop_GroupSeparator"/>
						</xsl:if>

						</xsl:element>
					</body>
				</html>
			</xsl:when>

      <xsl:when test="b:Bibliography">
        <html xmlns:o="urn:schemas-microsoft-com:office:office"
						xmlns:w="urn:schemas-microsoft-com:office:word"
						xmlns="http://www.w3.org/TR/REC-html40">
          <head>
            
            <style>
              p.MsoBibliography, li.MsoBibliography, div.MsoBibliography
            </style>
          </head>

          <body>
            <xsl:variable name="ListPopulatedWithMain">
              <xsl:call-template name="populateMain">
                <xsl:with-param name="Type">b:Bibliography</xsl:with-param>
              </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="sList">
              <xsl:call-template name="sortedList">
                <xsl:with-param name="sourceRoot">
                  <xsl:copy-of select="$ListPopulatedWithMain"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:variable>

            <xsl:for-each select="msxsl:node-set($sList)/b:Bibliography/b:Source">

              <xsl:variable name="LCID">
                <xsl:choose>
                  <xsl:when test="b:LCID='0' or b:LCID='' or not(b:LCID)">
                    <xsl:value-of select="/*/b:Locals/b:DefaultLCID"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="b:LCID"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>

              <xsl:variable name="dir">
                <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$LCID]/b:Properties/b:Direction"/>
              </xsl:variable>

              <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
              <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'"/>

              <xsl:element name="p">
                <xsl:attribute name="lang">
                  <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$LCID]/@Culture"/>
                </xsl:attribute>
                <xsl:attribute name="dir">
                  <xsl:value-of select="$dir"/>
                </xsl:attribute>
                <xsl:attribute name="class">
                  <xsl:value-of select="'MsoBibliography'"/>
                </xsl:attribute>
                <!-- PAÜ Kaynakça Paragraf Girintisi (1.25 cm) -->
                <xsl:attribute name="style">
                  <xsl:choose>
                    <xsl:when test="translate($dir,$uppercase,$lowercase)='rtl'">
                      <xsl:value-of select="'margin-right:1.25cm;text-indent:-1.25cm'"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="'margin-left:1.25cm;text-indent:-1.25cm'"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>

                <xsl:variable name="tempCSCPu">
                  <xsl:call-template name="templateCSCPu"/>
                </xsl:variable>

                <xsl:variable name="tempJVIP">
                  <xsl:call-template name="templateJVIP"/>
                </xsl:variable>

                <xsl:variable name="pages">
                  <xsl:call-template name="handleSpaces">
                    <xsl:with-param name="field" select="b:Pages"/>
                  </xsl:call-template>
                </xsl:variable>

                <xsl:variable name="title">
                  <xsl:call-template name="handleSpaces">
                    <xsl:with-param name="field" select="b:Title"/>
                  </xsl:call-template>
                </xsl:variable>

                <xsl:variable name="titleDot">
                  <xsl:call-template name="appendField_Dot">
                    <xsl:with-param name="field" select="b:Title"/>
                  </xsl:call-template>
                </xsl:variable>

                <xsl:variable name="date">
                  <xsl:call-template name="formatDate"/>
                </xsl:variable>

                <xsl:variable name="enclosedDateDot">
                  <xsl:if test="string-length($date)>0">
                    <xsl:call-template name="templ_prop_APA_GeneralOpen"/>
                    <xsl:value-of select="$date"/>
                    <xsl:call-template name="templ_prop_APA_GeneralClose"/>
                    <xsl:call-template name="templ_prop_Dot"/>
                  </xsl:if>
                </xsl:variable>

                <xsl:variable name="author">
                  <xsl:call-template name="formatAuthor"/>
                </xsl:variable>
                
                <xsl:variable name="authorDot">
                  <xsl:call-template name="appendField_Dot">
                    <xsl:with-param name="field" select="$author"/>
                  </xsl:call-template>
                </xsl:variable>

                <xsl:variable name="theAuthorDot">
                   <xsl:value-of select="$authorDot"/>
                </xsl:variable>

                <xsl:variable name="i_titleEditionVolumeDot">
                  <xsl:if test="string-length($title)>0">
                    <xsl:call-template name = "ApplyItalicTitleNS">
                      <xsl:with-param name = "data">
                          <xsl:value-of select="$titleDot"/>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:if>
                </xsl:variable>
                
                <!-- DOI Değişkenleri Kaldirildi -->

                <xsl:variable name = "source">
                  <xsl:choose>
                    
                    <!-- İnternet Sitesi (Web Sitesi) Kaynak Türleri -->
                    <xsl:when test="b:SourceType='InternetSite' or b:SourceType='DocumentFromInternetSite' or b:SourceType='ElectronicSource'">
                        <xsl:if test="string-length($theAuthorDot)>0">
                          <xsl:value-of select="$theAuthorDot"/>
                        </xsl:if>
                        <xsl:if test="string-length($enclosedDateDot)>0">
                          <xsl:call-template name="templ_prop_Space"/>
                          <xsl:value-of select="$enclosedDateDot"/>
                        </xsl:if>
                        <xsl:if test="string-length(b:Title)>0">
                          <xsl:call-template name="templ_prop_Space"/>
                          <xsl:value-of select="b:Title"/>
                          <xsl:choose>
                             <xsl:when test="string-length(b:URL)>0">
                                <xsl:text>, </xsl:text>
                             </xsl:when>
                             <xsl:otherwise>
                                <xsl:text>.</xsl:text>
                             </xsl:otherwise>
                          </xsl:choose>
                        </xsl:if>
                        <xsl:if test="string-length(b:URL)>0">
                          <xsl:if test="string-length(b:Title)=0 and (string-length($theAuthorDot)>0 or string-length($enclosedDateDot)>0)">
                             <xsl:call-template name="templ_prop_Space"/>
                          </xsl:if>
                          <a href="{b:URL}" style="color:blue; text-decoration:underline;">
                             <xsl:value-of select="b:URL"/>
                          </a>
                        </xsl:if>

                        <xsl:variable name="accDate">
                            <xsl:if test="string-length(b:YearAccessed)>0">
                                <xsl:if test="string-length(b:DayAccessed)>0">
                                    <xsl:value-of select="b:DayAccessed"/><xsl:text>.</xsl:text>
                                </xsl:if>
                                <xsl:if test="string-length(b:MonthAccessed)>0">
                                    <xsl:choose>
                                        <xsl:when test="b:MonthAccessed='Ocak' or b:MonthAccessed='ocak' or b:MonthAccessed='January' or b:MonthAccessed='1' or b:MonthAccessed='01'">01</xsl:when>
                                        <xsl:when test="b:MonthAccessed='Şubat' or b:MonthAccessed='şubat' or b:MonthAccessed='February' or b:MonthAccessed='2' or b:MonthAccessed='02'">02</xsl:when>
                                        <xsl:when test="b:MonthAccessed='Mart' or b:MonthAccessed='mart' or b:MonthAccessed='March' or b:MonthAccessed='3' or b:MonthAccessed='03'">03</xsl:when>
                                        <xsl:when test="b:MonthAccessed='Nisan' or b:MonthAccessed='nisan' or b:MonthAccessed='April' or b:MonthAccessed='4' or b:MonthAccessed='04'">04</xsl:when>
                                        <xsl:when test="b:MonthAccessed='Mayıs' or b:MonthAccessed='mayıs' or b:MonthAccessed='May' or b:MonthAccessed='5' or b:MonthAccessed='05'">05</xsl:when>
                                        <xsl:when test="b:MonthAccessed='Haziran' or b:MonthAccessed='haziran' or b:MonthAccessed='June' or b:MonthAccessed='6' or b:MonthAccessed='06'">06</xsl:when>
                                        <xsl:when test="b:MonthAccessed='Temmuz' or b:MonthAccessed='temmuz' or b:MonthAccessed='July' or b:MonthAccessed='7' or b:MonthAccessed='07'">07</xsl:when>
                                        <xsl:when test="b:MonthAccessed='Ağustos' or b:MonthAccessed='ağustos' or b:MonthAccessed='August' or b:MonthAccessed='8' or b:MonthAccessed='08'">08</xsl:when>
                                        <xsl:when test="b:MonthAccessed='Eylül' or b:MonthAccessed='eylül' or b:MonthAccessed='September' or b:MonthAccessed='9' or b:MonthAccessed='09'">09</xsl:when>
                                        <xsl:when test="b:MonthAccessed='Ekim' or b:MonthAccessed='ekim' or b:MonthAccessed='October' or b:MonthAccessed='10'">10</xsl:when>
                                        <xsl:when test="b:MonthAccessed='Kasım' or b:MonthAccessed='kasım' or b:MonthAccessed='November' or b:MonthAccessed='11'">11</xsl:when>
                                        <xsl:when test="b:MonthAccessed='Aralık' or b:MonthAccessed='aralık' or b:MonthAccessed='December' or b:MonthAccessed='12'">12</xsl:when>
                                        <xsl:otherwise><xsl:value-of select="b:MonthAccessed"/></xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:text>.</xsl:text>
                                </xsl:if>
                                <xsl:value-of select="b:YearAccessed"/>
                            </xsl:if>
                        </xsl:variable>

                        <xsl:if test="string-length($accDate)>0">
                            <xsl:call-template name="templ_prop_Space"/>
                            <xsl:text>(</xsl:text><xsl:value-of select="$accDate"/><xsl:text>).</xsl:text>
                        </xsl:if>
                        <xsl:if test="string-length($accDate)=0 and string-length(b:URL)>0">
                            <xsl:text>.</xsl:text>
                        </xsl:if>
                    </xsl:when>

                    <!-- RAPOR VE TEZLER İÇİN ÖZEL DÜZENLEME -->
                    <xsl:when test="b:SourceType='Report'">
                      <xsl:if test="string-length($theAuthorDot)>0">
                        <xsl:value-of select="$theAuthorDot"/>
                      </xsl:if>

                      <xsl:if test="string-length($enclosedDateDot)>0">
                        <xsl:call-template name="templ_prop_Space"/>
                        <xsl:value-of select="$enclosedDateDot"/>
                      </xsl:if>

                      <xsl:variable name="thesisTypeVar">
                        <xsl:value-of select="b:ThesisType"/>
                      </xsl:variable>

                      <xsl:choose>
                          <!-- TEZ FORMATI -->
                          <xsl:when test="string-length($thesisTypeVar)>0">
                              <xsl:if test="string-length(b:Title)>0">
                                  <xsl:call-template name="templ_prop_Space"/>
                                  <xsl:value-of select="b:Title"/><xsl:text>, </xsl:text>
                              </xsl:if>
                              
                              <xsl:text>(</xsl:text><xsl:value-of select="$thesisTypeVar"/><xsl:text>)</xsl:text>
                              
                              <xsl:choose>
                                  <xsl:when test="string-length(b:Institution)>0">
                                      <xsl:text>, </xsl:text><xsl:value-of select="b:Institution"/>
                                      <xsl:if test="string-length(b:Department)>0">
                                           <xsl:text> </xsl:text><xsl:value-of select="b:Department"/>
                                      </xsl:if>
                                  </xsl:when>
                                  <xsl:when test="string-length(b:Publisher)>0">
                                      <xsl:text>, </xsl:text><xsl:value-of select="b:Publisher"/>
                                  </xsl:when>
                              </xsl:choose>
                              
                              <xsl:choose>
                                  <xsl:when test="string-length(b:City)>0">
                                      <xsl:text>, </xsl:text><xsl:value-of select="b:City"/><xsl:text>.</xsl:text>
                                  </xsl:when>
                                  <xsl:otherwise>
                                      <xsl:text>.</xsl:text>
                                  </xsl:otherwise>
                              </xsl:choose>
                          </xsl:when>
                          
                          <!-- RAPOR FORMATI -->
                          <xsl:otherwise>
                              <xsl:if test="string-length(b:Title)>0">
                                  <xsl:call-template name="templ_prop_Space"/>
                                  <xsl:text>“</xsl:text><xsl:value-of select="b:Title"/><xsl:text>”</xsl:text>
                                  <xsl:choose>
                                      <xsl:when test="string-length(b:Institution)>0 or string-length(b:Publisher)>0 or string-length(b:City)>0 or string-length(b:Pages)>0">
                                          <xsl:text>, </xsl:text>
                                      </xsl:when>
                                      <xsl:otherwise>
                                          <xsl:text>.</xsl:text>
                                      </xsl:otherwise>
                                  </xsl:choose>
                              </xsl:if>
                              
                              <xsl:choose>
                                  <xsl:when test="string-length(b:Institution)>0">
                                      <xsl:value-of select="b:Institution"/>
                                  </xsl:when>
                                  <xsl:when test="string-length(b:Publisher)>0">
                                      <xsl:value-of select="b:Publisher"/>
                                  </xsl:when>
                              </xsl:choose>
                              
                              <xsl:if test="string-length(b:City)>0">
                                  <xsl:if test="string-length(b:Institution)>0 or string-length(b:Publisher)>0">
                                      <xsl:text>, </xsl:text>
                                  </xsl:if>
                                  <xsl:value-of select="b:City"/>
                              </xsl:if>

                              <xsl:if test="string-length(b:Pages)>0">
                                  <xsl:if test="string-length(b:Institution)>0 or string-length(b:Publisher)>0 or string-length(b:City)>0">
                                      <xsl:text>, </xsl:text>
                                  </xsl:if>
                                  <xsl:value-of select="b:Pages"/>
                              </xsl:if>

                              <xsl:if test="string-length(b:Institution)>0 or string-length(b:Publisher)>0 or string-length(b:City)>0 or string-length(b:Pages)>0">
                                  <xsl:text>.</xsl:text>
                              </xsl:if>
                          </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>

                    <!-- Kitaplar (Books) -->
                    <xsl:when test="b:SourceType='Book'">
                        <xsl:if test="string-length($theAuthorDot)>0">
                          <xsl:value-of select="$theAuthorDot"/>
                          <xsl:if test="string-length($enclosedDateDot)>0">
                            <xsl:call-template name="templ_prop_Space"/>
                            <xsl:value-of select="$enclosedDateDot"/>
                          </xsl:if>
                          <xsl:if test="string-length($i_titleEditionVolumeDot)>0">
                            <xsl:call-template name="templ_prop_Space"/>
                            <xsl:apply-templates select="msxsl:node-set($i_titleEditionVolumeDot)" mode="outputHtml"/>
                          </xsl:if>
                          <xsl:if test="string-length($tempCSCPu)>0">
                            <xsl:call-template name="templ_prop_Space"/>
                            <xsl:value-of select="$tempCSCPu"/>
                          </xsl:if>
                        </xsl:if>
                    </xsl:when>

                    <!-- Makaleler (Journal Articles) -->
                    <xsl:when test="b:SourceType='JournalArticle'">
                        <xsl:if test="string-length($theAuthorDot)>0">
                          <xsl:value-of select="$theAuthorDot"/>

                          <xsl:if test="string-length($enclosedDateDot)>0">
                            <xsl:call-template name="templ_prop_Space"/>
                            <xsl:value-of select="$enclosedDateDot"/>
                          </xsl:if>

                          <xsl:if test="string-length(b:Title)>0">
                            <xsl:call-template name="templ_prop_Space"/>
                            <xsl:text>“</xsl:text><xsl:value-of select="b:Title"/><xsl:text>”,</xsl:text>
                          </xsl:if>

                          <xsl:if test="string-length($tempJVIP)>0">
                            <xsl:call-template name="templ_prop_Space"/>
                            <xsl:apply-templates select="msxsl:node-set($tempJVIP)" mode="outputHtml"/>
                          </xsl:if>
                        </xsl:if>
                    </xsl:when>
                    
                    <!-- Diğer Kaynak Tipleri İçin Varsayılan Temel Düzen -->
                    <xsl:otherwise>
                        <xsl:if test="string-length($theAuthorDot)>0">
                          <xsl:value-of select="$theAuthorDot"/>
                        </xsl:if>
                        <xsl:if test="string-length($enclosedDateDot)>0">
                          <xsl:call-template name="templ_prop_Space"/>
                          <xsl:value-of select="$enclosedDateDot"/>
                        </xsl:if>
                        <xsl:if test="string-length(b:Title)>0">
                          <xsl:call-template name="templ_prop_Space"/>
                          <xsl:value-of select="b:Title"/><xsl:text>.</xsl:text>
                        </xsl:if>
                    </xsl:otherwise>
                    
                  </xsl:choose>
                </xsl:variable>

                <!-- DOI bağlantısı (formatHyperlink) kaldırıldı -->
                <xsl:if test="string-length($source)>0">
                  <xsl:copy-of select="$source"/>
                </xsl:if>

              </xsl:element>
            </xsl:for-each>
          </body>
        </html>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- PAÜ Formatına Uygun Kitap Yayıncı ve Şehir Düzeni -->
  <xsl:template name="templateCSCPu">
      <xsl:variable name="pub">
          <xsl:call-template name="handleSpaces">
              <xsl:with-param name="field" select="b:Publisher"/>
          </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="city">
          <xsl:call-template name="handleSpaces">
              <xsl:with-param name="field" select="b:City"/>
          </xsl:call-template>
      </xsl:variable>

      <xsl:if test="string-length($pub)>0">
          <xsl:value-of select="$pub"/>
      </xsl:if>
      <xsl:if test="string-length($pub)>0 and string-length($city)>0">
          <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:if test="string-length($city)>0">
          <xsl:value-of select="$city"/>
      </xsl:if>
      <xsl:if test="string-length($pub)>0 or string-length($city)>0">
          <xsl:text>.</xsl:text>
      </xsl:if>
  </xsl:template>

  <!-- PAÜ Formatına Uygun Dergi (Makale) Düzeni -->
  <xsl:template name="templateJVIP">
      <xsl:variable name="jn"><xsl:value-of select="b:JournalName"/></xsl:variable>
      <xsl:variable name="vol"><xsl:value-of select="b:Volume"/></xsl:variable>
      <xsl:variable name="iss"><xsl:value-of select="b:Issue"/></xsl:variable>
      <xsl:variable name="pg"><xsl:value-of select="b:Pages"/></xsl:variable>

      <xsl:if test="string-length($jn)>0">
          <i xmlns="http://www.w3.org/TR/REC-html40"><xsl:value-of select="$jn"/></i>
      </xsl:if>
      <xsl:if test="string-length($jn)>0 and (string-length($vol)>0 or string-length($iss)>0 or string-length($pg)>0)">
          <xsl:text>, </xsl:text>
      </xsl:if>

      <xsl:if test="string-length($vol)>0">
          <xsl:value-of select="$vol"/>
      </xsl:if>
      <xsl:if test="string-length($vol)>0 and string-length($iss)>0">
          <xsl:text>/</xsl:text>
      </xsl:if>
      <xsl:if test="string-length($iss)>0">
          <xsl:value-of select="$iss"/>
      </xsl:if>

      <xsl:if test="(string-length($vol)>0 or string-length($iss)>0) and string-length($pg)>0">
          <xsl:text>, </xsl:text>
      </xsl:if>

      <xsl:if test="string-length($pg)>0">
          <xsl:text>s. </xsl:text> 
          <xsl:value-of select="$pg"/>
      </xsl:if>
      <xsl:text>.</xsl:text>
  </xsl:template>

  <xsl:template name="sortedList">
    <xsl:param name="sourceRoot"/>
    <xsl:apply-templates select="msxsl:node-set($sourceRoot)/*">
      <xsl:sort select="b:SortingString" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="*">
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:for-each select="@*">
        <xsl:attribute name="{name()}" namespace="{namespace-uri()}">
          <xsl:value-of select="." />
        </xsl:attribute>
      </xsl:for-each>
      <xsl:apply-templates>
        <xsl:sort select="b:SortingString" />
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*" mode="outputHtml" xml:space="preserve"><xsl:element name="{name()}" namespace="{namespace-uri()}"><xsl:for-each select="@*"><xsl:attribute name="{name()}" namespace="{namespace-uri()}"><xsl:value-of select="." /></xsl:attribute></xsl:for-each><xsl:apply-templates mode="outputHtml"/></xsl:element></xsl:template>

  <xsl:template match="text()">
    <xsl:value-of select="." />
  </xsl:template>

  <xsl:template name="MainContributors">
    <xsl:param name="SourceRoot"/>
    <xsl:choose>
      <xsl:when test="./b:SourceType='Book'">
        <xsl:choose>
          <xsl:when test="string-length(./b:Author/b:Author)>0">Author</xsl:when>
          <xsl:when test="string-length(./b:Author/b:Editor)>0">Editor</xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="./b:SourceType='JournalArticle'">
        <xsl:choose>
          <xsl:when test="string-length(./b:Author/b:Author)>0">Author</xsl:when>
          <xsl:when test="string-length(./b:Author/b:Editor)>0">Editor</xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>Author</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="populateMain">
    <xsl:param name="Type"/>
    <xsl:element name="{$Type}">
      <xsl:for-each select="/*[$Type]/b:Source">
        <xsl:variable name="MostImportantAuthorLocalName">
          <xsl:call-template name="MainContributors"/>
        </xsl:variable>
        <xsl:element name="{'b:Source'}">
          <xsl:if test="$Type='b:Citation'">
            <b:Title>
              <xsl:if test="string-length(b:Title)>0">
                <xsl:value-of select="b:Title"/>
              </xsl:if>
            </b:Title>
          </xsl:if>

          <b:SortingString>
            <xsl:variable name = "author0">
              <xsl:for-each select="./b:Author/*[local-name()=$MostImportantAuthorLocalName]">
                <xsl:call-template name="formatPersonsAuthor"/>
              </xsl:for-each>
            </xsl:variable>
            <xsl:variable name = "author">
              <xsl:choose>
                <xsl:when test="string-length(./b:Author/*[local-name()=$MostImportantAuthorLocalName]/b:Corporate) > 0">
                  <xsl:value-of select="./b:Author/*[local-name()=$MostImportantAuthorLocalName]/b:Corporate"/>
                </xsl:when>
                <xsl:when test="string-length($author0) > 0">
                  <xsl:value-of select="$author0"/>
                </xsl:when>
              </xsl:choose>
            </xsl:variable>
            <xsl:value-of select="$author"/>
            <xsl:value-of select="b:Year"/>
          </b:SortingString>

          <b:Author>
            <b:Main>
				<xsl:if test="string-length(./b:Author/*[local-name()=$MostImportantAuthorLocalName]/b:Corporate)=0">
				  <b:NameList>
					<xsl:for-each select="./b:Author/*[local-name()=$MostImportantAuthorLocalName]/b:NameList/b:Person">
					  <b:Person>
						<b:Last><xsl:value-of select="./b:Last"/></b:Last>
						<b:First><xsl:value-of select="./b:First"/></b:First>
						<b:Middle><xsl:value-of select="./b:Middle"/></b:Middle>
					  </b:Person>
					</xsl:for-each>
				  </b:NameList>
				</xsl:if>
                <!-- PAÜ: Yazar Kuruluşu Desteği -->
				<xsl:if test="string-length(./b:Author/*[local-name()=$MostImportantAuthorLocalName]/b:Corporate)>0">
					<b:Corporate><xsl:value-of select="./b:Author/*[local-name()=$MostImportantAuthorLocalName]/b:Corporate"/></b:Corporate>
				</xsl:if>
            </b:Main>
            <xsl:for-each select="./b:Author/*">
              <xsl:element name="{name()}" namespace="{namespace-uri()}">
                <xsl:call-template name="copyNameNodes"/>
              </xsl:element>
            </xsl:for-each>
          </b:Author>
          <xsl:for-each select="*">
            <xsl:if test="name()!='Author' and not(name()='Title' and $Type='b:Citation')">
              <xsl:element name="{name()}" namespace="{namespace-uri()}">
                <xsl:call-template name="copyNodes"/>
              </xsl:element>
            </xsl:if>
          </xsl:for-each>
        </xsl:element>
        <xsl:for-each select="../*">
          <xsl:if test="local-name()!='Source' and namespace-uri()='http://schemas.openxmlformats.org/officeDocument/2006/bibliography'">
            <xsl:element name="{name()}" namespace="{namespace-uri()}">
              <xsl:call-template name="copyNodes"/>
            </xsl:element>
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each>
      <xsl:copy-of select="/*[$Type]/b:Locals"/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="copyNameNodes">
	<xsl:if test="string-length(b:Corporate)=0">
		<b:NameList>
		  <xsl:for-each select="b:NameList/b:Person">
			<b:Person>
			  <xsl:if test="string-length(./b:Last)>0"><b:Last><xsl:value-of select="./b:Last"/></b:Last></xsl:if>
			  <xsl:if test="string-length(./b:First)>0"><b:First><xsl:value-of select="./b:First"/></b:First></xsl:if>
			  <xsl:if test="string-length(./b:Middle)>0"><b:Middle><xsl:value-of select="./b:Middle"/></b:Middle></xsl:if>
			</b:Person>
		  </xsl:for-each>
		</b:NameList>
	</xsl:if>
    <!-- PAÜ: Yazar Kuruluşu Desteği -->
    <xsl:if test="string-length(b:Corporate)>0">
        <b:Corporate><xsl:value-of select="b:Corporate"/></b:Corporate>
    </xsl:if>
  </xsl:template>

  <xsl:template name="copyNodes">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template name="handleSpaces">
    <xsl:param name="field"/>
    <xsl:value-of select="$field"/>
  </xsl:template>

  <xsl:template name="appendField_Dot">
    <xsl:param name="field"/>
    <xsl:variable name="temp">
      <xsl:call-template name="handleSpaces">
        <xsl:with-param name="field" select="$field"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="lastChar">
      <xsl:value-of select="substring($temp, string-length($temp))"/>
    </xsl:variable>
    <xsl:variable name="prop_EndChars">
      <xsl:call-template name="templ_prop_EndChars"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="string-length($temp) = 0"></xsl:when>
      <xsl:when test="contains($prop_EndChars, $lastChar)">
        <xsl:value-of select="$temp"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$temp"/>
        <xsl:call-template name="templ_prop_Dot"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="formatNameOneItem">
    <xsl:param name="format"/>
    <xsl:choose>
      <xsl:when test="$format = 'F'"><xsl:value-of select="b:First"/></xsl:when>
      <xsl:when test="$format = 'L'"><xsl:value-of select="b:Last"/></xsl:when>
      <xsl:when test="$format = 'M'"><xsl:value-of select="b:Middle"/></xsl:when>
      <xsl:when test="$format = 'f'"><xsl:value-of select="substring(b:First,1,1)"/></xsl:when>
      <xsl:when test="$format = 'm'"><xsl:value-of select="substring(b:Middle,1,1)"/></xsl:when>
      <xsl:when test="$format = 'l'"><xsl:value-of select="substring(b:Last,1,1)"/></xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="formatMainAuthor">
    <xsl:call-template name="formatNameCore">
      <xsl:with-param name="FML"><xsl:call-template name="templ_prop_APA_MainAuthors_FML"/></xsl:with-param>
      <xsl:with-param name="FM"><xsl:call-template name="templ_prop_APA_MainAuthors_FM"/></xsl:with-param>
      <xsl:with-param name="ML"><xsl:call-template name="templ_prop_APA_MainAuthors_ML"/></xsl:with-param>
      <xsl:with-param name="FL"><xsl:call-template name="templ_prop_APA_MainAuthors_FL"/></xsl:with-param>
      <xsl:with-param name="upperLast">no</xsl:with-param>
      <xsl:with-param name="withDot">yes</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:variable name="maxBibAuthors" select="21"/>

  <xsl:template name="formatPersonSeperator">
    <xsl:param name="isLast"/>
    <xsl:variable name="cPeople" select="count(../b:Person)"/>

    <xsl:if test="position() = $cPeople - 1">
      <xsl:if test="$cPeople &lt;= $maxBibAuthors">
        <xsl:text> &amp; </xsl:text>
      </xsl:if>
    </xsl:if>

    <xsl:if test="position() &lt; $cPeople - 1 and position() &lt; $maxBibAuthors">
      <xsl:call-template name="templ_prop_AuthorsSeparator"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="formatPersonsAuthor">
    <xsl:if test="string-length(b:Corporate)=0">
      <xsl:for-each select="b:NameList/b:Person">
        <xsl:if test="position() &lt; $maxBibAuthors or position() = last()">
          <xsl:call-template name="formatMainAuthor"/>
        </xsl:if>
        <xsl:call-template name="formatPersonSeperator"/>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="string-length(b:Corporate)>0">
        <xsl:value-of select="b:Corporate"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="formatAuthor">
    <xsl:for-each select="b:Author/b:Author">
      <xsl:call-template name="formatPersonsAuthor"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="formatNameCore">
		<xsl:param name="FML"/>
		<xsl:param name="FM"/>
		<xsl:param name="ML"/>
		<xsl:param name="FL"/>
		<xsl:param name="upperLast"/>
		<xsl:param name="withDot"/>

		<xsl:variable name="first"><xsl:value-of select="b:First"/></xsl:variable>
		<xsl:variable name="middle"><xsl:value-of select="b:Middle"/></xsl:variable>
		<xsl:variable name="last"><xsl:value-of select="b:Last"/></xsl:variable>
		
		<xsl:variable name="format">
			<xsl:choose>
				<xsl:when test="string-length($first) = 0 and string-length($middle) = 0 and string-length($last) != 0 "><xsl:call-template name="templ_prop_SimpleAuthor_L" /></xsl:when>
				<xsl:when test="string-length($first) != 0 and string-length($middle) = 0 and string-length($last) != 0 "><xsl:value-of select="$FL"/></xsl:when>
				<xsl:when test="string-length($first) != 0 and string-length($middle) != 0 and string-length($last) = 0 "><xsl:value-of select="$FM"/></xsl:when>
				<xsl:when test="string-length($first) != 0 and string-length($middle) != 0 and string-length($last) != 0 "><xsl:value-of select="$FML"/></xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:call-template name="StringFormatName">
			<xsl:with-param name="format" select="$format"/>
			<xsl:with-param name="upperLast" select="$upperLast"/>
			<xsl:with-param name="withDot" select="$withDot"/>
		</xsl:call-template>
	</xsl:template>

  <xsl:template name="StringFormatName">
		<xsl:param name="format" />
		<xsl:param name="withDot" />
		<xsl:param name="upperLast"/>
    <xsl:variable name="prop_EndChars">
      <xsl:call-template name="templ_prop_EndChars"/>
    </xsl:variable>
    <xsl:choose>
			<xsl:when test="$format = ''"></xsl:when>
			<xsl:when test="substring($format, 1, 2) = '%%'">
				<xsl:text>%</xsl:text>
				<xsl:call-template name="StringFormatName">
					<xsl:with-param name="format" select="substring($format, 3)" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="substring($format, 1, 1) = '%'">
				<xsl:variable name="what" select="substring($format, 2, 1)" />
        <xsl:call-template name="formatNameOneItem">
          <xsl:with-param name="format" select="$what"/>
        </xsl:call-template>
				<xsl:call-template name="StringFormatName">
					<xsl:with-param name="format" select="substring($format, 3)" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring($format, 1, 1)" />
				<xsl:call-template name="StringFormatName">
					<xsl:with-param name="format" select="substring($format, 2)" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

  <xsl:template name="formatDate">
    <xsl:if test="string-length(b:Year) > 0">
      <xsl:value-of select="b:Year"/>
    </xsl:if>
  </xsl:template>

	<xsl:template name="ApplyItalicTitleNS">
		<xsl:param name="data" />
    <i xmlns="http://www.w3.org/TR/REC-html40">
      <xsl:copy-of select="msxsl:node-set($data)" />
    </i>
	</xsl:template>

</xsl:stylesheet>
