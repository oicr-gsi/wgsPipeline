# dockstore_wgsPipeline

Wrapper workflow for the WGS Analysis Pipeline

### Workflow

Currently, the WDL wrapper only contains the top 9 workflows, from Bcl2Fastq to Mutect Callability. 
The workflow is made to run in Docker and uploaded to [Dockstore](https://docs.dockstore.org/en/develop/getting-started/getting-started.html).
You can find OICR's Dockstore page [here](https://dockstore.org/organizations/OICR).
The Docker container is based on [Modulator](https://gitlab.oicr.on.ca/ResearchIT/modulator) which builds environment modules according to the runtime needs of the workflow.

<p align="center">
  <img src="./WGSPipeline.PNG" alt="WGS Pipeline Diagram" width="1306">
</p>

### Progress

Workflow Name|Uploaded to Dockstore?|Tested With Preprocess?|Modules Built in Container?|Integrated Into Pipeline?
---|---|---|---|---
bcl2fastq|Y|Y|Y|Y
fastQC|Y|Y|Y|Y
bwaMem|Y|Y|Y|Y
bamQC|Y|Y|Y|Y
bamMergePreprocess|Y|Y|Y|Y
wgsMetrics|Y|Y|Y|Y
insertSizeMetrics|Y|Y|Y|Y
callability|Y|Y|Y|Y
variantEffectPredictor|Y|Y|Y|N
haplotypeCaller|Y|Y|Y|N
sequenza|Y|Y|Y|N
delly|Y|Y|Y|N
mutect2|Y|Y|Y|N
mavis|N|N|Y|N
genotype gVCF|N|N|N|N
sampleFingerprinting|N|N|N|N
JANUS:MutationExtended|N|N|N|N
JANUS:CopyNumberAlteration|N|N|N|N
JANUS:Fusion|N|N|N|N

### Preprocess

Subworkflows are preprocessed using subworkflow_preprocess in [gsi-wdl-tools](https://github.com/oicr-gsi/gsi-wdl-tools).
The script changes task-level variables to workflow-level variables, and adds a Docker parameter in each runtime.

### Limitations

- The workflow requires Cromwell configs and options to run, due to mounting local data modules to the container --> improve the preprocessor to eliminate all supplemental config requirements.
- Dockstore tests are not automated --> implement Dockstore checker workflows
- Dockstore refresh is not automated --> implement Dockstore GitHub Apps