# 设置基本参数
if [ ! -d "./log" ]; then
    mkdir ./log
fi

if [ ! -d "./log/Informer" ]; then
    mkdir ./log/Informer
fi

if [ ! -d "./log/Informer/Electricity" ]; then
    mkdir ./log/Informer/Electricity
fi
model_name='Informer'
train_epochs=30
patience=5
root_path_name='/home/home_new/qsmx/pycodes/BasicTS/datasets/raw_data/Electricity/'
data_path_name='Electricity.csv'
data_name='custom'
seq_len=336
enc_in=321
dec_in=321
c_out=321
batch_size=16

# 循环不同的预测长度（pred_len）
for pred_len in 96 192 336 720 960 1024 1240 1688
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
      --e_layers 2 \
      --d_layers 1 \
      --factor 3 \
      --enc_in $enc_in \
      --dec_in $enc_in \
      --c_out $enc_in \
      --train_epochs $train_epochs \
      --patience $patience \
      --batch_size $batch_size \
      --itr 1 \
      --gpu 5 \
      --device '5,6,7' \
      --use_multi_gpu
done