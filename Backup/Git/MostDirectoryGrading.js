const fs = require('fs');
const path = require('path');

// 指定的主目录
const mainDirectory = '/storage/emulated/0/Documents/markor1/';

// 递归遍历目录并生成 Markdown 链接
function generateIndexFiles(directory, isMainDirectory = false) {
    const files = fs.readdirSync(directory);
    const folders = files.filter(file => fs.statSync(path.join(directory, file)).isDirectory());

    // 生成当前目录的 index.md 文件
    const filesLinks = files
        .filter(file => path.extname(file) === '.md' && !file.toLowerCase().startsWith('readme') && file.toLowerCase() !== 'index.md')
        .map(file => `- [${path.basename(file, '.md')}](${file})\n`)
        .join('');

    const foldersLinks = folders.map(folder => `- [**${path.basename(folder)}**](${folder}/index.md)\n`).join('\n\n'); // 添加空行

    const markdownContent = isMainDirectory ? `${foldersLinks}\n\n${filesLinks}` : `# ${path.basename(directory)}\n\n${foldersLinks}\n${filesLinks}`;
    fs.writeFileSync(path.join(directory, 'index.md'), markdownContent);

    // 递归处理子目录
    folders.forEach(folder => {
        const folderPath = path.join(directory, folder);
        generateIndexFiles(folderPath);
    });
}

// 生成主目录及其所有子目录下的 index.md 文件
generateIndexFiles(mainDirectory, true);

console.log('已生成主目录及其所有子目录的 index.md 文件！');