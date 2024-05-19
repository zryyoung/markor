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

    # 输出当前目录的名称和路径
    structure+="\n${indent}- **$current_dir_name**\n"

    # 遍历当前目录下的文件夹
    for entry in "$current_dir"/*; do
        # 获取文件夹的名称
        if [ -d "$entry" ]; then
            # 如果是文件夹，则递归调用生成目录结构
            structure+=$(generate_structure "$entry" "${indent}  ")
        fi
    done

    # 遍历当前目录下的文件
    for entry in "$current_dir"/*; do
        # 获取文件的名称
        if [ -f "$entry" ]; then
            # 如果是文件，则输出文件名
            local name=$(basename "$entry")
            structure+="\n ${indent}  $name\n"
        fi
    done

    # 返回目录结构字符串
    echo -e "$structure"
}

# 读取原始 README.md 文件的内容
readme_content=$(cat "$main_directory/README.md")

# 生成目录结构
directory_structure=$(generate_structure "$main_directory" "")

# 将目录结构添加到 README.md 文件内容中
updated_readme_content="${readme_content}\n\n${directory_structure}"

# 将更新后的内容写回 README.md 文件中
echo -e "$updated_readme_content" > "$main_directory/README.md"

echo "目录结构已成功添加到 README.md 文件中！"