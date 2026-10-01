package gov.noaa.eds.controller;

import static com.google.common.truth.Truth.assertThat;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import org.junit.BeforeClass;
import org.junit.Test;

public class TestServiceController {

  static File tempDir;

  @BeforeClass
  public static void setup() throws IOException {
    tempDir = Files.createTempDirectory("ncIso").toFile();
    tempDir.deleteOnExit();
  }

  @Test
  public void basicTest() throws IOException {
    String url = "-ts https://thredds.ucar.edu/thredds/catalog/casestudies/harvey/model/gfs_ana/catalog.xml";
    String num = "-num 1";
    String depth = "-depth 20";
    String iso = "-iso true";
    String waf = String.format("-waf %s", tempDir.getAbsolutePath());
    String[] args = String.join(" ", new String[] {url, num, depth, iso, waf}).split(" ");
    ServiceController.main(args);
    assertThat(tempDir.exists());
    assertThat(tempDir.isDirectory());
    File isoDir = Paths.get(tempDir.getAbsolutePath(), "iso").toFile();
    assertThat(isoDir.exists());
    assertThat(isoDir.isDirectory());
    File report = Paths.get(isoDir.getAbsolutePath(), "ferret.xml").toFile();
    assertThat(report.exists());
    assertThat(report.isFile());
  }
}
