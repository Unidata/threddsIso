package thredds.server.metadata;

import static com.google.common.truth.Truth.assertThat;
import static com.google.common.truth.Truth.assertWithMessage;
import static org.junit.Assert.fail;

import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Properties;
import javax.servlet.http.HttpServletResponse;
import org.junit.BeforeClass;
import org.junit.ClassRule;
import org.junit.Test;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.utility.DockerImageName;
import org.testcontainers.utility.MountableFile;
import org.w3c.dom.Node;
import org.xmlunit.builder.DiffBuilder;
import org.xmlunit.builder.Input;
import org.xmlunit.diff.Diff;
import org.xmlunit.util.Predicate;
import thredds.util.ContentType;
import ucar.httpservices.HTTPException;
import ucar.httpservices.HTTPFactory;
import ucar.httpservices.HTTPMethod;
import ucar.httpservices.HTTPSession;

public class NcIsoIT {
  private static final DockerImageName dockerImageName =
      DockerImageName.parse("unidata/thredds-docker:" + getTdsVersion());
  private static String basePath;

  @ClassRule
  public static final GenericContainer<?> tds = new GenericContainer<>(dockerImageName)
      .withExposedPorts(8080)
      .withCopyFileToContainer(MountableFile.forClasspathResource("/thredds/catalog.xml"),
          "/usr/local/tomcat/content/thredds/catalog.xml")
      .withCopyFileToContainer(MountableFile.forClasspathResource("/thredds/testgrid1.nc"),
          "/usr/local/tomcat/content/thredds/public/testdata/testgrid1.nc")
      .withCopyFileToContainer(MountableFile.forHostPath(getJarPath()),
          "/usr/local/tomcat/webapps/thredds/WEB-INF/lib/tds-plugin-jar-with-dependencies.jar");

  @BeforeClass
  public static void setUp() {
    final String address = tds.getHost();
    final Integer port = tds.getFirstMappedPort();
    basePath = "http://" + address + ":" + port + "/thredds/";
  }

  @Test
  public void shouldReturnNcml() {
    final String path = basePath + "ncml/testAll/testgrid1.nc";
    final String expectedOutput = "/thredds/testgrid1.ncml.xml";
    final Predicate<Node> filter = node -> !(node.hasAttributes() && node.getAttributes().getNamedItem("name") != null
        && (node.getAttributes().getNamedItem("name").getNodeValue().equals("metadata_creation")
        || node.getAttributes().getNamedItem("name").getNodeValue().equals("nciso_version")));
    compare(path, expectedOutput, ContentType.xml, filter);
  }

  @Test
  public void shouldReturnIso() {
    final String path = basePath + "iso/testAll/testgrid1.nc";
    final String expectedOutput = "/thredds/testgrid1.iso.xml";
    final Predicate<Node> filter =
        node -> !node.getTextContent().startsWith("This record was translated from NcML using")
            && !node.getNodeName().startsWith("gco:Date");
    compare(path, expectedOutput, ContentType.xml, filter);
  }

  @Test
  public void shouldReturnUddc() {
    final String path = basePath + "uddc/testAll/testgrid1.nc";
    final String expectedOutput = "/thredds/testgrid1.uddc.html";
    compare(path, expectedOutput, ContentType.html, node -> true);
  }

  private void compare(String endpoint, String expectedOutput, ContentType expectedType, Predicate<Node> filter) {
    final byte[] response = getContent(endpoint, expectedType);

    final Diff diff = DiffBuilder.compare(Input.fromStream(getClass().getResourceAsStream(expectedOutput)))
        .withTest(Input.fromByteArray(response)).normalizeWhitespace()
        // don't compare elements with e.g. version/ current datetime
        .withNodeFilter(filter).build();
    assertWithMessage(diff.toString()).that(diff.hasDifferences()).isFalse();
  }

  private byte[] getContent(String endpoint, ContentType expectedContentType) {
    try (HTTPSession session = HTTPFactory.newSession(endpoint)) {
      final HTTPMethod method = HTTPFactory.Get(session);
      final int statusCode = method.execute();
      assertThat(statusCode).isEqualTo(HttpServletResponse.SC_OK);
      assertThat(method.getResponseHeaderValue(ContentType.HEADER).get())
          .isEqualTo(expectedContentType.getContentHeader());
      return method.getResponseAsBytes();
    } catch (HTTPException e) {
      fail("Problem with HTTP request:" + e);
      return null;
    }
  }

  private static String getPropertyValue(String propertyKey) {
    try {
      final Properties properties = new Properties();
      properties.load(ClassLoader.getSystemClassLoader().getResourceAsStream("project.properties"));
      return properties.getProperty(propertyKey);
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }

  private static String getVersion() {
    return getPropertyValue("version");
  }

  private static String getTdsVersion() {
    return getPropertyValue("tds_version");
  }

  private static Path getJarPath() {
    try {
      final Path targetPath = Paths.get(ClassLoader.getSystemClassLoader().getResource("").toURI()).getParent();
      return Paths.get(targetPath.toString(), "tds-plugin-" + getVersion() + "-jar-with-dependencies.jar");
    } catch (URISyntaxException e) {
      throw new RuntimeException(e);
    }
  }
}
