package thredds.client;

import static org.junit.Assert.assertTrue;

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
}
