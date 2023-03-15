package com.governikus.sdg.edm;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

@Immutable
public final class CSdgEdm
{
  /**
   * XML namespace URI for the SDG data model.
   */
  public static final String SDG_XML_NAMESPACE_URI = "http://data.europa.eu/p4s";

  private CSdgEdm ()
  {}

  @Nonnull
  public static ClassLoader getCL ()
  {
    return CSdgEdm.class.getClassLoader ();
  }
}
