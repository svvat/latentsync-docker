
FROM pytorch/pytorch:2.5.1-cuda12.1-cudnn9-runtime
LABEL org.opencontainers.image.source="https://github.com/svvat/latentsync-docker"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git ffmpeg libgl1 libglib2.0-0 build-essential && \
    rm -rf /var/lib/apt/lists/*
# 
WORKDIR /opt/LatentSync

RUN git clone https://github.com/bytedance/LatentSync.git . 

RUN pip install --no-cache-dir -r requirements.txt

RUN pip install --no-cache-dir huggingface_hub && \
    mkdir -p checkpoints && \
    python -c "from huggingface_hub import hf_hub_download; \
hf_hub_download(repo_id='ByteDance/LatentSync-1.6', filename='latentsync_unet.pt', local_dir='checkpoints'); \
hf_hub_download(repo_id='ByteDance/LatentSync-1.6', filename='whisper/tiny.pt', local_dir='checkpoints')"

RUN mkdir -p /workspace/input /workspace/output

CMD ["/bin/bash"]
