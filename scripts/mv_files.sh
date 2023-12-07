#!/bin/bash

function show_progress() {
    current=$1
    total=$2
    percentage=$(awk "BEGIN { pc=100*${current}/${total}; i=int(pc); print (pc-i<0.5)?i:i+1 }")
    echo -ne "移动进度: $current/$total ($percentage%)\r"
}

SOURCE=/path/to/source
TARGET=/pathg/to/target

total_files=$(find $SOURCE -type f | wc -l)
count=0

find $SOURCE -type f -print0 | while IFS= read -r -d '' file; do
    target_file="${TARGET}${file#$SOURCE}"
    target_dir=$(dirname "$target_file")
    mkdir -p "$target_dir"

    if [ -f "$target_file" ]; then
        echo "文件已存在: $target_file"
    else
        mv -f "$file" "$target_file"
        count=$((count+1))
    fi

    show_progress $count $total_files
done

echo -e "\n文件移动完成"