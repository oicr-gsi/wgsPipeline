# wgsPipeline

Wrapper workflow for the WGS Analysis Pipeline

## Overview

## Dependencies

* [bcl2fastq](https://emea.support.illumina.com/sequencing/sequencing_software/bcl2fastq-conversion-software.html)
* [fastqc 0.11.8](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
* [bwa 0.7.12](https://github.com/lh3/bwa/archive/0.7.12.tar.gz)
* [samtools 1.9](https://github.com/samtools/samtools/archive/0.1.19.tar.gz)
* [cutadapt 1.8.3](https://cutadapt.readthedocs.io/en/v1.8.3/)
* [slicer 0.3.0](https://github.com/OpenGene/slicer/archive/v0.3.0.tar.gz)
* [picard 2.21.2](https://broadinstitute.github.io/picard/command-line-overview.html)
* [python 3.6](https://www.python.org/downloads/)
* [bam-qc-metrics 0.2.5](https://github.com/oicr-gsi/bam-qc-metrics.git)
* [mosdepth 0.2.9](https://github.com/brentp/mosdepth)
* [gatk 4.1.6.0](https://gatk.broadinstitute.org)
* [gatk 3.6-0](https://gatk.broadinstitute.org)
* [python 3.7](https://www.python.org)
* [bedtools 2.27](https://bedtools.readthedocs.io/en/latest/)
* [rstats 3.6](https://www.r-project.org/)


## Usage

### Cromwell
```
java -jar cromwell.jar run wgsPipeline.wdl --inputs inputs.json
```

### Inputs

#### Required workflow parameters:
Parameter|Value|Description
---|---|---
`bwaMemMetas`|Array[bwaMemMeta]|ReadGroups for bwaMemMeta
`rawBamQCMetas`|Array[bamQCMeta]|Metadata for the raw bamQC run
`processedBamQCMetas`|Array[bamQCMeta]|Metadata for the processed bamQC run
`bcl2fastq.mismatches`|Int|Number of mismatches to allow in the barcodes (usually, 1)
`bcl2fastq.modules`|String|The modules to load when running the workflow. This should include bcl2fastq and the helper scripts.
`bwaMem.runBwaMem_bwaRef`|String|The reference genome to align the sample with by BWA
`bwaMem.runBwaMem_modules`|String|Required environment modules
`rawBamQC.bamQCMetrics_workflowVersion`|String|Workflow version string
`rawBamQC.bamQCMetrics_refSizesBed`|String|Path to human genome BED reference with chromosome sizes
`rawBamQC.bamQCMetrics_refFasta`|String|Path to human genome FASTA reference
`bamMergePreprocessing.baseQualityScoreRecalibration_knownSites`|Array[String]|Array of VCF with known polymorphic sites used to exclude regions around known polymorphisms from analysis.
`bamMergePreprocessing.indelRealign_knownAlleles`|Array[String]|Array of input VCF files with known indels.
`bamMergePreprocessing.realignerTargetCreator_knownIndels`|Array[String]|Array of input VCF files with known indels.
`bamMergePreprocessing.intervalsToParallelizeByString`|String|Comma separated list of intervals to split by (e.g. chr1,chr2,chr3+chr4).
`bamMergePreprocessing.reference`|String|Path to reference file.
`callability.normalMinCoverage`|Int|Normal must have at least this coverage to be considered callable.
`callability.tumorMinCoverage`|Int|Tumor must have at least this coverage to be considered callable.
`callability.intervalFile`|File|The interval file of regions to calculate callability on.
`processedBamQC.bamQCMetrics_workflowVersion`|String|Workflow version string
`processedBamQC.bamQCMetrics_refSizesBed`|String|Path to human genome BED reference with chromosome sizes
`processedBamQC.bamQCMetrics_refFasta`|String|Path to human genome FASTA reference


#### Optional workflow parameters:
Parameter|Value|Default|Description
---|---|---|---
`doBcl2fastq`|Boolean|true|Whether to use fastqs or bcls
`bcl2fastqMetas`|Array[bcl2fastqMeta]?|None|Samples, lanes, and runDirectory for bcl2fastq
`fastqInputs`|Array[FastqInput]?|None|Name and list of fastqs


#### Optional task parameters:
Parameter|Value|Default|Description
---|---|---|---
`bcl2fastq.process_threads`|Int|8|The number of processing threads to use when running BCL2FASTQ
`bcl2fastq.process_temporaryDirectory`|String|"."|A directory where bcl2fastq can dump massive amounts of garbage while running.
`bcl2fastq.process_memory`|Int|32|The memory for the BCL2FASTQ process in GB.
`bcl2fastq.process_ignoreMissingPositions`|Boolean|false|Flag passed to bcl2fastq, allows missing or corrupt positions files.
`bcl2fastq.process_ignoreMissingFilter`|Boolean|false|Flag passed to bcl2fastq, allows missing or corrupt filter files.
`bcl2fastq.process_ignoreMissingBcls`|Boolean|false|Flag passed to bcl2fastq, allows missing bcl files.
`bcl2fastq.process_extraOptions`|String|""|Any other options that will be passed directly to bcl2fastq.
`bcl2fastq.process_bcl2fastqJail`|String|"bcl2fastq-jail"|The name ro path of the BCL2FASTQ wrapper script executable.
`bcl2fastq.process_bcl2fastq`|String|"bcl2fastq"|The name or path of the BCL2FASTQ executable.
`bcl2fastq.basesMask`|String?|None|An Illumina bases mask string to use. If absent, the one written by the instrument will be used.
`bcl2fastq.timeout`|Int|40|The maximum number of hours this workflow can run for.
`fastQC.secondMateZip_timeout`|Int|1|Timeout, in hours, needed to override imposed limits.
`fastQC.secondMateZip_jobMemory`|Int|2|Memory allocated to this task.
`fastQC.secondMateHtml_timeout`|Int|1|Timeout, in hours, needed to override imposed limits.
`fastQC.secondMateHtml_jobMemory`|Int|2|Memory allocated to this task.
`fastQC.secondMateFastQC_modules`|String|"perl/5.28 java/8 fastqc/0.11.8"|Names and versions of required modules.
`fastQC.secondMateFastQC_timeout`|Int|20|Timeout in hours, needed to override imposed limits.
`fastQC.secondMateFastQC_jobMemory`|Int|6|Memory allocated to fastqc.
`fastQC.firstMateZip_timeout`|Int|1|Timeout, in hours, needed to override imposed limits.
`fastQC.firstMateZip_jobMemory`|Int|2|Memory allocated to this task.
`fastQC.firstMateHtml_timeout`|Int|1|Timeout, in hours, needed to override imposed limits.
`fastQC.firstMateHtml_jobMemory`|Int|2|Memory allocated to this task.
`fastQC.firstMateFastQC_modules`|String|"perl/5.28 java/8 fastqc/0.11.8"|Names and versions of required modules.
`fastQC.firstMateFastQC_timeout`|Int|20|Timeout in hours, needed to override imposed limits.
`fastQC.firstMateFastQC_jobMemory`|Int|6|Memory allocated to fastqc.
`fastQC.outputFileNamePrefix`|String|""|Output prefix, customizable. Default is the first file's basename.
`fastQC.r1Suffix`|String|"_R1"|Suffix for R1 file.
`fastQC.r2Suffix`|String|"_R2"|Suffix for R2 file.
`bwaMem.adapterTrimmingLog_timeout`|Int|48|Hours before task timeout
`bwaMem.adapterTrimmingLog_jobMemory`|Int|12|Memory allocated indexing job
`bwaMem.indexBam_timeout`|Int|48|Hours before task timeout
`bwaMem.indexBam_modules`|String|"samtools/1.9"|Modules for running indexing job
`bwaMem.indexBam_jobMemory`|Int|12|Memory allocated indexing job
`bwaMem.bamMerge_timeout`|Int|72|Hours before task timeout
`bwaMem.bamMerge_modules`|String|"samtools/1.9"|Required environment modules
`bwaMem.bamMerge_jobMemory`|Int|32|Memory allocated indexing job
`bwaMem.runBwaMem_timeout`|Int|96|Hours before task timeout
`bwaMem.runBwaMem_jobMemory`|Int|32|Memory allocated for this job
`bwaMem.runBwaMem_threads`|Int|8|Requested CPU threads
`bwaMem.runBwaMem_addParam`|String?|None|Additional BWA parameters
`bwaMem.adapterTrimming_timeout`|Int|48|Hours before task timeout
`bwaMem.adapterTrimming_jobMemory`|Int|16|Memory allocated for this job
`bwaMem.adapterTrimming_addParam`|String?|None|Additional cutadapt parameters
`bwaMem.adapterTrimming_modules`|String|"cutadapt/1.8.3"|Required environment modules
`bwaMem.slicerR2_timeout`|Int|48|Hours before task timeout
`bwaMem.slicerR2_jobMemory`|Int|16|Memory allocated for this job
`bwaMem.slicerR2_modules`|String|"slicer/0.3.0"|Required environment modules
`bwaMem.slicerR1_timeout`|Int|48|Hours before task timeout
`bwaMem.slicerR1_jobMemory`|Int|16|Memory allocated for this job
`bwaMem.slicerR1_modules`|String|"slicer/0.3.0"|Required environment modules
`bwaMem.countChunkSize_timeout`|Int|48|Hours before task timeout
`bwaMem.countChunkSize_jobMemory`|Int|16|Memory allocated for this job
`bwaMem.outputFileNamePrefix`|String|"output"|Prefix for output file
`bwaMem.numChunk`|Int|1|number of chunks to split fastq file [1, no splitting]
`bwaMem.doTrim`|Boolean|false|if true, adapters will be trimmed before alignment
`bwaMem.trimMinLength`|Int|1|minimum length of reads to keep [1]
`bwaMem.trimMinQuality`|Int|0|minimum quality of read ends to keep [0]
`bwaMem.adapter1`|String|"AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC"|adapter sequence to trim from read 1 [AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC]
`bwaMem.adapter2`|String|"AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT"|adapter sequence to trim from read 2 [AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT]
`rawBamQC.collateResults_timeout`|Int|1|hours before task timeout
`rawBamQC.collateResults_threads`|Int|4|Requested CPU threads
`rawBamQC.collateResults_jobMemory`|Int|8|Memory allocated for this job
`rawBamQC.collateResults_modules`|String|"python/3.6"|required environment modules
`rawBamQC.cumulativeDistToHistogram_timeout`|Int|1|hours before task timeout
`rawBamQC.cumulativeDistToHistogram_threads`|Int|4|Requested CPU threads
`rawBamQC.cumulativeDistToHistogram_jobMemory`|Int|8|Memory allocated for this job
`rawBamQC.cumulativeDistToHistogram_modules`|String|"python/3.6"|required environment modules
`rawBamQC.runMosdepth_timeout`|Int|4|hours before task timeout
`rawBamQC.runMosdepth_threads`|Int|4|Requested CPU threads
`rawBamQC.runMosdepth_jobMemory`|Int|16|Memory allocated for this job
`rawBamQC.runMosdepth_modules`|String|"mosdepth/0.2.9"|required environment modules
`rawBamQC.bamQCMetrics_timeout`|Int|4|hours before task timeout
`rawBamQC.bamQCMetrics_threads`|Int|4|Requested CPU threads
`rawBamQC.bamQCMetrics_jobMemory`|Int|16|Memory allocated for this job
`rawBamQC.bamQCMetrics_modules`|String|"bam-qc-metrics/0.2.5"|required environment modules
`rawBamQC.bamQCMetrics_normalInsertMax`|Int|1500|Maximum of expected insert size range
`rawBamQC.markDuplicates_timeout`|Int|4|hours before task timeout
`rawBamQC.markDuplicates_threads`|Int|4|Requested CPU threads
`rawBamQC.markDuplicates_jobMemory`|Int|16|Memory allocated for this job
`rawBamQC.markDuplicates_modules`|String|"picard/2.21.2"|required environment modules
`rawBamQC.markDuplicates_picardMaxMemMb`|Int|6000|Memory requirement in MB for running Picard JAR
`rawBamQC.markDuplicates_opticalDuplicatePixelDistance`|Int|100|Maximum offset between optical duplicate clusters
`rawBamQC.downsampleRegion_timeout`|Int|4|hours before task timeout
`rawBamQC.downsampleRegion_threads`|Int|4|Requested CPU threads
`rawBamQC.downsampleRegion_jobMemory`|Int|16|Memory allocated for this job
`rawBamQC.downsampleRegion_modules`|String|"samtools/1.9"|required environment modules
`rawBamQC.downsample_timeout`|Int|4|hours before task timeout
`rawBamQC.downsample_threads`|Int|4|Requested CPU threads
`rawBamQC.downsample_jobMemory`|Int|16|Memory allocated for this job
`rawBamQC.downsample_modules`|String|"samtools/1.9"|required environment modules
`rawBamQC.downsample_randomSeed`|Int|42|Random seed for pre-downsampling (if any)
`rawBamQC.downsample_downsampleSuffix`|String|"downsampled.bam"|Suffix for output file
`rawBamQC.findDownsampleParamsMarkDup_timeout`|Int|4|hours before task timeout
`rawBamQC.findDownsampleParamsMarkDup_threads`|Int|4|Requested CPU threads
`rawBamQC.findDownsampleParamsMarkDup_jobMemory`|Int|16|Memory allocated for this job
`rawBamQC.findDownsampleParamsMarkDup_modules`|String|"python/3.6"|required environment modules
`rawBamQC.findDownsampleParamsMarkDup_customRegions`|String|""|Custom downsample regions; overrides chromosome and interval parameters
`rawBamQC.findDownsampleParamsMarkDup_intervalStart`|Int|100000|Start of interval in each chromosome, for very large BAMs
`rawBamQC.findDownsampleParamsMarkDup_baseInterval`|Int|15000|Base width of interval in each chromosome, for very large BAMs
`rawBamQC.findDownsampleParamsMarkDup_chromosomes`|Array[String]|["chr12", "chr13", "chrXII", "chrXIII"]|Array of chromosome identifiers for downsampled subset
`rawBamQC.findDownsampleParamsMarkDup_threshold`|Int|10000000|Minimum number of reads to conduct downsampling
`rawBamQC.findDownsampleParams_timeout`|Int|4|hours before task timeout
`rawBamQC.findDownsampleParams_threads`|Int|4|Requested CPU threads
`rawBamQC.findDownsampleParams_jobMemory`|Int|16|Memory allocated for this job
`rawBamQC.findDownsampleParams_modules`|String|"python/3.6"|required environment modules
`rawBamQC.findDownsampleParams_preDSMultiplier`|Float|1.5|Determines target size for pre-downsampled set (if any). Must have (preDSMultiplier) < (minReadsRelative).
`rawBamQC.findDownsampleParams_precision`|Int|8|Number of decimal places in fraction for pre-downsampling
`rawBamQC.findDownsampleParams_minReadsRelative`|Int|2|Minimum value of (inputReads)/(targetReads) to allow pre-downsampling
`rawBamQC.findDownsampleParams_minReadsAbsolute`|Int|10000|Minimum value of targetReads to allow pre-downsampling
`rawBamQC.findDownsampleParams_targetReads`|Int|100000|Desired number of reads in downsampled output
`rawBamQC.indexBamFile_timeout`|Int|4|hours before task timeout
`rawBamQC.indexBamFile_threads`|Int|4|Requested CPU threads
`rawBamQC.indexBamFile_jobMemory`|Int|16|Memory allocated for this job
`rawBamQC.indexBamFile_modules`|String|"samtools/1.9"|required environment modules
`rawBamQC.countInputReads_timeout`|Int|4|hours before task timeout
`rawBamQC.countInputReads_threads`|Int|4|Requested CPU threads
`rawBamQC.countInputReads_jobMemory`|Int|16|Memory allocated for this job
`rawBamQC.countInputReads_modules`|String|"samtools/1.9"|required environment modules
`rawBamQC.updateMetadata_timeout`|Int|4|hours before task timeout
`rawBamQC.updateMetadata_threads`|Int|4|Requested CPU threads
`rawBamQC.updateMetadata_jobMemory`|Int|16|Memory allocated for this job
`rawBamQC.updateMetadata_modules`|String|"python/3.6"|required environment modules
`rawBamQC.filter_timeout`|Int|4|hours before task timeout
`rawBamQC.filter_threads`|Int|4|Requested CPU threads
`rawBamQC.filter_jobMemory`|Int|16|Memory allocated for this job
`rawBamQC.filter_modules`|String|"samtools/1.9"|required environment modules
`rawBamQC.filter_minQuality`|Int|30|Minimum alignment quality to pass filter
`rawBamQC.outputFileNamePrefix`|String|"bamQC"|Prefix for output files
`bamMergePreprocessing.mergeSplitByIntervalBams_modules`|String|"gatk/4.1.6.0"|Environment module name and version to load (space separated) before command execution.
`bamMergePreprocessing.mergeSplitByIntervalBams_timeout`|Int|6|Maximum amount of time (in hours) the task can run for.
`bamMergePreprocessing.mergeSplitByIntervalBams_cores`|Int|1|The number of cores to allocate to the job.
`bamMergePreprocessing.mergeSplitByIntervalBams_overhead`|Int|6|Java overhead memory (in GB). jobMemory - overhead == java Xmx/heap memory.
`bamMergePreprocessing.mergeSplitByIntervalBams_jobMemory`|Int|24|Memory allocated to job (in GB).
`bamMergePreprocessing.mergeSplitByIntervalBams_additionalParams`|String?|None|Additional parameters to pass to GATK MergeSamFiles.
`bamMergePreprocessing.collectFilesBySample_modules`|String|"python/3.7"|Environment module name and version to load (space separated) before command execution.
`bamMergePreprocessing.collectFilesBySample_timeout`|Int|1|Maximum amount of time (in hours) the task can run for.
`bamMergePreprocessing.collectFilesBySample_cores`|Int|1|The number of cores to allocate to the job.
`bamMergePreprocessing.collectFilesBySample_jobMemory`|Int|1|Memory allocated to job (in GB).
`bamMergePreprocessing.applyBaseQualityScoreRecalibration_modules`|String|"gatk/4.1.6.0"|Environment module name and version to load (space separated) before command execution.
`bamMergePreprocessing.applyBaseQualityScoreRecalibration_timeout`|Int|6|Maximum amount of time (in hours) the task can run for.
`bamMergePreprocessing.applyBaseQualityScoreRecalibration_cores`|Int|1|The number of cores to allocate to the job.
`bamMergePreprocessing.applyBaseQualityScoreRecalibration_overhead`|Int|6|Java overhead memory (in GB). jobMemory - overhead == java Xmx/heap memory.
`bamMergePreprocessing.applyBaseQualityScoreRecalibration_jobMemory`|Int|24|Memory allocated to job (in GB).
`bamMergePreprocessing.applyBaseQualityScoreRecalibration_additionalParams`|String?|None|Additional parameters to pass to GATK ApplyBQSR.
`bamMergePreprocessing.applyBaseQualityScoreRecalibration_suffix`|String|".recalibrated"|Suffix to use for recalibrated bams.
`bamMergePreprocessing.analyzeCovariates_modules`|String|"gatk/4.1.6.0"|Environment module name and version to load (space separated) before command execution.
`bamMergePreprocessing.analyzeCovariates_timeout`|Int|6|Maximum amount of time (in hours) the task can run for.
`bamMergePreprocessing.analyzeCovariates_cores`|Int|1|The number of cores to allocate to the job.
`bamMergePreprocessing.analyzeCovariates_overhead`|Int|6|Java overhead memory (in GB). jobMemory - overhead == java Xmx/heap memory.
`bamMergePreprocessing.analyzeCovariates_jobMemory`|Int|24|Memory allocated to job (in GB).
`bamMergePreprocessing.analyzeCovariates_outputFileName`|String|"gatk.recalibration.pdf"|Recalibration report file name.
`bamMergePreprocessing.analyzeCovariates_additionalParams`|String?|None|Additional parameters to pass to GATK AnalyzeCovariates
`bamMergePreprocessing.gatherBQSRReports_modules`|String|"gatk/4.1.6.0"|Environment module name and version to load (space separated) before command execution.
`bamMergePreprocessing.gatherBQSRReports_timeout`|Int|6|Maximum amount of time (in hours) the task can run for.
`bamMergePreprocessing.gatherBQSRReports_cores`|Int|1|The number of cores to allocate to the job.
`bamMergePreprocessing.gatherBQSRReports_overhead`|Int|6|Java overhead memory (in GB). jobMemory - overhead == java Xmx/heap memory.
`bamMergePreprocessing.gatherBQSRReports_jobMemory`|Int|24|Memory allocated to job (in GB).
`bamMergePreprocessing.gatherBQSRReports_outputFileName`|String|"gatk.recalibration.csv"|Recalibration table file name.
`bamMergePreprocessing.gatherBQSRReports_additionalParams`|String?|None|Additional parameters to pass to GATK GatherBQSRReports.
`bamMergePreprocessing.baseQualityScoreRecalibration_modules`|String|"gatk/4.1.6.0"|Environment module name and version to load (space separated) before command execution.
`bamMergePreprocessing.baseQualityScoreRecalibration_timeout`|Int|6|Maximum amount of time (in hours) the task can run for.
`bamMergePreprocessing.baseQualityScoreRecalibration_cores`|Int|1|The number of cores to allocate to the job.
`bamMergePreprocessing.baseQualityScoreRecalibration_overhead`|Int|6|Java overhead memory (in GB). jobMemory - overhead == java Xmx/heap memory.
`bamMergePreprocessing.baseQualityScoreRecalibration_jobMemory`|Int|24|Memory allocated to job (in GB).
`bamMergePreprocessing.baseQualityScoreRecalibration_outputFileName`|String|"gatk.recalibration.csv"|Recalibration table file name.
`bamMergePreprocessing.baseQualityScoreRecalibration_additionalParams`|String?|None|Additional parameters to pass to GATK BaseRecalibrator.
`bamMergePreprocessing.baseQualityScoreRecalibration_intervals`|Array[String]|[]|One or more genomic intervals over which to operate.
`bamMergePreprocessing.indelRealign_gatkJar`|String|"$GATK_ROOT/GenomeAnalysisTK.jar"|Path to GATK jar.
`bamMergePreprocessing.indelRealign_modules`|String|"python/3.7 gatk/3.6-0"|Environment module name and version to load (space separated) before command execution.
`bamMergePreprocessing.indelRealign_timeout`|Int|6|Maximum amount of time (in hours) the task can run for.
`bamMergePreprocessing.indelRealign_cores`|Int|1|The number of cores to allocate to the job.
`bamMergePreprocessing.indelRealign_overhead`|Int|6|Java overhead memory (in GB). jobMemory - overhead == java Xmx/heap memory.
`bamMergePreprocessing.indelRealign_jobMemory`|Int|24|Memory allocated to job (in GB).
`bamMergePreprocessing.indelRealign_additionalParams`|String?|None|Additional parameters to pass to GATK IndelRealigner.
`bamMergePreprocessing.realignerTargetCreator_gatkJar`|String|"$GATK_ROOT/GenomeAnalysisTK.jar"|Path to GATK jar.
`bamMergePreprocessing.realignerTargetCreator_modules`|String|"gatk/3.6-0"|Environment module name and version to load (space separated) before command execution.
`bamMergePreprocessing.realignerTargetCreator_timeout`|Int|6|Maximum amount of time (in hours) the task can run for.
`bamMergePreprocessing.realignerTargetCreator_cores`|Int|1|The number of cores to allocate to the job.
`bamMergePreprocessing.realignerTargetCreator_overhead`|Int|6|Java overhead memory (in GB). jobMemory - overhead == java Xmx/heap memory.
`bamMergePreprocessing.realignerTargetCreator_jobMemory`|Int|24|Memory allocated to job (in GB).
`bamMergePreprocessing.realignerTargetCreator_additionalParams`|String?|None|Additional parameters to pass to GATK RealignerTargetCreator.
`bamMergePreprocessing.realignerTargetCreator_downsamplingType`|String?|None|Type of read downsampling to employ at a given locus (NONE|ALL_READS|BY_SAMPLE).
`bamMergePreprocessing.preprocessBam_defaultRuntimeAttributes`|DefaultRuntimeAttributes|{"memory": 24, "overhead": 6, "cores": 1, "timeout": 6, "modules": "samtools/1.9 gatk/4.1.6.0"}|Default runtime attributes (memory in GB, overhead in GB, cores in cpu count, timeout in hours, modules are environment modules to load before the task executes).
`bamMergePreprocessing.preprocessBam_splitNCigarReadsAdditionalParams`|String?|None|Additional parameters to pass to GATK SplitNCigarReads.
`bamMergePreprocessing.preprocessBam_readFilters`|Array[String]|[]|SplitNCigarReads read filters
`bamMergePreprocessing.preprocessBam_refactorCigarString`|Boolean|false|SplitNCigarReads refactor cigar string?
`bamMergePreprocessing.preprocessBam_splitNCigarReadsSuffix`|String|".split"|Suffix to use for SplitNCigarReads bams.
`bamMergePreprocessing.preprocessBam_markDuplicatesAdditionalParams`|String?|None|Additional parameters to pass to GATK MarkDuplicates.
`bamMergePreprocessing.preprocessBam_opticalDuplicatePixelDistance`|Int|100|MarkDuplicates optical distance.
`bamMergePreprocessing.preprocessBam_removeDuplicates`|Boolean|false|MarkDuplicates remove duplicates?
`bamMergePreprocessing.preprocessBam_markDuplicatesSuffix`|String|".deduped"|Suffix to use for duplicate marked bams.
`bamMergePreprocessing.preprocessBam_filterAdditionalParams`|String?|None|Additional parameters to pass to samtools.
`bamMergePreprocessing.preprocessBam_minMapQuality`|Int?|None|Samtools minimum mapping quality filter to apply.
`bamMergePreprocessing.preprocessBam_filterFlags`|Int|260|Samtools filter flags to apply.
`bamMergePreprocessing.preprocessBam_filterSuffix`|String|".filter"|Suffix to use for filtered bams.
`bamMergePreprocessing.preprocessBam_temporaryWorkingDir`|String|""|Where to write out intermediary bam files. Only the final preprocessed bam will be written to task working directory if this is set to local tmp.
`bamMergePreprocessing.splitStringToArray_modules`|String|"python/3.7"|Environment module name and version to load (space separated) before command execution.
`bamMergePreprocessing.splitStringToArray_timeout`|Int|1|Maximum amount of time (in hours) the task can run for.
`bamMergePreprocessing.splitStringToArray_cores`|Int|1|The number of cores to allocate to the job.
`bamMergePreprocessing.splitStringToArray_jobMemory`|Int|1|Memory allocated to job (in GB).
`bamMergePreprocessing.splitStringToArray_recordSeparator`|String|"+"|Interval interval group separator - this can be used to combine multiple intervals into one group.
`bamMergePreprocessing.splitStringToArray_lineSeparator`|String|","|Interval group separator - these are the intervals to split by.
`bamMergePreprocessing.doFilter`|Boolean|true|Enable/disable Samtools filtering.
`bamMergePreprocessing.doMarkDuplicates`|Boolean|true|Enable/disable GATK4 MarkDuplicates.
`bamMergePreprocessing.doSplitNCigarReads`|Boolean|false|Enable/disable GATK4 SplitNCigarReads.
`bamMergePreprocessing.doIndelRealignment`|Boolean|true|Enable/disable GATK3 RealignerTargetCreator + IndelRealigner.
`bamMergePreprocessing.doBqsr`|Boolean|true|Enable/disable GATK4 BQSR.
`bamMergePreprocessing.preprocessingBamRuntimeAttributes`|Array[RuntimeAttributes]|[]|Interval specific runtime attributes to use as overrides for the defaults.
`bamMergePreprocessing.applyBaseQualityScoreRecalibration.outputFileName`|String|basename(bam,".bam")|Output files will be prefixed with this.
`callability.calculateCallability_modules`|String|"mosdepth/0.2.9 bedtools/2.27 python/3.7"|Environment module name and version to load (space separated) before command execution.
`callability.calculateCallability_timeout`|Int|12|Maximum amount of time (in hours) the task can run for.
`callability.calculateCallability_cores`|Int|1|The number of cores to allocate to the job.
`callability.calculateCallability_jobMemory`|Int|8|Memory allocated to job (in GB).
`callability.calculateCallability_outputFileName`|String|"callability_metrics.json"|Output callability metrics file name.
`callability.calculateCallability_outputFileNamePrefix`|String?|None|Output files will be prefixed with this.
`callability.calculateCallability_threads`|Int|4|The number of threads to run mosdepth with.
`insertSizeMetrics.collectInsertSizeMetrics_timeout`|Int|12|Maximum amount of time (in hours) the task can run for.
`insertSizeMetrics.collectInsertSizeMetrics_modules`|String|"picard/2.21.2 rstats/3.6"|Environment module names and version to load (space separated) before command execution.
`insertSizeMetrics.collectInsertSizeMetrics_jobMemory`|Int|18|Memory (in GB) allocated for job.
`insertSizeMetrics.collectInsertSizeMetrics_minimumPercent`|Float|0.5|Discard any data categories (out of FR, TANDEM, RF) when generating the histogram (Range: 0 to 1).
`insertSizeMetrics.collectInsertSizeMetrics_picardJar`|String|"$PICARD_ROOT/picard.jar"|The picard jar to use.
`wgsMetrics.collectWGSmetrics_timeout`|Int|24|Maximum amount of time (in hours) the task can run for.
`wgsMetrics.collectWGSmetrics_modules`|String|"picard/2.21.2 hg19/p13"|Environment module names and version to load (space separated) before command execution
`wgsMetrics.collectWGSmetrics_coverageCap`|Int|500|Coverage cap, picard parameter
`wgsMetrics.collectWGSmetrics_jobMemory`|Int|18|memory allocated for Job
`wgsMetrics.collectWGSmetrics_filter`|String|"LENIENT"|Picard filter to use
`wgsMetrics.collectWGSmetrics_metricTag`|String|"WGS"|metric tag is used as a file extension for output
`wgsMetrics.collectWGSmetrics_refFasta`|String|"$HG19_ROOT/hg19_random.fa"|Path to the reference fasta
`wgsMetrics.collectWGSmetrics_picardJar`|String|"$PICARD_ROOT/picard.jar"|Picard jar file to use
`processedBamQC.collateResults_timeout`|Int|1|hours before task timeout
`processedBamQC.collateResults_threads`|Int|4|Requested CPU threads
`processedBamQC.collateResults_jobMemory`|Int|8|Memory allocated for this job
`processedBamQC.collateResults_modules`|String|"python/3.6"|required environment modules
`processedBamQC.cumulativeDistToHistogram_timeout`|Int|1|hours before task timeout
`processedBamQC.cumulativeDistToHistogram_threads`|Int|4|Requested CPU threads
`processedBamQC.cumulativeDistToHistogram_jobMemory`|Int|8|Memory allocated for this job
`processedBamQC.cumulativeDistToHistogram_modules`|String|"python/3.6"|required environment modules
`processedBamQC.runMosdepth_timeout`|Int|4|hours before task timeout
`processedBamQC.runMosdepth_threads`|Int|4|Requested CPU threads
`processedBamQC.runMosdepth_jobMemory`|Int|16|Memory allocated for this job
`processedBamQC.runMosdepth_modules`|String|"mosdepth/0.2.9"|required environment modules
`processedBamQC.bamQCMetrics_timeout`|Int|4|hours before task timeout
`processedBamQC.bamQCMetrics_threads`|Int|4|Requested CPU threads
`processedBamQC.bamQCMetrics_jobMemory`|Int|16|Memory allocated for this job
`processedBamQC.bamQCMetrics_modules`|String|"bam-qc-metrics/0.2.5"|required environment modules
`processedBamQC.bamQCMetrics_normalInsertMax`|Int|1500|Maximum of expected insert size range
`processedBamQC.markDuplicates_timeout`|Int|4|hours before task timeout
`processedBamQC.markDuplicates_threads`|Int|4|Requested CPU threads
`processedBamQC.markDuplicates_jobMemory`|Int|16|Memory allocated for this job
`processedBamQC.markDuplicates_modules`|String|"picard/2.21.2"|required environment modules
`processedBamQC.markDuplicates_picardMaxMemMb`|Int|6000|Memory requirement in MB for running Picard JAR
`processedBamQC.markDuplicates_opticalDuplicatePixelDistance`|Int|100|Maximum offset between optical duplicate clusters
`processedBamQC.downsampleRegion_timeout`|Int|4|hours before task timeout
`processedBamQC.downsampleRegion_threads`|Int|4|Requested CPU threads
`processedBamQC.downsampleRegion_jobMemory`|Int|16|Memory allocated for this job
`processedBamQC.downsampleRegion_modules`|String|"samtools/1.9"|required environment modules
`processedBamQC.downsample_timeout`|Int|4|hours before task timeout
`processedBamQC.downsample_threads`|Int|4|Requested CPU threads
`processedBamQC.downsample_jobMemory`|Int|16|Memory allocated for this job
`processedBamQC.downsample_modules`|String|"samtools/1.9"|required environment modules
`processedBamQC.downsample_randomSeed`|Int|42|Random seed for pre-downsampling (if any)
`processedBamQC.downsample_downsampleSuffix`|String|"downsampled.bam"|Suffix for output file
`processedBamQC.findDownsampleParamsMarkDup_timeout`|Int|4|hours before task timeout
`processedBamQC.findDownsampleParamsMarkDup_threads`|Int|4|Requested CPU threads
`processedBamQC.findDownsampleParamsMarkDup_jobMemory`|Int|16|Memory allocated for this job
`processedBamQC.findDownsampleParamsMarkDup_modules`|String|"python/3.6"|required environment modules
`processedBamQC.findDownsampleParamsMarkDup_customRegions`|String|""|Custom downsample regions; overrides chromosome and interval parameters
`processedBamQC.findDownsampleParamsMarkDup_intervalStart`|Int|100000|Start of interval in each chromosome, for very large BAMs
`processedBamQC.findDownsampleParamsMarkDup_baseInterval`|Int|15000|Base width of interval in each chromosome, for very large BAMs
`processedBamQC.findDownsampleParamsMarkDup_chromosomes`|Array[String]|["chr12", "chr13", "chrXII", "chrXIII"]|Array of chromosome identifiers for downsampled subset
`processedBamQC.findDownsampleParamsMarkDup_threshold`|Int|10000000|Minimum number of reads to conduct downsampling
`processedBamQC.findDownsampleParams_timeout`|Int|4|hours before task timeout
`processedBamQC.findDownsampleParams_threads`|Int|4|Requested CPU threads
`processedBamQC.findDownsampleParams_jobMemory`|Int|16|Memory allocated for this job
`processedBamQC.findDownsampleParams_modules`|String|"python/3.6"|required environment modules
`processedBamQC.findDownsampleParams_preDSMultiplier`|Float|1.5|Determines target size for pre-downsampled set (if any). Must have (preDSMultiplier) < (minReadsRelative).
`processedBamQC.findDownsampleParams_precision`|Int|8|Number of decimal places in fraction for pre-downsampling
`processedBamQC.findDownsampleParams_minReadsRelative`|Int|2|Minimum value of (inputReads)/(targetReads) to allow pre-downsampling
`processedBamQC.findDownsampleParams_minReadsAbsolute`|Int|10000|Minimum value of targetReads to allow pre-downsampling
`processedBamQC.findDownsampleParams_targetReads`|Int|100000|Desired number of reads in downsampled output
`processedBamQC.indexBamFile_timeout`|Int|4|hours before task timeout
`processedBamQC.indexBamFile_threads`|Int|4|Requested CPU threads
`processedBamQC.indexBamFile_jobMemory`|Int|16|Memory allocated for this job
`processedBamQC.indexBamFile_modules`|String|"samtools/1.9"|required environment modules
`processedBamQC.countInputReads_timeout`|Int|4|hours before task timeout
`processedBamQC.countInputReads_threads`|Int|4|Requested CPU threads
`processedBamQC.countInputReads_jobMemory`|Int|16|Memory allocated for this job
`processedBamQC.countInputReads_modules`|String|"samtools/1.9"|required environment modules
`processedBamQC.updateMetadata_timeout`|Int|4|hours before task timeout
`processedBamQC.updateMetadata_threads`|Int|4|Requested CPU threads
`processedBamQC.updateMetadata_jobMemory`|Int|16|Memory allocated for this job
`processedBamQC.updateMetadata_modules`|String|"python/3.6"|required environment modules
`processedBamQC.filter_timeout`|Int|4|hours before task timeout
`processedBamQC.filter_threads`|Int|4|Requested CPU threads
`processedBamQC.filter_jobMemory`|Int|16|Memory allocated for this job
`processedBamQC.filter_modules`|String|"samtools/1.9"|required environment modules
`processedBamQC.filter_minQuality`|Int|30|Minimum alignment quality to pass filter
`processedBamQC.outputFileNamePrefix`|String|"bamQC"|Prefix for output files


### Outputs

Output | Type | Description
---|---|---
`fastQC_html_report_R1`|Array[File?]|HTML report for the first mate fastq file.
`fastQC_zip_bundle_R1`|Array[File?]|zipped report from FastQC for the first mate reads.
`fastQC_html_report_R2`|Array[File?]|HTML report for read second mate fastq file.
`fastQC_zip_bundle_R2`|Array[File?]|zipped report from FastQC for the second mate reads.
`bwaMem_log`|Array[File?]|a summary log file for adapter trimming.
`bwaMem_cutAdaptAllLogs`|Array[File?]|a file containing all logs for adapter trimming for each fastq chunk.
`rawBamQC_result`|Array[File]|JSON file of collated results.
`bamMergePreprocessing_recalibrationReport`|File?|Recalibration report pdf (if BQSR enabled).
`bamMergePreprocessing_recalibrationTable`|File?|Recalibration csv that was used by BQSR (if BQSR enabled).
`callability_callabilityMetrics`|File|Json file with pass, fail and callability percent (# of pass bases / # total bases).
`insertSizeMetrics_insertSizeMetrics`|Array[File]|Metrics about the insert size distribution (see https://broadinstitute.github.io/picard/picard-metric-definitions.html#InsertSizeMetrics).
`insertSizeMetrics_histogramReport`|Array[File]|Insert size distribution plot.
`wgsMetrics_outputWGSMetrics`|Array[File]|Metrics about the fractions of reads that pass base and mapping-quality filters as well as coverage (read-depth) levels (see https://broadinstitute.github.io/picard/picard-metric-definitions.html#CollectWgsMetrics.WgsMetrics).
`processedBamQC_result`|Array[File]|JSON file of collated results.


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

_Generated with generate-markdown-readme (https://github.com/oicr-gsi/gsi-wdl-tools/)_
