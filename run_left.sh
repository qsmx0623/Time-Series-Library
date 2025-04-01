#!/bin/bash

# 定义数据集和对应脚本的关系
declare -A dataset_scripts
dataset_scripts=(
  ["Electricity"]="Autoformer.sh Crossformer.sh Informer.sh Nonstationary_Transformer.sh PatchTST.sh TiDE.sh DLinear.sh GLAFFLinear.sh TimeLinear.sh"
)

# 定义基本路径
base_script_path="scripts/long_term_forecast"

# 将数据集名称按字母顺序排序（这里只有一个数据集 "Electricity"）
for dataset in $(echo "${!dataset_scripts[@]}" | tr ' ' '\n' | sort)
do
    echo "Running scripts for dataset $dataset"
    
    # 遍历数据集对应的脚本
    for script in ${dataset_scripts[$dataset]}
    do
        # 运行脚本
        echo "Running $script"
        sh $base_script_path/ECL_script/$script
    done
done
