# 设置基本参数
if [ ! -d "./log" ]; then
    mkdir ./log
fi

if [ ! -d "./log/Informer" ]; then
    mkdir ./log/Informer
fi

if [ ! -d "./log/Informer/ExchangeRate" ]; then
    mkdir ./log/Informer/ExchangeRate
fi
model_name='Informer'
train_epochs=30
patience=5
root_path_name='/home/home_new/qsmx/pycodes/BasicTS/datasets/raw_data/ExchangeRate/'
data_path_name='ExchangeRate.csv'
data_name='custom'
seq_len=336
enc_in=8
dec_in=8
c_out=8
batch_size=64
gpu_id=4

# 循环不同的预测长度（pred_len）
for pred_len in 96 192 336 720
do
    # 训练模型
    python -u run.py \
      --task_name long_term_forecast \
      --is_training 1 \
      --root_path $root_path_name \
      --data_path $data_path_name \
      --model_id ExchangeRate_$seq_len'_'$pred_len \
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
      --itr 1 | tee -a ./log/Informer/ExchangeRate/$seq_len.txt
done