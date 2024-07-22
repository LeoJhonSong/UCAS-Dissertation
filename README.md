# UCAS-Dissertation
国科大硕士/博士学位论文LeTeX模板, 以《中国科学院大学研究生学位论文撰写规范指导意见》(校发学位字[2022]40号, 附件1) 作为撰写要求

## 使用

### 在线编辑

将压缩包上传Overleaf或[中国科技云Overleaf](https://www.cstcloud.cn/resources/452) (无编译时间限制) 后在菜单中需将编译器选为`xelatex`

### 本地编辑

根目录包含的`.latexmkrc`是**latexmk**的配置文件, 以xelatex为编译器, 运行`latexmk`即可编译, 生成的pdf文件在`build`目录下. 运行`latexmk -c`以清理中间文件. 推荐使用安装了**Latex Workshop**插件的**VSCode**进行编辑, `.vscode/settings.json`中已包含推荐的**Latex Workshop**的配置.