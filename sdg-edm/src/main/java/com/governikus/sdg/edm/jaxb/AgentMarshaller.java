package com.governikus.sdg.edm.jaxb;

public class AgentMarshaller extends AbstractSdgJaxbMarshaller <AgentType>
{
  public AgentMarshaller ()
  {
    super (AgentType.class, new ObjectFactory ()::createAgent);
  }
}
