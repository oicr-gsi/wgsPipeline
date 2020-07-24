version 1.0

workflow bamMergePreprocessing {

  input {
    String docker = "g3chen/wgspipeline@sha256:3c0c292c460c8db19b9744be1ea81529c4d189e4c4f9ca9a63046edcf792087d"
    String mergeSplitByIntervalBams_modules = "gatk/4.1.6.0"
    Int mergeSplitByIntervalBams_timeout = 6
    Int mergeSplitByIntervalBams_cores = 1
    Int mergeSplitByIntervalBams_overhead = 6
    Int mergeSplitByIntervalBams_jobMemory = 24
    String? mergeSplitByIntervalBams_additionalParams
    String collectFilesBySample_modules = "python/3.7"
    Int collectFilesBySample_timeout = 1
    Int collectFilesBySample_cores = 1
    Int collectFilesBySample_jobMemory = 1
    String applyBaseQualityScoreRecalibration_modules = "gatk/4.1.6.0"
    Int applyBaseQualityScoreRecalibration_timeout = 6
    Int applyBaseQualityScoreRecalibration_cores = 1
    Int applyBaseQualityScoreRecalibration_overhead = 6
    Int applyBaseQualityScoreRecalibration_jobMemory = 24
    String? applyBaseQualityScoreRecalibration_additionalParams
    String applyBaseQualityScoreRecalibration_suffix = ".recalibrated"
    String applyBaseQualityScoreRecalibration_outputFileName = "basename(bam,".bam")"
    String analyzeCovariates_modules = "gatk/4.1.6.0"
    Int analyzeCovariates_timeout = 6
    Int analyzeCovariates_cores = 1
    Int analyzeCovariates_overhead = 6
    Int analyzeCovariates_jobMemory = 24
    String analyzeCovariates_outputFileName = "gatk.recalibration.pdf"
    String? analyzeCovariates_additionalParams
    String gatherBQSRReports_modules = "gatk/4.1.6.0"
    Int gatherBQSRReports_timeout = 6
    Int gatherBQSRReports_cores = 1
    Int gatherBQSRReports_overhead = 6
    Int gatherBQSRReports_jobMemory = 24
    String gatherBQSRReports_outputFileName = "gatk.recalibration.csv"
    String? gatherBQSRReports_additionalParams
    String baseQualityScoreRecalibration_modules = "gatk/4.1.6.0"
    Int baseQualityScoreRecalibration_timeout = 6
    Int baseQualityScoreRecalibration_cores = 1
    Int baseQualityScoreRecalibration_overhead = 6
    Int baseQualityScoreRecalibration_jobMemory = 24
    String baseQualityScoreRecalibration_outputFileName = "gatk.recalibration.csv"
    String? baseQualityScoreRecalibration_additionalParams
    Array[String] baseQualityScoreRecalibration_knownSites
    Array[String] baseQualityScoreRecalibration_intervals = []
    String indelRealign_gatkJar = "$GATK_ROOT/GenomeAnalysisTK.jar"
    String indelRealign_modules = "python/3.7 gatk/3.6-0"
    Int indelRealign_timeout = 6
    Int indelRealign_cores = 1
    Int indelRealign_overhead = 6
    Int indelRealign_jobMemory = 24
    String? indelRealign_additionalParams
    Array[String] indelRealign_knownAlleles
    String realignerTargetCreator_gatkJar = "$GATK_ROOT/GenomeAnalysisTK.jar"
    String realignerTargetCreator_modules = "gatk/3.6-0"
    Int realignerTargetCreator_timeout = 6
    Int realignerTargetCreator_cores = 1
    Int realignerTargetCreator_overhead = 6
    Int realignerTargetCreator_jobMemory = 24
    String? realignerTargetCreator_additionalParams
    String? realignerTargetCreator_downsamplingType
    Array[String] realignerTargetCreator_knownIndels
    DefaultRuntimeAttributes preprocessBam_defaultRuntimeAttributes = {"memory": 24, "overhead": 6, "cores": 1, "timeout": 6, "modules": "samtools/1.9 gatk/4.1.6.0"}
    String? preprocessBam_splitNCigarReadsAdditionalParams
    Array[String] preprocessBam_readFilters = []
    Boolean preprocessBam_refactorCigarString = false
    String preprocessBam_splitNCigarReadsSuffix = ".split"
    String? preprocessBam_markDuplicatesAdditionalParams
    Int preprocessBam_opticalDuplicatePixelDistance = 100
    Boolean preprocessBam_removeDuplicates = false
    String preprocessBam_markDuplicatesSuffix = ".deduped"
    String? preprocessBam_filterAdditionalParams
    Int? preprocessBam_minMapQuality
    Int preprocessBam_filterFlags = 260
    String preprocessBam_filterSuffix = ".filter"
    String preprocessBam_temporaryWorkingDir = ""
    String splitStringToArray_modules = "python/3.7"
    Int splitStringToArray_timeout = 1
    Int splitStringToArray_cores = 1
    Int splitStringToArray_jobMemory = 1
    String splitStringToArray_recordSeparator = "+"
    String splitStringToArray_lineSeparator = ","
    Array[InputGroup] inputGroups
    String intervalsToParallelizeByString
    Boolean doFilter = true
    Boolean doMarkDuplicates = true
    Boolean doSplitNCigarReads = false
    Boolean doIndelRealignment = true
    Boolean doBqsr = true
    String reference

    # preprocessingBam runtime attributes overrides
    # map access with missing key (e.g. an interval that does not need an override) is not supported
    # see: https://github.com/openwdl/wdl/issues/305
    #Map[String, RuntimeAttributes]? preprocessingBamRuntimeAttributes
    Array[RuntimeAttributes] preprocessingBamRuntimeAttributes = []
  }

  parameter_meta {
    inputGroups: "Array of objects describing sets of bams to merge together and the merged file name. These merged bams will be cocleaned together and output separately (by merged name)."
    intervalsToParallelizeByString: "Comma separated list of intervals to split by (e.g. chr1,chr2,chr3+chr4)."
    doFilter: "Enable/disable Samtools filtering."
    doMarkDuplicates: "Enable/disable GATK4 MarkDuplicates."
    doSplitNCigarReads: "Enable/disable GATK4 SplitNCigarReads."
    doIndelRealignment: "Enable/disable GATK3 RealignerTargetCreator + IndelRealigner."
    doBqsr: "Enable/disable GATK4 BQSR."
    reference: "Path to reference file."
    preprocessingBamRuntimeAttributes: "Interval specific runtime attributes to use as overrides for the defaults."
  }

  meta {
    author: "Michael Laszloffy"
    email: "michael.laszloffy@oicr.on.ca"
    description: "WDL workflow to filter, merge, mark duplicates, indel realign and base quality score recalibrate groups of related (e.g. by library, donor, project) lane level alignments."
    dependencies: [
      {
        name: "samtools/1.9",
        url: "http://www.htslib.org/"
      },
      {
        name: "gatk/4.1.6.0",
        url: "https://gatk.broadinstitute.org"
      },
      {
        name: "gatk/3.6-0",
        url: "https://gatk.broadinstitute.org"
      },
      {
       name: "python/3.7",
       url: "https://www.python.org"
      }
    ]
    output_meta: {
      outputGroups: "Array of objects with outputIdentifier (from inputGroups) and the final merged bam and bamIndex.",
      recalibrationReport: "Recalibration report pdf (if BQSR enabled).",
      recalibrationTable: "Recalibration csv that was used by BQSR (if BQSR enabled)."
    }
  }

  call splitStringToArray {
    input:
      docker = docker,
      modules = splitStringToArray_modules,
      timeout = splitStringToArray_timeout,
      cores = splitStringToArray_cores,
      jobMemory = splitStringToArray_jobMemory,
      recordSeparator = splitStringToArray_recordSeparator,
      lineSeparator = splitStringToArray_lineSeparator,
      str = intervalsToParallelizeByString
  }
  Array[Intervals] intervalsToParallelizeBy = splitStringToArray.intervalsList.intervalsList

  scatter (intervals in intervalsToParallelizeBy) {
    scatter (i in inputGroups) {
      scatter(bamAndBamIndexInput in i.bamAndBamIndexInputs) {
        File inputGroupBam = bamAndBamIndexInput.bam
        File inputGroupBamIndex = bamAndBamIndexInput.bamIndex
      }
      Array[File] inputGroupBams = inputGroupBam
      Array[File] inputGroupBamIndexes = inputGroupBamIndex

      # map access with missing key (e.g. an interval that does not need an override) is not supported
      # see: https://github.com/openwdl/wdl/issues/305
      #RuntimeAttribute? runtimeAttributeOverride = preprocessingBamRuntimeAttributes[intervals.id]
      scatter (p in preprocessingBamRuntimeAttributes) {
        if(defined(p.id)) {
          String id = select_first([p.id])
          if(id == i.outputIdentifier + "." + intervals.id) {
            RuntimeAttributes? inputGroupAndIntervalRuntimeAttributesOverride = p
          }
          if(id == intervals.id) {
            RuntimeAttributes? intervalRuntimeAttributesOverride = p
          }
          if(id == "*") {
            RuntimeAttributes? wildcardRuntimeAttributesOverride = p
          }
        }
      }
      # collect interval and wildcard runtime attribute overrides
      Array[RuntimeAttributes] runtimeAttributeOverrides = flatten([select_all(inputGroupAndIntervalRuntimeAttributesOverride),
                                                                    select_all(intervalRuntimeAttributesOverride),
                                                                    select_all(wildcardRuntimeAttributesOverride)])
      if(length(runtimeAttributeOverrides) > 0) {
        # create a RuntimeAttributes optional
        RuntimeAttributes runtimeAttributesOverride = runtimeAttributeOverrides[0]
      }

      call preprocessBam {
        input:
          docker = docker,
          defaultRuntimeAttributes = preprocessBam_defaultRuntimeAttributes,
          splitNCigarReadsAdditionalParams = preprocessBam_splitNCigarReadsAdditionalParams,
          readFilters = preprocessBam_readFilters,
          refactorCigarString = preprocessBam_refactorCigarString,
          splitNCigarReadsSuffix = preprocessBam_splitNCigarReadsSuffix,
          markDuplicatesAdditionalParams = preprocessBam_markDuplicatesAdditionalParams,
          opticalDuplicatePixelDistance = preprocessBam_opticalDuplicatePixelDistance,
          removeDuplicates = preprocessBam_removeDuplicates,
          markDuplicatesSuffix = preprocessBam_markDuplicatesSuffix,
          filterAdditionalParams = preprocessBam_filterAdditionalParams,
          minMapQuality = preprocessBam_minMapQuality,
          filterFlags = preprocessBam_filterFlags,
          filterSuffix = preprocessBam_filterSuffix,
          temporaryWorkingDir = preprocessBam_temporaryWorkingDir,
          bams = inputGroupBams,
          bamIndexes = inputGroupBamIndexes,
          intervals = intervals.intervalsList,
          outputFileName = i.outputIdentifier,
          reference = reference,
          doFilter = doFilter,
          doMarkDuplicates = doMarkDuplicates,
          doSplitNCigarReads = doSplitNCigarReads,
          runtimeAttributes = runtimeAttributesOverride
      }
    }
    Array[File] preprocessedBams = preprocessBam.preprocessedBam
    Array[File] preprocessedBamIndexes = preprocessBam.preprocessedBamIndex

    # indel realignment combines samples (nWayOut) and is parallized by chromosome
    if(doIndelRealignment) {
      call realignerTargetCreator {
        input:
          docker = docker,
          gatkJar = realignerTargetCreator_gatkJar,
          modules = realignerTargetCreator_modules,
          timeout = realignerTargetCreator_timeout,
          cores = realignerTargetCreator_cores,
          overhead = realignerTargetCreator_overhead,
          jobMemory = realignerTargetCreator_jobMemory,
          additionalParams = realignerTargetCreator_additionalParams,
          downsamplingType = realignerTargetCreator_downsamplingType,
          knownIndels = realignerTargetCreator_knownIndels,
          bams = preprocessedBams,
          bamIndexes = preprocessedBamIndexes,
          intervals = intervals.intervalsList,
          reference = reference
      }

      call indelRealign {
        input:
          docker = docker,
          gatkJar = indelRealign_gatkJar,
          modules = indelRealign_modules,
          timeout = indelRealign_timeout,
          cores = indelRealign_cores,
          overhead = indelRealign_overhead,
          jobMemory = indelRealign_jobMemory,
          additionalParams = indelRealign_additionalParams,
          knownAlleles = indelRealign_knownAlleles,
          bams = preprocessedBams,
          bamIndexes = preprocessedBamIndexes,
          intervals = intervals.intervalsList,
          targetIntervals = realignerTargetCreator.targetIntervals,
          reference = reference
      }
      Array[File] indelRealignedBams = indelRealign.indelRealignedBams
      Array[File] indelRealignedBamIndexes = indelRealign.indelRealignedBamIndexes
    }

    if(doBqsr) {
      call baseQualityScoreRecalibration {
        input:
          docker = docker,
          modules = baseQualityScoreRecalibration_modules,
          timeout = baseQualityScoreRecalibration_timeout,
          cores = baseQualityScoreRecalibration_cores,
          overhead = baseQualityScoreRecalibration_overhead,
          jobMemory = baseQualityScoreRecalibration_jobMemory,
          outputFileName = baseQualityScoreRecalibration_outputFileName,
          additionalParams = baseQualityScoreRecalibration_additionalParams,
          knownSites = baseQualityScoreRecalibration_knownSites,
          intervals = baseQualityScoreRecalibration_intervals,
          bams = select_first([indelRealignedBams, preprocessedBams]),
          reference = reference
      }
    }
    Array[File] processedBamsByInterval = select_first([indelRealignedBams, preprocessedBams])
    Array[File] processedBamIndexesByInterval = select_first([indelRealignedBamIndexes, preprocessedBamIndexes])
    File? recalibrationTableByInterval = baseQualityScoreRecalibration.recalibrationTable
  }
  Array[File] processedBams = flatten(processedBamsByInterval)
  Array[File] processedBamIndexes = flatten(processedBamIndexesByInterval)

  if(doBqsr) {
    call gatherBQSRReports {
      input:
        docker = docker,
        modules = gatherBQSRReports_modules,
        timeout = gatherBQSRReports_timeout,
        cores = gatherBQSRReports_cores,
        overhead = gatherBQSRReports_overhead,
        jobMemory = gatherBQSRReports_jobMemory,
        outputFileName = gatherBQSRReports_outputFileName,
        additionalParams = gatherBQSRReports_additionalParams,
        recalibrationTables = select_all(recalibrationTableByInterval)
    }

    call analyzeCovariates {
      input:
        docker = docker,
        modules = analyzeCovariates_modules,
        timeout = analyzeCovariates_timeout,
        cores = analyzeCovariates_cores,
        overhead = analyzeCovariates_overhead,
        jobMemory = analyzeCovariates_jobMemory,
        outputFileName = analyzeCovariates_outputFileName,
        additionalParams = analyzeCovariates_additionalParams,
        recalibrationTable = gatherBQSRReports.recalibrationTable
    }

    scatter(bam in processedBams) {
      call applyBaseQualityScoreRecalibration {
        input:
          docker = docker,
          modules = applyBaseQualityScoreRecalibration_modules,
          timeout = applyBaseQualityScoreRecalibration_timeout,
          cores = applyBaseQualityScoreRecalibration_cores,
          overhead = applyBaseQualityScoreRecalibration_overhead,
          jobMemory = applyBaseQualityScoreRecalibration_jobMemory,
          additionalParams = applyBaseQualityScoreRecalibration_additionalParams,
          suffix = applyBaseQualityScoreRecalibration_suffix,
          outputFileName = applyBaseQualityScoreRecalibration_outputFileName,
          recalibrationTable = gatherBQSRReports.recalibrationTable,
          bam = bam
      }
    }
    Array[File] recalibratedBams = applyBaseQualityScoreRecalibration.recalibratedBam
    Array[File] recalibratedBamIndexes = applyBaseQualityScoreRecalibration.recalibratedBamIndex
  }

  call collectFilesBySample {
    input:
      docker = docker,
      modules = collectFilesBySample_modules,
      timeout = collectFilesBySample_timeout,
      cores = collectFilesBySample_cores,
      jobMemory = collectFilesBySample_jobMemory,
      inputGroups = inputGroups,
      bams = select_first([recalibratedBams, processedBams]),
      bamIndexes = select_first([recalibratedBamIndexes, processedBamIndexes])
  }

  scatter(o in collectFilesBySample.filesByOutputIdentifier.collectionGroups) {
    if(length(o.bams) > 1) {
      call mergeBams as mergeSplitByIntervalBams {
        input:
          docker = docker,
          modules = mergeSplitByIntervalBams_modules,
          timeout = mergeSplitByIntervalBams_timeout,
          cores = mergeSplitByIntervalBams_cores,
          overhead = mergeSplitByIntervalBams_overhead,
          jobMemory = mergeSplitByIntervalBams_jobMemory,
          additionalParams = mergeSplitByIntervalBams_additionalParams,
          bams = o.bams,
          outputFileName = o.outputFileName,
          suffix = "" # collectFilesBySample task generates the file name
      }
    }
    OutputGroup outputGroup = { "outputIdentifier": o.outputIdentifier,
                                "bam": select_first([mergeSplitByIntervalBams.mergedBam, o.bams[0]]),
                                "bamIndex": select_first([mergeSplitByIntervalBams.mergedBamIndex, o.bamIndexes[0]])}
  }

  output {
    Array[OutputGroup] outputGroups = outputGroup
    File? recalibrationReport = analyzeCovariates.recalibrationReport
    File? recalibrationTable = gatherBQSRReports.recalibrationTable
  }
}

