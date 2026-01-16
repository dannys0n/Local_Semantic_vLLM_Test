#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MODEL_PATH="$SCRIPT_DIR/llama/models/Qwen_Qwen2.5-Coder-1.5B-Instruct-GGUF_qwen2.5-coder-1.5b-instruct-q6_k.gguf"
LLAMA_BIN="$SCRIPT_DIR/llama.cpp/server"

if [ ! -f "$MODEL_PATH" ]; then
  echo "Model not found: $MODEL_PATH"
  exit 1
fi

llama-server \
  --model "$MODEL_PATH" \
  --ctx-size 8192 \
  --threads 8 \
  --n-gpu-layers 999 \
  --host 0.0.0.0 \
  --port 8001
