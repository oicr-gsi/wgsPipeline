version 1.0

# imports workflows for the middle portion of WGSPipeline
import "test_imports5/dockstore_bamMergePreprocessing.wdl" as bamMergePreprocessing 
import "test_imports5/dockstore_callability.wdl" as callability 
import "test_imports5/dockstore_insertSizeMetrics.wdl" as insertSizeMetrics
import "test_imports5/dockstore_wgsMetrics.wdl" as wgsMetrics
import "test_imports5/dockstore_bamQC.wdl" as bamQC

struct bamQCMeta {
    Map[String, String] metadata
	# possibly add more parameters here like outputFileNamePrefix
}

workflow top5 {
	input {
		Array[InputGroup] inputGroups	# will be replaced by bwaMem outputs
		Array[bamQCMeta] processedBamQCMetas
	}

	call bamMergePreprocessing.bamMergePreprocessing {
		input:
			inputGroups = inputGroups
	}

	Array[OutputGroup] outputGroups = bamMergePreprocessing.outputGroups 
	# OutputGroup outputGroup = { "outputIdentifier": o.outputIdentifier,
    #                             "bam": select_first([mergeSplitByIntervalBams.mergedBam, o.bams[0]]),
    #                             "bamIndex": select_first([mergeSplitByIntervalBams.mergedBamIndex, o.bamIndexes[0]])}

	call callability.callability {
		input:
			normalBam = outputGroups[0].bam,
			normalBamIndex = outputGroups[0].bamIndex,
			tumorBam = outputGroups[1].bam,
			tumorBamIndex = outputGroups[1].bamIndex
	}

	# scatter over [Normal, Tumor]
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