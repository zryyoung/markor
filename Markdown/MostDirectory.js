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