# x86_64 environment for ARM Mac
FROM --platform=linux/amd64 ubuntu:22.04

# 必要なツールをインストール
RUN apt-get update && apt-get install -y \
    build-essential \
    gdb \
    gdb-multiarch \
    python3 \
    python3-pip \
    vim \
    wget \
    curl \
    file \
    strace \
    ltrace \
    netcat \
    socat \
    binutils \
    && rm -rf /var/lib/apt/lists/*

# pwntools等のCTFツールをインストール（オプション）
RUN pip3 install --no-cache-dir pwntools

# 作業ディレクトリを設定
WORKDIR /work

# デフォルトでbashを起動
CMD ["/bin/bash"]
