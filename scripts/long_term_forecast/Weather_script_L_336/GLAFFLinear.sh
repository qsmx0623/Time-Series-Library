# export CUDA_VISIBLE_DEVICES=0

if [ ! -d "./log" ]; then
    mkdir ./log
fi

if [ ! -d "./log/GLAFFLinear" ]; then
    mkdir ./log/GLAFFLinear
fi

if [ ! -d "./log/GLAFFLinear/weather" ]; then
    mkdir ./log/GLAFFLinear/weather
fi

model_name=GLAFFLinear
root_path_name='/home/home_new/qsmx/pycodes/BasicTS/datasets/raw_data/Weather/'
data_path_name='Weather.csv'
seq_len=336
enc_in=21
dec_in=21
c_out=21
gpu_id=1

for pred_len in 96 192 336 720 960 1024 1240 1688
do
python -u run.py \
  --time_feature_types MonthOfYear DayOfMonth DayOfWeek HourOfDay MinuteOfHour SecondOfMinute \
  --task_name long_term_forecast \
  --is_training 1 \
  --with_curve 0 \
  --root_path $root_path_name \
  --data_path $data_path_name \
  --model_id weather_$seq_len'_'$pred_len \
  --model $model_name \
  --data custom \
  --features M \
  --freq t \
  --seq_len $seq_len \
  --pred_len $pred_len \
  --factor 3 \
  --enc_in $enc_in \
  --dec_in $dec_in \
  --c_out $c_out\
  --des 'Exp' \
  --learning_rate 0.001 \
  --batch_size 64 \
  --train_epochs 20 \
  --num_workers 5 \
  --dropout 0.0 \
  --loss mse \
  --gpu $gpu_id \
  --itr 1 | tee -a ./log/GLAFFLinear/weather/$seq_len.txt
done