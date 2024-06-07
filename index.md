## Search
<div style="margin-bottom: 20px;">
  <input type="text" id="searchInput" placeholder="Search..." style="padding: 8px; border: 1px solid #ccc; border-radius: 4px;" oninput="searchFunction()">
</div>
<script>
function searchFunction() {
  var input, filter, ul, li, a, i, txtValue;
  input = document.getElementById('searchInput');
  filter = input.value.toUpperCase();
  ul = document.getElementById('indexList');
  li = ul.getElementsByTagName('li');
  for (i = 0; i < li.length; i++) {
    a = li[i].getElementsByTagName('a')[0];
    txtValue = a.textContent || a.innerText;
    if (txtValue.toUpperCase().indexOf(filter) > -1) {
      li[i].style.display = '';
    } else {
      li[i].style.display = 'none';
    }
  }
}
</script>

```html

<ul id="indexList">

### Backup

- [e.html](Backup/e.html)

- [test](Backup/test.md)


###### Git

- [MostDirectory.js](Backup/Git/MostDirectory.js)

- [MostDirectory.sh](Backup/Git/MostDirectory.sh)

- [MostDirectoryGrading.js](Backup/Git/MostDirectoryGrading.js)

- [MostDirectoryGrading.sh](Backup/Git/MostDirectoryGrading.sh)

- [MostDirectoryGradingOld.js](Backup/Git/MostDirectoryGradingOld.js)

- [_config.yml](Backup/Git/_config.yml)

- [search.sh](Backup/Git/search.sh)

- [upGit.sh](Backup/Git/upGit.sh)

- [update.sh](Backup/Git/update.sh)

- [目录结构.sh](Backup/Git/目录结构.sh)

- [目录结构markdown格式.sh](Backup/Git/目录结构markdown格式.sh)
### Github

- [1.Github入门](Github/1.Github入门.md)

- [2.Github功能介绍](Github/2.Github功能介绍.md)

- [3.Github仓库管理](Github/3.Github仓库管理.md)

- [4.Github克隆仓库](Github/4.Github克隆仓库.md)

- [5.Git版本控制](Github/5.Git版本控制.md)

- [6.Github_Action](Github/6.Github_Action.md)

- [7.Github_Page](Github/7.Github_Page.md)

- [8.Github进阶](Github/8.Github进阶.md)
### Markdown

- [Github托管](Markdown/Github托管.md)

- [Markdown入门](Markdown/Markdown入门.md)

- [Markdown文件操作](Markdown/Markdown文件操作.md)

- [Markor_Github_Termux](Markdown/Markor_Github_Termux.md)


###### Nodejs

- [MostDirectory.js](Markdown/Nodejs/MostDirectory.js)

- [MostDirectoryGrading.js](Markdown/Nodejs/MostDirectoryGrading.js)

- [SingleDirectory.js](Markdown/Nodejs/SingleDirectory.js)
### Termux

- [Termux](Termux/Termux.md)

- [Test](Termux/Test.md)

- [openJDK_Termux](Termux/openJDK_Termux.md)

</ul>
```
