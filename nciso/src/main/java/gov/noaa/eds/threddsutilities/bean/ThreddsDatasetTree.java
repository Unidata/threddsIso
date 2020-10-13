package gov.noaa.eds.threddsutilities.bean;

import java.util.Enumeration;
import java.util.Vector;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ThreddsDatasetTree {
	private static Logger _logger = LoggerFactory.getLogger(ThreddsDatasetTree.class);
	
	public Integer _id;
	public String _displayName;	  
	public String _url;
	public Integer _level;
	public MetadataContainer _mdc;
	public Vector<ThreddsDatasetTree> _components;
	public boolean _isLeaf;
	public boolean _isLastElement;
	public ThreddsDatasetTree _parent = null;

	//--------------------------------------
	public ThreddsDatasetTree(Integer id, ThreddsDatasetTree parent, String name, String url, MetadataContainer mdc, Integer level) {
	    _id = id;
		_displayName = name;
		_logger.info("displayName=" + _displayName);
	    _parent = parent;
	    _url = url;
	    _mdc = mdc;
	    _level = level;
	    _components = new Vector<ThreddsDatasetTree>();
	    _isLeaf = false;
	}

	//--------------------------------------
	public void setLeaf(boolean b) {
	    _isLeaf = b; //if true, do not allow children
	}

	//--------------------------------------
	public void setLastElement(boolean b) {
	    _isLastElement = b; 
	}
	  
	//--------------------------------------
	public String getName() {
	    return _displayName;
	}
	
	//--------------------------------------
	public String getUrl() {
	    return _url;
	}
	
	//--------------------------------------
	public boolean add(ThreddsDatasetTree e) {
	    if (!_isLeaf)
	      _components.addElement(e);
	    return _isLeaf; //false if unsuccessful
	}

	//--------------------------------------
	public void remove(ThreddsDatasetTree e) {
	    if (!_isLeaf)
	      _components.removeElement(e);
	}

	//--------------------------------------
	public Enumeration<ThreddsDatasetTree> elements() {
	    return _components.elements();
    }

	//--------------------------------------
	public ThreddsDatasetTree getChild(String s) {
	    ThreddsDatasetTree newDataset = null;

	    if (this.getUrl().equals(s)) {
	      _logger.info("returning: " + _displayName +"; url: " + _url);
	      return this;
	    } else {
	      boolean found = false;
	      Enumeration<ThreddsDatasetTree> e = elements();
	      while (e.hasMoreElements() && (!found)) {
	        newDataset = e.nextElement();
	        found = newDataset.getName().equals(s);
	        if (!found) {
	          newDataset = newDataset.getChild(s);
	          found = (newDataset != null);
	        }
	      }
	      if (found) {
	    	_logger.info("found: " + newDataset._url);   
	        return newDataset;
	      } else {
	        return null;
	      }
	    }
    }

	}
