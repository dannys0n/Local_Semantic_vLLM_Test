#!/usr/bin/env bash
set -euo pipefail
#\"max_tokens\": 1280
# ------------------------------------------------------------
# Sends a test OpenAI-compatible chat request
# ------------------------------------------------------------

source "$(dirname "$0")/cluster.env"

curl -s http://127.0.0.1:8001/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d "{
    \"model\": \"Qwen/Qwen2.5-Coder-1.5B\",
    \"messages\": [
      {\"role\": \"user\", \"content\": \"generate a function to add two integers together\"}
    ],
    \"max_tokens\": 500
  }" | jq .
