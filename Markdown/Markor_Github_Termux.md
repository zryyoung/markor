## Markdown格式教程：将Markdown笔记发布到GitHub Pages
### 使用Markor和Termux，写md笔记并将本地的文件目录发布到Github仓库，再配合GithubPages通过网络直接访问访问，比如说username.github.io/markor

## 1. 安装应用程序

- 在你的Android设备上，打开Google Play商店。
- 搜索并安装Markor和Termux应用。

## 2. 写笔记

- 使用Markor在本地编写Markdown笔记。
- 将笔记保存在 `/storage/emulated/0/Documents/markor/` 目录下。

## 3. 在Termux中编写脚本以生成index.md

创建一个shell脚本，比如 `generate_index.sh`，用于递归遍历 `/storage/emulated/0/Documents/markor/` 目录并生成 `index.md` 文件。脚本内容如下：

```bash
#!/bin/bash

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
```
复制上面的脚本，
```bash
nano generate_index.sh
```
粘贴，ctrl加s保存，ctrl加x退出

## 4. 在Termux中执行脚本

在Termux中执行以下命令来运行脚本并生成 `index.md` 文件：

```bash
cd /path/to/script/directory
bash generate_index.sh
```

## 5. 安装Git

如果你的Termux中尚未安装Git，可以使用以下命令进行安装：

```bash
pkg install git
```

## 6. 创建GitHub账户和仓库

- 如果你还没有GitHub账户，可以在GitHub网站上注册一个新账户。
- 在GitHub上创建一个新的仓库，用于存储你的Markdown笔记。

## 7. 将Markdown笔记提交到GitHub仓库

在Termux中导航到你的Markor笔记目录：

```bash
cd /storage/emulated/0/Documents/markor/
```

初始化Git仓库并添加远程仓库地址：

```bash
git init
git remote add origin <GitHub仓库地址>
```

添加所有文件并提交更改：

```bash
git add .
git commit -m "Add Markdown notes"
```

将更改推送到GitHub仓库：

```bash
git push -u origin master
```

## 8. 配置GitHub Pages

- 进入你的GitHub仓库页面，点击Settings。
- 在GitHub Pages部分，选择主分支和 `/root` 目录作为源，并保存设置。

## 9. 访问你的GitHub Pages

在浏览器中输入你的GitHub Pages网址，如 `https://<你的GitHub用户名>.github.io/<你的仓库名>`，即可直接访问你的Markdown笔记。

通过以上步骤，你应该能够方便地编写、管理和访问你的Markdown笔记了。

### Tip：把生成md的脚本和下次需要直接提交更改推送的git脚本放在一起，写成一个脚本，方便下次提交

```bash
#!/bin/bash

# 生成 Markdown 目录索引的函数
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

# 清空并生成主目录的 index.md
> "$directory/index.md"
generate_index "$directory" ""

echo "已生成 index.md 文件！"

cd /storage/emulated/0/Documents/markor/

# 提交更改推送到GitHub仓库
echo "提交更改到GitHub仓库..."
git add .
git commit -m "Update Markdown notes"
git push origin master

echo "更改已推送到GitHub仓库！"
```

比如说保存到`update_notes.sh`文件，下次直接用
```bash
./update_notes.sh
```
或者
```bash
bash update_notes.sh
```

