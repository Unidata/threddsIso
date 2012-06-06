package thredds.client;

import static org.junit.Assert.assertTrue;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import org.junit.Test;

public class NcisoIntegrationTests {
	
	@Test
	public void testNCML() {

		HttpRequestService req = new HttpRequestService();
	    try {
	    	String result = req.sendHttpGet("http://localhost:8080/thredds/ncml/test/testData.nc?","catalog=http://localhost:8080/thredds/catalog.html&dataset=testDataset");
			assertTrue(result.contains("group name=\"CFMetadata\""));
		} catch (Exception e) {
			assertTrue(false);
		}
        
	}
	
	@Test
	public void testUDDC() {

		HttpRequestService req = new HttpRequestService();
	    try {
		    String result = req.sendHttpGet("http://localhost:8080/thredds/uddc/test/testData.nc?","catalog=http://localhost:8080/thredds/catalog.html&dataset=testDataset");
			assertTrue(result.contains("Total Score:"));
		} catch (Exception e) {
			assertTrue(false);
		}
        
	}	
	
	@Test
	public void testISO() {

		HttpRequestService req = new HttpRequestService();
	    try {
	    	String result = req.sendHttpGet("http://localhost:8080/thredds/iso/test/testData.nc?","catalog=http://localhost:8080/thredds/catalog.html&dataset=testDataset");
			assertTrue(result.contains("gmd:fileIdentifier"));
		} catch (Exception e) {
			assertTrue(false);
		}
        
	}	
	
	@Test
	public void encodedRequest() {
		String catalogUrl = "http://motherlode.ucar.edu:8080/thredds/catalog/satellite/3.9/WEST-CONUS_4km/current/catalog.html";
		String datasetId = "SSEC/IDD-Satellite/3.9/WEST-CONUS_4km/current/WEST-CONUS_4km_3.9_20111104_1300.gini";
        try {
			catalogUrl = URLEncoder.encode( catalogUrl, "UTF-8" );
	        datasetId = URLEncoder.encode( datasetId, "UTF-8" );
	        System.out.println("catalogUrl: " + catalogUrl);
	        System.out.println("datasetId: " + datasetId);
	        assertTrue(true);
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			assertTrue(false);
			e.printStackTrace();
		}


	}
}
