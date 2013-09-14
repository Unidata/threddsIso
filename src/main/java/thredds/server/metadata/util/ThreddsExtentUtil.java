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

import java.util.Date;
import java.util.List;

import org.apache.commons.lang.time.DurationFormatUtils;

import thredds.server.metadata.bean.Extent;
import ucar.ma2.Array;
import ucar.nc2.Attribute;
import ucar.nc2.Variable;
import ucar.nc2.constants.AxisType;
import ucar.nc2.constants.FeatureType;
import ucar.nc2.dataset.CoordinateAxis;
import ucar.nc2.dataset.NetcdfDataset;
import ucar.nc2.ft.FeatureDatasetFactoryManager;
import ucar.nc2.units.DateFormatter;
import ucar.nc2.units.DateUnit;

/**
 * ThreddsExtentUtil
 * 
 * @author: dneufeld Date: June 17, 2010
 */
public class ThreddsExtentUtil {
  static private org.slf4j.Logger _log = org.slf4j.LoggerFactory.getLogger(ThreddsExtentUtil.class);

	private static Extent doGetExtent(final String url) throws Exception {
		Extent ext = null;

		try {
			NetcdfDataset ncd = NetcdfDataset.openDataset(url);
			ext = getExtent(ncd);
		} catch (Exception e) {
			e.printStackTrace();
			String err = "Could not load NETCDF file: " + url
					+ " because of Exception. " + e.getLocalizedMessage();
			_log.error(err, e);
		}
		return ext;
	}

	private static boolean isLatCoord(Attribute att) {
		if (att.getName().equals("standard_name")
				&& (att.getStringValue().equals("latitude") || att
						.getStringValue().equals("grid_latitude")))
			return true;

		if (att.getName().equals("units")
				&& (att.getStringValue().equals("degrees_north")))
			return true;

		return false;
	}

	private static boolean isLonCoord(Attribute att) {
		if (att.getName().equals("standard_name")
				&& (att.getStringValue().equals("longitude") || att
						.getStringValue().equals("grid_longitude")))
			return true;
		if (att.getName().equals("units")
				&& (att.getStringValue().equals("degrees_east")))
			return true;
		return false;
	}

