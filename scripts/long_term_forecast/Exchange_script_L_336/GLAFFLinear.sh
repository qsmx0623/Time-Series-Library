# export CUDA_VISIBLE_DEVICES=0

if [ ! -d "./log" ]; then
    mkdir ./log
fi

if [ ! -d "./log/GLAFFLinear" ]; then
    mkdir ./log/GLAFFLinear
fi

if [ ! -d "./log/GLAFFLinear/ExchangeRate" ]; then
    mkdir ./log/GLAFFLinear/ExchangeRate
fi

model_name=GLAFFLinear
train_epochs=10
patience=3
root_path_name='/home/home_new/qsmx/pycodes/BasicTS/datasets/raw_data/ExchangeRate/'
data_path_name='ExchangeRate.csv'
seq_len=336
enc_in=8
dec_in=8
c_out=8
gpu_id=7

for pred_len in 192 720
do
python -u run.py \
  --time_feature_types MonthOfYear DayOfMonth DayOfWeek \
  --task_name long_term_forecast \
  --is_training 1 \
  --with_curve 0 \
  --root_path $root_path_name \
  --data_path $data_path_name \
  --model_id ExchangeRate_$seq_len'_'$pred_len \
  --model $model_name \
  --data custom \
  --features M \
  --freq w \
  --seq_len $seq_len \
  --pred_len $pred_len \
  --factor 0 \
  --enc_in $enc_in \
  --dec_in $dec_in \
  --c_out $c_out\
  --des 'Exp' \
  --learning_rate 0.001 \
  --batch_size 64 \
  --train_epochs $train_epochs \
  --patience $patience \
  --num_workers 1 \
  --dropout 0.8 \
  --loss mse \
  --gpu $gpu_id \
  --itr 1 | tee -a ./log/GLAFFLinear/ExchangeRate/$seq_len.txt
done