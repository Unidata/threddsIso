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

import thredds.server.metadata.exception.ThreddsUtilitiesException;

import org.apache.commons.lang.StringUtils;

import ucar.nc2.NCdumpW;
import ucar.nc2.NetcdfFile;
import ucar.nc2.dataset.NetcdfDataset;
import ucar.nc2.ncml.NcMLWriter;

import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import java.io.*;

/**
 * ThreddsTranslatorUtil
 * @author: dneufeld
 * Date: May 19, 2010
 */
public class ThreddsTranslatorUtil {
  static private org.slf4j.Logger _log = org.slf4j.LoggerFactory.getLogger(ThreddsTranslatorUtil.class);
    private static final String _tempFileName = "theFile.out";
    private static final TransformerFactory transFact = new net.sf.saxon.TransformerFactoryImpl();

    private static StreamSource getXSLT(String xslName) {
    	return new StreamSource(ThreddsTranslatorUtil.class.getResourceAsStream("/resources/xsl/" + xslName));
    }
    
    /**
     * Creates an NCML file based up on a given location of a NetCDF file. The file will be deleted upon exit.
     * @param location The fully qualified path including the file name of the NetCDF file.
     * @return A File containing the NCML.
     * @throws ThreddsUtilitiesException
     */
    public static File getNcml(final String location) throws ThreddsUtilitiesException {
        return doGetNcml(location, null);
    }

    /**
     * Creates an NCML file based up on a given location.
     * @param location The fully qualified path to the NetCDF file. location must point to a valid netCDF dataset.
     * @param saveFileLocation The fully qualified path to where the file should be saved.
     * @return
     * @throws ThreddsUtilitiesException
     */
    public static File getNcml(final String location, final String saveFileLocation)  throws ThreddsUtilitiesException{
        return doGetNcml(location,saveFileLocation);
    }

    

    private static File doGetNcml(final String location, final String saveFileLocation) {
        File ncml = null;

        try {
            NetcdfDataset ncd = NetcdfDataset.openDataset(location);
            if(!StringUtils.isEmpty(saveFileLocation)){
                ncml = new File(saveFileLocation);
            } else {
                ncml = new File(_tempFileName);
            }
            FileWriter writer = new FileWriter(ncml);

            NCdumpW.writeNcML(ncd,writer,NCdumpW.WantValues.all,null);
        } catch (Exception e) {
			String err = "Could not load NETCDF file: "+location+" because of Exception. "+e.getLocalizedMessage();
			_log.error(err,e);			
        } finally {
            if(StringUtils.isEmpty(saveFileLocation)){
                if(ncml != null && ncml.exists()){
                    ncml.deleteOnExit();
                }
            }


        }
        return ncml;
    }


    /**
     * Creates an NCML file based upon the provided netCDF file.
     * @param ncFile The provided netCDF file
     * @param fileLocation A String representing the fully qualified path including the file's name where the ncml should
     * be saved to. I
     * @return an NCML file
     * @throws ThreddsUtilitiesException
     */
    public static File getNcml(final NetcdfFile ncFile, final String fileLocation)
            throws ThreddsUtilitiesException {
        return doGetNcml(ncFile, fileLocation);
    }

    /**
     * Creates an NCML file based upon the provided netCDF file. The file will be deleted from the file system.
     * when the JVM exits. If you would like to have the file saved to the file system,
     * use getNcml(final NetcdfFile ncFile, final String fileLocation)
     * @param ncFile The provided netCDF file
     * @return an NCML file
     * @throws ThreddsUtilitiesException
     */
    public static File getNcml(final NetcdfFile ncFile) throws ThreddsUtilitiesException {
        return doGetNcml(ncFile, null);
    }

    private static File doGetNcml(final NetcdfFile ncFile, final String fileLocation)
            throws ThreddsUtilitiesException {
        NcMLWriter ncMLWriter = new NcMLWriter();
        File returnFile;
        if(!StringUtils.isEmpty(fileLocation)){
            returnFile = new File(fileLocation);
        } else {
            returnFile = new File(_tempFileName);
        }
        FileWriter fw = null;
        try {
            fw = new FileWriter(returnFile);
            ncFile.writeNcML(fw, null);
        } catch (IOException e) {
			String err = "Could not load NETCDF file: "+ncFile.getLocation()+" because of IOException. "+
                    e.getLocalizedMessage();
			_log.error(err,e);
			throw new ThreddsUtilitiesException(err,e,ThreddsUtilitiesException.EXCEPTION_TYPES.IO_EXCEPTION);
        } finally {
            if(fw != null){
                try {
                    fw.flush();
                    fw.close();
                } catch (IOException e) {
                    String err = "Could not close NETCDF file: "+ncFile.getLocation()+" because of IOException. "+
                            e.getLocalizedMessage();
                    _log.error(err,e);
                    throw new ThreddsUtilitiesException(err,e,ThreddsUtilitiesException.EXCEPTION_TYPES.IO_EXCEPTION);
                }
                if(StringUtils.isEmpty(fileLocation)){
                    if(returnFile != null && returnFile.exists()){
                        returnFile.deleteOnExit();
                    }
                }
            }
        }
        return returnFile;
    }

