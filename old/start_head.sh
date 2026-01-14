#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/cluster.env"
#source "${SCRIPT_DIR}/detect_net.sh"
IFACE="enp129s0" #testing hard coded

VLLM_HOST_IP=${HEAD_NODE_IP}
mkdir -p "${HF_HOME}"

EXTRA_ARGS=(
  -e "VLLM_HOST_IP=${VLLM_HOST_IP}"
  -e "MASTER_ADDR=${HEAD_NODE_IP}"
  -e "MASTER_PORT=41001"
)

[[ -n "${HF_TOKEN:-}" ]] && EXTRA_ARGS+=(-e "HF_TOKEN=${HF_TOKEN}")

echo "[HEAD] Using IFACE=${IFACE} IP=${VLLM_HOST_IP}"

exec ./run_cluster.sh \
  "${VLLM_IMAGE}" \
  "${HEAD_NODE_IP}" \
  --head \
  "${HF_HOME}" \
  "${EXTRA_ARGS[@]}"
