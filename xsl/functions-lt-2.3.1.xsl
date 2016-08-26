<?xml version="1.0" encoding="utf-8"?>

<!-- This file is part of the DITA Open Toolkit project.
     See the accompanying license.txt file for applicable licenses.-->
<!-- (c) Copyright IBM Corp. 2004, 2005 All Rights Reserved. -->

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  exclude-result-prefixes="xs dita-ot">

  <xsl:function name="dita-ot:get-variable" as="node()*">
    <xsl:param name="ctx" as="node()?"/>
    <xsl:param name="id" as="xs:string"/>

    <xsl:call-template name="getString">
      <xsl:with-param name="stringName" select="$id"/>
    </xsl:call-template>
  </xsl:function>


  <!-- message has been disabled from original template -->
  <xsl:template name="getString">
    <xsl:param name="stringName"/>
    <xsl:call-template name="getVariable">
      <xsl:with-param name="id" select="string($stringName)"/>
    </xsl:call-template>
  </xsl:template>


 <xsl:template name="findString">
    <xsl:param name="id" as="xs:string"/>
    <xsl:param name="params" as="node()*"/>
    <xsl:param name="ancestorlang" as="xs:string*"/>
    <xsl:param name="defaultlang" as="xs:string*"/>

    <xsl:variable name="l" select="($ancestorlang, $defaultlang)[1]" as="xs:string?"/>
    <xsl:choose>
      <xsl:when test="exists($l)">
        <xsl:variable name="stringfile" select="$stringFiles[@xml:lang = $l]/@filename" as="xs:string*"/>
        <xsl:variable name="str" as="element()*">
          <xsl:for-each select="$stringfile">
            <xsl:sequence select="document(., $stringFiles[1])/*/*[@name = $id or @id = $id]"/><!-- strings/str/@name opentopic-vars:vars/opentopic-vars:variable/@id -->
          </xsl:for-each>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="exists($str)">
            <xsl:apply-templates select="$str[last()]" mode="processVariableBody">
              <xsl:with-param name="params" select="$params"/>
            </xsl:apply-templates>
            <xsl:if test="empty($ancestorlang)">
              <xsl:call-template name="output-message">
                <xsl:with-param name="msgnum">001</xsl:with-param>
                <xsl:with-param name="msgsev">W</xsl:with-param>
                <xsl:with-param name="msgparams">%1=<xsl:value-of select="$id"/>;%2=<xsl:call-template name="getLowerCaseLang"/>;%3=<xsl:value-of select="$DEFAULTLANG"/></xsl:with-param>
              </xsl:call-template>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="findString">
              <xsl:with-param name="id" select="$id"/>
              <xsl:with-param name="params" select="$params"/>
              <xsl:with-param name="ancestorlang" select="$ancestorlang[position() gt 1]"/>
              <xsl:with-param name="defaultlang" select="if (exists($ancestorlang)) then $defaultlang else $defaultlang[position() gt 1]"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$id"/>
        <!--xsl:call-template name="output-message">
          <xsl:with-param name="msgnum">052</xsl:with-param>
          <xsl:with-param name="msgsev">W</xsl:with-param>
          <xsl:with-param name="msgparams">%1=<xsl:value-of select="$id"/></xsl:with-param>
        </xsl:call-template-->
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>
</xsl:stylesheet>
