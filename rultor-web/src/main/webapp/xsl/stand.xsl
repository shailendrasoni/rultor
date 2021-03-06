<?xml version="1.0"?>
<!--
 * Copyright (c) 2009-2013, rultor.com
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met: 1) Redistributions of source code must retain the above
 * copyright notice, this list of conditions and the following
 * disclaimer. 2) Redistributions in binary form must reproduce the above
 * copyright notice, this list of conditions and the following
 * disclaimer in the documentation and/or other materials provided
 * with the distribution. 3) Neither the name of the rultor.com nor
 * the names of its contributors may be used to endorse or promote
 * products derived from this software without specific prior written
 * permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT
 * NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 * FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml" version="2.0" exclude-result-prefixes="xs">
    <xsl:output method="xml" omit-xml-declaration="yes"/>
    <xsl:include href="./layout.xsl"/>
    <xsl:include href="./pulse.xsl"/>
    <xsl:template name="head">
        <title>
            <xsl:value-of select="/page/stand"/>
        </title>
        <script type="text/javascript">
            <xsl:attribute name="src">
                <xsl:value-of select="/page/links/link[@rel='root']/@href"/>
                <xsl:text>js/stand.js</xsl:text>
                <xsl:if test="/page/@ip">
                    <xsl:text>?</xsl:text>
                    <xsl:value-of select="/page/version/revision"/>
                </xsl:if>
            </xsl:attribute>
            <!-- this is for W3C compliance -->
            <xsl:text> </xsl:text>
        </script>
    </xsl:template>
    <xsl:template name="content">
        <xsl:apply-templates select="/page/filters"/>
        <xsl:apply-templates select="/page/pulses/pulse[snapshot or error]"/>
        <xsl:apply-templates select="/page/widgets"/>
        <xsl:choose>
            <xsl:when test="/page/pulses/pulse">
                <xsl:if test="/page/since">
                    <div class="spacious">
                        <ul class="list-inline">
                            <li>
                                <xsl:text>Since </xsl:text>
                                <span class="timeago"><xsl:value-of select="/page/since"/></span>
                            </li>
                            <li>
                                <a title="back to start">
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="/page/links/link[@rel='latest']/@href"/>
                                    </xsl:attribute>
                                    <xsl:text>back to start</xsl:text>
                                </a>
                            </li>
                        </ul>
                    </div>
                </xsl:if>
                <xsl:apply-templates select="/page/pulses/pulse[not(snapshot) and not(error)]"/>
                <xsl:if test="/page/links/link[@rel='more']">
                    <div class="spacious">
                        <xsl:text>See </xsl:text>
                        <a title="more">
                            <xsl:attribute name="href">
                                <xsl:value-of select="/page/links/link[@rel='more']/@href"/>
                            </xsl:attribute>
                            <xsl:text>more</xsl:text>
                        </a>
                        <xsl:text> pulses.</xsl:text>
                    </div>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <p class="spacious">
                    <xsl:text>No pulses yet.</xsl:text>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="filters">
        <xsl:if test="filter">
            <div class="spacious">
                <ul class="list-inline spacious-inline-list">
                    <li>
                        <xsl:text>Show only: </xsl:text>
                    </li>
                    <xsl:apply-templates select="filter"/>
                    <li>
                        <a title="clear filtering">
                            <xsl:attribute name="href">
                                <xsl:value-of select="/page/links/link[@rel='collapse']/@href"/>
                            </xsl:attribute>
                            <xsl:text>clear</xsl:text>
                        </a>
                    </li>
                </ul>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template match="filter">
        <li>
            <span class="label label-default"><xsl:value-of select="."/></span>
        </li>
    </xsl:template>
    <xsl:template match="widgets">
        <div class="row">
            <xsl:for-each select="widget">
                <div>
                    <xsl:attribute name="class">
                        <xsl:choose>
                            <xsl:when test="width">
                                <xsl:text>col-lg-</xsl:text>
                                <xsl:call-template name="grid-width">
                                    <xsl:with-param name="w" select="width"/>
                                </xsl:call-template>
                                <xsl:text> col-md-</xsl:text>
                                <xsl:call-template name="grid-width">
                                    <xsl:with-param name="w" select="width * 1.3"/>
                                </xsl:call-template>
                                <xsl:text> col-sm-</xsl:text>
                                <xsl:call-template name="grid-width">
                                    <xsl:with-param name="w" select="width * 2"/>
                                </xsl:call-template>
                                <xsl:text> col-xs-</xsl:text>
                                <xsl:call-template name="grid-width">
                                    <xsl:with-param name="w" select="width * 4"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>col-lg-12 col-md-12 col-sm-12 col-xs-12</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <div class="panel panel-default">
                        <xsl:if test="title">
                            <div class="panel-heading">
                                <xsl:value-of select="title"/>
                            </div>
                        </xsl:if>
                        <xsl:apply-templates select="." />
                    </div>
                </div>
            </xsl:for-each>
        </div>
    </xsl:template>
    <xsl:template name="grid-width">
        <xsl:param name="w" as="xs:double"/>
        <xsl:choose>
            <xsl:when test="$w &gt; 12">
                <xsl:text>12</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="round($w)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
