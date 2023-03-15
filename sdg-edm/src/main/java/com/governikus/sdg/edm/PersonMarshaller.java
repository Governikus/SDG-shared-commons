package com.governikus.sdg.edm;

import com.governikus.sdg.edm.jaxb.ObjectFactory;
import com.governikus.sdg.edm.jaxb.PersonType;

public class PersonMarshaller extends AbstractSdgJaxbMarshaller <PersonType>
{
  public PersonMarshaller ()
  {
    super (PersonType.class, new ObjectFactory ()::createPerson);
  }
}
