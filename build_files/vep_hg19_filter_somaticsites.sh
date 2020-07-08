#!/bin/sh
set -eu 
echo "##FILTER=<ID=AC_Adj0_Filter,Description=\"Only low quality genotype calls containing alternate alleles are present\">" > header_line.tmp
bcftools annotate --header-lines header_line.tmp --remove FMT,^INF/AF,INF/AC,INF/AN,INF/AC_Adj,INF/AN_Adj,INF/AC_AFR,INF/AC_AMR,INF/AC_EAS,INF/AC_FIN,INF/AC_NFE,INF/AC_OTH,INF/AC_SAS,INF/AN_AFR,INF/AN_AMR,INF/AN_EAS,INF/AN_FIN,INF/AN_NFE,INF/AN_OTH,INF/AN_SAS $1 | bcftools filter --targets-file ^$2 --output-type z --output $3
tabix -p vcf $3
