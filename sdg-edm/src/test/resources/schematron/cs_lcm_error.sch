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
            <sch:assert test="$ln ='RegistryResponse'" id="R-LCM-ERR-001"
                >The root element of a rs:RegistryResponse document MUST be 'rs:RegistryResponse'</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="/node()">
            <sch:let name="ns" value="namespace-uri(/node())"/>
            <sch:assert test="$ns ='urn:oasis:names:tc:ebxml-regrep:xsd:rs:4.0'" id="R-LCM-ERR-002"
                >The namespace of root element of a 'rs:RegistryResponse' must be 'urn:oasis:names:tc:ebxml-regrep:xsd:rs:4.0'</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    
    <sch:pattern>
        <sch:rule context="rs:RegistryResponse">
            <sch:let name="status" value="@status" />
            
            <sch:assert test="@requestId" id="R-LCM-ERR-003" flag="FATAL"
                >The 'requestId' attribute of a 'rs:RegistryResponse' MUST be present. </sch:assert>
            
            <sch:assert test="matches(normalize-space(@requestId),'[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$','i')" 
                flag='FATAL' id="R-LCM-ERR-004"
                >The 'requestID' attribute of a 'rs:RegistryResponse' MUST be unique UUID (RFC 4122) and match the corresponding request.</sch:assert>
            
            
            <sch:assert test="@status" id="R-LCM-ERR-005" flag="FATAL"
                >The 'status' attribute of a 'rs:RegistryResponse' MUST be present. </sch:assert>

            <sch:assert test="$status = 'urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure'" id="R-LCM-ERR-006"
                >The 'status' attribute of a unsuccessful 'rs:RegistryResponse' MUST be encoded as as 'urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure'.</sch:assert>
            
            <sch:assert test="count(rim:RegistryObjectList) = 0" id="R-LCM-ERR-007"
                >An unsuccessful 'rs:RegistryResponse' does not include a 'rim:RegistryObjectList'</sch:assert>
            
            <sch:assert test="count(rs:Exception)>0" id="R-LCM-ERR-008"
                >An unsuccessful 'rs:RegistryResponse' includes an Exception</sch:assert>
            

            <sch:assert test="count(Slot) = 0" id="R-LCM-SUC-008"
                >A successful 'rs:RegistryResponse' does not include a 'rim:Slot'</sch:assert>
            
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern >
        <sch:rule context="RegistryResponse/rs:Exception">
            <sch:assert test="@xsi:type" id="R-LCM-ERR-009"
                >The 'xsi:type' attribute of a 'rs:Exception' MUST be present. </sch:assert>
        </sch:rule>
        <sch:rule context="RegistryResponse/rs:Exception/@xsi:type">   
            <sch:assert test="rs:InvalidRequestExceptionType" id="R-LCM-010"
                >The value of 'xsi:type' attribute of a 'rs:Exception' MUST be rs:InvalidRequestExceptionType</sch:assert>          
        </sch:rule>
        
        <sch:rule context="RegistryResponse/rs:Exception">
            
            <sch:assert test="@severity" id="R-LCM-ERR-011"
                >The 'severity' attribute of a 'rs:Exception' MUST be present. </sch:assert>
             
            <sch:assert test="@severity='ErrorSeverity'" id="R-LCM-012"
                >The value of 'severity' attribute of a 'rs:Exception' MUST  be part of the code list 'ErrorSeverity'.</sch:assert>          
            
            <sch:assert test="@message" id="R-LCM-ERR-013"
                >The 'message' attribute of a 'rs:Exception' MUST be present. </sch:assert>
            
            <sch:let name="GenericError"  value="'Generic Error'"/>         
            <sch:assert test="$GenericError=string(@message)" id="R-LCM-014"
                >The value of 'message' attribute of a 'rs:Exception' MUST be part of the code list 'GenericError'. </sch:assert>  
            
            <sch:assert test="@code" id="R-LCM-ERR-015"
                >The 'code' attribute of a 'rs:Exception' MUST be present. </sch:assert>
            
            <sch:let name="CommonErrorCodes"  value="'SERVICE:ERR:0001'"/>
            <sch:assert test="$CommonErrorCodes=string(@code)" id="R-LCM-016"
                >The value of 'code' attribute of a 'rs:Exception' MUST be part of the code list 'CommonErrorCodes'.</sch:assert>  
 
            <sch:assert test="count(rim:Slot) = 0" id="R-LCM-SUC-017"
                >An successful 'rs:RegistryResponse' MUST not any rim:Slots.</sch:assert>
            
            
            
        </sch:rule>
        
    </sch:pattern>
    
</sch:schema>