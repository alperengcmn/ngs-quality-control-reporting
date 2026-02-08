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
## Outputs

### Raw QC summary (MultiQC)
MultiQC report generated from raw FastQC results:

- `results/multiqc_raw/multiqc_report.html`

Screenshots:

![MultiQC raw overview](assets/multiqc_raw_overview.png)
![MultiQC per base quality](assets/multiqc_raw_per_base_quality.png)
![MultiQC adapters/overrepresented](assets/multiqc_raw_adapters_or_overrep.png)
## Outputs

### Raw QC summary (MultiQC)

MultiQC report generated from raw FastQC results:

- `results/multiqc_raw/multiqc_report.html`

Screenshots:

![MultiQC general statistics](assets/multiqc_raw_general_statistics.png)
![MultiQC sequence quality histograms](assets/multiqc_raw_sequence_quality_histograms.png)
![MultiQC per base quality](assets/multiqc_raw_per_base_quality.png)


---

### Trimming report (fastp)

Reads were trimmed to remove low-quality bases and short reads based on FastQC results.

Screenshots from fastp report:

![Filtering result](assets/fastp_filtering_result.png)
![Read 1 quality](assets/fastp_read1_quality.png)
![Read 2 quality](assets/fastp_read2_quality.png)
Summary table generated: `report/qc_summary.csv`
## Requirements

- SRA Toolkit (prefetch, fasterq-dump)
- FastQC
- MultiQC
- fastp
- Python 3

## Quickstart

Tüm QC pipeline’ı çalıştırmak için:

bash scripts/run_qc.sh SRR390728

## Outputs

- Raw FastQC → results/fastqc_raw/
- Raw MultiQC → results/multiqc_raw/multiqc_report.html
- Trimmed FASTQ → results/trimmed/
- fastp report → results/fastp/fastp.html
- Post-trim FastQC → results/fastqc_trimmed/
- Combined MultiQC → results/multiqc_all/multiqc_report.html
- QC summary table → report/qc_summary.csv

## Project Highlights

- End-to-end RNA-seq QC pipeline
- Raw vs Trimmed quality comparison
- fastp trimming + HTML report
- MultiQC consolidated reports
- Automated QC summary table
