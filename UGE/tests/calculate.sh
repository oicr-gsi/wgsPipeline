#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

#enter the workflow's final output directory ($1)
cd $1

# fastqc
find . -type f -name "*.html" | sed 's/.*\.//' | sort | uniq -c
find . -type f -name "*.zip" | sed 's/.*\.//' | sort | uniq -c

# bwaMem
find . -type f -name "*output.txt" -exec sh -c "wc -l {}" \;
find . -type f -name "*output.log" -exec sh -c "wc -l {}" \;

# bamMergePreprocessing
find . -type f -name "*gatk.recalibration*" -exec sh -c "wc -l {}" \;

# bamQC
module load jq
module load python/3.6
# remove the Picard header because it includes temporary paths
for f in ./*.bamQC_results.json; do
    jq 'del(.picard | .header)' "$f" | tail -n 9 | head -n 8;
done

# wgsMetrics @@@ check out original metrics
find . -type f -name "*.WGS.txt" -exec sh -c "wc -l {}" \;

# insertSizeMetrics
find . -type f -name "*.histogram.pdf" -exec sh -c "wc -l {}" \;
find . -type f -name "*.isize.txt" -exec sh -c "wc -l {}" \;

# callability
module load jq
jq -c . *callability_metrics.json