    /**
     * Transforms an XML document based on the provided XSLT. The transformed document will be
     * deleted when the JVM exits.
     * @param xsltFile
     * @param xml
     * @return A File with the transform result
     * @throws ThreddsUtilitiesException
     */
    public static File transform(final File xsltFile, final File xml) throws ThreddsUtilitiesException {
		 return doTransform(xsltFile, xml, null);
	}

    public static File transform(final String xsltFileStr, final String xmlStr, final String fileLocation) throws ThreddsUtilitiesException {         
        File xml = new File(xmlStr); 
    	return doTransform(xsltFileStr, xml, fileLocation);
    }

    public static void transform(final String xsltFileStr, final InputStream is, Writer writer) throws ThreddsUtilitiesException {         
    	StreamSource xsltSS = getXSLT(xsltFileStr);
    	doTransform(xsltSS, is, writer);
    }
    
    public static void transform(final File xsltFile, final InputStream is, Writer writer) throws ThreddsUtilitiesException {         
    	doTransform(xsltFile, is, writer);
    }
    
    public static void transform(final String xsltFileStr, final NetcdfFile netcdfFile, Writer writer) throws ThreddsUtilitiesException {         
        StreamSource xsltSS = getXSLT(xsltFileStr);
        NcMLWriter ncMLWriter = new NcMLWriter();

		String ncml;
		InputStream is;
		try {
            ByteArrayOutputStream dsToNcml = new ByteArrayOutputStream();
            netcdfFile.writeNcML(dsToNcml,null);
            is = new ByteArrayInputStream(dsToNcml.toByteArray());
		} catch (UnsupportedEncodingException uee) {
			String err = "UnsupportedEncodingException " + uee.getLocalizedMessage();
			_log.error(err, uee);
			throw new ThreddsUtilitiesException(
					err,
					uee,
					ThreddsUtilitiesException.EXCEPTION_TYPES.TRANSFORMER_EXCEPTION);
		} catch (IOException ioe) {
			String err = "IOException " + ioe.getLocalizedMessage();
			_log.error(err, ioe);
			throw new ThreddsUtilitiesException(
					err,
					ioe,
					ThreddsUtilitiesException.EXCEPTION_TYPES.TRANSFORMER_EXCEPTION);
		} 	
		
    	doTransform(xsltSS, is, writer);
    }
       
    
    /**
     * Transforms an XML document based on the provided XSLT. The transformed document will be
     * saved based upon the fileLocation.
     * @param xsltFile The transform
     * @param xml The XML document to be transformed
     * @param fileLocation The fully qualified path, including the file name where the transformed file should be saved.
     * If this is empty or null, the file will be deleted when the JVM exits.
     * @return A File with the transform result
     * @throws ThreddsUtilitiesException
     */
    public static  File transform(final File xsltFile, final File xml, final String fileLocation)
            throws ThreddsUtilitiesException {
		 return doTransform(xsltFile, xml, fileLocation);
	}

    private static File doTransform(final File xsltFile, final File srcFile, final String fileLocation)
            throws ThreddsUtilitiesException {
        File returnFile;
        if(!StringUtils.isEmpty(fileLocation)){
            returnFile = new File(fileLocation);
        } else {
            returnFile = new File(_tempFileName);
        }
        Source xsltSource = new StreamSource(xsltFile);
        Templates cachedXSLT;
        StreamResult result = new StreamResult(returnFile);
        StreamSource xmlStream = new StreamSource(srcFile);
		try {
			cachedXSLT = transFact.newTemplates(xsltSource);
			Transformer trans = cachedXSLT.newTransformer();
			trans.transform(xmlStream, result);
		} catch (TransformerConfigurationException tce) {
			String err = "Configuration problem: "+xsltFile+" TransformerConfigurationException. "+
            tce.getLocalizedMessage();
	        _log.error(err,tce);
	        throw new ThreddsUtilitiesException(err,tce,ThreddsUtilitiesException.EXCEPTION_TYPES.TRANSFORMERCOFIGURATION_EXCEPTION);
		} catch (TransformerException te) {
			String err = "Transformer problem: "+srcFile.getName()+" TransformerException. "+
            te.getLocalizedMessage();
	        _log.error(err,te);
	        throw new ThreddsUtilitiesException(err,te,ThreddsUtilitiesException.EXCEPTION_TYPES.TRANSFORMER_EXCEPTION);
		} finally {
            if(StringUtils.isEmpty(fileLocation)){
                if(returnFile != null && returnFile.exists()){
                    returnFile.deleteOnExit();
                }
            }
        }
        return returnFile;
    }

