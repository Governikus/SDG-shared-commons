# DSD Samples

## 1. Introduction 
The Data Service Directory is a Common Service defined in the OOTS HLA. It maintains a catalog of Evidence Providers with the Evidence Types they are able to provide upon request using their Data Services. It is used in the Evidence Exchange process by the Evidence Requesters to discover the Evidence Providers that can provide the evidences they require, together with the required metadata and attributes imposed by the Data Services, like the classifications and context determinations of the Evidence Providers.
The information data model is based on the SDGR Application Profile for the DSD. The Service API is implemented using the OASIS RegRep v4 Query Protocol with the REST API Binding.
The main functionality of the DSD is to publish Data Services of Evidence Providers that provide distributions of Evidence Types and make them discoverable through queries. The functionality requires four main classes of Information:
* The DataServiceEvidenceType, providing the semantic information and requirements for retrieving an evidence type from a Data Service.
* The Distribution of the DataServiceEvidenceType, describing the format, the semantic and syntactic conformance, under which the Evidence Type can be distributed.
* The DataService, describing the technical endpoint from which an Evidence Requester can request the Evidence distributions.
* The EvidenceProvider, describing the details of the Provider of the Evidence.
The Request-Response samples can be found in the [OOTS-EDM/XML folder of the tdd_chapters git repository](https://ec.europa.eu/digital-building-blocks/code/projects/OOP/repos/tdd_chapters/browse/OOTS-EDM/xml).
In this section, some examples for the evidence exchange using the OOTS Exchange Data Model are provided. 

## 2. Information Model
The DSD information Data Model is based on the SDGR Application Profile for the DSD. It is based on the semantic classes of Evidence Type derived from the CCCEV v2.0, the DataService from DCAT and the Organization Class from the Core Public Organisation Vocabularies. It provides all the information aspects of the model, including the data types, use of Identifiers and code lists for every element used in this profile. The serialization of the model is done using XML according to the guidelines below. Below is an example of the XML representation of a Data Service serving an Evidence Type as it is contained in the DSD.

##     2.1. Evidence Type Metadata
The Evidence type metadata describes specific aspects of the evidence type such as:
* The Identifier, using the Identifier element, provided by the Data Services to uniquely identify an Evidence Type with its required metadata. This identifier is used by the Evidence Requester in the Evidence Exchange Request, to identify the Evidence Type to be retrieved by the Data Service.
* The available distributions, using the DistributedAs element. The distributions provide the available formats for the Evidence Type, such as PDF, XML, JSON etc, using the IANA Media Types. For the file types that provide structured content like XML, JSON, RDF, etc., the Data Service can provide a conformance statement, using the conformsTo sub-element of the DistributedAs element, for denoting the semantic and technical conformance profile. The element's value is a persistent URL, pointing to an entry of the OOTS Semantic Repository that contains all the relevant information of such a profile.

##     2.2. Data Service Metadata 
The Data Service metadata provides the necessary information needed for selecting the proper Evidence Provider and its relevant Data Service. It consists of:
* The Data Service Identifier, using the AccessService/Identifier element that is used by the eDelivery infrastructure to extract and use the proper pre-configured PMode for the submission of the Evidence Request. This identifier is profiled as a CEF eDelivery ebcore Party Identifier. 
* The Evidence Exchange Message Data Model Profile and version, denoted in the AccessService/ConformsTo element. Currently, the only value allowed is the oots:edm-1.0. 
* The Publisher element, providing the Name, Location and Jurisdiction of the Evidence Provider, used by the Evidence Requester for filtering and selection of the correct Evidence Provider.
* The Evidence Provider Determination Context, defining the location context of the Evidence provider. For example, if the determination context is "Place of Birth", it means that the jurisdiction of the Evidence provider must match the place of birth of the user.

##     2.3. Data Service Metadata Evidence Provider Discovery Metadata
The jurisdiction of the Evidence Provider is usually contextualized with a specific property of the user and the issued evidence type. 
A birth certificate registry's jurisdiction for example must match the user's place of birth at a specific level of jurisdiction. 
The DSD contains the EvidenceProviderJurisdictionDetermination attribute that defines the required mapping of the Evidence Provider's jurisdiction, 
in the DataServiceEvidenceType element. The attribute consists of the following sub-attributes:
* The Jurisdiction Context Identifier that is used as part of the query API for providing the response to the DSD by the User
* The Jurisdiction Context itself, which is a multilingual string describing the context as it should be displayed by the Evidence Requester's UI
* The Jurisdiction Level required, defining the required granularity of the jurisdiction.
The following example describes an entry in the DSD:

	<sdg:EvidenceProviderJurisdictionDetermination> \
    	<sdg:JurisdictionContextId>PlaceOfBirthIdentifier</sdg:JurisdictionContextId> \
    	<sdg:JurisdictionContext lang="en">Place Of Birth</sdg:JurisdictionContext> \
    	<sdg:JurisdictionContext lang="de">Geburtsort</sdg:JurisdictionContext> \
    	<!-- Codelist defining the jurisdiction levels, registered in the semantic repository --> \
    	<sdg:JurisdictionLevel>https://sr.ec.europa.eu/codelist/locationLevel/LAU</sdg:JurisdictionLevel> \
	</sdg:EvidenceProviderJurisdictionDetermination> \

##     2.3.1. Provider Context Determination
Although the jurisdiction mapping can be the main attribute for discovering the Evidence Provider, there are situations where the Evidence Provider must be further 
classified, depending on domain-specific quality attributes. For example, a registry containing social security and/or insurance contracts covers only specific kinds of
insurance (Private, Public, Mixed) or could cover only specific kinds of subjects, (e.g. SMEs, very large companies, construction companies, etc.). 
These domain-specific quality attributes must be declared in the Evidence Provider's DSD information and also in the DataServiceEvidenceType structure as a mandatory classification
filter that needs to be provided by the Evidence Requester. The DSD represents these attributes using the CCCEV 2.0 Information Concept structure. 
The Evidence Provider declares the qualities supported together with the supported values, as shown in the example below:

    <sdg:AccessService> \
        <sdg:Identifier schemeID="urn:oasis:names:tc:ebcore:partyid-type:iso6523:0060">8889909099</Identifier> \
            <sdg:ConformsTo>oots:edm-v1.0</ConformsTo> \
                <sdg:Publisher> \
                    /* Omitted ... */ \
                    <sdg:ClassificationConcept> \
                        <sdg:Identifier>TypeOfInsurance</sdg:Identifier> \
                        <sdg:SupportedValue> \
                            <sdg:StringValue>Private</sdg:StringValue> \
                        </sdg:SupportedValue> \
                    </sdg:ClassificationConcept> \   
                    /* Omitted ... */ \
                </sdg:Publisher> \
    </sdg:AccessService> \

##     2.3.2. Evidence Provider Classification
Classification concepts must be  present in the DataServiceEvidenceType for supporting a filtering mechanism at the Evidence Requester side. 
The classification concepts are listed, using CCCEV 2.0 at the DataServiceEvidenceType as the following example:

    <sdg:EvidenceProviderClassification> \
        <sdg:Identifier>CertificateOfBirth</sdg:Identifier> \
        <sdg:Type>Codelist</sdg:Type> \
        <!-- Value from a Codelist required. Must be publised in the Semantic Repository --> \
        <sdg:ValueExpression>http://sr.europa.eu/codelists/birthCertificate</sdg:ValueExpression> \
        <sdg:Description lang="en">Certificate of Birth</sdg:Description> \
    </sdg:EvidenceProviderClassification> \

File [DSDQueryTest.xml](https://ec.europa.eu/digital-building-blocks/code/projects/OOP/repos/tdd_chapters/browse/OOTS-EDM/xml/DSD/DSDQueryTest.xml) shows a DSD query request Example.

## 3. Query Interface Specification
The query interface specification for the Data Service Directory is based on the OASIS ebXML RegRep V4 standard. This standard has multiple protocol bindings that can 
be used to execute queries. Since the DSD queries have only simple, single-value parameters, the REST binding is used to implement the DSD query interface. 
This implies that the query transaction is executed as an HTTP GET request with the URL representing the query to execute and the HTTP response carrying the query response 
as an XML document. This section further profiles the REST binding as specified in the OASIS RegRep standard for use by the DSD.

##     3.1 Query Response of the DSD
An example of a successful QueryResponse of the DSD providing a collection of Data Services of Service Providers for a specific Evidence Type is shown in file 
[DSDQueryResponse.xml](https://ec.europa.eu/digital-building-blocks/code/projects/OOP/repos/tdd_chapters/browse/OOTS-EDM/xml/DSD/DSDQueryResponse.xml)

##     3.2 Query Error Response of the DSD
The Query Error Response of the DSD is syntactically expressed inside an [ebRS QueryResponse](http://docs.oasis-open.org/regrep/regrep-core/v4.0/os/regrep-core-rs-v4.0-os.html#__RefHeading__32277_422331532) using the [ebRS RegistryExceptionType](http://docs.oasis-open.org/regrep/regrep-core/v4.0/os/regrep-core-rs-v4.0-os.html#__RefHeading__32237_422331532). 
An example of Query Error Responses of the DSD due to an empty result set of the Data Service is shown in the following XML snippet:

    <query:QueryResponse xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" \
        xmlns:rs="urn:oasis:names:tc:ebxml-regrep:xsd:rs:4.0" \
        xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:4.0" \
        xmlns:query="urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0" \
        xmlns:xlink="http://www.w3.org/1999/xlink" \
        status="urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure"> \
        <rs:Exception \
            xsi:type="rs:ObjectNotFoundExceptionType" \
            severity="urn:oasis:names:tc:ebxml-regrep:ErrorSeverityType:Error" \
            message="No Data services were found based on the given parameters" \
            code="DSD:ERR:0001"> \
        </rs:Exception> \
    </query:QueryResponse> \

The file [DSDQueryErrorResponse](https://ec.europa.eu/digital-building-blocks/code/projects/OOP/repos/tdd_chapters/browse/OOTS-EDM/xml/DSD/DSDQueryErrorResponse.xml)

DSDErrorResponseCodes:
    * 1	Data Services Not Found			rs:ObjectNotFoundExceptionType	DSD:ERR:0001	No Data Services were found based on the given parameters
    * 2	Evidence Type Not Found			rs:ObjectNotFoundExceptionType	DSD:ERR:0002	The Evidence requested cannot be found
    * 3	Bad Query Parameters			rs:InvalidRequestExceptionType	DSD:ERR:0003	The query parameters do not follow the query specification
    * 4	Unknown Query	        		rs:InvalidRequestExceptionType	DSD:ERR:0004	The requested Query does not exist
    * 5	Additional Parameters Required	rs:ObjectNotFoundExceptionType	DSD:ERR:0005	The query requires the included extra attributes to be provided by the user
    * 6	Incorrect Parameter Value		rs:InvalidRequestExceptionType	DSD:ERR:0006	Incorrect provided value for requested parameters

##     3.3. DSD Response Requesting Additional User Provided Attributes 
##     3.3.1. Jurisdiction Context
When the DataServiceEvidenceType class contains the EvidenceProviderJursidictionDetermination, the returned exception MUST contain:
* One slot with name DataServiceEvidenceType with a slot value of type rim:AnyValueType. The contents of the slot value MUST be mandatory elements of the DataServiceEvidenceType with the descriptions included. When responding to the exception, if the specific DataServiceEvidenceType is the one selected by the user, the Evidence Requester MUST add a new query parameter with name evidence-type-id and value the identifier of the DataServiceEvidenceType.
* One slot with name JurisdictionDetermination with a slot value of type rim:AnyValueType. The contents of the slot value MUST be the complete structure of the EvidenceProviderJursidictionDetermination. When responding to the exception, the Evidence Requester MUST add a new query parameter with name jurisdiction-context-id with a value equal to the JurisdictionContextId element's value of the JurisdictionDerermination slot.
* Additionally, the query must now provide the extra level of jurisdiction level values required, as declared in the JurisdictionLevel element of the JurisdictionDetermination slot, by using the pre-defined parameters jurisdiction-admin-l3 and/or jurisdiction-admin-l2

An example showing the Jurisdiction Context is provided in sample [DSDQueryResponseJurisdiction.xml](https://ec.europa.eu/digital-building-blocks/code/projects/OOP/repos/tdd_chapters/browse/OOTS-EDM/xml/DSD/DSDQueryResponseJurisdiction.xml)
When responding to the example above, the Evidence Requester MUST add the JurisdictionContextId parameter with the value of the JurisdictionContextId found in the exception, accompanied by the proper jurisdiction level ( in the example the LAU code) provided by the user as follows: \
	«server base url»/rest/search?queryId=urn:oots:dsd:ebxml-regrep:queries:dataservices-by-evidencetype-and-jurisdiction&evidence-type-classification=CertificateOfBirth&country-code=MS&evidence-type-id=DSEV-ID1&jurisdiction-context-id=PlaceOfBirth&jurisdiction-admin-l2=MS202&jurisdiction-admin-l3=02200334

##     3.3.1. Evidence Provider Classification
When the DataServiceEvidenceType class contains the EvidenceProviderClassification elements, the returned exception MUST contain:
* One slot with name DataServiceEvidenceType with a slot value of type rim:AnyValueType. The contents of the slot value MUST be mandatory elements of the DataServiceEvidenceType with the descriptions included. When responding to the exception, if the specific DataServiceEvidenceType is the one selected by the user, the Evidence Requester MUST add a new query parameter with name evidence-type-id and value the identifier of the DataServiceEvidenceType.
* One slot with name UserRequestedClassificationConcepts with a slot value of type rim:CollectionValueType with collectionType="urn:oasis:names:tc:ebxml-regrep:CollectionType:Set". The contents of the slot value MUST be the complete structure of the EvidenceProviderClassification, with each EvidenceProviderClassification placed inside a rim:element of type rim:AnyValyeType.  When responding to the exception, the Evidence Requester MUST add a new query parameter for every Classification Concept existing in the EvidenceProviderClassification element, using the ClassificationConcept Identifier as its name and providing as a value one that complies with the Type, ValueExpression and Description of the Classification Concept.
The following example shows an exception sent back to the Evidence Requester containing a UserRequestedClassificationConcepts slot, stating that the user should provide his type of insurance using a string value: [DSDQueryResponseEPClassification.xml](https://ec.europa.eu/digital-building-blocks/code/projects/OOP/repos/tdd_chapters/browse/OOTS-EDM/xml/DSD/DSDQueryResponseEPClassification.xml)

##     4. DSD Interaction Examples
##     4.1.Registration by the MS
In this example a MS needs to register an Insurance Certificate for Companies evidence type. For this specific MS, the evidence type is issued by Evidence Providers that are located in the same region as the company's headquarters and thus the Jurisdiction Determination context is "Company's headquarters location", with the response required to be a NUTS2 based code. The following snippet shows how this jurisdiction context is defined in the DSD DataServiceEvidenceType element:
The sample file is [DSDRegistrationMS.xml](https://ec.europa.eu/digital-building-blocks/code/projects/OOP/repos/tdd_chapters/browse/OOTS-EDM/xml/DSD/DSDRegistrationMS.xml)

##     4.2. Registration of Data Services and Evidence Providers
The Evidence Providers of the specific MS must now register their capability on providing the Insurance certificate, but associating themselves to the specific DataServiceEvidenceType registered by the MS. For the example, two Evidence Providers are able to issue this evidence type for the MS, but are assigned different types of classifications. Evidence Provider 1 supports public insurance policies, while evidence provider 2 supports only private ones. 
The following XML example shows how the data services will be properly declared to contain also these classifications: [DSDRegistrationDSandEP.xml](https://ec.europa.eu/digital-building-blocks/code/projects/OOP/repos/tdd_chapters/browse/OOTS-EDM/xml/DSD/DSDRegistrationDSandEP.xml)
These Data Sevices and Evidence Providers registration integrated into the complete record in the DSD are illustrated in the sample [DSDRegistrationOfDataServices.xml](https://ec.europa.eu/digital-building-blocks/code/projects/OOP/repos/tdd_chapters/browse/OOTS-EDM/xml/DSD/DSDRegistrationOfDataServices.xml)

##     4.3. Evidence Requester Query
The Evidence Requester needs to fetch the Evidence Providers that can provide an evidence type with Evidence Type Classification CertificateOfInsurance, as it was extracted from the Evidence Broker. 
The DSD receives the requests and checks whether the specific evidenceType for country MS has a DataServiceEvidenceType contains either a Jurisdiction Context or a classification scheme. 

In our example, both exists and thus it must return an exception requesting information on both the Jurisdiction Context and the Classification Scheme. 
The Evidence Requester will then request the company's headquarters location, using the NUTS2 codes of country MS and will also ask the type of insurance the company supports from the user and then create a new HTTP as follows: \
	«server base url»/rest/search?queryId=urn:fdc:oots:dsd:ebxml-regrep:queries:dataservices-by-evidencetype-and-jurisdiction&evidence-type-classification=CertificationOfInsurance&country-code=MS&evidence-type-id=DSEV-ID1&jurisdiction-context-id=CompanyHq&jurisdiction-admin-l2=MS77&TypeOfInsurance=public
	where "DSEV-ID1", "MS77" and "public" are values provided by the user.
    
The DSD is able to properly provide a DataServiceEvidenceType with the appropriate Data Services and Evidence Providers. For example, the following response will be returned shown in file: 
[DSDQueryResponse.xml](https://ec.europa.eu/digital-building-blocks/code/projects/OOP/repos/tdd_chapters/browse/OOTS-EDM/xml/DSD/DSDQueryResponse.xml)




