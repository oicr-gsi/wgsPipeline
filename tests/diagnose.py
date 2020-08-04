import WDL
import argparse
import csv, json

parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument("--summary", required = False)
parser.add_argument("--globalD", required = False)
args = parser.parse_args()

if args.summary:
    summary = open(args.summary).readlines()
else:
    summary = open("/home/ubuntu/repos/wgsPipeline/cromwell-executions/top4/3dc65f40-246d-42c8-8067-45e42a1ffbc6/call-rawBamQC/shard-1/bamQC/8e593f88-1308-4eea-aa7f-fe4e6aaa5eee/call-cumulativeDistToHistogram/inputs/-1902759171/bamqc.mosdepth.summary.txt").readlines()

if args.globalD:
    globalDist = open(args.globalD).readlines()
else:
    globalDist = open("/home/ubuntu/repos/wgsPipeline/cromwell-executions/top4/3dc65f40-246d-42c8-8067-45e42a1ffbc6/call-rawBamQC/shard-1/bamQC/8e593f88-1308-4eea-aa7f-fe4e6aaa5eee/call-cumulativeDistToHistogram/inputs/-1902759171/bamqc.mosdepth.global.dist.txt").readlines()
# read chromosome lengths from the summary
summaryReader = csv.reader(summary, delimiter="\t")
lengthByChr = {}
for row in summaryReader:
    if row[0] == 'chrom' or row[0] == 'total':
        continue # skip initial header row, and final total row
    lengthByChr[row[0]] = int(row[1])
chromosomes = sorted(lengthByChr.keys())
# read the cumulative distribution for each chromosome
globalReader = csv.reader(globalDist, delimiter="\t")
cumDist = {}
for k in chromosomes:
    cumDist[k] = {}
for row in globalReader:
    if row[0]=="total":
        continue
    cumDist[row[0]][int(row[1])] = float(row[2])
# convert the cumulative distributions to non-cumulative and populate histogram
histogram = {}
for k in chromosomes:
    depths = sorted(cumDist[k].keys())
    dist = {}
    for i in range(len(depths)-1):
        depth = depths[i]
        nextDepth = depths[i+1]
        dist[depth] = cumDist[k][depth] - cumDist[k][nextDepth]
    maxDepth = max(depths)
    dist[maxDepth] = cumDist[k][maxDepth]
    # now find the number of loci at each depth of coverage to construct the histogram
    for depth in depths:
        loci = int(round(dist[depth]*lengthByChr[k], 0))
        histogram[depth] = histogram.get(depth, 0) + loci
# fill in zero values for missing depths
for i in range(max(histogram.keys())):
    if i not in histogram:
        histogram[i] = 0
out = open("coverage_histogram.json", "w")
json.dump(histogram, out, sort_keys=True)
out.close()