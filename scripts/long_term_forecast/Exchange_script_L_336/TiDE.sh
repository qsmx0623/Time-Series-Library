
# 设置数据集名称变量
dataset_name="ExchangeRate"  # 你可以修改此变量为其他数据集名，例如 "electricity" 或 "traffic"

# 设置基本参数
if [ ! -d "./log" ]; then
    mkdir ./log
fi

if [ ! -d "./log/TiDE" ]; then
    mkdir ./log/TiDE
fi

if [ ! -d "./log/TiDE/$dataset_name" ]; then
    mkdir ./log/TiDE/$dataset_name
fi

model_name=TiDE
train_epochs=10
patience=3
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
for pred_len in 96 192 336 720
do
    # 训练模型
    python -u run.py \
      --task_name long_term_forecast \
      --is_training 1 \
      --root_path $root_path_name \
      --data_path $data_path_name \
      --model_id ${dataset_name}_$seq_len'_'$pred_len \
      --model $model_name \
      --data $data_name \
      --freq w \
      --features M \
      --gpu $gpu_id \
      --seq_len $seq_len \
      --pred_len $pred_len \
      --e_layers 1 \
      --d_layers 1 \
      --factor 1 \
      --enc_in $enc_in \
      --dec_in $dec_in \
      --c_out 22 \
      --d_model 64 \
      --d_ff 64 \
      --dropout 0.6 \
      --train_epochs $train_epochs \
      --patience $patience \
      --batch_size $batch_size \
      --itr 1 | tee -a ./log/TiDE/$dataset_name/$seq_len.txt
done
