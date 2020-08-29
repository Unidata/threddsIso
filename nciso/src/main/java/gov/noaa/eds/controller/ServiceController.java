package gov.noaa.eds.controller;

import gov.noaa.eds.service.DatasetTreeService;
import gov.noaa.eds.service.WafService;
import gov.noaa.eds.threddsutilities.service.iface.ICatalogCrawler;
import gov.noaa.eds.threddsutilities.service.impl.CatalogCrawlerImpl;
import gov.noaa.eds.util.StackTraceUtil;
import gov.noaa.eds.util.WafScoreCalculator;
import gov.noaa.eds.threddsutilities.bean.MetadataContainer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Vector;

//-ts http://dods.ndbc.noaa.gov/thredds/dodsC/data/oceansites/catalog.xml -num 1 -iso true
public class ServiceController {
   
	private static Logger logger = LoggerFactory.getLogger(ServiceController.class);

	/**
	 * Create Wafs
	 *  
	 */
   	public void createWaf(String tsUrl, int numSample, int depth, boolean isoExtract, boolean customExtract, String xsltFile, String wafDir) {   	
   		logger.info("Running createWaf in service controller...");   		
   		String wafIsoDir = null;
   		String wafNcmlDir = wafDir + "/ncml/";
   		String wafRubricDir = wafDir + "/score/";   		
   		if (isoExtract) wafIsoDir = wafDir + "/iso/";
        Vector<MetadataContainer> mdcs = new Vector<MetadataContainer>();
        Vector<String> ncmlFiles = new Vector<String>();
        ICatalogCrawler crawler = new CatalogCrawlerImpl();
        try {
            crawler.crawlThredds(tsUrl, depth, numSample, mdcs);
            WafService.generateNcml(mdcs, ncmlFiles, wafNcmlDir);
            WafService.generateNcmlRubric(ncmlFiles, wafRubricDir);
            
            if (wafIsoDir!=null) WafService.generateIso(ncmlFiles, wafIsoDir);
            
        } catch (Exception e) {
        	e.printStackTrace();
        }   		
    }
   	
	/**
	 * Calculate Waf Score
	 *  
	 */
   	public void calcWafScore(String wafDir) {    	
   		logger.info("Running calcWafScore in service controller...");   		
   		WafScoreCalculator.getSummary(wafDir);
    }
	
	/**
	 * Launch crawler
	 *  
	 */
   	public void launch(String tsUrl, int sampleNum, int depth, boolean isoExtract, boolean customExtract, String xsltFile) {    	
   		logger.info("Running service controller...");
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("d MMM yyyy hh:mm");
        String dateTime = sdf.format(calendar.getTime());
        logger.info("Launch start time: "+ dateTime);
        try {
            DatasetTreeService treeService = new DatasetTreeService();
            treeService.setServer(tsUrl, sampleNum, depth, isoExtract, customExtract, xsltFile);
            treeService.generateTree();
        } catch (Exception e) {
        	logger.error("Exception encountered.", e);
        }
    }
    
   	public static void main(String[] args) {
   		try {
   			//Need thredds server url
   			String flag = null;
   			String tsUrl = null;
   			boolean isoExtract = false;
   			boolean customExtract = false;
   			String xsltFile = null;
   			String wafDir = null;
   			String wafScoreDir = null;
   			
   			int sampleNum = 1; // Default sample 1 netcdf file per leaf node
   			int depth = -1;
   			if (args.length<2) {
   				System.out.println("Usage: java -Xms1024m -Xmx1024m -jar ncISO.jar -ts ThreddsServer -num 5 -depth 1000 -iso true");
   				System.out.println("Usage: java -Xms1024m -Xmx1024m -jar ncISO.jar -ts ThreddsServer -num 5 -depth 1000 -iso false -custom true -xsl myXSLT");
   				System.exit(-1);
   			}
   			
   			for (int i=0; i<args.length; i+=2) {
   				flag = args[i];
   				if (flag.equalsIgnoreCase("-ts")) {
   					tsUrl = args[i+1];
   				}				
   				if (flag.equalsIgnoreCase("-num")) {
   					sampleNum = Integer.parseInt(args[i+1]);
   				}
   				if (flag.equalsIgnoreCase("-depth")) {
   					depth = Integer.parseInt(args[i+1]);
   				}
   				if (flag.equalsIgnoreCase("-iso")) {
   					isoExtract = Boolean.valueOf(args[i+1]);
   				}
   				if (flag.equalsIgnoreCase("-custom")) {
   					customExtract = Boolean.valueOf(args[i+1]);
   				}   				
   				if (flag.equalsIgnoreCase("-xsl")) {
   					xsltFile = args[i+1];
   				}
   				if (flag.equalsIgnoreCase("-waf")) {
   					wafDir = args[i+1];
   				}			
   				if (flag.equalsIgnoreCase("-wafScore")) {
   					wafScoreDir = args[i+1];
   				}
   			}
   			
   		    ServiceController serviceController = new ServiceController();
   		    if (tsUrl!=null) {
   		    	if (wafDir==null) {
   		            serviceController.launch(tsUrl, sampleNum, depth, isoExtract, customExtract, xsltFile);
   		    	} else {
   		    		//Generate flat WAF
   		    		serviceController.createWaf(tsUrl, sampleNum, depth, isoExtract, customExtract, xsltFile, wafDir);
   		    	}
   		    } else {
   		    	//Check to see if wafScore option set
   		    	serviceController.calcWafScore(wafScoreDir);
   		    }
   		} catch(Exception e) {
   			logger.error(StackTraceUtil.getStackTrace(e));
  	   		System.out.println("Usage: java -Xms1024m -Xmx1024m -jar ncISO.jar -ts ThreddsServer -num 5 -depth 1000 -iso true");
  	   	    System.out.println("Usage: java -Xms1024m -Xmx1024m -jar ncISO.jar -ts ThreddsServer -num 5 -depth 1000 -iso true -waf /tmp/mywaf/");
  	   	    System.out.println("Usage: java -Xms1024m -Xmx1024m -jar ncISO.jar -ts ThreddsServer -num 5 -depth 1000 -iso true -custom true -xslt mycustom.xsl");
   		}
   		
   	}

   	
	
   
}
