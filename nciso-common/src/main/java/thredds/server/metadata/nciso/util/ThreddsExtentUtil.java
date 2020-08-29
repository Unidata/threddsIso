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
package thredds.server.metadata.nciso.util;

import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.time.DurationFormatUtils;

import com.google.common.collect.Lists;

import thredds.server.metadata.nciso.bean.Extent;
import ucar.ma2.Array;
import ucar.nc2.Attribute;
import ucar.nc2.Variable;
import ucar.nc2.constants.AxisType;
import ucar.nc2.constants.CF;
import ucar.nc2.constants.FeatureType;
import ucar.nc2.dataset.CoordinateAxis;
import ucar.nc2.dataset.NetcdfDataset;
import ucar.nc2.dataset.NetcdfDatasets;
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

		try (NetcdfDataset ncd = NetcdfDatasets.openDataset(url)) {
			ext = getExtent(ncd);
		} catch (Exception e) {
			e.printStackTrace();
			String err = "Could not load NETCDF file: " + url
					+ " because of Exception. " + e.getLocalizedMessage();
			_log.error(err, e);
		}
		return ext;
	}

    private static boolean variableHasAttribute(Variable var, String attribute, String... values) {
        if (values == null || values.length == 0) {
            return false;
        }
        Attribute attr = var.attributes().findAttributeIgnoreCase(attribute);
        if (attr == null) {
            return false;
        }
        String attrValue = attr.getStringValue();
        if (attrValue == null) {
            return false;
        }
        for (String value : values) {
            if (attrValue.equalsIgnoreCase(value)) {
                return true;
            }
        }
        return false;
    }

    private static boolean variableHasFullName(Variable var, String... varNames) {
        if (varNames == null || varNames.length == 0) {
            return false;
        }
        for (String varName : varNames) {
            if (var.getFullName().equalsIgnoreCase(varName)) {
                return true;
            }
        }
        return false;
    }

    private static boolean variableHasStdName(Variable var, String... stdNames) {
        return variableHasAttribute(var, CF.STANDARD_NAME, stdNames);
    }

    
    private static boolean variableHasUnits(Variable var, String... unitsArr) {
        return variableHasAttribute(var, "units", unitsArr);        
    }

    private static Variable findLatVar(List<Variable> vars) {
        //search using standard name first
        for (Variable var : vars) {
            if (variableHasStdName(var, "latitude", "grid_latitude")) {
                return var;
            }
        }
        //now search using units
        for (Variable var : vars) {
            if (variableHasUnits(var, "degrees_north")) {
                return var;
            }
        }
        return null;
    }

    private static Variable findLonVar(List<Variable> vars) {
        //search using standard name first
        for (Variable var : vars) {
            if (variableHasStdName(var, "longitude", "grid_longitude")) {
                return var;
            }
        }
        //now search using units
        for (Variable var : vars) {
            if (variableHasUnits(var, "degrees_east")) {
                return var;
            }
        }
        return null;
    }

    private static CoordinateAxis findAxisByType(List<CoordinateAxis> coordAxes, AxisType axisType) {
        for (CoordinateAxis axis : coordAxes) {
            if (axis.getAxisType() == axisType) {
                return axis;
            }
        }
        return null;
    }
    
    private static CoordinateAxis findTimeAxis(List<CoordinateAxis> coordAxes) {
        //search using standard name first
        List<CoordinateAxis> timeAxes = Lists.newArrayList();
        for (CoordinateAxis axis : coordAxes) {
            if (axis.getAxisType() == AxisType.Time && variableHasStdName(axis, CF.TIME)) {
                timeAxes.add(axis);
            }
        }
        if (timeAxes.size() == 1) {
            //one std name match, return match
            return timeAxes.get(0);
        } else if (timeAxes.size() > 1) {
            //multiple std name matches, look for variable named "time"
            for (CoordinateAxis timeAxis : timeAxes) {
                if (variableHasFullName(timeAxis, "TIME")) {
                    return timeAxis;
                }
            }
            //no "time" variable found, return first found "time" std name
            return timeAxes.get(0);
        } else {
            //no std name matches, search using var name
            for (CoordinateAxis axis : coordAxes) {
                if (axis.getAxisType() == AxisType.Time && variableHasFullName(axis, "TIME")) {
                    return axis;
                }
            }
        }
        return null;
    }

    private static CoordinateAxis findHeightAxis(List<CoordinateAxis> coordAxes) {
        //search using standard name first
        for (CoordinateAxis axis : coordAxes) {
            if (axis.getAxisType() == AxisType.Height
                    && variableHasStdName(axis, "depth", "height", "altitude")) {
                return axis;
            }
        }
        //now search using var name
        for (CoordinateAxis axis : coordAxes) {
            if (axis.getAxisType() == AxisType.Height
                    && variableHasFullName(axis, "depth", "height", "altitude", "z")) {
                return axis;
            }
        }
        return null;
    }

    private static Extent doGetExtent(final NetcdfDataset ncd) throws Exception {
        double maxLon = -9999.999;
        double minLon = 9999.999;
        double maxLat = -9999.999;
        double minLat = 9999.999;

        Extent ext = new Extent();

        List<CoordinateAxis> coordAxes = ncd.getCoordinateAxes();
        List<Variable> vars = ncd.getVariables();		
        try {
            Variable latVar = findLatVar(vars);
            if (latVar != null) {
                ext._latUnits = latVar.getUnitsString();
                Array vals = latVar.read();
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

            Variable lonVar = findLonVar(vars);
            if (lonVar != null) {
                ext._lonUnits = lonVar.getUnitsString();
                Array vals = lonVar.read();
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

            CoordinateAxis timeAxis = findTimeAxis(coordAxes);
            if (timeAxis != null) {
                _log.info("numTimeElems=" + timeAxis.getSize());
                _log.info("axisName=" + timeAxis.getFullName());
                logAvailableMemory("Retrieving Time coordAxis values");

                ext._minTime = Double.toString(timeAxis.getMinValue());
                ext._maxTime = Double.toString(timeAxis.getMaxValue());

                // Add 2/8/2011
                String rawMinTime = Double
                        .toString(timeAxis.getMinValue());
                String rawMaxTime = Double
                        .toString(timeAxis.getMaxValue());
                _log.info("udunits string = " + rawMinTime + " "
                        + timeAxis.getUnitsString());

                Date startDate = DateUnit.getStandardDate(rawMinTime + " "
                        + timeAxis.getUnitsString());
                Date endDate = DateUnit.getStandardDate(rawMaxTime + " "
                        + timeAxis.getUnitsString());
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
                if ((timeAxis.getSize() - 1) > 0) {
                    timeRes = (duration / 1000) / (timeAxis.getSize() - 1);
                }
                ext._timeRes = Double.toString(timeRes);
                ext._timeUnits = "seconds";			    
            }

            CoordinateAxis heightAxis = findHeightAxis(coordAxes);
            if (heightAxis != null) {
                // logAvailableMemory("Retrieving Height coordAxis values");
                _log.info("axisName=" + heightAxis.getFullName());
                ext._minHeight = heightAxis.getMinValue();
                ext._maxHeight = heightAxis.getMaxValue();
                ext._heightUnits = heightAxis.getUnitsString();
                ext._vOrientation = heightAxis.getPositive();
                ext._heightRes = 0.0d;
                if ((heightAxis.getSize() - 1) > 0) {
                    ext._heightRes = ((heightAxis.getMaxValue() - heightAxis
                            .getMinValue()) / (heightAxis.getSize() - 1));
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
            CoordinateAxis timeAxis = findTimeAxis(coordAxes);
            if (timeAxis != null) {
                _log.info("numTimeElems=" + timeAxis.getSize());
                _log.info("axisName=" + timeAxis.getFullName());
                logAvailableMemory("Retrieving Time coordAxis values");

                ext._minTime = Double.toString(timeAxis.getMinValue());
                ext._maxTime = Double.toString(timeAxis.getMaxValue());

                // Add 2/8/2011
                String rawMinTime = Double
                        .toString(timeAxis.getMinValue());
                String rawMaxTime = Double
                        .toString(timeAxis.getMaxValue());
                _log.info("udunits string = " + rawMinTime + " "
                        + timeAxis.getUnitsString());

                Date startDate = DateUnit.getStandardDate(rawMinTime + " "
                        + timeAxis.getUnitsString());
                Date endDate = DateUnit.getStandardDate(rawMaxTime + " "
                        + timeAxis.getUnitsString());
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
                if ((timeAxis.getSize() - 1) > 0) {
                    timeRes = (duration / 1000) / (timeAxis.getSize() - 1);
                }
                ext._timeRes = Double.toString(timeRes);
                ext._timeUnits = "seconds";            
            }

            CoordinateAxis latAxis = findAxisByType(coordAxes, AxisType.Lat);
            if (latAxis != null) {
                // logAvailableMemory("Retrieving Lat coordAxis values");
                ext._minLat = latAxis.getMinValue();
                ext._maxLat = latAxis.getMaxValue();
                ext._latUnits = latAxis.getUnitsString();
                ext._latRes = 0.0d;
                if ((latAxis.getSize() - 1) > 0) {
                    ext._latRes = ((latAxis.getMaxValue() - latAxis
                            .getMinValue()) / (latAxis.getSize() - 1));
                }
            }

            CoordinateAxis lonAxis = findAxisByType(coordAxes, AxisType.Lon);
            if (lonAxis != null) {
                // logAvailableMemory("Retrieving Lon coordAxis values");
                ext._minLon = lonAxis.getMinValue();
                ext._maxLon = lonAxis.getMaxValue();
                ext._lonUnits = lonAxis.getUnitsString();
                ext._lonRes = 0.0d;
                if ((lonAxis.getSize() - 1) > 0) {
                    ext._lonRes = ((lonAxis.getMaxValue() - lonAxis
                            .getMinValue()) / (lonAxis.getSize() - 1));
                }            
            }

            CoordinateAxis heightAxis = findHeightAxis(coordAxes);
            if (heightAxis != null) {
                // logAvailableMemory("Retrieving Height coordAxis values");
                _log.info("axisName=" + heightAxis.getFullName());
                ext._minHeight = heightAxis.getMinValue();
                ext._maxHeight = heightAxis.getMaxValue();
                ext._heightUnits = heightAxis.getUnitsString();
                ext._vOrientation = heightAxis.getPositive();
                ext._heightRes = 0.0d;
                if ((heightAxis.getSize() - 1) > 0) {
                    ext._heightRes = ((heightAxis.getMaxValue() - heightAxis
                            .getMinValue()) / (heightAxis.getSize() - 1));
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
