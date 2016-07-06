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

</xsl:stylesheet>
