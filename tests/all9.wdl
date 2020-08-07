version 1.0

# imports workflows for the top portion of WGSPipeline
import "test_imports9/dockstore_bcl2fastq.wdl" as bcl2fastq
import "test_imports9/dockstore_fastqc.wdl" as fastQC
import "test_imports9/dockstore_bwaMem.wdl" as bwaMem
import "test_imports9/dockstore_bamQC.wdl" as bamQC
import "test_imports9/dockstore_bamMergePreprocessing.wdl" as bamMergePreprocessing 
import "test_imports9/dockstore_callability.wdl" as callability 
import "test_imports9/dockstore_insertSizeMetrics.wdl" as insertSizeMetrics
import "test_imports9/dockstore_wgsMetrics.wdl" as wgsMetrics

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

struct FastqInput {
	String name
	Array[File] fastqs
}

workflow all9 {
	input {
		Boolean doBcl2fastq = true
		Array[bcl2fastqMeta]? bcl2fastqMetas
		Array[FastqInput]? fastqInputs
		Array[bwaMemMeta] bwaMemMetas
		Array[bamQCMeta] rawBamQCMetas	
		Array[bamQCMeta] processedBamQCMetas	
	}

	parameter_meta {
		skipBcl2fastq: "Whether to use fastqs or bcls"
		bcl2fastqMetas: "Samples, lanes, and runDirectory for bcl2fastq"
		fastqInputs: "Name and list of fastqs"
		bwaMemMetas: "ReadGroups for bwaMemMeta"
		rawBamQCMetas: "Metadata for the raw bamQC run"
		processedBamQCMetas: "Metadata for the processed bamQC run"
	}

	# scatter over [normal, tumor]
	scatter (index in [0, 1]){
		if (doBcl2fastq) {
			bcl2fastqMeta bcl2fastqMeta = select_first([bcl2fastqMetas])[index]
			call bcl2fastq.bcl2fastq {
				input:
					samples = bcl2fastqMeta.samples,
					lanes = bcl2fastqMeta.lanes,
					runDirectory = bcl2fastqMeta.runDirectory
		  	}
		}

		File fastqR1 = if doBcl2fastq then select_first([bcl2fastq.fastqs])[0].fastqs.left[0] else select_first([fastqInputs])[index].fastqs[0]
		File fastqR2 = if doBcl2fastq then select_first([bcl2fastq.fastqs])[0].fastqs.left[1] else select_first([fastqInputs])[index].fastqs[1]
		String name = if doBcl2fastq then select_first([bcl2fastq.fastqs])[0].name else select_first([fastqInputs])[index].name

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

		call linkBamAndBamIndex {
			input:
				bam = bwaMem.bwaMemBam,
				bamIndex = bwaMem.bwaMemIndex
		}

		BamAndBamIndex bamAndBamIndex = object {
			bam: linkBamAndBamIndex.linkedBam,
			bamIndex: linkBamAndBamIndex.linkedBamIndex
		}

		InputGroup inputGroup = object {
			outputIdentifier: name,
			bamAndBamIndexInputs: [
				bamAndBamIndex
			]
		}

		bamQCMeta rawBamQCMeta = rawBamQCMetas[index]
		call bamQC.bamQC as rawBamQC {
			input:
				bamFile = bwaMem.bwaMemBam, 	# File
				metadata = rawBamQCMeta.metadata,	# Map[String, String]
		}
	}

	Array[InputGroup] inputGroups = inputGroup	# congregate results from first 4 workflows

	call bamMergePreprocessing.bamMergePreprocessing {
		input:
			inputGroups = inputGroups
	}
		
	Array[OutputGroup] outputGroups = bamMergePreprocessing.outputGroups 
	
	call callability.callability {
		input:
			normalBam = outputGroups[0].bam,
			normalBamIndex = outputGroups[0].bamIndex,
			tumorBam = outputGroups[1].bam,
			tumorBamIndex = outputGroups[1].bamIndex
	}

	# scatter over [normal, tumor]
	scatter (index in [0, 1]){

		OutputGroup outputGroup = outputGroups[index]

		call insertSizeMetrics.insertSizeMetrics {
			input:
				inputBam = outputGroup.bam,
				outputFileNamePrefix = outputGroup.outputIdentifier
		}

		call wgsMetrics.wgsMetrics {
			input: 
				inputBam = outputGroup.bam,
				outputFileNamePrefix = outputGroup.outputIdentifier
		}

		bamQCMeta processedBamQCMeta = processedBamQCMetas[index]

		call bamQC.bamQC as processedBamQC {
			input:
				bamFile = outputGroup.bam,
				metadata = processedBamQCMeta.metadata	# Map[String, String]
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

	    # bamMergePreprocessing
	    File? bamMergePreprocessing_recalibrationReport = bamMergePreprocessing.recalibrationReport
	    File? bamMergePreprocessing_recalibrationTable = bamMergePreprocessing.recalibrationTable

	    # callability
	    File callability_callabilityMetrics = callability.callabilityMetrics

	    # insertSizeMetrics
	    Array[File] insertSizeMetrics_insertSizeMetrics = insertSizeMetrics.insertSizeMetrics
    	Array[File] insertSizeMetrics_histogramReport = insertSizeMetrics.histogramReport

    	# wgsMetrics
    	Array[File] wgsMetrics_outputWGSMetrics = wgsMetrics.outputWGSMetrics

	    # bamQC
	    Array[File] processedBamQC_result = processedBamQC.result
	}
}

task linkBamAndBamIndex {
	input {
		File bam
		File bamIndex
	}

	command <<<
		ln -s ~{bam} "~{basename(bam)}"
		ln -s ~{bamIndex} "~{basename(bamIndex)}"
	>>>

	output {
		File linkedBam = "~{basename(bam)}"
		File linkedBamIndex = "~{basename(bamIndex)}"
	}
}