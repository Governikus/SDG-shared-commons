<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:query="urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0" xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:4.0" xmlns:rs="urn:oasis:names:tc:ebxml-regrep:xsd:rs:4.0" xmlns:saxon="http://saxon.sf.net/" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:sdg="http://data.europa.eu/p4s" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
<!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->

<xsl:param name="archiveDirParameter" />
  <xsl:param name="archiveNameParameter" />
  <xsl:param name="fileNameParameter" />
  <xsl:param name="fileDirParameter" />
  <xsl:variable name="document-uri">
    <xsl:value-of select="document-uri(/)" />
  </xsl:variable>

<!--PHASES-->


<!--PROLOG-->
<xsl:output indent="yes" method="xml" omit-xml-declaration="no" standalone="yes" />

<!--XSD TYPES FOR XSLT2-->


<!--KEYS AND FUNCTIONS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-select-full-path">
    <xsl:apply-templates mode="schematron-get-full-path" select="." />
  </xsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-get-full-path">
    <xsl:apply-templates mode="schematron-get-full-path" select="parent::*" />
    <xsl:text>/</xsl:text>
    <xsl:choose>
      <xsl:when test="namespace-uri()=''">
        <xsl:value-of select="name()" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>*:</xsl:text>
        <xsl:value-of select="local-name()" />
        <xsl:text>[namespace-uri()='</xsl:text>
        <xsl:value-of select="namespace-uri()" />
        <xsl:text>']</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="preceding" select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])" />
    <xsl:text>[</xsl:text>
    <xsl:value-of select="1+ $preceding" />
    <xsl:text>]</xsl:text>
  </xsl:template>
  <xsl:template match="@*" mode="schematron-get-full-path">
    <xsl:apply-templates mode="schematron-get-full-path" select="parent::*" />
    <xsl:text>/</xsl:text>
    <xsl:choose>
      <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()" />
</xsl:when>
      <xsl:otherwise>
        <xsl:text>@*[local-name()='</xsl:text>
        <xsl:value-of select="local-name()" />
        <xsl:text>' and namespace-uri()='</xsl:text>
        <xsl:value-of select="namespace-uri()" />
        <xsl:text>']</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-2">
    <xsl:for-each select="ancestor-or-self::*">
      <xsl:text>/</xsl:text>
      <xsl:value-of select="name(.)" />
      <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />
        <xsl:text>]</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:if test="not(self::*)">
      <xsl:text />/@<xsl:value-of select="name(.)" />
    </xsl:if>
  </xsl:template>
<!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->

<xsl:template match="node() | @*" mode="schematron-get-full-path-3">
    <xsl:for-each select="ancestor-or-self::*">
      <xsl:text>/</xsl:text>
      <xsl:value-of select="name(.)" />
      <xsl:if test="parent::*">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />
        <xsl:text>]</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:if test="not(self::*)">
      <xsl:text />/@<xsl:value-of select="name(.)" />
    </xsl:if>
  </xsl:template>

<!--MODE: GENERATE-ID-FROM-PATH -->
<xsl:template match="/" mode="generate-id-from-path" />
  <xsl:template match="text()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')" />
  </xsl:template>
  <xsl:template match="comment()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')" />
  </xsl:template>
  <xsl:template match="processing-instruction()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')" />
  </xsl:template>
  <xsl:template match="@*" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.@', name())" />
  </xsl:template>
  <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:text>.</xsl:text>
    <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')" />
  </xsl:template>

<!--MODE: GENERATE-ID-2 -->
<xsl:template match="/" mode="generate-id-2">U</xsl:template>
  <xsl:template match="*" mode="generate-id-2" priority="2">
    <xsl:text>U</xsl:text>
    <xsl:number count="*" level="multiple" />
  </xsl:template>
  <xsl:template match="node()" mode="generate-id-2">
    <xsl:text>U.</xsl:text>
    <xsl:number count="*" level="multiple" />
    <xsl:text>n</xsl:text>
    <xsl:number count="node()" />
  </xsl:template>
  <xsl:template match="@*" mode="generate-id-2">
    <xsl:text>U.</xsl:text>
    <xsl:number count="*" level="multiple" />
    <xsl:text>_</xsl:text>
    <xsl:value-of select="string-length(local-name(.))" />
    <xsl:text>_</xsl:text>
    <xsl:value-of select="translate(name(),':','.')" />
  </xsl:template>
