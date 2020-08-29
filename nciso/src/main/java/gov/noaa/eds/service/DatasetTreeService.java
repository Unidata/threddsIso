package gov.noaa.eds.service;


import gov.noaa.eds.threddsutilities.service.iface.ICatalogCrawler;
import gov.noaa.eds.threddsutilities.service.impl.CatalogCrawlerImpl;
import gov.noaa.eds.util.FileUtility;
import thredds.server.metadata.nciso.bean.Extent;
import gov.noaa.eds.threddsutilities.bean.MetadataContainer;
import gov.noaa.eds.threddsutilities.bean.ThreddsDatasetTree;
import thredds.server.metadata.nciso.util.ElementNameComparator;
import thredds.server.metadata.nciso.util.NCMLModifier;
import thredds.server.metadata.nciso.util.ThreddsExtentUtil;
import thredds.server.metadata.nciso.util.ThreddsTranslatorUtil;
import thredds.server.metadata.nciso.util.XMLUtil;
import org.jdom2.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.Vector;

/**
 * DatasetTreeTest
 * Date: Mar 2, 2010
 * Time: 12:27:53 PM
 *
 * @author dneufeld
 */

	
public class DatasetTreeService {
	private static Logger logger = LoggerFactory.getLogger(DatasetTreeService.class);
	// See WafService
    private static final String _xsltMetadataAssessmentUrl = "https://cdn.rawgit.com/NOAA-PMEL/uafnciso/fdb7f86515c21a8b5c087978975addf9ad5d0027/transforms/UnidataDDCount-HTML.xsl";
    private static final String _xsltIsoUrl = "https://cdn.rawgit.com/noaaroland/uafnciso/e84d6e26b87a799eb996173358c72ec7a4ed4912/transforms/UnidataDD2MI.xsl";

	private String _xsltFilePath = null;
    private String _threddsServer = null;  
    ThreddsDatasetTree root;
    ArrayList<String> threddsAl = new ArrayList<String>();

    private FileUtility fu;
    String rootStr = "";
    private String nodeIndent = "";
    private String pad = "	      ";
    private static String childrenIndent = "       ";
    private boolean _iso = true;
    private boolean _custom = false;
    private int _numSample = 1;
    private int _depth = -1;
        
    // Thredds
    public void setServer(String tdsServer, int depth, int numSample, boolean isoExtract, boolean customExtract, String customXsltFile) {
    	_depth = depth;
    	_threddsServer = tdsServer;
    	_numSample = numSample;
    	_iso = isoExtract;    
    	_xsltFilePath = "xsl/" + customXsltFile;
    	_custom = customExtract;  
    }
    
    private void evaluateTopDown(String evalStr) {
    	logger.debug("evalStr=" + evalStr);
    	if (evalStr.indexOf("/")<0) {
    		//Add the leaf
    		threddsAl.add(evalStr);
    		return;
    	}
    	String parsedStr = evalStr.substring(0,(evalStr.indexOf("/")));
        evalStr = evalStr.substring(parsedStr.length()+1,evalStr.length());
        threddsAl.add(parsedStr);
        evaluateTopDown(evalStr);    	
    }
    
