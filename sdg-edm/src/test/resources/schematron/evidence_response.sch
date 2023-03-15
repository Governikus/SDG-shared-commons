<?xml version="1.0" encoding="UTF-8"?>
<sch:schema 
    xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    
    <sch:ns uri="http://data.europa.eu/p4s" prefix="sdg"/>
    <sch:ns uri="urn:oasis:names:tc:ebxml-regrep:xsd:rs:4.0" prefix="rs"/>
    <sch:ns uri="urn:oasis:names:tc:ebxml-regrep:xsd:rim:4.0" prefix="rim"/>
    <sch:ns uri="urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0" prefix="query"/>
    <sch:ns uri="http://www.w3.org/2001/XMLSchema-instance" prefix="xsi"/>
    <sch:ns uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
    
    <sch:pattern>
        <sch:rule context="/node()">
            <sch:let name="ln" value="local-name(/node())"/>
            <sch:assert test="$ln ='QueryResponse'" id="R-EDM-RESP-S001"
                >The root element of a query response document MUST be 'query:QueryResponse'</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="/node()">
            <sch:let name="ns" value="namespace-uri(/node())"/>
            <sch:assert test="$ns ='urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0'" id="R-EDM-RESP-S002"
                >The namespace of root element of a 'query:QueryResponse' must be 'urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0'</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="query:QueryResponse/@requestId">
            <sch:assert test="matches(normalize-space((.)),'^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$','i')" 
                flag='ERROR' id="R-EDM-RESP-S004" >
                The 'requestId' attribute of a 'QueryResponse' MUST be unique UUID (RFC 4122) and match the corresponding request.
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="query:QueryResponse">
            <sch:assert test="@requestId" id="R-EDM-RESP-S031" >
                The 'RequestId' attribute of a 'QueryResponse' MUST be present.
            </sch:assert>
            <sch:assert test="@status" id="R-EDM-RESP-S032" >
                The 'status' attribute of a 'QueryResponse' MUST be present. 
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="query:QueryResponse">
            <sch:assert test="@status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success' 
                or @status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Unavailable'" id="R-EDM-RESP-S006"
                >The 'status attribute of a 'QueryResponse' MUST be encoded as "urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success" for successful responses or as "urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Unavailable" for responses that will be available at a later time .</sch:assert>         
        </sch:rule>
    </sch:pattern>
    
    
    
    <sch:pattern>
        <!-- 
            If Response is Success RegistryObjectList must be non-empty and should include rim:RepositoryItemRef
        -->
        <sch:rule context="query:QueryResponse[@status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success']/rim:RegistryObjectList">
            <sch:assert test="count(rim:RegistryObject) > 0" id="R-EDM-RESP-S007"
                >An successful 'query:QueryResponse' includes a 'rim:RegistryObjectList'                
            </sch:assert>
            
        </sch:rule>    
        <sch:rule context="query:QueryResponse[@status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success']/rim:RegistryObjectList/rim:RegistryObject">
            <sch:assert test="rim:RepositoryItemRef" id="R-EDM-RESP-S033" 
                >The 'rim:RepositoryItemRef' of a 'rim:RegistryObject' MUST be present.               
            </sch:assert> 
            
            <sch:assert test="@id" id="R-EDM-RESP-S036" 
                >The 'id' attribute of a 'RegistryObject' MUST be present.             
            </sch:assert> 
        </sch:rule>   
    </sch:pattern>
    
    <sch:pattern>
        <!-- 
           rim:RegistryObject/rim:RepositoryItemRef should include @xlink:href and @xlink:title attributes
        -->
        <sch:rule context="query:QueryResponse[@status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success']/rim:RegistryObjectList/rim:RegistryObject/rim:RespositoryItemRef">
            <sch:assert test="@xlink:href" id="R-EDM-RESP-S034"
                >The 'xlink:href' attribute of 'RepositoryItemRef' MUST be present.             
            </sch:assert>
            <sch:assert test="@xlink:title" id="R-EDM-RESP-S035"
                >The 'xlink:title' attribute of 'RepositoryItemRef' MUST be present.          
            </sch:assert> 
        </sch:rule>       
    </sch:pattern>
    
    <sch:pattern>
        <!-- 
            If Response is Success RegistryObjectList must be non-empty
        -->
        <sch:rule context="query:QueryResponse/rs:Exception">
            <sch:assert test="count(rs:Exception) > 0"  id="R-EDM-RESP-S008"
                >A successful 'query:QueryResponse' does not include an Exception                
            </sch:assert>
        </sch:rule>       
    </sch:pattern>
    
    
    <sch:pattern >
        <sch:rule context="query:QueryResponse">
            
            <sch:assert test="count(child::rim:Slot[@name='SpecificationIdentifier'])=1" id="R-EDM-RESP-S009"
                >The rim:Slot name="SpecificationIdentifier" MUST be present in the QueryResponse.</sch:assert>
            
            <sch:assert test="count(child::rim:Slot[@name='EvidenceResponseIdentifier'])=1" id="R-EDM-RESP-S010"
                >The rim:Slot name="EvidenceResponseIdentifier" MUST be present in the QueryResponse.</sch:assert>
            
            <sch:assert test="count(child::rim:Slot[@name='IssueDateTime'])=1" id="R-EDM-RESP-S011"
                >The rim:Slot name="IssueDateTime" MUST be present  in the QueryResponse.</sch:assert>
            
            <sch:assert test="count(child::rim:Slot[@name='EvidenceProvider'])=1" id="R-EDM-RESP-S012"
                >The rim:Slot name="EvidenceProvider" MUST be present in the QueryResponse.</sch:assert>
            
            <sch:assert test="count(child::rim:Slot[@name='EvidenceRequester'])=1" id="R-EDM-RESP-S013"
                >The rim:Slot name="EvidenceRequester" MUST be present in the QueryResponse.</sch:assert>
            
            <sch:assert test="count(child::rim:Slot[@name='ResponseAvailableDateTime'])&lt;2" role="info" id="R-EDM-RESP-S014"
                >The rim:Slot name="ResponseAvailableDateTime" MAY be present in the QueryResponse.</sch:assert>
            <sch:assert test="rim:Slot[@name='SpecificationIdentifier' and 'EvidenceResponseIdentifier' and 'IssueDateTime' and 'EvidenceProvider' and 'EvidenceRequester' or 'ResponseAvailableDateTime']" id="R-EDM-RESP-S016"
                >A query:QueryResponse MUST not contain any other rim:Slots than SpecificationIdentifier, EvidenceResponseIdentifier, IssueDateTime, EvidenceProvider, EvidenceRequester, rim:RegistryObjectList and optional ResponseAvailableDateTime</sch:assert>
            <!-- 
            Maybe add assertion that report any slots with unexpected values?  
            For now they are just ignored. 
            --> 
            
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern> 
        <!-- Rules for data types of specific slots in responses -->
        <sch:rule context="query:QueryResponse/rim:Slot[@name='SpecificationIdentifier']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='StringValueType'" id="R-EDM-RESP-S017"
                >The rim:SlotValue of rim:Slot name="SpecificationIdentifier" MUST be of "rim:StringValueType"</sch:assert>
        </sch:rule>
        
        <sch:rule context="query:QueryResponse/rim:Slot[@name='EvidenceResponseIdentifier']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='StringValueType'" id="R-EDM-RESP-S018"
                >The rim:SlotValue of rim:Slot name="EvidenceResponseIdentifier" MUST be of "rim:StringValueType"</sch:assert>
        </sch:rule>
        
        <sch:rule context="query:QueryResponse/rim:Slot[@name='IssueDateTime']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='DateTimeValueType'" id="R-EDM-RESP-S019"
                >The rim:SlotValue of rim:Slot name="IssueDateTime" MUST be of "rim:DateTimeValueType"</sch:assert>
        </sch:rule>
        
        <sch:rule context="query:QueryResponse/rim:Slot[@name='EvidenceProvider']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='CollectionValueType'" id="R-EDM-RESP-S020"
                >The rim:SlotValue of rim:Slot name="EvidenceProvider" MUST be of "rim:CollectionValueType"</sch:assert>
        </sch:rule>
        
        <sch:rule context="query:QueryRequest/rim:Slot[@name='EvidenceProvider']/rim:SlotValue/rim:Element">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='AnyValueType'" id="R-EDM-REQ-S021"
                >The rim:Element of rim:SlotValue of rim:Slot name="EvidenceProvider" MUST be of "rim:AnyValueType"</sch:assert>
            <sch:assert test="sdg:Agent" id="R-EDM-RESP-S025"
                >The 'query:QueryResponse/rim:Slot[@name='EvidenceProvider']/rim:SlotValue' MUST use the 'sdg:Agent' of the targetNamespace="http://data.europa.eu/p4s"</sch:assert>
        </sch:rule>
        
        <sch:rule context="query:QueryResponse/rim:Slot[@name='EvidenceProvider']/rim:SlotValue/sdg:Agent">
            <sch:assert test="sdg:Identifier and sdg:Name and sdg:Address and sdg:Classification" id="R-EDM-RESP-S026"
                >An EvidenceProvider 'rim:SlotValue/sdg:Agent' MUST not contain any other elements than 'sdg:Identifier' and 'sdg:Name', 'sdg:Address', sdg:Classification. </sch:assert>
        </sch:rule>
        
        <sch:rule context="query:QueryResponse/rim:Slot[@name='EvidenceRequester']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='AnyValueType'" id="R-EDM-RESP-S022"
                >The rim:SlotValue of rim:Slot name="EvidenceRequester" MUST be of "rim:AnyValueType"</sch:assert>
            <sch:assert test="sdg:Agent" id="R-EDM-RESP-S027"
                >The 'query:QueryResponse/rim:Slot[@name='EvidenceRequester']/rim:SlotValue' MUST 'sdg:Agent' of the targetNamespace="http://data.europa.eu/p4s".</sch:assert>
        </sch:rule>
        
        <sch:rule context="query:QueryResponse/rim:Slot[@name='EvidenceRequester']/rim:SlotValue/sdg:Agent">
            <sch:assert test="sdg:Identifier and sdg:Name" id="R-EDM-RESP-S028"
                >An EvidenceRequester ''rim:SlotValue/sdg:Agent' MUST not contain any other elements than 'sdg:Identifier' and 'sdg:Name'. </sch:assert>
        </sch:rule>
        
        <sch:rule context="query:QueryResponse/rim:Slot[@name='ResponseAvailableDateTime']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='DateTimeValueType'" id="R-EDM-RESP-S023"
                >Slot type value for ResponseAvailableDateTime must be rim:DateTimeValueType</sch:assert>
        </sch:rule>
        
        <sch:rule context="query:QueryResponse/rim:Slot[@name='EvidenceMetadata']/rim:SlotValue/sdg:Evidence/sdg:IsConformantTo">
            <sch:assert test="sdg:EvidenceTypeClassification and sdg:Title and sdg:Description" id="R-EDM-RESP-S030"
                >The class 'IsConformantTo' of 'Evidence' MUST not contain any other elements than 'sdg:EvidenceTypeClassification', 'sdg:Title' and 'sdg:Description'..</sch:assert>
        </sch:rule>
        
    </sch:pattern>
    
    
    <sch:pattern>
        <!-- Registry Object -->
        <sch:rule context="query:QueryResponse//rim:RegistryObject">
            <sch:assert test="count(child::rim:Slot[@name='EvidenceMetadata'])=1" id="R-EDM-RESP-S015"
                >The rim:Slot name="EvidenceMetadata" MUST be present in the RegistryObject.</sch:assert>
        </sch:rule>
        
        <sch:rule context="query:QueryResponse//rim:RegistryObject/rim:Slot[@name='EvidenceMetadata']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='AnyValueType'" id="R-EDM-RESP-S024"
                >The rim:SlotValue of rim:Slot name="EvidenceMetadata MUST be of "rim:AnyValueType"</sch:assert>
            <sch:assert test="sdg:Evidence" id="R-EDM-RESP-S029"
                >The 'query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='EvidenceMetadata']/rim:SlotValue' MUST use the 'sdg:Evidence' of the targetNamespace="http://data.europa.eu/p4s"</sch:assert>
        </sch:rule>
        
        <!-- Check that a referenced evidence payload has syntax for an AS4 MIME part reference -->
        <sch:rule context="query:QueryResponse//rim:RepositoryItemRef">
            <sch:assert test="@xlink:href"
                >A repository item reference must contain an xlink:href attribute</sch:assert>
            <sch:assert test="@xlink:href[contains(.,'@')]"
                >A repository item reference must reference a MIME part, so it must contain '@'</sch:assert>
            <sch:assert test="@xlink:href[starts-with(.,'cid:')]"
                >A repository item reference must reference a MIME part, so it must start with 'cid:'</sch:assert>
        </sch:rule>
    </sch:pattern>
    
</sch:schema>