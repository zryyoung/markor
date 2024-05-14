#!/bin/bash

# 指定的主目录
main_directory='/storage/emulated/0/Documents/markor1'

# 获取主目录的名称
main_directory_name=$(basename "$main_directory")

# 生成目录索引的函数
generate_index() {
    local current_dir="$1"
    local current_index="$current_dir/index.md"
    local current_dir_name=$(basename "$current_dir")
    
    # 清空当前目录的 index.md 文件
    > "$current_index"

    # 输出当前目录的名称，除非是主目录
    if [ "$current_dir" != "$main_directory" ]; then
        echo "# $current_dir_name" >> "$current_index"
    fi

    # 遍历当前目录下的文件和文件夹
    for entry in "$current_dir"/*; do
        # 获取文件或文件夹的名称
        local name=$(basename "$entry")
        
        # 如果是文件夹，则生成对应的链接
        if [ -d "$entry" ] && [ "$name" != "index.md" ]; then
            echo "- [**$name**]($name/index.md)" >> "$current_index"
            # 递归调用生成子目录的 index.md 文件
            generate_index "$entry"
        # 如果是文件，并且不是 index.md 或 README.md，则生成对应的链接
        elif [ -f "$entry" ] && [ "$name" != "index.md" ] && [ "$name" != "README.md" ]; then
            echo "- [$name]($name)" >> "$current_index"
        fi
    done
}

# 递归生成主目录及其所有子目录下的 index.md 文件
generate_index "$main_directory"

echo "已生成所有目录的 index.md 文件！"