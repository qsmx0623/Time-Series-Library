#!/bin/bash

# 设置数据集名称变量
dataset_name="ExchangeRate"  # 你可以修改此变量为其他数据集名，例如 "electricity" 或 "traffic"

# 设置基本参数
if [ ! -d "./log" ]; then
    mkdir ./log
fi

if [ ! -d "./log/DLinear" ]; then
    mkdir ./log/DLinear
fi

if [ ! -d "./log/DLinear/$dataset_name" ]; then
    mkdir ./log/DLinear/$dataset_name
fi

model_name=DLinear
train_epochs=10
patience=3
root_path_name='/home/home_new/qsmx/pycodes/BasicTS/datasets/raw_data/ExchangeRate/'
data_path_name='ExchangeRate.csv'
data_name='custom'
seq_len=336
enc_in=8
dec_in=8
c_out=8
batch_size=32
learning_rate=0.5
gpu_id=7

# 循环不同的预测长度（pred_len）
for pred_len in 720
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
      --e_layers 1 \
      --d_layers 1 \
      --factor 1 \
      --enc_in $enc_in \
      --dec_in $dec_in \
      --c_out $c_out \
      --train_epochs $train_epochs \
      --patience $patience \
      --batch_size $batch_size \
      --learning_rate $learning_rate \
      --itr 1 | tee -a ./log/DLinear/$dataset_name/$seq_len.txt
done
