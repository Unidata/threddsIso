/*package gov.noaa.eds.service;

import gov.noaa.eds.threddsutilities.exception.ThreddsUtilitiesException;
import gov.noaa.eds.threddsutilities.service.iface.ICatalogCrawler;
import gov.noaa.eds.threddsutilities.service.impl.CatalogCrawlerImpl;
import gov.noaa.eds.util.FileUtility;

import java.io.IOException;
import java.util.Vector;

import org.apache.commons.httpclient.DefaultHttpMethodRetryHandler;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.params.HttpMethodParams;

public class OGCLocatorService {
    private String _threddsServer = null; 
    private int _numSample = 1;
    private int _depth = -1;
    
    public void setServer(String tdsServer, int depth, int numSample) {
    	_depth = depth;
    	_threddsServer = tdsServer;
    	_numSample = numSample;
    }
    
	public boolean hasWMS(String urlStr) {

		boolean wmsExists = false;
		HttpClient client = new HttpClient();

		// Create a method instance.
		GetMethod method = new GetMethod(urlStr);
		System.out.println(urlStr);
		// Provide custom retry handler is necessary
		method.getParams().setParameter(HttpMethodParams.RETRY_HANDLER,
				new DefaultHttpMethodRetryHandler(2, false));

		try {
			// Execute the method.
			int statusCode = client.executeMethod(method);

			if (statusCode != HttpStatus.SC_OK) {
				System.err.println("Method failed: " + method.getStatusLine());
			}

			// Read the response body.
			String responseBody = method.getResponseBodyAsString();
			if (responseBody.contains("<Service>")) wmsExists = true;


		} catch (HttpException e) {
			System.err.println("Fatal protocol violation: " + e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			System.err.println("Fatal transport error: " + e.getMessage());
			e.printStackTrace();
		} finally {
			// Release the connection.
			method.releaseConnection();
		}
		return wmsExists;
	}
	
    public void generateCatalog(){
        ICatalogCrawler crawler = new CatalogCrawlerImpl();
        FileUtility fu = new FileUtility("wmsservices.csv");
        fu.openFileWriter();
        fu.writeln("ServiceLink");
    
        int wmsCnt = 0;
        try {

            Vector<MetadataContainer> urls = new Vector<String>(0);
            crawler.crawlThredds(_threddsServer, _depth, _numSample, urls);
            boolean wmsExists;
            String wmsUrl = "";
            for(String urlStr:urls){
            	wmsExists = false;
        		wmsUrl  = urlStr + "?service=WMS&version=1.3.0&request=GetCapabilities";
        		wmsUrl = wmsUrl.replace("dodsC", "wms");
        		wmsExists = hasWMS(wmsUrl);
                
                if (wmsExists) {
                	fu.writeln(wmsUrl);
                	wmsCnt++;
                }
            }
            fu.close();
            
        } catch (ThreddsUtilitiesException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        } 
    }
}
*/