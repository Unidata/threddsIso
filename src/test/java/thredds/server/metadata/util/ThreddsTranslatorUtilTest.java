package thredds.server.metadata.util;

import org.junit.Test;
import java.io.File;


import static org.junit.Assert.*;
import org.junit.BeforeClass;

public class ThreddsTranslatorUtilTest {
    @BeforeClass
    public static void runBeforeClass()
    {
        File htmlReport = new File ( "resources/out/test.html" );
        if (htmlReport.exists()) htmlReport.delete();
    }

    @Test
    public void testTransform() throws Exception {
        File xsltFile = new File( "resources/xsl/nciso/UnidataDDCount-HTML.xsl" );
        File xmlFile = new File( "resources/extent/test.ncml" );
        //File reportFile = File.createTempFile("tst",".html");
        //System.out.println( reportFile.getAbsolutePath() );
        File reportFile = ThreddsTranslatorUtil.transform(xsltFile, xmlFile, "resources/out/test.html" );

        assertTrue( reportFile.exists() );
    }

}
