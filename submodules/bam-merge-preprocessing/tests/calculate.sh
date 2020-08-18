#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

cd $1

qrsh -l h_vmem=8G -cwd -now n "\
. /oicr/local/Modules/default/init/bash; \
module load samtools 2>/dev/null; \
find . -regex '.*\.bam$' \
       -exec sh -c \" samtools flagstat {} | tr '\n' '\t'; echo ; printf "{}="; samtools view {} | md5sum \" \; \
| sort | uniq | tr '\t' '\n'"

# get a listing of the output files
ls -1