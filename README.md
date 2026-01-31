# NGS Quality Control & Reporting 

## Goal
Build a small RNA-seq QC pipeline:
raw QC → trimming → post-QC → reporting.

## Pipeline Steps
SRA → FASTQ → FastQC → MultiQC → fastp → FastQC → MultiQC → QC_Report

## Dataset
SRR390728 | Human | Illumina | Paired-end | RNA-seq
## Data acquisition
Data were obtained from NCBI Sequence Read Archive (SRA).

- Accession: SRR390728
- Layout: Paired-end (R1/R2)

Commands used:
```bash
prefetch SRR390728 -O data/sra
fasterq-dump SRR390728 --split-files -O data/raw
gzip data/raw/SRR390728_1.fastq
gzip data/raw/SRR390728_2.fastq
