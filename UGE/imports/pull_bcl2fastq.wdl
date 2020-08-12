version 1.0

struct Sample {
    Array[String]+ barcodes
    String name
    Boolean inlineUmi
    String? acceptableUmiList
    Map[String,String]? patterns
}

struct SampleList {
    Array[Sample]+ samples
}

struct Output {
    String name
    Pair[File,Map[String,String]] fastqs
}

struct Outputs {
    Array[Output]+ outputs
}

workflow bcl2fastq {
  input {
    Int process_threads = 8
    String process_temporaryDirectory = "."
    Int process_memory = 32
    Boolean process_ignoreMissingPositions = false
    Boolean process_ignoreMissingFilter = false
    Boolean process_ignoreMissingBcls = false
    String process_extraOptions = ""
    String process_bcl2fastqJail = "bcl2fastq-jail"
    String process_bcl2fastq = "bcl2fastq"
    String? basesMask
    Array[Int]+ lanes
    Int mismatches
    String modules
    Array[Sample]+ samples
    String runDirectory
    Int timeout = 40
  }
  parameter_meta {
      process_threads: "The number of processing threads to use when running BCL2FASTQ"
      process_temporaryDirectory: "A directory where bcl2fastq can dump massive amounts of garbage while running."
      process_memory: "The memory for the BCL2FASTQ process in GB."
      process_ignoreMissingPositions: "Flag passed to bcl2fastq, allows missing or corrupt positions files."
      process_ignoreMissingFilter: "Flag passed to bcl2fastq, allows missing or corrupt filter files."
      process_ignoreMissingBcls: "Flag passed to bcl2fastq, allows missing bcl files."
      process_extraOptions: "Any other options that will be passed directly to bcl2fastq."
      process_bcl2fastqJail: "The name ro path of the BCL2FASTQ wrapper script executable."
      process_bcl2fastq: "The name or path of the BCL2FASTQ executable."
    basesMask: "An Illumina bases mask string to use. If absent, the one written by the instrument will be used."
    lanes: "The lane numbers to process from this run"
    mismatches: "Number of mismatches to allow in the barcodes (usually, 1)"
    modules: "The modules to load when running the workflow. This should include bcl2fastq and the helper scripts."
    runDirectory: "The path to the instrument's output directory."
    samples: "The information about the samples. Tname of the sample which will determine the output file prefix. The list of barcodes in the format i7-i5 for this sample. If multiple barcodes are provided, they will be merged into a single output."
    timeout: "The maximum number of hours this workflow can run for."
  }
  meta {
    author: "Andre Masella"
    description: "Workflow to produce FASTQ files from an Illumina instrument's run directory"
    dependencies: [{
      name: "bcl2fastq",
      url: "https://emea.support.illumina.com/sequencing/sequencing_software/bcl2fastq-conversion-software.html"
    }]
    output_meta: {
      fastqs: "A list of FASTQs generated and annotations that should be applied to them."
    }
  }
  call process {
    input:
      threads = process_threads,
      temporaryDirectory = process_temporaryDirectory,
      memory = process_memory,
      ignoreMissingPositions = process_ignoreMissingPositions,
      ignoreMissingFilter = process_ignoreMissingFilter,
      ignoreMissingBcls = process_ignoreMissingBcls,
      extraOptions = process_extraOptions,
      bcl2fastqJail = process_bcl2fastqJail,
      bcl2fastq = process_bcl2fastq,
      basesMask = basesMask,
      lanes = lanes,
      mismatches  = mismatches,
      modules = modules,
      runDirectory = runDirectory,
      samples = object { samples: samples },
      timeout = timeout
  }
  output {
    Array[Output]+ fastqs = process.out.outputs
  }
}


task process {
  input {
    String? basesMask
    String bcl2fastq = "bcl2fastq"
    String bcl2fastqJail = "bcl2fastq-jail"
    String extraOptions = ""
    Boolean ignoreMissingBcls = false
    Boolean ignoreMissingFilter = false
    Boolean ignoreMissingPositions = false
    Array[Int]+ lanes
    Int memory = 32
    Int mismatches
    String modules
    String runDirectory
    SampleList samples
    String temporaryDirectory = "."
    Int threads = 8
    Int timeout = 40
  }
  parameter_meta {
    basesMask: "An Illumina bases mask string to use. If absent, the one written by the instrument will be used."
    bcl2fastq: "The name or path of the BCL2FASTQ executable."
    bcl2fastqJail: "The name ro path of the BCL2FASTQ wrapper script executable."
    extraOptions: "Any other options that will be passed directly to bcl2fastq."
    ignoreMissingBcls: "Flag passed to bcl2fastq, allows missing bcl files."
    ignoreMissingFilter: "Flag passed to bcl2fastq, allows missing or corrupt filter files."
    ignoreMissingPositions: "Flag passed to bcl2fastq, allows missing or corrupt positions files."
    lanes: "The set of lanes to process."
    memory: "The memory for the BCL2FASTQ process in GB."
    mismatches: "Number of mismatches to allow in the barcodes (usually, 1)"
    modules: "The modules to load when running the workflow. This should include bcl2fastq and the helper scripts."
    runDirectory: "The path to the instrument's output directory."
    samples: "The samples to extract from the run."
    temporaryDirectory: "A directory where bcl2fastq can dump massive amounts of garbage while running."
    threads: "The number of processing threads to use when running BCL2FASTQ"
    timeout: "The maximum number of hours this workflow can run for."
  }
  meta {
    output_meta: {
      out: "The FASTQ files and read counts for the samples"
    }
  }

  command <<<
    ~{bcl2fastqJail} \
      -t "~{temporaryDirectory}" \
      -s ~{write_json(samples)} \
      -- ~{bcl2fastq} \
      --barcode-mismatches ~{mismatches} \
      --input-dir "~{runDirectory}/Data/Intensities/BaseCalls" \
      --intensities-dir "~{runDirectory}/Data/Intensities" \
      --no-lane-splitting \
      --processing-threads ~{threads} \
      --runfolder-dir "~{runDirectory}" \
      --tiles "^(s_)?[~{sep="" lanes}]_" \
      --interop-dir "~{temporaryDirectory}" \
      ~{if ignoreMissingBcls then "--ignore-missing-bcls" else ""} \
      ~{if ignoreMissingFilter then "--ignore-missing-filter" else ""} \
      ~{if ignoreMissingPositions then "--ignore-missing-positions" else ""} \
      ~{if defined(basesMask) then "--use-bases-mask ~{basesMask}" else ""} \
      ~{extraOptions}
  >>>
  output {
    Outputs out = read_json("outputs.json")
  }
  runtime {
    memory: "~{memory}G"
    modules: "~{modules}"
    timeout: "~{timeout}"
  }
}
