package thredds.server.metadata.util;

import org.junit.Test;

import static org.junit.Assert.*;

public class NCMLModiferTest {

    @Test
    public void testFormat() throws Exception {
        NCMLModifier ncmlModifier = new NCMLModifier();
        double dbl = -1.6391277313232422E-6;
        String fmtDbl = ncmlModifier.format(dbl);

        assertEquals("-.0", fmtDbl);
    }

}
