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
# import "" as sampleFingerprinting			# @@@ no WDL available

# imports workflows for the bottom portion of WGSPipeline
# import "imports/dockstore_sequenza.wdl" as sequenza
# import "imports/dockstore_delly.wdl" as delly
# import "" as mavis						# @@@ qsub run not compatible with docker
# import "imports/dockstore_haplotypecaller.wdl" as haplotypeCaller
# import "" as genotypegVCF					# @@@ no WDL available
# import "imports/dockstore_variantEffectPredictor.wdl" as vep
# import "imports/dockstore_mutect2GATK4.wdl" as mutect2
# import "" as janusMutationExtended		# @@@ no WDL available
# import "" as janusCopyNumberAlteration	# @@@ no WDL available
# import "" as janusFusion					# @@@ no WDL available

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
      # OUTPUT METAS
    }
  }

  call bcl2fastq.bcl2fastq {
    input:
      
  }

  call fastQC.fastQC {
    input:
      
  }

  call bwaMem.bwaMem {
    input:
      
  }

  call bamQC.bamQC {
    input:
      
  }

  call bamMergePreprocessing.bamMergePreprocessing {
    input:
      
  }

  call insertSizeMetrics.insertSizeMetrics {
    input:
      
  }

  call callability.callability {
    input:
      
  }

  call wgsMetrics.wgsMetrics {
    input:
      
  }

  output {
    # OUTPUTS
    # Bcl2fastq

    # FastQC

    # BwaMem

    # BamQC

    # BamMergePreprocess

    # Picard WGSMetrics

    # InsertSizeMetrics

    # Mutect Callability

    # SampleFingerprinting
    
  }
}