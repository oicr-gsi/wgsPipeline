# insertSizeMetrics

Workflow to run picard InsertSizeMetrics

## Overview

## Dependencies

* [picard 2.21.2](https://broadinstitute.github.io/picard/)
* [rstats 3.6](https://www.r-project.org/)


## Usage

### Cromwell
```
java -jar cromwell.jar run insertSizeMetrics.wdl --inputs inputs.json
```

### Inputs

#### Required workflow parameters:
Parameter|Value|Description
---|---|---
`inputBam`|File|Input file (bam or sam).


#### Optional workflow parameters:
Parameter|Value|Default|Description
---|---|---|---
`outputFileNamePrefix`|String|basename(inputBam,'.bam')|Output prefix to prefix output file names with.


#### Optional task parameters:
Parameter|Value|Default|Description
---|---|---|---
`collectInsertSizeMetrics.picardJar`|String|"$PICARD_ROOT/picard.jar"|The picard jar to use.
`collectInsertSizeMetrics.minimumPercent`|Float|0.5|Discard any data categories (out of FR, TANDEM, RF) when generating the histogram (Range: 0 to 1).
`collectInsertSizeMetrics.jobMemory`|Int|18|Memory (in GB) allocated for job.
`collectInsertSizeMetrics.modules`|String|"picard/2.21.2 rstats/3.6"|Environment module names and version to load (space separated) before command execution.
`collectInsertSizeMetrics.timeout`|Int|12|Maximum amount of time (in hours) the task can run for.


### Outputs

Output | Type | Description
---|---|---
`insertSizeMetrics`|File|Metrics about the insert size distribution (see https://broadinstitute.github.io/picard/picard-metric-definitions.html#InsertSizeMetrics).
`histogramReport`|File|Insert size distribution plot.


## Niassa + Cromwell

This WDL workflow is wrapped in a Niassa workflow (https://github.com/oicr-gsi/pipedev/tree/master/pipedev-niassa-cromwell-workflow) so that it can used with the Niassa metadata tracking system (https://github.com/oicr-gsi/niassa).

* Building
```
mvn clean install
```

* Testing
```
mvn clean verify \
-Djava_opts="-Xmx1g -XX:+UseG1GC -XX:+UseStringDeduplication" \
-DrunTestThreads=2 \
-DskipITs=false \
-DskipRunITs=false \
-DworkingDirectory=/path/to/tmp/ \
-DschedulingHost=niassa_oozie_host \
-DwebserviceUrl=http://niassa-url:8080 \
-DwebserviceUser=niassa_user \
-DwebservicePassword=niassa_user_password \
-Dcromwell-host=http://cromwell-url:8000
```

## Support

For support, please file an issue on the [Github project](https://github.com/oicr-gsi) or send an email to gsi@oicr.on.ca .

_Generated with wdl_doc_gen (https://github.com/oicr-gsi/wdl_doc_gen/)_
