model_name=SparseTSF

root_path_name='/home/home_new/qsmx/pycodes/BasicTS/datasets/raw_data/ExchangeRate/'
data_path_name='ExchangeRate.csv'
data_name='custom'
model_id_name=ExchangeRate
gpu_id=2

seq_len=336
for pred_len in 96 192 336 720
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
    --enc_in 8 \
    --train_epochs 10 \
    --patience 5 \
    --itr 1 --batch_size 64 \
    --gpu $gpu_id 
done
