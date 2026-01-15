#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MODEL_PATH="$SCRIPT_DIR/llama/models/qwen2.5-coder-1.5b-q6_k.gguf"
LLAMA_BIN="$SCRIPT_DIR/llama.cpp/server"

if [ ! -f "$MODEL_PATH" ]; then
  echo "Model not found: $MODEL_PATH"
  exit 1
fi

if [ ! -x "$LLAMA_BIN" ]; then
  echo "llama.cpp server binary not found. Run build_llama_mac.sh first."
  exit 1
fi

"$LLAMA_BIN" \
  --model "$MODEL_PATH" \
  --ctx-size 8192 \
  --threads 8 \
  --n-gpu-layers 999 \
  --host 0.0.0.0 \
  --port 8001
