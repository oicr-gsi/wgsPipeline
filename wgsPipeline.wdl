version 1.0

# imports workflows for the top portion of WGSPipeline
import "dockstore_imports/dockstore_bcl2fastq.wdl" as bcl2fastq
import "dockstore_imports/dockstore_fastqc.wdl" as fastQC
import "dockstore_imports/dockstore_bwaMem.wdl" as bwaMem
import "dockstore_imports/dockstore_bamQC.wdl" as bamQC
import "dockstore_imports/dockstore_bamMergePreprocessing.wdl" as bamMergePreprocessing 
import "dockstore_imports/dockstore_callability.wdl" as callability 
import "dockstore_imports/dockstore_insertSizeMetrics.wdl" as insertSizeMetrics
import "dockstore_imports/dockstore_wgsMetrics.wdl" as wgsMetrics
# import "" as sampleFingerprinting       # @@@ no WDL available

# imports workflows for the bottom portion of WGSPipeline
# import "imports/dockstore_sequenza.wdl" as sequenza
# import "imports/dockstore_delly.wdl" as delly
# import "" as mavis                      # @@@ qsub run not compatible with docker
# import "imports/dockstore_haplotypecaller.wdl" as haplotypeCaller
# import "" as genotypegVCF               # @@@ no WDL available
# import "imports/dockstore_variantEffectPredictor.wdl" as vep
# import "imports/dockstore_mutect2GATK4.wdl" as mutect2
# import "" as janusMutationExtended      # @@@ no WDL available
# import "" as janusCopyNumberAlteration  # @@@ no WDL available
# import "" as janusFusion                # @@@ no WDL available

struct bcl2fastqMeta {
  Array[Sample]+ samples  # Sample: {Array[String]+, String}
  Array[Int] lanes
  String runDirectory
}

struct bwaMemMeta {
  String readGroups
  # possibly add more parameters here like outputFileNamePrefix
}

struct bamQCMeta {
  Map[String, String] metadata
  # possibly add more parameters here like outputFileNamePrefix
}

struct FastqInput {
  String name
  Array[File] fastqs
}

