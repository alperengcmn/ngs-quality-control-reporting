## Dataset
- Accession: SRR390728
- Organism: Human
- Technology: Illumina
- Layout: Paired-end (RNA-seq)

## Run information
- Date:1/02/2026
- Tool: FastQC
- Input: data/raw/SRR390728_1.fastq.gz, data/raw/SRR390728_2.fastq.gz
- Output: results/fastqc_raw/

## Raw QC Findings
(Write 5–8 bullet points based on FastQC HTML reports.)

- Per base sequence quality:
- Per sequence quality scores:
- Per base sequence content:
- GC content:
- Adapter content:
- Overrepresented sequences:
- Sequence duplication levels:
- Sequence length distribution:
- Per-base quality scores decreased towards the 3’ end of reads, with several bases falling into low-quality regions, indicating the need for trimming.
- Adapter contamination was minimal, but trimming is still required due to quality decay at read ends.
- Duplication levels were moderate, consistent with RNA-seq data.
- GC content distribution was within expected range for human RNA-seq.
- Some overrepresented sequences were detected, likely reflecting technical or biological biases.
## Trimming rationale
Raw FastQC showed a clear quality drop towards the 3' end of reads (per-base quality), suggesting that trailing low-quality bases could affect downstream analyses. Therefore, trimming was applied to remove low-quality bases and discard overly short reads.

## Parameters used
Trimming was performed using fastp with the following parameters:

- `-q 20`: trim/filter bases/reads below Phred Q20
- `-l 30`: discard reads shorter than 30 bp after trimming
- `-w 6`: use 6 threads for faster processing

Outputs:
- Trimmed FASTQ: `results/trimmed/${SRA_ID}_1.trimmed.fastq.gz`, `results/trimmed/${SRA_ID}_2.trimmed.fastq.gz`
- fastp report: `results/fastp/fastp.html` and `results/fastp/fastp.json`
## Before vs After

- Per-base quality at the 3' end improved after trimming, reducing low-quality tails observed in raw reads.
- The overall per-sequence quality distribution shifted towards higher scores (fewer low-quality reads).
- Adapter-related signals  were reduced after trimming.
- Trimmed reads showed more consistent quality profiles across positions (R1 and R2).
- No major changes were observed in GC distribution, suggesting no new bias introduced by trimming.
## QC summary table highlights
- A summary table was generated from MultiQC data (`report/qc_summary.csv`) to compare QC metrics across samples (R1/R2 and raw/trimmed if present).
- The table highlights which sample has the highest number of WARN/FAIL modules and provides quick access to key metrics such as total sequences, GC%, read length, and duplication rate.
# QC Report — SRR390728 (RNA-seq)

## Dataset and Run Information
- Accession: SRR390728
- Organism: Human
- Technology: Illumina
- Layout: Paired-end (R1/R2)
- Read length: 36 bp
- Data source: NCBI Sequence Read Archive (SRA)

---

## Raw QC Findings

- **Per-base sequence quality** showed a clear drop in quality towards the 3’ end of reads, with several bases entering the warning/fail zones, indicating low-quality tails.
- **Per-sequence quality scores** indicated that most reads still had high overall average quality.
- **GC content** distribution was within expected range for human RNA-seq data, suggesting no major contamination.
- **Sequence duplication levels** were moderate; this is expected in RNA-seq due to highly expressed transcripts.
- **Adapter/overrepresented sequences** were present at low levels, but combined with quality drop, trimming was justified.

---

## Trimming Rationale and Parameters

Trimming was performed to remove low-quality bases at read ends and discard overly short reads that could negatively impact downstream analyses.

fastp parameters used:

- `-q 20` — trim/filter bases below Phred Q20
- `-l 30` — discard reads shorter than 30 bp after trimming
- `-w 6` — use 6 threads

Outputs:
- Trimmed FASTQ files in `results/trimmed/`
- fastp report in `results/fastp/`

---

## Post-QC Improvements

Post-trimming FastQC and MultiQC analysis showed:

- Improved quality profiles at read ends (reduced low-quality tails).
- More consistent per-base quality distribution across positions.
- Reduced signals from adapter/overrepresented sequences.
- GC distribution remained stable, indicating trimming did not introduce bias.

---

## Before vs After Comparison

- Quality degradation at the 3’ end was mitigated after trimming.
- Overall read quality distributions shifted toward higher confidence bases.
- No major change was observed in GC distribution.
- Read duplication levels remained within expected RNA-seq ranges.
- Adapter-related signals were reduced.

---

## Final Assessment

The dataset is **suitable for downstream analysis** (e.g., alignment and expression quantification).

### Notes / Caveats
- Short read length (36 bp) may limit mapping specificity compared to longer modern reads.
- RNA-seq duplication is biologically driven; interpretation should consider transcript abundance.

Overall, quality control and trimming steps successfully prepared the dataset for reliable downstream processing.
## Final Assessment

This RNA-seq dataset (SRR390728) underwent a complete quality control workflow including raw read assessment, trimming with fastp, and post-trim quality evaluation.

Raw FastQC results indicated a noticeable decline in base quality toward the end of reads, which is typical for Illumina sequencing data. No severe GC bias, duplication anomalies, or adapter overrepresentation were observed at levels that would invalidate downstream analysis.

Trimming was performed using fastp (Q20 quality threshold, minimum read length 30 bp). Post-trimming FastQC and MultiQC reports showed improved base quality consistency across read positions, while GC distribution and duplication levels remained stable, indicating no trimming-induced bias.

### Conclusion

The dataset is **suitable for downstream RNA-seq analysis** including alignment, expression quantification, and differential expression studies.

Minor quality degradation at read tails was effectively mitigated by trimming, and no critical QC issues remain.
