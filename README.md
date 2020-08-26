# Unidata threddsISO Code Repository

This is the main threddsISO code repository.
threddsISO provides the NcML, ISO 19115, and metadata rubric services available from the THREDDS Data Server ([TDS]).
The code in this repository is used to build the [threddsIso artifacts][Maven_artifacts] ([snapshots][Maven_artifacts_snapshots]) that are distributed with the [TDS].

This code is maintained and advanced by developers at NOAA/NGDC and at Unidata along with
many contributions from the community of users.

A command-line utility, [ncISO], is also available ([here][ncISO]) for automating metadata analysis and ISO metadata generation for THREDDS Catalogs.

The NOAA/NGDC ncISO team and the Unidata THREDDS team work closely (and with the larger
ncISO/threddsISO community) to maintained and advance the project.

## Versions, Tags, and Branches

### Tags

| TDS Version        | threddsISO     | threddsISO Tag       |
|:-------------------|:---------------|:---------------------|
| TDS 5.0.0-beta     | 2.4.0          |                      |
| TDS 4.6.15         | 2.2.13         | **v2.2.13**          |
| TDS 4.6.14         | 2.2.12         | **v2.2.12**          |
| TDS 4.6.12         | 2.2.11         | **v2.2.11**          |
| TDS 4.6.11         | 2.2.10         | **v2.2.10**          |
| TDS 4.6.9          | 2.2.9          | **v2.2.9**           |
| TDS 4.6.4          | 2.2.8          | **v2.2.8**           |
| TDS 4.6.1          | 2.2.6          | **v2.2.6**           |
| TDS 4.6.0          | 2.2.5          | **v2.2.5**           |
| TDS 4.5.4          | 2.2.4          | **v2.2.4**           |
| TDS 4.3            | 2.2.2          | **v2.2.2**           |
| TDS 4.2            | 2.0.2          | **v2.0.2**           |

### Active Branches

| threddsIso branch | TDS Version            |
|:------------------|:-----------------------|
| master            | **4.6.15**             |
| threddsIsoTds5    | **5.0.0-beta**         |

## Notes on External Dependencies

### <a name="Note_1"></a> Note 1
[SAXON] used for XSLT (net.sf.saxon.TransformerFactoryImpl())

### <a name="Note_2"></a> Note 2
THREDDS uses [commons-lang3], threddsISO is still on 2 (2 or 3)

### <a name="Note_3"></a> Note 3
spring-test does not appear to be used by threddsISO (maybe hold over from ncISO)

[ncISO]: https://github.com/NOAA-PMEL/uafnciso
[TDS]: http://www.unidata.ucar.edu/software/tds/current/

[Maven_artifacts]: https://artifacts.unidata.ucar.edu/content/repositories/unidata-releases/EDS/threddsIso/
[Maven_artifacts_snapshots]: https://artifacts.unidata.ucar.edu/content/repositories/unidata-snapshots/EDS/threddsIso/

[JDOM]: http://www.jdom.org/
[SAXON]: http://saxon.sourceforge.net/
[commons-lang]: http://commons.apache.org/proper/commons-lang/