<!--Strip characters-->  <xsl:template match="text()" priority="-1" />

<!--SCHEMA SETUP-->
<xsl:template match="/">
    <svrl:schematron-output schemaVersion="" title="">
      <xsl:comment>
        <xsl:value-of select="$archiveDirParameter" />   
		 <xsl:value-of select="$archiveNameParameter" />  
		 <xsl:value-of select="$fileNameParameter" />  
		 <xsl:value-of select="$fileDirParameter" />
      </xsl:comment>
      <svrl:ns-prefix-in-attribute-values prefix="sdg" uri="http://data.europa.eu/p4s" />
      <svrl:ns-prefix-in-attribute-values prefix="rs" uri="urn:oasis:names:tc:ebxml-regrep:xsd:rs:4.0" />
      <svrl:ns-prefix-in-attribute-values prefix="rim" uri="urn:oasis:names:tc:ebxml-regrep:xsd:rim:4.0" />
      <svrl:ns-prefix-in-attribute-values prefix="query" uri="urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0" />
      <svrl:ns-prefix-in-attribute-values prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance" />
      <svrl:ns-prefix-in-attribute-values prefix="xlink" uri="http://www.w3.org/1999/xlink" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M6" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M7" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M8" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M9" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M10" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M11" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M12" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M13" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M14" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M15" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M16" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->


