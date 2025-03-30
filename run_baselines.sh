#!/bin/bash

# 定义数据集和对应脚本的关系
declare -A dataset_scripts
dataset_scripts=(
  ["ETTh1"]="Autoformer_ETTh1.sh Crossformer_ETTh1.sh Informer_ETTh1.sh Nonstationary_Transformer_ETTh1.sh PatchTST_ETTh1.sh TiDE_ETTh1.sh DLinear_ETTh1.sh GLAFFLinear_ETTh1.sh TimeLinear_ETTh1.sh"
  ["ETTh2"]="Autoformer_ETTh2.sh Crossformer_ETTh2.sh Informer_ETTh2.sh Nonstationary_Transformer_ETTh2.sh PatchTST_ETTh2.sh TiDE_ETTh2.sh DLinear_ETTh2.sh GLAFFLinear_ETTh2.sh TimeLinear_ETTh2.sh"
  ["ETTm1"]="Autoformer_ETTm1.sh Crossformer_ETTm1.sh Informer_ETTm1.sh Nonstationary_Transformer_ETTm1.sh PatchTST_ETTm1.sh TiDE_ETTm1.sh DLinear_ETTm1.sh GLAFFLinear_ETTm1.sh TimeLinear_ETTm1.sh"
  ["ETTm2"]="Autoformer_ETTm2.sh Crossformer_ETTm2.sh Informer_ETTm2.sh Nonstationary_Transformer_ETTm2.sh PatchTST_ETTm2.sh TiDE_ETTm2.sh DLinear_ETTm2.sh GLAFFLinear_ETTm2.sh TimeLinear_ETTm2.sh"
)

# 定义基本路径
base_script_path="scripts/long_term_forecast"

# 将数据集名称按字母顺序排序，确保从 ETTh1 开始
for dataset in $(echo "${!dataset_scripts[@]}" | tr ' ' '\n' | sort)
do
    echo "Running scripts for dataset $dataset"
    
    # 遍历数据集对应的脚本
    for script in ${dataset_scripts[$dataset]}
    do
        # 运行脚本
        echo "Running $script"
        sh $base_script_path/ETT_script_L_336/$script
    done
done
