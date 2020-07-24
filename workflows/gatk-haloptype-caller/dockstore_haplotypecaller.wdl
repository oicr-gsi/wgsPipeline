version 1.0

workflow haplotypeCaller {
  input {
    String docker = "g3chen/wgspipeline@sha256:3c0c292c460c8db19b9744be1ea81529c4d189e4c4f9ca9a63046edcf792087d"
    Int mergeGVCFs_timeout = 24
    Int mergeGVCFs_cores = 1
    Int mergeGVCFs_overhead = 6
    Int mergeGVCFs_jobMemory = 24
    String mergeGVCFs_modules
    Int callHaplotypes_timeout = 72
    Int callHaplotypes_cores = 1
    Int callHaplotypes_overhead = 6
    Int callHaplotypes_jobMemory = 24
    String callHaplotypes_refFasta
    String callHaplotypes_modules
    String callHaplotypes_erc = "GVCF"
    String callHaplotypes_intervalSetRule = "INTERSECTION"
    Int callHaplotypes_intervalPadding = 100
    String? callHaplotypes_extraArgs
    String callHaplotypes_dbsnpFilePath
    Int splitStringToArray_timeout = 1
    Int splitStringToArray_cores = 1
    Int splitStringToArray_jobMemory = 1
    String splitStringToArray_lineSeparator = ","
    File bai
    File bam
    File? filterIntervals
    String outputFileNamePrefix = basename(bam, ".bam")
    String intervalsToParallelizeBy
  }
  parameter_meta {
      bai: "The index for the BAM file to be used."
      bam: "The BAM file to be used."
      filterIntervals: "A BED file that restricts calling to only the regions in the file."
      outputFileNamePrefix: "Prefix for output file."
      intervalsToParallelizeBy: "Comma separated list of intervals to split by (e.g. chr1,chr2,chr3,chr4)."
  }

  meta {
      author: "Andre Masella, Xuemei Luo"
      description: "Workflow to run the GATK Haplotype Caller"
      dependencies: [{
          name: "GATK4",
          url: "https://gatk.broadinstitute.org/hc/en-us/articles/360037225632-HaplotypeCaller"
      }]
      output_meta: {
        outputVcf: "output vcf",
        outputVcfIndex: "output vcf index"
      }
  }

  call splitStringToArray {
    input:
      docker = docker,
      timeout = splitStringToArray_timeout,
      cores = splitStringToArray_cores,
      jobMemory = splitStringToArray_jobMemory,
      lineSeparator = splitStringToArray_lineSeparator,
      intervalsToParallelizeBy = intervalsToParallelizeBy
  }
  
  scatter (intervals in splitStringToArray.out) {
     call callHaplotypes {
       input:
         docker = docker,
         timeout = callHaplotypes_timeout,
         cores = callHaplotypes_cores,
         overhead = callHaplotypes_overhead,
         jobMemory = callHaplotypes_jobMemory,
         refFasta = callHaplotypes_refFasta,
         modules = callHaplotypes_modules,
         erc = callHaplotypes_erc,
         intervalSetRule = callHaplotypes_intervalSetRule,
         intervalPadding = callHaplotypes_intervalPadding,
         extraArgs = callHaplotypes_extraArgs,
         dbsnpFilePath = callHaplotypes_dbsnpFilePath,
         bamIndex = bai,
         bam = bam,
         interval = intervals[0],
         filterIntervals = filterIntervals,
         outputFileNamePrefix = outputFileNamePrefix,
     }
  }

  call mergeGVCFs {
    input:
      docker = docker,
      timeout = mergeGVCFs_timeout,
      cores = mergeGVCFs_cores,
      overhead = mergeGVCFs_overhead,
      jobMemory = mergeGVCFs_jobMemory,
      modules = mergeGVCFs_modules,
      outputFileNamePrefix = outputFileNamePrefix,
      vcfs = callHaplotypes.output_vcf
  }
  output {
    File outputVcf = mergeGVCFs.mergedVcf
    File outputVcfIndex = mergeGVCFs.mergedVcfTbi
  }

}

task splitStringToArray {
  input {
    String docker = "g3chen/wgspipeline@sha256:3c0c292c460c8db19b9744be1ea81529c4d189e4c4f9ca9a63046edcf792087d"
    String intervalsToParallelizeBy
    String lineSeparator = ","
    Int jobMemory = 1
    Int cores = 1
    Int timeout = 1
  }

  command <<<
    echo "~{intervalsToParallelizeBy}" | tr '~{lineSeparator}' '\n'
  >>>

  output {
    Array[Array[String]] out = read_tsv(stdout())
  }

  runtime {
    docker: "~{docker}"
    memory: "~{jobMemory} GB"
    cpu: "~{cores}"
    timeout: "~{timeout}"
  }

  parameter_meta {
    intervalsToParallelizeBy: "Interval string to split (e.g. chr1,chr2,chr3,chr4)."
    lineSeparator: "line separator for intervalsToParallelizeBy. "
    jobMemory: "Memory allocated to job (in GB)."
    cores: "The number of cores to allocate to the job."
    timeout: "Maximum amount of time (in hours) the task can run for."
  }
}

