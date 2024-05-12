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