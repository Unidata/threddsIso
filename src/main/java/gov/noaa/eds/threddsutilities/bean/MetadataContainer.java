package gov.noaa.eds.threddsutilities.bean;

import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import thredds.client.catalog.Access;
import thredds.client.catalog.Dataset;
import thredds.client.catalog.ServiceType;

public class MetadataContainer {

	private Map<String, String> _map = new HashMap<String, String>();

	private Dataset _dataset;
	private static  Vector<ServiceType> additionalServiceTypes = new Vector<ServiceType>(0);
	
    static{
    	additionalServiceTypes.add(ServiceType.OPENDAP);
        additionalServiceTypes.add(ServiceType.WMS);
        additionalServiceTypes.add(ServiceType.WCS);
        additionalServiceTypes.add(ServiceType.WFS);
        additionalServiceTypes.add(ServiceType.NetcdfSubset);
    }
    
	public MetadataContainer(Dataset threddsDataset) {
		_dataset = threddsDataset;		
		this.processMetadata();
	}
	
	// Convenience method
	public String getOpenDapUrl() {
		return this._map.get("opendap");
	}
	
	public Map<String, String> getMetadataMap() {
		return this._map;
	}
	
	public void processMetadata() {

	    // Get available online resources including 		
		for(Access access: _dataset.getAccess()){
			if(additionalServiceTypes.contains(access.getService().getType())){
				int pos = access.getStandardUrlName().indexOf("/", 7);
				String serviceBaseUrl = access.getStandardUrlName().substring(0,pos) + access.getService().getBase() + access.getUrlPath();
//				if (access.getService().getServiceType().equals(ServiceType.OPENDAP)) _map.put(access.getService().getServiceType().toString().toLowerCase(), access.getStandardUrlName().replace("http", "dods"));
				// Don't use dods:// it's outdated. Keep http or https
				if (access.getService().getType().equals(ServiceType.OPENDAP)) _map.put(access.getService().getType().toString().toLowerCase(), access.getStandardUrlName());
				if (access.getService().getType().equals(ServiceType.WMS)) _map.put(access.getService().getType().toString().toLowerCase(), serviceBaseUrl + "?service=WMS&version=1.3.0&request=GetCapabilities");
				if (access.getService().getType().equals(ServiceType.WCS)) _map.put(access.getService().getType().toString().toLowerCase(), serviceBaseUrl + "?service=WCS&version=1.0.0&request=GetCapabilities");
				if (access.getService().getType().equals(ServiceType.NetcdfSubset)) _map.put(access.getService().getType().toString().toLowerCase(), serviceBaseUrl);
			}
		}
		
	}
	
	public Dataset getDataset() {
		return _dataset;
	}
	
	
}
