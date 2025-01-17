version 1.0

workflow bamQC {

    input {
    Int collateResults_timeout = 1
    Int collateResults_threads = 4
    Int collateResults_jobMemory = 8
    String collateResults_modules = "python/3.6"
    Int cumulativeDistToHistogram_timeout = 1
    Int cumulativeDistToHistogram_threads = 4
    Int cumulativeDistToHistogram_jobMemory = 8
    String cumulativeDistToHistogram_modules = "python/3.6"
    Int runMosdepth_timeout = 4
    Int runMosdepth_threads = 4
    Int runMosdepth_jobMemory = 16
    String runMosdepth_modules = "mosdepth/0.2.9"
    Int bamQCMetrics_timeout = 4
    Int bamQCMetrics_threads = 4
    Int bamQCMetrics_jobMemory = 16
    String bamQCMetrics_modules = "bam-qc-metrics/0.2.5"
    Int bamQCMetrics_normalInsertMax = 1500
    String bamQCMetrics_workflowVersion
    String bamQCMetrics_refSizesBed
    String bamQCMetrics_refFasta
    Int markDuplicates_timeout = 4
    Int markDuplicates_threads = 4
    Int markDuplicates_jobMemory = 16
    String markDuplicates_modules = "picard/2.21.2"
    Int markDuplicates_picardMaxMemMb = 6000
    Int markDuplicates_opticalDuplicatePixelDistance = 100
    Int downsampleRegion_timeout = 4
    Int downsampleRegion_threads = 4
    Int downsampleRegion_jobMemory = 16
    String downsampleRegion_modules = "samtools/1.9"
    Int downsample_timeout = 4
    Int downsample_threads = 4
    Int downsample_jobMemory = 16
    String downsample_modules = "samtools/1.9"
    Int downsample_randomSeed = 42
    String downsample_downsampleSuffix = "downsampled.bam"
    Int findDownsampleParamsMarkDup_timeout = 4
    Int findDownsampleParamsMarkDup_threads = 4
    Int findDownsampleParamsMarkDup_jobMemory = 16
    String findDownsampleParamsMarkDup_modules = "python/3.6"
    String findDownsampleParamsMarkDup_customRegions = ""
    Int findDownsampleParamsMarkDup_intervalStart = 100000
    Int findDownsampleParamsMarkDup_baseInterval = 15000
    Array[String] findDownsampleParamsMarkDup_chromosomes = ["chr12", "chr13", "chrXII", "chrXIII"]
    Int findDownsampleParamsMarkDup_threshold = 10000000
    Int findDownsampleParams_timeout = 4
    Int findDownsampleParams_threads = 4
    Int findDownsampleParams_jobMemory = 16
    String findDownsampleParams_modules = "python/3.6"
    Float findDownsampleParams_preDSMultiplier = 1.5
    Int findDownsampleParams_precision = 8
    Int findDownsampleParams_minReadsRelative = 2
    Int findDownsampleParams_minReadsAbsolute = 10000
    Int findDownsampleParams_targetReads = 100000
    Int indexBamFile_timeout = 4
    Int indexBamFile_threads = 4
    Int indexBamFile_jobMemory = 16
    String indexBamFile_modules = "samtools/1.9"
    Int countInputReads_timeout = 4
    Int countInputReads_threads = 4
    Int countInputReads_jobMemory = 16
    String countInputReads_modules = "samtools/1.9"
    Int updateMetadata_timeout = 4
    Int updateMetadata_threads = 4
    Int updateMetadata_jobMemory = 16
    String updateMetadata_modules = "python/3.6"
    Int filter_timeout = 4
    Int filter_threads = 4
    Int filter_jobMemory = 16
    String filter_modules = "samtools/1.9"
    Int filter_minQuality = 30
    File bamFile
    Map[String, String] metadata
    String outputFileNamePrefix = "bamQC"
    }

    parameter_meta {
        collateResults_timeout: "hours before task timeout"
        collateResults_threads: "Requested CPU threads"
        collateResults_jobMemory: "Memory allocated for this job"
        collateResults_modules: "required environment modules"
        cumulativeDistToHistogram_timeout: "hours before task timeout"
        cumulativeDistToHistogram_threads: "Requested CPU threads"
        cumulativeDistToHistogram_jobMemory: "Memory allocated for this job"
        cumulativeDistToHistogram_modules: "required environment modules"
        runMosdepth_timeout: "hours before task timeout"
        runMosdepth_threads: "Requested CPU threads"
        runMosdepth_jobMemory: "Memory allocated for this job"
        runMosdepth_modules: "required environment modules"
        bamQCMetrics_timeout: "hours before task timeout"
        bamQCMetrics_threads: "Requested CPU threads"
        bamQCMetrics_jobMemory: "Memory allocated for this job"
        bamQCMetrics_modules: "required environment modules"
        bamQCMetrics_normalInsertMax: "Maximum of expected insert size range"
        bamQCMetrics_workflowVersion: "Workflow version string"
        bamQCMetrics_refSizesBed: "Path to human genome BED reference with chromosome sizes"
        bamQCMetrics_refFasta: "Path to human genome FASTA reference"
        markDuplicates_timeout: "hours before task timeout"
        markDuplicates_threads: "Requested CPU threads"
        markDuplicates_jobMemory: "Memory allocated for this job"
        markDuplicates_modules: "required environment modules"
        markDuplicates_picardMaxMemMb: "Memory requirement in MB for running Picard JAR"
        markDuplicates_opticalDuplicatePixelDistance: "Maximum offset between optical duplicate clusters"
        downsampleRegion_timeout: "hours before task timeout"
        downsampleRegion_threads: "Requested CPU threads"
        downsampleRegion_jobMemory: "Memory allocated for this job"
        downsampleRegion_modules: "required environment modules"
        downsample_timeout: "hours before task timeout"
        downsample_threads: "Requested CPU threads"
        downsample_jobMemory: "Memory allocated for this job"
        downsample_modules: "required environment modules"
        downsample_randomSeed: "Random seed for pre-downsampling (if any)"
        downsample_downsampleSuffix: "Suffix for output file"
        findDownsampleParamsMarkDup_timeout: "hours before task timeout"
        findDownsampleParamsMarkDup_threads: "Requested CPU threads"
        findDownsampleParamsMarkDup_jobMemory: "Memory allocated for this job"
        findDownsampleParamsMarkDup_modules: "required environment modules"
        findDownsampleParamsMarkDup_customRegions: "Custom downsample regions; overrides chromosome and interval parameters"
        findDownsampleParamsMarkDup_intervalStart: "Start of interval in each chromosome, for very large BAMs"
        findDownsampleParamsMarkDup_baseInterval: "Base width of interval in each chromosome, for very large BAMs"
        findDownsampleParamsMarkDup_chromosomes: "Array of chromosome identifiers for downsampled subset"
        findDownsampleParamsMarkDup_threshold: "Minimum number of reads to conduct downsampling"
        findDownsampleParams_timeout: "hours before task timeout"
        findDownsampleParams_threads: "Requested CPU threads"
        findDownsampleParams_jobMemory: "Memory allocated for this job"
        findDownsampleParams_modules: "required environment modules"
        findDownsampleParams_preDSMultiplier: "Determines target size for pre-downsampled set (if any). Must have (preDSMultiplier) < (minReadsRelative)."
        findDownsampleParams_precision: "Number of decimal places in fraction for pre-downsampling"
        findDownsampleParams_minReadsRelative: "Minimum value of (inputReads)/(targetReads) to allow pre-downsampling"
        findDownsampleParams_minReadsAbsolute: "Minimum value of targetReads to allow pre-downsampling"
        findDownsampleParams_targetReads: "Desired number of reads in downsampled output"
        indexBamFile_timeout: "hours before task timeout"
        indexBamFile_threads: "Requested CPU threads"
        indexBamFile_jobMemory: "Memory allocated for this job"
        indexBamFile_modules: "required environment modules"
        countInputReads_timeout: "hours before task timeout"
        countInputReads_threads: "Requested CPU threads"
        countInputReads_jobMemory: "Memory allocated for this job"
        countInputReads_modules: "required environment modules"
        updateMetadata_timeout: "hours before task timeout"
        updateMetadata_threads: "Requested CPU threads"
        updateMetadata_jobMemory: "Memory allocated for this job"
        updateMetadata_modules: "required environment modules"
        filter_timeout: "hours before task timeout"
        filter_threads: "Requested CPU threads"
        filter_jobMemory: "Memory allocated for this job"
        filter_modules: "required environment modules"
        filter_minQuality: "Minimum alignment quality to pass filter"
    bamFile: "Input BAM file on which to compute QC metrics"
    metadata: "JSON file containing metadata"
    outputFileNamePrefix: "Prefix for output files"
    }

    call filter {
    input:
    timeout = filter_timeout,
    threads = filter_threads,
    jobMemory = filter_jobMemory,
    modules = filter_modules,
    minQuality = filter_minQuality,
    bamFile = bamFile,
    outputFileNamePrefix = outputFileNamePrefix
    }

    call updateMetadata {
    input:
    timeout = updateMetadata_timeout,
    threads = updateMetadata_threads,
    jobMemory = updateMetadata_jobMemory,
    modules = updateMetadata_modules,
    metadata = metadata,
    outputFileNamePrefix = outputFileNamePrefix,
    totalInputReads = filter.totalInputReads,
    nonPrimaryReads = filter.nonPrimaryReads,
    unmappedReads = filter.unmappedReads,
    lowQualityReads = filter.lowQualityReads
    }

    call countInputReads {
    input:
    timeout = countInputReads_timeout,
    threads = countInputReads_threads,
    jobMemory = countInputReads_jobMemory,
    modules = countInputReads_modules,
    bamFile = filter.filteredBam
    }

    call indexBamFile {
    input:
    timeout = indexBamFile_timeout,
    threads = indexBamFile_threads,
    jobMemory = indexBamFile_jobMemory,
    modules = indexBamFile_modules,
    bamFile = filter.filteredBam
    }

    call findDownsampleParams {
    input:
    timeout = findDownsampleParams_timeout,
    threads = findDownsampleParams_threads,
    jobMemory = findDownsampleParams_jobMemory,
    modules = findDownsampleParams_modules,
    preDSMultiplier = findDownsampleParams_preDSMultiplier,
    precision = findDownsampleParams_precision,
    minReadsRelative = findDownsampleParams_minReadsRelative,
    minReadsAbsolute = findDownsampleParams_minReadsAbsolute,
    targetReads = findDownsampleParams_targetReads,
    outputFileNamePrefix = outputFileNamePrefix,
    inputReads = countInputReads.result
    }

    call findDownsampleParamsMarkDup {
    input:
    timeout = findDownsampleParamsMarkDup_timeout,
    threads = findDownsampleParamsMarkDup_threads,
    jobMemory = findDownsampleParamsMarkDup_jobMemory,
    modules = findDownsampleParamsMarkDup_modules,
    customRegions = findDownsampleParamsMarkDup_customRegions,
    intervalStart = findDownsampleParamsMarkDup_intervalStart,
    baseInterval = findDownsampleParamsMarkDup_baseInterval,
    chromosomes = findDownsampleParamsMarkDup_chromosomes,
    threshold = findDownsampleParamsMarkDup_threshold,
    outputFileNamePrefix = outputFileNamePrefix,
    inputReads = countInputReads.result
    }

    Boolean ds = findDownsampleParams.status["ds"]
    Boolean dsMarkDup = findDownsampleParamsMarkDup.status

    if (ds) {
    call downsample {
        input:
        timeout = downsample_timeout,
        threads = downsample_threads,
        jobMemory = downsample_jobMemory,
        modules = downsample_modules,
        randomSeed = downsample_randomSeed,
        downsampleSuffix = downsample_downsampleSuffix,
        bamFile = filter.filteredBam,
        outputFileNamePrefix = outputFileNamePrefix,
        downsampleStatus = findDownsampleParams.status,
        downsampleTargets = findDownsampleParams.targets,
    }
    }

    if (dsMarkDup) {
    call downsampleRegion {
        input:
        timeout = downsampleRegion_timeout,
        threads = downsampleRegion_threads,
        jobMemory = downsampleRegion_jobMemory,
        modules = downsampleRegion_modules,
        bamFile = filter.filteredBam,
        bamIndex = indexBamFile.index,
        outputFileNamePrefix = outputFileNamePrefix,
        region = findDownsampleParamsMarkDup.region
    }
    }

    Array[File?] markDupInputs = [downsampleRegion.result, filter.filteredBam]
    call markDuplicates {
    input:
    timeout = markDuplicates_timeout,
    threads = markDuplicates_threads,
    jobMemory = markDuplicates_jobMemory,
    modules = markDuplicates_modules,
    picardMaxMemMb = markDuplicates_picardMaxMemMb,
    opticalDuplicatePixelDistance = markDuplicates_opticalDuplicatePixelDistance,
    bamFile = select_first(markDupInputs),
    outputFileNamePrefix = outputFileNamePrefix
    }

    call bamQCMetrics {
    input:
    timeout = bamQCMetrics_timeout,
    threads = bamQCMetrics_threads,
    jobMemory = bamQCMetrics_jobMemory,
    modules = bamQCMetrics_modules,
    normalInsertMax = bamQCMetrics_normalInsertMax,
    workflowVersion = bamQCMetrics_workflowVersion,
    refSizesBed = bamQCMetrics_refSizesBed,
    refFasta = bamQCMetrics_refFasta,
    bamFile = filter.filteredBam,
    outputFileNamePrefix = outputFileNamePrefix,
    markDuplicates = markDuplicates.result,
    downsampled = ds,
    bamFileDownsampled = downsample.result
    }

    call runMosdepth {
    input:
    timeout = runMosdepth_timeout,
    threads = runMosdepth_threads,
    jobMemory = runMosdepth_jobMemory,
    modules = runMosdepth_modules,
    bamFile = filter.filteredBam,
    bamIndex = indexBamFile.index
    }

    call cumulativeDistToHistogram {
    input:
    timeout = cumulativeDistToHistogram_timeout,
    threads = cumulativeDistToHistogram_threads,
    jobMemory = cumulativeDistToHistogram_jobMemory,
    modules = cumulativeDistToHistogram_modules,
    globalDist = runMosdepth.globalDist,
    summary = runMosdepth.summary
    }

    call collateResults {
    input:
    timeout = collateResults_timeout,
    threads = collateResults_threads,
    jobMemory = collateResults_jobMemory,
    modules = collateResults_modules,
    bamQCMetricsResult = bamQCMetrics.result,
    metadata = updateMetadata.result,
    histogram = cumulativeDistToHistogram.histogram,
    outputFileNamePrefix = outputFileNamePrefix
    }

    output {
    File result = collateResults.result
    }

    meta {
    author: "Iain Bancarz"
    email: "ibancarz@oicr.on.ca"
    description: "QC metrics for BAM files"
    dependencies: [
    {
        name: "samtools/1.9",
        url: "https://github.com/samtools/samtools"
    },
    {
        name: "picard/2.21.2",
        url: "https://broadinstitute.github.io/picard/command-line-overview.html"
    },
    {
        name: "python/3.6",
        url: "https://www.python.org/downloads/"
    },
    {
        name: "bam-qc-metrics/0.2.5",
        url: "https://github.com/oicr-gsi/bam-qc-metrics.git"
    },
        {
        name: "mosdepth/0.2.9",
        url: "https://github.com/brentp/mosdepth"
    }
    ]
    }

}

