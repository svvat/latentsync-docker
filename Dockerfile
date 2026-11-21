
FROM pytorch/pytorch:2.5.1-cuda12.1-cudnn9-runtime

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git ffmpeg libgl1 libglib2.0-0 build-essential && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/LatentSync

RUN git clone https://github.com/bytedance/LatentSync.git . 

RUN pip install --no-cache-dir -r requirements.txt

RUN mkdir -p checkpoints && \
    hf download ByteDance/LatentSync-1.6 \
    latentsync_unet.pt whisper/tiny.pt \
    --local-dir checkpoints

RUN mkdir -p /workspace/input /workspace/output

CMD ["/bin/bash"]
