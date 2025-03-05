# UCAS-Dissertation
国科大硕士/博士学位论文LeTeX模板, 以《中国科学院大学研究生学位论文撰写规范指导意见》(校发学位字[2022]40号, 附件1) 作为撰写要求

## 文件结构

```
.
├── 📁.vscode                      vscode配置文件
├── 📁assets                       图片/附件代码等资产放这里, 如果文件较多建议进一步按章节分为多个文件夹
├── 📁bibs
│   ├── 📒abbreviations.bib        术语表的缩写类术语定义
│   └── 📒mywork.bib               用于“作者简历及攻读学位期间发表的学术论文与其他相关学术成果”章节 (cv.tex) 的个人学术论文及专利的bibtex/biblatex
│   ├── 📒references.bib           参考文献的bibtex/biblatex都放这里
│   └── 📒symbols.bib              术语表的数学符号类术语定义
├── 📦build                        编译出的文件在这个目录, 比如编译出的pdf文件`Thesis.pdf`
├── 📁styles                       本模板核心文件, 定义模板样式
│   ├── 📜ucasDissertation.cls     论文样式及附带命令
│   ├── 📜ucasInfo.sty             提供一组`info.tex`中的论文信息变量设置命令
│   ├── 📜ucasSilence.sty          抑制无用的编译warning
│   └── 📜ucasSpine.cls            书脊样式
├── 📑abstract.tex                 摘要章节
├── 📑acknowledgements.tex         致谢章节
├── 📑appendix1.tex                附录章节, 一章写在一个文件, 根据需要增加
├── 📑chapter1.tex                 正文章节, 一章写在一个文件, 根据需要增加
├── 📑cv.tex                       作者简历章节
├── 🪪info.tex                     论文信息整理于此处
├── 💼spine.tex                    书脊pdf根文件
├── 📕Thesis.pdf                   编译出的论文pdf样例
└── 💼Thesis.tex                   论文pdf根文件
```

项目大致文件结构如上. 论文写作流程:

1. 填写`info.tex`, 填写论文信息 (论文标题如果还没想好可以之后再填)
2. 写正文章节, 根据需要增加`chapterN.tex`, `Thesis.tex`中`\include{chapter1.tex}`下方增加`\include{chapterN.tex}`. 附录章节操作是类似的.
2. 填写摘要, 致谢, 简历等章节
2. 书脊pdf不需要编辑, 只需要生成

## 编译方式

### 在线编辑

将压缩包上传Overleaf或[中国科技云Overleaf](https://www.cstcloud.cn/resources/452) (无编译时间限制) 后在菜单中需将编译器选为`xelatex`. 打开Thesis.tex并编译可以生成论文pdf, 打开spine.tex并编译可以生成书脊pdf. 由于overleaf/科技云会覆盖`.latexmkrc`中设置的latexmk规则, 输出文件夹被覆写为根目录, 因此想要正常编译**需要做两点修改**:
1. 在行首加`#`, 注释[.latexmkrc](./.latexmkrc)中`$xelatex=`开头的行
   ```diff
   - xelatex = 'xelatex -synctex=1 -interaction=nonstopmode -file-line-error -shell-escape -output-directory=%0 %S';
   + #xelatex = 'xelatex -synctex=1 -interaction=nonstopmode -file-line-error -shell-escape -output-directory=%0 %S';
   ```
2. [styles/ucasDissertation.cls](./styles/ucasDissertation.cls)第464行minted包`outputdir`选项的值改为`./`
   ```diff
   \RequirePackage[
   -    outputdir=build,
   +    outputdir=./,
       cachedir=minted_cache,
       newfloat,
   ]{minted}
   ```

### 本地编辑

根目录包含的`.latexmkrc`是**latexmk**的配置文件, 以xelatex为编译器, 运行`latexmk`即可编译, 生成的pdf文件在`build`目录下. 运行`latexmk -c`以清理中间文件. 推荐使用安装了**Latex Workshop**插件的**VSCode**进行编辑, `.vscode/settings.json`中已包含推荐的**Latex Workshop**的配置, `latex-snippets.code-snippets`提供了几个可能用得上的snippet.

#### 依赖安装

- 首先你需要安装一个LaTeX发行版, 推荐安装**TeXLive**.
- 参考文献相关内容使用`biber`生成, Windows平台上这个程序好像一般已经包含在LaTeX发行版中了, 而在Linux下可能需要单独安装[biber](https://github.com/plk/biber)
- 术语表相关内容使用`bib2gls`生成, 这个工具需要借助java, 因此你需要有**java**. 不过术语表 ([这里](https://www.overleaf.com/learn/latex/Nomenclatures)有个简单示例) 仅在文中缩写或符号较多时有一定意义, 不想使用术语表的话, 可以把`Thsis.tex`中`\listofnotaions`一行注释掉, 然后删掉章节中调用的所有`\gls{}`命令.
- 代码插入使用`minted`包实现, 其中代码语法高亮依赖于代码语法高亮生成工具[Pygments](https://pygments.org/). 如果你的路径里有Python, 只需`pip install Pygments`即可. (同样如果你不需要插入代码那就不用管)

## 模板选项

**ucasDissertation**模板类提供了几个选项, 除了`ref`选项给定参考文献文件路径, 不应变动, 其他选项可根据需要设置 (取消注释为开启, 注释掉为关闭):

- `print`: 印刷版/电子版 (电子版非另页右页, 仅另页), 关闭时为电子版
- `colorlinks`: 超链接是否彩色, 关闭时为黑色
- `bibBackref`: 是否在参考文献列表中显示文献引用页, 关闭时为不显示
- `draft`: 指定为草稿模式, 会进行简化使生成更快, 在断行不良/溢出出加黑色方块给出提示, 会将pdf压缩等级设为0, 缩短生成时间 (但会导致pdf更大).

## 更多$\LaTeX$帮助

我写了一篇[LaTeX使用笔记](https://leojhonsong.github.io/zh-CN/2021/04/24/LaTeX杂记/), 有兴趣可以看看. 如果仍遇到问题, 欢迎在本仓库提issue.