task bamQCMetrics {

    input {
    File bamFile
    String outputFileNamePrefix
    File markDuplicates
    Boolean downsampled
    File? bamFileDownsampled
    String refFasta
    String refSizesBed
    String workflowVersion
    Int normalInsertMax = 1500
    String modules = "bam-qc-metrics/0.2.5"
    Int jobMemory = 16
    Int threads = 4
    Int timeout = 4
    }

    parameter_meta {
    bamFile: "Input BAM file of aligned rnaSeqQC data. Not downsampled; may be filtered."
    outputFileNamePrefix: "Prefix for output file"
    markDuplicates: "Text file output from markDuplicates task"
    downsampled: "True if downsampling has been applied"
    bamFileDownsampled: "(Optional) downsampled subset of reads from bamFile."
    refFasta: "Path to human genome FASTA reference"
    refSizesBed: "Path to human genome BED reference with chromosome sizes"
    workflowVersion: "Workflow version string"
    normalInsertMax: "Maximum of expected insert size range"
    modules: "required environment modules"
    jobMemory: "Memory allocated for this job"
    threads: "Requested CPU threads"
    timeout: "hours before task timeout"
    }

    String dsInput = if downsampled then "-S ~{bamFileDownsampled}" else ""
    String resultName = "~{outputFileNamePrefix}.metrics.json"

    command <<<
    run_bam_qc.py \
    -b ~{bamFile} \
    -d ~{markDuplicates} \
    --debug \
    -i ~{normalInsertMax} \
    -o ~{resultName} \
    -r ~{refFasta} \
    -t ~{refSizesBed} \
    -T . \
    -w ~{workflowVersion} \
    ~{"-S " + bamFileDownsampled}
    # Below replaced by above. Doesn't work with docker for some reason
    #~{dsInput}
    >>>

    runtime {
    modules: "~{modules}"
    memory:  "~{jobMemory} GB"
    cpu:     "~{threads}"
    timeout: "~{timeout}"
    }

    output {
    File result = "~{resultName}"
    }

    meta {
    output_meta: {
            output1: "JSON file with bam-qc-metrics output"
    }
  }

}

