package thredds.server.metadata.nciso;

import static com.google.common.truth.Truth.assertThat;
import static org.junit.Assert.fail;

import org.junit.Test;

import thredds.server.metadata.nciso.bean.Extent;
import thredds.server.metadata.nciso.util.ThreddsExtentUtil;

public class ThreddsExtentUtilTest {
    private Extent getExtent(String file) throws Exception {
        return ThreddsExtentUtil.getExtent("file:src/test/resources/extent/" + file + ".ncml");
    }

    @Test
    public void testExtent() throws Exception {
        validateExtent(getExtent("test"));
    }

    @Test
    public void testExtentPositiveDown() throws Exception {
        validateExtent(getExtent("test_positive_down"));
    }

    @Test
    public void testExtentStandardNames() throws Exception {
        validateExtent(getExtent("test_standard_names"));
    }

    @Test
    public void testExtentMultipleTimeStdNames() throws Exception {
        validateExtent(getExtent("test_multiple_time_std_names"));
    }

    private void validateExtent(Extent extent) throws Exception {
        assertThat(extent._minLat).isWithin(1e-20).of(39.0);
        assertThat(extent._maxLat).isWithin(1e-20).of(41.0);
        assertThat(extent._latUnits).isEqualTo("degrees_north");
        assertThat(extent._latRes).isWithin(1e-20).of(1.0);
        
        assertThat(extent._minLon).isWithin(1e-20).of(-109.0);
        assertThat(extent._maxLon).isWithin(1e-20).of(-105.0);
        assertThat(extent._lonUnits).isEqualTo("degrees_east");
        assertThat(extent._lonRes).isWithin(1e-20).of(2.0);

        assertThat(extent._minTime).isEqualTo("2015-01-01T06:00:00Z");
        assertThat(extent._maxTime).isEqualTo("2015-01-01T18:00:00Z");
        assertThat(extent._timeUnits).isEqualTo("seconds");
        assertThat(extent._timeDuration).isEqualTo("P0Y0M0DT12H0M0.000S");
        assertThat(extent._timeRes).isEqualTo("43200.0");

        assertThat(extent._heightRes).isWithin(1e-20).of(10.0);
        assertThat(extent._heightUnits).isEqualTo("meters");
        assertThat(extent._vOrientation).isNotNull();
        if (extent._vOrientation.equalsIgnoreCase("up")) {
            assertThat(extent._minHeight).isWithin(1e-20).of(-10.0);
            assertThat(extent._maxHeight).isWithin(1e-20).of(0.0);
        } else if (extent._vOrientation.equalsIgnoreCase("down")) {
            assertThat(extent._minHeight).isWithin(1e-20).of(0.0);
            assertThat(extent._maxHeight).isWithin(1e-20).of(10.0);
        } else {
            fail("Invalid vOrientation value: " + extent._vOrientation);
        }
    }
}
