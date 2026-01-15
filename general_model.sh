docker run --runtime nvidia --gpus all \
	--name vllm_general_model \
	-v ~/.cache/huggingface:/root/.cache/huggingface \
 	--env "HUGGING_FACE_HUB_TOKEN=<secret>" \
	-p 8000:8000 \
	--ipc=host \
	vllm/vllm-openai:latest \
	--model Qwen/Qwen3-4B \
	--gpu-memory-utilization 0.7  \
	--max-num-seqs 4 \
	--max-model-len 2048 \
	--enforce-eager \
	--port 8000


	#--max-model-len 8192 \

	# the following are for memory optimizations for larger models
	#--gpu-memory-utilization \
	#--max-num-seqs \
	#--max-model-len \
	#--enforce-eager \