task collateResults {

    input {
    File bamQCMetricsResult
    File histogram
    File metadata
    String outputFileNamePrefix
    String modules = "python/3.6"
    Int jobMemory = 8
    Int threads = 4
    Int timeout = 1
    }

    parameter_meta {
    bamQCMetricsResult: "JSON result file from bamQCMetrics"
    histogram: "JSON file with coverage histogram"
    metadata: "JSON file with additional metadata"
    outputFileNamePrefix: "Prefix for output file"
    modules: "required environment modules"
    jobMemory: "Memory allocated for this job"
    threads: "Requested CPU threads"
    timeout: "hours before task timeout"
    }

    runtime {
    modules: "~{modules}"
    memory:  "~{jobMemory} GB"
    cpu:     "~{threads}"
    timeout: "~{timeout}"
    }

    String outputFileName = "~{outputFileNamePrefix}.bamQC_results.json"

    command <<<
        python3 <<CODE
        import json
        data = json.loads(open("~{bamQCMetricsResult}").read())
        histogram = json.loads(open("~{histogram}").read())
        data["coverage_histogram"] = histogram
        metadata = json.loads(open("~{metadata}").read())
        for key in metadata.keys():
            data[key] = metadata[key]
        out = open("~{outputFileName}", "w")
        json.dump(data, out, sort_keys=True)
        out.close()
        CODE
    >>>

    output {
    File result = "~{outputFileName}"
    }

    meta {
    output_meta: {
            output1: "JSON file of collated results"
    }
    }
}