	private static Extent doGetExtent(final NetcdfDataset ncd) throws Exception {
		double maxLon = -9999.999;
		double minLon = 9999.999;
		double maxLat = -9999.999;
		double minLat = 9999.999;
		String latUnits = null;
		String lonUnits = null;

		Extent ext = new Extent();

		List<CoordinateAxis> coordAxes = ncd.getCoordinateAxes();
		try {
			List<Variable> vars = ncd.getVariables();
			for (Variable var : vars) {
				List<Attribute> atts = var.getAttributes();
				for (Attribute att : atts) {

					if (isLatCoord(att)) {
						latUnits = var.getUnitsString();
						Array vals = var.read();
						long latSize = vals.getSize();
						for (int i = 0; i < vals.getSize(); i++) {

							double lat = vals.getDouble(i);
							// System.out.println("lat=" + lat);

							if (lat > maxLat) {
								maxLat = lat;
							}
							if (lat < minLat) {
								minLat = lat;
							}
						}

						if (minLat != 9999.999)
							ext._minLat = minLat;
						if (maxLat != 9999.999)
							ext._maxLat = maxLat;
						ext._latRes = 0.0d;
						if ((latSize - 1) > 0) {
							ext._latRes = ((maxLat - minLat) / (latSize - 1));
						}
					}

					if (isLonCoord(att)) {
						lonUnits = var.getUnitsString();
						Array vals = var.read();
						long lonSize = vals.getSize();
						for (int i = 0; i < vals.getSize(); i++) {

							double lon = vals.getDouble(i);
							// System.out.println("lon=" + lon);

							if (lon > maxLon) {
								maxLon = lon;
							}
							if (lon < minLon) {
								minLon = lon;
							}
						}

						if (minLon != 9999.999)
							ext._minLon = minLon;
						if (maxLon != 9999.999)
							ext._maxLon = maxLon;
						ext._lonRes = 0.0d;
						if ((lonSize - 1) > 0) {
							ext._lonRes = ((maxLat - minLat) / (lonSize - 1));
						}
					}
				}
			}

			for (CoordinateAxis coordAxis : coordAxes) {
				if ((coordAxis.getAxisType() == AxisType.Time)
						&& (coordAxis.getFullName().equalsIgnoreCase("TIME"))) {
					_log.info("numTimeElems=" + coordAxis.getSize());
					_log.info("axisName=" + coordAxis.getFullName());
					logAvailableMemory("Retrieving Time coordAxis values");

					ext._minTime = Double.toString(coordAxis.getMinValue());
					ext._maxTime = Double.toString(coordAxis.getMaxValue());

					// Add 2/8/2011
					String rawMinTime = Double
							.toString(coordAxis.getMinValue());
					String rawMaxTime = Double
							.toString(coordAxis.getMaxValue());
					_log.info("udunits string = " + rawMinTime + " "
							+ coordAxis.getUnitsString());

					Date startDate = DateUnit.getStandardDate(rawMinTime + " "
							+ coordAxis.getUnitsString());
					Date endDate = DateUnit.getStandardDate(rawMaxTime + " "
							+ coordAxis.getUnitsString());
					DateFormatter df = new DateFormatter();
					ext._minTime = df.toDateTimeStringISO(startDate);
					ext._maxTime = df.toDateTimeStringISO(endDate);
					// End Add 2/8/2011

					// Revised to get ISO Duration format
					long duration = endDate.getTime() - startDate.getTime();
					ext._timeDuration = DurationFormatUtils
							.formatDurationISO(duration);
					// System.out.println("duration in millisecs=" + duration);
					// System.out.println("intervals =" +
					// (coordAxis.getSize()-1));
					// Revised resolution
					double timeRes = 0.0d;
					if ((coordAxis.getSize() - 1) > 0) {
						timeRes = (duration / 1000) / (coordAxis.getSize() - 1);
					}
					ext._timeRes = Double.toString(timeRes);
					ext._timeUnits = "seconds";
				}

				if ((coordAxis.getAxisType() == AxisType.Height)
						&& (coordAxis.getFullName().equalsIgnoreCase("DEPTH"))) {
					// logAvailableMemory("Retrieving Height coordAxis values");
					_log.info("axisName=" + coordAxis.getFullName());
					ext._minHeight = coordAxis.getMinValue();
					ext._maxHeight = coordAxis.getMaxValue();
					ext._heightUnits = coordAxis.getUnitsString();
					ext._vOrientation = coordAxis.getPositive();
					ext._heightRes = 0.0d;
					if ((coordAxis.getSize() - 1) > 0) {
						ext._heightRes = ((coordAxis.getMaxValue() - coordAxis
								.getMinValue()) / coordAxis.getSize() - 1);
					}
				}

			}
		} catch (Exception e) {
			_log.error("Error in doGetExtent", e);
		}

		return ext;
	}

