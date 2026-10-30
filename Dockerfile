# DramaWave ComfyUI serverless worker: the official worker plus the one custom node our workflows need.
# Models are not baked in; they live on the network volume (see stage_models.sh).
FROM runpod/worker-comfyui:5.11.0-base

# UnetLoaderGGUF (Wan 2.2 I2V Q8 GGUF)
RUN comfy-node-install comfyui-gguf

# The stock file maps only the classic folders; ours also need diffusion_models, text_encoders,
# model_patches (InfiniteTalk) and audio_encoders (wav2vec2).
COPY extra_model_paths.yaml /comfyui/extra_model_paths.yaml