task countInputReads {

    input {
    File bamFile
    String modules = "samtools/1.9"
    Int jobMemory = 16
    Int threads = 4
    Int timeout = 4
    }

    parameter_meta {
    bamFile: "Input BAM file of aligned data"
    modules: "required environment modules"
    jobMemory: "Memory allocated for this job"
    threads: "Requested CPU threads"
    timeout: "hours before task timeout"
    }

    runtime {
    modules: "~{modules}"
    memory:  "~{jobMemory} GB"
    cpu:     "~{threads}"
    timeout: "~{timeout}"
    }

    command <<<
    samtools view -c ~{bamFile}
    >>>
    
    output {
    String result = read_string(stdout())
    }

    meta {
    output_meta: {
            output1: "Number of reads in input BAM file"
    }
    }
}

task cumulativeDistToHistogram {

    input {
    File globalDist
    File summary
    String modules = "python/3.6"
    Int jobMemory = 8
    Int threads = 4
    Int timeout = 1
    }

    parameter_meta {
    globalDist: "Global coverage distribution output from mosdepth"
    summary: "Summary output from mosdepth"
    modules: "required environment modules"
    jobMemory: "Memory allocated for this job"
    threads: "Requested CPU threads"
    timeout: "hours before task timeout"
    }

    String outFileName = "coverage_histogram.json"

    # mosdepth writes a global coverage distribution with 3 columns:
    # 1) Chromsome name, or "total" for overall totals
    # 2) Depth of coverage
    # 3) Probability of coverage less than or equal to (2)
    # Want to convert the above cumulative probability distribution to a histogram
    # The "total" section of the summary discards some information
    # So, we process the outputs for each chromosome to construct the histogram

    command <<<
        python3 <<CODE
        import csv, json
        summary = open("~{summary}").readlines()
        globalDist = open("~{globalDist}").readlines()
        # read chromosome lengths from the summary
        summaryReader = csv.reader(summary, delimiter="\t")
        lengthByChr = {}
        for row in summaryReader:
            if row[0] == 'chrom' or row[0] == 'total':
                continue # skip initial header row, and final total row
            lengthByChr[row[0]] = int(row[1])
        chromosomes = sorted(lengthByChr.keys())
        # read the cumulative distribution for each chromosome
        globalReader = csv.reader(globalDist, delimiter="\t")
        cumDist = {}
        for k in chromosomes:
            cumDist[k] = {}
        for row in globalReader:
            if row[0]=="total":
                continue
            cumDist[row[0]][int(row[1])] = float(row[2])
        # convert the cumulative distributions to non-cumulative and populate histogram
        histogram = {}
        for k in chromosomes:
            depths = sorted(cumDist[k].keys())
            dist = {}
            for i in range(len(depths)-1):
                depth = depths[i]
                nextDepth = depths[i+1]
                dist[depth] = cumDist[k][depth] - cumDist[k][nextDepth]
            maxDepth = max(depths)
            dist[maxDepth] = cumDist[k][maxDepth]
            # now find the number of loci at each depth of coverage to construct the histogram
            for depth in depths:
                loci = int(round(dist[depth]*lengthByChr[k], 0))
                histogram[depth] = histogram.get(depth, 0) + loci
        # fill in zero values for missing depths
        for i in range(max(histogram.keys())):
            if i not in histogram:
                histogram[i] = 0
        out = open("~{outFileName}", "w")
        json.dump(histogram, out, sort_keys=True)
        out.close()
        CODE
    >>>

    runtime {
    modules: "~{modules}"
    memory:  "~{jobMemory} GB"
    cpu:     "~{threads}"
    timeout: "~{timeout}"
    }

    output {
    File histogram = "~{outFileName}"
    }

    meta {
    output_meta: {
        histogram: "Coverage histogram in JSON format"
    }
    }
}