    private String writeChildrenFromNode(Enumeration<ThreddsDatasetTree> e) {
        String children = pad + nodeIndent + childrenIndent + "children:[";
        while (e.hasMoreElements()) {
        	ThreddsDatasetTree newTree = e.nextElement();
        	if (newTree._isLeaf) {
        		logger.debug(newTree._displayName + " is leaf");
        		
        		int pos = -1;
        		if ((newTree._displayName.lastIndexOf(".nc")>0)||(newTree._displayName.lastIndexOf(".cdf")>0)) {
        			pos = newTree._displayName.lastIndexOf(".");        			
        		} else {
        			pos = newTree._displayName.length();
        		}

				String ncmlFile = newTree._displayName.substring(0, pos) + "_NCML.xml";
				String reportFile = newTree._displayName.substring(0, pos) + "_REPORT.html";			  
				String isoFile = newTree._displayName.substring(0, pos) + "_ISO.xml";

				children += "{_reference:'" + newTree._id.toString() + "." + ncmlFile + "'},";
				if (_iso) {
					children += "{_reference:'" + newTree._id.toString() + "." + reportFile + "'},";
					children += "{_reference:'" + newTree._id.toString() + "." + isoFile + "'}";
				} else {
					children += "{_reference:'" + newTree._id.toString() + "." + reportFile + "'}";
				}
				 				
        	} else {
        		children += "{_reference:'"  + newTree._id.toString() + "." + newTree.getName() + "'}";	
        	}
            if (e.hasMoreElements()) children += ",";
        }        
        children += "] },";
        return children;
    }
    

			
    private void getNodes(ThreddsDatasetTree tree) {
    	logger.debug("getNodes()=" + tree._displayName);
    	Enumeration<ThreddsDatasetTree> e = tree.elements();
    	if (!tree._isLeaf) {    		
            String children = writeChildrenFromNode(e);
            fu.writeln(children);
            e = tree.elements();
    	}

        
        while (e.hasMoreElements()) {
        	
        	ThreddsDatasetTree newTree = e.nextElement();
            nodeIndent = "";
            int level = Integer.valueOf(newTree._level).intValue();
            for (int i=0; i<level; i++) {
                nodeIndent += "    ";
            }        	              
            if (!newTree._isLeaf) {
                fu.writeln(pad + nodeIndent + "{ id: '" + newTree._id.toString() + "." + newTree._displayName + "', name:'" + newTree._displayName + "', type:'level" + newTree._level + "',");
            } else {
            	String ncmlFullFilePath = "";
            	int startPos = newTree._url.indexOf("/", 7);
            	String urlSrcRoot = newTree._url.substring(startPos+1,newTree._url.lastIndexOf("/")+1);
        		int pos = -1;
        		if ((newTree._displayName.lastIndexOf(".nc")>0)||(newTree._displayName.lastIndexOf(".cdf")>0)) {
        			pos = newTree._displayName.lastIndexOf(".");        			
        		} else {
        			pos = newTree._displayName.length();
        		}
        		        		
				String ncmlFileStr = newTree._displayName.substring(0, pos) + "_NCML.xml";
				String reportFile = newTree._displayName.substring(0, pos) + "_REPORT.html";			  
				String isoFile = newTree._displayName.substring(0, pos) + "_ISO.xml";
				String customMetaFile = newTree._displayName.substring(0, pos) + "_META.xml";
				
			    ncmlFullFilePath  = urlSrcRoot + ncmlFileStr;
				FileUtility mdu = new FileUtility(urlSrcRoot);
				mdu.mkdirs();
				

				//Generate NCML file content
				try {
					
					File ncmlFile = ThreddsTranslatorUtil.getNcml(newTree._url, ncmlFullFilePath);
					if (ncmlFile!=null) {
					    Extent ext = ThreddsExtentUtil.getExtent(newTree._url);
			    	    XMLUtil xmlUtil = new XMLUtil(ncmlFullFilePath);

			    	    NCMLModifier ncmlMod = new NCMLModifier();
			    	
			    	    List<Element> list = xmlUtil.elemFinder("//ncml:netcdf", "ncml", "http://www.unidata.ucar.edu/namespaces/netcdf/ncml-2.2");
			    	    Element rootElem = list.get(0);
			    	    
			    	    Element cfGroupElem = ncmlMod.doAddGroupElem(rootElem, "CFMetadata");
			    	    ncmlMod.addCFMetadata(ext, cfGroupElem);

			    	    Element threddsGroupElem = ncmlMod.doAddGroupElem(rootElem, "THREDDSMetadata");
			    	    ncmlMod.addThreddsMetadata(tree._mdc.getDataset(), threddsGroupElem);
			    	    
			    	    Element ncisoGroupElem = ncmlMod.doAddGroupElem(rootElem, "NCISOMetadata");
			    	    ncmlMod.addNcIsoMetadata(ncisoGroupElem);
			    	    
			    	    xmlUtil.sortElements(rootElem, new ElementNameComparator());

			    	    xmlUtil.write(ncmlFullFilePath);
					
			    	    // Generate report file content
			    	    String scoreReportLoc = null;
			    	    scoreReportLoc = urlSrcRoot + reportFile; 
		
			    	    ThreddsTranslatorUtil.transform(_xsltMetadataAssessmentUrl, ncmlFullFilePath, scoreReportLoc);
			    	    fu.writeln(pad + nodeIndent + "{ id: '" + newTree._id.toString() + "." + ncmlFileStr + "', name:'" + ncmlFileStr + "', urlSrc: '" + ncmlFullFilePath + "', type:'level" + newTree._level + "' },");
					
			    	    if (!_iso) {
			    	        if (!newTree._isLastElement) {
			    	            logger.info("LAST ELEMENT: " + newTree._id.toString() + "." + reportFile);
			    	            fu.writeln(pad + nodeIndent + "{ id: '" + newTree._id.toString() + "." + reportFile + "', name:'" + reportFile + "', urlSrc: '" + urlSrcRoot + reportFile + "', type:'level" + newTree._level + "' },");
			    	        } else { //last element no comma
			    	            fu.writeln(pad + nodeIndent + "{ id: '" + newTree._id.toString() + "." + reportFile + "', name:'" + reportFile + "', urlSrc: '" + urlSrcRoot + reportFile + "', type:'level" + newTree._level + "' }");
			    	        }            	
			    	    } else {
			    	        fu.writeln(pad + nodeIndent + "{ id: '" + newTree._id.toString() + "." + reportFile + "', name:'" + reportFile + "', urlSrc: '" + urlSrcRoot + reportFile + "', type:'level" + newTree._level + "' },");
			    	    }
				        // Generate iso file content	
					    if (_iso) {
					        ThreddsTranslatorUtil.transform(_xsltIsoUrl, ncmlFullFilePath, urlSrcRoot + isoFile);
					        if (!newTree._isLastElement) {
					            fu.writeln(pad + nodeIndent + "{ id: '" + newTree._id.toString() + "." + isoFile + "', name:'" + isoFile + "', urlSrc: '" + urlSrcRoot + isoFile + "', type:'level" + newTree._level + "' },");
	            	        } else { //last element no comma
	            	            fu.writeln(pad + nodeIndent + "{ id: '" + newTree._id.toString() + "." + isoFile + "', name:'" + isoFile + "', urlSrc: '" + urlSrcRoot + isoFile + "', type:'level" + newTree._level + "' }");
	            	        }
					    }		
				        // Generate custom file content	
					    if (_custom) {
					   	    //logger.info("_xsltFilePath: " + _xsltFilePath);
					        ThreddsTranslatorUtil.transform(_xsltFilePath, ncmlFullFilePath, urlSrcRoot + customMetaFile);
					        if (!newTree._isLastElement) {
					            fu.writeln(pad + nodeIndent + "{ id: '" + newTree._id.toString() + "." + customMetaFile + "', name:'" + isoFile + "', urlSrc: '" + urlSrcRoot + customMetaFile + "', type:'level" + newTree._level + "' },");
	            	        } else { //last element no comma
	            		        fu.writeln(pad + nodeIndent + "{ id: '" + newTree._id.toString() + "." + customMetaFile + "', name:'" + isoFile + "', urlSrc: '" + urlSrcRoot + customMetaFile + "', type:'level" + newTree._level + "' }");
	            	        }
					    }						    
				    } else {
				        fu.writeln(pad + nodeIndent + "{ id: '" + newTree._id.toString() + "." + ncmlFileStr + "', name:'" + ncmlFileStr + "', urlSrc: 'NOTAVAILABLE', type:'level" + newTree._level + "' },");
				        fu.writeln(pad + nodeIndent + "{ id: '" + newTree._id.toString() + "." + reportFile + "', name:'" + reportFile + "', urlSrc: 'NOTAVAILABLE', type:'level" + newTree._level + "' },");
				        if (_iso) {
				       	    fu.writeln(pad + nodeIndent + "{ id: '" + newTree._id.toString() + "." + isoFile + "', name:'" + isoFile + "', urlSrc: 'NOTAVAILABLE', type:'level" + newTree._level + "' },");
				        }
				    }
				
				} catch (Exception exc) {
					logger.error("_id=" + newTree._id, exc);
				} finally {
					mdu.close();
				}
            

            }
            getNodes(newTree);

        }        
       
    }    
   
