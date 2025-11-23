#!/usr/bin/env bash
set -e

EXEC="../../htsim_uec"
TOPO="../../topologies/topo_assignment2/fat_tree_128_1os.topo"
CM="../../connection_matrices/cm_assignment2/incast_64to2.cm"

END_TIME=30000
SEED=0

mkdir -p results

run_one() {
  local algo="$1"
  echo "=== Task4 incast: algo=${algo} ==="

  rm -f core_queue_usage.txt

  $EXEC \
    -nodes 128 \
    -topo "$TOPO" \
    -tm "$CM" \
    -sender_cc_algo dctcp \
    -load_balancing_algo "$algo" \
    -queue_type composite_ecn \
    -q 100 \
    -ecn 20 80 \
    -paths 200 \
    -cwnd 10 \
    -mtu 1500 \
    -end "$END_TIME" \
    -log queue_usage \
    -seed "$SEED" |
    tee "results/experiment_incast_${algo}.txt"

  if [[ -f core_queue_usage.txt ]]; then
    mv core_queue_usage.txt "results/queue_incast_${algo}.txt"
  else
    echo "[WARN] No core_queue_usage.txt generated for ${algo}"
  fi
}

run_one ecmp
run_one bitmap
run_one reps

echo "Done. Logs in results/"
