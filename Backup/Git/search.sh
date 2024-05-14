# 指定的目录
directory='/storage/emulated/0/Documents/markor1/'
# 加入搜索功能的代码
search_code="## Search\n<div style=\"margin-bottom: 20px;\">\n  <input type=\"text\" id=\"searchInput\" placeholder=\"Search...\" style=\"padding: 8px; border: 1px solid #ccc; border-radius: 4px;\" oninput=\"searchFunction()\">\n</div>\n<script>\nfunction searchFunction() {\n  var input, filter, ul, li, a, i, txtValue;\n  input = document.getElementById('searchInput');\n  filter = input.value.toUpperCase();\n  ul = document.getElementById('indexList');\n  li = ul.getElementsByTagName('li');\n  for (i = 0; i < li.length; i++) {\n    a = li[i].getElementsByTagName('a')[0];\n    txtValue = a.textContent || a.innerText;\n    if (txtValue.toUpperCase().indexOf(filter) > -1) {\n      li[i].style.display = '';\n    } else {\n      li[i].style.display = 'none';\n    }\n  }\n}\n</script>\n\n<ul id=\"indexList\">"

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
            elif [[ $name != 'index.md' && $name != .* ]]; then
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
            markdown_content+="\n$(printf '###%.0s' $(seq 1 $((level + 1)))) $name\n\n"
            markdown_content+="$sub_content"
        fi
    done

    # 将搜索功能代码添加到 Markdown 内容开头
    markdown_content="$markdown_content"

    echo -e "$markdown_content"
}

# 生成 Markdown 内容
markdown_content=$(generate_markdown "$directory")

# 将 Markdown 内容和 </ul> 标签写入 index.md 文件
index_path="$directory/index.md"
{
    echo -e "$search_code"
    echo -e "$markdown_content"
    echo -e "</ul>"
} > "$index_path"

echo "已生成 index.md 文件！"