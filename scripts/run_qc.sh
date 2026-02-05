#!/usr/bin/env bash
set -euo pipefail
SRA_ID="${1:-}"


echo "Starting QC pipeline skeleton..."

mkdir -p data/raw data/sra results report assets logs

echo "OK: project skeleton ready"
echo "STEP 1: Download SRA and generate FASTQ (manual step for now)"
echo "  prefetch ${SRA_ID} -O data/sra"
echo "  fasterq-dump ${SRA_ID} --split-files -O data/raw"
echo "  gzip data/raw/${SRA_ID}_1.fastq data/raw/${SRA_ID}_2.fastq"
echo "STEP 2: Raw FastQC"
echo "STEP 3: Raw MultiQC"

mkdir -p results/multiqc_raw

multiqc results/fastqc_raw -o results/multiqc_raw

echo "  fastqc data/raw/*.fastq.gz -o results/fastqc_raw"
echo "STEP 4: fastp trimming"
mkdir -p results/trimmed results/fastp
fastp \
  -i data/raw/${SRA_ID}_1.fastq.gz \
  -I data/raw/${SRA_ID}_2.fastq.gz \
  -o results/trimmed/${SRA_ID}_1.trimmed.fastq.gz \
  -O results/trimmed/${SRA_ID}_2.trimmed.fastq.gz \
  -h results/fastp/fastp.html \
  -j results/fastp/fastp.json \
  -q 20 -l 30 -w 6
echo "STEP 5: Post-trim FastQC"
mkdir -p results/fastqc_trimmed
fastqc results/trimmed/*.fastq.gz -o results/fastqc_trimmed

echo "STEP 6: Combined MultiQC (raw + trimmed + fastp)"
mkdir -p results/multiqc_all
multiqc results -o results/multiqc_all

