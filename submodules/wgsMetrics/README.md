# wgsMetrics

Workflow to run picard WGSMetrics

## Overview

## Dependencies

* [picard 2.21.2](https://broadinstitute.github.io/picard/)


## Usage

### Cromwell
```
java -jar cromwell.jar run wgsMetrics.wdl --inputs inputs.json
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
`collectWGSmetrics.picardJar`|String|"$PICARD_ROOT/picard.jar"|Picard jar file to use
`collectWGSmetrics.refFasta`|String|"$HG19_ROOT/hg19_random.fa"|Path to the reference fasta
`collectWGSmetrics.metricTag`|String|"WGS"|metric tag is used as a file extension for output
`collectWGSmetrics.filter`|String|"LENIENT"|Picard filter to use
`collectWGSmetrics.jobMemory`|Int|18|memory allocated for Job
`collectWGSmetrics.coverageCap`|Int|500|Coverage cap, picard parameter
`collectWGSmetrics.modules`|String|"picard/2.21.2 hg19/p13"|Environment module names and version to load (space separated) before command execution
`collectWGSmetrics.timeout`|Int|24|Maximum amount of time (in hours) the task can run for.


### Outputs

Output | Type | Description
---|---|---
`outputWGSMetrics`|File|Metrics about the fractions of reads that pass base and mapping-quality filters as well as coverage (read-depth) levels (see https://broadinstitute.github.io/picard/picard-metric-definitions.html#CollectWgsMetrics.WgsMetrics)


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
