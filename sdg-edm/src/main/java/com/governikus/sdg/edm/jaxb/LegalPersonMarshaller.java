package com.governikus.sdg.edm.jaxb;

public class LegalPersonMarshaller extends AbstractSdgJaxbMarshaller <LegalPersonType>
{
  public LegalPersonMarshaller ()
  {
    super (LegalPersonType.class, new ObjectFactory ()::createLegalPerson);
  }
}