    public void generateTree(){
        ICatalogCrawler crawler = new CatalogCrawlerImpl();

        rootStr = _threddsServer.substring(0, _threddsServer.lastIndexOf("/"));
        int rootNodeStart =rootStr.lastIndexOf("/")+1;
        String rootNode = rootStr.substring(rootNodeStart, rootStr.length());

        int i = 0;
        int cnt = 0;

        ThreddsDatasetTree tree = new ThreddsDatasetTree(new Integer(cnt), null, "ROOT", "/ROOT" , null, new Integer(i));

        cnt++;
        logger.debug("root=" + rootStr);
        logger.info("rootNode=" + rootNode);

        fu = new FileUtility(rootNode +".json");
        fu.openFileWriter();
        try {

            Vector<MetadataContainer> mdcs = new Vector<MetadataContainer>();
            crawler.crawlThredds(_threddsServer, _depth, _numSample, mdcs);

            ThreddsDatasetTree lastNode = tree;
            logger.info("mdcs.size()=" + mdcs.size());
            
            for(MetadataContainer mdc:mdcs) {
            	String urlStr = mdc.getOpenDapUrl();
            	logger.info("cnt=" + cnt + " ------------------ Processing: " + urlStr);
            	int startPos = urlStr.indexOf("/", 7);
            	//String evalStr = urlStr.substring(rootStr.length() + 1,urlStr.length());
            	String evalStr = urlStr.substring(startPos + 1,urlStr.length());
            	evaluateTopDown(evalStr);
            	i = 1;
            	String nodePath = "/";
            	lastNode = tree.getChild("/ROOT");
            	for (String element:threddsAl) {
                    ThreddsDatasetTree node = null;
                    
                    logger.debug(i + ":" + element + ":theddsAl.size()=" + threddsAl.size());
                    if (i==threddsAl.size()) { //leaf
                    	logger.debug("Adding new leaf:" + cnt + ";" + lastNode._displayName + ";" + element + ";" + nodePath + ";" + i);
                    	node = new ThreddsDatasetTree(new Integer(cnt),lastNode, element.replace(":","_"), urlStr, mdc, new Integer(i));
                    	node.setLeaf(true);
                    	if (cnt==mdcs.size()) node.setLastElement(true);
                    	lastNode.add(node);
                    } else {
                    	nodePath += element + "/";
                    	logger.debug("nodePath=" + nodePath);
                    	node = tree.getChild(nodePath);
                    	if (node==null) {
                    	    logger.debug("Adding new node:" + cnt + ";" + lastNode._displayName + ";" + element + ";" + nodePath + ";" + i);
                    	    node = new ThreddsDatasetTree(new Integer(cnt), lastNode, element.replace(":","_"), nodePath, mdc, new Integer(i));
                    	    lastNode.add(node);                   	  
                    	} else {
                    		logger.debug("found a an existing node:" + node._displayName);
                    	}
                    }
                    lastNode = node;
                    i++;
            		
            	}
            	threddsAl.clear();            
            	//if (cnt>=urlsToProcess) break;
            	cnt++;
            	
            }
            // write json header
            fu.writeln("{");
            fu.writeln("	identifier: 'id',");
            fu.writeln("	label: 'name',");
            fu.writeln("	items: [");

            fu.write(pad + "{ id: '" + tree._id.toString() + "." + tree._displayName + "', name:'" + tree._displayName + "', type:'level" + tree._level + "'");
            
            if (tree.elements().hasMoreElements()) {
                fu.writeln(",");
                try {
                  getNodes(tree);
                } catch (Exception e) {
                	logger.error("Exception encountered.", e);
                }
            } 
            fu.writeln("");

            // write json footer
            fu.writeln("]}");
        } catch (Exception e) {
        	logger.error("Exception encountered.", e);

        } finally {
            fu.close();
        }    	
    	

    }
    
    	
    
}
