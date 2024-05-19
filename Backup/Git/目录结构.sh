#!/bin/bash

# 指定的主目录
main_directory='/storage/emulated/0/Documents/markor1'

# 生成目录结构的函数
generate_structure() {
    local current_dir="$1"
    local indent="$2"

    # 获取当前目录的名称
    local current_dir_name=$(basename "$current_dir")

    # 初始化目录结构字符串
    local structure=""

    # 遍历当前目录下的文件和文件夹
    for entry in "$current_dir"/*; do
        # 获取文件或文件夹的名称
        local name=$(basename "$entry")
        # 判断是否是目录
        if [ -d "$entry" ]; then
            # 输出当前目录的名称和路径
            structure+="${indent}├─ $current_dir_name\n"
            structure+="$(generate_structure "$entry" "${indent}│  ")"

        else
            # 如果是文件，则输出文件名
            structure+="${indent}├─ $name\n"
        fi
    done

    # 返回目录结构字符串
    echo -e "$structure"
}

# 生成目录结构
directory_structure=$(generate_structure "$main_directory" "")

echo -e "$directory_structure"