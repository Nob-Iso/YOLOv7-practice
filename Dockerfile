# ベースイメージ(CUDA)の指定
FROM nvidia/cuda:12.6.3-cudnn-devel-ubuntu22.04

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y \
    python3-pip python3-venv git vim \
    libgl1 libglib2.0-0 \
    zip htop screen wget curl

# 作業ディレクトリを設定
WORKDIR /app

# Python仮想環境の作成
RUN python3 -m venv /app/.venv

# 仮想環境をアクティベートするコマンドを.bashrcに追加
RUN echo "source /app/.venv/bin/activate" >> /root/.bashrc

# PyTorchのインストール
RUN /app/.venv/bin/pip install torch==2.11.0 torchvision==0.26.0 torchaudio==2.11.0 --index-url https://download.pytorch.org/whl/cu126

# YOLOv7のセットアップ
RUN git clone https://github.com/WongKinYiu/yolov7.git /app/yolov7
RUN /app/.venv/bin/pip install -r /app/yolov7/requirements.txt

# PyTorch 2.6以降の weights_only=True デフォルト変更への対応パッチ
RUN sed -i 's/ckpt = torch.load(w, map_location=map_location)/ckpt = torch.load(w, map_location=map_location, weights_only=False)/' /app/yolov7/models/experimental.py

# コンテナの起動時にbashを実行
CMD ["/bin/bash"]
