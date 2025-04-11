#!/bin/bash

# 设置数据集名称变量
dataset_name="Electricity"  # 你可以修改此变量为其他数据集名，例如 "electricity" 或 "traffic"

# 设置基本参数
if [ ! -d "./log" ]; then
    mkdir ./log
fi

if [ ! -d "./log/TimeLinear" ]; then
    mkdir ./log/TimeLinear
fi

if [ ! -d "./log/TimeLinear/$dataset_name" ]; then
    mkdir ./log/TimeLinear/$dataset_name
fi

model_name=TimeLinear
root_path_name='/home/home_new/qsmx/pycodes/BasicTS/datasets/raw_data/Electricity/'
data_path_name='Electricity.csv'
seq_len=336
enc_in=321
dec_in=321
c_out=321

# 循环不同的预测长度（pred_len）
for pred_len in 336 720 960 1024 1240 1688
do
    for beta in 0.1
    do
        # 训练模型
        python -u run.py \
          --time_feature_types HourOfDay SeasonOfYear \
          --task_name long_term_forecast \
          --is_training 1 \
          --with_curve 0 \
          --root_path $root_path_name \
          --data_path $data_path_name \
          --model_id ${dataset_name}_$seq_len'_'$pred_len \
          --model $model_name \
          --data custom \
          --features M \
          --freq t \
          --seq_len $seq_len \
          --pred_len $pred_len \
          --factor 1 \
          --enc_in $enc_in \
          --dec_in $dec_in \
          --c_out $c_out \
          --des 'Exp' \
          --rda 2 \
          --rdb 2 \
          --ksize 2 \
          --beta $beta \
          --learning_rate 0.005 \
          --batch_size 16 \
          --train_epochs 3 \
          --num_workers 1 \
          --dropout 0 \
          --loss mse \
          --itr 1 \
          --gpu 0 \
          --device '0,1,3,4,5,6' \
          --use_multi_gpu
    done
done
