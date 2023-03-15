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
            <sch:assert test="$ln ='QueryResponse'" id="R-DSD-RESP-S001"
                >Root element of a query response document must be QueryResponse</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:rule context="/node()">
            <sch:let name="ns" value="namespace-uri(/node())"/>
            <sch:assert test="$ns ='urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0'" id="R-DSD-RESP-S002"
                >The namespace of root element of a query response document must be 'urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0'</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="query:QueryResponse">
            <sch:let name="status" value="@status" />
            <sch:assert test="$status = 'urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success'" id="R-DSD-RESP-S006"
                >The 'status' attribute of a successfull 'QueryResponse' MUST be encoded as as 'urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success'.</sch:assert>
        </sch:rule>
    </sch:pattern>
    

    <sch:pattern>
        <!-- 
            If Response is Success there is only a RegistryObjectList 
            If Response is Failure then there is only an Exception 
        -->
        <sch:rule context="query:QueryResponse[
            @status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success']">
            <sch:assert test="count(rim:RegistryObjectList) = 1" id="R-DSD-RESP-S007"
                >A successful QueryResponse includes a RegistryObjectList</sch:assert>
            <sch:assert test="count(rs:Exception) = 0" id="R-DSD-RESP-S008"
                >A successful QueryResponse does not include an Exception</sch:assert>
        </sch:rule>       
        <sch:rule context="query:QueryResponse[
            @status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure']">
            <sch:assert test="count(rim:RegistryObjectList) = 0"
                >An unsuccessful OOTS response does not include a RegistryObjectList</sch:assert>
            <sch:assert test="count(rs:Exception) = 1"
                >An unsuccessful OOTS response includes an Exception</sch:assert>
        </sch:rule>       
    </sch:pattern>
    
    
    <sch:pattern>
        <sch:rule context="rim:RegistryObject">
            <sch:assert test="rim:Slot[@name='DataServiceEvidenceType']" id="R-DSD-RESP-S009"
                >The rim:Slot name="DataServiceEvidenceType" MUST be present in the QueryResponse.</sch:assert>
            <sch:assert test="count(rim:Slot) = 1" 
                >A registry object in a DSD response must contain one and only one Slot</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="rim:RegistryObject/rim:Slot[@name='DataServiceEvidenceType']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='AnyValueType'" id="R-DSD-RESP-S010"
                >The rim:SlotValue of rim:Slot name="DataServiceEvidenceType" MUST be of "rim:AnyValueType"</sch:assert>
            <sch:assert test="count(sdg:DataServiceEvidenceType)=1" id="R-DSD-RESP-S011"
                >A  'rim:Slot[@name='DataServiceEvidenceType'/rim:SlotValue/sdg:DataServiceEvidenceType' MUST contain one sdg:DataServiceEvidenceType of the targetNamespace="http://data.europa.eu/p4s"</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    
    <sch:pattern>
        <sch:rule context="rs:Exception[@code='DSD:ERR:0005']">
            <sch:assert test="rim:Slot[@name='JurisdictionDetermination'] or rim:Slot[@name='UserRequestedClassificationConcepts']"
                >DSD dialog feature exception contains jurisdiction determination or classfication concept slots</sch:assert>
            <sch:assert test="rim:Slot[@name='DataServiceEvidenceType']"
                >DSD dialog feature exception contains a DataServiceEvidenceType slot</sch:assert>
        </sch:rule>
    </sch:pattern>


    <sch:pattern>
        <sch:rule context="rs:Exception[@code='DSD:ERR:0005']/rim:Slot[@name='JurisdictionDetermination']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='AnyValueType'"
                >Slot type value for EvidenceProvider must be rim:AnyValueType</sch:assert>
            <sch:assert test="sdg:EvidenceProviderJurisdictionDetermination"
                >An DSD JurisdictionDetermination slot must have sdg:EvidenceProviderJurisdictionDetermination content.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    
    <sch:pattern>
        <sch:rule context="rs:Exception[@code='DSD:ERR:0005']/rim:Slot[@name='UserRequestedClassificationConcepts']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='CollectionValueType'"
                >Slot type value for EvidenceProvider must be rim:CollectionValueType</sch:assert>
            <sch:assert test="rim:Element">A UserRequestedClassificationConcepts slot contains elements</sch:assert>
            <sch:assert test="rim:Element/sdg:EvidenceProviderClassification"
                >An DSD UserRequestedClassificationConcepts slot must have a sdg:EvidenceProviderClassification content.</sch:assert>
        </sch:rule> 
    </sch:pattern>
    
    
    
   
</sch:schema>