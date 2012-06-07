package thredds.server.metadata.controller;

import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.context.ServletContextAware;

import thredds.catalog.InvCatalog;
import thredds.catalog.InvDataset;
import thredds.servlet.DataRootHandler;


public abstract class AbstractMetadataController implements ServletContextAware, IMetadataContoller {
	private static org.slf4j.Logger _log = org.slf4j.LoggerFactory
    .getLogger(AbstractMetadataController.class);
	
    protected static org.slf4j.Logger _logServerStartup = org.slf4j.LoggerFactory
	.getLogger("serverStartup");

    protected boolean _allow = false;	
    protected String _metadataServiceType = "";
    protected String _servletPath = "";  

	protected ServletContext sc; 
	protected File xslFile;

	public void setServletContext(ServletContext sc) {
		this.sc = sc;		
	}

	protected void isAllowed(final boolean allow, final String metadataServiceType, final HttpServletResponse res) throws Exception {
	    // Check whether TDS is configured to support service.
	    if ( ! allow )
	    {
	      res.sendError(HttpServletResponse.SC_FORBIDDEN, metadataServiceType + " service not supported");
	      return;
	    }
	}
	
	protected void returnError(final String message, final String metadataServiceType, final HttpServletResponse res) throws Exception {
	    res.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, metadataServiceType + " service failed. " + message);
	    return;
	}
	
	/** 
	* All metadata controllers must implement a handleMetadataRequest method.
	* 
	* @param request incoming url request 
	* @param response outgoing web based response
	* @throws ServletException if ServletException occurred
	* @throws IOException if IOException occurred 
	*/	
	public void handleMetadataRequest(final HttpServletRequest req,
		final HttpServletResponse res) throws ServletException, IOException {		
	}
	
	/** 
	* Get the THREDDS dataset object 
	* where catalogString and dataset are passed in the request string
	* @param request incoming url request 
	*/	
    protected InvDataset getThreddsDataset(final HttpServletRequest req) {
    	
    	InvCatalog catalog = null;
    	InvDataset ids = null;
        String catalogPath = null; 

        String catalogString = req.getParameter("catalog");
        String invDatasetString = req.getParameter("dataset");
        
    	try
        {  
    	 
          // Check for matching dataset and catalog.    
          DataRootHandler drh = DataRootHandler.getInstance();            		
    	  
          //Is the catalog generated dynamically by datasetScan?
          String dynamicCatStr = "thredds/catalog/"; //datasetScans catalog hrefs always begin with thredds/catalog
    	  String staticCatStr = "thredds/";
    	  
    	  if (catalogString.contains(".html")) catalogString = catalogString.substring(0,catalogString.length()-4) + "xml";
    	  
    	  // Check to see if it's a static or dynamically generated catalog
          if (catalogString.contains(dynamicCatStr)) {
              catalogPath = catalogString.substring(catalogString.indexOf(dynamicCatStr)+dynamicCatStr.length(),catalogString.length());	
          } else {
        	  catalogPath = catalogString.substring(catalogString.indexOf(staticCatStr)+staticCatStr.length(),catalogString.length());
          }

          _log.debug("ncISO catalogPath=" + catalogPath +"; " + "dataset=" + invDatasetString + "; invDatasetString=" + invDatasetString);

          catalog = drh.getCatalog( catalogPath, new URI( catalogString ) );
          if (catalog==null) {
        	  _log.error("catalog is not found using catalogPath: " + catalogPath + "; and catalogString: " + catalogString);
        	  return null;
          } else {
        	  _log.debug("catalog found! catalog name: " + catalog.getName());
        	  ids = (InvDataset) catalog.findDatasetByID(invDatasetString);        	 
          }
          
          
          if (ids!=null) {
              _log.debug("Dataset information retrieved!"
              + ids.getCatalogUrl() + "; id=" + ids.getName());          
          } else {
              _log.debug("ids dataset not found!: " + invDatasetString);
              return null;
          }
          
          if (ids.hasNestedDatasets()) {
        	  String nestedDataset = invDatasetString.substring((invDatasetString.lastIndexOf("/")+1), invDatasetString.length());
        	  //then look up the individual nested dataset using 
        	  InvDataset nds = ids.findDatasetByName(nestedDataset);
        	  _log.debug("nestedDataset name: " + nestedDataset);
        	  return nds;
          }
          
          return ids;
        } catch ( URISyntaxException e ) {
            String msg = "Bad URI syntax [" + catalogString + "]: " + e.getMessage();
            _log.error( msg + " getTDSMetadata failed: ", e );   
            return null;
        } catch ( Exception e ) {
            String msg = e.getMessage();
            _log.error( msg + " getTDSMetadata failed: ", e );
            return null;
        } 
        
    }   
    
    protected abstract String getPath();

    protected String getInfoPath( HttpServletRequest req ){
	    String servletPath = req.getServletPath();	  
	    String pathInfo = servletPath.substring(   getPath().length(), servletPath.length() );
	    return pathInfo;
    }
    

}
