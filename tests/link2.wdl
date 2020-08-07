version 1.0

# imports workflows for the top portion of WGSPipeline
import "test_imports2/dockstore_bwaMem.wdl" as bwaMem
import "test_imports2/dockstore_bamMergePreprocessing.wdl" as bamMergePreprocessing 

struct bwaMemMeta {
	String readGroups
	# possibly add more parameters here like outputFileNamePrefix
}

struct FastqInput {
	String name
	Array[File] fastqs
}

workflow link2 {
	input {
		Array[FastqInput] fastqInputs
		Array[bwaMemMeta] bwaMemMetas
	}

	# scatter over [normal, tumor]
	scatter (index in [0, 1]){
		File fastqR1 = fastqInputs[index].fastqs[0]
		File fastqR2 = fastqInputs[index].fastqs[1]
		String name = fastqInputs[index].name

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
	}

	Array[InputGroup] inputGroups = inputGroup	# congregate results from first 4 workflows

	InputGroups groups = object {inputGroups: inputGroups}
	call test {
		input:
			groups = groups
	}

	call bamMergePreprocessing.bamMergePreprocessing {
		input:
			inputGroups = inputGroups
	}

	output {
		# bwaMem
		Array[File?] bwaMem_log = bwaMem.log
		Array[File?] bwaMem_cutAdaptAllLogs = bwaMem.cutAdaptAllLogs

		# bamMergePreprocessing
		File? bamMergePreprocessing_recalibrationReport = bamMergePreprocessing.recalibrationReport
		File? bamMergePreprocessing_recalibrationTable = bamMergePreprocessing.recalibrationTable
		Array[OutputGroup] outputGroups = bamMergePreprocessing.outputGroups 
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

task test {		# call once for each InputGroup in InputGroups
	input {
		InputGroups groups
	}

	command <<<
		echo "~{write_json(groups)}"
	>>>

	output {
		String result = read_string(stdout())
	}
}