task splitStringToArray {
  input {
    String docker = "g3chen/wgspipeline@sha256:3c0c292c460c8db19b9744be1ea81529c4d189e4c4f9ca9a63046edcf792087d"
    String str
    String lineSeparator = ","
    String recordSeparator = "+"

    Int jobMemory = 1
    Int cores = 1
    Int timeout = 1
    String modules = "python/3.7"
  }

  command <<<
    source /home/ubuntu/.bashrc 
    ~{"module load " + modules + " || exit 20; "} 

    set -euo pipefail

    python3 <<CODE
    import json

    intervals = []
    for i in "~{str}".split("~{lineSeparator}"):
      interval = {"id": i, "intervalsList": i.split("~{recordSeparator}")}
      intervals.append(interval)

    # wrap intervals in intervalsList for cromwell
    print(json.dumps({"intervalsList": intervals}))
    CODE
  >>>

  output {
    # cromwell doesn't support read_json where the json is an array of objects...
    #Array[Intervals] intervals = read_json(stdout())
    IntervalsList intervalsList = read_json(stdout())
  }

  runtime {
    docker: "~{docker}"
    memory: "~{jobMemory} GB"
    cpu: "~{cores}"
    timeout: "~{timeout}"
    modules: "~{modules}"
  }

  parameter_meta {
    str: "Interval string to split (e.g. chr1,chr2,chr3+chr4)."
    lineSeparator: "Interval group separator - these are the intervals to split by."
    recordSeparator: "Interval interval group separator - this can be used to combine multiple intervals into one group."
    jobMemory: "Memory allocated to job (in GB)."
    cores: "The number of cores to allocate to the job."
    timeout: "Maximum amount of time (in hours) the task can run for."
    modules: "Environment module name and version to load (space separated) before command execution."
  }
}

