#!/usr/bin/env bash
set -euo pipefail
#\"max_tokens\": 1280
# ------------------------------------------------------------
# Sends a test OpenAI-compatible chat request
# ------------------------------------------------------------

source "$(dirname "$0")/cluster.env"

curl -s http://${HEAD_NODE_IP}:${VLLM_PORT}/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d "{
    \"model\": \"${MODEL}\",
    \"messages\": [
      {\"role\": \"user\", \"content\": \"Confirm the Ray cluster is running.\"}
    ],
    \"max_tokens\": 1
  }" | jq .