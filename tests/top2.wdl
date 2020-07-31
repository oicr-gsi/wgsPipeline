version 1.0

# imports workflows for the top portion of WGSPipeline
import "test_imports2/dockstore_bcl2fastq.wdl" as bcl2fastq
import "test_imports2/dockstore_fastqc.wdl" as fastQC

struct bcl2fastqSample {
	Array[Sample]+ samples  # Sample: {Array[String]+, String}
	Array[Int] lanes
	String runDirectory
}

workflow top2 {
	input {
		# right now bcl2fastqSamples contain just Tumor and Normal (finite)
		# in the future, expand to an infinite-sized Array
		Array[bcl2fastqSample]+ bcl2fastqSamples
	}

	parameter_meta {

	}

	scatter (bcl2fastqSample in bcl2fastqSamples){
		call bcl2fastq.bcl2fastq {
			input:
				# need samples, lanes, and runDirectory
				samples = bcl2fastqSample.samples,
				lanes = bcl2fastqSample.lanes,
				runDirectory = bcl2fastqSample.runDirectory
	  	  		# the rest of the inputs are the same for all runs; fed directly into subworkflow
	  	}

	  # assumes that bcl2fastq only outputs one pair of fastqs
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
		Output bcl2fastqOut = bcl2fastq.fastqs[0]
		File fastqR1 = bcl2fastqOut.fastqs.left[0]
		File fastqR2 = bcl2fastqOut.fastqs.left[1]

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