	private static Extent doGetExtentByAxis(final NetcdfDataset ncd)
			throws Exception {
		Extent ext = new Extent();

		List<CoordinateAxis> coordAxes = ncd.getCoordinateAxes();
		try {
			for (CoordinateAxis coordAxis : coordAxes) {

				if (coordAxis.getAxisType() == AxisType.Lat) {
					// logAvailableMemory("Retrieving Lat coordAxis values");
					ext._minLat = coordAxis.getMinValue();
					ext._maxLat = coordAxis.getMaxValue();
					ext._latUnits = coordAxis.getUnitsString();
					ext._latRes = 0.0d;
					if ((coordAxis.getSize() - 1) > 0) {
						ext._latRes = ((coordAxis.getMaxValue() - coordAxis
								.getMinValue()) / (coordAxis.getSize() - 1));
					}
				}
				if (coordAxis.getAxisType() == AxisType.Lon) {
					// logAvailableMemory("Retrieving Lon coordAxis values");
					ext._minLon = coordAxis.getMinValue();
					ext._maxLon = coordAxis.getMaxValue();
					ext._lonUnits = coordAxis.getUnitsString();
					ext._lonRes = 0.0d;
					if ((coordAxis.getSize() - 1) > 0) {
						ext._lonRes = ((coordAxis.getMaxValue() - coordAxis
								.getMinValue()) / (coordAxis.getSize() - 1));
					}
				}
				if ((coordAxis.getAxisType() == AxisType.Time)
						&& (coordAxis.getFullName().equalsIgnoreCase("TIME"))) {
					_log.info("numTimeElems=" + coordAxis.getSize());
					_log.info("axisName=" + coordAxis.getFullName());
					logAvailableMemory("Retrieving Time coordAxis values");

					ext._minTime = Double.toString(coordAxis.getMinValue());
					ext._maxTime = Double.toString(coordAxis.getMaxValue());

					// Add 2/8/2011
					String rawMinTime = Double
							.toString(coordAxis.getMinValue());
					String rawMaxTime = Double
							.toString(coordAxis.getMaxValue());
					_log.info("udunits string = " + rawMinTime + " "
							+ coordAxis.getUnitsString());

					Date startDate = DateUnit.getStandardDate(rawMinTime + " "
							+ coordAxis.getUnitsString());
					Date endDate = DateUnit.getStandardDate(rawMaxTime + " "
							+ coordAxis.getUnitsString());
					DateFormatter df = new DateFormatter();
					ext._minTime = df.toDateTimeStringISO(startDate);
					ext._maxTime = df.toDateTimeStringISO(endDate);
					// End Add 2/8/2011

					// Revised to get ISO Duration format
					long duration = endDate.getTime() - startDate.getTime();
					ext._timeDuration = DurationFormatUtils
							.formatDurationISO(duration);
					// System.out.println("duration in millisecs=" + duration);
					// System.out.println("intervals =" +
					// (coordAxis.getSize()-1));
					// Revised resolution
					double timeRes = 0.0d;
					if ((coordAxis.getSize() - 1) > 0) {
						timeRes = (duration / 1000) / (coordAxis.getSize() - 1);
					}
					ext._timeRes = Double.toString(timeRes);
					ext._timeUnits = "seconds";
				}

				if ((coordAxis.getAxisType() == AxisType.Height)
						&& (coordAxis.getFullName().equalsIgnoreCase("DEPTH"))) {
					// logAvailableMemory("Retrieving Height coordAxis values");
					_log.info("axisName=" + coordAxis.getFullName());
					ext._minHeight = coordAxis.getMinValue();
					ext._maxHeight = coordAxis.getMaxValue();
					ext._heightUnits = coordAxis.getUnitsString();
					ext._vOrientation = coordAxis.getPositive();
					ext._heightRes = 0.0d;
					if ((coordAxis.getSize() - 1) > 0) {
						ext._heightRes = ((coordAxis.getMaxValue() - coordAxis
								.getMinValue()) / coordAxis.getSize() - 1);
					}
				}

			}
		} catch (Exception e) {
			_log.error("Error in doGetExtentByAxis", e);
		}

		return ext;
	}

	/**
	 * Creates a spatial extent based upon a given url for a NetCDFDataset.
	 * 
	 * @param url
	 *            The fully qualified path to the netCDF file. Url must point to
	 *            a valid netCDF dataset.
	 * @return a spatial extent object
	 * @throws Exception
	 */
	public static Extent getExtent(final String url) throws Exception {
		return doGetExtent(url);
	}

	/**
	 * Creates a spatial extent based upon a given NetcdfDataset.
	 * 
	 * @param ncd
	 *            a valid netCDF dataset.
	 * @return a spatial extent object
	 * @throws Exception
	 */
	public static Extent getExtent(final NetcdfDataset ncd) throws Exception {
		if (FeatureDatasetFactoryManager.findFeatureType(ncd) != null
				&& FeatureDatasetFactoryManager.findFeatureType(ncd) != FeatureType.GRID) {
			_log.info("FeatureType is not null && not a grid getting extent by reading arrays: "
					+ FeatureDatasetFactoryManager.findFeatureType(ncd));
			return doGetExtent(ncd);
		} else { // For now we assume most datasets are grids
			_log.info("FeatureType is null or a GRID getting extent from axes: "
					+ FeatureDatasetFactoryManager.findFeatureType(ncd));
			return doGetExtentByAxis(ncd);
		}
	}

	private static void logAvailableMemory(String message) {
		int mb = 1024 * 1024;

		_log.debug(message);
		_log.info("Total Memory: " + Runtime.getRuntime().totalMemory() / mb);
		_log.info("Free Memory: " + Runtime.getRuntime().freeMemory() / mb);
	}
}
