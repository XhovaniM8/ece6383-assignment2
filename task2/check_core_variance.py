#!/usr/bin/env python3
import os
import re
import statistics

RESULT_DIRS = ["ecmp_results", "ops_results", "reps_results"]
FILENAME = "core_queue_usage.txt"

# Regexes to extract fields
RE_CORE = re.compile(r"Name\s+Switch_Core_(\d+)")
RE_LASTQ = re.compile(r"LastQ\s+(\d+)")

def load_core_samples(path):
    """
    Parse core_queue_usage.txt and return:
      - dict: core_id -> list of LastQ samples
    """
    core_samples = {}
    with open(path, "r") as f:
        for line in f:
            if "Switch_Core_" not in line or "LastQ" not in line:
                continue

            m_core = RE_CORE.search(line)
            m_lastq = RE_LASTQ.search(line)
            if not m_core or not m_lastq:
                continue

            core = int(m_core.group(1))
            lastq = int(m_lastq.group(1))

            core_samples.setdefault(core, []).append(lastq)
    return core_samples

def analyze_result_dir(result_dir):
    path = os.path.join(result_dir, FILENAME)
    if not os.path.exists(path):
        print(f"[{result_dir}] WARNING: {FILENAME} not found, skipping.")
        return

    core_samples = load_core_samples(path)
    if not core_samples:
        print(f"[{result_dir}] No core samples found.")
        return

    # Compute average LastQ per core
    core_avgs = {
        core: sum(vals) / len(vals)
        for core, vals in core_samples.items()
    }

    # Sort by core id for stable output
    sorted_cores = sorted(core_avgs.items(), key=lambda kv: kv[0])
    avgs_list = [avg for _, avg in sorted_cores]

    # Population and sample variance across core averages
    pop_var = statistics.pvariance(avgs_list)
    samp_var = statistics.variance(avgs_list) if len(avgs_list) > 1 else 0.0

    print(f"\n=== {result_dir} ===")
    print("Per-core average LastQ (bytes):")
    for core, avg in sorted_cores:
        print(f"  Core_{core:2d}: {avg:.2f}")

    print(f"\n  Population variance of per-core averages: {pop_var:.2f} bytes^2")
    print(f"  Sample     variance of per-core averages: {samp_var:.2f} bytes^2")

def main():
    for d in RESULT_DIRS:
        if not os.path.isdir(d):
            print(f"[WARNING] Directory {d} does not exist, skipping.")
            continue
        analyze_result_dir(d)

if __name__ == "__main__":
    main()

