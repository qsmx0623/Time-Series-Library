#!/bin/bash

# 设置数据集名称变量
dataset_name="ETTh2"  # 你可以修改此变量为其他数据集名，例如 "electricity" 或 "traffic"

# 设置基本参数
if [ ! -d "./log" ]; then
    mkdir ./log
fi

if [ ! -d "./log/Nonstationary_Transformer" ]; then
    mkdir ./log/Nonstationary_Transformer
fi

if [ ! -d "./log/Nonstationary_Transformer/$dataset_name" ]; then
    mkdir ./log/Nonstationary_Transformer/$dataset_name
fi

model_name=Nonstationary_Transformer

root_path_name='/home/home_new/qsmx/pycodes/BasicTS/datasets/raw_data/ETTh2/'
data_path_name='ETTh2.csv'
data_name='ETTh2'
seq_len=336
enc_in=7
dec_in=7
c_out=7

train_epochs=10
patience=5
gpu_id=7

# 循环不同的预测长度（pred_len）
for pred_len in 96 192 336 720 960 1024 1240 1688
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
      --features M \
      --freq w \
      --batch_size 64 \
      --gpu $gpu_id \
      --seq_len $seq_len \
      --pred_len $pred_len \
      --label_len 48 \
      --e_layers 2 \
      --d_layers 1 \
      --factor 3 \
      --enc_in $enc_in \
      --dec_in $dec_in \
      --c_out $c_out \
      --des 'Exp' \
      --itr 1 \
      --p_hidden_dims 256 256 \
      --p_hidden_layers 2 \
      --d_model 256 | tee -a ./log/Nonstationary_Transformer/$dataset_name/$seq_len.txt 
done
