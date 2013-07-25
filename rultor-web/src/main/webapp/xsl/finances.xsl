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
    <xsl:include href="/xsl/layout.xsl"/>
    <xsl:template name="head">
        <title>
            <xsl:text>finances</xsl:text>
        </title>
    </xsl:template>
    <xsl:template name="content">
        <p>
            <xsl:text>Unbilled </xsl:text>
            <a title="receipts">
                <xsl:attribute name="href">
                    <xsl:value-of select="//links/link[@rel='receipts']/@href"/>
                </xsl:attribute>
                <xsl:text>receipts</xsl:text>
            </a>
            <xsl:text>.</xsl:text>
        </p>
        <xsl:choose>
            <xsl:when test="/page/statements/statement">
                <ul class="nav">
                    <xsl:apply-templates select="/page/statements/statement"/>
                </ul>
                <xsl:if test="//links/link[@rel='more']">
                    <p>
                        <xsl:text>See </xsl:text>
                        <a title="more">
                            <xsl:attribute name="href">
                                <xsl:value-of select="//links/link[@rel='more']/@href"/>
                            </xsl:attribute>
                            <xsl:text>older</xsl:text>
                        </a>
                        <xsl:text> statements.</xsl:text>
                    </p>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:text>No statements at the moment.</xsl:text>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="statement">
        <li>
            <ul class="inline btn-group-vertical">
                <li>
                    <a title="see details">
                        <xsl:attribute name="href">
                            <xsl:value-of select="links/link[@rel='see']/@href"/>
                        </xsl:attribute>
                        <xsl:value-of select="date"/>
                    </a>
                </li>
                <li class="hidden-phone">
                    <xsl:value-of select="when"/>
                    <xsl:text> ago</xsl:text>
                </li>
                <li>
                    <xsl:value-of select="amount"/>
                </li>
            </ul>
        </li>
    </xsl:template>
</xsl:stylesheet>