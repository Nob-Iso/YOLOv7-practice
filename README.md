# pytorch-env

## PyTorch GPU認識テスト

Dockerコンテナ内のPyTorchから、ホストマシンのGPUが正しく認識されているかを確認するための環境です。

## 実行手順

リポジトリのクローンからディレクトリ移動
```bash
git clone <URL>
cd pytorch-env
```

イメージのビルドからコンテナ起動まで
```bash
docker compose run pytorch_container
```

pythonの対話モード
```bash
python
```

torchをインポート
```python
import torch
```

gpuを認識しているか確認(trueが返ってくればok)
```python
torch.cuda.is_available()
```
