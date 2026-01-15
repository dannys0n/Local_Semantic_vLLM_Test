docker run --runtime nvidia --gpus all     \
 	--name vllm_code_model      \
  	-v ~/.cache/huggingface:/root/.cache/huggingface     \
   	--env "HUGGING_FACE_HUB_TOKEN=<secret>"      \
    -p 8001:8001   \
	--ipc=host    \
	vllm/vllm-openai:latest \
	--model Qwen/Qwen2.5-Coder-1.5B \
	--tokenizer-mode auto \
	--max-model-len 8192 \
	--max-num-seqs 8 \
	--port 8001
	#--gpu-memory-utilization 0.8  \