task downsample {

    # random downsampling for QC metrics (excepting MarkDuplicates)

    input {
    File bamFile
    String outputFileNamePrefix
    Map[String, Boolean] downsampleStatus
    Map[String, String] downsampleTargets
    String downsampleSuffix = "downsampled.bam"
    Int randomSeed = 42
    String modules = "samtools/1.9"
    Int jobMemory = 16
    Int threads = 4
    Int timeout = 4
    }

    parameter_meta {
    bamFile: "Input BAM file of aligned rnaSeqQC data"
    outputFileNamePrefix: "Prefix for output file"
    downsampleStatus: "Map; whether to apply pre-downsampling and downsampling"
    downsampleTargets: "Map; target number of reads for pre-downsampling and downsampling"
    downsampleSuffix: "Suffix for output file"
    randomSeed: "Random seed for pre-downsampling (if any)"
    modules: "required environment modules"
    jobMemory: "Memory allocated for this job"
    threads: "Requested CPU threads"
    timeout: "hours before task timeout"
    }

    String resultName = "~{outputFileNamePrefix}.~{downsampleSuffix}"

    # unpack downsample parameters
    Boolean applyPreDownsample = downsampleStatus["pre_ds"]
    String preDownsampleTarget = downsampleTargets["pre_ds"]
    String downsampleTarget = downsampleTargets["ds"]

    # generate downsample commands
    # preDownsample = fast, random selection of approximate total with samtools view
    String preDownsample = "samtools view -h -u -s ~{randomSeed}.~{preDownsampleTarget} | "
    String preDownsampleCommand = if applyPreDownsample then "~{preDownsample}" else ""
    # downsample = slow, deterministic selection of exact total with samtools collate and sort
    # see https://github.com/samtools/samtools/issues/931
    String dsCollate = "samtools collate -O --output-fmt sam - | "
    String dsAwk = "awk '/^@/ { print; next } count < ~{downsampleTarget} || last == $1 { print; last = $1; count++ }' | "
    String dsSort = "samtools sort -T downsample_sort - | "
    String downsampleCommand = "~{dsCollate}~{dsAwk}~{dsSort}"
    
    command <<<
    set -e
    set -o pipefail
    samtools view -b -h ~{bamFile} | \
    ~{preDownsampleCommand} ~{downsampleCommand} \
    samtools view -b > ~{resultName}
    >>>

    runtime {
    modules: "~{modules}"
    memory:  "~{jobMemory} GB"
    cpu:     "~{threads}"
    timeout: "~{timeout}"
    }

    output {
    File result = "~{resultName}"
    }
    
    meta {
    output_meta: {
            result: "BAM file downsampled to required number of reads"
    }
    }

}

task downsampleRegion {

    # downsample a specific chromosomal region for MarkDuplicates
    # this keeps a proportionate level of duplicates in the downsampled data

    input {
    File bamFile
    File bamIndex
    String outputFileNamePrefix
    String region
    String modules = "samtools/1.9"
    Int jobMemory = 16
    Int threads = 4
    Int timeout = 4
    }

    parameter_meta {
    bamFile: "Input BAM file"
    bamIndex: "BAM index file in BAI format"
    outputFileNamePrefix: "Prefix for output file"
    region: "Region argument for samtools"
    modules: "required environment modules"
    jobMemory: "Memory allocated for this job"
    threads: "Requested CPU threads"
    timeout: "hours before task timeout"
    }

    String bamFileName = basename(bamFile)
    String resultName = "~{outputFileNamePrefix}.downsampledRegion.bam"

    # need to index the (filtered) BAM file before viewing a specific chromosome

    command <<<
    set -e
    # ensure BAM file and index are symlinked to working directory
    ln -s ~{bamFile}
    ln -s ~{bamIndex}
    samtools view -b -h ~{bamFileName} ~{region} > ~{resultName}
    >>>

    runtime {
    modules: "~{modules}"
    memory:  "~{jobMemory} GB"
    cpu:     "~{threads}"
    timeout: "~{timeout}"
    }

    output {
    File result = "~{resultName}"
    }

    meta {
    output_meta: {
            result: "BAM file downsampled to required number of reads"
    }
    }

}

