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
           EB-ERR-S excel sheet 
           Validates test sample file:/Users/rotunacarmenionela/tdd_chapters/OOTS-EDM/xml/EB/Query_Error_Response.xml
     -->
    <sch:pattern>
        <sch:rule context="/node()">
            <sch:let name="ln" value="local-name(/node())"/>
            <sch:assert test="$ln ='QueryResponse'" id="R-EB-ERR-S001"
                >The root element of a query response document MUST be query:QueryResponse</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="/node()">
            <sch:let name="ns" value="namespace-uri(/node())"/>
            <sch:assert test="$ns ='urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0'" id="R-EB-ERR-S002"
                >The namespace of root element of a query response document must be 'urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0'</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="query:QueryResponse">
            <sch:assert test="@status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure'" id="R-EB-ERR-S006"
                >The 'status' attribute of an unsuccessfull 'query:QueryResponse' MUST be encoded as as 'urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure'.</sch:assert>         
        </sch:rule>
    </sch:pattern>
    
    
    
    <sch:pattern>
        <!-- 
            If Response is Success there is only a RegistryObjectList 
            If Response is Failure then there is only an Exception 
        -->
        <sch:rule context="query:QueryResponse[
            @status='urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success']">
            <sch:assert test="count(rim:RegistryObjectList) = 0" id="R-EB-ERR-S007"
                >An unsuccessful 'query:QueryResponse' does not include a 'rim:RegistryObjectList'</sch:assert>
            <sch:assert test="count(rs:Exception) = 1" id="R-EB-ERR-S008"
                >An unsuccessful 'query:QueryResponse' includes an Exception</sch:assert>
        </sch:rule>       
    </sch:pattern>
    
    
    <sch:pattern >
        <sch:rule context="RegistryResponse/rs:Exception">
            <sch:assert test="@xsi:type" id="R-EB-ERR-009"
                >The 'xsi:type' attribute of a 'rs:Exception' MUST be present. </sch:assert>
        </sch:rule>
        <sch:rule context="RegistryResponse/rs:Exception/@xsi:type">   
            <sch:assert test="rs:InvalidRequestExceptionType or rs:ObjectNotFoundExceptionType" id="R-EB-ERR-010"
                >The value of 'xsi:type' attribute of a 'rs:Exception' MUST be rs:InvalidRequestExceptionType or rs:ObjectNotFoundExceptionType
            </sch:assert>          
        </sch:rule>
        
        <sch:rule context="RegistryResponse/rs:Exception">
            
            <sch:assert test="@severity" id="R-EB-ERR-011"
                >The 'severity' attribute of a 'rs:Exception' MUST be present. </sch:assert>
            
            <sch:assert test="@severity='ErrorSeverity'" id="R-EB-ERR-012"
                >The value of 'severity' attribute of a 'rs:Exception' MUST  be part of the code list 'ErrorSeverity'.</sch:assert>          
            
            <sch:assert test="@message" id="R-EB-ERR-013"
                >The 'message' attribute of a 'rs:Exception' MUST be present. </sch:assert>
            
            <sch:let name="GenericError"  value="'Generic Error'"/>         
            <sch:assert test="$GenericError=string(@message)" id="R-EB-ERR-014"
                >The value of 'message' attribute of a 'rs:Exception' MUST be part of the code list 'EBErrorCodes'.  </sch:assert>  
            
            <sch:assert test="@code" id="R-EB-ERR-015"
                >The 'code' attribute of a 'rs:Exception' MUST be present. </sch:assert>
            
            <sch:let name="EBErrorCodes"  value="'SERVICE:ERR:0001'"/>
            <sch:assert test="$EBErrorCodes=string(@code)" id="R-EB-ERR-016"
                >The value of 'code' attribute of a 'rs:Exception' MUST be part of the code list 'EBErrorCodes'. </sch:assert>  
            
            <sch:assert test="count(rim:Slot) = 0" id="R-EB-ERR-017"
                >An unsuccessfull 'query:QueryResponse' MUST not contain any rim:Slots.</sch:assert>
            
            
            
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