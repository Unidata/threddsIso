package thredds.server.metadata.util;

import org.junit.Test;

import static org.junit.Assert.assertEquals;
import thredds.server.metadata.bean.Extent;

public class ThreddsExtentUtilTest {
    private Extent getExtent(String file) throws Exception {
        return ThreddsExtentUtil.getExtent("file:src/test/resources/extent/" + file + ".ncml");
    }
    
    @Test
    public void testExtent() throws Exception {
        Extent extent = getExtent("test");
        validateExtent(extent);

        assertEquals("up", extent._vOrientation);
        assertEquals(-10.0, extent._minHeight, 1E-20);
        assertEquals(0.0, extent._maxHeight, 1E-20);
    }

    @Test
    public void testExtentPositiveDown() throws Exception {
        Extent extent = getExtent("test_positive_down");
        validateExtent(extent);

        assertEquals("down", extent._vOrientation);
        assertEquals(0.0, extent._minHeight, 1E-20);
        assertEquals(10.0, extent._maxHeight, 1E-20);
    }

    @Test
    public void testExtentStandardNames() throws Exception {
        Extent extent = getExtent("test_standard_names");
        validateExtent(extent);

        assertEquals("up", extent._vOrientation);
        assertEquals(-10.0, extent._minHeight, 1E-20);
        assertEquals(0.0, extent._maxHeight, 1E-20);
    }

    private void validateExtent(Extent extent) throws Exception {
        assertEquals(39.0, extent._minLat, 1E-20);
        assertEquals(41.0, extent._maxLat, 1E-20);
        assertEquals("degrees_north", extent._latUnits);
        assertEquals(1.0, extent._latRes, 1E-20);
        
        assertEquals(-109.0, extent._minLon, 1E-20);
        assertEquals(-105.0, extent._maxLon, 1E-20);
        assertEquals("degrees_east", extent._lonUnits);
        assertEquals(2.0, extent._lonRes, 1E-20);

        assertEquals("2015-01-01T06:00:00Z", extent._minTime);
        assertEquals("2015-01-01T18:00:00Z", extent._maxTime);
        assertEquals("seconds", extent._timeUnits);
        assertEquals("P0Y0M0DT12H0M0.000S", extent._timeDuration);
        assertEquals("43200.0", extent._timeRes);

        assertEquals(10.0, extent._heightRes, 1E-20);
        assertEquals("meters", extent._heightUnits);
    }
}
