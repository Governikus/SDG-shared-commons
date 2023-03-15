<?xml version="1.0" encoding="UTF-8"?>
<sch:schema 
    xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    
    <sch:ns uri="http://data.europa.eu/p4s" prefix="sdg"/>
    <sch:ns uri="urn:oasis:names:tc:ebxml-regrep:xsd:rs:4.0" prefix="rs"/>
    <sch:ns uri="urn:oasis:names:tc:ebxml-regrep:xsd:rim:4.0" prefix="rim"/>
    <sch:ns uri="urn:oasis:names:tc:ebxml-regrep:xsd:lcm:4.0" prefix="lcm"/>
    <sch:ns uri="http://www.w3.org/2001/XMLSchema-instance" prefix="xsi"/>
    <sch:ns uri="http://www.w3.org/1999/xlink" prefix="xlink"/>


    <sch:pattern>
        <sch:rule context="/node()">
            <sch:let name="ln" value="local-name(/node())"/>
            <sch:assert test="$ln ='SubmitObjectsRequest'" id="DSD-SUB-S001" flag="FATAL"
                >The root element of a query response document MUST be 'lcm:SubmitObjectsRequest'</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:rule context="/node()">
            <sch:let name="ns" value="namespace-uri(/node())"/>
            <sch:assert test="$ns ='urn:oasis:names:tc:ebxml-regrep:xsd:lcm:4.0'" id="DSD-SUB-S002" flag="FATAL"
                >The namespace of root element of a 'lcm:SubmitObjectsRequest' must be 'urn:oasis:names:tc:ebxml-regrep:xsd:lcm:4.0'</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="lcm:SubmitObjectsRequest">
            <sch:assert test="matches(normalize-space((@id)),'^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$','i')" 
                flag='FATAL' id="DSD-SUB-S004"
                >The 'id' attribute of a 'SubmitObjectsRequest' MUST be unique UUID (RFC 4122).</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:rule context="lcm:SubmitObjectsRequest">
            <sch:assert test="count(rim:RegistryObjectList)>0" id="DSD-SUB-S005a" flag="FATAL"
                >A 'SubmitObjectsRequest' MUST include a 'rim:RegistryObjectList' and a 'rim:RegistryObject'</sch:assert>
        </sch:rule>
        <sch:rule context="lcm:SubmitObjectsRequest/rim:RegistryObjectList">
            <sch:assert test="count(rim:RegistryObject)>0" id="DSD-SUB-S005b" flag="FATAL"
                >A 'SubmitObjectsRequest' MUST include a 'rim:RegistryObjectList' and a 'rim:RegistryObject'</sch:assert>
        </sch:rule>        
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="rim:RegistryObject">
            <sch:let name="idattr" value="@id"/>
            <sch:let name="st"  value="substring-after(@xsi:type, ':')" />
            <sch:assert test="string-length($idattr)>0" id="DSD-SUB-S006" flag="FATAL"
                >Each 'rim:RegistryObject' MUST include an 'id' attribute</sch:assert>
            <sch:assert test="$st ='AssociationType' or count(rim:Classification)>0" id="DSD-SUB-S007"
                >Each 'rim:RegistryObject' MUST include a 'rim:Classification' if the 'rim:RegistryObject' is not an 'xsi:type="rim:AssociationType"'</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:rule context="rim:RegistryObject/rim:Classification">
            <sch:let name="idattr" value="@id"/>
            <sch:let name="schemeattr" value="@classificationScheme"/>
            <sch:let name="nodeattr" value="@classificationNode"/>
            <sch:assert test="string-length($idattr)>0"  flag='FATAL' id="DSD-SUB-S008"   
                >Each 'rim:Classification' MUST include an 'id' attribute</sch:assert>
            <sch:assert test="matches(normalize-space((@id)),'^urn:uuid:[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$','i')" 
                flag='FATAL' id="DSD-SUB-S009"
                >Each id of 'rim:Classification' MUST be unique UUID (RFC 4122).</sch:assert>
            <sch:assert test="string-length($schemeattr)>0"  flag='FATAL' id="DSD-SUB-S010"   
                >Each 'rim:Classification' MUST include an 'classificationScheme' attribute</sch:assert>
            <sch:assert test="string-length($nodeattr)>0"  flag='FATAL' id="DSD-SUB-S011"   
                >Each 'rim:Classification' MUST include an 'classificationNode' attribute</sch:assert>
            <sch:assert test="$schemeattr = 'urn:fdc:oots:classification:dsd'" id="DSD-SUB-S012"
                > The 'classificationScheme' attribute MUST be 'urn:fdc:oots:classification:dsd'</sch:assert>
            <sch:assert test="$nodeattr = 'EvidenceProvider' or $nodeattr = 'DataServiceEvidenceType' "  flag='FATAL' id="DSD-SUB-S013"   
                > The 'classificationNode' attribute MUST be 'EvidenceProvider' or 'DataServiceEvidenceType'</sch:assert>
            
        </sch:rule>
    </sch:pattern>
   
</sch:schema>