task callHaplotypes {
  input {
    String docker = "g3chen/wgspipeline@sha256:3c0c292c460c8db19b9744be1ea81529c4d189e4c4f9ca9a63046edcf792087d"
    File bamIndex
    File bam
    String dbsnpFilePath
    String? extraArgs
    String interval
    File? filterIntervals
    Int intervalPadding = 100
    String intervalSetRule = "INTERSECTION"
    String erc = "GVCF"
    String modules
    String refFasta
    String outputFileNamePrefix
    Int jobMemory = 24
    Int overhead = 6
    Int cores = 1
    Int timeout = 72
  }
 
  String outputName = "~{outputFileNamePrefix}.~{interval}.g.vcf.gz"

  command <<<
    source /home/ubuntu/.bashrc 
    ~{"module load " + modules + " || exit 20; "} 

    set -euo pipefail

    gatk --java-options -Xmx~{jobMemory - overhead}G \
      HaplotypeCaller \
      -R ~{refFasta} \
      -I ~{bam} \
      -L ~{interval} \
      ~{if defined(filterIntervals) then "-L ~{filterIntervals} -isr ~{intervalSetRule} -ip ~{intervalPadding}" else ""} \
      -D ~{dbsnpFilePath} \
      -ERC ~{erc} ~{extraArgs} \
      -O "~{outputName}"
  >>>

  output {
    File output_vcf = "~{outputName}"
  }

  runtime {
    docker: "~{docker}"
    memory: "~{jobMemory} GB"
    cpu: "~{cores}"
    timeout: "~{timeout}"
    modules: "~{modules}"
  }

  parameter_meta {
    bamIndex: "The index for the BAM file to be used."
    bam: "The BAM file to be used."
    dbsnpFilePath: "The dbSNP VCF to call against."
    extraArgs: "Additional arguments to be passed directly to the command."
    filterIntervals: "A BED file that restricts calling to only the regions in the file."
    intervalPadding: "The number of bases of padding to add to each interval."
    intervalSetRule: "Set merging approach to use for combining interval inputs."
    interval: "The interval (chromosome) for this shard to work on."
    erc: "Mode for emitting reference confidence scores."
    modules: "Required environment modules."
    refFasta: "The file path to the reference genome."
    outputFileNamePrefix: "Prefix for output file."
    jobMemory:  "Memory allocated to job (in GB)."
    overhead: "Java overhead memory (in GB). jobMemory - overhead == java Xmx/heap memory."
    cores: "The number of cores to allocate to the job."
    timeout: "Maximum amount of time (in hours) the task can run for."
  }
  meta {
      output_meta: {
          output_vcf: "Output vcf file for this interval"
      }
  }
}

task mergeGVCFs {
  input {
    String docker = "g3chen/wgspipeline@sha256:3c0c292c460c8db19b9744be1ea81529c4d189e4c4f9ca9a63046edcf792087d"
    String modules
    Array[File] vcfs
    String outputFileNamePrefix
    Int jobMemory = 24
    Int overhead = 6
    Int cores = 1
    Int timeout = 24
  }

  String outputName = "~{outputFileNamePrefix}.g.vcf.gz"

  command <<<
    source /home/ubuntu/.bashrc 
    ~{"module load " + modules + " || exit 20; "} 

    set -euo pipefail

    gatk --java-options "-Xmx~{jobMemory - overhead}G" MergeVcfs \
    -I ~{sep=" -I " vcfs} \
    -O ~{outputName}
  >>>

  runtime {
    docker: "~{docker}"
    memory: "~{jobMemory} GB"
    cpu: "~{cores}"
    timeout: "~{timeout}"
    modules: "~{modules}"
  }

  output {
    File mergedVcf = "~{outputName}"
    File mergedVcfTbi = "~{outputName}.tbi"
  }

  parameter_meta {
    modules: "Required environment modules."
    vcfs: "Vcf's from scatter to merge together."
    jobMemory:  "Memory allocated to job (in GB)."
    overhead: "Java overhead memory (in GB). jobMemory - overhead == java Xmx/heap memory."
    cores: "The number of cores to allocate to the job."
    timeout: "Maximum amount of time (in hours) the task can run for."
  }

  meta {
    output_meta: {
      mergedVcf: "Merged vcf",
      mergedVcfTbi: "Merged vcf index"
    }
  }

}