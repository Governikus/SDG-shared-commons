package com.governikus.sdg.edm.schematron;

import static org.junit.Assert.assertNotNull;

import org.junit.Test;

/**
 * Test class for class {@link SdgSchematronValidator}.
 *
 * @author Philip Helger
 */
public final class SdgSchematronValidatorTest
{
  @Test
  public void testBasic ()
  {
    assertNotNull (SdgSchematronValidator.evidenceExceptionValidator ());
    assertNotNull (SdgSchematronValidator.evidenceRequestValidator ());
    assertNotNull (SdgSchematronValidator.evidenceResponseValidator ());
  }
}
