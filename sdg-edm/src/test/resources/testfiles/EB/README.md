# Evidence Broker Samples

## 1. Introduction 
The Evidence Broker is one of the Common Services of the OOTS HLA. It is a service that publishes which types of evidence Member States can provide to prove a particular requirement of a procedure. It provides metadata on the requirements applicable in a procedure and which type of evidence can be used by the User to prove fulfilment. Using the mapping from criteria or information requirements to possible evidence types, the Evidence Requester can find the evidence types that can prove that the User fulfills the requirements of the procedure.
The EB Information Model is based on the ISA2 SEMIC Core Criterion and Core Evidence Vocabulary (CCCEV) v2.0. The CCCEV is designed to support the exchange of information between organisations defining requirements and organisations responding to these requirements by means of evidence types.

The CCCEV contains two basic and complementary core concepts:
* The Requirement, which is used as the basis for making a judgement or decision, e.g. a requirement set in a public tender or a condition that has to be fulfilled for a public service to be executed;
* The Evidence Type, which proves that something else exists or is true. In particular, an evidence is used to prove that a specific requirement is met by someone or by something.
## 2. Requirement Model
One of the central concepts of the Evidence Broker is the ‘Requirement’. It is a condition or prerequisite that someone requests and someone else has to meet.

The requirement is realised by three concrete types of requirements: The Information Requirement, the Criterion and the Constraint.
* The Information Requirement is to be seen as a request for data that proves one or more facts of the real world, or that leads to the source of such a proof.
* The Criterion is to be seen as a condition that will be evaluated.
* The Constraint is a limitation imposed on any type of requirement or on an element defined inside a requirement.

## 2. Query Interface 
###     2.1. Example of the Query Response of the EB for the "Requirement Query"
The Query Response of the EB of an Requirement Query returns a RegRep QueryResponse document which MUST either contain an Exception or RegistryObjectList element with zero or more RegistryObjects. Each RegistryObject in the result MUST include one Slot element with a SlotValue of type rim:AnyValueType and a single Requirement child element, following the SDGR Application Profile of the EB. The SDGR application profile of the EB describes how the SDG-Generic-Metadata Profile (SDG-syntax) is profiled in ebRIM in order to compose a valid QueryResponse. It therefore contains a mapping to the underlying SDG-syntax elements and necessary parameters to compose a QueryResponse.  The namespace of the SDG-syntax is [http://data.europa.eu/p4s](http://data.europa.eu/p4s). 
The query response contains the list of evidence types that fulfil the specific requirement of the query, filtered by the jurisdiction level code. The following example shows a response using the SDG Application Profile XML Representation
[Response_for_Get_Evidence_Type_for_Requirement_Query.xml](https://ec.europa.eu/digital-building-blocks/code/projects/OOP/repos/tdd_chapters/browse/OOTS-EDM/xml/EB/Response_for_Get_Evidence_Type_for_Requirement_Query.xml)

###     2.2. Example of the Query Response of the EB for the "Get Evidence Types for Requirement Query"
The Query Response of the EB  for Evidence Types that prove a specific requirement returns a RegRep QueryResponse document which MUST either contain an Exception or RegistryObjectList element with zero or more RegistryObjects. Each RegistryObject in the result MUST include one Slot element with a SlotValue of type rim:AnyValueType and a single Requirement child element, following the SDGR Application Profile of the EB. The SDGR application profile of the EB describes how the SDG-Generic-Metadata Profile (SDG-syntax) is profiled in ebRIM in order to compose a valid QueryResponse. It therefore contains a mapping to the underlying SDG-syntax elements and necessary parameters to compose a QueryResponse.  The namespace of the SDG-syntax is http://data.europa.eu/p4s. 
The query response contains the list of evidence types that fulfil the specific requirement of the query, filtered by the jurisdiction level code. The following example shows a response using the SDG Application Profile XML Representation.
[Response_for_Get_List_of_Requirements_Query.xml](https://ec.europa.eu/digital-building-blocks/code/projects/OOP/repos/tdd_chapters/browse/OOTS-EDM/xml/EB/Response_for_Get_List_of_Requirements_Query.xml)

###     2.3. Example of the Query Error Response of the Evidence Broker
An example of Query Error Responses of the Evidence Broker due to an empty list of requirements is shown in the following XML sample:
[Query_Error_Response.xml](https://ec.europa.eu/digital-building-blocks/code/projects/OOP/repos/tdd_chapters/browse/OOTS-EDM/xml/EB/Query_Error_Response.xml)

## 3. Registry object Queries

### 3.1. Registry Object Evidence Type
This Registry Object provides the information of the Evidence Type. The classification node used MUST be EvidenceTypeunder the EB Classification Scheme urn:fdc:oots:classification:eb.
An example of EvidenceType Registry Object in XML format is shown in the following XML sample:
[Registry_Object_Evidence_Type.xml](https://ec.europa.eu/digital-building-blocks/code/projects/OOP/repos/tdd_chapters/browse/OOTS-EDM/xml/EB/Registry_Object_Evidence_Type.xml)

### 3.2.Registry Object Evidence Type List
This Registry Object provides the information of a Requirement in any of its derivative forms (Critertion, Information Requirement). It MUST NOT contain any Evidence Type or Reference Frameworks (Procedures) as this are provided dynamically by the use of associations. The classification node used MUST be Requirement under the EB Classification Scheme urn:fdc:oots:classification:eb.
An example of Requirement Registry Object in XML format is shown in the following XML sample:
[Registry_Object_Evidence_Type_List.xm](https://ec.europa.eu/digital-building-blocks/code/projects/OOP/repos/tdd_chapters/browse/OOTS-EDM/xml/EB/Registry_Object_Evidence_Type_List.xml)

### 3.3.Registry Object Requirement
This Registry Object provides the information of a Requirement in any of its derivative forms (Critertion, Information Requirement). It MUST NOT contain any Evidence Type or Reference Frameworks (Procedures) as this are provided dynamically by the use of associations. The classification node used MUST be Requirement under the EB Classification Scheme urn:fdc:oots:classification:eb.
An example of Requirement Registry Object in XML format is shown in the following XML sample:
[Registry_Object_Requirement.xml](https://ec.europa.eu/digital-building-blocks/code/projects/OOP/repos/tdd_chapters/browse/OOTS-EDM/xml/EB/Registry_Object_Requirement.xml)

### 3.4.Registry Object Procedure
This Registry Object provides the information of a Procedure. It MUST NOT contain any relations to other Reference Frameworks (Procedures) as this are provided dynamically by the use of associations. The classification node used MUST be Procedure under the EB Classification Scheme urn:fdc:oots:classification:eb.
A Procedure Registry Object sample in XML Format is shown in the following XML sample:
[Registry_Object_Procedure.xml](https://ec.europa.eu/digital-building-blocks/code/projects/OOP/repos/tdd_chapters/browse/OOTS-EDM/xml/EB/Registry_Object_Procedure.xml)

