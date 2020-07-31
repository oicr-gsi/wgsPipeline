version 1.0

# imports workflows for the top portion of WGSPipeline
import "test_imports4/dockstore_bcl2fastq.wdl" as bcl2fastq
import "test_imports4/dockstore_fastqc.wdl" as fastQC
import "test_imports4/dockstore_bwaMem.wdl" as bwaMem
import "test_imports4/dockstore_bamQC.wdl" as bamQC

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

workflow top4 {
	input {
		Array[bcl2fastqMeta] bcl2fastqMetas
		Array[bwaMemMeta] bwaMemMetas
		Array[bamQCMeta] bamQCMetas
	}

	parameter_meta {

	}

	# scatter over [Tumour, Normal]
	scatter (index in [0, 1]){

		bcl2fastqMeta bcl2fastqMeta = bcl2fastqMetas[index]

		call bcl2fastq.bcl2fastq {
			input:
				# need samples, lanes, and runDirectory
				samples = bcl2fastqMeta.samples,
				lanes = bcl2fastqMeta.lanes,
				runDirectory = bcl2fastqMeta.runDirectory
	  	  		# the rest of the inputs are the same for all runs; fed directly into subworkflow
	  	}

	  	# bcl2fastq.fastqs = Array[Output]+
	  	# Output:
	    # {
	    #   "fastqs": {
	    #     "right": {
	    #       "read_count": "528"
	    #     },
	    #     "left": ["/home/ubuntu/repos/wgsPipeline/cromwell-executions/bcl2fastq/2d9c661c-5fdf-4b73-8ee6-a90c9af8598d/call-process/execution/test_sample_R1.fastq.gz", "/home/ubuntu/repos/wgsPipeline/cromwell-executions/bcl2fastq/2d9c661c-5fdf-4b73-8ee6-a90c9af8598d/call-process/execution/test_sample_R2.fastq.gz"]
	    #   },
	    #   "name": "test_sample"
	    # }
	    # assumes that bcl2fastq only outputs one pair of fastqs
		Output bcl2fastqOut = bcl2fastq.fastqs[0]
		File fastqR1 = bcl2fastqOut.fastqs.left[0]
		File fastqR2 = bcl2fastqOut.fastqs.left[1]

		call fastQC.fastQC {
			input:
				fastqR1 = fastqR1,	# File
				fastqR2 = fastqR2	# File
		}

		bwaMemMeta bwaMemMeta = bwaMemMetas[index]

		call bwaMem.bwaMem {
			input:
				fastqR1 = fastqR1,   # File
				fastqR2 = fastqR2,   # File
				readGroups = bwaMemMeta.readGroups 	# String
		}

		bamQCMeta bamQCMeta = bamQCMetas[index]

		call bamQC.bamQC as rawBamQC {
			input:
				bamFile = bwaMem.bwaMemBam, 	# File
				metadata = bamQCMeta.metadata	# Map[String, String]
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
	}
}