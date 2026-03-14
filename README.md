# 🧬 NGS Quality Control & Reporting Pipeline

## 📌 Project Overview

This project implements an end-to-end **Next-Generation Sequencing (NGS) Quality Control pipeline** starting from raw SRA data to a final QC report.

The pipeline automates:

- Data download from SRA
- FASTQ conversion
- Raw quality control using FastQC
- Multi-sample aggregation using MultiQC
- Read trimming with fastp
- Post-trimming quality control
- Final structured QC report generation

This project demonstrates practical experience with real NGS data processing and reproducible pipeline design.

---

## 🔬 Dataset

- **SRA ID:** SRR390728  
- **Type:** Paired-end sequencing  
- **Source:** NCBI SRA  

---

## ⚙️ Pipeline Workflow

```
SRA → FASTQ → FastQC → MultiQC → fastp → FastQC → MultiQC → QC_Report
```

### Step-by-step Process

1. Download SRA data
2. Convert SRA to FASTQ
3. Run FastQC on raw reads
4. Aggregate reports with MultiQC
5. Perform trimming using fastp
6. Run FastQC on trimmed reads
7. Generate final MultiQC report
8. Prepare structured QC_Report.md

---

## 🛠 Requirements

- SRA Toolkit
- FastQC
- MultiQC
- fastp
- Bash (Linux / macOS / WSL)

---

## 🚀 Quickstart

To run the full QC pipeline:

```bash
bash scripts/run_qc.sh SRR390728
```

This command will automatically:

- Download data
- Perform raw QC
- Trim reads
- Perform post-trimming QC
- Generate MultiQC reports
- Save execution logs

---

## 📂 Output Structure

```
data/               → Raw downloaded data
results/
   raw_qc/          → FastQC reports (raw)
   trimmed/         → Trimmed FASTQ files
   post_qc/         → FastQC reports (after trimming)
   multiqc/         → Combined MultiQC reports
   fastp/           → fastp HTML & JSON reports
logs/               → Execution logs
QC_Report.md        → Final QC summary report
```

---

## 📊 Key QC Metrics Evaluated

- Per base sequence quality
- GC content
- Adapter contamination
- Sequence duplication levels
- Overrepresented sequences
- Read length distribution

---

## ✂️ Trimming Strategy

fastp was used to:

- Remove low-quality bases
- Remove adapter contamination
- Improve overall read quality before downstream analysis

Trimming decisions were based on:

- FastQC raw quality reports
- Presence of adapter sequences
- Per-base quality drop at read ends

---

## 📈 Project Highlights

- Fully automated Bash pipeline
- Reproducible workflow
- Clear folder organization
- Version-controlled (v1.0 release)
- Structured QC documentation
- Ready for integration into alignment & variant calling workflows

---

## 🎯 Future Improvements

- Add alignment step (BWA)
- Add variant calling (GATK)
- Add visualization using IGV
- Convert pipeline into Snakemake or Nextflow workflow

---

## 👨‍💻 Author

Alperen Göçmen  
BSc Genetics Student | Aspiring Bioinformatics Specialist
