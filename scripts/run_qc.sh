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

# ÖRNEK input değişkenleri (senin dosya isimlerine göre ayarla)
R1="data/raw/sample_R1.fastq.gz"
R2="data/raw/sample_R2.fastq.gz"

# ÖRNEK output isimleri
OUT_R1="results/trimmed/sample_R1.trim.fastq.gz"
OUT_R2="results/trimmed/sample_R2.trim.fastq.gz"

fastp \
  -i "$R1" -I "$R2" \
  -o "$OUT_R1" -O "$OUT_R2" \
  -h "results/fastp/fastp.html" \
  -j "results/fastp/fastp.json" \
  -q 20 \
  -l 50 \
  -w 4
