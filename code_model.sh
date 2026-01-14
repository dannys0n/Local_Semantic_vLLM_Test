docker run --runtime nvidia --gpus all     \
 	--name my_vllm_code      \
  	-v ~/.cache/huggingface:/root/.cache/huggingface     \
   	--env "HUGGING_FACE_HUB_TOKEN=<secret>"      \
    -p 8001:8001   \
	--ipc=host    \
	vllm/vllm-openai:latest \
	--model Qwen/Qwen2.5-Coder-1.5B \
	--gpu-memory-utilization 0.4  \
	--max-num-seqs 128 \
	--max-model-len 16820 \
	--port 8001
	#--max-model-len 8192 \
