#!/usr/bin/env bash
set -e

# Parameters
EXECUTABLE="../../../build/datacenter/htsim_uec"
TOPOLOGY="../../topologies/topo_assignment2/fat_tree_128_1os.topo"
CONNECTION_MATRIX="../../connection_matrices/cm_assignment2/one.cm"

FAILED=64     # ~50% of AGG→Core links degraded (adjust if you want)
END_TIME=1000 # same as before

mkdir -p results

run_one() {
  local algo="$1" # bitmap or reps
  local tag="$2"  # ops or reps (just for filename)

  echo "=== Running algo=${algo}, failed=${FAILED} ==="

  $EXECUTABLE \
    -nodes 128 \
    -topo "$TOPOLOGY" \
    -tm "$CONNECTION_MATRIX" \
    -sender_cc_algo dctcp \
    -load_balancing_algo "$algo" \
    -queue_type composite_ecn \
    -q 100 \
    -ecn 20 80 \
    -paths 200 \
    -cwnd 10 \
    -mtu 1500 \
    -end "$END_TIME" \
    -failed "$FAILED" \
    -log flow_events \
    -seed 0 \
    >"results/experiment_failed${FAILED}_${tag}.txt"
}

# bitmap ≈ OPS
run_one bitmap ops
run_one reps reps

echo "Done. Text logs are in:"
echo "  results/experiment_failed${FAILED}_ops.txt"
echo "  results/experiment_failed${FAILED}_reps.txt"
