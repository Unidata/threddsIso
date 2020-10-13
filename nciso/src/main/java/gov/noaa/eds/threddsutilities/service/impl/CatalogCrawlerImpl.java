package gov.noaa.eds.threddsutilities.service.impl;

import gov.noaa.eds.threddsutilities.bean.MetadataContainer;
import thredds.client.catalog.Access;
import thredds.client.catalog.Catalog;
import thredds.client.catalog.Dataset;
import thredds.client.catalog.ServiceType;
import thredds.client.catalog.builder.CatalogBuilder;
import thredds.server.metadata.nciso.exception.ThreddsUtilitiesException;
import gov.noaa.eds.threddsutilities.service.iface.ICatalogCrawler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;
import java.util.Vector;

/**
 * CatalogCrawlerImpl
 * Date: Feb 22, 2010
 * Time: 12:24:40 PM
 *
 * @author rbaker
 * @author dneufeld
 */
public class CatalogCrawlerImpl implements ICatalogCrawler {
	private static Logger logger = LoggerFactory.getLogger(CatalogCrawlerImpl.class);
    private static  Vector<ServiceType> allowableTypes = new Vector<ServiceType>(0);
    private Dataset lastParent = null;
    
    private int _actualDepthCount;
    private int _actualLeafCount;
       

    static{
        allowableTypes.add(ServiceType.DODS);
        allowableTypes.add(ServiceType.OPENDAP);
    }

    
    
    @Override
    public synchronized void crawlThredds(String url, int maxDepth, int maxLeaves, Vector<MetadataContainer> mdcs) throws ThreddsUtilitiesException {

        CatalogBuilder factory = new CatalogBuilder();
        Catalog catalog = factory.buildFromLocation(url, null);
        StringBuilder sb = new StringBuilder();
        
        // get all datasets from catalog
        List<Dataset> threddsDatasets = catalog.getDatasets();
        for(Dataset ds:threddsDatasets){
            if(ds.hasNestedDatasets()){
                for(Dataset ds2:ds.getDatasets()){
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
    private void getDataset(Dataset dataset, Vector<MetadataContainer> mdcs, int maxDepth, int maxLeaves)  {
    
        Dataset parent = null;
       	logger.info("maxDepth: " + maxDepth + " depth: " + _actualDepthCount + " dataset.getFullName():" + dataset.getName() + "; dataset.hasAccess(): " + dataset.hasAccess() + " maxLeaves: " + maxLeaves + " leafcnt: " + _actualLeafCount);
        if(dataset.hasAccess()){
            for(Access access: dataset.getAccess()){
                if(allowableTypes.contains(access.getService().getType())){
                	logger.info("allowable service");
                	parent = dataset.getParentDataset();
                    
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
                    for (Dataset ds : dataset.getDatasets()) {
                        getDataset(ds, mdcs, maxDepth, maxLeaves);
                    }
                }
            }
        }            
        
    }    
    

}

