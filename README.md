# LatentSync 1.6 — Docker for NVIDIA GPUs

A Docker build of [ByteDance LatentSync](https://github.com/bytedance/LatentSync), designed to run on NVIDIA GPU instances such as [Vast.ai](https://vast.ai/).

The image includes the LatentSync source code, Python dependencies, PyTorch, CUDA runtime, FFmpeg and model checkpoints.

## Docker Image

Published to GitHub Container Registry (GHCR):

```bash
ghcr.io/svvat/latentsync:1.6
```

**Platform:** `linux/amd64`  
**PyTorch:** 2.5.1  
**CUDA runtime:** 12.1  
**LatentSync:** 1.6 checkpoints

## Requirements

- Linux x86-64
- NVIDIA GPU with at least 18 GB VRAM
- Compatible NVIDIA drivers
- Sufficient disk space for the image, inputs and outputs

Test environment: Vast.ai with NVIDIA RTX 3090 (24 GB VRAM).

The Docker image has been built successfully through GitHub Actions. Deployment and inference using the published image have not yet been verified.

## Running on Vast.ai

1. Open the Vast.ai console.
2. Select an instance with a suitable NVIDIA GPU.
3. Configure the Docker image:

   ```text
   ghcr.io/svvat/latentsync:1.6
   ```

4. Configure registry authentication if the GHCR package is private.
5. Launch the instance.

The container uses `/bin/bash` as its default command.

The image does not automatically expose a web interface or API.

## Running Inference

Connect to the running container and prepare input and output files.

The LatentSync repository is located at:

```bash
cd /opt/LatentSync
```

Create an output directory if necessary:

```bash
mkdir -p /workspace/output
```

Run inference:

```bash
python -m scripts.inference \
  --unet_config_path configs/unet/stage2.yaml \
  --inference_ckpt_path checkpoints/latentsync_unet.pt \
  --video_path /workspace/input/video.mp4 \
  --audio_path /workspace/input/audio.wav \
  --video_out_path /workspace/output/result.mp4
```

The input files must already exist inside the container. Transfer them using SCP, a mounted volume or another supported transfer method.

## Running with Docker

On a Linux host with NVIDIA Container Toolkit installed:

```bash
docker run --rm -it \
  --gpus all \
  -v "$(pwd)/input:/workspace/input" \
  -v "$(pwd)/output:/workspace/output" \
  ghcr.io/svvat/latentsync:1.6
```

This mounts local input and output directories so generated files persist after the container exits.

## Building and Publishing

The Docker image is built using GitHub Actions.

The workflow:

1. Checks out this repository.
2. Configures Docker Buildx.
3. Authenticates with GHCR.
4. Builds the image for `linux/amd64`.
5. Pushes the image to GitHub Container Registry.

To publish a new image, open **GitHub → Actions → Build LatentSync Docker Image → Run workflow**.

The published image tag is currently fixed at `1.6`.

## Repository Contents

```text
.
├── Dockerfile
├── README.md
└── .github/
    └── workflows/
        └── docker.yml
```

## Important Notes

**Source version:** The Dockerfile clones the upstream LatentSync repository during the build. Unless pinned to a commit, future builds may contain newer source code.

**Dependencies:** Python dependencies are installed from the upstream requirements file.

**Checkpoints:** Model weights are downloaded during the Docker build and included in the published image.

**Persistence:** Files stored only inside a running Vast.ai container may be lost when the instance is destroyed. Download outputs or use persistent storage.

**Registry access:** Private GHCR packages require appropriate authentication.

## Credits and Licensing

LatentSync is developed by ByteDance.

- [Official LatentSync repository](https://github.com/bytedance/LatentSync)
- [LatentSync checkpoints on Hugging Face](https://huggingface.co/ByteDance/LatentSync-1.6)

This repository provides Docker packaging and deployment configuration. It is not an official ByteDance project.

Refer to the upstream project, model weights and dependencies for their respective licensing and usage conditions.