#!/bin/bash

# 执行 Node.js 文件
node MostDirectory.js

# 切换到指定目录
cd /storage/emulated/0/Documents/markor/

# 执行 Git 操作
git pull
git add .
git commit -m "Update"
git push -u origin main
