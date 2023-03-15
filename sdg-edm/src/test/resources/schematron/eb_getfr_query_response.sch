<?xml version="1.0" encoding="UTF-8"?>
<sch:schema 
    xmlns:sch="http://purl.oclc.org/dsdl/schematron" >
    
    <sch:ns uri="http://data.europa.eu/p4s" prefix="sdg"/>
    <sch:ns uri="urn:oasis:names:tc:ebxml-regrep:xsd:rs:4.0" prefix="rs"/>
    <sch:ns uri="urn:oasis:names:tc:ebxml-regrep:xsd:rim:4.0" prefix="rim"/>
    <sch:ns uri="urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0" prefix="query"/>
    <sch:ns uri="http://www.w3.org/2001/XMLSchema-instance" prefix="xsi"/>
    <sch:ns uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
    
    <!-- 
           EB-EVI-S excel sheet 
           Validates test sample xml/EB/Response_for_Get_Evidence_Type_for_Requirement_Query.xml
     -->
    <sch:pattern>
        <sch:rule context="/node()">
            <sch:let name="ln" value="local-name(/node())"/>
            <sch:assert test="$ln ='QueryResponse'" id="R-EB-EVI-S001"
                >The root element of a query response document MUST be query:QueryResponse</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="/node()">
            <sch:let name="ns" value="namespace-uri(/node())"/>
            <sch:assert test="$ns ='urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0'" id="R-EB-EVI-S002"
                >The namespace of root element of a query response document must be 'urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0'</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="query:QueryResponse">
            <sch:assert test="@status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success'"
                id="R-EB-EVI-S006"
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
            <sch:assert test="count(rim:RegistryObjectList) = 1" id="R-EB-EVI-S007"
                >A successful OOTS response includes a RegistryObjectList</sch:assert>
            <sch:assert test="count(rs:Exception) = 0" id="R-EB-EVI-S008"
                >A successful OOTS response does not include an Exception</sch:assert>
        </sch:rule>       
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="rim:RegistryObject">
            <sch:assert test="rim:Slot[@name='Requirement']" id="R-EB-EVI-S009"
                >The rim:Slot name="Requirement" MUST be present in the QueryResponse.</sch:assert>
        </sch:rule>
        <sch:rule context="rim:RegistryObject">
            <sch:assert test="count(rim:Slot) = 1" id="R-EB-EVI-S010"
                >A 'query:QueryResponse' MUST not contain any other rim:Slots.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="rim:Slot[@name='Requirement']/rim:SlotValue">
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="$st ='AnyValueType'" id="R-EB-EVI-S011"
                >The rim:SlotValue of rim:Slot name="Requirement" MUST be of "rim:AnyValueType"<sch:value-of select="$st"/></sch:assert>
            <sch:assert test="count(sdg:Requirement)=1" id="R-EB-EVI-S012"
                >A  rim:Slot[@name=Requirement]/rim:SlotValue MUST contain one sdg:Requirement of the targetNamespace="http://data.europa.eu/p4s</sch:assert>
        </sch:rule>
    </sch:pattern>         
    
    <sch:pattern>
        <sch:rule context="rim:Slot[@name='Requirement']/rim:SlotValue/sdg:Requirement/sdg:ReferenceFramework/sdg:RelatedTo">
            <sch:assert test="count(sdg:Identifier)=1" id="R-EB-EVI-S013"
                >The xs:element name="RelatedTo" type="sdg:ReferenceFrameworkType"/ MUST only contain the 'sdg:Identifier'</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="rim:Slot[@name='Requirement']/rim:SlotValue/sdg:Requirement/sdg:EvidenceTypeList/sdg:EvidenceType">        
            <sch:assert test="count(sdg:Distribution)=0" id="R-EB-EVI-S014"
                >The xs:element name="EvidenceType" type="sdg:EvidenceTypeType" MUST not contain the Distribution.</sch:assert>      
        </sch:rule>
    </sch:pattern>
    
    
    <!-- A RegistryObjectList can be empty !? 
            <sch:pattern>
                <sch:rule context="rim:RegistryObjectList">
                    <sch:assert test="count(rim:RegistryObject) > 0"
                        >A RegistryObjectList must include at least one RegistryObject</sch:assert>
                </sch:rule>
            </sch:pattern>
    -->
    
    <!-- The following is specific to Get Evidence Types for Requirement --> 
    
    
</sch:schema>