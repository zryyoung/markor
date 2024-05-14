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