task filter {

    # filter out non-primary, unmapped, and low-quality aligned reads
    # count the number of reads filtered out at each step
    # return filtered read counts and the filtered BAM file

    input {
    File bamFile
    String outputFileNamePrefix
    Int minQuality = 30
    String modules = "samtools/1.9"
    Int jobMemory = 16
    Int threads = 4
    Int timeout = 4
    }

    parameter_meta {
    bamFile: "Input BAM file of aligned rnaSeqQC data"
    outputFileNamePrefix: "Prefix for output file"
    minQuality: "Minimum alignment quality to pass filter"
    modules: "required environment modules"
    jobMemory: "Memory allocated for this job"
    threads: "Requested CPU threads"
    timeout: "hours before task timeout"
    }

    String resultName = "~{outputFileNamePrefix}.filtered.bam"
    String totalInputReadsFile = "total_input_reads.txt"
    String totalNonPrimaryReadsFile = "total_non_primary_reads.txt"
    String totalUnmappedReadsFile = "total_unmapped_reads.txt"
    String totalLowQualityReadsFile = "total_low_quality_reads.txt"
    String nonPrimaryReadsFile = "non_primary_reads.bam"
    String unmappedReadsFile = "unmapped_reads.bam"
    String lowQualityReadsFile = "low_quality_reads.bam"

    # -F 2304 excludes secondary and supplementary alignments
    # -F 4 excludes unmapped reads

    command <<<
    set -e
    set -o pipefail
    samtools view -h -b -F 2304 -U ~{nonPrimaryReadsFile} ~{bamFile} | \
    samtools view -h -b -F 4 -U ~{unmappedReadsFile} | \
    samtools view -h -b -q ~{minQuality} -U ~{lowQualityReadsFile} \
    > ~{resultName}
    samtools view -c ~{bamFile} > ~{totalInputReadsFile}
    samtools view -c ~{nonPrimaryReadsFile} > ~{totalNonPrimaryReadsFile}
    samtools view -c ~{unmappedReadsFile} > ~{totalUnmappedReadsFile}
    samtools view -c ~{lowQualityReadsFile} > ~{totalLowQualityReadsFile}
    >>>

    runtime {
    modules: "~{modules}"
    memory:  "~{jobMemory} GB"
    cpu:     "~{threads}"
    timeout: "~{timeout}"
    }

    # record read totals as String, not Int, to avoid integer overflow error
    output {
    String totalInputReads = read_string("~{totalInputReadsFile}")
    String nonPrimaryReads = read_string("~{totalNonPrimaryReadsFile}")
    String unmappedReads = read_string("~{totalUnmappedReadsFile}")
    String lowQualityReads = read_string("~{totalLowQualityReadsFile}")
    File filteredBam = "~{resultName}"
    }

    meta {
    output_meta: {
        totalInputReads: "Total reads in original input BAM file",
        nonPrimaryReads: "Total reads excluded as non-primary",
        unmappedReads: "Total reads excluded as unmapped",
        lowQualityReads: "Total reads excluded as low alignment quality",
            filteredBam: "Filtered BAM file"
    }
    }

}

task findDownsampleParams {

    input {
    String outputFileNamePrefix
    String inputReads
    Int targetReads = 100000
    Int minReadsAbsolute = 10000
    Int minReadsRelative = 2
    Int precision = 8
    Float preDSMultiplier = 1.5
    String modules = "python/3.6"
    Int jobMemory = 16
    Int threads = 4
    Int timeout = 4
    }

    String statusFile = "status.json"
    String targetsFile = "targets.json"

    parameter_meta {
    outputFileNamePrefix: "Prefix for output file"
    inputReads: "Number of reads in input bamFile (represented as string to avoid integer overflow)"
    targetReads: "Desired number of reads in downsampled output"
    minReadsAbsolute: "Minimum value of targetReads to allow pre-downsampling"
    minReadsRelative: "Minimum value of (inputReads)/(targetReads) to allow pre-downsampling"
    precision: "Number of decimal places in fraction for pre-downsampling"
    preDSMultiplier: "Determines target size for pre-downsampled set (if any). Must have (preDSMultiplier) < (minReadsRelative)."
    modules: "required environment modules"
    jobMemory: "Memory allocated for this job"
    threads: "Requested CPU threads"
    timeout: "hours before task timeout"
    }

    # see comments in "task downsample" for effect of predownsampling and downsampling

    # target for predownsampling with "samtools view -s" is expressed as a probability
    # eg. to choose approximately 200 reads out of 10000, target = 0.02
    # we convert to a fixed-precision target string for easier handling in BASH
    # eg. 0.02 -> "020000"
    # subsequently, we concatenate in the form {$RANDOM_SEED}.${TARGET}, eg. "42.020000"
    # for consistency, express downsampling target (integer number of reads) as a string also
    
    command <<<
        python3 <<CODE
        import json, math, sys
        readsIn = ~{inputReads}
        readsTarget = ~{targetReads}
        precision = ~{precision}
        print("Input reads param =", readsIn, file=sys.stderr)
        print("Target reads param =", readsTarget, file=sys.stderr)
        minReadsAbsolute = ~{minReadsAbsolute}
        minReadsRelative = ~{minReadsRelative}
        preDownsampleMultiplier = ~{preDSMultiplier}
        if readsIn <= readsTarget:
          # absolutely no downsampling
          applyPreDownsample = False
          applyDownsample = False
          preDownsampleTarget = "no_pre_downsample"
          downSampleTarget = "no_downsample"
        elif readsIn < readsTarget * minReadsRelative or readsTarget < minReadsAbsolute:
          # no predownsampling
          applyPreDownsample = False
          applyDownsample = True
          preDownsampleTarget = "no_pre_downsample"
          downSampleTarget = str(readsTarget)
        else:
          # predownsampling and downsampling
          applyPreDownsample = True
          applyDownsample = True
          probability = (readsTarget * preDownsampleMultiplier)/readsIn
          formatString = "{:0"+str(precision)+"d}"
          preDownsampleTarget = formatString.format(int(math.floor(probability * 10**precision)))
          downSampleTarget = str(readsTarget)
        status = {
          "pre_ds": applyPreDownsample,
          "ds": applyDownsample
        }
        targets = {
          "pre_ds": preDownsampleTarget,
          "ds": downSampleTarget
        }
        statusFile = open("~{statusFile}", "w")
        json.dump(status, statusFile)
        statusFile.close()
        targetFile = open("~{targetsFile}", "w")
        json.dump(targets, targetFile)
        targetFile.close()
        CODE
    >>>

    runtime {
    modules: "~{modules}"
    memory:  "~{jobMemory} GB"
    cpu:     "~{threads}"
    timeout: "~{timeout}"
    }

    output {
    Map[String, Boolean] status = read_json("~{statusFile}")
    Map[String, String] targets = read_json("~{targetsFile}")
    }

    meta {
    output_meta: {
            status: "Boolean flags indicating whether to apply (pre)downsampling.",
            output2: "Strings representing target number of reads for (pre)downsampling."
    }
    }
}

