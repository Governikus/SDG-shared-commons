package com.governikus.sdg.edm.schematron;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.Immutable;
import javax.xml.transform.dom.DOMSource;

import org.w3c.dom.Document;

import com.governikus.sdg.edm.CSdgEdm;
import com.helger.commons.ValueEnforcer;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.xslt.SchematronResourceXSLT;

/**
 * Class that contains the basic API for performing Schematron validation based
 * on precompiled XSLT scripts.
 *
 * @author Philip Helger
 */
@Immutable
public final class SdgSchematronValidator
{
  @Immutable
  public static final class Validator
  {
    private final SchematronResourceXSLT m_aSch;

    public Validator (@Nonnull final ClassPathResource aXslt)
    {
      ValueEnforcer.notNull (aXslt, "XSLT");
      ValueEnforcer.isTrue ( () -> aXslt.canRead (), "XSLT cannot be read");
      m_aSch = new SchematronResourceXSLT (aXslt);
      ValueEnforcer.isTrue ( () -> m_aSch.isValidSchematron (), "Precompiled XSLT of " + aXslt + " is invalid");
    }

    @Nullable
    public SchematronOutputType validate (@Nonnull final Document doc) throws Exception
    {
      return m_aSch.applySchematronValidationToSVRL (new DOMSource (doc));
    }
  }

  private static final ClassPathResource XSLT_EVIDENCE_EXCEPTION = new ClassPathResource ("xslt/evidence_exception.xslt",
                                                                                          CSdgEdm.getCL ());
  private static final ClassPathResource XSLT_EVIDENCE_REQUEST = new ClassPathResource ("xslt/evidence_request.xslt",
                                                                                        CSdgEdm.getCL ());
  private static final ClassPathResource XSLT_EVIDENCE_RESPONSE = new ClassPathResource ("xslt/evidence_response.xslt",
                                                                                         CSdgEdm.getCL ());

  private SdgSchematronValidator ()
  {}

  @Nonnull
  public static Validator evidenceExceptionValidator ()
  {
    return new Validator (XSLT_EVIDENCE_EXCEPTION);
  }

  @Nonnull
  public static Validator evidenceRequestValidator ()
  {
    return new Validator (XSLT_EVIDENCE_REQUEST);
  }

  @Nonnull
  public static Validator evidenceResponseValidator ()
  {
    return new Validator (XSLT_EVIDENCE_RESPONSE);
  }
}
