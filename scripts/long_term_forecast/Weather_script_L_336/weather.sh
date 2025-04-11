model_name=SparseTSF

root_path_name='/home/home_new/qsmx/pycodes/BasicTS/datasets/raw_data/Weather/'
data_path_name='Weather.csv'
model_id_name=weather
data_name=custom
gpu_id=6

seq_len=336
for pred_len in 96 192 336 720 960 1024 1240 1688
do
  python -u run.py \
    --task_name long_term_forecast \
    --is_training 1 \
    --root_path $root_path_name \
    --data_path $data_path_name \
    --model_id $model_id_name'_'$seq_len'_'$pred_len \
    --model $model_name \
    --data $data_name \
    --features M \
    --seq_len $seq_len \
    --pred_len $pred_len \
    --period_len 4 \
    --model_type 'linear' \
    --enc_in 21 \
    --train_epochs 10 \
    --patience 3 \
    --itr 1 --batch_size 256 --learning_rate 0.02 \
    --gpu $gpu_id 
done
