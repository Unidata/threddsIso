# Unidata threddsISO Code Repository

This is the main threddsISO code repository.
threddsISO provides the NcML, ISO 19115, and metadata rubric services that can be used with the THREDDS Data Server ([TDS]).
The code in this repository is used to build the [threddsIso artifacts][Maven_artifacts] ([snapshots][Maven_artifacts_snapshots]).
The threddsISO plugin is no longer distributed with the TDS by default, however, it is easy add it to your TDS (see documentation [here][ncISO_TDS_docs]).

This code is maintained and advanced by developers at NOAA/NGDC and at Unidata along with many contributions from the community of users.

A command-line utility, [ncISO], is also available ([here][ncISO]) for automating metadata analysis and ISO metadata generation for THREDDS Catalogs.

Much has changed with the `main` branch.
The repository currently produces two artifacts of interest:

1. [nciso](https://artifacts.unidata.ucar.edu/service/rest/repository/browse/unidata-all/EDS/nciso/)
2. [tds-plugin](https://artifacts.unidata.ucar.edu/service/rest/repository/browse/unidata-all/EDS/tds-plugin/)

An attempt has been made to combine the code bases of the command line utility and the TDS threddsISO plugin.
In this repository, the commandline utility code lives in the `nciso` maven module.
The TDS plugin code lives in the `tds-plugin` maven module.
Common code and resources live in the `nciso-common` maven module.
The commandline utility jar built from this repository can be downloaded from the `nciso` artifacts (they use the classifier `commandline`, e.g. `nciso-2.4.0-commandline.jar`).

The NOAA/NGDC ncISO team and the Unidata THREDDS team work closely (and with the larger ncISO/threddsISO community) to maintained and advance the project.

## Versions, Tags, and Branches

### Tags

| netCDF-Java / TDS Version     | threddsISO     | threddsISO Tag |
|:------------------------------|:---------------|:---------------|
| 5.7.1-SNAPSHOT / 5.7-SNAPSHOT | 2.4.8-SNAPSHOT |                |
| 5.7.0 / 5.6                   | 2.4.7          | **v2.4.7**     |
| 5.6.0 / 5.5                   | 2.4.6          | **v2.4.6**     |
| 5.5.3 / 5.4                   | 2.4.5          | **v2.4.5**     |
| 5.5.0 / 5.3                   | 2.4.3          | **v2.4.3**     |
| 5.4.2 / 5.2                   | 2.4.2          | **v2.4.2**     |
| 5.4.2 / 5.1                   | 2.4.1          | **v2.4.1**     |
| 5.4.2 / 5.0                   | 2.4.0          | **v2.4.0**     |
| 4.6.17                        | 2.2.15         | **v2.2.15**    |
| 4.6.16                        | 2.2.14         | **v2.2.14**    |
| 4.6.15                        | 2.2.13         | **v2.2.13**    |
| 4.6.15                        | 2.2.13         | **v2.2.13**    |
| 4.6.14                        | 2.2.12         | **v2.2.12**    |
| 4.6.12                        | 2.2.11         | **v2.2.11**    |
| 4.6.11                        | 2.2.10         | **v2.2.10**    |
| 4.6.9                         | 2.2.9          | **v2.2.9**     |
| 4.6.4                         | 2.2.8          | **v2.2.8**     |
| 4.6.1                         | 2.2.6          | **v2.2.6**     |
| 4.6.0                         | 2.2.5          | **v2.2.5**     |
| 4.5.4                         | 2.2.4          | **v2.2.4**     |
| 4.3                           | 2.2.2          | **v2.2.2**     |
| 4.2                           | 2.0.2          | **v2.0.2**     |

### Active Branches

| threddsIso branch | netCDF-Java / TDS Version         |
|:------------------|:----------------------------------|
| main              | **5.5.4-SNAPSHOT / 5.5-SNAPSHOT** |
| 2.2.x             | **4.6.17**                        |

## Notes on External Dependencies

### <a name="Note_1"></a> Note 1
[SAXON] used for XSLT (net.sf.saxon.TransformerFactoryImpl())

### <a name="Note_2"></a> Note 2
[commons-lang3] used in `nciso-common`

[ncISO]: https://github.com/NOAA-PMEL/uafnciso
[TDS]: http://www.unidata.ucar.edu/software/tds/current/
[ncISO_TDS_docs]: https://docs.unidata.ucar.edu/tds/current/userguide/iso_metadata.html

[Maven_artifacts]: https://artifacts.unidata.ucar.edu/service/rest/repository/browse/unidata-releases/EDS/
[Maven_artifacts_snapshots]: https://artifacts.unidata.ucar.edu/service/rest/repository/browse/unidata-snapshots/EDS/

[JDOM]: http://www.jdom.org/
[SAXON]: http://saxon.sourceforge.net/
[commons-lang]: http://commons.apache.org/proper/commons-lang/