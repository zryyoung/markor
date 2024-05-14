# 指定的目录
directory='/storage/emulated/0/Documents/markor/'

# 生成 Markdown 文件的函数
generate_markdown() {
    local directory="$1"
    local level="${2:-0}"
    local parent_folder="${3:-}"

    local markdown_content=""
    local folders=()
    local non_folders=()

    # 遍历目录并生成 Markdown 内容
    for file in "$directory"/*; do
        local name=$(basename "$file")
        if [[ $name != .* && $name != 'README.md' ]]; then
            if [[ -d $file ]]; then
                # 如果是文件夹，则递归调用 generate_markdown 函数
                folders+=("$file")
            elif [[ $name != 'index.md' && $name == *.md ]]; then
                # 如果是 Markdown 文件且不是主目录下的 index.md，则添加到 non_folders 数组中
                non_folders+=("$file")
            fi
        fi
    done

    # 添加文件夹里的文件
    for file in "${non_folders[@]}"; do
        local name=$(basename "$file")
        local folder_path="${parent_folder:+$parent_folder/}"
        markdown_content+="- [${name%.md}]($folder_path$name)\n\n"
    done

    # 添加文件夹
    for folder in "${folders[@]}"; do
        local name=$(basename "$folder")
        local sub_content=$(generate_markdown "$folder" $((level + 1)) "${parent_folder:+$parent_folder/}$name")
        if [ -n "$sub_content" ]; then
            markdown_content+="\n$(printf '#%.0s' $(seq 1 $((level + 1)))) $name\n\n"
            markdown_content+="$sub_content"
        fi
    done

    echo -e "$markdown_content"
}

# 生成 Markdown 内容
markdown_content=$(generate_markdown "$directory")

# 将 Markdown 内容写入 index.md 文件
index_path="$directory/index.md"
echo -e "$markdown_content" > "$index_path"
echo "已生成 index.md 文件！"

# 切换到指定目录
cd "$directory" || exit

# 执行 Git 操作
git pull
git add .                           
# 将所有修改、删除和已被 Git 管理的文件添加到暂存区
git commit -m "Update: $(date +'%Y-%m-%d %H:%M:%S') - Modified files: $(git diff --name-only --cached)"  
# 使用当前日期和时间作为提交信息的一部分，并列出修改的文件
git push -u origin main
echo "提交更改到GitHub仓库..."
