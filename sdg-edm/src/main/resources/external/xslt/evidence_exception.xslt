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
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M17" select="/" />
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
          <xsl:attribute name="id">R-EDM-ERR-S001</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Root element of a query response document must be query:QueryResponse</svrl:text>
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
          <xsl:attribute name="id">R-EDM-ERR-S02</xsl:attribute>
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
<xsl:template match="query:QueryResponse/@requestID" mode="M8" priority="1000">
    <svrl:fired-rule context="query:QueryResponse/@requestID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space((.)),'^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$','i')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space((.)),'^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$','i')">
          <xsl:attribute name="id">R-EDM-ERR-S004</xsl:attribute>
          <xsl:attribute name="flag">ERROR</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The 'requestID' attribute of a 'QueryResponse' MUST be unique UUID (RFC 4122) and match the corresponding request.
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
<xsl:template match="query:QueryResponse" mode="M9" priority="1001">
    <svrl:fired-rule context="query:QueryResponse" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure'                  or @status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Unavailable'" />
      <xsl:otherwise>
        <svrl:failed-assert test="@status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure' or @status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Unavailable'">
          <xsl:attribute name="id">R-EDM-ERR-S06</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The 'status' attribute of an unsuccessfull 'query:QueryResponse' MUST be encoded as as 'urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="query:QueryResponse" mode="M9" priority="1000">
    <svrl:fired-rule context="query:QueryResponse" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(rim:RegistryObjectList)=0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(rim:RegistryObjectList)=0">
          <xsl:attribute name="id">R-EDM-ERR-S07</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>An unsuccessful 'query:QueryResponse' does not include a 'rim:RegistryObjectList'.</svrl:text>
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
      <xsl:when test="count(rs:Exception)>0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(rs:Exception)>0">
          <xsl:attribute name="id">R-EDM-ERR-S08</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>An unsuccessful 'query:QueryResponse' includes an Exception</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(rim:Slot[@name='SpecificationIdentifier'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(rim:Slot[@name='SpecificationIdentifier'])=1">
          <xsl:attribute name="id">R-EDM-ERR-S09</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:Slot name=SpecificationIdentifier" MUST be present in the QueryResponse.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(rim:Slot[@name='EvidenceResponseIdentifier'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(rim:Slot[@name='EvidenceResponseIdentifier'])=1">
          <xsl:attribute name="id">R-EDM-ERR-S10</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:Slot name="EvidenceResponseIdentifier" MUST be present in the QueryResponse.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(rim:Slot[@name='EvidenceRequester'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(rim:Slot[@name='EvidenceRequester'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>An OOTS error response must have one EvidenceRequester slot</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(rim:Slot[@name='ErrorProvider'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(rim:Slot[@name='ErrorProvider'])=1">
          <xsl:attribute name="id">R-EDM-ERR-S11</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:Slot name="EvidenceRequester" MUST be present in the QueryResponse.</svrl:text>
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
<xsl:template match="query:QueryResponse/rim:Slot[@name='SpecificationIdentifier']/rim:SlotValue" mode="M11" priority="1004">
    <svrl:fired-rule context="query:QueryResponse/rim:Slot[@name='SpecificationIdentifier']/rim:SlotValue" />
    <xsl:variable name="st" select="substring-after(@xsi:type, ':')" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$st ='StringValueType'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$st ='StringValueType'">
          <xsl:attribute name="id">R-EDM-ERR-S18</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:SlotValue of rim:Slot name="SpecificationIdentifier" MUST be of "rim:StringValueType"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="query:QueryResponse/rim:Slot[@name='EvidenceResponseIdentifier']/rim:SlotValue" mode="M11" priority="1003">
    <svrl:fired-rule context="query:QueryResponse/rim:Slot[@name='EvidenceResponseIdentifier']/rim:SlotValue" />
    <xsl:variable name="st" select="substring-after(@xsi:type, ':')" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$st ='StringValueType'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$st ='StringValueType'">
          <xsl:attribute name="id">R-EDM-ERR-S19</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:SlotValue of rim:Slot name="EvidenceResponseIdentifier" MUST be of "rim:StringValueType"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="query:QueryResponse/rim:Slot[@name='IssueDateTime']/rim:SlotValue" mode="M11" priority="1002">
    <svrl:fired-rule context="query:QueryResponse/rim:Slot[@name='IssueDateTime']/rim:SlotValue" />
    <xsl:variable name="st" select="substring-after(@xsi:type, ':')" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$st ='DateTimeValueType'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$st ='DateTimeValueType'">
          <xsl:attribute name="id">R-EDM-ERR-S22</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:SlotValue of rim:Slot name="Timestamp" MUST be of "rim:DateTimeValueType"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="query:QueryResponse/rim:Slot[@name='EvidenceRequester']/rim:SlotValue" mode="M11" priority="1001">
    <svrl:fired-rule context="query:QueryResponse/rim:Slot[@name='EvidenceRequester']/rim:SlotValue" />
    <xsl:variable name="st" select="substring-after(@xsi:type, ':')" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$st ='AnyValueType'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$st ='AnyValueType'">
          <xsl:attribute name="id">R-EDM-ERR-S021</xsl:attribute>
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
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>An OOTS response EvidenceRequester slot must have one sdg:Agent element.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="query:QueryResponse/rim:Slot[@name='ErrorProvider']/rim:SlotValue" mode="M11" priority="1000">
    <svrl:fired-rule context="query:QueryResponse/rim:Slot[@name='ErrorProvider']/rim:SlotValue" />
    <xsl:variable name="st" select="substring-after(@xsi:type, ':')" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$st ='AnyValueType'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$st ='AnyValueType'">
          <xsl:attribute name="id">R-EDM-ERR-S020</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:SlotValue of rim:Slot name="ErrorProvider" MUST be of "rim:AnyValueType"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="sdg:Agent" />
      <xsl:otherwise>
        <svrl:failed-assert test="sdg:Agent">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>An OOTS response ErrorProvider slot must have one sdg:Agent element.</svrl:text>
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
<xsl:template match="rs:Exception" mode="M12" priority="1000">
    <svrl:fired-rule context="rs:Exception" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(rim:Slot[@name='Timestamp'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(rim:Slot[@name='Timestamp'])=1">
          <xsl:attribute name="id">R-EDM-ERR-S12</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:Slot name="Timestamp" MUST be present in the rs:Exception.</svrl:text>
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
<xsl:template match="rs:Exception[rim:Slot[@name='PreviewMethod']]" mode="M13" priority="1000">
    <svrl:fired-rule context="rs:Exception[rim:Slot[@name='PreviewMethod']]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(rim:Slot[@name='PreviewMethod'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(rim:Slot[@name='PreviewMethod'])=1">
          <xsl:attribute name="id">R-EDM-ERR-S16</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:Slot name="PreviewMethod" MAY be present in the rs:Exception.</svrl:text>
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
<xsl:template match="rs:Exception[rim:Slot[@name='PreviewDescription']]" mode="M14" priority="1000">
    <svrl:fired-rule context="rs:Exception[rim:Slot[@name='PreviewDescription']]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(rim:Slot[@name='PreviewDescription'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(rim:Slot[@name='PreviewDescription'])=1">
          <xsl:attribute name="id">R-EDM-ERR-S15</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:Slot name="PreviewDescription" MAY be present in the rs:Exception.</svrl:text>
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
<xsl:template match="rs:Exception/rim:Slot[@name='PreviewLocation']/rim:SlotValue" mode="M15" priority="1000">
    <svrl:fired-rule context="rs:Exception/rim:Slot[@name='PreviewLocation']/rim:SlotValue" />
    <xsl:variable name="st" select="substring-after(@xsi:type, ':')" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$st ='StringValueType'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$st ='StringValueType'">
          <xsl:attribute name="id">R-EDM-ERR-S23</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:SlotValue of rim:Slot name="PreviewLocation" MUST be of "rim:StringValueType"</svrl:text>
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
<xsl:template match="rs:Exception/rim:Slot[@name='PreviewMethod']/rim:SlotValue" mode="M16" priority="1000">
    <svrl:fired-rule context="rs:Exception/rim:Slot[@name='PreviewMethod']/rim:SlotValue" />
    <xsl:variable name="st" select="substring-after(@xsi:type, ':')" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$st ='StringValueType'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$st ='StringValueType'">
          <xsl:attribute name="id">R-EDM-ERR-S25</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:SlotValue of rim:Slot name="PreviewMethod" MUST be of "rim:StringValueType"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M16" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M16" priority="-1" />
  <xsl:template match="@*|node()" mode="M16" priority="-2">
    <xsl:apply-templates mode="M16" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="rs:Exception/rim:Slot[@name='PreviewDescription']/rim:SlotValue" mode="M17" priority="1000">
    <svrl:fired-rule context="rs:Exception/rim:Slot[@name='PreviewDescription']/rim:SlotValue" />
    <xsl:variable name="st" select="substring-after(@xsi:type, ':')" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$st ='InternationalStringValueType'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$st ='InternationalStringValueType'">
          <xsl:attribute name="id">R-EDM-ERR-S24</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:SlotValue of rim:Slot name="PreviewDescription" MUST be of "rim:InternationalStringValueType"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M17" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M17" priority="-1" />
  <xsl:template match="@*|node()" mode="M17" priority="-2">
    <xsl:apply-templates mode="M17" select="@*|*" />
  </xsl:template>
</xsl:stylesheet>
