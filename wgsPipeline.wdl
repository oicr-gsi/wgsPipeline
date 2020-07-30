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
      File fastqR1 
      File? fastqR2
  }

  call bwaMem.bwaMem {
    input:
      File fastqR1
      File fastqR2
  }

  call bamQC.bamQC {
    input:
      File bamFile      
  }

  call bamMergePreprocessing.bamMergePreprocessing {
    input:    
      Array[InputGroup] inputGroups
      Array[RuntimeAttributes] preprocessingBamRuntimeAttributes = []      
  }

  call insertSizeMetrics.insertSizeMetrics {
    input:
      File inputBam      
  }

  call callability.callability {
    input:
      File normalBam
      File normalBamIndex
      File tumorBam
      File tumorBamIndex
      File intervalFile      
  }

  call wgsMetrics.wgsMetrics {
    input:
      File inputBam
  }

  output {
    # bcl2fastq
    Array[Output]+ bcl2fastq_fastqs = bcl2fastq.fastqs

    # fastQC
    File? fastQC_html_report_R1  = fastQC.html_report_R1
    File? fastQC_zip_bundle_R1   = fastQC.zip_bundle_R1
    File? fastQC_html_report_R2 = fastQC.html_report_R2
    File? fastQC_zip_bundle_R2  = fastQC.zip_bundle_R2
    
    # bwaMem
    File bwaMem_bwaMemBam = bwaMem.bwaMemBam
    File bwaMem_bwaMemIndex = bwaMem.bwaMemIndex
    File? bwaMem_log = bwaMem.log
    File? bwaMem_cutAdaptAllLogs = bwaMem.cutAdaptAllLogs

    # bamQC
    File bamQC_result = bamQC.result

    # bamMergePreprocessing
    Array[OutputGroup] bamMergePreprocessing_outputGroups = bamMergePreprocessing.outputGroup
    File? bamMergePreprocessing_recalibrationReport = bamMergePreprocessing.recalibrationReport
    File? bamMergePreprocessing_recalibrationTable = bamMergePreprocessing.recalibrationTable
    
    # insertSizeMetrics
    File insertSizeMetrics_insertSizeMetrics = insertSizeMetrics.insertSizeMetrics
    File insertSizeMetrics_histogramReport = insertSizeMetrics.histogramReport

    # callability
    File callability_callabilityMetrics = callability.callabilityMetrics

    # wgsMetrics
    File wgsMetrics_outputWGSMetrics = wgsMetrics.outputWGSMetrics
  }
}