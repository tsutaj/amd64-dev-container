# x86_64 Development Environment for ARM Mac

ARM Mac（Apple Silicon）でx86_64バイナリを実行するためのDocker環境です。

M5 Mac + Colima で動作確認しました。利用は自己責任でお願いします。

## 前準備: Colima に x86_64 VM を追加する

普通に Colima を使うと aarch64 VM しか追加されないと思います。x86_64 VM を追加して、その VM 上で動作させると gdb などもうまく動きます。

```bash
$ brew install qemu lima-additional-guestagents

# x86_64 の VM を作成
$ colima start -p x86_64 --arch x86_64 --vm-type vz --vz-rosetta --mount-type virtiofs

# 環境が作られていることを確認
$ colima list
PROFILE    STATUS     ARCH       CPUS    MEMORY    DISK      RUNTIME    ADDRESS
default    Running    aarch64    2       2GiB      100GiB    docker     
x86_64     Running    x86_64     2       2GiB      100GiB    docker 

$ docker context list
NAME              DESCRIPTION                               DOCKER ENDPOINT                                    ERROR
colima *          colima                                    unix:///Users/tsutaj/.colima/default/docker.sock   
colima-x86_64     colima [profile=x86_64]                   unix:///Users/tsutaj/.colima/x86_64/docker.sock    
default           Current DOCKER_HOST based configuration   unix:///var/run/docker.sock     
```

docker コマンドを使う時に `--context colima-x86_64` をつけて、x86_64 VM を使います。

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
docker --context colima-x86_64 compose up -d --build
```

- `--build`: Dockerイメージをビルド
- `-d`: バックグラウンドで起動

### 2. コンテナに入る

```bash
docker --context colima-x86_64 compose exec x86_64-env bash
```

### 3. コンテナの停止

```bash
docker --context colima-x86_64 compose stop
```

### 4. コンテナの削除

```bash
docker --context colima-x86_64 compose down
```

### 5. コンテナとイメージの完全削除

```bash
docker --context colima-x86_64 compose down --rmi all -v
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
docker --context colima-x86_64 compose exec x86_64-env bash
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
