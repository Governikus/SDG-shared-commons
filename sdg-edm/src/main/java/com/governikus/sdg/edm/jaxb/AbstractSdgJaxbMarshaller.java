package com.governikus.sdg.edm.jaxb;

import java.util.List;
import java.util.function.Function;

import javax.annotation.Nonnull;

import com.governikus.sdg.edm.CSdgEdm;
import com.helger.commons.collection.impl.CommonsArrayList;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.jaxb.GenericJAXBMarshaller;

import jakarta.xml.bind.JAXBElement;

/**
 * Base class for all SDG XML marshallers. It abstracts the link to the right
 * XML Schema to be used for validation.
 *
 * @author Philip Helger
 * @param <JAXBTYPE>
 *        Implementation type
 */
public abstract class AbstractSdgJaxbMarshaller <JAXBTYPE> extends GenericJAXBMarshaller <JAXBTYPE>
{
  private static final List <ClassPathResource> XSDS = new CommonsArrayList <> (new ClassPathResource ("external/schemas/sdg/SDG-GenericMetadataProfile-v0.99-SNAPSHOT.xsd",
                                                                                                       CSdgEdm.getCL ()));

  protected AbstractSdgJaxbMarshaller (@Nonnull final Class <JAXBTYPE> aType,
                                       @Nonnull final Function <? super JAXBTYPE, ? extends JAXBElement <JAXBTYPE>> aJAXBElementWrapper)
  {
    super (aType, XSDS, aJAXBElementWrapper);
  }
}
