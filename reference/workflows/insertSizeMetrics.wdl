version 1.0

workflow insertSizeMetrics {
  input {
    File inputBam
    String outputFileNamePrefix = basename(inputBam, '.bam')
  }

  call collectInsertSizeMetrics {
    input:
      inputBam = inputBam,
      outputPrefix = outputFileNamePrefix
  }

  output {
    File insertSizeMetrics = collectInsertSizeMetrics.insertSizeMetrics
    File histogramReport = collectInsertSizeMetrics.histogramReport
  }

  parameter_meta {
    inputBam: "Input file (bam or sam)."
    outputFileNamePrefix: "Output prefix to prefix output file names with."
  }

  meta {
    author: "Michael Laszloffy"
    email: "michael.laszloffy@oicr.on.ca"
    description: "Workflow to run picard InsertSizeMetrics"
    dependencies: [{
      name: "picard/2.21.2",
      url: "https://broadinstitute.github.io/picard/"
    },{
      name: "rstats/3.6",
      url: "https://www.r-project.org/"
    }]
  }
}

task collectInsertSizeMetrics {
  input {
    File inputBam
    String picardJar = "$PICARD_ROOT/picard.jar"
    Float minimumPercent = 0.5
    String outputPrefix = "OUTPUT"
    Int jobMemory = 18
    String modules = "picard/2.21.2 rstats/3.6"
    Int timeout = 12
  }

  parameter_meta {
    picardJar: "The picard jar to use."
    inputBam: "Input file (bam or sam)."
    minimumPercent: "Discard any data categories (out of FR, TANDEM, RF) when generating the histogram (Range: 0 to 1)."
    outputPrefix: "Output prefix to prefix output file names with."
    jobMemory: "Memory (in GB) allocated for job."
    modules: "Environment module names and version to load (space separated) before command execution."
    timeout: "Maximum amount of time (in hours) the task can run for."
  }

  meta {
    output_meta : {
      insertSizeMetrics: "Metrics about the insert size distribution (see https://broadinstitute.github.io/picard/picard-metric-definitions.html#InsertSizeMetrics).",
      histogramReport: "Insert size distribution plot."
    }
  }

  command <<<
    java -Xmx~{jobMemory - 6}G -jar ~{picardJar} \
    CollectInsertSizeMetrics \
    TMP_DIR=picardTmp \
    INPUT=~{inputBam} \
    OUTPUT="~{outputPrefix}.isize.txt" \
    HISTOGRAM_FILE="~{outputPrefix}.histogram.pdf" \
    MINIMUM_PCT=~{minimumPercent}
  >>>

  runtime {
    memory: "~{jobMemory} GB"
    modules: "~{modules}"
    timeout: "~{timeout}"
  }

  output {
    File insertSizeMetrics = "~{outputPrefix}.isize.txt"
    File histogramReport = "~{outputPrefix}.histogram.pdf"
  }
}