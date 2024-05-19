### Markor: Markdown文件编辑工具与GitHub仓库托管

- **效果网站：**  
[Markor 实时浏览](https://zryyoung.github.io/markor/)

- **Markor存储仓库：**  
[Markor GitHub仓库](https://github.com/zryyoung/markor/)

**详细步骤：**

1. **安装Markor和Termux：** 在手机上安装Markor和Termux应用。

2. **安装Git：** 在Termux中安装Git：
   ```markdown
   pkg install git
   ```

3. **配置Git：** 设置Git用户名和邮箱，以便提交到GitHub：
   ```markdown
   git config --global user.name "Your GitHub Username"
   git config --global user.email "your.email@example.com"
   ```

4. **创建GitHub仓库：** 在GitHub上创建一个新的仓库，用来存储Markdown笔记。

5. **使用Markor编辑Markdown文件：** 打开Markor应用，创建或编辑Markdown文件。

6. **提交更改到GitHub仓库：** 在Termux中导航到本地仓库目录，使用Git添加、提交和推送更改到GitHub：
   ```markdown
   cd /storage/emulated/0/Documents/markor/
   git add .
   git commit -m "Add/update your Markdown notes"
   git remote add origin <远程仓库URL>
   git push
   ```

7. **执行shell脚本：** 在Termux中执行shell脚本，为每个目录生成index.md文件，方便各文件之间的跳转。
   - [脚本链接](https://zryyoung.github.io/markor/Backup/Git/MostDirectoryGrading.sh)
   ```markdown
   wget https://zryyoung.github.io/markor/Backup/Git/MostDirectoryGrading.sh
   bash MostDirectoryGrading.sh
   ```

8. **再次推送到GitHub仓库：** 执行脚本后，再次推送更改到GitHub仓库。你也可以将两个脚本合并为一个以便每次推送使用。
   - [合并后的脚本链接](https://zryyoung.github.io/markor/Backup/Git/upGit.sh)
   ```markdown
   wget https://zryyoung.github.io/markor/Backup/Git/upGit.sh
   bash upGit.sh
   ```

9. **配置GitHub Pages：** 在GitHub上启用GitHub Pages，实现自动将md文件编译成HTML文件，通过网络实时访问浏览。
   - **步骤：**
     1. **选择仓库：** 打开要托管网站的GitHub仓库。
     2. **转到设置页面：** 点击仓库上方的“Settings”选项卡。
     3. **选择页面源：** 在“Source”下拉菜单中选择`main`分支作为托管网站的源。
     4. **保存更改：** 选择根目录文件夹（`/root`），然后点击“Save”按钮。
     5. **等待构建完成：** GitHub Pages将自动构建你的网站。完成后，你会在“GitHub Pages”选项下看到一个指向你网站的链接。
     6. **访问网站：** 点击生成的链接即可访问你的网站。

这样，你就可以在GitHub仓库托管Markdown文件，并通过GitHub Pages实时浏览你的笔记。无论何时何地，只要有网络，你都能跨平台写笔记。另外，GitHub的版本控制功能还可以让你轻松回滚到任意版本。