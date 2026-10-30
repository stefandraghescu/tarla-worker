# dramawave-worker

Runpod Serverless image for the DramaWave pipeline: `runpod/worker-comfyui:5.11.0-base` + `comfyui-gguf`,
with model paths for the network volume (`/runpod-volume/models/...`).

- Image: `ghcr.io/stefandraghescu/dramawave-worker` (built by GitHub Actions on push to main)
- Models: staged once on the network volume with `stage_models.sh` (~85 GB)
- Jobs: the ComfyUI API workflow in `input.workflow`, input files (PNG keyframes, WAV lines) in `input.images`
- Outputs: videos come from core `CreateVideo` + `SaveVideo` (the worker only returns the `images` output key)
