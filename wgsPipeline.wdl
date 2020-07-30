version 1.0

# imports workflows for the top portion of WGSPipeline
import "imports/dockstore_bcl2fastq.wdl" as bcl2fastq
import "imports/dockstore_fastqc.wdl" as fastQC
import "imports/dockstore_bwaMem.wdl" as bwaMem
import "imports/dockstore_bamQC.wdl" as bamQC
import "imports/dockstore_bamMergePreprocessing.wdl" as bamMergePreprocessing
import "imports/dockstore_insertSizeMetrics.wdl" as insertSizeMetrics
import "imports/dockstore_callability.wdl" as callability
import "imports/dockstore_wgsMetrics.wdl" as wgsMetrics
# import "" as sampleFingerprinting			    # @@@ no WDL available

# imports workflows for the bottom portion of WGSPipeline
# import "imports/dockstore_sequenza.wdl" as sequenza
# import "imports/dockstore_delly.wdl" as delly
# import "" as mavis						            # @@@ qsub run not compatible with docker
# import "imports/dockstore_haplotypecaller.wdl" as haplotypeCaller
# import "" as genotypegVCF					        # @@@ no WDL available
# import "imports/dockstore_variantEffectPredictor.wdl" as vep
# import "imports/dockstore_mutect2GATK4.wdl" as mutect2
# import "" as janusMutationExtended		    # @@@ no WDL available
# import "" as janusCopyNumberAlteration	  # @@@ no WDL available
# import "" as janusFusion					        # @@@ no WDL available

