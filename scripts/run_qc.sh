#!/usr/bin/env bash
set -euo pipefail

SRA_ID="${1:-SRR390728}"
THREADS=6

mkdir -p data/sra data/raw results logs report

LOG="logs/run_${SRA_ID}.log"
exec > >(tee -a "$LOG") 2>&1

echo "Pipeline started for $SRA_ID"

echo "STEP 1: Download + FASTQ"
prefetch "$SRA_ID" -O data/sra
fasterq-dump "$SRA_ID" --split-files -O data/raw -e "$THREADS"
gzip -f data/raw/${SRA_ID}_1.fastq
gzip -f data/raw/${SRA_ID}_2.fastq

echo "STEP 2: Raw FastQC"
mkdir -p results/fastqc_raw
fastqc data/raw/${SRA_ID}_*.fastq.gz -o results/fastqc_raw -t "$THREADS"

echo "STEP 3: Raw MultiQC"
mkdir -p results/multiqc_raw
multiqc results/fastqc_raw -o results/multiqc_raw

echo "STEP 4: fastp trimming"
mkdir -p results/trimmed results/fastp
fastp \
-i data/raw/${SRA_ID}_1.fastq.gz \
-I data/raw/${SRA_ID}_2.fastq.gz \
-o results/trimmed/${SRA_ID}_1.trimmed.fastq.gz \
-O results/trimmed/${SRA_ID}_2.trimmed.fastq.gz \
-h results/fastp/fastp.html \
-j results/fastp/fastp.json \
-q 20 -l 30 -w "$THREADS"

echo "STEP 5: Post-trim FastQC"
mkdir -p results/fastqc_trimmed
fastqc results/trimmed/*.fastq.gz -o results/fastqc_trimmed -t "$THREADS"

echo "STEP 6: Combined MultiQC"
mkdir -p results/multiqc_all
multiqc results -o results/multiqc_all

echo "Pipeline finished."
