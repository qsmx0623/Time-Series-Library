# 设置基本参数

if [ ! -d "./log" ]; then
    mkdir ./log
fi

if [ ! -d "./log/Crossformer" ]; then
    mkdir ./log/Crossformer
fi

if [ ! -d "./log/Crossformer/Electricity" ]; then
    mkdir ./log/Crossformer/Electricity
fi
model_name='Crossformer'
train_epochs=10
patience=3
root_path_name='/home/home_new/qsmx/pycodes/BasicTS/datasets/raw_data/Electricity/'
data_path_name='Electricity.csv'
data_name='custom'
seq_len=336
enc_in=321
dec_in=321
c_out=321
batch_size=4
learning_rate=0.005

# 循环不同的预测长度（pred_len）
for pred_len in 96 192
do
    # 训练模型
    python -u run.py \
      --task_name long_term_forecast \
      --is_training 1 \
      --root_path $root_path_name \
      --data_path $data_path_name \
      --model_id Electricity_$seq_len'_'$pred_len \
      --model $model_name \
      --data $data_name \
      --freq w \
      --features M \
      --seq_len $seq_len \
      --pred_len $pred_len \
      --enc_in $enc_in \
      --dec_in $dec_in \
      --c_out $c_out\
      --train_epochs $train_epochs \
      --patience $patience \
      --batch_size $batch_size \
      --learning_rate $learning_rate \
      --itr 1 \
      --gpu 4 \
      --device '4,5,6,7' \
      --use_multi_gpu
done