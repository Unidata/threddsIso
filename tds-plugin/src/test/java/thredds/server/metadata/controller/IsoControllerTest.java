package thredds.server.metadata.controller;

import static com.google.common.truth.Truth.assertThat;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.InputStream;
import java.io.StringWriter;
import java.io.Writer;
import org.junit.BeforeClass;
import org.junit.Test;
import thredds.client.catalog.Dataset;
import thredds.server.metadata.nciso.util.ThreddsTranslatorUtil;
import thredds.server.metadata.service.EnhancedMetadataService;
import ucar.nc2.dataset.NetcdfDataset;
import ucar.nc2.dataset.NetcdfDatasets;

/**
 * Testing the IsoController
 *
 * This is a fake test, in that we are not actually testing the controller yet. Need to mock.
 *
 */
public class IsoControllerTest {

  private static File xslFile;

  @BeforeClass
  public static void setXls() {
    String ncIsoXslFilePath = ThreddsTranslatorUtil.class.getResource("/resources/xsl/nciso/UnidataDD2MI.xsl").getFile();
    xslFile = new File(ncIsoXslFilePath);
  }

  @Test
  public void testFakeIsoController() throws Exception {
    NetcdfDataset netCdfDataset = NetcdfDatasets.openDataset("file:src/test/resources/extent/test.ncml");
    Writer writer = new StringWriter();
    // Get Thredds level metadata if it exists
    Dataset ids = null;

    // Enhance with file and dataset level metadata
    EnhancedMetadataService.enhance(netCdfDataset, ids, writer);

    String ncml = writer.toString();
    writer.flush();
    writer.close();
    InputStream is = new ByteArrayInputStream(
        ncml.getBytes("UTF-8"));
    Writer isoWriter = new StringWriter();
    ThreddsTranslatorUtil.transform(xslFile, is, isoWriter);
    is.close();
    String iso = isoWriter.toString();
    assertThat(iso).isNotEmpty();
  }

}
