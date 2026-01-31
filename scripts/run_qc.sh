#!/usr/bin/env bash
set -euo pipefail

echo "Starting QC pipeline skeleton..."

mkdir -p data/raw data/sra results report assets logs

echo "OK: project skeleton ready"
echo "STEP 1: Download SRA and generate FASTQ (manual step for now)"
echo "  prefetch ${SRA_ID} -O data/sra"
echo "  fasterq-dump ${SRA_ID} --split-files -O data/raw"
echo "  gzip data/raw/${SRA_ID}_1.fastq data/raw/${SRA_ID}_2.fastq"
