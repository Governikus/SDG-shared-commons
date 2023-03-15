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
            <sch:assert test="$ln ='QueryRequest'" id="R-EDM-REQ-S001"
                >The root element of a query request document MUST be 'query:QueryRequest'</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="/node()">
            <sch:let name="ns" value="namespace-uri(/node())"/>
            <sch:assert test="$ns ='urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0'" id="R-EDM-REQ-S002"
                >The namespace of root element of a 'query:QueryRequest' must be 'urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0'</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="query:QueryRequest/@id">
            <sch:assert test="matches(normalize-space((.)),'^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$','i')" 
                flag='ERROR' id="R-EDM-REQ-S004">
                The 'id' attribute of a 'QueryRequest' MUST be unique UUID (RFC 4122) for each request.
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern >
        <sch:rule context="query:QueryRequest">
            
            <sch:assert test="count(child::rim:Slot[@name='SpecificationIdentifier'])=1" id="R-EDM-REQ-S005"
                >The rim:Slot name="SpecificationIdentifier" MUST be present in the QueryRequest.</sch:assert>
            
            <sch:assert test="count(child::rim:Slot[@name='IssueDateTime'])=1" id="R-EDM-REQ-S006"
                >The rim:Slot name="IssueDateTime" MUST be present  in the QueryRequest.</sch:assert>
            
            <sch:assert test="count(child::rim:Slot[@name='Procedure']) = 1" role="warning" id="R-EDM-REQ-S007"
                >The rim:Slot name="Procedure" SHOULD be present in the QueryRequest.</sch:assert>
            
            <sch:assert test="count(child::rim:Slot[@name='PreviewLocation']) = 1" role="info" id="R-EDM-REQ-S008"
                >The rim:Slot name="PreviewLocation" MAY be present in the QueryRequest.</sch:assert>
            
            <sch:assert test="count(child::rim:Slot[@name='PossibilityForPreview'])=1" id="R-EDM-REQ-S009"
                >The rim:Slot name="PossibilityForPreview" MUST be present in the QueryRequest.</sch:assert>
            
            <sch:assert test="count(child::rim:Slot[@name='ExplicitRequestGiven'])=1" id="R-EDM-REQ-S010"
                >The rim:Slot name="ExplicitRequestGiven" MUST be present in the QueryRequest.</sch:assert>
            
            <sch:assert test="count(child::rim:Slot[@name='Requirements'])=1" role="warning" id="R-EDM-REQ-S011"
                >The rim:Slot name="Requirements" SHOULD be present in the QueryRequest.</sch:assert>
            
            <sch:assert test="count(child::rim:Slot[@name='EvidenceRequester'])=1" id="R-EDM-REQ-S012"
                >The rim:Slot name="EvidenceRequester" MUST be present in the QueryRequest.</sch:assert>
            
            <sch:assert test="count(child::rim:Slot[@name='EvidenceProvider'])=1" id="R-EDM-REQ-S013"
                >The rim:Slot name="EvidenceProvider" MUST be present in the QueryRequest.</sch:assert>
            
            <sch:assert test="count(child::rim:Slot[@name='EvidenceProviderClassification'])=1" role="info" id="R-EDM-REQ-S014"
                >The rim:Slot name="EvidenceProviderClassification" MAY be present in the QueryRequest.</sch:assert>
            
            <sch:assert test="count(child::rim:Slot[@name='AuthorizedRepresentative']) = 1" role="info"
                >The rim:Slot name="AuthorizedRepresentative" MAY be present in the Query.</sch:assert>
            
            
            <!-- 
            Maybe add assertion that report any slots with unexpected values?  
            For now they are just ignored. 
            --> 
            
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern> 
        <!-- Rules for data types of specific slots in requests -->
        <sch:rule context="query:QueryRequest/rim:Slot">
            <sch:assert test="@name='SpecificationIdentifier' or 'IssueDateTime' or 'Procedure' or 'PreviewLocation' or 'PossibilityForPreview' or 'ExplicitRequestGiven' 
                or 'Requirement' or 'EvidenceRequester' or 'EvidenceProvider' or 'EvidenceProviderClassification' or 'EvidenceRequest' or 'LegalPerson' or 'NaturalPerson' or 
                'AuthorizedRepresentative'" id="R-EDM-REQ-S019"
                >A query:QueryRequest MUST not contain any other rim:Slots.</sch:assert>
        </sch:rule>
    </sch:pattern>   
    
    <sch:pattern> 
        <!-- Rules for data types of specific slots in requests -->
        <sch:rule context="query:QueryRequest/rim:Slot[@name='SpecificationIdentifier']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='StringValueType'" id="R-EDM-REQ-S020"
                >The rim:SlotValue of rim:Slot name="SpecificationIdentifier" MUST be of "rim:StringValueType"</sch:assert>
        </sch:rule>
        
        <sch:rule context="query:QueryRequest/rim:Slot[@name='IssueDateTime']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='DateTimeValueType'" id="R-EDM-REQ-S021"
                >The rim:SlotValue of rim:Slot name="IssueDateTime" MUST be of "rim:DateTimeValueType"</sch:assert>
        </sch:rule>
        
        <sch:rule context="query:QueryRequest/rim:Slot[@name='Procedure']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='InternationalStringValueType'" id="R-EDM-REQ-S022"
                >The rim:SlotValue of rim:Slot name="Procedure" MUST be of "rim:InternationalStringValueType"</sch:assert>
        </sch:rule>
        
        <sch:rule context="query:QueryRequest/rim:Slot[@name='PreviewLocation']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='StringValueType'" id="R-EDM-REQ-S023"
                >The rim:SlotValue of rim:Slot name="PreviewLocation" MUST be of "rim:StringValueType"</sch:assert>
        </sch:rule>
        
        <sch:rule context="query:QueryRequest/rim:Slot[@name='PossibilityForPreview']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='BooleanValueType'" id="R-EDM-REQ-S024"
                >The rim:SlotValue of rim:Slot name="PossibilityForPreview" MUST be of "rim:BooleanValueType"</sch:assert>
        </sch:rule>
        
        <sch:rule context="query:QueryRequest/rim:Slot[@name='ExplicitRequestGiven']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='BooleanValueType'" id="R-EDM-REQ-S025"
                >The rim:SlotValue of rim:Slot name="ExplicitRequestGiven" MUST be of "rim:BooleanValueType"</sch:assert>
        </sch:rule>    
        
        <sch:rule context="query:QueryRequest/rim:Slot[@name='Requirements']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='CollectionValueType'" id="R-EDM-REQ-S026"
                >The rim:SlotValue of rim:Slot name="Requirements MUST be of "rim:CollectionValueType"</sch:assert>
        </sch:rule>
        
        <sch:rule context="query:QueryRequest/rim:Slot[@name='Requirements']/rim:SlotValue/rim:Element">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='AnyValueType'" id="R-EDM-REQ-S027"
                >The rim:Element of rim:SlotValue of rim:Slot name="Requirements" MUST be of "rim:AnyValueType"</sch:assert>
            <sch:assert test="sdg:Requirement" id="R-EDM-REQ-S037"
                >The 'query:QueryRequest/rim:Slot[@name='Requirements']/rim:SlotValue/rim:Element' MUST use the 'sdg:Requirement' of the targetNamespace="http://data.europa.eu/p4s".</sch:assert>       
        </sch:rule>
        
        <sch:rule context="query:QueryRequest/rim:Slot[@name='Requirements']/rim:SlotValue/rim:Element/sdg:Requirement">  
            <sch:assert test="sdg:Name and sdg:Identifier" id="R-EDM-REQ-S038"
                >A Requirement  rim:Element/Requirement MUST not contain any other elements than 'sdg:Identifier' and 'sdg:Name'.</sch:assert>      
        </sch:rule>    
        
        <sch:rule context="query:QueryRequest/rim:Slot[@name='EvidenceRequester']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='CollectionValueType'" id="R-EDM-REQ-S028"
                >The rim:SlotValue of rim:Slot name="EvidenceRequester" MUST be of "rim:CollectionValueType"</sch:assert>
            <sch:assert test="rim:Element/sdg:Agent" id="R-EDM-REQ-S039"
                >The 'query:QueryRequest/rim:Slot[@name='EvidenceRequester']/rim:SlotValue/rim:Element' MUST use the 'sdg:Agent' of the targetNamespace="http://data.europa.eu/p4s"</sch:assert>
        </sch:rule>
        
        <sch:rule context="query:QueryRequest/rim:Slot[@name='EvidenceRequester']/rim:SlotValue/rim:Element">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='AnyValueType'" id="R-EDM-REQ-S029"
                >The rim:Element of rim:SlotValue of rim:Slot name="EvidenceRequester" MUST be of "rim:AnyValueType"</sch:assert>
        </sch:rule>
        
        <sch:rule context="query:QueryRequest/rim:Slot[@name='EvidenceRequester']/rim:SlotValue/rim:Element/sdg:Agent">
            <sch:assert test="sdg:Identifier and sdg:Name and sdg:Address and sdg:Classification" id="R-EDM-REQ-S040"
                >An EvidenceRequester ''rim:Element/Agent' MUST not contain any other elements than 'sdg:Identifier' and 'sdg:Name', 'sdg:Address' and 'sdg:Classification'.</sch:assert>
        </sch:rule>
        
        <sch:rule context="query:QueryRequest/rim:Slot[@name='EvidenceProvider']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='AnyValueType'" id="R-EDM-REQ-S030"
                >The rim:SlotValue of rim:Slot name="EvidenceProvider" MUST be of "rim:AnyValueType"</sch:assert>
            <sch:assert test="sdg:Agent" id="R-EDM-REQ-S042"
                >The 'query:QueryRequest/rim:Slot[@name='EvidenceProvider']/rim:SlotValue' MUST use the 'sdg:Agent' of the targetNamespace="http://data.europa.eu/p4s"</sch:assert>             
        </sch:rule>         
        
        <sch:rule context="query:QueryRequest/rim:Slot[@name='EvidenceProviderClassification']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='CollectionValueType'" id="R-EDM-REQ-S031"
                >The rim:SlotValueof rim:Slot name="EvidenceProviderClassification" MUST be of "rim:CollectionValueType"
            </sch:assert>
        </sch:rule>
        
        <sch:rule context="query:QueryRequest/rim:Slot[@name='EvidenceProviderClassification']/rim:SlotValue/rim:Element">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='AnyValueType'" id="R-EDM-REQ-S032"
                >TThe rim:Element of rim:SlotValue of rim:Slot name="EvidenceProviderClassification" MUST be of "rim:AnyValueType"</sch:assert>
            <sch:assert test="sdg:EvidenceProviderClassification" id="R-EDM-REQ-S041"
                >An OOTS query EvidenceRequest EvidenceProviderClassification slot must use sdg:EvidenceProviderClassification.</sch:assert> 
        </sch:rule>
        
        <sch:rule context="query:QueryRequest/rim:Slot[@name='EvidenceProvider']/rim:SlotValue/sdg:Agent">
            <sch:assert test="sdg:Identifier and sdg:Name" id="R-EDM-REQ-S043"
                >An EvidenceProvider 'rim:SlotValue/Agent' MUST not contain any other elements than 'sdg:Identifier' and 'sdg:Name'.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern >
        <sch:rule context="query:Query/rim:Slot[@name='EvidenceRequest']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='AnyValueType'" id="R-EDM-REQ-S033"
                >The rim:SlotValue of rim:Slot name="EvidenceRequest" MUST be of "rim:AnyValueType"</sch:assert>
            <sch:assert test="sdg:DataServiceEvidenceType" id="R-EDM-REQ-S044"
                >The 'query:QueryRequest/rim:Slot[@name='EvidenceRequest']/rim:SlotValue' MUST use the 'sdg:DataServiceEvidenceType' of the targetNamespace="http://data.europa.eu/p4s"</sch:assert>            
        </sch:rule>
    </sch:pattern>
    
    
    <sch:pattern >
        <sch:rule context="query:Query/rim:Slot[@name='EvidenceRequest']/rim:SlotValue/sdg:DataServiceEvidenceType">   
            <sch:assert test="sdg:Identifier and sdg:EvidenceTypeClassification and sdg:Title and sdg:Description and sdg:DistributedAs and count(sdg:Title)=1 or 2" id="R-EDM-REQ-S045"
                >An EvidenceRequest 'rim:SlotValue/DataServiceEvidenceType' MUST not contain any other elements than 'sdg:Identifier', 'sdg:EvidenceTypeClassification', 'sdg:Title', 'sdg:Description' and 'sdg:DistributedAs'.</sch:assert>            
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern >
        <sch:rule context="query:Query/rim:Slot[@name='NaturalPerson']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='AnyValueType'" id="R-EDM-REQ-S035"
                >The rim:SlotValue of rim:Slot name="NaturalPerson" MUST be of "rim:AnyValueType"</sch:assert>
            <sch:assert test="sdg:Person" id="R-EDM-REQ-S046"
                >The 'query:QueryRequest/query:Query/rim:Slot[@name='NaturalPerson']/rim:SlotValue' MUST use the 'sdg:Person' of the targetNamespace="http://data.europa.eu/p4s"</sch:assert>            
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern >
        <sch:rule context="query:Query/rim:Slot[@name='LegalPerson']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='AnyValueType'" id="R-EDM-REQ-S034"
                >The rim:SlotValue of rim:Slot name="LegalPerson" MUST be of "rim:AnyValueType"</sch:assert>
            <sch:assert test="sdg:LegalPerson" id="R-EDM-REQ-S047"
                >The 'query:QueryRequest/query:Query/rim:Slot[@name='LegalPerson']/rim:SlotValue' MUST use the 'sdg:LegalPerson' of the targetNamespace="http://data.europa.eu/p4s"</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern >
        <sch:rule context="query:Query">
            <sch:assert test="count(child::rim:Slot[@name='EvidenceRequest'])=1" id="R-EDM-REQ-S015"
                >The rim:Slot name="EvidenceRequest" MUST be present in the Query.</sch:assert>
            <sch:assert test="count(child::rim:Slot[@name='NaturalPerson'])+count(child::rim:Slot[@name='LegalPerson'])=1" id="R-EDM-REQ-S016"
                >A Query MUST contain either a rim:Slot name="LegalPerson" or a rim:Slot name="NaturalPerson" but NOT both.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern >
        <sch:rule context="query:Query/rim:Slot[@name='AuthorizedRepresentative']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='AnyValueType'" id="R-EDM-REQ-S036"
                >The rim:SlotValue of rim:Slot name="AuthorizedRepresentative" MUST be of "rim:AnyValueType"</sch:assert>
            <sch:assert test="sdg:Person" id="R-EDM-REQ-S048"
                >The 'query:QueryRequest/query:Query/rim:Slot[@name='AuthorizedRepresentative']/rim:SlotValue' MUST use the 'sdg:Person' of the targetNamespace="http://data.europa.eu/p4s"</sch:assert>            
        </sch:rule>
    </sch:pattern>
    
</sch:schema>
