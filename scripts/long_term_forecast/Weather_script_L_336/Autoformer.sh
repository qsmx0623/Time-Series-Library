#export CUDA_VISIBLE_DEVICES=7
if [ ! -d "./log" ]; then
    mkdir ./log
fi

if [ ! -d "./log/Autoformer" ]; then
    mkdir ./log/Autoformer
fi

if [ ! -d "./log/Autoformer/weather" ]; then
    mkdir ./log/Autoformer/weather
fi
model_name='Autoformer'
train_epochs=10
patience=5
root_path_name='/home/home_new/qsmx/pycodes/BasicTS/datasets/raw_data/Weather/'
data_path_name='Weather.csv'
data_name='custom'
seq_len=336
enc_in=21
dec_in=21
c_out=21
batch_size=32
learning_rate=0.005
gpu_id=1

# 循环不同的预测长度（pred_len）
for pred_len in 1240
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
      --enc_in $enc_in \
      --dec_in $dec_in \
      --c_out $c_out\
      --train_epochs $train_epochs \
      --patience $patience \
      --batch_size $batch_size \
      --learning_rate $learning_rate \
      --itr 1 | tee -a ./log/Autoformer/weather/$seq_len.txt
done