<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    
    <sch:ns uri="http://data.europa.eu/p4s" prefix="sdg"/>
    <sch:ns uri="urn:oasis:names:tc:ebxml-regrep:xsd:rs:4.0" prefix="rs"/>
    <sch:ns uri="urn:oasis:names:tc:ebxml-regrep:xsd:rim:4.0" prefix="rim"/>
    <sch:ns uri="urn:oasis:names:tc:ebxml-regrep:xsd:lcm:4.0" prefix="lcm"/>
    <sch:ns uri="http://www.w3.org/2001/XMLSchema-instance" prefix="xsi"/>
    <sch:ns uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
    
    <sch:pattern>
        <sch:rule context="/node()">
            <sch:let name="ln" value="local-name(/node())"/>
            <sch:assert test="$ln ='RegistryResponse'" id="R-LCM-SUC-001"
                >The root element of a query response document MUST be 'rs:RegistryResponse'</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="/node()">
            <sch:let name="ns" value="namespace-uri(/node())"/>
            <sch:assert test="$ns ='urn:oasis:names:tc:ebxml-regrep:xsd:rs:4.0'" id="R-LCM-SUC-002"
                >The namespace of root element of a 'rs:RegistryResponse' must be 'urn:oasis:names:tc:ebxml-regrep:xsd:rs:4.0'</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="rs:RegistryResponse/@requestID">
            <sch:assert test="matches(normalize-space((.)),'^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$','i')" 
                flag='ERROR' id="R-LCM-SUC-004">
                The 'requestID' attribute of a 'rs:RegistryResponse' MUST be unique UUID (RFC 4122) and match the corresponding request.
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="rs:RegistryResponse">
            <sch:let name="status" value="@status" />
            
            <sch:assert test="@requestID" id="R-LCM-SUC-003" flag="FATAL"
                >The 'requestID' attribute of a 'rs:RegistryResponse' MUST be present. </sch:assert>
            
            <sch:assert test="@status" id="R-LCM-SUC-005" flag="FATAL"
                >The 'status' attribute of a 'rs:RegistryResponse' MUST be present. </sch:assert>

            <sch:assert test="$status = 'urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success'" id="R-LCM-SUC-006"
                >The 'status' attribute of a successful 'rs:RegistryResponse' MUST be encoded as as 'urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success'.</sch:assert>
            
            <sch:assert test="count(rim:RegistryObjectList) = 0" id="R-LCM-SUC-007"
                >A successful 'rs:RegistryResponse' does not include a 'rim:RegistryObjectList'</sch:assert>

            <sch:assert test="count(rim:Slot) = 0" id="R-LCM-SUC-008"
                >A successful 'rs:RegistryResponse' does not include a 'rim:Slot'</sch:assert>
            
        </sch:rule>
    </sch:pattern>
    
    
</sch:schema>