# Evidence Request/Response Samples

## 1. Introduction 

Within [OOTS-EDM](https://ec.europa.eu/digital-building-blocks/wikis/pages/viewpage.action?pageId=489653731) some examples for the evidence exchange using the OOTS Exchange Data Model are provided. The samples can be used for sending and receiving evidences using the mechanisms 
defined in the design documents of the [Once-Only Technical System (OOTS)](https://ec.europa.eu/cefdigital/wiki/display/CEFDIGITAL/Once+Only+Principle)
developed for the EU's [Single Digital Gateway regulation](https://ec.europa.eu/growth/single-market/single-digital-gateway_en). 
In this section, some examples for the evidence exchange using the OOTS Exchange Data Model are provided. 
The Request-Response samples can be found in the [OOTS-EDM/XML folder of the tdd_chapters git repository](https://ec.europa.eu/digital-building-blocks/code/projects/OOP/repos/tdd_chapters/browse/OOTS-EDM/xml).

## 2. Example for requesting a birth certificate 
Example for requesting a birth certificate In this example, we consider the case of a natural person that needs to provide a prove of birth. 
Therefore an Evidence Requester is requesting a birth certificate on behalf of the natural person. To do this, an Evidence Request is sent, which 
contains information about who is participating in this data exchange and which DataServiceEvidenceType is required. 
The information about the required DataServiceEvidenceType has been received from the DSD. The request is sent to a service that can provide the 
evidence (Evidence Provider). The Evidence Provider then sends back to the Evidence Requester an Evidence Response that contains the certificates 
that has been requested. The  example can be also found in the [Git Repository](https://ec.europa.eu/digital-building-blocks/code/projects/OOP/repos/tdd_chapters/browse/OOTS-EDM/xml/Request-Response%20Samples/Birth%20Certificate). 

##     2.1. Step 1: Evidence Request Header and Evidence Request 
The sender of the Evidence Request uses an ebMS message header that contains the Access Point identifiers as sender and receiver. Using an eDelivery AS4 profile enhancement, however, the outer corners, i.e. the Evidence Requester 
(originalSender) and Evidence Provider (finalRecipient), can be included in the ebMS message header. For the identification of the Access Points in 
the ebMS message header, i.e. the values to be used in the /PartyInfo/To/PartyId element are extracted from the DSD Response. The Evidence Request itself 
is referenced in the /PayloadInfo element. More information about the ebMS message header can be found at in the eDelivery Configuration. 
* Step 1: [XML example of the ebMS message header for the Evidence Request](https://ec.europa.eu/digital-building-blocks/code/projects/OOP/repos/tdd_chapters/browse/OOTS-EDM/xml/Request-Response%20Samples/Birth%20Certificate/oots_request_header.xml) 
The Evidence Request itself contains information about the Evidence Requester who is requesting the birth certificate for a natural person from the Evidence Provider based on the underlying procedure 
and requirements. More information about how this information is represented within the XML document can be found in the Evidence Request Syntax Mapping. 
* Step 1: [XML example of Evidence Request for a birth certificate](https://ec.europa.eu/digital-building-blocks/code/projects/OOP/repos/tdd_chapters/browse/OOTS-EDM/xml/Request-Response%20Samples/Birth%20Certificate/oots_request.xml)

##     2.2. Step 2: Evidence Response Header and Evidence Response 
Similar to the request, the sender of the Evidence Response uses an ebMS message header 
that contains the Access Point identifiers as sender and receiver. Next to the Evidence Request itself the requested evidence object is additionally 
included to the /PayloadInfo element of the ebMS message header. More information about the ebMS message header can be found at in the eDelivery Configuration. 
* Step 2: [XML example of ebMS message header for the Evidence Response](https://ec.europa.eu/digital-building-blocks/code/projects/OOP/repos/tdd_chapters/browse/OOTS-EDM/xml/Request-Response%20Samples/Birth%20Certificate/oots_response_header.xml) 
The Evidence Response itself contains information about the Evidence 
Provider who is providing the birth certificate and its associated Evidence Metadata for a natural person based on the Evidence Request issued by the 
Evidence Requester. The /rim:RepositoryItemRef provides a references to the evidence object in the ebMS message header.  
More information about how this information is represented within the XML document can be found in the Evidence Response Syntax Mapping. 
XML sample of Evidence Response for a birth certificate 
* Step 2: [XML example of Evidence Response for a birth certificate](https://ec.europa.eu/digital-building-blocks/code/projects/OOP/repos/tdd_chapters/browse/OOTS-EDM/xml/Request-Response%20Samples/Birth%20Certificate/oots_response.xml) 

## 3. Example for requesting Secondary Education Completition Evidence with Error Response requesting an Evidence Provider side Preview 
In this example, we consider the case of a natural person that needs to prove secondary education completition. 
Therefore an Evidence Requester is requesting a Secondary Education Completition Evidence and its supplement on behalf of the natural person. 
To do this, an Evidence Request is sent, which contains information about who is participating in this data exchange and which DataServiceEvidenceType is required. 
The information about the required DataServiceEvidenceType has been received from the DSD. The request is sent to a service that can provide the evidence
(Evidence Provider). 
  Since for this evidence type a preview on the side of the Evidence Provider is required, the Evidence Provider responds with an 
Error Response who rejects a direct evidence provision and informs the Evidence Requester about the required preview location, location and method 
provided for the Evidence Provider. The Evidence Requester than redirects the user (natural person) to the corresponding preview location and sends 
a second Evidence Request after the preview.  
  The Evidence Provider matches the second Evidence Request with the preview results and sends an 
Evidence Response with the the Secondary Education Completition Evidence and its supplement to the Evidence Requester. As the ebMS message header 
has been already introduced in the preview example illustrating the request for a birth certificate it is not repeated here even though it is needed 
for the message exchange. 
  The complete example can be found in the [Git Repository](https://ec.europa.eu/digital-building-blocks/code/projects/OOP/repos/tdd_chapters/browse/OOTS-EDM/xml/Request-Response%20Samples/Secondary%20Education%20Completion%20Evidence). 

##     3.1 Step 1: Initiating Evidence Request 
The initating Evidence Request contains information about the Evidence Requester who is requesting the Secondary Education Completition Evidence 
for a natural person from the Evidence Provider based on the underlying procedure and requirements. More information about how this information is 
represented within the XML document can be found in the Evidence Request Syntax Mapping. 
* Step 1: [XML example of the initiating Evidence Request for a Secondary Education Completition Evidence Expand source](https://ec.europa.eu/digital-building-blocks/code/projects/OOP/repos/tdd_chapters/browse/OOTS-EDM/xml/Request-Response%20Samples/Secondary%20Education%20Completion%20Evidence/oots_request1_preview.xml) 

##     3.2 Step 2: Error Response 
The response status provided by the Evidence Provider is declared as failure. The rs:Exception type provided by the Evidence Provider references to an 
authorization problem which requires a user redirection to a preview location where the user can preview, select and give his consent to use the evidence. 
Therefore the Evidence provider informs the Evdience Requester about the required preview location, location and method. 
More information about how this information is represented within the XML document can be found in the Error Response Syntax Mapping.
* Step 2: [XML example of the Error Response returned by the Evidence Provider](https://ec.europa.eu/digital-building-blocks/code/projects/OOP/repos/tdd_chapters/browse/OOTS-EDM/xml/Request-Response%20Samples/Secondary%20Education%20Completion%20Evidence/oots_exception_preview.xml)

##     3.3 Step 3: Second Evidence Request 
The Evidence Requester redirects the user (natural person) to the corresponding preview location. 
After the execution of the preview the Evidence Requester sends a second Evidence Request to the Evidence Provider containing the preview location. 
More information about how this information is represented within the XML document can be found in the Evidence Request Syntax Mapping. 
* Step 3: [XML example of the second Evidence Request for a Secondary Education Completition Evidence](https://ec.europa.eu/digital-building-blocks/code/projects/OOP/repos/tdd_chapters/browse/OOTS-EDM/xml/Request-Response%20Samples/Secondary%20Education%20Completion%20Evidence/oots_request2_after_preview.xml)

##     3.4 Step 4: Evidence Response 
Evidence Response After the execution of the preview and a matching of the preview results with the second Evidence Request, 
the Evidence Provider sends an Evidence Response with the Secondary Education Completition Evidence and its supplement to the Evidence Requester. 
More information about how this information is represented within the XML document can be found in the Evidence Response Syntax Mapping. 
* Step 4: [XML example of Evidence Response for a Secondary Education Completition Evidence](https://ec.europa.eu/digital-building-blocks/code/projects/OOP/repos/tdd_chapters/browse/OOTS-EDM/xml/Request-Response%20Samples/Secondary%20Education%20Completion%20Evidence/oots_response.xml)



