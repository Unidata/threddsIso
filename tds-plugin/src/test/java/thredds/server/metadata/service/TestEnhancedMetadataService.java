package thredds.server.metadata.service;

import static com.google.common.truth.Truth.assertWithMessage;

import java.io.StringWriter;
import java.io.Writer;
import org.junit.Test;
import org.w3c.dom.Node;
import org.xmlunit.builder.DiffBuilder;
import org.xmlunit.builder.Input;
import org.xmlunit.diff.Diff;
import org.xmlunit.util.Predicate;
import ucar.nc2.dataset.NetcdfDataset;
import ucar.nc2.dataset.NetcdfDatasets;

public class TestEnhancedMetadataService {

  @Test
  public void shouldReturnMetadata() throws Exception {
    final String path = getClass().getResource("/thredds/testgrid1.nc").getPath();
    final Writer writer = new StringWriter();

    try (NetcdfDataset netcdfDataset = NetcdfDatasets.openDataset(path)) {
      EnhancedMetadataService.enhance(netcdfDataset, null, writer);
    }

    // don't compare elements with current datetime or version
    final Predicate<Node> filter = node -> !(node.hasAttributes() && node.getAttributes().getNamedItem("name") != null
        && (node.getAttributes().getNamedItem("name").getNodeValue().equals("metadata_creation")
        || node.getAttributes().getNamedItem("name").getNodeValue().equals("nciso_version")));

    final Diff diff =
        DiffBuilder.compare(Input.fromStream(getClass().getResourceAsStream("/thredds/testgrid1.ncml.xml")))
        .withTest(writer.toString())
        .withNodeFilter(filter)
        .build();
    assertWithMessage(diff.toString()).that(diff.hasDifferences()).isFalse();
  }
}
