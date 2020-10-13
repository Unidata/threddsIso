package gov.noaa.eds.threddsutilities.service.iface;

import gov.noaa.eds.threddsutilities.bean.MetadataContainer;
import thredds.server.metadata.nciso.exception.ThreddsUtilitiesException;

import java.util.Vector;

/**
 * ICatalogCrawler
 * Date: Feb 22, 2010
 * Time: 12:22:44 PM
 *
 * @author rbaker
 */
public interface ICatalogCrawler extends IBaseServiceObject{

    public static final String KEY = "iCatalogCrawler";
    /**
     * Finds a list of URLs to THREDDS catalogs
     * @param url
     * @param depth
     * @param leaves
     * @param urls
     * @throws ThreddsUtilitiesException
     */
    public void crawlThredds(String url, int depth, int leaves, Vector<MetadataContainer> mdcs) throws ThreddsUtilitiesException;


}