    private static File doTransform(final String xsltLocationStr, final File srcFile, final String fileLocation) 
           throws ThreddsUtilitiesException {
        File returnFile;
        if(!StringUtils.isEmpty(fileLocation)){
            returnFile = new File(fileLocation);
        } else {
            returnFile = new File(_tempFileName);
        }
        Source xsltSource = new StreamSource(xsltLocationStr);
        Templates cachedXSLT;
        try {
            StreamResult result = new StreamResult(new FileOutputStream(returnFile));
            StreamSource xmlStream = new StreamSource(srcFile);		
			cachedXSLT = transFact.newTemplates(xsltSource);
			Transformer trans = cachedXSLT.newTransformer();
			trans.transform(xmlStream, result);
		} catch (TransformerConfigurationException tce) {
			String err = "Configuration problem: "+xsltLocationStr+" TransformerConfigurationException. "+
            tce.getLocalizedMessage();
	        _log.error(err,tce);
	        throw new ThreddsUtilitiesException(err,tce,ThreddsUtilitiesException.EXCEPTION_TYPES.TRANSFORMERCOFIGURATION_EXCEPTION);
		} catch (TransformerException te) {
			String err = "Transformer problem: "+srcFile.getName()+" TransformerException. "+
            te.getLocalizedMessage();
	        _log.error(err,te);
	        throw new ThreddsUtilitiesException(err,te,ThreddsUtilitiesException.EXCEPTION_TYPES.TRANSFORMER_EXCEPTION);
		} catch (FileNotFoundException fnfe) {
			String err = "FileNotFoundException in ThreddsTranslatorUtil: " + srcFile.getName();
			_log.error(err, fnfe);
    	} finally {
            if(StringUtils.isEmpty(fileLocation)){
                if(returnFile != null && returnFile.exists()){
                    returnFile.deleteOnExit();
                }
            }
        }
        return returnFile;
    }    

	private static void doTransform(final StreamSource xsltSS, final InputStream is, Writer writer) throws ThreddsUtilitiesException {
		try {

		    Templates cachedXSLT;
		    StreamResult result = new StreamResult(writer);        

			StreamSource xmlStream = new StreamSource(is);
			cachedXSLT = transFact.newTemplates(xsltSS);
			Transformer trans = cachedXSLT.newTransformer();
			trans.transform(xmlStream, result);
		} catch (TransformerConfigurationException tce) {
			String err = "TransformerConfigurationException. "
					+ tce.getLocalizedMessage();
			_log.error(err, tce);
			throw new ThreddsUtilitiesException(
					err,
					tce,
					ThreddsUtilitiesException.EXCEPTION_TYPES.TRANSFORMERCOFIGURATION_EXCEPTION);
		} catch (TransformerException te) {
			String err = "TransformerException. " + te.getLocalizedMessage();
			_log.error(err, te);
			throw new ThreddsUtilitiesException(
					err,
					te,
					ThreddsUtilitiesException.EXCEPTION_TYPES.TRANSFORMER_EXCEPTION);
		}

	}
    
	private static void doTransform(final File xslFile, final InputStream is, Writer writer) throws ThreddsUtilitiesException {
		try {
		    Source xsltSource = new StreamSource(xslFile);
		    Transformer  transformer = transFact.newTransformer(xsltSource);
		    //Templates cachedXSLT;
		    StreamResult result = new StreamResult(writer);        

			StreamSource xmlStream = new StreamSource(is);
			//cachedXSLT = transFact.newTemplates(xsltSource);
			transformer.transform(xmlStream, result);
			//trans.transform(xmlStream, result);
		} catch (TransformerConfigurationException tce) {
			String err = "TransformerConfigurationException. "
					+ tce.getLocalizedMessage();
			_log.error(err, tce);
			throw new ThreddsUtilitiesException(
					err,
					tce,
					ThreddsUtilitiesException.EXCEPTION_TYPES.TRANSFORMERCOFIGURATION_EXCEPTION);
		} catch (TransformerException te) {
			String err = "TransformerException. " + te.getLocalizedMessage();
			_log.error(err, te);
			throw new ThreddsUtilitiesException(
					err,
					te,
					ThreddsUtilitiesException.EXCEPTION_TYPES.TRANSFORMER_EXCEPTION);
		}

	}
}
