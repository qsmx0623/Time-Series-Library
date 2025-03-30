#export CUDA_VISIBLE_DEVICES=1

if [ ! -d "./log" ]; then
    mkdir ./log
fi

if [ ! -d "./log/TimeLinear" ]; then
    mkdir ./log/TimeLinear
fi

if [ ! -d "./log/TimeLinear/weather" ]; then
    mkdir ./log/TimeLinear/weather
fi
model_name=TimeLinear
root_path_name='/home/home_new/qsmx/pycodes/BasicTS/datasets/raw_data/Weather/'
data_path_name='Weather.csv'
seq_len=336
enc_in=21
dec_in=21
c_out=21
gpu_id=1

for pred_len in 96 192 336 720 960 1024 1240 1688
do
for beta in 0.5
do
python -u run.py \
  --time_feature_types HourOfDay SeasonOfYear \
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
  --factor 2 \
  --enc_in $enc_in \
  --dec_in $dec_in \
  --c_out $c_out\
  --des 'Exp' \
  --rda 4 \
  --rdb 2 \
  --ksize 3 \
  --beta $beta \
  --learning_rate 0.005 \
  --batch_size 128 \
  --train_epochs 10 \
  --num_workers 5 \
  --dropout 0 \
  --loss mse \
  --gpu $gpu_id \
  --itr 1 | tee -a ./log/TimeLinear/weather/$seq_len'_'$pred_len.txt
done
done