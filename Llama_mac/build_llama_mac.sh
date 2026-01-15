#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

if [ ! -d "llama.cpp" ]; then
  git clone https://github.com/ggml-org/llama.cpp
fi

cd llama.cpp

echo "Building llama.cpp with Metal support..."
make clean
make LLAMA_METAL=1

echo "Build complete."
