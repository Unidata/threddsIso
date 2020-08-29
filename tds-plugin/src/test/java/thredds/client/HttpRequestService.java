package thredds.client;

//import org.apache.commons.httpclient.HttpClient;
//import org.apache.commons.httpclient.methods.GetMethod;

public class HttpRequestService {

	public String sendHttpGet(String url, String queryString) throws Exception {
        String result = null;
    
        try {
//            HttpClient client = new HttpClient();
//            GetMethod get = new GetMethod(url);
//            get.setQueryString(queryString);
//            client.executeMethod(get);
//
//            result = get.getResponseBodyAsString();
//            get.releaseConnection();
        } 
        catch (Exception e) {
            throw new Exception("Get failed", e);
        }
        
        return result;
	}
	

}
