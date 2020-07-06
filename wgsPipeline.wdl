version 1.0

# imports workflows for the top portion of WGSPipeline
import "https://raw.githubusercontent.com/f73chen/WGSPipeline/master/workflows/bcl2fastq.wdl" as bcl2fastq
import "https://raw.githubusercontent.com/f73chen/WGSPipeline/master/workflows/fastqc.wdl" as fastqc
import "https://raw.githubusercontent.com/f73chen/WGSPipeline/master/workflows/bwaMem.wdl" as bwaMem
import "https://raw.githubusercontent.com/f73chen/WGSPipeline/master/workflows/bamQC.wdl" as bamQC
import "https://raw.githubusercontent.com/f73chen/WGSPipeline/master/workflows/bamMergePreprocessing.wdl" as bamMergePreprocessing
import "https://raw.githubusercontent.com/f73chen/WGSPipeline/master/workflows/insertSizeMetrics.wdl" as insertSizeMetrics
import "https://raw.githubusercontent.com/f73chen/WGSPipeline/master/workflows/callability.wdl" as callability
import "https://raw.githubusercontent.com/f73chen/WGSPipeline/master/workflows/wgsMetrics.wdl" as wgsMetrics

# imports workflows for the bottom portion of WGSPipeline

workflow wgsPipeline {
  input {
    # INPUTS
  }
  parameter_meta {
    # PARAMETER METAS
  }
  meta {
    author: "Fenglin Chen"
    description: "Workflow to produce FASTQ files from an Illumina instrument's run directory"
    dependencies: [{
      name: "bcl2fastq",
      url: "https://emea.support.illumina.com/sequencing/sequencing_software/bcl2fastq-conversion-software.html"
    }]
    output_meta: {
      fastqs: "A list of FASTQs generated and annotations that should be applied to them."
    }
  }
  call @@@@@@@@@@@{
    # CALL FUNCTIONS
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
