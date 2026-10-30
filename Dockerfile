# tarla ComfyUI serverless worker: the official worker plus the one custom node our workflows need.
# Models are not baked in; they live on the network volume (see stage_models.sh).
FROM runpod/worker-comfyui:5.10.0-base

# UnetLoaderGGUF (Wan 2.2 I2V Q8 GGUF). `comfy-node-install comfyui-gguf` only listed versions without
# installing (5.10.0 build), so clone it and install its requirements into the venv ComfyUI runs from.
RUN git clone --depth 1 https://github.com/city96/ComfyUI-GGUF /comfyui/custom_nodes/ComfyUI-GGUF     && uv pip install --python /opt/venv/bin/python -r /comfyui/custom_nodes/ComfyUI-GGUF/requirements.txt     && /opt/venv/bin/python -c "import gguf; print('gguf', gguf.__version__ if hasattr(gguf, '__version__') else 'ok')"

# The stock file maps only the classic folders; ours also need diffusion_models, text_encoders,
# model_patches (InfiniteTalk) and audio_encoders (wav2vec2).
COPY extra_model_paths.yaml /comfyui/extra_model_paths.yaml
