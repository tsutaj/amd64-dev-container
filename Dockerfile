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
    ca-certificates \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Docker のインストール
RUN install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && chmod a+r /etc/apt/keyrings/docker.gpg \
    && echo \
      "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    && rm -rf /var/lib/apt/lists/*

# pwntools等のCTFツールをインストール（オプション）
RUN pip3 install --no-cache-dir pwntools

# 作業ディレクトリを設定
WORKDIR /work

# entrypoint スクリプトをコピー
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Docker デーモンを起動してから bash を起動
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/bin/bash"]
