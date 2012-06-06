/*
* Access and use of this software shall impose the following
* obligations and understandings on the user. The user is granted the
* right, without any fee or cost, to use, copy, modify, alter, enhance
* and distribute this software, and any derivative works thereof, and
* its supporting documentation for any purpose whatsoever, provided
* that this entire notice appears in all copies of the software,
* derivative works and supporting documentation. Further, the user
* agrees to credit NOAA/NGDC in any publications that result from
* the use of this software or in any product that includes this
* software. The names NOAA/NGDC, however, may not be used
* in any advertising or publicity to endorse or promote any products
* or commercial entity unless specific written permission is obtained
* from NOAA/NGDC. The user also understands that NOAA/NGDC
* is not obligated to provide the user with any support, consulting,
* training or assistance of any kind with regard to the use, operation
* and performance of this software nor to provide the user with any
* updates, revisions, new versions or "bug fixes".
*
* THIS SOFTWARE IS PROVIDED BY NOAA/NGDC "AS IS" AND ANY EXPRESS
* OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
* ARE DISCLAIMED. IN NO EVENT SHALL NOAA/NGDC BE LIABLE FOR ANY SPECIAL,
* INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER
* RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF
* CONTRACT, NEGLIGENCE OR OTHER TORTUOUS ACTION, ARISING OUT OF OR IN
* CONNECTION WITH THE ACCESS, USE OR PERFORMANCE OF THIS SOFTWARE. 
 */
package thredds.server.metadata.util;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import thredds.catalog.CollectionType;
import thredds.catalog.DataFormatType;
import thredds.catalog.InvAccess;
import thredds.catalog.InvDataset;
import thredds.catalog.InvDocumentation;
import thredds.catalog.InvMetadata;
import thredds.catalog.InvProperty;
import thredds.catalog.InvService;
import thredds.catalog.ServiceType;
import thredds.catalog.ThreddsMetadata;
import thredds.server.metadata.bean.Extent;
import ucar.nc2.constants.FeatureType;
import ucar.nc2.units.DateRange;
import ucar.nc2.units.DateType;
import ucar.nc2.units.TimeDuration;
import ucar.unidata.util.StringUtil;

import org.apache.log4j.Logger;
import org.jdom.Element;
import org.jdom.Namespace;

/**
* NCMLModifier
* @author: dneufeld
* Date: Jun 6, 2010
*/
public class NCMLModifier {
	private static Logger logger = Logger.getLogger(NCMLModifier.class);	
    private String _openDapService = null;
    private String _version = "2.0.2";
    
   /** 
	* Class constructor.
	*/ 	
	public NCMLModifier() {

	}	
	
	/** 
	* Update the NCML document by calculating Data Discovery elements using CF conventions
	* wherever possible.
	* 
	* @param extent the geospatial extent of the NetCDF file
	* @param element the root XML element of the NCML document
	*/			
	public void addCFMetadata(final Extent ext, final Element groupElem) {
		//Geospatial        	 		

        if (ext._minLon!=null) addElem(groupElem, "geospatial_lon_min", ext._minLon.toString(), "float");
        if (ext._minLat!=null) addElem(groupElem, "geospatial_lat_min", ext._minLat.toString(), "float");
        if (ext._maxLon!=null) addElem(groupElem, "geospatial_lon_max", ext._maxLon.toString(), "float");
        if (ext._maxLat!=null) addElem(groupElem, "geospatial_lat_max", ext._maxLat.toString(), "float");
        if (ext._lonUnits!=null) addElem(groupElem, "geospatial_lon_units", ext._lonUnits);
        if (ext._latUnits!=null) addElem(groupElem, "geospatial_lat_units", ext._latUnits);
        if (ext._lonRes!=null) addElem(groupElem, "geospatial_lon_resolution", ext._lonRes.toString());
        if (ext._latRes!=null) addElem(groupElem, "geospatial_lat_resolution", ext._latRes.toString());
        	    	 
        //VERTICAL        	 		
        if (ext._minHeight!=null) addElem(groupElem, "geospatial_vertical_min", ext._minHeight.toString());
        if (ext._maxHeight!=null) addElem(groupElem, "geospatial_vertical_max", ext._maxHeight.toString());
        if (ext._heightUnits!=null) addElem(groupElem, "geospatial_vertical_units", ext._heightUnits);
        if (ext._heightRes!=null) addElem(groupElem, "geospatial_vertical_resolution", ext._heightRes.toString());
        if (ext._vOrientation!=null) addElem(groupElem, "geospatial_vertical_positive", ext._vOrientation);
        
        //TIME
        if (ext._minTime!=null) addElem(groupElem, "time_coverage_start", ext._minTime.toString());
        if (ext._maxTime!=null) addElem(groupElem, "time_coverage_end", ext._maxTime.toString());
        if (ext._timeUnits!=null) addElem(groupElem, "time_coverage_units", ext._timeUnits.toString());
        if (ext._timeRes!=null) addElem(groupElem, "time_coverage_resolution", ext._timeRes.toString());
        if (ext._timeRes!=null) addElem(groupElem, "time_coverage_duration", ext._timeDuration.toString());
	}
	
