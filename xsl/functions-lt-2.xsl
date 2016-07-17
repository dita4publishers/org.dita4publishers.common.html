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

<!--   -->
  <xsl:template name="getString">
    <xsl:param name="stringName"/>
    <xsl:param name="stringFileList" select="document('../../../xsl/common/allstrings.xml')/allstrings/stringfile"/>
    <xsl:param name="stringFile">#none#</xsl:param>
    <xsl:param name="ancestorlang">
      <!-- Get the current language -->
      <xsl:call-template name="getLowerCaseLang"/>
    </xsl:param>
    <xsl:choose>
      <xsl:when test="$stringFile != '#none#'">
        <!-- Use the old getString template interface -->
        <!-- Get the translated string -->
        <xsl:variable name="str"
          select="$stringFile/strings/str[@name=$stringName][lang($ancestorlang)]"/>
        <xsl:choose>
          <!-- If the string was found, use it. Cannot test $str, because value could be empty. -->
          <xsl:when test="$stringFile/strings/str[@name=$stringName][lang($ancestorlang)]">
            <xsl:value-of select="$str"/>
          </xsl:when>
          <!-- If the current language is not the default language, try the default -->
          <xsl:when test="$ancestorlang!=$DEFAULTLANG">
            <!-- Determine which file holds the defaults; then get the default translation. -->
            <xsl:variable name="str-default"
              select="$stringFile/strings/str[@name=$stringName][lang($DEFAULTLANG)]"/>
            <xsl:choose>
              <!-- If a default was found, use it, but warn that fallback was needed.-->
              <xsl:when test="string-length($str-default)>0">
                <xsl:value-of select="$str-default"/>
                <xsl:call-template name="output-message">
                  <xsl:with-param name="msgnum">001</xsl:with-param>
                  <xsl:with-param name="msgsev">W</xsl:with-param>
                  <xsl:with-param name="msgparams">%1=<xsl:value-of select="$stringName"/>;%2=<xsl:value-of select="$ancestorlang"/>;%3=<xsl:value-of select="$DEFAULTLANG"/></xsl:with-param>
                </xsl:call-template>
              </xsl:when>
              <!-- Translation was not even found in the default language. -->
              <xsl:otherwise>
                <xsl:value-of select="$stringName"/>
                <xsl:call-template name="output-message">
                  <xsl:with-param name="msgnum">052</xsl:with-param>
                  <xsl:with-param name="msgsev">W</xsl:with-param>
                  <xsl:with-param name="msgparams">%1=<xsl:value-of select="$stringName"/></xsl:with-param>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <!-- The current language is the default; no translation found at all. -->
          <xsl:otherwise>
            <xsl:value-of select="$stringName"/>
            <xsl:call-template name="output-message">
              <xsl:with-param name="msgnum">052</xsl:with-param>
              <xsl:with-param name="msgsev">W</xsl:with-param>
              <xsl:with-param name="msgparams">%1=<xsl:value-of select="$stringName"/></xsl:with-param>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- Use the new getString template interface -->
        <!-- Determine which file holds translations for the current language -->
        <xsl:variable name="stringfile"
            select="document($stringFileList)/*/lang[@xml:lang=$ancestorlang]/@filename"/>
        <!-- Get the translated string -->
        <xsl:variable name="str" select="document($stringfile)/strings/str[@name=$stringName]"/>
        <xsl:choose>
          <!-- If the string was found, use it. -->
          <xsl:when test="count($str) &gt; 0">
            <xsl:value-of select="$str[last()]"/>
          </xsl:when>
          <!-- If the current language is not the default language, try the default -->
          <xsl:when test="$ancestorlang!=$DEFAULTLANG">
            <!-- Determine which file holds the defaults; then get the default translation. -->
            <xsl:variable name="backupstringfile"
                select="document($stringFileList)/*/lang[@xml:lang=$DEFAULTLANG]/@filename"/>
            <xsl:variable name="str-default"
              select="document($backupstringfile)/strings/str[@name=$stringName]"/>
            <xsl:choose>
              <!-- If a default was found, use it, but warn that fallback was needed.-->
              <xsl:when test="count($str-default) &gt; 0">
                <xsl:value-of select="$str-default[last()]"/>
                <xsl:call-template name="output-message">
                  <xsl:with-param name="msgnum">001</xsl:with-param>
                  <xsl:with-param name="msgsev">W</xsl:with-param>
                  <xsl:with-param name="msgparams">%1=<xsl:value-of select="$stringName"/>;%2=<xsl:value-of select="$ancestorlang"/>;%3=<xsl:value-of select="$DEFAULTLANG"/></xsl:with-param>
                </xsl:call-template>
              </xsl:when>
              <!-- Translation was not even found in the default language. -->
              <xsl:otherwise>
                <xsl:value-of select="$stringName"/>
                <xsl:call-template name="output-message">
                  <xsl:with-param name="msgnum">052</xsl:with-param>
                  <xsl:with-param name="msgsev">W</xsl:with-param>
                  <xsl:with-param name="msgparams">%1=<xsl:value-of select="$stringName"/></xsl:with-param>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <!-- The current language is the default; no translation found at all. -->
          <xsl:otherwise>
            <xsl:value-of select="$stringName"/>
            <xsl:call-template name="output-message">
              <xsl:with-param name="msgnum">052</xsl:with-param>
              <xsl:with-param name="msgsev">W</xsl:with-param>
              <xsl:with-param name="msgparams">%1=<xsl:value-of select="$stringName"/></xsl:with-param>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
