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

# 生成 Markdown 目录索引的函数
generate_index() {
    local dir="$1"
    local parent_folder="$2"

    local markdown_content=""

    # 清除当前文件夹的 index.md 文件
    rm -f "$dir/index.md"

    # 遍历目录下的文件和文件夹
    for file in "$dir"/*; do
        if [ -d "$file" ] && [[ "$(basename "$file")" != .* ]]; then
            # 如果是文件夹且不以点开头，则写入当前文件夹的链接
            local folder_name=$(basename "$file")
            local folder_path="${parent_folder:+$parent_folder/}$folder_name"
            markdown_content+="- [${folder_name}](${folder_path}/index.md)\n"
            # 递归生成当前文件夹的 index.md 文件
            generate_index "$file" "${parent_folder:+$parent_folder/}$folder_name"
        elif [ -f "$file" ] && [[ ! "$(basename "$file")" =~ ^\..* && "$(basename "$file")" != "README.md" && "$(basename "$file")" != "index.md" ]]; then
            # 如果是文件且不以点开头，并且不是 README.md 和 index.md，则将文件添加到 markdown_content 中
            local file_name=$(basename "$file")
            local file_path="${parent_folder:+$parent_folder/}${file_name%.md}.md"
            markdown_content+="- [${file_name%.md}](${file_path})\n"
        fi
    done

    # 生成当前文件夹的 index.md 文件
    echo -e "# ${parent_folder:-主目录}\n\n$markdown_content" > "$dir/index.md"
}

# 清空并生成主目录的 index.md
> "$directory/index.md"
generate_index "$directory" ""

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
generate_index() {
    local dir="$1"
    local parent_folder="$2"

    local markdown_content=""

    # 清除当前文件夹的 index.md 文件
    rm -f "$dir/index.md"

    # 遍历目录下的文件和文件夹
    for file in "$dir"/*; do
        if [ -d "$file" ] && [[ "$(basename "$file")" != .* ]]; then
            # 如果是文件夹且不以点开头，则写入当前文件夹的链接
            local folder_name=$(basename "$file")
            local folder_path="${parent_folder:+$parent_folder/}$folder_name"
            markdown_content+="- [${folder_name}](${folder_path}/index.md)\n"
            # 递归生成当前文件夹的 index.md 文件
            generate_index "$file" "${parent_folder:+$parent_folder/}$folder_name"
        elif [ -f "$file" ] && [[ ! "$(basename "$file")" =~ ^\..* && "$(basename "$file")" != "README.md" && "$(basename "$file")" != "index.md" ]]; then
            # 如果是文件且不以点开头，并且不是 README.md 和 index.md，则将文件添加到 markdown_content 中
            local file_name=$(basename "$file")
            local file_path="${parent_folder:+$parent_folder/}${file_name%.md}.md"
            markdown_content+="- [${file_name%.md}](${file_path})\n"
        fi
    done

    # 生成当前文件夹的 index.md 文件
    echo -e "# ${parent_folder:-主目录}\n\n$markdown_content" > "$dir/index.md"
}

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

比如说保存到
```
update_notes.sh
```
下次直接
```bash
./update_notes.sh
```
or
```bash
bash update_notes.sh
```

