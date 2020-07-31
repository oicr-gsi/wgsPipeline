version 1.0

# imports workflows for the top portion of WGSPipeline
import "imports/dockstore_bcl2fastq.wdl" as bcl2fastq
import "imports/dockstore_fastqc.wdl" as fastQC

workflow top4 {

  call bcl2fastq.bcl2fastq {}

  scatter (index in length(bcl2fastq.fastqs)) {  # bcl2fastq.fastqs = Array[Output]+  
    # {
    #   "fastqs": {
    #     "right": {
    #       "read_count": "528"
    #     },
    #     "left": ["/home/ubuntu/repos/wgsPipeline/cromwell-executions/bcl2fastq/2d9c661c-5fdf-4b73-8ee6-a90c9af8598d/call-process/execution/test_sample_R1.fastq.gz", "/home/ubuntu/repos/wgsPipeline/cromwell-executions/bcl2fastq/2d9c661c-5fdf-4b73-8ee6-a90c9af8598d/call-process/execution/test_sample_R2.fastq.gz"]
    #   },
    #   "name": "test_sample"
    # }
    Output fastqs = bcl2fastq.fastqs[index]
    File fastqR1 = fastqs.fastqs.left[0]
    File fastqR2 = fastqs.fastqs.left[1]

    call fastQC.fastQC {
      input:
        fastqR1 = fastqR1,
        fastqR2 = fastqR2
    }
  }

  output {
    # fastQC
    Array[File]? fastQC_html_report_R1  = fastQC.html_report_R1
    Array[File]? fastQC_zip_bundle_R1   = fastQC.zip_bundle_R1
    Array[File]? fastQC_html_report_R2 = fastQC.html_report_R2
    Array[File]? fastQC_zip_bundle_R2  = fastQC.zip_bundle_R2
  }
}