	/** 
	* Update the NCML document by calculating Data Discovery elements using THREDDS metadata.
	* 
	* @param ids the THREDDS dataset object retrieved from the catalog
	* @param element the root XML element of the NCML document
	*/			
	public void addThreddsMetadata(final InvDataset ids, final Element groupElem) throws Exception {
	    if (ids==null) return;
		if (ids.getID()!= null) addElem(groupElem, "id", ids.getID());		
		if (ids.getFullName()!=null) addElem(groupElem, "full_name", ids.getFullName());
	    if ((ids.getDataFormatType()!=null) && (ids.getDataFormatType() != DataFormatType.NONE)) 
	    	addElem(groupElem, "data_format_type", StringUtil.quoteHtmlContent(ids.getDataFormatType().toString()));
	    if ((ids.getDataType() != null) && (ids.getDataType() != FeatureType.ANY) && (ids.getDataType() != FeatureType.NONE)) 
	    	addElem(groupElem, "data_type", StringUtil.quoteHtmlContent(ids.getDataType().toString()));
	    if ((ids.getCollectionType() != null) && (ids.getCollectionType() != CollectionType.NONE))
	    	addElem(groupElem, "collection_type", StringUtil.quoteXmlContent(ids.getCollectionType().toString()));
	    if (ids.getAuthority() != null)
	    	addElem(groupElem, "authority", StringUtil.quoteXmlContent(ids.getAuthority()));
	    
	    java.util.List<InvDocumentation> docs = ids.getDocumentation();
	    if (docs.size() > 0) {
	      Element docsGrp = doAddGroupElem(groupElem, "documentation");
	      for (InvDocumentation doc : docs) {
	    	Element docGrp = doAddGroupElem(docsGrp, "document");
	        String type = (doc.getType() == null) ? "" : StringUtil.quoteXmlContent(doc.getType());
	        String inline = doc.getInlineContent();
	        String xlink = null;
	        String xlinkTitle = null;
	        if ((inline != null) && (inline.length() > 0))
	          inline = StringUtil.quoteXmlContent(inline);
	          addElem(docGrp, "inline", inline, type);	
	        if (doc.hasXlink()) {
	          xlink = doc.getXlinkHref();
	          xlinkTitle = doc.getXlinkTitle();
	          addElem(docGrp, "xlink", xlink, type);
	        }
	      }
	    }

	    java.util.List<InvAccess> access = ids.getAccess();
	    if (access.size() > 0) {
	    	Element servicesGrp = doAddGroupElem(groupElem, "services");
	      for (InvAccess a : access) {
	        InvService s = a.getService();
	        String urlString = a.getStandardUrlName();

	        String fullUrlString = urlString;
	        ServiceType stype = s.getServiceType();
	        logger.debug("THREDDS service type=" + stype);
	        if ((stype == ServiceType.OPENDAP) || (stype == ServiceType.DODS)) {
	            addElem(servicesGrp, "opendap_service", fullUrlString);	             
	       	    _openDapService = fullUrlString;
	        } else if (stype == ServiceType.WCS) {
	            fullUrlString = fullUrlString + "?service=WCS&version=1.0.0&request=GetCapabilities";
	            addElem(servicesGrp, "wcs_service", fullUrlString);
	        } else if (stype == ServiceType.WMS) {
	            fullUrlString = fullUrlString + "?service=WMS&version=1.3.0&request=GetCapabilities";
	            addElem(servicesGrp, "wms_service", fullUrlString);
	        } else if (stype == ServiceType.NetcdfSubset) {
	            fullUrlString = fullUrlString + "/dataset.html";
	            addElem(servicesGrp, "nccs_service", fullUrlString);	          
	        } else if ((stype == ServiceType.CdmRemote) || (stype == ServiceType.CdmrFeature)) {
	            fullUrlString = fullUrlString + "?req=form";
	            addElem(servicesGrp, "cdmremote_service", fullUrlString);
	        } else if (stype.toString().equals("SOS")) {
	            fullUrlString = fullUrlString + "?service=SOS&version=1.0.0&request=GetCapabilities";
	            addElem(servicesGrp, "sos_service", fullUrlString);
	        }
	      }	      	    
	    }
	        
	    java.util.List<ThreddsMetadata.Contributor> contributors = ids.getContributors();
	    if (contributors.size() > 0) {
	      Element contributorsGrp = doAddGroupElem(groupElem, "contributors");
	      for (ThreddsMetadata.Contributor t : contributors) {
	    	Element contributorGrp = doAddGroupElem(contributorsGrp, "contributor");
	        String role = (t.getRole() == null) ? "" : StringUtil.quoteXmlContent(t.getRole());
	        addElem(contributorGrp, "role", role);
	        String name = (t.getName() == null) ? "" : StringUtil.quoteXmlContent(t.getName());
	        addElem(contributorGrp, "name", name);
	      }
	    }	    
	    
	    java.util.List<ThreddsMetadata.Vocab> keywords = ids.getKeywords();
	    if (keywords.size() > 0) {
	      Element keywordsGrp = doAddGroupElem(groupElem, "keywords");	     
	      for (ThreddsMetadata.Vocab t : keywords) {
	    	String vocab = (t.getVocabulary() == null) ? "" : StringUtil.quoteXmlContent(t.getVocabulary());
	    	String text = StringUtil.quoteXmlContent(t.getText());
	        addElem(keywordsGrp, "keyword", text);    
	        if (!vocab.equals("")) addElem(keywordsGrp, "vocab", vocab);  
	      }
	    }	    
	    	
	    java.util.List<DateType> dates = ids.getDates();
	    if (dates.size() > 0) {
	      Element datesGrp = doAddGroupElem(groupElem, "dates");
	      for (DateType d : dates) {
	        String type = (d.getType() == null) ? "" : StringUtil.quoteXmlContent(d.getType());
	        String text = StringUtil.quoteXmlContent(d.getText());
	        addElem(datesGrp, "date", text, type);  
	      }
	    }
	    
	    java.util.List<ThreddsMetadata.Vocab> projects = ids.getProjects();
	    if (projects.size() > 0) {
	      Element projectsGrp = doAddGroupElem(groupElem, "projects");
	      for (ThreddsMetadata.Vocab t : projects) {
	    	String vocab = (t.getVocabulary() == null) ? "" : StringUtil.quoteXmlContent(t.getVocabulary());
	    	String text = StringUtil.quoteXmlContent(t.getText());
	    	addElem(projectsGrp, "project", text); 
	    	if (!vocab.equals("")) addElem(projectsGrp, "vocab", vocab); 
	      }
	    }

	    java.util.List<ThreddsMetadata.Source> creators = ids.getCreators();
	    if (creators.size() > 0) {
	      Element creatorsGrp = doAddGroupElem(groupElem, "creators");
	      for (ThreddsMetadata.Source t : creators) {
	    	Element creatorGrp = doAddGroupElem(creatorsGrp, "creator");
	    	String name = StringUtil.quoteXmlContent(t.getName());
	    	String email = StringUtil.quoteXmlContent(t.getEmail());	    	
            String url = (t.getUrl() != null) ? "" : t.getUrl();	         	        
	        addElem(creatorGrp, "name", name); 
	        addElem(creatorGrp, "email", email);
	        addElem(creatorGrp, "url", url);	        
	      }
	    }
	    
	    java.util.List<ThreddsMetadata.Source> publishers = ids.getPublishers();
	    if (publishers.size() > 0) {
	      Element publishersGrp = doAddGroupElem(groupElem, "publishers");
	      for (ThreddsMetadata.Source t : publishers) {
	    	  Element publisherGrp = doAddGroupElem(publishersGrp, "publisher");  
		      String name = StringUtil.quoteXmlContent(t.getName());
		      String email = StringUtil.quoteXmlContent(t.getEmail());		        
		      String url = (t.getUrl() != null) ? "" : t.getUrl();
		      addElem(publisherGrp, "name", name); 
		      addElem(publisherGrp, "email", email);
		      addElem(publisherGrp, "url", url);
	        }
	    }

	    java.util.List<ThreddsMetadata.Variables> vars = ids.getVariables();
	    if (vars.size() > 0) {
	      for (ThreddsMetadata.Variables t : vars) {
	    	String uri = (t.getVocabUri() == null) ? "" : t.getVocabUri().toString();
	    	addElem(groupElem, "standard_name_vocabulary", t.getVocabulary(), uri);
	      }
	    }	    

	    ThreddsMetadata.GeospatialCoverage gc = ids.getGeospatialCoverage();
	    if ((gc != null) && !gc.isEmpty()) {
	        addElem(groupElem, "geospatial_lon_min", Double.toString(gc.getBoundingBox().getLonMin()));
	        addElem(groupElem, "geospatial_lat_min", Double.toString(gc.getBoundingBox().getLatMin()));
	        addElem(groupElem, "geospatial_lon_max", Double.toString(gc.getBoundingBox().getLonMax()));
	        addElem(groupElem, "geospatial_lat_max", Double.toString(gc.getBoundingBox().getLatMax()));

	        if (gc.getUpDownRange() != null) {

	          double minHeight = 0.0;
	          double maxHeight = 0.0;
	          if (gc.getZPositiveUp()) {
	              minHeight = gc.getHeightStart();
	              maxHeight = minHeight + gc.getHeightExtent();
	          } else {
		          minHeight = gc.getHeightStart() * -1;
		          maxHeight = minHeight - gc.getHeightExtent();
	          }
	          double heightRes = gc.getHeightResolution();
	          String heightUnits = gc.getUpDownRange().getUnits();
	          addElem(groupElem, "geospatial_vertical_min", Double.toString(minHeight));
	          addElem(groupElem, "geospatial_vertical_max", Double.toString(maxHeight));
              if (heightUnits!=null) addElem(groupElem, "geospatial_vertical_units", heightUnits);
	          addElem(groupElem, "geospatial_vertical_resolution", Double.toString(heightRes));
	          addElem(groupElem, "geospatial_vertical_positive", gc.getZPositive());
	          
	        }

	        java.util.List<ThreddsMetadata.Vocab> nlist = gc.getNames();
	        if ((nlist != null) && (nlist.size() > 0)) {
	          Element vocabGrp = doAddGroupElem(groupElem, "vocab");
	          for (ThreddsMetadata.Vocab elem : nlist) {
	        	  addElem(vocabGrp, "name", StringUtil.quoteXmlContent(elem.getText()));
	          }
	        }
	    }
	
	    DateRange tc = ids.getTimeCoverage();
	    if (tc != null) {

	      DateType start = tc.getStart();
	      if ((start != null) && !start.isBlank())
	    	  addElem(groupElem, "time_coverage_start", start.toDateTimeString());
	      DateType end = tc.getEnd();
	      if ((end != null) && !end.isBlank()) 
	    	  addElem(groupElem, "time_coverage_end", end.toDateTimeString());

	      TimeDuration resolution = tc.getResolution();
	      if (tc.useResolution() && (resolution != null) && !resolution.isBlank()) {
	    	  addElem(groupElem, "time_coverage_resolution", StringUtil.quoteXmlContent(resolution.toString()));
	      }
	      TimeDuration duration = tc.getDuration();
	      if (tc.useDuration() && (duration != null) && !duration.isBlank()) {
	    	  addElem(groupElem, "time_coverage_duration", StringUtil.quoteXmlContent(duration.toString()));
	      }

	    }

	    
	    java.util.List<InvMetadata> metadata = ids.getMetadata();
	    boolean gotSomeMetadata = false;
	    for (InvMetadata m : metadata) {
	      if (m.hasXlink()) gotSomeMetadata = true;
	    }

	    if (gotSomeMetadata) {
	      Element metaGrp = doAddGroupElem(groupElem, "metadata");
	      for (InvMetadata m : metadata) {
	    	
	        String type = (m.getMetadataType() == null) ? "" : m.getMetadataType();
	        if (m.hasXlink()) {
	          String title = (m.getXlinkTitle() == null) ? "Type " + type : m.getXlinkTitle();
	          addElem(metaGrp, title, m.getXlinkHref());
	        } 
	      }
	    }

	    java.util.List<InvProperty> props = ids.getProperties();
	    if (props.size() > 0) {
	      Element propsGrp = doAddGroupElem(groupElem, "properties");
	      for (InvProperty p : props) {
	    	
	        addElem(propsGrp, p.getName(), p.getValue());
	      }
	    } 
	}
	
