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
    \"model\": \"google/gemma-3-4b-it\",
    \"messages\": [
      {\"role\": \"user\", \"content\": \"make a function of adding 2 integers\"}
    ],
      \"chat_template_kwargs\": {
    \"enable_thinking\": false
  },
    \"max_tokens\": 1000
  }" | jq .
