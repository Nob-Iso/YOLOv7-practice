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

---

## COCO128を使ったYOLOv7テスト

### 1. コンテナをビルド

```bash
docker compose build
```

### 2. コンテナに入ってCOCO128をダウンロード

```bash
docker compose run pytorch_container
```

コンテナ内で以下を実行します。

ディレクトリ移動：
```bash
cd /app/yolov7
```

COCO128をダウンロード（約6MB）：
```bash
wget https://ultralytics.com/assets/coco128.zip -O /tmp/coco128.zip
```

`/app/yolov7/coco128/` に展開：
```bash
unzip /tmp/coco128.zip -d /app/yolov7/
```

yamlファイルを作成：
```bash
cat > /app/yolov7/data/coco128.yaml << 'EOF'
path: /app/yolov7/coco128
train: /app/yolov7/coco128/images/train2017
val: /app/yolov7/coco128/images/train2017

nc: 80
names: ['person', 'bicycle', 'car', 'motorcycle', 'airplane', 'bus', 'train', 'truck', 'boat', 'traffic light',
        'fire hydrant', 'stop sign', 'parking meter', 'bench', 'bird', 'cat', 'dog', 'horse', 'sheep', 'cow',
        'elephant', 'bear', 'zebra', 'giraffe', 'backpack', 'umbrella', 'handbag', 'tie', 'suitcase', 'frisbee',
        'skis', 'snowboard', 'sports ball', 'kite', 'baseball bat', 'baseball glove', 'skateboard', 'surfboard',
        'tennis racket', 'bottle', 'wine glass', 'cup', 'fork', 'knife', 'spoon', 'bowl', 'banana', 'apple',
        'sandwich', 'orange', 'broccoli', 'carrot', 'hot dog', 'pizza', 'donut', 'cake', 'chair', 'couch',
        'potted plant', 'bed', 'dining table', 'toilet', 'tv', 'laptop', 'mouse', 'remote', 'keyboard',
        'cell phone', 'microwave', 'oven', 'toaster', 'sink', 'refrigerator', 'book', 'clock', 'vase',
        'scissors', 'teddy bear', 'hair drier', 'toothbrush']
EOF
```

### 3. COCO128でテスト実行

```bash
python test.py --data data/coco128.yaml --img 640 --batch 32 --conf 0.001 --iou 0.65 --device 0 --weights yolov7.pt --name yolov7_640_val
```

---

## Inferenceの実行

### 1. detect.py を実行

コンテナ内で以下を実行します。

```bash
python detect.py --weights yolov7.pt --conf 0.25 --img-size 640 --source inference/images/
```

結果は `runs/detect/exp/` 以下に保存されます。

### 2. 出力画像の確認

`imgcat` を使ってターミナル上で画像を確認できます。

```bash
imgcat /app/yolov7/runs/detect/exp/horses.jpg
```
