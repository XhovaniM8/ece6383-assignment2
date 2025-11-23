# ECE 6383 – Assignment 2  
### Load Balancing in HTSIM (UEC Version)

This repository contains my complete work for **Assignment 2** of *ECE-GY 6383 High-Speed Networks* at NYU.  
It includes simulations and analysis for the following load-balancing algorithms implemented in the UEC version of HTSIM:

- **ECMP** – Equal-Cost Multi-Path  
- **OPS** – Oblivious Packet Spraying  
- **REPS** – Recycled Entropy Packet Spraying  

---

## Repository Structure

```
1.1_topoplogy      # Topology file used in Task 1
task1/             # One-to-one communication experiments
task2/             # Queue logging + queue variance analysis
task3/             # Link degradation experiments
task4/             # Custom incast experiment design
```

---

## Task Summaries

### **Task 1 — One-to-One Communication**
Simulates a single large flow under a Fat-Tree topology using ECMP, OPS, and REPS.  
Metrics collected:
- Flow Completion Time (FCT)
- Last 5 RTT samples
- Packets-in-flight
- Throughput

Output files in `task1/results/`.

---

### **Task 2 — Queue Size & Variance**
Logs queue lengths across all core switches.  
Evaluates how evenly each algorithm distributes traffic.  
Outputs stored in `task2/`.

---

### **Task 3 — Link Degradation**
Simulates reduced AGG→Core link capacity using the `-failed` flag.  
Compares resiliency of OPS vs REPS under partial failures.  
Outputs stored in `task3/results/`.

---

### **Task 4 — Custom Incast Experiment**
Implements a **64-to-2 incast** (many senders → few receivers).  
Evaluates:
- FCT under heavy contention  
- Queue variance imbalance  

Results in `task4/results/`.

---

## Running the Experiments

Clone and build the UEC HTSIM environment:

```bash
git clone https://github.com/Pilusimida/spcl_HTSIM
cd spcl_HTSIM/htsim/sim
chmod +x BUILD.sh
./BUILD.sh
```

Each task folder contains runnable scripts such as:

```
run_test.sh
run_lb_experiments.sh
run_switch_queue_logging.sh
run_test_with_failed.sh
run_task4_incast.sh
```

---

## Notes

- All simulation outputs in this repo are **real**, produced directly by HTSIM.
- No external dependencies are required beyond the standard UEC HTSIM build.
- This repo intentionally contains **only Assignment 2**, not the full HTSIM project.

---

## Author
**Xhovani Mali**  
NYU Tandon School of Engineering  
GitHub: https://github.com/XhovaniM8/ece6383-assignment2

