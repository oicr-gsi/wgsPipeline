version 1.0

workflow insertSizeMetrics {
  input {
    String docker = "g3chen/wgspipeline@sha256:3c0c292c460c8db19b9744be1ea81529c4d189e4c4f9ca9a63046edcf792087d"
    Int collectInsertSizeMetrics_timeout = 12
    String collectInsertSizeMetrics_modules = "picard/2.21.2 rstats/3.6"
    Int collectInsertSizeMetrics_jobMemory = 18
    Float collectInsertSizeMetrics_minimumPercent = 0.5
    String collectInsertSizeMetrics_picardJar = "$PICARD_ROOT/picard.jar"
    File inputBam
    String outputFileNamePrefix = basename(inputBam, '.bam')
  }

  call collectInsertSizeMetrics {
    input:
      docker = docker,
      timeout = collectInsertSizeMetrics_timeout,
      modules = collectInsertSizeMetrics_modules,
      jobMemory = collectInsertSizeMetrics_jobMemory,
      minimumPercent = collectInsertSizeMetrics_minimumPercent,
      picardJar = collectInsertSizeMetrics_picardJar,
      inputBam = inputBam,
      outputPrefix = outputFileNamePrefix
  }

  output {
    File insertSizeMetrics = collectInsertSizeMetrics.insertSizeMetrics
    File histogramReport = collectInsertSizeMetrics.histogramReport
  }

  parameter_meta {
      docker: "Docker container to run the workflow in"
      collectInsertSizeMetrics_timeout: "Maximum amount of time (in hours) the task can run for."
      collectInsertSizeMetrics_modules: "Environment module names and version to load (space separated) before command execution."
      collectInsertSizeMetrics_jobMemory: "Memory (in GB) allocated for job."
      collectInsertSizeMetrics_minimumPercent: "Discard any data categories (out of FR, TANDEM, RF) when generating the histogram (Range: 0 to 1)."
      collectInsertSizeMetrics_picardJar: "The picard jar to use."
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
    String docker = "g3chen/wgspipeline@sha256:3c0c292c460c8db19b9744be1ea81529c4d189e4c4f9ca9a63046edcf792087d"
    File inputBam
    String picardJar = "$PICARD_ROOT/picard.jar"
    Float minimumPercent = 0.5
    String outputPrefix = "OUTPUT"
    Int jobMemory = 18
    String modules = "picard/2.21.2 rstats/3.6"
    Int timeout = 12
  }

  parameter_meta {
      docker: "Docker container to run the workflow in"
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
    source /home/ubuntu/.bashrc 
    ~{"module load " + modules + " || exit 20; "} 

    java -Xmx~{jobMemory - 6}G -jar ~{picardJar} \
    CollectInsertSizeMetrics \
    TMP_DIR=picardTmp \
    INPUT=~{inputBam} \
    OUTPUT="~{outputPrefix}.isize.txt" \
    HISTOGRAM_FILE="~{outputPrefix}.histogram.pdf" \
    MINIMUM_PCT=~{minimumPercent}
  >>>

  runtime {
    docker: "~{docker}"
    memory: "~{jobMemory} GB"
    modules: "~{modules}"
    timeout: "~{timeout}"
  }

  output {
    File insertSizeMetrics = "~{outputPrefix}.isize.txt"
    File histogramReport = "~{outputPrefix}.histogram.pdf"
  }
}