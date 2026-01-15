#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

docker run --rm \
  --name llama_code_model \
  --gpus all \
  -p 8001:8080 \
  -v "$SCRIPT_DIR/llama/models:/models" \
  ghcr.io/ggml-org/llama.cpp:server-cuda \
  --model /models/qwen2.5-1.5b-instruct-q6_k.gguf \
  --host 0.0.0.0 \
  --port 8080