task preprocessBam {
  input {
    String docker = "g3chen/wgspipeline@sha256:3c0c292c460c8db19b9744be1ea81529c4d189e4c4f9ca9a63046edcf792087d"
    Boolean doFilter = true
    Boolean doMarkDuplicates = true
    Boolean doSplitNCigarReads = false

    String outputFileName

    # by default write tmp files to the current working directory (cromwell task directory)
    # $TMPDIR is set by Cromwell
    # $TMP is set by Univa
    String temporaryWorkingDir = ""

    Array[File] bams
    Array[File] bamIndexes
    Array[String] intervals

    # filter parameters
    String filterSuffix = ".filter"
    Int filterFlags = 260
    Int? minMapQuality
    String? filterAdditionalParams

    # mark duplicates
    String markDuplicatesSuffix = ".deduped"
    Boolean removeDuplicates = false
    Int opticalDuplicatePixelDistance = 100
    String? markDuplicatesAdditionalParams

    # split N cigar reads
    String splitNCigarReadsSuffix = ".split"
    String reference
    Boolean refactorCigarString = false
    Array[String] readFilters = []
    String? splitNCigarReadsAdditionalParams

    RuntimeAttributes? runtimeAttributes
    DefaultRuntimeAttributes defaultRuntimeAttributes = {
      "memory": 24,
      "overhead": 6,
      "cores": 1,
      "timeout": 6,
      "modules": "samtools/1.9 gatk/4.1.6.0"
    }
  }

  # select_first doesn't like struct?.field? and winstanley doesn't like empty object "{}"
  RuntimeAttributes optionalRuntimeAttributes = select_first([runtimeAttributes, {"id":"using_defaults"}])

  # get provided runtime attributes or use defaults
  Int memory = select_first([optionalRuntimeAttributes.memory, defaultRuntimeAttributes.memory])
  Int overhead = select_first([optionalRuntimeAttributes.overhead, defaultRuntimeAttributes.overhead])
  Int cores = select_first([optionalRuntimeAttributes.cores, defaultRuntimeAttributes.cores])
  Int timeout = select_first([optionalRuntimeAttributes.timeout, defaultRuntimeAttributes.timeout])
  String modules = select_first([optionalRuntimeAttributes.modules, defaultRuntimeAttributes.modules])

  String workingDir = if temporaryWorkingDir == "" then "" else "~{temporaryWorkingDir}/"

  String baseFileName = "~{outputFileName}"

  String filteredFileName = if doFilter then
                            "~{baseFileName}.filter"
                           else
                            "~{baseFileName}"
  String filteredFilePath = if doMarkDuplicates || doSplitNCigarReads then
                            "~{workingDir}~{filteredFileName}"
                           else "~{filteredFileName}"

  String markDuplicatesFileName = if doMarkDuplicates then
                                  "~{filteredFileName}.deduped"
                                 else
                                  "~{filteredFileName}"
  String markDuplicatesFilePath = if doSplitNCigarReads then
                                  "~{workingDir}~{markDuplicatesFileName}"
                                 else
                                  "~{markDuplicatesFileName}"

  String splitNCigarReadsFileName = if doSplitNCigarReads then
                                    "~{markDuplicatesFileName}.split"
                                   else
                                    "~{markDuplicatesFileName}"
  String splitNCigarReadsFilePath = if false then # there are no downstream steps, so don't write to temp dir
                                    "~{workingDir}~{splitNCigarReadsFileName}"
                                   else
                                    "~{splitNCigarReadsFileName}"

  # workaround for this issue https://github.com/broadinstitute/cromwell/issues/5092
  # ~{sep = " " prefix("--read-filter ", readFilters)}
  Array[String] prefixedReadFilters = prefix("--read-filter ", readFilters)

  command <<<
    set -euxo pipefail
    inputBams="~{sep=" " bams}"
    inputBamIndexes="~{sep=" " bamIndexes}"

    # filter
    if [ "~{doFilter}" = true ]; then
      outputBams=()
      outputBamIndexes=()
      for inputBam in $inputBams; do
        filename="$(basename $inputBam ".bam")"
        outputBam="~{workingDir}${filename}.filtered.bam"
        outputBamIndex="~{workingDir}${filename}.filtered.bai"
        samtools view -b \
        -F ~{filterFlags} \
        ~{"-q " + minMapQuality} \
        ~{filterAdditionalParams} \
        $inputBam \
        ~{sep=" " intervals} > $outputBam
        samtools index $outputBam $outputBamIndex
        outputBams+=("$outputBam")
        outputBamIndexes+=("$outputBamIndex")
      done
      # set inputs for next step
      inputBams=("${outputBams[@]}")
      inputBamIndexes=("${outputBamIndexes[@]}")
    else
      outputBams=()
      outputBamIndexes=()
      for inputBam in $inputBams; do
        filename="$(basename $inputBam ".bam")"
        outputBam="~{workingDir}${filename}.bam"
        outputBamIndex="~{workingDir}${filename}.bai"
        samtools view -b \
        $inputBam \
        ~{sep=" " intervals} > $outputBam
        samtools index $outputBam $outputBamIndex
        outputBams+=("$outputBam")
        outputBamIndexes+=("$outputBamIndex")
      done
      # set inputs for next step
      inputBams=("${outputBams[@]}")
      inputBamIndexes=("${outputBamIndexes[@]}")
    fi

    # mark duplicates
    if [ "~{doMarkDuplicates}" = true ]; then
      outputBams=()
      outputBamIndexes=()
      gatk --java-options "-Xmx~{memory - overhead}G" MarkDuplicates \
      ${inputBams[@]/#/--INPUT } \
      --OUTPUT="~{markDuplicatesFilePath}.bam" \
      --METRICS_FILE="~{outputFileName}.metrics" \
      --VALIDATION_STRINGENCY=SILENT \
      --REMOVE_DUPLICATES=~{removeDuplicates} \
      --OPTICAL_DUPLICATE_PIXEL_DISTANCE=~{opticalDuplicatePixelDistance} \
      --CREATE_INDEX=true \
      ~{markDuplicatesAdditionalParams}
      outputBams+=("~{markDuplicatesFilePath}.bam")
      outputBamIndexes+=("~{markDuplicatesFilePath}.bai")
      # set inputs for next step
      inputBams=("${outputBams[@]}")
      inputBamIndexes=("${outputBamIndexes[@]}")
    fi

    # split N cigar reads
    if [ "~{doSplitNCigarReads}" = true ]; then
      outputBams=()
      outputBamIndexes=()
      gatk --java-options "-Xmx~{memory - overhead}G" SplitNCigarReads \
      ${inputBams[@]/#/--input=} \
      --output="~{splitNCigarReadsFilePath}.bam" \
      --reference ~{reference} \
      ~{sep=" " prefix("--intervals ", intervals)} \
      ~{sep=" " prefixedReadFilters} \
      --create-output-bam-index true \
      --refactor-cigar-string ~{refactorCigarString} \
      ~{splitNCigarReadsAdditionalParams}
      outputBams+=("~{splitNCigarReadsFilePath}.bam")
      outputBamIndexes+=("~{splitNCigarReadsFilePath}.bai")
      # set inputs for next step
      inputBams=("${outputBams[@]}")
      inputBamIndexes=("${outputBamIndexes[@]}")
    fi

    # catch all - need to merge filtered+split bams if MarkDuplicates or SplitNCigarReads isn't called
    if [ "~{doMarkDuplicates}" = false ] && [ "~{doSplitNCigarReads}" = false ]; then
      gatk --java-options "-Xmx~{memory - overhead}G" MergeSamFiles \
      ${inputBams[@]/#/--INPUT=} \
      --OUTPUT="~{filteredFileName}.bam" \
      --CREATE_INDEX=true \
      --SORT_ORDER=coordinate \
      --ASSUME_SORTED=false \
      --USE_THREADING=true \
      --VALIDATION_STRINGENCY=SILENT
    fi
  >>>

  output {
    File preprocessedBam = if doSplitNCigarReads then
                            "~{splitNCigarReadsFilePath}.bam"
                           else if doMarkDuplicates then
                            "~{markDuplicatesFilePath}.bam"
                           else if doFilter then
                            "~{filteredFilePath}.bam"
                           else "~{filteredFileName}.bam"
    File preprocessedBamIndex = if doSplitNCigarReads then
                                  "~{splitNCigarReadsFilePath}.bai"
                                else if doMarkDuplicates then
                                  "~{markDuplicatesFilePath}.bai"
                                else if doFilter then
                                  "~{filteredFilePath}.bai"
                                else "~{filteredFileName}.bai"
    File? markDuplicateMetrics = "~{outputFileName}.metrics"
  }

  runtime {
    docker: "~{docker}"
    memory: "~{memory} GB"
    cpu: "~{cores}"
    timeout: "~{timeout}"
    modules: "~{modules}"
  }

  parameter_meta {
    doFilter: "Enable/disable Samtools filtering."
    doMarkDuplicates: "Enable/disable GATK4 MarkDuplicates."
    doSplitNCigarReads: "Enable/disable GATK4 SplitNCigarReads."
    outputFileName: "Output files will be prefixed with this."
    temporaryWorkingDir: "Where to write out intermediary bam files. Only the final preprocessed bam will be written to task working directory if this is set to local tmp."
    bams: "Array of bam files to merge together."
    bamIndexes: "Array of index files for input bams."
    intervals: "One or more genomic intervals over which to operate."
    filterSuffix: "Suffix to use for filtered bams."
    filterFlags: "Samtools filter flags to apply."
    minMapQuality: "Samtools minimum mapping quality filter to apply."
    filterAdditionalParams: "Additional parameters to pass to samtools."
    markDuplicatesSuffix: "Suffix to use for duplicate marked bams."
    removeDuplicates: "MarkDuplicates remove duplicates?"
    opticalDuplicatePixelDistance: "MarkDuplicates optical distance."
    markDuplicatesAdditionalParams: "Additional parameters to pass to GATK MarkDuplicates."
    splitNCigarReadsSuffix: "Suffix to use for SplitNCigarReads bams."
    reference: "Path to reference file."
    refactorCigarString: "SplitNCigarReads refactor cigar string?"
    readFilters: "SplitNCigarReads read filters"
    splitNCigarReadsAdditionalParams: "Additional parameters to pass to GATK SplitNCigarReads."
    runtimeAttributes: "Override default runtime attributes using this parameter (see parameter defaultRuntimeAttributes)."
    defaultRuntimeAttributes: "Default runtime attributes (memory in GB, overhead in GB, cores in cpu count, timeout in hours, modules are environment modules to load before the task executes)."
  }
}

task mergeBams {
  input {
    String docker = "g3chen/wgspipeline@sha256:3c0c292c460c8db19b9744be1ea81529c4d189e4c4f9ca9a63046edcf792087d"
    Array[File] bams
    String outputFileName
    String suffix = ".merge"
    String? additionalParams

    Int jobMemory = 24
    Int overhead = 6
    Int cores = 1
    Int timeout = 6
    String modules = "gatk/4.1.6.0"
  }

  command <<<
    source /home/ubuntu/.bashrc 
    ~{"module load " + modules + " || exit 20; "} 

    set -euo pipefail

    gatk --java-options "-Xmx~{jobMemory - overhead}G" MergeSamFiles \
    ~{sep=" " prefix("--INPUT=", bams)} \
    --OUTPUT="~{outputFileName}~{suffix}.bam" \
    --CREATE_INDEX=true \
    --SORT_ORDER=coordinate \
    --ASSUME_SORTED=false \
    --USE_THREADING=true \
    --VALIDATION_STRINGENCY=SILENT \
    ~{additionalParams}
  >>>

  output {
    File mergedBam = "~{outputFileName}~{suffix}.bam"
    File mergedBamIndex = "~{outputFileName}~{suffix}.bai"
  }

  runtime {
    docker: "~{docker}"
    memory: "~{jobMemory} GB"
    cpu: "~{cores}"
    timeout: "~{timeout}"
    modules: "~{modules}"
  }

  parameter_meta {
    bams: "Array of bam files to merge together."
    outputFileName: "Output files will be prefixed with this."
    additionalParams: "Additional parameters to pass to GATK MergeSamFiles."
    jobMemory: "Memory allocated to job (in GB)."
    overhead: "Java overhead memory (in GB). jobMemory - overhead == java Xmx/heap memory."
    cores: "The number of cores to allocate to the job."
    timeout: "Maximum amount of time (in hours) the task can run for."
    modules: "Environment module name and version to load (space separated) before command execution."
  }
}

task realignerTargetCreator {
  input {
    String docker = "g3chen/wgspipeline@sha256:3c0c292c460c8db19b9744be1ea81529c4d189e4c4f9ca9a63046edcf792087d"
    Array[File] bams
    Array[File] bamIndexes
    String reference
    Array[String] knownIndels
    Array[String] intervals
    String? downsamplingType
    String? additionalParams

    Int jobMemory = 24
    Int overhead = 6
    Int cores = 1
    Int timeout = 6

    # use gatk3 for now: https://github.com/broadinstitute/gatk/issues/3104
    String modules = "gatk/3.6-0"
    String gatkJar = "$GATK_ROOT/GenomeAnalysisTK.jar"
  }

  command <<<
    source /home/ubuntu/.bashrc 
    ~{"module load " + modules + " || exit 20; "} 

    set -euo pipefail

    java -Xmx~{jobMemory - overhead}G -jar ~{gatkJar} --analysis_type RealignerTargetCreator \
    --reference_sequence ~{reference} \
    ~{sep=" " prefix("--intervals ", intervals)} \
    ~{sep=" " prefix("--input_file ", bams)} \
    ~{sep=" " prefix("--known ", knownIndels)} \
    --out realignerTargetCreator.intervals \
    ~{"--downsampling_type " + downsamplingType} \
    ~{additionalParams}
  >>>

  output {
    File targetIntervals = "realignerTargetCreator.intervals"
  }

  runtime {
    docker: "~{docker}"
    memory: "~{jobMemory} GB"
    cpu: "~{cores}"
    timeout: "~{timeout}"
    modules: "~{modules}"
  }

  parameter_meta {
    bams: "Array of bam files to produce RTC intervals for."
    bamIndexes: "Array of index files for input bams."
    reference: "Path to reference file."
    knownIndels: "Array of input VCF files with known indels."
    intervals: "One or more genomic intervals over which to operate."
    downsamplingType: "Type of read downsampling to employ at a given locus (NONE|ALL_READS|BY_SAMPLE)."
    additionalParams: "Additional parameters to pass to GATK RealignerTargetCreator."
    jobMemory:  "Memory allocated to job (in GB)."
    overhead: "Java overhead memory (in GB). jobMemory - overhead == java Xmx/heap memory."
    cores: "The number of cores to allocate to the job."
    timeout: "Maximum amount of time (in hours) the task can run for."
    modules: "Environment module name and version to load (space separated) before command execution."
    gatkJar: "Path to GATK jar."
  }
}

task indelRealign {
  input {
    String docker = "g3chen/wgspipeline@sha256:3c0c292c460c8db19b9744be1ea81529c4d189e4c4f9ca9a63046edcf792087d"
    Array[File] bams
    Array[File] bamIndexes
    Array[String] intervals
    String reference
    Array[String] knownAlleles
    File targetIntervals
    String? additionalParams

    Int jobMemory = 24
    Int overhead = 6
    Int cores = 1
    Int timeout = 6

    # use gatk3 for now: https://github.com/broadinstitute/gatk/issues/3104
    String modules = "python/3.7 gatk/3.6-0"
    String gatkJar = "$GATK_ROOT/GenomeAnalysisTK.jar"
  }

  command <<<
    source /home/ubuntu/.bashrc 
    ~{"module load " + modules + " || exit 20; "} 

    set -euo pipefail

    # generate gatk nWayOut file
    python3 <<CODE
    import os
    import csv

    with open('~{write_lines(bams)}') as f:
        bamFiles = f.read().splitlines()

    nWayOut = []
    for bam in bamFiles:
        fileName = os.path.basename(bam)
        realignedFileName = os.path.splitext(fileName)[0] + ".realigned.bam"
        nWayOut.append([fileName, realignedFileName])

    with open('input_output.map', 'w') as f:
        tsv_writer = csv.writer(f, delimiter='\t')
        tsv_writer.writerows(nWayOut)
    CODE

    java -Xmx~{jobMemory - overhead}G -jar ~{gatkJar} --analysis_type IndelRealigner \
    --reference_sequence ~{reference} \
    ~{sep=" " prefix("--intervals ", intervals)} \
    ~{sep=" " prefix("--input_file ", bams)} \
    --targetIntervals ~{targetIntervals} \
    ~{sep=" " prefix("--knownAlleles ", knownAlleles)} \
    --bam_compression 0 \
    --nWayOut input_output.map \
    ~{additionalParams}
  >>>

  output {
    Array[File] indelRealignedBams = glob("*.bam")
    Array[File] indelRealignedBamIndexes = glob("*.bai")
  }

  runtime {
    docker: "~{docker}"
    memory: "~{jobMemory} GB"
    cpu: "~{cores}"
    timeout: "~{timeout}"
    modules: "~{modules}"
  }

  parameter_meta {
    bams: "Array of bam files to indel realign together."
    bamIndexes: "Array of index files for input bams."
    intervals: "One or more genomic intervals over which to operate."
    reference: "Path to reference file."
    knownAlleles: "Array of input VCF files with known indels."
    targetIntervals: "Intervals file output from RealignerTargetCreator."
    additionalParams: "Additional parameters to pass to GATK IndelRealigner."
    jobMemory:  "Memory allocated to job (in GB)."
    overhead: "Java overhead memory (in GB). jobMemory - overhead == java Xmx/heap memory."
    cores: "The number of cores to allocate to the job."
    timeout: "Maximum amount of time (in hours) the task can run for."
    modules: "Environment module name and version to load (space separated) before command execution."
    gatkJar: "Path to GATK jar."
  }
}

task baseQualityScoreRecalibration {
  input {
    String docker = "g3chen/wgspipeline@sha256:3c0c292c460c8db19b9744be1ea81529c4d189e4c4f9ca9a63046edcf792087d"
    Array[File] bams
    String reference
    Array[String] intervals = []
    Array[String] knownSites
    String? additionalParams
    String outputFileName = "gatk.recalibration.csv"

    Int jobMemory = 24
    Int overhead = 6
    Int cores = 1
    Int timeout = 6
    String modules = "gatk/4.1.6.0"
  }

  # workaround for this issue https://github.com/broadinstitute/cromwell/issues/5092
  # ~{sep=" " prefix("--intervals ", intervals)}
  Array[String] prefixedIntervals = prefix("--intervals ", intervals)

  command <<<
    source /home/ubuntu/.bashrc 
    ~{"module load " + modules + " || exit 20; "} 

    set -euo pipefail

    gatk --java-options "-Xmx~{jobMemory - overhead}G" BaseRecalibrator \
    --reference ~{reference} \
    ~{sep=" " prefixedIntervals} \
    ~{sep=" " prefix("--input=", bams)} \
    ~{sep=" " prefix("--known-sites ", knownSites)} \
    --output=~{outputFileName} \
    ~{additionalParams}
  >>>

  output {
    File recalibrationTable = outputFileName
  }

  runtime {
    docker: "~{docker}"
    memory: "~{jobMemory} GB"
    cpu: "~{cores}"
    timeout: "~{timeout}"
    modules: "~{modules}"
  }

  parameter_meta {
    bams: "Array of bam files to produce a recalibration table for."
    reference: "Path to reference file."
    intervals: "One or more genomic intervals over which to operate."
    knownSites: "Array of VCF with known polymorphic sites used to exclude regions around known polymorphisms from analysis."
    additionalParams: "Additional parameters to pass to GATK BaseRecalibrator."
    outputFileName: "Recalibration table file name."
    jobMemory:  "Memory allocated to job (in GB)."
    overhead: "Java overhead memory (in GB). jobMemory - overhead == java Xmx/heap memory."
    cores: "The number of cores to allocate to the job."
    timeout: "Maximum amount of time (in hours) the task can run for."
    modules: "Environment module name and version to load (space separated) before command execution."
  }
}

task gatherBQSRReports {
  input {
    String docker = "g3chen/wgspipeline@sha256:3c0c292c460c8db19b9744be1ea81529c4d189e4c4f9ca9a63046edcf792087d"
    Array[File] recalibrationTables
    String? additionalParams
    String outputFileName = "gatk.recalibration.csv"

    Int jobMemory = 24
    Int overhead = 6
    Int cores = 1
    Int timeout = 6
    String modules = "gatk/4.1.6.0"
  }

  command <<<
    source /home/ubuntu/.bashrc 
    ~{"module load " + modules + " || exit 20; "} 

    set -euo pipefail

    gatk --java-options "-Xmx~{jobMemory - overhead}G" GatherBQSRReports \
    ~{sep=" " prefix("--input=", recalibrationTables)} \
    --output ~{outputFileName} \
    ~{additionalParams}
  >>>

  output {
    File recalibrationTable = outputFileName
  }

  runtime {
    docker: "~{docker}"
    memory: "~{jobMemory} GB"
    cpu: "~{cores}"
    timeout: "~{timeout}"
    modules: "~{modules}"
  }

  parameter_meta {
    recalibrationTables: "Array of recalibration tables to merge."
    additionalParams: "Additional parameters to pass to GATK GatherBQSRReports."
    outputFileName: "Recalibration table file name."
    jobMemory:  "Memory allocated to job (in GB)."
    overhead: "Java overhead memory (in GB). jobMemory - overhead == java Xmx/heap memory."
    cores: "The number of cores to allocate to the job."
    timeout: "Maximum amount of time (in hours) the task can run for."
    modules: "Environment module name and version to load (space separated) before command execution."
  }
}

task analyzeCovariates {
  input {
    String docker = "g3chen/wgspipeline@sha256:3c0c292c460c8db19b9744be1ea81529c4d189e4c4f9ca9a63046edcf792087d"
    File recalibrationTable
    String? additionalParams
    String outputFileName = "gatk.recalibration.pdf"

    Int jobMemory = 24
    Int overhead = 6
    Int cores = 1
    Int timeout = 6
    String modules = "gatk/4.1.6.0"
  }

  command <<<
    source /home/ubuntu/.bashrc 
    ~{"module load " + modules + " || exit 20; "} 

    set -euo pipefail

    gatk --java-options "-Xmx~{jobMemory - overhead}G" AnalyzeCovariates \
    --bqsr-recal-file=~{recalibrationTable} \
    --plots-report-file ~{outputFileName} \
    ~{additionalParams}
  >>>

  output {
    File recalibrationReport = outputFileName
  }

  runtime {
    docker: "~{docker}"
    memory: "~{jobMemory} GB"
    cpu: "~{cores}"
    timeout: "~{timeout}"
    modules: "~{modules}"
  }

  parameter_meta {
    recalibrationTable: "Recalibration table to produce report for."
    additionalParams: "Additional parameters to pass to GATK AnalyzeCovariates"
    outputFileName: "Recalibration report file name."
    jobMemory:  "Memory allocated to job (in GB)."
    overhead: "Java overhead memory (in GB). jobMemory - overhead == java Xmx/heap memory."
    cores: "The number of cores to allocate to the job."
    timeout: "Maximum amount of time (in hours) the task can run for."
    modules: "Environment module name and version to load (space separated) before command execution."
  }
}

task applyBaseQualityScoreRecalibration {
  input {
    String docker = "g3chen/wgspipeline@sha256:3c0c292c460c8db19b9744be1ea81529c4d189e4c4f9ca9a63046edcf792087d"
    File recalibrationTable
    File bam
    String outputFileName = basename(bam, ".bam")
    String suffix = ".recalibrated"
    String? additionalParams

    Int jobMemory = 24
    Int overhead = 6
    Int cores = 1
    Int timeout = 6
    String modules = "gatk/4.1.6.0"
  }

  command <<<
    source /home/ubuntu/.bashrc 
    ~{"module load " + modules + " || exit 20; "} 

    set -euo pipefail

    gatk --java-options "-Xmx~{jobMemory - overhead}G" ApplyBQSR \
    --bqsr-recal-file=~{recalibrationTable} \
    ~{sep=" " prefix("--input=", [bam])} \
    --output ~{outputFileName}~{suffix}.bam \
    ~{additionalParams}
  >>>

  output {
    File recalibratedBam = outputFileName + suffix + ".bam"
    File recalibratedBamIndex = outputFileName + suffix + ".bai"
  }

  runtime {
    docker: "~{docker}"
    memory: "~{jobMemory} GB"
    cpu: "~{cores}"
    timeout: "~{timeout}"
    modules: "~{modules}"
  }

  parameter_meta {
    recalibrationTable: "Recalibration table to apply to all input bams."
    bam: "Bam file to recalibrate."
    outputFileName: "Output files will be prefixed with this."
    suffix: "Suffix to use for recalibrated bams."
    additionalParams: "Additional parameters to pass to GATK ApplyBQSR."
    jobMemory:  "Memory allocated to job (in GB)."
    overhead: "Java overhead memory (in GB). jobMemory - overhead == java Xmx/heap memory."
    cores: "The number of cores to allocate to the job."
    timeout: "Maximum amount of time (in hours) the task can run for."
    modules: "Environment module name and version to load (space separated) before command execution."
  }
}

task collectFilesBySample {
  input {
    String docker = "g3chen/wgspipeline@sha256:3c0c292c460c8db19b9744be1ea81529c4d189e4c4f9ca9a63046edcf792087d"
    Array[InputGroup] inputGroups
    Array[File] bams
    Array[File] bamIndexes

    Int jobMemory = 1
    Int cores = 1
    Int timeout = 1
    String modules = "python/3.7"
  }

  InputGroups wrappedInputGroups = {"inputGroups": inputGroups}

  command <<<
    source /home/ubuntu/.bashrc 
    ~{"module load " + modules + " || exit 20; "} 

    set -euo pipefail

    python3 <<CODE
    import json
    import os
    import re

    with open('~{write_json(wrappedInputGroups)}') as f:
        inputGroups = json.load(f)
    with open('~{write_lines(bams)}') as f:
        bamFiles = f.read().splitlines()
    with open('~{write_lines(bamIndexes)}') as f:
        bamIndexFiles = f.read().splitlines()

    filesByOutputIdentifier = []
    for outputIdentifier in [inputGroup['outputIdentifier'] for inputGroup in inputGroups['inputGroups']]:
        # select bams and bamIndexes for outputIdentifier (preprocessBam prefixes the outputIdentifier, so include that too)
        bams = [bam for bam in bamFiles if re.match("^" + outputIdentifier + "\.", os.path.basename(bam))]
        bais = [bai for bai in bamIndexFiles if re.match("^" + outputIdentifier + "\.", os.path.basename(bai))]

        fileNames = list(set([os.path.splitext(os.path.basename(f))[0] for f in bams + bais]))
        if len(fileNames) != 1:
            raise Exception("Unable to determine unique fileName from fileNames = [" + ','.join(f for f in fileNames) + "]")
        else:
            fileName = fileNames[0]

        filesByOutputIdentifier.append({
            'outputIdentifier': outputIdentifier,
            'outputFileName': fileName,
            'bams': bams,
            'bamIndexes': bais})

    # wrap the array into collectionGroups object
    wrappedFilesByOutputIdentifier = {'collectionGroups': filesByOutputIdentifier}

    with open('filesByOutputIdentifier.json', 'w') as f:
        json.dump(wrappedFilesByOutputIdentifier, f, indent=4)
    CODE
  >>>

  output {
    CollectionGroups filesByOutputIdentifier = read_json("filesByOutputIdentifier.json")
  }

  runtime {
    docker: "~{docker}"
    memory: "~{jobMemory} GB"
    cpu: "~{cores}"
    timeout: "~{timeout}"
    modules: "~{modules}"
  }

  parameter_meta {
    inputGroups: "Array of objects describing output file groups. The output file group name is used to partition input bams by name."
    bams: "Array of bams to partition by inputGroup output file name."
    bamIndexes: "Array of index files for input bams."
    jobMemory:  "Memory allocated to job (in GB)."
    cores: "The number of cores to allocate to the job."
    timeout: "Maximum amount of time (in hours) the task can run for."
    modules: "Environment module name and version to load (space separated) before command execution."
  }
}

struct BamAndBamIndex {
  File bam
  File bamIndex
}

struct InputGroup {
  String outputIdentifier
  Array[BamAndBamIndex]+ bamAndBamIndexInputs
}

struct InputGroups {
  Array[InputGroup] inputGroups
}

struct CollectionGroup {
  String outputIdentifier
  String outputFileName
  Array[File] bams
  Array[File] bamIndexes
}

struct CollectionGroups {
  Array[CollectionGroup] collectionGroups
}

struct OutputGroup {
  String outputIdentifier
  File bam
  File bamIndex
}

struct RuntimeAttributes {
  Int? memory
  Int? overhead
  Int? cores
  Int? timeout
  String? modules
  String? id # optional internal id
}

struct DefaultRuntimeAttributes {
  Int memory
  Int overhead
  Int cores
  Int timeout
  String modules
}

struct Intervals {
  String id
  Array[String] intervalsList
}

struct IntervalsList {
  Array[Intervals] intervalsList
}
