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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:output method="text"/>
    <xsl:template match="/snapshot">
        <xsl:variable name="attrs" select="tags/tag[label='github']/attributes"/>
        <xsl:text>Hey, let me try to merge your branch `</xsl:text>
        <xsl:value-of select="$attrs/attribute[name='headRef']/value"/>
        <xsl:text>` from `</xsl:text>
        <xsl:value-of select="$attrs/attribute[name='headUser']/value"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="$attrs/attribute[name='headRepo']/value"/>
        <xsl:text>` into branch `</xsl:text>
        <xsl:value-of select="$attrs/attribute[name='baseRef']/value"/>
        <xsl:text>` of `</xsl:text>
        <xsl:value-of select="$attrs/attribute[name='baseUser']/value"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="$attrs/attribute[name='baseRepo']/value"/>
        <xsl:text>`. If there won't be any merge conflicts, I'll try to build it.</xsl:text>
        <xsl:text> If it builds without errors, I will merge this pull request.</xsl:text>
        <xsl:text> I will let you know in any case, in a few...</xsl:text>
    </xsl:template>
</xsl:stylesheet>