<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/node()" mode="M6" priority="1000">
    <svrl:fired-rule context="/node()" />
    <xsl:variable name="ln" select="local-name(/node())" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$ln ='QueryResponse'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$ln ='QueryResponse'">
          <xsl:attribute name="id">R-EDM-RESP-S001</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The root element of a query response document MUST be 'query:QueryResponse'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M6" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M6" priority="-1" />
  <xsl:template match="@*|node()" mode="M6" priority="-2">
    <xsl:apply-templates mode="M6" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/node()" mode="M7" priority="1000">
    <svrl:fired-rule context="/node()" />
    <xsl:variable name="ns" select="namespace-uri(/node())" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$ns ='urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$ns ='urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0'">
          <xsl:attribute name="id">R-EDM-RESP-S002</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The namespace of root element of a 'query:QueryResponse' must be 'urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M7" priority="-1" />
  <xsl:template match="@*|node()" mode="M7" priority="-2">
    <xsl:apply-templates mode="M7" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="query:QueryResponse/@requestId" mode="M8" priority="1000">
    <svrl:fired-rule context="query:QueryResponse/@requestId" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space((.)),'^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$','i')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space((.)),'^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$','i')">
          <xsl:attribute name="id">R-EDM-RESP-S004</xsl:attribute>
          <xsl:attribute name="flag">ERROR</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The 'requestId' attribute of a 'QueryResponse' MUST be unique UUID (RFC 4122) and match the corresponding request.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M8" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M8" priority="-1" />
  <xsl:template match="@*|node()" mode="M8" priority="-2">
    <xsl:apply-templates mode="M8" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="query:QueryResponse" mode="M9" priority="1000">
    <svrl:fired-rule context="query:QueryResponse" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@requestId" />
      <xsl:otherwise>
        <svrl:failed-assert test="@requestId">
          <xsl:attribute name="id">R-EDM-RESP-S031</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The 'RequestId' attribute of a 'QueryResponse' MUST be present.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@status" />
      <xsl:otherwise>
        <svrl:failed-assert test="@status">
          <xsl:attribute name="id">R-EDM-RESP-S032</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The 'status' attribute of a 'QueryResponse' MUST be present. 
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M9" priority="-1" />
  <xsl:template match="@*|node()" mode="M9" priority="-2">
    <xsl:apply-templates mode="M9" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="query:QueryResponse" mode="M10" priority="1000">
    <svrl:fired-rule context="query:QueryResponse" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success'                  or @status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Unavailable'" />
      <xsl:otherwise>
        <svrl:failed-assert test="@status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success' or @status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Unavailable'">
          <xsl:attribute name="id">R-EDM-RESP-S006</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The 'status attribute of a 'QueryResponse' MUST be encoded as "urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success" for successful responses or as "urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Unavailable" for responses that will be available at a later time .</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M10" priority="-1" />
  <xsl:template match="@*|node()" mode="M10" priority="-2">
    <xsl:apply-templates mode="M10" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="query:QueryResponse[@status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success']/rim:RegistryObjectList" mode="M11" priority="1001">
    <svrl:fired-rule context="query:QueryResponse[@status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success']/rim:RegistryObjectList" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(rim:RegistryObject) > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(rim:RegistryObject) > 0">
          <xsl:attribute name="id">R-EDM-RESP-S007</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>An successful 'query:QueryResponse' includes a 'rim:RegistryObjectList'                
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="query:QueryResponse[@status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success']/rim:RegistryObjectList/rim:RegistryObject" mode="M11" priority="1000">
    <svrl:fired-rule context="query:QueryResponse[@status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success']/rim:RegistryObjectList/rim:RegistryObject" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="rim:RepositoryItemRef" />
      <xsl:otherwise>
        <svrl:failed-assert test="rim:RepositoryItemRef">
          <xsl:attribute name="id">R-EDM-RESP-S033</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The 'rim:RepositoryItemRef' of a 'rim:RegistryObject' MUST be present.               
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@id" />
      <xsl:otherwise>
        <svrl:failed-assert test="@id">
          <xsl:attribute name="id">R-EDM-RESP-S036</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The 'id' attribute of a 'RegistryObject' MUST be present.             
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M11" priority="-1" />
  <xsl:template match="@*|node()" mode="M11" priority="-2">
    <xsl:apply-templates mode="M11" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="query:QueryResponse[@status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success']/rim:RegistryObjectList/rim:RegistryObject/rim:RespositoryItemRef" mode="M12" priority="1000">
    <svrl:fired-rule context="query:QueryResponse[@status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success']/rim:RegistryObjectList/rim:RegistryObject/rim:RespositoryItemRef" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@xlink:href" />
      <xsl:otherwise>
        <svrl:failed-assert test="@xlink:href">
          <xsl:attribute name="id">R-EDM-RESP-S034</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The 'xlink:href' attribute of 'RepositoryItemRef' MUST be present.             
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@xlink:title" />
      <xsl:otherwise>
        <svrl:failed-assert test="@xlink:title">
          <xsl:attribute name="id">R-EDM-RESP-S035</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The 'xlink:title' attribute of 'RepositoryItemRef' MUST be present.          
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M12" priority="-1" />
  <xsl:template match="@*|node()" mode="M12" priority="-2">
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="query:QueryResponse/rs:Exception" mode="M13" priority="1000">
    <svrl:fired-rule context="query:QueryResponse/rs:Exception" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(rs:Exception) > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(rs:Exception) > 0">
          <xsl:attribute name="id">R-EDM-RESP-S008</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>A successful 'query:QueryResponse' does not include an Exception                
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M13" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M13" priority="-1" />
  <xsl:template match="@*|node()" mode="M13" priority="-2">
    <xsl:apply-templates mode="M13" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="query:QueryResponse" mode="M14" priority="1000">
    <svrl:fired-rule context="query:QueryResponse" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(child::rim:Slot[@name='SpecificationIdentifier'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(child::rim:Slot[@name='SpecificationIdentifier'])=1">
          <xsl:attribute name="id">R-EDM-RESP-S009</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:Slot name="SpecificationIdentifier" MUST be present in the QueryResponse.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(child::rim:Slot[@name='EvidenceResponseIdentifier'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(child::rim:Slot[@name='EvidenceResponseIdentifier'])=1">
          <xsl:attribute name="id">R-EDM-RESP-S010</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:Slot name="EvidenceResponseIdentifier" MUST be present in the QueryResponse.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(child::rim:Slot[@name='IssueDateTime'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(child::rim:Slot[@name='IssueDateTime'])=1">
          <xsl:attribute name="id">R-EDM-RESP-S011</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:Slot name="IssueDateTime" MUST be present  in the QueryResponse.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(child::rim:Slot[@name='EvidenceProvider'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(child::rim:Slot[@name='EvidenceProvider'])=1">
          <xsl:attribute name="id">R-EDM-RESP-S012</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:Slot name="EvidenceProvider" MUST be present in the QueryResponse.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(child::rim:Slot[@name='EvidenceRequester'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(child::rim:Slot[@name='EvidenceRequester'])=1">
          <xsl:attribute name="id">R-EDM-RESP-S013</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:Slot name="EvidenceRequester" MUST be present in the QueryResponse.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT info-->
<xsl:choose>
      <xsl:when test="count(child::rim:Slot[@name='ResponseAvailableDateTime'])&lt;2" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(child::rim:Slot[@name='ResponseAvailableDateTime'])&lt;2">
          <xsl:attribute name="id">R-EDM-RESP-S014</xsl:attribute>
          <xsl:attribute name="role">info</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:Slot name="ResponseAvailableDateTime" MAY be present in the QueryResponse.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="rim:Slot[@name='SpecificationIdentifier' and 'EvidenceResponseIdentifier' and 'IssueDateTime' and 'EvidenceProvider' and 'EvidenceRequester' or 'ResponseAvailableDateTime']" />
      <xsl:otherwise>
        <svrl:failed-assert test="rim:Slot[@name='SpecificationIdentifier' and 'EvidenceResponseIdentifier' and 'IssueDateTime' and 'EvidenceProvider' and 'EvidenceRequester' or 'ResponseAvailableDateTime']">
          <xsl:attribute name="id">R-EDM-RESP-S016</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>A query:QueryResponse MUST not contain any other rim:Slots than SpecificationIdentifier, EvidenceResponseIdentifier, IssueDateTime, EvidenceProvider, EvidenceRequester, rim:RegistryObjectList and optional ResponseAvailableDateTime</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M14" priority="-1" />
  <xsl:template match="@*|node()" mode="M14" priority="-2">
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="query:QueryResponse/rim:Slot[@name='SpecificationIdentifier']/rim:SlotValue" mode="M15" priority="1009">
    <svrl:fired-rule context="query:QueryResponse/rim:Slot[@name='SpecificationIdentifier']/rim:SlotValue" />
    <xsl:variable name="st" select="substring-after(@xsi:type, ':')" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$st ='StringValueType'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$st ='StringValueType'">
          <xsl:attribute name="id">R-EDM-RESP-S017</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:SlotValue of rim:Slot name="SpecificationIdentifier" MUST be of "rim:StringValueType"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="query:QueryResponse/rim:Slot[@name='EvidenceResponseIdentifier']/rim:SlotValue" mode="M15" priority="1008">
    <svrl:fired-rule context="query:QueryResponse/rim:Slot[@name='EvidenceResponseIdentifier']/rim:SlotValue" />
    <xsl:variable name="st" select="substring-after(@xsi:type, ':')" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$st ='StringValueType'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$st ='StringValueType'">
          <xsl:attribute name="id">R-EDM-RESP-S018</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:SlotValue of rim:Slot name="EvidenceResponseIdentifier" MUST be of "rim:StringValueType"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="query:QueryResponse/rim:Slot[@name='IssueDateTime']/rim:SlotValue" mode="M15" priority="1007">
    <svrl:fired-rule context="query:QueryResponse/rim:Slot[@name='IssueDateTime']/rim:SlotValue" />
    <xsl:variable name="st" select="substring-after(@xsi:type, ':')" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$st ='DateTimeValueType'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$st ='DateTimeValueType'">
          <xsl:attribute name="id">R-EDM-RESP-S019</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:SlotValue of rim:Slot name="IssueDateTime" MUST be of "rim:DateTimeValueType"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="query:QueryResponse/rim:Slot[@name='EvidenceProvider']/rim:SlotValue" mode="M15" priority="1006">
    <svrl:fired-rule context="query:QueryResponse/rim:Slot[@name='EvidenceProvider']/rim:SlotValue" />
    <xsl:variable name="st" select="substring-after(@xsi:type, ':')" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$st ='CollectionValueType'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$st ='CollectionValueType'">
          <xsl:attribute name="id">R-EDM-RESP-S020</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:SlotValue of rim:Slot name="EvidenceProvider" MUST be of "rim:CollectionValueType"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="query:QueryRequest/rim:Slot[@name='EvidenceProvider']/rim:SlotValue/rim:Element" mode="M15" priority="1005">
    <svrl:fired-rule context="query:QueryRequest/rim:Slot[@name='EvidenceProvider']/rim:SlotValue/rim:Element" />
    <xsl:variable name="st" select="substring-after(@xsi:type, ':')" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$st ='AnyValueType'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$st ='AnyValueType'">
          <xsl:attribute name="id">R-EDM-REQ-S021</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:Element of rim:SlotValue of rim:Slot name="EvidenceProvider" MUST be of "rim:AnyValueType"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="sdg:Agent" />
      <xsl:otherwise>
        <svrl:failed-assert test="sdg:Agent">
          <xsl:attribute name="id">R-EDM-RESP-S025</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The 'query:QueryResponse/rim:Slot[@name='EvidenceProvider']/rim:SlotValue' MUST use the 'sdg:Agent' of the targetNamespace="http://data.europa.eu/p4s"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="query:QueryResponse/rim:Slot[@name='EvidenceProvider']/rim:SlotValue/sdg:Agent" mode="M15" priority="1004">
    <svrl:fired-rule context="query:QueryResponse/rim:Slot[@name='EvidenceProvider']/rim:SlotValue/sdg:Agent" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="sdg:Identifier and sdg:Name and sdg:Address and sdg:Classification" />
      <xsl:otherwise>
        <svrl:failed-assert test="sdg:Identifier and sdg:Name and sdg:Address and sdg:Classification">
          <xsl:attribute name="id">R-EDM-RESP-S026</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>An EvidenceProvider 'rim:SlotValue/sdg:Agent' MUST not contain any other elements than 'sdg:Identifier' and 'sdg:Name', 'sdg:Address', sdg:Classification. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="query:QueryResponse/rim:Slot[@name='EvidenceRequester']/rim:SlotValue" mode="M15" priority="1003">
    <svrl:fired-rule context="query:QueryResponse/rim:Slot[@name='EvidenceRequester']/rim:SlotValue" />
    <xsl:variable name="st" select="substring-after(@xsi:type, ':')" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$st ='AnyValueType'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$st ='AnyValueType'">
          <xsl:attribute name="id">R-EDM-RESP-S022</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:SlotValue of rim:Slot name="EvidenceRequester" MUST be of "rim:AnyValueType"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="sdg:Agent" />
      <xsl:otherwise>
        <svrl:failed-assert test="sdg:Agent">
          <xsl:attribute name="id">R-EDM-RESP-S027</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The 'query:QueryResponse/rim:Slot[@name='EvidenceRequester']/rim:SlotValue' MUST 'sdg:Agent' of the targetNamespace="http://data.europa.eu/p4s".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="query:QueryResponse/rim:Slot[@name='EvidenceRequester']/rim:SlotValue/sdg:Agent" mode="M15" priority="1002">
    <svrl:fired-rule context="query:QueryResponse/rim:Slot[@name='EvidenceRequester']/rim:SlotValue/sdg:Agent" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="sdg:Identifier and sdg:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="sdg:Identifier and sdg:Name">
          <xsl:attribute name="id">R-EDM-RESP-S028</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>An EvidenceRequester ''rim:SlotValue/sdg:Agent' MUST not contain any other elements than 'sdg:Identifier' and 'sdg:Name'. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="query:QueryResponse/rim:Slot[@name='ResponseAvailableDateTime']/rim:SlotValue" mode="M15" priority="1001">
    <svrl:fired-rule context="query:QueryResponse/rim:Slot[@name='ResponseAvailableDateTime']/rim:SlotValue" />
    <xsl:variable name="st" select="substring-after(@xsi:type, ':')" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$st ='DateTimeValueType'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$st ='DateTimeValueType'">
          <xsl:attribute name="id">R-EDM-RESP-S023</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Slot type value for ResponseAvailableDateTime must be rim:DateTimeValueType</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="query:QueryResponse/rim:Slot[@name='EvidenceMetadata']/rim:SlotValue/sdg:Evidence/sdg:IsConformantTo" mode="M15" priority="1000">
    <svrl:fired-rule context="query:QueryResponse/rim:Slot[@name='EvidenceMetadata']/rim:SlotValue/sdg:Evidence/sdg:IsConformantTo" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="sdg:EvidenceTypeClassification and sdg:Title and sdg:Description" />
      <xsl:otherwise>
        <svrl:failed-assert test="sdg:EvidenceTypeClassification and sdg:Title and sdg:Description">
          <xsl:attribute name="id">R-EDM-RESP-S030</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The class 'IsConformantTo' of 'Evidence' MUST not contain any other elements than 'sdg:EvidenceTypeClassification', 'sdg:Title' and 'sdg:Description'..</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M15" priority="-1" />
  <xsl:template match="@*|node()" mode="M15" priority="-2">
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="query:QueryResponse//rim:RegistryObject" mode="M16" priority="1002">
    <svrl:fired-rule context="query:QueryResponse//rim:RegistryObject" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(child::rim:Slot[@name='EvidenceMetadata'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(child::rim:Slot[@name='EvidenceMetadata'])=1">
          <xsl:attribute name="id">R-EDM-RESP-S015</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:Slot name="EvidenceMetadata" MUST be present in the RegistryObject.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M16" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="query:QueryResponse//rim:RegistryObject/rim:Slot[@name='EvidenceMetadata']/rim:SlotValue" mode="M16" priority="1001">
    <svrl:fired-rule context="query:QueryResponse//rim:RegistryObject/rim:Slot[@name='EvidenceMetadata']/rim:SlotValue" />
    <xsl:variable name="st" select="substring-after(@xsi:type, ':')" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$st ='AnyValueType'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$st ='AnyValueType'">
          <xsl:attribute name="id">R-EDM-RESP-S024</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:SlotValue of rim:Slot name="EvidenceMetadata MUST be of "rim:AnyValueType"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="sdg:Evidence" />
      <xsl:otherwise>
        <svrl:failed-assert test="sdg:Evidence">
          <xsl:attribute name="id">R-EDM-RESP-S029</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The 'query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='EvidenceMetadata']/rim:SlotValue' MUST use the 'sdg:Evidence' of the targetNamespace="http://data.europa.eu/p4s"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M16" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="query:QueryResponse//rim:RepositoryItemRef" mode="M16" priority="1000">
    <svrl:fired-rule context="query:QueryResponse//rim:RepositoryItemRef" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@xlink:href" />
      <xsl:otherwise>
        <svrl:failed-assert test="@xlink:href">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>A repository item reference must contain an xlink:href attribute</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@xlink:href[contains(.,'@')]" />
      <xsl:otherwise>
        <svrl:failed-assert test="@xlink:href[contains(.,'@')]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>A repository item reference must reference a MIME part, so it must contain '@'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@xlink:href[starts-with(.,'cid:')]" />
      <xsl:otherwise>
        <svrl:failed-assert test="@xlink:href[starts-with(.,'cid:')]">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>A repository item reference must reference a MIME part, so it must start with 'cid:'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M16" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M16" priority="-1" />
  <xsl:template match="@*|node()" mode="M16" priority="-2">
    <xsl:apply-templates mode="M16" select="@*|*" />
  </xsl:template>
</xsl:stylesheet>