	/** 
	* Update the NCML document by adding ncISO specific metadata
	* 
	* @param element the group XML element of the NCML document
	*/			
	public void addNcIsoMetadata(final Element groupElem) {
        // Add date stamp for metadata creation
		Date dateStamp = Calendar.getInstance().getTime();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String metadata_creation_date = sdf.format(dateStamp);
        addElem(groupElem,"metadata_creation", metadata_creation_date);
        addElem(groupElem,"nciso_version", _version); 
	}
	
	private Element newGroupElement() {
		return new Element("group");
	}
	
	private Element newAttributeElement() {
		return new Element("attribute");
	}
	
	public Element doAddGroupElem(Element rootElem, final String name) {
		Namespace ns = Namespace.getNamespace("http://www.unidata.ucar.edu/namespaces/netcdf/ncml-2.2");

		Element groupElem = newGroupElement();
		groupElem.setAttribute("name", name);
		groupElem.setNamespace(ns);
		rootElem.addContent(groupElem);
		return groupElem;
	}
	
	private void doAddElem(Element groupElem, final String name, final String value, final String type) {
		Namespace ns = Namespace.getNamespace("http://www.unidata.ucar.edu/namespaces/netcdf/ncml-2.2");

		Element elem = newAttributeElement();
		elem.setAttribute("name", name);

		elem.setAttribute("value", value);
		if (type!=null) {
			elem.setAttribute("type", type);
		}
		elem.setNamespace(ns);
		groupElem.addContent(elem);
	}
	
	private void addElem(final Element rootElem, final String name, final String value) {
		doAddElem(rootElem, name, value, null);
	}
	
	private void addElem(final Element rootElem, final String name, final String value, final String type) {
		doAddElem(rootElem, name, value, type);
	}
	

	
	public String getOpenDapService() {
		return this._openDapService;
	}
}
