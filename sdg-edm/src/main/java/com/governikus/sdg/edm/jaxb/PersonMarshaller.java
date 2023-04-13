package com.governikus.sdg.edm.jaxb;

public class PersonMarshaller extends AbstractSdgJaxbMarshaller <PersonType>
{
  public PersonMarshaller ()
  {
    super (PersonType.class, new ObjectFactory ()::createPerson);
  }
}
