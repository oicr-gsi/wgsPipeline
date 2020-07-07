version 1.0

# imports workflows for the top portion of WGSPipeline
import "https://raw.githubusercontent.com/f73chen/WGSPipeline/master/workflows/bcl2fastq.wdl" as Bcl2fastq
# import "https://raw.githubusercontent.com/f73chen/WGSPipeline/master/workflows/fastqc.wdl" as Fastqc
# import "https://raw.githubusercontent.com/f73chen/WGSPipeline/master/workflows/bwaMem.wdl" as BwaMem
# import "https://raw.githubusercontent.com/f73chen/WGSPipeline/master/workflows/bamQC.wdl" as BamQC
# import "https://raw.githubusercontent.com/f73chen/WGSPipeline/master/workflows/bamMergePreprocessing.wdl" as BamMergePreprocessing
# import "https://raw.githubusercontent.com/f73chen/WGSPipeline/master/workflows/insertSizeMetrics.wdl" as InsertSizeMetrics
# import "https://raw.githubusercontent.com/f73chen/WGSPipeline/master/workflows/callability.wdl" as Callability
# import "https://raw.githubusercontent.com/f73chen/WGSPipeline/master/workflows/wgsMetrics.wdl" as WgsMetrics
# Sample Fingerprinting

# imports workflows for the bottom portion of WGSPipeline
# Sequenza
# Delly
# Mavis
# Haplotype Caller
# Genotype gVCF
# Variant Effect Predictor
# Mutect2
# Janus:MutationExtended
# Janus:CopyNumberAlteration
# Janus:Fusion

workflow wgsPipeline {
  input {
    # INPUTS
  }
  parameter_meta {
    # PARAMETER METAS
  }
  meta {
    author: "Fenglin Chen"
    description: "Workflow to wrap the WGS Analysis Pipeline"
    dependencies: [{
      name: "bcl2fastq",
      url: "https://emea.support.illumina.com/sequencing/sequencing_software/bcl2fastq-conversion-software.html"
    }]
    output_meta: {
      fastqs: "A list of FASTQs generated and annotations that should be applied to them."
    }
  }
  call Bcl2fastq.bcl2fastq {
    input:
      
  }
  output {
    # OUTPUTS
  }
}

task @@@@@@@@@@@ {
  command {
    # COMMANDS
  }
  output {
    # OUTPUTS
  }
}
