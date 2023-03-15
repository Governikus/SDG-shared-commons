<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    
    <sch:ns uri="http://data.europa.eu/p4s" prefix="sdg"/>
    <sch:ns uri="urn:oasis:names:tc:ebxml-regrep:xsd:rs:4.0" prefix="rs"/>
    <sch:ns uri="urn:oasis:names:tc:ebxml-regrep:xsd:rim:4.0" prefix="rim"/>
    <sch:ns uri="urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0" prefix="query"/>
    <sch:ns uri="http://www.w3.org/2001/XMLSchema-instance" prefix="xsi"/>
    <sch:ns uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
    
    <sch:pattern>
        <sch:rule context="/node()">
            <sch:let name="ln" value="local-name(/node())"/>
            <sch:assert test="$ln ='QueryResponse'" id="R-EDM-ERR-S001"
                >Root element of a query response document must be query:QueryResponse</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="/node()">
            <sch:let name="ns" value="namespace-uri(/node())"/>
            <sch:assert test="$ns ='urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0'" id="R-EDM-ERR-S02"
                >The namespace of root element of a 'query:QueryResponse' must be 'urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0'</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="query:QueryResponse/@requestID">
            <sch:assert test="matches(normalize-space((.)),'^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$','i')" 
                flag='ERROR' id="R-EDM-ERR-S004" >
                The 'requestID' attribute of a 'QueryResponse' MUST be unique UUID (RFC 4122) and match the corresponding request.
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    
    <sch:pattern>
        <sch:rule context="query:QueryResponse">
            <sch:assert test="@status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure' 
                or @status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Unavailable'" id="R-EDM-ERR-S06"
                >The 'status' attribute of an unsuccessfull 'query:QueryResponse' MUST be encoded as as 'urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure'.</sch:assert>         
        </sch:rule>
        <sch:rule context="query:QueryResponse">
            <sch:assert test="count(rim:RegistryObjectList)=0" id="R-EDM-ERR-S07"
                >An unsuccessful 'query:QueryResponse' does not include a 'rim:RegistryObjectList'.</sch:assert>         
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="query:QueryResponse">
            <sch:assert test="count(rs:Exception)>0" id="R-EDM-ERR-S08"
                >An unsuccessful 'query:QueryResponse' includes an Exception</sch:assert>
            <sch:assert test="count(rim:Slot[@name='SpecificationIdentifier'])=1" id="R-EDM-ERR-S09"
                >The rim:Slot name=SpecificationIdentifier" MUST be present in the QueryResponse.</sch:assert>
            <sch:assert test="count(rim:Slot[@name='EvidenceResponseIdentifier'])=1" id="R-EDM-ERR-S10"
                >The rim:Slot name="EvidenceResponseIdentifier" MUST be present in the QueryResponse.</sch:assert>
            <sch:assert test="count(rim:Slot[@name='EvidenceRequester'])=1"
                >An OOTS error response must have one EvidenceRequester slot</sch:assert>
            <sch:assert test="count(rim:Slot[@name='ErrorProvider'])=1" id="R-EDM-ERR-S11"
                >The rim:Slot name="EvidenceRequester" MUST be present in the QueryResponse.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:rule context="query:QueryResponse/rim:Slot[@name='SpecificationIdentifier']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='StringValueType'" id="R-EDM-ERR-S18"
                >The rim:SlotValue of rim:Slot name="SpecificationIdentifier" MUST be of "rim:StringValueType"</sch:assert>
        </sch:rule>
        <sch:rule context="query:QueryResponse/rim:Slot[@name='EvidenceResponseIdentifier']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='StringValueType'" id="R-EDM-ERR-S19"
                >The rim:SlotValue of rim:Slot name="EvidenceResponseIdentifier" MUST be of "rim:StringValueType"</sch:assert>
        </sch:rule>
        <sch:rule context="query:QueryResponse/rim:Slot[@name='IssueDateTime']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='DateTimeValueType'" id="R-EDM-ERR-S22"
                >The rim:SlotValue of rim:Slot name="Timestamp" MUST be of "rim:DateTimeValueType"</sch:assert>
        </sch:rule>
        <sch:rule context="query:QueryResponse/rim:Slot[@name='EvidenceRequester']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='AnyValueType'" id="R-EDM-ERR-S021"
                >The rim:SlotValue of rim:Slot name="EvidenceRequester" MUST be of "rim:AnyValueType"</sch:assert>
            <sch:assert test="sdg:Agent"
                >An OOTS response EvidenceRequester slot must have one sdg:Agent element.</sch:assert>
        </sch:rule>
        <sch:rule context="query:QueryResponse/rim:Slot[@name='ErrorProvider']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='AnyValueType'" id="R-EDM-ERR-S020"
                >The rim:SlotValue of rim:Slot name="ErrorProvider" MUST be of "rim:AnyValueType"</sch:assert>
            <sch:assert test="sdg:Agent"
                >An OOTS response ErrorProvider slot must have one sdg:Agent element.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="rs:Exception">
            <sch:assert test="count(rim:Slot[@name='Timestamp'])=1" id="R-EDM-ERR-S12"
                >The rim:Slot name="Timestamp" MUST be present in the rs:Exception.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- PreviewDescription and PreviewLocation are only present when PreviewLocation is present -->
    
    <sch:pattern>
        <sch:rule context="rs:Exception[rim:Slot[@name='PreviewMethod']]">
            <sch:assert test="count(rim:Slot[@name='PreviewMethod'])=1" id="R-EDM-ERR-S16"
                >The rim:Slot name="PreviewMethod" MAY be present in the rs:Exception.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="rs:Exception[rim:Slot[@name='PreviewDescription']]">
            <sch:assert test="count(rim:Slot[@name='PreviewDescription'])=1" id="R-EDM-ERR-S15"
                >The rim:Slot name="PreviewDescription" MAY be present in the rs:Exception.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- Data types for Exception slot values-->
    
    <sch:pattern>
        <sch:rule context="rs:Exception/rim:Slot[@name='PreviewLocation']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='StringValueType'" id="R-EDM-ERR-S23"
                >The rim:SlotValue of rim:Slot name="PreviewLocation" MUST be of "rim:StringValueType"</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="rs:Exception/rim:Slot[@name='PreviewMethod']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='StringValueType'" id="R-EDM-ERR-S25"
                >The rim:SlotValue of rim:Slot name="PreviewMethod" MUST be of "rim:StringValueType"</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="rs:Exception/rim:Slot[@name='PreviewDescription']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='InternationalStringValueType'" id="R-EDM-ERR-S24"
                >The rim:SlotValue of rim:Slot name="PreviewDescription" MUST be of "rim:InternationalStringValueType"</sch:assert>
        </sch:rule>
    </sch:pattern>
    
</sch:schema>