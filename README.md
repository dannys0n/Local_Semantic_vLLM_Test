# Local Semantic vLLM Test

A small test setup for **vLLM Semantic Router**: routing prompts to specialized LLM endpoints based on context (e.g. code vs general). One machine runs the router and a local endpoint; a second machine (Mac) runs another endpoint as a worker.

<img width="1611" height="898" alt="setup" src="https://github.com/user-attachments/assets/fcb36bd6-cf49-471a-9778-8acfd9a63df5" />

- prompt "what is the most common disease" called local general model
![local-model](https://github.com/user-attachments/assets/dd0450d5-9731-4329-8edf-d074efc1aeca)

- prompt "make me a function to add integers" called specialized model over network
![lan-model](https://github.com/user-attachments/assets/0afd6c8f-53d4-4943-a686-10b69ac0bd10)

## What this repo does

- Runs a **semantic router** that decides which model endpoint to call (e.g. code-focused vs general).
- **Machine 1:** Router + one vLLM endpoint (e.g. local Llama server).
- **Machine 2 (Mac):** Second vLLM endpoint (worker), so the router can route to either endpoint.

Useful for trying out semantic routing locally and across two machines before scaling up.

## Layout

| Path | Purpose |
|------|--------|
| `Config/` | Router/endpoint configuration |
| `Llama_server_local/` | Local server (single-machine) endpoint setup |
| `Llama_mac/` | Mac worker endpoint setup |
| `config.yaml` | Semantic router config (endpoints, routes) |
| `cluster.env` | Environment variables for multi-machine (e.g. Mac worker URL) |
| `start_semantic.sh` / `stop_semantic.sh` | Start/stop the semantic router |
| `code_model.sh` / `general_model.sh` | Start code vs general model endpoints |
| `test_chat_code.sh` / `test_chat_general.sh` | Test routing to code vs general |

## Prerequisites

- [vLLM](https://docs.vllm.ai/) (and Semantic Router / routing layer you’re using)
- Two machines on the same network (or reachable): one for router + local endpoint, one (e.g. Mac) for the second endpoint
- Shell (scripts are written for a Unix-style environment; Mac is supported for the worker)

## Quick start

1. **On the main machine (router + local endpoint)**
   - Start DHCP with `setup_autolink.sh`
   - Start the local vLLM endpoint (e.g. run `code_model.sh` or `general_model.sh` as needed).  
   - Set any env in `cluster.env` (e.g. `LOCAL_ENDPOINT`, `MAC_WORKER_URL`).  
   - Start the semantic router:  
     `./start_semantic.sh`

3. **On the Mac (worker)**
   - connect the the main machine's network
   - Start the second vLLM endpoint (use the scripts or layout under `Llama_mac/` so it’s reachable at the URL you put in `cluster.env`).

5. **Test routing**  
   - Use `test_chat_code.sh` and `test_chat_general.sh` to send prompts and confirm they hit the code vs general endpoint as intended.

Stop the router with `./stop_semantic.sh` when done.

## Configuration

- **`config.yaml`** — Define router behavior and endpoint URLs (local and Mac worker).
- **`cluster.env`** — URLs/hosts for the local endpoint and the Mac worker; source this before starting the router or endpoint scripts if they depend on it.

## Notes

- This is a **local test setup**, not production (no auth, minimal hardening).
- The repo structure reflects testing on one machine + one Mac worker; you can add more workers by extending `config.yaml` and `cluster.env`.

## Links

- [vLLM](https://github.com/vllm-project/vllm)  
- [Semantic Router](https://github.com/aurelio-labs/semantic-router) (or the specific router you use with vLLM)