workflow wgsPipeline {
  input {
    Boolean doBcl2fastq = true
    Array[bcl2fastqMeta]? bcl2fastqMetas
    Array[FastqInput]? fastqInputs
    Array[bwaMemMeta] bwaMemMetas
    Array[bamQCMeta] rawBamQCMetas  
    Array[bamQCMeta] processedBamQCMetas  
  }

  parameter_meta {
    skipBcl2fastq: "Whether to use fastqs or bcls"
    bcl2fastqMetas: "Samples, lanes, and runDirectory for bcl2fastq"
    fastqInputs: "Name and list of fastqs"
    bwaMemMetas: "ReadGroups for bwaMemMeta"
    rawBamQCMetas: "Metadata for the raw bamQC run"
    processedBamQCMetas: "Metadata for the processed bamQC run"
  }

  meta {
    author: "Fenglin Chen"
    email: "g3chen@oicr.on.ca"
    description: "Wrapper workflow for the WGS Analysis Pipeline"
    dependencies: [
      {
        name: "bcl2fastq",
        url: "https://emea.support.illumina.com/sequencing/sequencing_software/bcl2fastq-conversion-software.html"
      },
      {
        name: "fastqc/0.11.8",
        url: "https://www.bioinformatics.babraham.ac.uk/projects/fastqc/"
      },
      {
        name: "bwa/0.7.12",
        url: "https://github.com/lh3/bwa/archive/0.7.12.tar.gz"
      },
      {
        name: "samtools/1.9",
        url: "https://github.com/samtools/samtools/archive/0.1.19.tar.gz"
      },
      {
        name: "cutadapt/1.8.3",
        url: "https://cutadapt.readthedocs.io/en/v1.8.3/"
      },
      {
        name: "slicer/0.3.0",
        url: "https://github.com/OpenGene/slicer/archive/v0.3.0.tar.gz"
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
      },
      {
        name: "bedtools/2.27",
        url: "https://bedtools.readthedocs.io/en/latest/"
      },
      {
        name: "rstats/3.6",
        url: "https://www.r-project.org/"
      }
    ]
    output_meta: {
      fastQC_html_report_R1: "HTML report for the first mate fastq file.",
      fastQC_zip_bundle_R1: "zipped report from FastQC for the first mate reads.",
      fastQC_html_report_R2: "HTML report for read second mate fastq file.",
      fastQC_zip_bundle_R2: "zipped report from FastQC for the second mate reads.",
      bwaMem_log: "a summary log file for adapter trimming.",
      bwaMem_cutAdaptAllLogs: "a file containing all logs for adapter trimming for each fastq chunk.",
      rawBamQC_result: "JSON file of collated results.",
      bamMergePreprocessing_recalibrationReport: "Recalibration report pdf (if BQSR enabled).",
      bamMergePreprocessing_recalibrationTable: "Recalibration csv that was used by BQSR (if BQSR enabled).",
      callability_callabilityMetrics: "Json file with pass, fail and callability percent (# of pass bases / # total bases).",
      insertSizeMetrics_insertSizeMetrics: "Metrics about the insert size distribution (see https://broadinstitute.github.io/picard/picard-metric-definitions.html#InsertSizeMetrics).",
      insertSizeMetrics_histogramReport: "Insert size distribution plot.",
      wgsMetrics_outputWGSMetrics: "Metrics about the fractions of reads that pass base and mapping-quality filters as well as coverage (read-depth) levels (see https://broadinstitute.github.io/picard/picard-metric-definitions.html#CollectWgsMetrics.WgsMetrics).",
      processedBamQC_result: "JSON file of collated results."
    }
  }

  # scatter over [normal, tumor]
  scatter (index in [0, 1]){
    if (doBcl2fastq) {
      bcl2fastqMeta bcl2fastqMeta = select_first([bcl2fastqMetas])[index]
      call bcl2fastq.bcl2fastq {
        input:
          samples = bcl2fastqMeta.samples,
          lanes = bcl2fastqMeta.lanes,
          runDirectory = bcl2fastqMeta.runDirectory
        }
    }

    File fastqR1 = if doBcl2fastq then select_first([bcl2fastq.fastqs])[0].fastqs.left[0] else select_first([fastqInputs])[index].fastqs[0]
    File fastqR2 = if doBcl2fastq then select_first([bcl2fastq.fastqs])[0].fastqs.left[1] else select_first([fastqInputs])[index].fastqs[1]
    String name = if doBcl2fastq then select_first([bcl2fastq.fastqs])[0].name else select_first([fastqInputs])[index].name

    call fastQC.fastQC {
      input:
        fastqR1 = fastqR1,   # File
        fastqR2 = fastqR2    # File
    }

    bwaMemMeta bwaMemMeta = bwaMemMetas[index]
    call bwaMem.bwaMem {
      input:
        fastqR1 = fastqR1,   # File
        fastqR2 = fastqR2,   # File
        readGroups = bwaMemMeta.readGroups   # String
    }    

    call linkBamAndBamIndex {
      input:
        bam = bwaMem.bwaMemBam,
        bamIndex = bwaMem.bwaMemIndex
    }

    BamAndBamIndex bamAndBamIndex = object {
      bam: linkBamAndBamIndex.linkedBam,
      bamIndex: linkBamAndBamIndex.linkedBamIndex
    }

    InputGroup inputGroup = object {
      outputIdentifier: name,
      bamAndBamIndexInputs: [
        bamAndBamIndex
      ]
    }

    bamQCMeta rawBamQCMeta = rawBamQCMetas[index]
    call bamQC.bamQC as rawBamQC {
      input:
        bamFile = bwaMem.bwaMemBam,          # File
        metadata = rawBamQCMeta.metadata,    # Map[String, String]
    }
  }

  Array[InputGroup] inputGroups = inputGroup # congregate results from first 4 workflows

  call bamMergePreprocessing.bamMergePreprocessing {
    input:
      inputGroups = inputGroups
  }
    
  Array[OutputGroup] outputGroups = bamMergePreprocessing.outputGroups 
  
  call callability.callability {
    input:
      normalBam = outputGroups[0].bam,
      normalBamIndex = outputGroups[0].bamIndex,
      tumorBam = outputGroups[1].bam,
      tumorBamIndex = outputGroups[1].bamIndex
  }

  # scatter over [normal, tumor]
  scatter (index in [0, 1]){

    OutputGroup outputGroup = outputGroups[index]

    call insertSizeMetrics.insertSizeMetrics {
      input:
        inputBam = outputGroup.bam,
        outputFileNamePrefix = outputGroup.outputIdentifier
    }

    call wgsMetrics.wgsMetrics {
      input: 
        inputBam = outputGroup.bam,
        outputFileNamePrefix = outputGroup.outputIdentifier
    }

    bamQCMeta processedBamQCMeta = processedBamQCMetas[index]

    call bamQC.bamQC as processedBamQC {
      input:
        bamFile = outputGroup.bam,
        metadata = processedBamQCMeta.metadata  # Map[String, String]
    }
  }

  output {
    # fastQC
    Array[File?] fastQC_html_report_R1  = fastQC.html_report_R1
    Array[File?] fastQC_zip_bundle_R1   = fastQC.zip_bundle_R1
    Array[File?] fastQC_html_report_R2 = fastQC.html_report_R2
    Array[File?] fastQC_zip_bundle_R2  = fastQC.zip_bundle_R2
  
    # bwaMem
    Array[File?] bwaMem_log = bwaMem.log
    Array[File?] bwaMem_cutAdaptAllLogs = bwaMem.cutAdaptAllLogs

    # bamQC
    Array[File] rawBamQC_result = rawBamQC.result

    # bamMergePreprocessing
    File? bamMergePreprocessing_recalibrationReport = bamMergePreprocessing.recalibrationReport
    File? bamMergePreprocessing_recalibrationTable = bamMergePreprocessing.recalibrationTable

    # callability
    File callability_callabilityMetrics = callability.callabilityMetrics

    # insertSizeMetrics
    Array[File] insertSizeMetrics_insertSizeMetrics = insertSizeMetrics.insertSizeMetrics
    Array[File] insertSizeMetrics_histogramReport = insertSizeMetrics.histogramReport

    # wgsMetrics
    Array[File] wgsMetrics_outputWGSMetrics = wgsMetrics.outputWGSMetrics

    # bamQC
    Array[File] processedBamQC_result = processedBamQC.result
  }
}

task linkBamAndBamIndex {
  input {
    File bam
    File bamIndex
  }

  command <<<
    ln -s ~{bam} "~{basename(bam)}"
    ln -s ~{bamIndex} "~{basename(bamIndex)}"
  >>>

  output {
    File linkedBam = "~{basename(bam)}"
    File linkedBamIndex = "~{basename(bamIndex)}"
  }
}