# export CUDA_VISIBLE_DEVICES=0

if [ ! -d "./log" ]; then
    mkdir ./log
fi

if [ ! -d "./log/GLAFFLinear" ]; then
    mkdir ./log/GLAFFLinear
fi

if [ ! -d "./log/GLAFFLinear/Electricity" ]; then
    mkdir ./log/GLAFFLinear/Electricity
fi

model_name=GLAFFLinear
train_epochs=5
patience=3
root_path_name='/home/home_new/qsmx/pycodes/BasicTS/datasets/raw_data/Electricity/'
data_path_name='Electricity.csv'
seq_len=336
enc_in=321
dec_in=321
c_out=321

for pred_len in 1024 1688
do
python -u run.py \
  --time_feature_types MonthOfYear DayOfMonth DayOfWeek \
  --task_name long_term_forecast \
  --is_training 1 \
  --with_curve 0 \
  --root_path $root_path_name \
  --data_path $data_path_name \
  --model_id Electricity_$seq_len'_'$pred_len \
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
  --batch_size 16 \
  --train_epochs $train_epochs \
  --patience $patience \
  --num_workers 1 \
  --dropout 0.6 \
  --loss mse \
  --itr 1 \
  --gpu 0 \
  --device '0,1,3,4,5,6' \
  --use_multi_gpu
done