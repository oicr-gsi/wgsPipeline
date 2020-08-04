version 1.0

workflow wgsMetrics {
  input {
    String docker = "g3chen/wgspipeline@sha256:3c0c292c460c8db19b9744be1ea81529c4d189e4c4f9ca9a63046edcf792087d"
    Int collectWGSmetrics_timeout = 24
    String collectWGSmetrics_modules = "picard/2.21.2 hg19/p13"
    Int collectWGSmetrics_coverageCap = 500
    Int collectWGSmetrics_jobMemory = 18
    String collectWGSmetrics_filter = "LENIENT"
    String collectWGSmetrics_metricTag = "WGS"
    String collectWGSmetrics_refFasta = "$HG19_ROOT/hg19_random.fa"
    String collectWGSmetrics_picardJar = "$PICARD_ROOT/picard.jar"
    File inputBam
    String outputFileNamePrefix = basename(inputBam, '.bam')
  }

  call collectWGSmetrics {
    input:
      docker = docker,
      timeout = collectWGSmetrics_timeout,
      modules = collectWGSmetrics_modules,
      coverageCap = collectWGSmetrics_coverageCap,
      jobMemory = collectWGSmetrics_jobMemory,
      filter = collectWGSmetrics_filter,
      metricTag = collectWGSmetrics_metricTag,
      refFasta = collectWGSmetrics_refFasta,
      picardJar = collectWGSmetrics_picardJar,
      inputBam = inputBam,
      outputPrefix = outputFileNamePrefix
  }

  output {
    File outputWGSMetrics  = collectWGSmetrics.outputWGSMetrics
  }

  parameter_meta {
      docker: "Docker container to run the workflow in"
      collectWGSmetrics_timeout: "Maximum amount of time (in hours) the task can run for."
      collectWGSmetrics_modules: "Environment module names and version to load (space separated) before command execution"
      collectWGSmetrics_coverageCap: "Coverage cap, picard parameter"
      collectWGSmetrics_jobMemory: "memory allocated for Job"
      collectWGSmetrics_filter: "Picard filter to use"
      collectWGSmetrics_metricTag: "metric tag is used as a file extension for output"
      collectWGSmetrics_refFasta: "Path to the reference fasta"
      collectWGSmetrics_picardJar: "Picard jar file to use"
    inputBam: "Input file (bam or sam)."
    outputFileNamePrefix: "Output prefix to prefix output file names with."
  }

  meta {
    author: "Peter Ruzanov"
    email: "peter.ruzanov@oicr.on.ca"
    description: "Workflow to run picard WGSMetrics"
    dependencies: [{
      name: "picard/2.21.2",
      url: "https://broadinstitute.github.io/picard/"
    }]
  }
}

task collectWGSmetrics {
  input {
    String docker = "g3chen/wgspipeline@sha256:3c0c292c460c8db19b9744be1ea81529c4d189e4c4f9ca9a63046edcf792087d"
    File inputBam
    String picardJar = "$PICARD_ROOT/picard.jar"
    String refFasta = "$HG19_ROOT/hg19_random.fa"
    String metricTag = "WGS"
    String filter = "LENIENT"
    String outputPrefix = "OUTPUT"
    Int jobMemory = 18
    Int coverageCap = 500
    String modules = "picard/2.21.2 hg19/p13"
    Int timeout = 24
  }

  parameter_meta {
      docker: "Docker container to run the workflow in"
    picardJar: "Picard jar file to use"
    inputBam: "Input file (bam or sam)"
    refFasta: "Path to the reference fasta"
    metricTag: "metric tag is used as a file extension for output"
    filter: "Picard filter to use"
    outputPrefix: "Output prefix, either input file basename or custom string"
    jobMemory: "memory allocated for Job"
    coverageCap: "Coverage cap, picard parameter"
    modules: "Environment module names and version to load (space separated) before command execution"
    timeout: "Maximum amount of time (in hours) the task can run for."
  }

  meta {
    output_meta : {
      outputWGSMetrics: "Metrics about the fractions of reads that pass base and mapping-quality filters as well as coverage (read-depth) levels (see https://broadinstitute.github.io/picard/picard-metric-definitions.html#CollectWgsMetrics.WgsMetrics)"
    }
  }

  command <<<
    source /home/ubuntu/.bashrc 
    ~{"module load " + modules + " || exit 20; "} 

    java -Xmx~{jobMemory-6}G -jar ~{picardJar} \
    CollectWgsMetrics \
    TMP_DIR=picardTmp \
    R=~{refFasta} \
    COVERAGE_CAP=~{coverageCap} \
    INPUT=~{inputBam} \
    OUTPUT="~{outputPrefix}.~{metricTag}.txt" \
    VALIDATION_STRINGENCY=~{filter}
  >>>

  runtime {
    docker: "~{docker}"
    memory:  "~{jobMemory} GB"
    modules: "~{modules}"
    timeout: "~{timeout}"
  }

  output {
    File outputWGSMetrics = "~{outputPrefix}.~{metricTag}.txt"
  }
}
