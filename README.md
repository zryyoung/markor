## markor
### 此仓库用于保存md文件
安卓手机端的应用Markor，这是一个用来保存此应用的markdown文件的Github仓库。


### 使用Termux/zeroTermux实现本地md笔记上传至Github仓库

**详细的步骤：**

1. **在手机上安装Markor和Termux**：如果你还没有安装这两个应用，可以从Google Play商店或者其他应用商店下载安装。

2. **在Termux中安装Git**：打开Termux应用，在命令行中输入以下命令来安装Git：
   ```bash
   pkg install git
   ```

3. **配置Git**：在Termux中设置你的Git用户名和邮箱，以便提交到GitHub：
   ```bash
   git config --global user.name "Your GitHub Username"
   git config --global user.email "your.email@example.com"
   ```

4. **创建GitHub仓库**：在GitHub上创建一个新的仓库，用来存储你的Markdown笔记。

5. **将GitHub仓库克隆到本地**：在Termux中使用Git将你的GitHub仓库克隆到本地：
   ```bash
   git clone https://github.com/yourusername/your-repository.git
   ```
   将 `yourusername` 替换为你的GitHub用户名， `your-repository` 替换为你的仓库名称。

6. **使用Markor编辑Markdown文件**：打开Markor应用，创建或编辑Markdown文件，将其保存到你在第 5 步中克隆的本地仓库目录中。

7. **提交更改到GitHub**：在Termux中，导航到你的本地仓库目录，然后使用Git添加、提交和推送你的更改到GitHub：
   ```bash
   cd /storage/emulated/0/Documents/markor/
   git add .
   git commit -m "Add/update your Markdown notes"
   git push origin main
   ```
   