task findDownsampleParamsMarkDup {

    # downsampling parameters for MarkDuplicates; see filter_downsample.md for details
    # choose a region of the genome instead of using random selection

    # a BAM file is *very* approximately 10M reads per GB
    # Current merged BAM files are unlikely to exceed 10**9 reads; but we scale up higher just in case

    input {
    String outputFileNamePrefix
    String inputReads
    Int threshold = 10000000
    Array[String] chromosomes = ["chr12", "chr13", "chrXII", "chrXIII"]
    Int baseInterval = 15000
    Int intervalStart = 100000
    String customRegions = ""
    String modules = "python/3.6"
    Int jobMemory = 16
    Int threads = 4
    Int timeout = 4
    }

    parameter_meta {
    outputFileNamePrefix: "Prefix for output file"
    inputReads: "Number of reads in input bamFile"
    threshold: "Minimum number of reads to conduct downsampling"
    chromosomes: "Array of chromosome identifiers for downsampled subset"
    baseInterval: "Base width of interval in each chromosome, for very large BAMs"
    intervalStart: "Start of interval in each chromosome, for very large BAMs"
    customRegions: "Custom downsample regions; overrides chromosome and interval parameters"
    modules: "required environment modules"
    jobMemory: "Memory allocated for this job"
    threads: "Requested CPU threads"
    timeout: "hours before task timeout"
    }

    String outputStatus = "~{outputFileNamePrefix}_status.txt"
    String outputRegion = "~{outputFileNamePrefix}_region.txt"
    File chromosomesText = write_lines(chromosomes)

    command <<<
        python3 <<CODE
        readsIn = ~{inputReads}
        threshold = ~{threshold}
        interval = ~{baseInterval}
        start = ~{intervalStart} + 1 # start of sub-chromosome window, if needed; exclude telomeres
        chromosomes = [line.strip() for line in open("~{chromosomesText}").readlines()]
        customRegions = "~{customRegions}" # overrides other chromosome/interval parameters
        ds = True # True if downsampling, false otherwise
        end = None # end of window, if needed
        if readsIn <= threshold:
            ds = False # no downsampling
        elif readsIn <= threshold*10:
            pass # default to chr12 & chr13 =~ 8% of genome
        elif readsIn <= threshold*10**2:
            end = start + interval*10**3 - 1 # default 2*15 million base window ~ 1% of genome
        elif readsIn <= threshold*10**3:
            end = start + interval*10**2 - 1
        elif readsIn <= threshold*10**4:
            end = start + interval*10 - 1
        else:
            end = start + interval - 1
        if ds:
            status = "true"
            if customRegions != "":
                region = customRegions
            elif end == None:
                region = " ".join(chromosomes)
            else:
                regions = ["%s:%i-%i" % (chromosome, start, end) for chromosome in chromosomes ]
                region = " ".join(regions)
        else:
            status = "false"
            region = ""
        outStatus = open("~{outputStatus}", "w")
        print(status, file=outStatus)
        outStatus.close()
        outRegion = open("~{outputRegion}", "w")
        print(region, file=outRegion)
        outRegion.close()
        CODE
    >>>

    output {
    Boolean status = read_boolean("~{outputStatus}")
    String region = read_string("~{outputRegion}")
    }

    meta {
    output_meta: {
        status: "Boolean flag, indicates whether downsampling is required",
        region: "String to specify downsampled region for samtools"
    }
    }
}

task indexBamFile {

    input {
    File bamFile
    String modules = "samtools/1.9"
    Int jobMemory = 16
    Int threads = 4
    Int timeout = 4
    }

    parameter_meta {
    bamFile: "Input BAM file of aligned data"
    modules: "required environment modules"
    jobMemory: "Memory allocated for this job"
    threads: "Requested CPU threads"
    timeout: "hours before task timeout"
    }

    runtime {
    modules: "~{modules}"
    memory:  "~{jobMemory} GB"
    cpu:     "~{threads}"
    timeout: "~{timeout}"
    }

    String bamName = basename(bamFile)
    String indexName = "~{bamName}.bai"
    
    command <<<
    samtools index -b ~{bamFile} ~{indexName}
    >>>
    
    output {
    File index = indexName
    }

    meta {
    output_meta: {
            index: "Index file in BAI format"
    }
  }

}

