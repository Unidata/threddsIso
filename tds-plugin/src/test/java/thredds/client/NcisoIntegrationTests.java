package thredds.client;

import static com.google.common.truth.Truth.assertThat;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import org.junit.Test;

public class NcisoIntegrationTests {

  @Test
  public void testNCML() throws Exception {
    HttpRequestService req = new HttpRequestService();
    String result = req.sendHttpGet("http://localhost:8080/thredds/ncml/test/testData.nc?",
        "catalog=http://localhost:8080/thredds/catalog.html&dataset=testDataset");
    assertThat(result).contains("group name=\"CFMetadata\"");
  }

  @Test
  public void testUDDC() throws Exception {
    HttpRequestService req = new HttpRequestService();
    String result = req.sendHttpGet("http://localhost:8080/thredds/uddc/test/testData.nc?",
        "catalog=http://localhost:8080/thredds/catalog.html&dataset=testDataset");
    assertThat(result).contains("Total Score:");
  }

  @Test
  public void testISO() throws Exception {

    HttpRequestService req = new HttpRequestService();
    String result = req.sendHttpGet("http://localhost:8080/thredds/iso/test/testData.nc?",
        "catalog=http://localhost:8080/thredds/catalog.html&dataset=testDataset");
    assertThat(result).contains("gmd:fileIdentifier");
  }

  @Test
  public void encodedRequest() throws UnsupportedEncodingException {
    String catalogUrl = "http://motherlode.ucar.edu:8080/thredds/catalog/satellite/3.9/WEST-CONUS_4km/current/catalog.html";
    String datasetId = "SSEC/IDD-Satellite/3.9/WEST-CONUS_4km/current/WEST-CONUS_4km_3.9_20111104_1300.gini";
    catalogUrl = URLEncoder.encode(catalogUrl, "UTF-8");
    datasetId = URLEncoder.encode(datasetId, "UTF-8");
    System.out.println("catalogUrl: " + catalogUrl);
    System.out.println("datasetId: " + datasetId);
    assertThat(catalogUrl).isNotEmpty();
    assertThat(datasetId).isNotEmpty();
  }
}
