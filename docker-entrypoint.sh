#!/bin/bash
set -e

# Docker デーモンを起動（デフォルトのソケットパスを明示的に指定）
dockerd --host=unix:///var/run/docker.sock &

# Docker が起動するまで待機
echo "Waiting for Docker daemon to start..."
while ! docker info >/dev/null 2>&1; do
    sleep 1
done
echo "Docker daemon started successfully!"

# コマンドが指定されていればそれを実行、なければ bash を起動
exec "${@:-/bin/bash}"
