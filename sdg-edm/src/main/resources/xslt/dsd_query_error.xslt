<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:query="urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0" xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:4.0" xmlns:rs="urn:oasis:names:tc:ebxml-regrep:xsd:rs:4.0" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:sdg="http://data.europa.eu/p4s" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
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
        <xsl:variable name="p_1" select="1+    count(preceding-sibling::*[name()=name(current())])" />
        <xsl:if test="$p_1>1 or following-sibling::*[name()=name(current())]">[<xsl:value-of select="$p_1" />]</xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>*[local-name()='</xsl:text>
        <xsl:value-of select="local-name()" />
        <xsl:text>']</xsl:text>
        <xsl:variable name="p_2" select="1+   count(preceding-sibling::*[local-name()=local-name(current())])" />
        <xsl:if test="$p_2>1 or following-sibling::*[local-name()=local-name(current())]">[<xsl:value-of select="$p_2" />]</xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="@*" mode="schematron-get-full-path">
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
          <xsl:attribute name="id">R-DSD-ERR-S001</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Root element of a query response document must be QueryResponse</svrl:text>
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
          <xsl:attribute name="id">R-DSD-ERR-S002</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The namespace of root element of a query response document must be 'urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0'</svrl:text>
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
<xsl:template match="query:QueryResponse" mode="M8" priority="1000">
    <svrl:fired-rule context="query:QueryResponse" />
    <xsl:variable name="status" select="@status" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$status = 'urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$status = 'urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure'">
          <xsl:attribute name="id">R-DSD-RESP-S006</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The 'status' attribute of an unsuccessfull 'query:QueryResponse' MUST be encoded as as 'urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure'..</svrl:text>
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
<xsl:template match="query:QueryResponse[@status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure']" mode="M9" priority="1001">
    <svrl:fired-rule context="query:QueryResponse[@status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(rim:RegistryObjectList) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(rim:RegistryObjectList) = 0">
          <xsl:attribute name="id">R-DSD-RESP-S007</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>An unsuccessful 'query:QueryResponse' does not include a 'rim:RegistryObjectList'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="query:QueryResponse[@status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure']" mode="M9" priority="1000">
    <svrl:fired-rule context="query:QueryResponse[@status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(rs:Exception)>0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(rs:Exception)>0">
          <xsl:attribute name="id">R-DSD-RESP-S008</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>An unsuccessful 'query:QueryResponse' includes an Exception</svrl:text>
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
<xsl:template match="query:QueryResponse[@status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure']" mode="M10" priority="1000">
    <svrl:fired-rule context="query:QueryResponse[@status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure']" />
    <xsl:variable name="rs_present" select="count(rs:Exception)" />
    <xsl:variable name="slot_number" select="count(rim:Slot)" />

		<!--REPORT error-->
<xsl:if test="$rs_present=0 and $slot_number>0">
      <svrl:successful-report test="$rs_present=0 and $slot_number>0">
        <xsl:attribute name="id">R-DSD-RESP-S009</xsl:attribute>
        <xsl:attribute name="role">error</xsl:attribute>
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>An unsuccessfull 'query:QueryResponse' which does not contain the rs:Exception xsi:type='rs:ObjectNotFoundExceptionType' (DSD:ERR:0005) MUST not contain any rim:Slots.</svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M10" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M10" priority="-1" />
  <xsl:template match="@*|node()" mode="M10" priority="-2">
    <xsl:apply-templates mode="M10" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="query:QueryResponse/rs:Exception" mode="M11" priority="1000">
    <svrl:fired-rule context="query:QueryResponse/rs:Exception" />

		<!--ASSERT info-->
<xsl:choose>
      <xsl:when test="count(child::rim:Slot[@name='JurisdictionDetermination'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(child::rim:Slot[@name='JurisdictionDetermination'])=1">
          <xsl:attribute name="id">R-DSD-RESP-S011</xsl:attribute>
          <xsl:attribute name="role">info</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>An unsuccessful 'query:QueryResponse' containing the rs:Exception xsi:type='rs:ObjectNotFoundExceptionType' (DSD:ERR:0005) MAY contain rim:Slot name="JurisdictionDetermination" requesting additional user.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT info-->
<xsl:choose>
      <xsl:when test="count(child::rim:Slot[@name='UserRequestedClassificationConcepts'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(child::rim:Slot[@name='UserRequestedClassificationConcepts'])=1">
          <xsl:attribute name="id">R-DSD-RESP-S012</xsl:attribute>
          <xsl:attribute name="role">info</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>An unsuccessful 'query:QueryResponse' containing the rs:Exception xsi:type='rs:ObjectNotFoundExceptionType' (DSD:ERR:0005) MAY contain a  rim:Slot name="UserRequestedClassificationConcepts" requesting additional user provided attributes.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT info-->
<xsl:choose>
      <xsl:when test="count(child::rim:Slot[@name='DataServiceEvidenceType'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(child::rim:Slot[@name='DataServiceEvidenceType'])=1">
          <xsl:attribute name="id">R-DSD-RESP-S013</xsl:attribute>
          <xsl:attribute name="role">info</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>An unsuccessful 'query:QueryResponse' containing the rs:Exception xsi:type='rs:ObjectNotFoundExceptionType' (DSD:ERR:0005) MUST contain  rim:Slot name="DataServiceEvidenceType" requesting additional user provided attributes.</svrl:text>
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
<xsl:template match="query:QueryResponse/rs:Exception/rim:Slot[@name='JurisdictionDetermination']/rim:SlotValue" mode="M12" priority="1007">
    <svrl:fired-rule context="query:QueryResponse/rs:Exception/rim:Slot[@name='JurisdictionDetermination']/rim:SlotValue" />
    <xsl:variable name="st" select="substring-after(@xsi:type, ':')" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$st ='AnyValueType'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$st ='AnyValueType'">
          <xsl:attribute name="id">R-EDM-REQ-S014</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:SlotValue of rim:Slot name="JurisdictionDetermination" MUST be of "rim:AnyValueType"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="query:QueryResponse/rs:Exception/rim:Slot[@name='UserRequestedClassificationConcepts']/rim:SlotValue" mode="M12" priority="1006">
    <svrl:fired-rule context="query:QueryResponse/rs:Exception/rim:Slot[@name='UserRequestedClassificationConcepts']/rim:SlotValue" />
    <xsl:variable name="st" select="substring-after(@xsi:type, ':')" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$st ='CollectionValueType'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$st ='CollectionValueType'">
          <xsl:attribute name="id">R-EDM-REQ-S015</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:SlotValue of rim:Slot name="UserRequestedClassificationConcepts" MUST be of "rim:CollectionValueType"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="query:QueryResponse/rs:Exception/rim:Slot[@name='UserRequestedClassificationConcepts']/rim:SlotValue/rim:Element" mode="M12" priority="1005">
    <svrl:fired-rule context="query:QueryResponse/rs:Exception/rim:Slot[@name='UserRequestedClassificationConcepts']/rim:SlotValue/rim:Element" />
    <xsl:variable name="st" select="substring-after(@xsi:type, ':')" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$st ='AnyValueType'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$st ='AnyValueType'">
          <xsl:attribute name="id">R-EDM-REQ-S016</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:Element of rim:SlotValue of rim:Slot name="UserRequestedClassificationConcepts" MUST be of "rim:AnyValueType"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="query:QueryResponse/rs:Exception/rim:Slot[@name='UserRequestedClassificationConcepts']/rim:SlotValue" mode="M12" priority="1004">
    <svrl:fired-rule context="query:QueryResponse/rs:Exception/rim:Slot[@name='UserRequestedClassificationConcepts']/rim:SlotValue" />
    <xsl:variable name="st" select="substring-after(@xsi:type, ':')" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$st ='AnyValueType'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$st ='AnyValueType'">
          <xsl:attribute name="id">R-EDM-REQ-S017</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The rim:SlotValue of rim:Slot name="DataServiceEvidenceType" MUST be of "rim:AnyValueType"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="query:QueryResponse/rs:Exception/rim:Slot[@name='DataServiceEvidenceType']/rim:SlotValue" mode="M12" priority="1003">
    <svrl:fired-rule context="query:QueryResponse/rs:Exception/rim:Slot[@name='DataServiceEvidenceType']/rim:SlotValue" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="sdg:DataServiceEvidenceType" />
      <xsl:otherwise>
        <svrl:failed-assert test="sdg:DataServiceEvidenceType">
          <xsl:attribute name="id">R-EDM-REQ-S018</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The query:QueryResponse/rs:Exception/rim:Slot[@name='DataServiceEvidenceType'] MUST contain one 'sdg:DataServiceEvidenceType' of the targetNamespace="http://data.europa.eu/p4s"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="query:QueryResponse/rs:Exception/rim:Slot[@name='UserRequestedClassificationConcepts']/rim:SlotValue" mode="M12" priority="1002">
    <svrl:fired-rule context="query:QueryResponse/rs:Exception/rim:Slot[@name='UserRequestedClassificationConcepts']/rim:SlotValue" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="sdg:EvidenceProviderClassification" />
      <xsl:otherwise>
        <svrl:failed-assert test="sdg:EvidenceProviderClassification">
          <xsl:attribute name="id">R-EDM-REQ-S019</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The query:QueryResponse/rs:Exception/rim:Slot[@name='UserRequestedClassificationConcepts' MUST contain the 'sdg:EvidenceProviderClassification' of the targetNamespace="http://data.europa.eu/p4s"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="query:QueryResponse/rs:Exception/rim:Slot[@name='JurisdictionDetermination']/rim:SlotValue" mode="M12" priority="1001">
    <svrl:fired-rule context="query:QueryResponse/rs:Exception/rim:Slot[@name='JurisdictionDetermination']/rim:SlotValue" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="sdg:JurisdictionDetermination" />
      <xsl:otherwise>
        <svrl:failed-assert test="sdg:JurisdictionDetermination">
          <xsl:attribute name="id">R-EDM-REQ-S020</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The query:QueryResponse/rs:Exception/rim:Slot[@name='JurisdictionDetermination' MUST contain one 'sdg:JurisdictionDetermination' of the targetNamespace="http://data.europa.eu/p4s"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="query:QueryResponse/rs:Exception/rim:Slot[@name='DataServiceEvidenceType']/rim:SlotValue/sdg:DataServiceEvidenceType" mode="M12" priority="1000">
    <svrl:fired-rule context="query:QueryResponse/rs:Exception/rim:Slot[@name='DataServiceEvidenceType']/rim:SlotValue/sdg:DataServiceEvidenceType" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="sdg:Identifier and sdg:EvidenceTypeClassification and sdg:Title and sdg:Description" />
      <xsl:otherwise>
        <svrl:failed-assert test="sdg:Identifier and sdg:EvidenceTypeClassification and sdg:Title and sdg:Description">
          <xsl:attribute name="id">R-EDM-REQ-S021</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> A DataServiceEvidenceType 'rim:Slot[@name='DataServiceEvidenceType'/rim:SlotValue/sdg:DataServiceEvidenceType' MUST not contain any other elements than 'sdg:Identifier', 'sdg:EvidenceTypeClassification', 'sdg:Title' and 'sdg:Description'.</svrl:text>
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
<xsl:template match="rs:Exception[@code='DSD:ERR:0005']/rim:Slot[@name='UserRequestedClassificationConcepts']/rim:SlotValue/rim:Element/sdg:EvidenceProviderClassification" mode="M13" priority="1000">
    <svrl:fired-rule context="rs:Exception[@code='DSD:ERR:0005']/rim:Slot[@name='UserRequestedClassificationConcepts']/rim:SlotValue/rim:Element/sdg:EvidenceProviderClassification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(sdg:SupportedValue)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(sdg:SupportedValue)">
          <xsl:attribute name="id">R-DSD-RESP-S022</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>An EvidenceProviderClassification 'rim:Slot[@name='rim:Slot[@name='UserRequestedClassificationConcepts'/rim:SlotValue/rim:Element/sdg:EvidenceProviderClassification' MUST not contain 'SupportedValue'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M13" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M13" priority="-1" />
  <xsl:template match="@*|node()" mode="M13" priority="-2">
    <xsl:apply-templates mode="M13" select="@*|*" />
  </xsl:template>
</xsl:stylesheet>
