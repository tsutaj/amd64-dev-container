# x86_64 Development Environment for ARM Mac

ARM Mac（Apple Silicon）でx86_64バイナリを実行するためのDocker環境です。

## ディレクトリ構成

```
.
├── Dockerfile           # x86_64環境の定義
├── docker-compose.yml   # Docker Compose設定
├── work/               # 作業ディレクトリ（コンテナと共有）
└── README.md           # このファイル
```

## 使い方

### 1. イメージのビルドとコンテナの起動

```bash
docker compose up -d --build
```

- `--build`: Dockerイメージをビルド
- `-d`: バックグラウンドで起動

### 2. コンテナに入る

```bash
docker compose exec x86_64-env bash
```

### 3. コンテナの停止

```bash
docker compose stop
```

### 4. コンテナの削除

```bash
docker compose down
```

### 5. コンテナとイメージの完全削除

```bash
docker compose down --rmi all -v
```

- `--rmi all`: ビルドしたイメージも削除
- `-v`: ボリュームも削除

## インストールされているツール

- build-essential (gcc, g++, make など)
- gdb / gdb-multiarch
- Python3
- pwntools
- vim
- wget, curl
- file, strace, ltrace
- netcat, socat
- binutils

## ファイルの配置

`work/` ディレクトリに問題ファイルを配置すると、コンテナ内の `/work` からアクセスできます。

```bash
# 例: work/challenge というバイナリを配置した場合
docker compose exec x86_64-env bash
# コンテナ内で
cd /work
file challenge
./challenge
```

## トラブルシューティング

### アーキテクチャの確認

コンテナ内で以下のコマンドを実行して、x86_64環境であることを確認できます。

```bash
uname -m
# 出力: x86_64
```

### デバッグツールの使用

gdbなどのデバッグツールは、`security_opt` と `cap_add` の設定により使用可能です。

```bash
gdb ./your_binary
```
