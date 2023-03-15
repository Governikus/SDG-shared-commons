<?xml version="1.0" encoding="UTF-8"?>
<sch:schema 
    xmlns:sch="http://purl.oclc.org/dsdl/schematron" >
    
    <sch:ns uri="http://data.europa.eu/p4s" prefix="sdg"/>
    <sch:ns uri="urn:oasis:names:tc:ebxml-regrep:xsd:rs:4.0" prefix="rs"/>
    <sch:ns uri="urn:oasis:names:tc:ebxml-regrep:xsd:rim:4.0" prefix="rim"/>
    <sch:ns uri="urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0" prefix="query"/>
    <sch:ns uri="http://www.w3.org/2001/XMLSchema-instance" prefix="xsi"/>
    <sch:ns uri="http://www.w3.org/1999/xlink" prefix="xlink"/>

    <sch:pattern>
        <sch:rule context="/node()">
            <sch:let name="ln" value="local-name(/node())"/>
            <sch:assert test="$ln ='QueryResponse'" id="R-DSD-ERR-S001" 
                >Root element of a query response document must be QueryResponse</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:rule context="/node()">
            <sch:let name="ns" value="namespace-uri(/node())"/>
            <sch:assert test="$ns ='urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0'" id="R-DSD-ERR-S002"
                >The namespace of root element of a query response document must be 'urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0'</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="query:QueryResponse">
            <sch:let name="status" value="@status" />
            <sch:assert test="$status = 'urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure'" id="R-DSD-RESP-S006"
                >The 'status' attribute of an unsuccessfull 'query:QueryResponse' MUST be encoded as as 'urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure'..</sch:assert>
        </sch:rule>
    </sch:pattern>
    

    <sch:pattern>
        <!-- 
            If Response is Success there is only a RegistryObjectList 
            If Response is Failure then there is only an Exception 
        -->
        <sch:rule context="query:QueryResponse[@status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure']">
            <sch:assert test="count(rim:RegistryObjectList) = 0" id="R-DSD-RESP-S007"
                >An unsuccessful 'query:QueryResponse' does not include a 'rim:RegistryObjectList'</sch:assert>
        </sch:rule> 
         <sch:rule context="query:QueryResponse[@status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure']">
            <sch:assert test="count(rs:Exception)>0" id="R-DSD-RESP-S008"
                >An unsuccessful 'query:QueryResponse' includes an Exception</sch:assert>
         </sch:rule> 
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="query:QueryResponse[@status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure']">
            <sch:let name="rs_present" value="count(rs:Exception)"/> 
            <sch:let name="slot_number" value="count(rim:Slot)"/>   
            <sch:report test="$rs_present=0 and $slot_number>0" role="error" id="R-DSD-RESP-S009">An unsuccessfull 'query:QueryResponse' which does not contain the rs:Exception xsi:type='rs:ObjectNotFoundExceptionType' (DSD:ERR:0005) MUST not contain any rim:Slots.</sch:report>
        </sch:rule>       
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="query:QueryResponse/rs:Exception">
            <sch:assert test="count(child::rim:Slot[@name='JurisdictionDetermination'])=1" id="R-DSD-RESP-S011" role="info"
                >An unsuccessful 'query:QueryResponse' containing the rs:Exception xsi:type='rs:ObjectNotFoundExceptionType' (DSD:ERR:0005) MAY contain rim:Slot name="JurisdictionDetermination" requesting additional user.</sch:assert>     
            <sch:assert test="count(child::rim:Slot[@name='UserRequestedClassificationConcepts'])=1" id="R-DSD-RESP-S012" role="info"
                >An unsuccessful 'query:QueryResponse' containing the rs:Exception xsi:type='rs:ObjectNotFoundExceptionType' (DSD:ERR:0005) MAY contain a  rim:Slot name="UserRequestedClassificationConcepts" requesting additional user provided attributes.</sch:assert>
            <sch:assert test="count(child::rim:Slot[@name='DataServiceEvidenceType'])=1" id="R-DSD-RESP-S013" role="info"
                >An unsuccessful 'query:QueryResponse' containing the rs:Exception xsi:type='rs:ObjectNotFoundExceptionType' (DSD:ERR:0005) MUST contain  rim:Slot name="DataServiceEvidenceType" requesting additional user provided attributes.</sch:assert>
        </sch:rule>  
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="query:QueryResponse/rs:Exception/rim:Slot[@name='JurisdictionDetermination']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='AnyValueType'" id="R-EDM-REQ-S014"
                >The rim:SlotValue of rim:Slot name="JurisdictionDetermination" MUST be of "rim:AnyValueType"</sch:assert>
        </sch:rule>
        <sch:rule context="query:QueryResponse/rs:Exception/rim:Slot[@name='UserRequestedClassificationConcepts']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='CollectionValueType'" id="R-EDM-REQ-S015"
                >The rim:SlotValue of rim:Slot name="UserRequestedClassificationConcepts" MUST be of "rim:CollectionValueType"</sch:assert>
        </sch:rule>  
        <sch:rule context="query:QueryResponse/rs:Exception/rim:Slot[@name='UserRequestedClassificationConcepts']/rim:SlotValue/rim:Element">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='AnyValueType'" id="R-EDM-REQ-S016"
                >The rim:Element of rim:SlotValue of rim:Slot name="UserRequestedClassificationConcepts" MUST be of "rim:AnyValueType"</sch:assert>
        </sch:rule>  
        <sch:rule context="query:QueryResponse/rs:Exception/rim:Slot[@name='UserRequestedClassificationConcepts']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='AnyValueType'" id="R-EDM-REQ-S017"
                >The rim:SlotValue of rim:Slot name="DataServiceEvidenceType" MUST be of "rim:AnyValueType"</sch:assert>
        </sch:rule> 
        <sch:rule context="query:QueryResponse/rs:Exception/rim:Slot[@name='DataServiceEvidenceType']/rim:SlotValue">
            <sch:assert test="sdg:DataServiceEvidenceType" id="R-EDM-REQ-S018"
                >The query:QueryResponse/rs:Exception/rim:Slot[@name='DataServiceEvidenceType'] MUST contain one 'sdg:DataServiceEvidenceType' of the targetNamespace="http://data.europa.eu/p4s"</sch:assert>
        </sch:rule> 
        <sch:rule context="query:QueryResponse/rs:Exception/rim:Slot[@name='UserRequestedClassificationConcepts']/rim:SlotValue">
            <sch:assert test="sdg:EvidenceProviderClassification" id="R-EDM-REQ-S019"
                >The query:QueryResponse/rs:Exception/rim:Slot[@name='UserRequestedClassificationConcepts' MUST contain the 'sdg:EvidenceProviderClassification' of the targetNamespace="http://data.europa.eu/p4s"</sch:assert>
        </sch:rule> 
        <sch:rule context="query:QueryResponse/rs:Exception/rim:Slot[@name='JurisdictionDetermination']/rim:SlotValue">
            <sch:assert test="sdg:JurisdictionDetermination" id="R-EDM-REQ-S020"
                >The query:QueryResponse/rs:Exception/rim:Slot[@name='JurisdictionDetermination' MUST contain one 'sdg:JurisdictionDetermination' of the targetNamespace="http://data.europa.eu/p4s"</sch:assert>
        </sch:rule> 
        
        <sch:rule context="query:QueryResponse/rs:Exception/rim:Slot[@name='DataServiceEvidenceType']/rim:SlotValue/sdg:DataServiceEvidenceType">
            <sch:assert test="sdg:Identifier and sdg:EvidenceTypeClassification and sdg:Title and sdg:Description" id="R-EDM-REQ-S021"
                > A DataServiceEvidenceType 'rim:Slot[@name='DataServiceEvidenceType'/rim:SlotValue/sdg:DataServiceEvidenceType' MUST not contain any other elements than 'sdg:Identifier', 'sdg:EvidenceTypeClassification', 'sdg:Title' and 'sdg:Description'.</sch:assert>
        </sch:rule> 
       
        
    </sch:pattern>
   
    <sch:pattern>
        <sch:rule context="rs:Exception[@code='DSD:ERR:0005']/rim:Slot[@name='UserRequestedClassificationConcepts']/rim:SlotValue/rim:Element/sdg:EvidenceProviderClassification">
            <sch:assert test="not(sdg:SupportedValue)" id="R-DSD-RESP-S022"
                >An EvidenceProviderClassification 'rim:Slot[@name='rim:Slot[@name='UserRequestedClassificationConcepts'/rim:SlotValue/rim:Element/sdg:EvidenceProviderClassification' MUST not contain 'SupportedValue'.</sch:assert>
        </sch:rule> 
    </sch:pattern>
   
</sch:schema>