workflow wgsPipeline {
  input {
    # universal inputs
  }

  parameter_meta {
    # parameter_metas, only for the universal inputs
  }

  meta {
    author: "Fenglin Chen"
    description: "Wrapper workflow for the WGS Analysis Pipeline"
    dependencies: [{
      name: "bcl2fastq",
      url: "https://emea.support.illumina.com/sequencing/sequencing_software/bcl2fastq-conversion-software.html"
    }
    # ALL DEPENDENCIES
    ]
    output_meta: {
      # bcl2fastq

      # fastQC

      # bwaMem

      # bamQC

      # bamMergePreprocessing

      # insertSizeMetrics

      # callability

      # wgsMetrics

    }
  }

  call bcl2fastq.bcl2fastq {}

  call fastQC.fastQC {
    input:
    # Array[Output]+ bcl2fastq_fastqs
      File fastqR1 
      File? fastqR2
  }

  call bwaMem.bwaMem {
    input:
    # Array[Output]+ bcl2fastq_fastqs
      File fastqR1
      File fastqR2
  }
  call bamQC.bamQC as rawBamQC {
    input:
      File bamFile = bwaMem.bwaMemBam
  }

  call bamMergePreprocessing.bamMergePreprocessing {
    input:    
    # "bamMergePreprocessing.inputGroups": [
    #   {
    #     "outputIdentifier": "PCSI0022",
    #     "bamAndBamIndexInputs": [
    #       {
    #         "bam": "/home/ubuntu/data/sample_data/bammergepreprocessing/PCSI0022C.val.bam",
    #         "bamIndex": "/home/ubuntu/data/sample_data/bammergepreprocessing/PCSI0022C.val.bam.bai"
    #       },
    #       {
    #         "bam": "/home/ubuntu/data/sample_data/bammergepreprocessing/PCSI0022P.val.bam",
    #         "bamIndex": "/home/ubuntu/data/sample_data/bammergepreprocessing/PCSI0022P.val.bam.bai"
    #       },
    #       {
    #         "bam": "/home/ubuntu/data/sample_data/bammergepreprocessing/PCSI0022R.val.bam",
    #         "bamIndex": "/home/ubuntu/data/sample_data/bammergepreprocessing/PCSI0022R.val.bai"
    #       },
    #       {
    #         "bam": "/home/ubuntu/data/sample_data/bammergepreprocessing/PCSI0022X.val.bam",
    #         "bamIndex": "/home/ubuntu/data/sample_data/bammergepreprocessing/PCSI0022X.val.bam.bai"
    #       }
    #     ]
    #   }
    # ]
      #File bwaMem_bwaMemBam = bwaMem.bwaMemBam
      #File bwaMem_bwaMemIndex = bwaMem.bwaMemIndex
      Array[InputGroup] inputGroups
    # "bamMergePreprocessing.preprocessingBamRuntimeAttributes": [
    #   {
    #     "id": "chr1",
    #     "memory": 21,
    #     "timeout": 1
    #   },
    #   {
    #     "id": "PCSI0022.chr2",
    #     "memory": 21,
    #     "timeout": 1
    #   },
    #   {
    #     "id": "*",
    #     "memory": 18,
    #     "timeout": 1
    #   }
    # ]
      Array[RuntimeAttributes] preprocessingBamRuntimeAttributes = []      
  }

  call bamQC.bamQC as processedBamQC {
    input:
    # Array[OutputGroup] bamMergePreprocessing_outputGroups
      File bamFile      
  }

  call insertSizeMetrics.insertSizeMetrics {
    input:
    # Array[OutputGroup] bamMergePreprocessing_outputGroups
      File inputBam      
  }

  call callability.callability {
    input:
    # Array[OutputGroup] bamMergePreprocessing_outputGroups
      File normalBam
      File normalBamIndex
      File tumorBam
      File tumorBamIndex
      File intervalFile      
  }

  call wgsMetrics.wgsMetrics {
    input:
    # Array[OutputGroup] bamMergePreprocessing_outputGroups
      File inputBam
  }

  output {
    # bcl2fastq
    # "bcl2fastq.fastqs": [{
    #   "fastqs": {
    #     "right": {
    #       "read_count": "528"
    #     },
    #     "left": ["/home/ubuntu/repos/wgsPipeline/cromwell-executions/bcl2fastq/2d9c661c-5fdf-4b73-8ee6-a90c9af8598d/call-process/execution/test_sample_R1.fastq.gz", "/home/ubuntu/repos/wgsPipeline/cromwell-executions/bcl2fastq/2d9c661c-5fdf-4b73-8ee6-a90c9af8598d/call-process/execution/test_sample_R2.fastq.gz"]
    #   },
    #   "name": "test_sample"
    # }]
    # Array[Output]+ bcl2fastq_fastqs = bcl2fastq.fastqs

    # fastQC FINAL OUTPUTS
    File? fastQC_html_report_R1  = fastQC.html_report_R1
    File? fastQC_zip_bundle_R1   = fastQC.zip_bundle_R1
    File? fastQC_html_report_R2 = fastQC.html_report_R2
    File? fastQC_zip_bundle_R2  = fastQC.zip_bundle_R2
    
    # bwaMem
    #File bwaMem_bwaMemBam = bwaMem.bwaMemBam
    # FINAL OUTPUTS
    #File bwaMem_bwaMemIndex = bwaMem.bwaMemIndex
    File? bwaMem_log = bwaMem.log
    File? bwaMem_cutAdaptAllLogs = bwaMem.cutAdaptAllLogs

    # bamQC FINAL OUTPUTS
    File rawBamQC_result = rawBamQC.result

    # bamMergePreprocessing
    #OutputGroup outputGroup = { "outputIdentifier": o.outputIdentifier,
    #                            "bam": select_first([mergeSplitByIntervalBams.mergedBam, o.bams[0]]),
    #                            "bamIndex": select_first([mergeSplitByIntervalBams.mergedBamIndex, o.bamIndexes[0]])}
    #Array[OutputGroup] bamMergePreprocessing_outputGroups = bamMergePreprocessing.outputGroup
    # FINAL OUTPUTS
    File? bamMergePreprocessing_recalibrationReport = bamMergePreprocessing.recalibrationReport
    File? bamMergePreprocessing_recalibrationTable = bamMergePreprocessing.recalibrationTable
    
    # insertSizeMetrics FINAL OUTPUTS
    File insertSizeMetrics_insertSizeMetrics = insertSizeMetrics.insertSizeMetrics
    File insertSizeMetrics_histogramReport = insertSizeMetrics.histogramReport

    # bamQC FINAL OUTPUTS
    File processedBamQC_result = processedBamQC.result

    # callability FINAL OUTPUTS
    File callability_callabilityMetrics = callability.callabilityMetrics

    # wgsMetrics FINAL OUTPUTS
    File wgsMetrics_outputWGSMetrics = wgsMetrics.outputWGSMetrics
  }
}