#!/usr/bin/env bash
# Run ONCE on a temporary pod that mounts the network volume at /workspace, to fill it with the
# DramaWave models (~85 GB). Serverless workers see the same volume at /runpod-volume.
set -euo pipefail
M=/workspace/models
mkdir -p $M/unet $M/diffusion_models $M/model_patches $M/audio_encoders $M/loras $M/text_encoders $M/vae $M/clip_vision
pip install --break-system-packages -q -U "huggingface_hub[hf_transfer]"
export HF_HUB_ENABLE_HF_TRANSFER=1
T=/workspace/hfdl
for n in high low; do
  hf download Abiray/Wan2.2-LightX2V-260412-4STEP-GGUF ${n}_noise_260412/wan2.2_i2v_A14b_${n}_noise_lightx2v_4step_720p_260412-Q8_0.gguf --local-dir $T
done
hf download Comfy-Org/Wan_2.1_ComfyUI_repackaged split_files/diffusion_models/wan2.1_i2v_480p_14B_fp8_scaled.safetensors split_files/model_patches/wan2.1_infiniteTalk_single_fp16.safetensors --local-dir $T
hf download Kijai/wav2vec2_safetensors wav2vec2-chinese-base_fp16.safetensors --local-dir $M/audio_encoders
hf download Kijai/WanVideo_comfy Lightx2v/lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors --local-dir $T
hf download Kijai/WanVideo_comfy Wan2_1_VAE_fp32.safetensors --local-dir $M/vae
hf download AniWanefrrr/202508_wan21UMT5XxlFP32_fp32 wan21UMT5XxlFP32_fp32.safetensors --local-dir $M/text_encoders
hf download ricecake/wan21NSFWClipVisionH_v10 wan21NSFWClipVisionH_v10.safetensors --local-dir $M/clip_vision
hf download lightx2v/Qwen-Image-Edit-2511-Lightning qwen_image_edit_2511_fp8_e4m3fn_scaled_lightning_comfyui_4steps_v1.0.safetensors --local-dir $M/diffusion_models
hf download Comfy-Org/Qwen-Image_ComfyUI split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors split_files/vae/qwen_image_vae.safetensors --local-dir $T
mv $T/*_noise_260412/*.gguf $M/unet/
mv $T/split_files/diffusion_models/* $M/diffusion_models/
mv $T/split_files/model_patches/* $M/model_patches/
mv $T/Lightx2v/* $M/loras/
mv $T/split_files/text_encoders/* $M/text_encoders/
mv $T/split_files/vae/* $M/vae/
rm -rf $T $M/*/.cache
find $M -type f -size +1M -printf "%10s  %p\n" | sort -k2
du -sh $M
echo VOLUME_READY
