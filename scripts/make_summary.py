#!/usr/bin/env python3
from __future__ import annotations

import os
import sys
from pathlib import Path

import pandas as pd


def find_file(multiqc_data_dir: Path, candidates: list[str]) -> Path:
    for name in candidates:
        p = multiqc_data_dir / name
        if p.exists():
            return p
    raise FileNotFoundError(
        f"Could not find any of these files in {multiqc_data_dir}:\n"
        + "\n".join(candidates)
    )


def read_tsv(path: Path) -> pd.DataFrame:
    # MultiQC tables are usually tab-separated with a header row
    return pd.read_csv(path, sep="\t", dtype=str)


def main() -> int:
    if len(sys.argv) != 3:
        print("Usage: python scripts/make_summary.py results/multiqc_all/multiqc_data report/qc_summary.csv")
        return 2

    multiqc_data_dir = Path(sys.argv[1]).expanduser().resolve()
    out_csv = Path(sys.argv[2]).expanduser().resolve()
    out_csv.parent.mkdir(parents=True, exist_ok=True)

    if not multiqc_data_dir.exists():
        print(f"ERROR: multiqc_data dir not found: {multiqc_data_dir}")
        return 1

    general_stats_path = find_file(
        multiqc_data_dir,
        [
            "multiqc_fastqc_general_stats.txt",
            "multiqc_fastqc_general_stats.tsv",
            "multiqc_fastqc_general_stats.csv",
        ],
    )

    summary_path = find_file(
        multiqc_data_dir,
        [
            "multiqc_fastqc_summary.txt",
            "multiqc_fastqc_summary.tsv",
            "multiqc_fastqc_summary.csv",
        ],
    )

    gs = read_tsv(general_stats_path)
    sm = read_tsv(summary_path)

    # Normalize column names (MultiQC sometimes changes case/spaces)
    gs.columns = [c.strip() for c in gs.columns]
    sm.columns = [c.strip() for c in sm.columns]

    # Sample column: usually "Sample" in MultiQC tables
    sample_col_gs = "Sample" if "Sample" in gs.columns else gs.columns[0]
    sample_col_sm = "Sample" if "Sample" in sm.columns else sm.columns[0]

    # Pick a few useful metrics if they exist
    def pick_col(df: pd.DataFrame, options: list[str]) -> str | None:
        for c in options:
            if c in df.columns:
                return c
        return None

    col_total_seqs = pick_col(gs, ["Total Sequences", "Total Seqs", "Total sequences"])
    col_gc = pick_col(gs, ["%GC", "GC %", "GC"])
    col_len = pick_col(gs, ["Sequence length", "Sequence Length", "Length"])
    col_dups = pick_col(gs, ["%Duplication", "% Dups", "Dups", "Duplication"])

    out = pd.DataFrame()
    out["sample"] = gs[sample_col_gs]

    if col_total_seqs:
        out["total_sequences"] = gs[col_total_seqs]
    else:
        out["total_sequences"] = ""

    if col_gc:
        out["gc_percent"] = gs[col_gc]
    else:
        out["gc_percent"] = ""

    if col_len:
        out["sequence_length"] = gs[col_len]
    else:
        out["sequence_length"] = ""

    if col_dups:
        out["duplication_percent"] = gs[col_dups]
    else:
        out["duplication_percent"] = ""

    # FastQC module PASS/WARN/FAIL counts from summary table
    # Expected columns: Sample, Module, Status (sometimes "Category" etc.)
    module_col = pick_col(sm, ["Module", "module", "Metric", "metric"])
    status_col = pick_col(sm, ["Status", "status", "Result", "result"])

    if module_col and status_col:
        sm_small = sm[[sample_col_sm, module_col, status_col]].copy()
        sm_small.columns = ["sample", "module", "status"]

        # Count statuses
        counts = (
            sm_small.pivot_table(
                index="sample",
                columns="status",
                values="module",
                aggfunc="count",
                fill_value=0,
            )
            .reset_index()
        )

        # Ensure columns exist
        for c in ["pass", "warn", "fail", "PASS", "WARN", "FAIL"]:
            if c not in counts.columns:
                counts[c] = 0

        # Merge both lower/upper variants
        counts["n_pass"] = counts.get("PASS", 0) + counts.get("pass", 0)
        counts["n_warn"] = counts.get("WARN", 0) + counts.get("warn", 0)
        counts["n_fail"] = counts.get("FAIL", 0) + counts.get("fail", 0)

        counts = counts[["sample", "n_pass", "n_warn", "n_fail"]]

        out = out.merge(counts, how="left", left_on="sample", right_on="sample")
        out[["n_pass", "n_warn", "n_fail"]] = out[["n_pass", "n_warn", "n_fail"]].fillna(0).astype(int)

        # Worst modules list (FAIL first, then WARN)
        worst = (
            sm_small[sm_small["status"].str.upper().isin(["FAIL", "WARN"])]
            .sort_values(["sample", "status"])
            .groupby("sample")["module"]
            .apply(lambda s: "; ".join(s.astype(str).tolist()))
            .reset_index()
            .rename(columns={"module": "flagged_modules"})
        )
        out = out.merge(worst, how="left", on="sample")
        out["flagged_modules"] = out["flagged_modules"].fillna("")
    else:
        out["n_pass"] = 0
        out["n_warn"] = 0
        out["n_fail"] = 0
        out["flagged_modules"] = ""

    # Sort: worst first
    out = out.sort_values(["n_fail", "n_warn"], ascending=[False, False])

    out.to_csv(out_csv, index=False)
    print(f"OK: wrote {out_csv}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
