#!/bin/bash

SOURCE=/youtu-reid/gatilin/datasets/kaggle
TARGET=/svap_storage/gatilin/datasets/kaggle

function show_progress() {
    current=$1
    total=$2
    percentage=$(awk "BEGIN { pc=100*${current}/${total}; i=int(pc); print (pc-i<0.5)?i:i+1 }")
    echo -ne "复制进度: $current/$total ($percentage%)\r"
}

if [ ! -d "$SOURCE" ]; then
    echo "源目录不存在: $SOURCE"
    exit 1
fi

if [ ! -d "$TARGET" ]; then
    echo "目标目录不存在: $TARGET"
    exit 1
fi

read -p "是否覆盖已存在的文件? (y/n): " overwrite
if [[ ! $overwrite =~ ^[YyNn]$ ]]; then
    echo "无效的输入，退出脚本。"
    exit 1
fi

total_files=$(find $SOURCE -type f | wc -l)
count=0

find $SOURCE -type f -print0 | while IFS= read -r -d '' file; do
    target_file="${TARGET}${file#$SOURCE}"
    target_dir=$(dirname "$target_file")
    mkdir -p "$target_dir"

    if [ -f "$target_file" ]; then
        if [[ $overwrite =~ ^[Yy]$ ]]; then
            cp -f "$file" "$target_file"
            count=$((count+1))
        else
            echo "文件已存在，跳过: $target_file"
        fi
    else
        cp -f "$file" "$target_file"
        count=$((count+1))
    fi

    show_progress $count $total_files
done

echo -e "\n文件复制完成"