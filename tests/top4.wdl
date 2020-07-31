version 1.0

# imports workflows for the top portion of WGSPipeline
import "test_imports4/dockstore_bcl2fastq.wdl" as bcl2fastq
import "test_imports4/dockstore_fastqc.wdl" as fastQC
import "test_imports4/dockstore_bwaMem.wdl" as bwaMem
import "test_imports4/dockstore_bamQC.wdl" as bamQC

workflow top4 {
  input {
    Array[Map[String, String]] bwaMem_fastqInfos
  }

  parameter_meta {
    bwaMem_fastqInfos: "@@@ placeholder"
  }

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

    # [
    #   "'@RG\\tID:121005_h804_0096_AD0V4NACXX-NoIndex_6\\tLB:PCSI0022C\\tPL:ILLUMINA\\tPU:121005_h804_0096_AD0V4NACXX-NoIndex_6\\tSM:PCSI0022C'", 
    #   "121005_h804_0096_AD0V4NACXX_PCSI0022C_NoIndex_L006_001"
    # ]

    Map[String, String] fastqInfo = bwaMem_fastqInfos[index]
    String readGroups = fastqInfo[readGroups]
    String outputFileNamePrefix = fastqInfo[outputFileNamePrefix]

    call fastQC.fastQC {
      input:
        fastqR1 = fastqR1,	# File
        fastqR2 = fastqR2   # File
    }

    call bwaMem.bwaMem {
      input:
        fastqR1 = fastqR1,   # File
        fastqR2 = fastqR2,   # File
        readGroups = readGroups, 	# String
        outputFileNamePrefix = outputFileNamePrefix 	# String
    }

    call bamQC.bamQC as rawBamQC {
      input:
        bamFile = bwaMem.bwaMemBam 	# File
    }
  }

  output {
    # fastQC
    Array[File]? fastQC_html_report_R1  = fastQC.html_report_R1
    Array[File]? fastQC_zip_bundle_R1   = fastQC.zip_bundle_R1
    Array[File]? fastQC_html_report_R2 = fastQC.html_report_R2
    Array[File]? fastQC_zip_bundle_R2  = fastQC.zip_bundle_R2
    
    # bwaMem
    Array[File]? bwaMem_log = bwaMem.log
    Array[File]? bwaMem_cutAdaptAllLogs = bwaMem.cutAdaptAllLogs

    # bamQC
    Array[File] rawBamQC_result = rawBamQC.result
  }
}