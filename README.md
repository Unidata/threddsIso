<a href="https://scan.coverity.com/projects/4054">
  <img alt="Coverity Scan Build Status"
       src="https://scan.coverity.com/projects/4054/badge.svg"/>
</a>

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
| TDS 4.6.0          | 2.2.5          | **2.2.5.tds.4.6.0**  |
| TDS 4.5.4          | 2.2.4          | **2.2.4.tds.4.5.4**  |
| TDS 4.3            | 2.2.2          | **2.2.2.tds.4.3**    |
| TDS 4.2            | 2.0.2          | **2.0.2.tds.4.2**    |

### Active Branches

| threddsIso branch | TDS Version            |
|:------------------|:-----------------------|
| master            | **4.6.1-SNAPSHOT** |


## External Dependencies

### Updating Dependency Versions to work with TDS 4.5.4

| name                                   |    TDS ver |   avail | Uni ncISO  |  ncISO ver |
| :-------------------------------       |    ------: | ------: | ------:    |   -------: |
| edu.ucar:cdm                           |      4.5.4 |         | 4.4.0 (+<) |        4.2 |
| - org.apache.httpcomponents:httpclient |          - |         | -          |        3.1 |
| edu.ucar:thredds                       |      4.5.4 |         | 4.4.0 (+<) |        4.2 |
|                                        |            |         |            |            |
| org.jdom:jdom2                  [[Note 1](#Note_1)] |   2.0.4 |         | -          |          - |
| org.jdom:jdom (aka jdom-legacy) [[Note 1](#Note_1)] |   1.1.3 |         | 1.1.3      |        1.1 |
| net.sf.saxon:saxon-he  [[Note 2](#Note_2)] | 8.7 (ncISO ver) | 9.6.0.3 | 8.7 (+<)   |    9.3.0.5 |
| jaxen:jaxen        [[Note 3](#Note_3)] |          - |   1.1.6 | -          |      1.1.1 |
|                                        |            |         |            |            |
|                                        |            |         |            |            |
| org.slf4j:slf4j-api                    |      1.7.7 |   1.7.7 | 1.7.5 (<+) |      1.5.6 |
| log4j:log4j                            |          - |     2.1 | -          |     1.2.15 |
| org.apache:commons-logging             |          - |       ? | -          |      1.1.1 |
|                                        |            |         |            |            |
| org.apache:commons-lang  [[Note 4](#Note_4)]|     - (ncISO ver) |     2.6 | - (+<)     |        2.3 |
| org.apache:commons-lang3 [[Note 4](#Note_4)]| 3.3.2  |   3.3.2 | -          |          - |
|                                        |            |         |            |            |
| commons-code:commons-codec             |          - |    1.10 | -          |        1.5 |
|                                        |            |         |            |            |
| org.springframework:spring-core        |     3.2.12 |         | 3.2.2 (+<) |      2.5.6 |
| org.springframework:spring-context     |     3.2.12 |         | -          |          - |
| org.springframework:spring-beans       |     3.2.12 |         | -          |          - |
| org.springframework:spring-webmvc      |     3.2.12 |  3.2.12 | 3.2.2 (+<) |      2.5.6 |
| org.springframework:security           |      3.2.5 |   3.2.5 | -          |          - |
|                                        |            |         |            |            |
| javax.servlet:javax.servlet-api        |      3.1.0 |   3.1.0 | 3.0.1 (+<) | tomcat 5.5 |
| javax.servlet:jstl                     |        1.2 |       - | 1.2 (rm)   |          - |
|                                        |            |         |            |            |
| junit:junit                            |  4.11 (+>) |    4.12 | 4.11 (+<)  |        4.4 |
| org.springframework:spring-test [[Note 5](#Note_5)] |          - |         | -          |  2.5.6 (?) |

####  <a name="Note_1"></a>Note 1
THREDDS uses [JDOM] 2, threddsISO uses [JDOM] 1 (TODO upgrade threddsISO usage)

#### <a name="Note_2"></a> Note 2
[SAXON] used for XSLT (net.sf.saxon.TransformerFactoryImpl())

#### <a name="Note_3"></a> Note 3
[JAXEN] no longer needed? Looks like using JDOM XPath?

#### <a name="Note_4"></a> Note 4
THREDDS uses [commons-lang3], threddsISO is still on 2 (2 or 3)

#### <a name="Note_5"></a> Note 5
spring-test does not appear to be used by threddsISO (maybe hold over from ncISO)

* To Do

- Convert from JDOM 1.x to JDOM 2.x (see the [migration guide](https://github.com/hunterhacker/jdom/wiki/JDOM2-Migration-Issues))

[ncISO]: http://www.ngdc.noaa.gov/eds/tds/
[TDS]: http://www.unidata.ucar.edu/software/thredds/current/tds

[Maven_artifacts]: https://artifacts.unidata.ucar.edu/content/repositories/unidata-releases/EDS/threddsIso/
[Maven_artifacts_snapshots]: https://artifacts.unidata.ucar.edu/content/repositories/unidata-snapshots/EDS/threddsIso/

[JDOM]: http://www.jdom.org/
[SAXON]: http://saxon.sourceforge.net/
[JAXEN]: http://jaxen.codehaus.org/
[commons-lang]: http://commons.apache.org/proper/commons-lang/
