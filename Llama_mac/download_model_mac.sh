#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MODEL_DIR="$SCRIPT_DIR/llama/models"

mkdir -p "$MODEL_DIR"
cd "$MODEL_DIR"

MODEL_NAME="qwen2.5-coder-1.5b-q6_k.gguf"
MODEL_URL="https://huggingface.co/Qwen/Qwen2.5-Coder-1.5B-GGUF/resolve/main/$MODEL_NAME"

echo "Downloading $MODEL_NAME..."
curl -L -o "$MODEL_NAME" "$MODEL_URL"

echo "Model downloaded to $MODEL_DIR/$MODEL_NAME"
