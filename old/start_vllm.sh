#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------
# Starts vLLM API server inside Ray head container
# ------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/cluster.env"

# Defensive defaults (prevents -u crashes)
: "${VLLM_PORT:=8000}"
: "${MODEL:?MODEL not set}"
: "${HEAD_NODE_IP:?HEAD_NODE_IP not set}"
: "${GPU_MEMORY_UTILIZATION:=0.85}"
: "${PIPELINE_PARALLEL_SIZE:=1}"
: "${TENSOR_PARALLEL_SIZE:=1}"
: "${DATA_PARALLEL_SIZE:=1}"
: "${MAX_MODEL_LEN:=24576}"
: "${MAX_NUM_SEQS:=32}"
: "${VLLM_TOOL_ARGS:=""}"

NODE=$(docker ps \
  --filter "ancestor=vllm/vllm-openai" \
  --format "{{.Names}}" | head -n1)

if [[ -z "${NODE}" ]]; then
  echo "ERROR: Ray head container not running."
  exit 1
fi

echo "[VLLM] Container : ${NODE}"
echo "[VLLM] Model     : ${MODEL}"
echo "[VLLM] Port      : ${VLLM_PORT}"
[[ -n "${VLLM_TOOL_ARGS}" ]] && echo "[VLLM] Tools     : Enabled" || echo "[VLLM] Tools     : Disabled"
echo "[VLLM] Ray Head  : ${HEAD_NODE_IP}"
echo

#    --distributed-executor-backend ray \
docker exec -it "${NODE}" bash -lc \
  "vllm serve ${MODEL} \
    --host 0.0.0.0 \
    --port ${VLLM_PORT}\
    --enforce-eager \
    --gpu-memory-utilization ${GPU_MEMORY_UTILIZATION}\
    --max-model-len ${MAX_MODEL_LEN}\
    --pipeline-parallel-size ${PIPELINE_PARALLEL_SIZE}\
    --tensor-parallel-size ${TENSOR_PARALLEL_SIZE}\
    --data-parallel-size ${DATA_PARALLEL_SIZE}\
    --max-num-seqs ${MAX_NUM_SEQS}\
    ${VLLM_TOOL_ARGS}"
