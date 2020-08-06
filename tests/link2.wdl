version 1.0

# imports workflows for the top portion of WGSPipeline
import "test_imports9/dockstore_bwaMem.wdl" as bwaMem
import "test_imports9/dockstore_bamMergePreprocessing.wdl" as bamMergePreprocessing 

struct bwaMemMeta {
	String readGroups
	# possibly add more parameters here like outputFileNamePrefix
}

struct FastqInput {
	String name
	Array[File] fastqs
}

workflow all9 {
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

		BamAndBamIndex bamAndBamIndex = object {
			bam: bwaMem.bwaMemBam,
		    bamIndex: bwaMem.bwaMemIndex	
		}

		InputGroup inputGroup = object {
			outputIdentifier: name,
			bamAndBamIndexInputs: [
				bamAndBamIndex
		    ]
		}
	}

	Array[InputGroup] inputGroups = inputGroup	# congregate results from first 4 workflows

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