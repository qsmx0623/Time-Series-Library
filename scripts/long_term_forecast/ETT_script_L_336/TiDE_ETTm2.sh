
# 设置数据集名称变量
dataset_name="ETTm2"  # 你可以修改此变量为其他数据集名，例如 "electricity" 或 "traffic"

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
patience=5
root_path_name='/home/home_new/qsmx/pycodes/BasicTS/datasets/raw_data/ETTm2/'
data_path_name='ETTm2.csv'
data_name='ETTm2'
seq_len=336
enc_in=7
dec_in=7
c_out=8
batch_size=64
learning_rate=0.1
gpu_id=2

# 循环不同的预测长度（pred_len）
for pred_len in 96 192 336 720 960 1024 1240 1680
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
      --e_layers 2 \
      --d_layers 1 \
      --factor 3 \
      --enc_in $enc_in \
      --dec_in $dec_in \
      --c_out $c_out \
      --d_model 256 \
      --d_ff 256 \
      --dropout 0.3 \
      --train_epochs $train_epochs \
      --patience $patience \
      --batch_size $batch_size \
      --learning_rate $learning_rate \
      --itr 1 | tee -a ./log/TiDE/$dataset_name/$seq_len.txt
done
