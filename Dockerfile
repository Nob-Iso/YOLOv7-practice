# ベースイメージ(CUDA)の指定
FROM nvidia/cuda:13.2.0-cudnn-devel-ubuntu24.04

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y python3-pip python3-venv git vim

# 作業ディレクトリを設定
WORKDIR /app

# アプリケーションコードをコピー
COPY . /app

# Python仮想環境の作成
RUN python3 -m venv /app/.venv

# 仮想環境をアクティベートするコマンドを.bashrcに追加
RUN echo "source /app/.venv/bin/activate" >> /root/.bashrc

# PyTorchのインストール
RUN /app/.venv/bin/pip install torch==2.11.0 torchvision==0.26.0 torchaudio==2.11.0 --index-url https://download.pytorch.org/whl/cu126

# コンテナの起動時にbashを実行
CMD ["/bin/bash"]
