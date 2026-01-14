docker run --runtime nvidia --gpus all \
	--name my_vllm_general \
	-v ~/.cache/huggingface:/root/.cache/huggingface \
 	--env "HUGGING_FACE_HUB_TOKEN=<secret>" \
	-p 8000:8000 \
	--ipc=host \
	vllm/vllm-openai:latest \
	--model Qwen/Qwen2.5-0.5B-Instruct \
	--gpu-memory-utilization 0.2  \
	--max-num-seqs 128 \
	--max-model-len 8192