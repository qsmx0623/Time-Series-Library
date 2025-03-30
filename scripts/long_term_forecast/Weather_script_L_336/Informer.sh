# 设置基本参数
if [ ! -d "./log" ]; then
    mkdir ./log
fi

if [ ! -d "./log/Informer" ]; then
    mkdir ./log/Informer
fi

if [ ! -d "./log/Informer/weather" ]; then
    mkdir ./log/Informer/weather
fi
model_name='Informer'
train_epochs=10
patience=5
root_path_name='/home/home_new/qsmx/pycodes/BasicTS/datasets/raw_data/Weather/'
data_path_name='Weather.csv'
data_name='custom'
seq_len=336
enc_in=21
dec_in=21
c_out=21
batch_size=64
learning_rate=0.005
gpu_id=1

# 循环不同的预测长度（pred_len）
for pred_len in 96 192 336 720 960 1024 1240 1688
do
    # 训练模型
    python -u run.py \
      --task_name long_term_forecast \
      --is_training 1 \
      --root_path $root_path_name \
      --data_path $data_path_name \
      --model_id weather_$seq_len'_'$pred_len \
      --model $model_name \
      --data $data_name \
      --freq w \
      --features M \
      --gpu $gpu_id \
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
      --learning_rate $learning_rate \
      --itr 1 | tee -a ./log/Informer/weather/$seq_len.txt
done