#!/bin/bash

# 设置数据集名称变量
dataset_name="ETTm1"  # 你可以修改此变量为其他数据集名，例如 "electricity" 或 "traffic"

# 设置基本参数
if [ ! -d "./log" ]; then
    mkdir ./log
fi

if [ ! -d "./log/Autoformer" ]; then
    mkdir ./log/Autoformer
fi

if [ ! -d "./log/Autoformer/$dataset_name" ]; then
    mkdir ./log/Autoformer/$dataset_name
fi

model_name='Autoformer'
train_epochs=10
patience=5
root_path_name='/home/home_new/qsmx/pycodes/BasicTS/datasets/raw_data/ETTm1/'
data_path_name='ETTm1.csv'
data_name='ETTm1'
seq_len=336
enc_in=7
batch_size=64
learning_rate=0.005
gpu_id=1

# 循环不同的预测长度（pred_len）
for pred_len in 96 192 336 720
do
    # 训练模型
    python -u run.py \
      --task_name long_term_forecast \
      --is_training 1 \
      --root_path $root_path_name \
      --data_path $data_path_name \
      --model_id ${dataset_name}_$seq_len'_'$pred_len \
      --model $model_name \
      --data $data_name \
      --freq w \
      --features M \
      --gpu $gpu_id \
      --seq_len $seq_len \
      --pred_len $pred_len \
      --enc_in $enc_in \
      --dec_in $enc_in \
      --c_out $enc_in \
      --e_layers 2 \
      --d_layers 1 \
      --factor 3 \
      --train_epochs $train_epochs \
      --patience $patience \
      --batch_size $batch_size \
      --learning_rate $learning_rate \
      --itr 1 | tee -a ./log/Autoformer/$dataset_name/$seq_len.txt
done
