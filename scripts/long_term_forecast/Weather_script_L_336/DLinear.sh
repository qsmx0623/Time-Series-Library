# export CUDA_VISIBLE_DEVICES=1

model_name=DLinear
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
gpu_id=5

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
      --freq t \
      --features M \
      --gpu $gpu_id \
      --seq_len $seq_len \
      --pred_len $pred_len \
      --e_layers 1 \
      --d_layers 1 \
      --factor 2 \
      --enc_in $enc_in \
      --dec_in $dec_in \
      --c_out $c_out\
      --train_epochs $train_epochs \
      --patience $patience \
      --itr 1 \
      --batch_size $batch_size \
      --learning_rate $learning_rate
done