task markDuplicates {

    input {
    File bamFile
    String outputFileNamePrefix
    Int opticalDuplicatePixelDistance=100
    Int picardMaxMemMb=6000
    String modules = "picard/2.21.2"
    Int jobMemory = 16
    Int threads = 4
    Int timeout = 4
    }

    # See GR-899 for opticalDuplicatePixelDistance

    parameter_meta {
    bamFile: "Input BAM file, after filtering and downsampling (if any)"
    outputFileNamePrefix: "Prefix for output file"
    opticalDuplicatePixelDistance: "Maximum offset between optical duplicate clusters"
    picardMaxMemMb: "Memory requirement in MB for running Picard JAR"
    modules: "required environment modules"
    jobMemory: "Memory allocated for this job"
    threads: "Requested CPU threads"
    timeout: "hours before task timeout"
    }

    String outFileBam = "~{outputFileNamePrefix}.markDuplicates.bam"
    String outFileText = "~{outputFileNamePrefix}.markDuplicates.txt"

    command <<<
    java -Xmx~{picardMaxMemMb}M \
    -jar ${PICARD_ROOT}/picard.jar \
    MarkDuplicates \
    INPUT=~{bamFile} \
    OUTPUT=~{outFileBam} \
    VALIDATION_STRINGENCY=SILENT \
    TMP_DIR=${PWD} \
    METRICS_FILE=~{outFileText} \
    OPTICAL_DUPLICATE_PIXEL_DISTANCE=~{opticalDuplicatePixelDistance}
    >>>

    runtime {
    modules: "~{modules}"
    memory:  "~{jobMemory} GB"
    cpu:     "~{threads}"
    timeout: "~{timeout}"
    }

    output {
    File result = "~{outFileText}"
    }

    meta {
    output_meta: {
            result: "Text file with Picard markDuplicates metrics"
    }
    }

}

task runMosdepth {

    input {
    File bamFile
    File bamIndex
    String modules = "mosdepth/0.2.9"
    Int jobMemory = 16
    Int threads = 4
    Int timeout = 4
    }

    parameter_meta {
    bamFile: "Input BAM file of aligned data"
    bamIndex: "Index file in samtools .bai format"
    modules: "required environment modules"
    jobMemory: "Memory allocated for this job"
    threads: "Requested CPU threads"
    timeout: "hours before task timeout"
    }

    runtime {
    modules: "~{modules}"
    memory:  "~{jobMemory} GB"
    cpu:     "~{threads}"
    timeout: "~{timeout}"
    }

    String bamFileName = basename(bamFile)

    command <<<
    set -eo pipefail
    # ensure BAM file and index are symlinked to working directory
    ln -s ~{bamFile}
    ln -s ~{bamIndex}
    # run mosdepth
    MOSDEPTH_PRECISION=8 mosdepth -x -n -t 3 bamqc ~{bamFileName}
    >>>

    output {
    File globalDist = "bamqc.mosdepth.global.dist.txt"
    File summary = "bamqc.mosdepth.summary.txt"
    }

    meta {
    output_meta: {
            globalDist: "Global distribution of coverage",
        summary: "Total bases in coverage"
    }
  }

}

task updateMetadata {

    # add extra fields to the metadata JSON file

    input {
    Map[String, String] metadata
    String outputFileNamePrefix
    String totalInputReads
    String nonPrimaryReads
    String unmappedReads
    String lowQualityReads
    String modules = "python/3.6"
    Int jobMemory = 16
    Int threads = 4
    Int timeout = 4
    }

    parameter_meta {
    metadata: "Key/value map of input metadata"
    outputFileNamePrefix: "Prefix for output file"
    totalInputReads: "Total reads in original input BAM file"
    nonPrimaryReads: "Total reads excluded as non-primary"
    unmappedReads: "Total reads excluded as unmapped"
    lowQualityReads: "Total reads excluded as low alignment quality"
    modules: "required environment modules"
    jobMemory: "Memory allocated for this job"
    threads: "Requested CPU threads"
    timeout: "hours before task timeout"
    }

    runtime {
    modules: "~{modules}"
    memory:  "~{jobMemory} GB"
    cpu:     "~{threads}"
    timeout: "~{timeout}"
    }

    File metadataJson = write_json(metadata)
    String outFileName = "~{outputFileNamePrefix}.updated_metadata.json"

    # Read totals are Strings in WDL to avoid integer overflow in Cromwell
    # Python3 can handle arbitrarily large integers

    command <<<
        python3 <<CODE
        import json
        metadata = json.loads(open("~{metadataJson}").read())
        metadata["total input reads meta"] = ~{totalInputReads}
        metadata["non-primary reads meta"] = ~{nonPrimaryReads}
        metadata["unmapped reads meta"] = ~{unmappedReads}
        metadata["low-quality reads meta"] = ~{lowQualityReads}
        outFile = open("~{outFileName}", "w")
        json.dump(metadata, outFile)
        outFile.close()
        CODE
    >>>

    output {
    File result = "~{outFileName}"
    }

    meta {
    output_meta: {
            result: "JSON file with updated metadata"
    }
    }
}
