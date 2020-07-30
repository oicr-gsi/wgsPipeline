version 1.0

# imports workflows for the top portion of WGSPipeline
import "imports/dockstore_bcl2fastq.wdl" as bcl2fastq
import "imports/dockstore_fastqc.wdl" as fastQC
import "imports/dockstore_bwaMem.wdl" as bwaMem
import "imports/dockstore_bamQC.wdl" as bamQC

workflow top4 {
  input {
  }

  parameter_meta {
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
    File processedBamQC_result = processedBamQC.result
  }
}