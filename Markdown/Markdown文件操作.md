##  Markdown 文件操作

### 使用 Node.js 来进行文件操作
- 安卓手机可使用Termux/zeroTermux，安装node.js，可以运行。

#### 一、单个目录的md文件操作
- 将单个目录下的所有makdown文件，添加到index.js目录中，以下是一个简单的 Node.js 脚本示例
```javascript
const fs = require('fs');
const path = require('path');

// 要添加链接的目录
const directory = '/storage/emulated/0/Documents/markor/Github/';

// 获取目录中所有的 Markdown 文件，排除 index.md 文件
const files = fs.readdirSync(directory).filter(file => path.extname(file) === '.md' && file !== 'index.md');

// 生成 Markdown 链接
const links = files.map(file => `- [${path.basename(file, '.md')}](${file})`);

// 检查是否存在 index.md 文件
const indexPath = path.join(directory, 'index.md');
if (fs.existsSync(indexPath)) {
    // 如果存在 index.md 文件，则读取文件内容，检查是否已经包含相同的链接
    const indexContent = fs.readFileSync(indexPath, 'utf-8');
    const existingLinks = indexContent.match(/\-\[.*\]\(.*\.md\)/g) || [];

    // 检查每个链接是否已经存在于 index.md 文件中，如果不存在则添加到 links 数组中
    links.forEach(link => {
        if (!existingLinks.includes(link)) {
            existingLinks.push(link);
        }
    });

    // 更新 index.md 文件内容
    fs.writeFileSync(indexPath, `
# 我的文档

欢迎来到我的文档。点击以下链接进行跳转：

${existingLinks.join('\n')}
`);
    console.log('已将链接添加到 index.md 文件中！');
} else {
    // 如果不存在 index.md 文件，则创建一个新的 index.md 文件并写入内容
    fs.writeFileSync(indexPath, `
# 我的文档

欢迎来到我的文档。点击以下链接进行跳转：

${links.join('\n')}
`);
    console.log('已创建并写入链接到 index.md 文件！');
}

```
#### 二、多级目录中的md文件和文件夹操作
- 将某路径下的文件夹和 Markdown 文件以及文件夹下的子文件夹文件添加到一个 `index.md`文件中


 1. 按文件夹分级，全部显示到主目录下的index.md文件中。
 
 
```javascript
const fs = require('fs');
const path = require('path');

// 指定的目录
const directory = '/storage/emulated/0/Documents/markor/';

// 递归遍历目录并生成 Markdown 链接
function generateMarkdown(directory, level = 0, parentFolder = '') {
    const files = fs.readdirSync(directory);
    let markdownContent = '';
    const folders = [];
    const nonFolders = [];

    files
        .map(file => ({
            name: file,
            fullPath: path.join(directory, file),
            stats: fs.statSync(path.join(directory, file))
        }))
        .filter(fileInfo => !fileInfo.name.startsWith('.')) // 排除以点开头的文件
        .forEach(fileInfo => {
            const { name, fullPath, stats } = fileInfo;

            if (stats.isDirectory()) {
                // 如果是文件夹，则将其记录在 folders 数组中
                folders.push(fileInfo);
            } else if (stats.isFile() && name !== 'index.md') {
                // 如果是 Markdown 文件且不是主目录下的 index.md，则将其记录在 nonFolders 数组中
                nonFolders.push(fileInfo);
            }
        });

    // 首先添加文件夹里的文件
    nonFolders.forEach(fileInfo => {
        const { name, stats } = fileInfo;
        const folderPath = parentFolder ? `${parentFolder}/` : '';
        markdownContent += `- [${path.basename(name, '.md')}](${folderPath}${name})\n\n`;
    });

    // 然后添加文件夹
    folders.forEach((folderInfo, index) => {
        const { name, fullPath } = folderInfo;
        markdownContent += `\n${'#'.repeat(level + 1)} ${name}\n\n`;
        markdownContent += generateMarkdown(fullPath, level + 1, parentFolder ? `${parentFolder}/${name}` : name);
    });

    return markdownContent;
}

// 生成 Markdown 内容
const markdownContent = generateMarkdown(directory);

// 将 Markdown 内容写入 index.md 文件
const indexPath = path.join(directory, 'index.md');
fs.writeFileSync(indexPath, `${markdownContent}`);
console.log('已生成 index.md 文件！');
```


2. 以目录的形式，按文件夹分级展开。

```javascript

const fs = require('fs');
const path = require('path');

// 指定的目录
const directory = '/storage/emulated/0/Documents/markor/';

// 递归遍历目录并生成 Markdown 链接
function generateMarkdown(directory, parentFolder = '') {
    let markdownContent = '';

    const files = fs.readdirSync(directory);
    const folders = files.filter(file => fs.statSync(path.join(directory, file)).isDirectory());

    folders
        .filter(folder => !folder.startsWith('.') && !folder.startsWith('_')) // 排除以点开头的文件夹
        .sort((a, b) => {
            const statA = fs.statSync(path.join(directory, a));
            const statB = fs.statSync(path.join(directory, b));
            return statB.mtime.getTime() - statA.mtime.getTime(); // 按文件夹创建时间排序
        })
        .forEach(folder => {
            const folderPath = path.join(parentFolder, folder);
            markdownContent += `- [${folder}](${folderPath}/index.md)\n`;
            generateMarkdown(path.join(directory, folder), folderPath);
            const subFolderPath = path.join(directory, folder);
            const subFiles = fs.readdirSync(subFolderPath).filter(file => path.extname(file) === '.md' && file !== 'index.md');
            const subFilesLinks = subFiles.map(file => `- [${path.basename(file, '.md')}](${file})\n`).join('');
            fs.writeFileSync(path.join(subFolderPath, 'index.md'), `# ${folder} 目录\n\n${subFilesLinks}`);
        });

    return markdownContent;
}

// 生成 Markdown 内容
const markdownContent = generateMarkdown(directory);

// 将 Markdown 内容写入 index.md 文件
const indexPath = path.join(directory, 'index.md');
fs.writeFileSync(indexPath, `# 主目录\n\n${markdownContent}`);

console.log('已生成 index.md 文件！');


```
