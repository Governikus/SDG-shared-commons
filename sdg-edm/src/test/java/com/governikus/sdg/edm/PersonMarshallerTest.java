package com.governikus.sdg.edm;

import static org.junit.Assert.assertNotNull;

import org.junit.Test;

import com.governikus.sdg.edm.jaxb.PersonType;

public class PersonMarshallerTest
{
  @Test
  public void testBasic ()
  {
    final String s = "<sdg:Person xmlns:sdg=\"http://data.europa.eu/p4s\">\r\n" +
                     "          <sdg:LevelOfAssurance>High</sdg:LevelOfAssurance>\r\n" +
                     "          <sdg:Identifier schemeID=\"eidas\">DK/DE/123456</sdg:Identifier>\r\n" +
                     "          <sdg:FamilyName>Smith</sdg:FamilyName>\r\n" +
                     "          <sdg:GivenName>John</sdg:GivenName>\r\n" +
                     "          <sdg:DateOfBirth>1970-03-01</sdg:DateOfBirth>\r\n" +
                     "          <sdg:PlaceOfBirth>Hamburg, Germany</sdg:PlaceOfBirth>\r\n" +
                     "          <sdg:CurrentAddress>\r\n" +
                     "            <sdg:FullAddress>Dieter Wellhausen 71</sdg:FullAddress>\r\n" +
                     "            <sdg:AdminUnitLevel1>DE</sdg:AdminUnitLevel1>\r\n" +
                     "          </sdg:CurrentAddress>\r\n" +
                     "          <sdg:Gender>Male</sdg:Gender>\r\n" +
                     "        </sdg:Person>";
    final PersonType p = new PersonMarshaller ().read (s);
    assertNotNull (p);
  }
}
