#export CUDA_VISIBLE_DEVICES=7
if [ ! -d "./log" ]; then
    mkdir ./log
fi

if [ ! -d "./log/Autoformer" ]; then
    mkdir ./log/Autoformer
fi

if [ ! -d "./log/Autoformer/ExchangeRate" ]; then
    mkdir ./log/Autoformer/ExchangeRate
fi
model_name='Autoformer'
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
gpu_id=1

# 循环不同的预测长度（pred_len）
for pred_len in 336 720
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
      --enc_in $enc_in \
      --dec_in $dec_in \
      --c_out $c_out\
      --train_epochs $train_epochs \
      --patience $patience \
      --batch_size $batch_size \
      --itr 1 | tee -a ./log/Autoformer/ExchangeRate/$seq_len.txt
done