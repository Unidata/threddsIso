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
package thredds.server.metadata.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;

import thredds.catalog.InvDataset;
import thredds.server.metadata.exception.ThreddsUtilitiesException;
import thredds.server.metadata.service.EnhancedMetadataService;
import thredds.server.metadata.util.DatasetHandlerAdapter;
import thredds.server.metadata.util.ThreddsTranslatorUtil;
import thredds.servlet.ThreddsConfig;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.io.Writer;

import ucar.nc2.dataset.NetcdfDataset;

/**
 * Controller for UDDC service 
 * Author: dneufeld Date: Jul 7, 2010
 * <p/>
 */
@Controller
@RequestMapping("/uddc")
public class UddcController extends AbstractMetadataController {
	private static org.slf4j.Logger _log = org.slf4j.LoggerFactory
		    .getLogger(UddcController.class);

	protected String getPath() {
		return _metadataServiceType + "/";
	}
	
	public void init() throws ServletException {
		_metadataServiceType = "UDDC";
		_logServerStartup.info("Metadata UDDC - initialization start");
		_allow = ThreddsConfig.getBoolean("NCISO.uddcAllow", false);
	    _logServerStartup.info("NCISO.uddcAllow = " + _allow);		
		String ncIsoXslFilePath = super.sc.getRealPath("/WEB-INF/classes/resources/xsl/nciso") + "/UnidataDDCount-HTML.xsl";		  
		xslFile = new File(ncIsoXslFilePath); 		    
	}

	public void destroy() {
		NetcdfDataset.shutdown();
		_logServerStartup.info("Metadata UDDC - destroy done");
	}

	/** 
	* Generate a report on quality of the metadata for the underlying NetcdfDataset
	* 
	* @param request incoming url request 
	* @param response outgoing web based response
	* @throws ServletException if ServletException occurred
	* @throws IOException if IOException occurred  
	*/	
	@RequestMapping(params = {})
	public void handleMetadataRequest(final HttpServletRequest req,
			final HttpServletResponse res) throws ServletException {
		_log.info("Handling UDDC metadata request.");

		NetcdfDataset netCdfDataset = null;

		try {
			isAllowed(_allow, _metadataServiceType, res);
			res.setContentType("text/html");
			netCdfDataset = DatasetHandlerAdapter.openDataset(req, res);
			if (netCdfDataset == null) {
				res.sendError(HttpServletResponse.SC_NOT_FOUND,
						"ThreddsIso Extension: Requested resource not found.");
			} else {
				Writer writer = new StringWriter();
				// Get Thredds level metadata if it exists
				InvDataset ids = this.getThreddsDataset(req);

				EnhancedMetadataService.enhance(netCdfDataset, ids, writer);
				String ncml = writer.toString();
				writer.flush();
				writer.close();
				
				
				InputStream is = new ByteArrayInputStream(
						ncml.getBytes("UTF-8"));
			
				ThreddsTranslatorUtil.transform(xslFile, is, res.getWriter());
				
				res.getWriter().flush();
			}
		} catch (ThreddsUtilitiesException tue) {
			String errMsg = "Error in UDDCController: " + req.getQueryString();
			_log.error(errMsg, tue);
			try {this.returnError(errMsg, _metadataServiceType, res);} catch (Exception fe) {}
		} catch (Exception e) {
			String errMsg = "Error in UDDCController: " + req.getQueryString();
			_log.error(errMsg, e);
			try {this.returnError(errMsg, _metadataServiceType, res);} catch (Exception fe) {}

		} finally {
			DatasetHandlerAdapter.closeDataset(netCdfDataset);
		}
	}

}
