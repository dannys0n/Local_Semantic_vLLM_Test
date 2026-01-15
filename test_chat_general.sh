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
    \"model\": \"Qwen/Qwen3-4B\",
    \"messages\": [
      {\"role\": \"user\", \"content\": \"make a function of adding 2 integers /no_think\"}
    ],
    \"max_tokens\": 1000
  }" | jq .
