package thredds.server.metadata.nciso.util;

import static com.google.common.truth.Truth.assertThat;

import org.junit.Test;


public class NCMLModiferTest {

    @Test
    public void testFormat() throws Exception {
        NCMLModifier ncmlModifier = new NCMLModifier();
        double dbl = -1.6391277313232422E-6;
        String fmtDbl = ncmlModifier.format(dbl);

        assertThat("-.0").isEqualTo(fmtDbl);
    }
}
