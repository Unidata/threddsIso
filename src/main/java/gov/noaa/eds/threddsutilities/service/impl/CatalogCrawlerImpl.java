package gov.noaa.eds.threddsutilities.service.impl;

import gov.noaa.eds.threddsutilities.bean.MetadataContainer;
import thredds.server.metadata.exception.ThreddsUtilitiesException;
import gov.noaa.eds.threddsutilities.service.iface.ICatalogCrawler;
import thredds.catalog.*;

import java.util.List;
import java.util.Vector;

import org.apache.log4j.Logger;

/**
 * CatalogCrawlerImpl
 * Date: Feb 22, 2010
 * Time: 12:24:40 PM
 *
 * @author rbaker
 * @author dneufeld
 */
public class CatalogCrawlerImpl implements ICatalogCrawler {
	private static Logger logger = Logger.getLogger(CatalogCrawlerImpl.class); 
    private static  Vector<ServiceType> allowableTypes = new Vector<ServiceType>(0);
    private InvDataset lastParent = null;
    
    private int _actualDepthCount;
    private int _actualLeafCount;
       

    static{
        allowableTypes.add(ServiceType.DODS);
        allowableTypes.add(ServiceType.OPENDAP);
        allowableTypes.add(ServiceType.NETCDF);
    }

    
    
    @Override
    public synchronized void crawlThredds(String url, int maxDepth, int maxLeaves, Vector<MetadataContainer> mdcs) throws ThreddsUtilitiesException {

        InvCatalogFactory factory = new InvCatalogFactory("default",true);
        InvCatalog catalog = factory.readXML(url);
        StringBuilder sb = new StringBuilder();
        if(!catalog.check(sb)){
            throw new ThreddsUtilitiesException(sb.toString());
        }
        
        
        // get all datasets from catalog
        List<InvDataset> threddsDatasets = catalog.getDatasets();
        for(InvDataset ds:threddsDatasets){        	
            if(ds.hasNestedDatasets()){
                for(InvDataset ds2:ds.getDatasets()){                       	
                    getDataset(ds2,mdcs,maxDepth,maxLeaves);           
                }
            } else {            	
           	    getDataset(ds,mdcs,maxDepth,maxLeaves);
            }
        }

    }




    
    /**
     * Recursively walks through datasets add urls of the dataset's subset catalog
     * @param dataset
     * @param mdcs
     * @param maxDepth
     * @param maxLeaves
     * @throws ThreddsUtilitiesException 
     */
    private void getDataset(InvDataset dataset, Vector<MetadataContainer> mdcs, int maxDepth, int maxLeaves)  {
    
        InvDataset parent = null;
       	logger.info("maxDepth: " + maxDepth + " depth: " + _actualDepthCount + " dataset.getFullName():" + dataset.getFullName() + "; dataset.hasAccess(): " + dataset.hasAccess() + " maxLeaves: " + maxLeaves + " leafcnt: " + _actualLeafCount);
        if(dataset.hasAccess()){
            for(InvAccess access: dataset.getAccess()){
                if(allowableTypes.contains(access.getService().getServiceType())){
                	logger.info("allowable service");
                	parent = dataset.getParent(); 
                    
  					MetadataContainer mdc = new MetadataContainer(dataset);

  					String lastParentName = "NULL";
  					String parentName = "NULL";
  					
  					if (lastParent!=null) lastParentName = lastParent.getName();
  					if (parent!=null) parentName = parent.getName();
   					//logger.info("URL: " + mdc.getOpenDapUrl() + "; Last Parent:" + lastParentName + "; Parent: " + parentName);
	                if ((lastParent!=null) && (parent!=null) && (!parent.getName().equals(lastParent.getName()))) {	
	                	logger.info("New Parent");
	                	_actualLeafCount = 0;
	                } 
   					_actualLeafCount++;
   		            if((_actualLeafCount <= maxLeaves )){  
   		            	logger.info("adding mdc");
   					    mdcs.add(mdc);  
                        lastParent = parent;                                
   		            } 
   		            // Break because we are only evaluating the opendap service
   					break;
                }
            }
        } else {
            if((maxDepth == -1) || (maxDepth != _actualDepthCount)){
                _actualDepthCount++;
                if (dataset.hasNestedDatasets()) {
                    for (InvDataset ds : dataset.getDatasets()) {
                        getDataset(ds, mdcs, maxDepth, maxLeaves);
                    }
                }
            }
        }            
        
    }    
    

}

