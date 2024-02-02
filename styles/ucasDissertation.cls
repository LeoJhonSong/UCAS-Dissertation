% ucasDissertation文档类
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{styles/ucasDissertation}[中国科学院大学硕博学位论文LaTEx模板]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 解析选项
\RequirePackage{keyval}
\newif\ifUCAS@print % 按印刷要求还是为pdf去掉前言的空白页, 默认为false
\DeclareOption{print}{\UCAS@printtrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{ctexbook}} % 将所有未知选项传递给ctexbook类
\ProcessOptions\relax % 执行上面为每个选项定义的代码


% 把使用fontspec的Script=CJK选项导致的no-script警告 (warning) 重定向为信息 (info), 抑制如下警告 (需在加载ctexbook类前).
% Font "FandolSong-Regular" does not contain requested
% (fontspec)	Script "CJK".

% fontspec包需要执行\normalsize命令, 但这个命令在\LoadClass{ctexbook}中的\LoadClass[book]中加载的size12.clo中才重定义
% 为了在加载ctexbook前加载fontspec包, 在此重定义\normalsize (与size12.clo中定义一样)
\renewcommand\normalsize{
    \@setfontsize\normalsize\@xiipt{14.5}%
    \abovedisplayskip 12\p@ \@plus3\p@ \@minus7\p@
    \abovedisplayshortskip \z@ \@plus3\p@
    \belowdisplayshortskip 6.5\p@ \@plus3.5\p@ \@minus3\p@
    \belowdisplayskip \abovedisplayskip
    \let\@listi\@listI}
\RequirePackage{fontspec}
\RequirePackage{xpatch}
\ExplSyntaxOn
\xpatchcmd \fontspec_new_script:nn
{ \__fontspec_warning:nxx }
{ \__fontspec_info:nxx }
{}{\fail}
\newfontscript{CJK}{hani}
\ExplSyntaxOff

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 0. 纸张要求和页面设置
\LoadClass[
    scheme = plain, % ctex宏包仅用于提供中文支持, 不对文章排版进行任何修改
    zihao = -4, % 设置文档字号为小四, 也就是12bp. 见ctex文档表: 标准字体命令与字号的对应
    autoindent = true, % 段首缩进2汉字符
    linespread = 1.25, % 1.25倍行距
    % openany, % 章节不强制 (右页) 奇数页开始 !印刷要求另页右页
    % draft, % 指定为草稿模式, 会进行简化使生成更快, 在断行不良/溢出出加黑色方块给出提示
]{ctexbook}

% 页面设置 ---------------------------------------------------------------------
\RequirePackage[
    a4paper, % 纸张大小
    top = 2.54cm,
    bottom = 2.54cm,
    left = 3.17cm,
    right = 3.17cm,
    % showcrop,
    % showframe, % 用线框可视化显示当前布局各边距大小
]{geometry}
\RequirePackage{setspace}

% 页眉页脚 ----------------------------------------------------------------------
% Word相对于纸张边缘计算而LaTeX相对于版心计算
% 页眉顶端距离= top - headheight - headsep
\geometry{
    headheight=0.51cm, % 页眉高度
    headsep=0.53cm, % 页眉与正文间距
    footskip=1.04cm, % 页脚底端距离= bottom - footskip
}
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\renewcommand{\chaptermark}[1]{\markboth{\UCAS@header@cn}{\CTEXifname{\CTEXthechapter}{}\quad#1}}
\renewcommand{\sectionmark}[1]{\empty}

% 正文页眉页脚样式
\fancypagestyle{mainmatter}{
    \fancyhf{} % 清除当前页眉页脚样式
    \fancyhead[CO]{\songti\zihao{-5}\rightmark} % 奇数页页眉为章节名, 宋体小五
    \fancyhead[CE]{\songti\zihao{-5}\leftmark} % 偶数页页眉为论文题目, 宋体小五
    \fancyfoot[LE, RO]{\zihao{-5}\thepage}
}
% 前言页码样式
\fancypagestyle{frontmatter}[mainmatter]{
    \fancyfoot{}
    \fancyfoot[C]{\zihao{-5}\thepage}
}

% 默认字体 ---------------------------------------------------------------------
\RequirePackage{fontspec}
\setmainfont{Times New Roman} % 设置英文及阿拉伯数字字体
% ctex默认衬线字体为宋体, 无衬线字体 (\sffamily) 为黑体

% 按文档结构设置样式 ------------------------------------------------------------
\let\oldfrontmatter\frontmatter
\renewcommand{\frontmatter}{
    \oldfrontmatter % 小写罗马数字页码, 章节不编号但计入目录
    \pagenumbering{Roman} % 用大写罗马数字
    \pagestyle{frontmatter}
    \ctexset{chapter/pagestyle = frontmatter} % 章节页眉页脚样式
}

\let\oldmainmatter\mainmatter
\renewcommand{\mainmatter}{
    \oldmainmatter % 重置页码, 阿拉伯数字页码
    \pagenumbering{arabic}
    \pagestyle{mainmatter}
    \ctexset{chapter/pagestyle = mainmatter} % 章节页眉页脚样式
}

% 汉化 -------------------------------------------------------------------------
\ctexset{
    contentsname = {目\quad 录},
    listfigurename = {图目录},
    listtablename = {表目录},
    appendixname = {附录},
    bibname = {参考文献},
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (二) 封面
\renewcommand{\title}[2]{
    \newcommand{\UCAS@title@cn}{#1}
    \newcommand{\UCAS@title@en}{#2}
    \newcommand{\UCAS@header@cn}{#1}
    \newcommand{\UCAS@header@en}{#2}
}
\newcommand{\header}[2]{
    \ifx&#1&\else\renewcommand{\UCAS@header@cn}{#1}\fi % 如果 #1 不为空，给 \UCAS@header@cn 赋值
    \ifx&#2&\else\renewcommand{\UCAS@header@en}{#2}\fi % 如果 #2 不为空，给 \UCAS@header@en 赋值
}
\newcommand{\degree}[1]{
    \ifthenelse{\equal{#1}{硕士}}{
        \newcommand{\UCAS@degree@cn}{硕士}
        \newcommand{\UCAS@degree@en}{master}
        \newcommand{\UCAS@articleType}{thesis}
    }{
        \newcommand{\UCAS@degree@cn}{博士}
        \newcommand{\UCAS@degree@en}{doctor}
        \newcommand{\UCAS@articleType}{dissertation}
    }
}
\newcommand{\setterFactory}[1]{
    \expandafter\edef\csname #1\endcsname##1##2{
        \expandafter\edef\csname UCAS@#1@cn\endcsname{##1}
        \expandafter\edef\csname UCAS@#1@en\endcsname{##2}
    }
}
\forcsvlist{\setterFactory}{author, degreeType, subject, institute, date} % 定义\title, \author等命令
\newcommand{\supervisor}[3]{
    \newcommand{\UCAS@supervisor@cn}{#1}
    \newcommand{\UCAS@supervisor@en}{#2}
    \newcommand{\UCAS@supervisor@institute}{#3}
}

\RequirePackage{contour} % 给字体绘制轮廓, 以解决下划线与下划线上文字重叠的问题
\RequirePackage[normalem]{ulem} % 支持复杂内容的下划线\uline{}

\ExplSyntaxOn
\newcommand{\contouredUline}[1]{ % 没能做到对有轮廓的文本的自动换行支持, 换行需要手动用\\给出
    \seq_set_split:Nnn \l_tmpa_seq { \\ } { #1 } % 分割文本
    \contourlength{0.8pt}
    \seq_map_inline:Nn \l_tmpa_seq { % 遍历每一行
        \uline{\contour{white}{##1}} \\ % 在每一行上应用 \uline{\contour{white}{...}}
    }
}
\ExplSyntaxOff
\newcommand{\cnTitleUline}[1]{ % 增大了下划线与文字间距离, 加粗下划线
    \renewcommand{\ULthickness}{1.8pt}
    \setlength{\ULdepth}{0.5em}
    \uline{#1}
    \renewcommand{\ULthickness}{1pt}
}
\newcommand{\enTitleUline}[1]{
    \renewcommand{\ULthickness}{2.2pt}
    \expandafter\contouredUline\expandafter{#1}
    \renewcommand{\ULthickness}{1pt}
}
\newcommand{\expandedUline}[1]{\renewcommand{\ULthickness}{1pt}\uline{\hfill #1\hfill}}

\newcommand{\makeCover@cn}{ % 中文封面
    \pagestyle{empty} % 首页无页眉页脚
    \begin{center}
        \vspace*{36pt}
        \includegraphics[scale=0.098]{ucas_logo}\par
        \vspace{28pt}
        {\heiti\zihao{1}\UCAS@degree@cn 学位论文\par}
        \vspace{48pt}

        \begin{spacing}{1}{\heiti\zihao{-3}\textbf{\cnTitleUline{\UCAS@title@cn}}}\end{spacing}\par

        \vspace{61pt}\par
        \begin{spacing}{2}
            \bfseries
            \zihao{4}\noindent\begin{tabularx}{\textwidth}{lX}
                作者姓名: & \expandedUline{\UCAS@author@cn} \\
                指导教师: & \expandedUline{\UCAS@supervisor@cn} \\
                         & \expandedUline{\UCAS@supervisor@institute} \\
                学位类别: & \expandedUline{\UCAS@degreeType@cn} \\
                学科专业: & \expandedUline{\UCAS@subject@cn} \\
                培养单位: & \expandedUline{\UCAS@institute@cn} \\
            \end{tabularx}\par
            \vspace{72pt}
            \UCAS@date@cn
        \end{spacing}
    \end{center}
}

\newcommand{\makeCover@en}{ % 英文封面
    \pagestyle{empty}
    \begin{center}
        \vspace*{58pt}
        \renewcommand{\ULthickness}{1.8pt}
        \begin{spacing}{1}{\zihao{-3}\textbf{\enTitleUline{\UCAS@title@en}}}\end{spacing}
        \renewcommand{\ULthickness}{1pt}

        \vspace{80pt}

        \begin{spacing}{2}
            \bfseries\zihao{4}\centering
            A \UCAS@articleType\ submitted to\\
            University of Chinese Academy of Sciences\\
            in partial fulfillment of the requirement\\
            for the degree of\\
            \UCAS@degreeType@en\\
            in \UCAS@subject@en\\
            By\\
            \UCAS@author@en\\
            Supervisor:\quad\UCAS@supervisor@en\\
            \vspace{75pt}
            \UCAS@institute@en\\
            \UCAS@date@en
        \end{spacing}
    \end{center}
}

\newcommand{\makeCover}{ % 中国科学院大学规定的统一中英文封面
    \makeCover@cn
    \ifUCAS@print\cleardoublepage\else\clearpage\fi
    \makeCover@en
    \global\let\makeCover\relax % 销毁该命令, 防止重复调用
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (二) 原创性声明及授权使用声明
\newcommand{\makeDeclaration}{
    \ifUCAS@print\cleardoublepage\else\clearpage\fi
    \pagestyle{empty}
    \begin{spacing}{1.5}
        \vspace*{48pt}
        {\centering\heiti\zihao{4}\textbf{中国科学院大学\\研究生学位论文原创性声明}\par}

        \songti\zihao{-4}
        \vspace{\baselineskip}
        本人郑重声明：所呈交的学位论文是本人在导师的指导下独立进行研究工作所取得
        的成果。承诺除文中已经注明引用的内容外，本论文不包含任何其他个人或集体享
        有著作权的研究成果，未在以往任何学位申请中全部或部分提交。对本论文所涉及
        的研究工作做出贡献的其他个人或集体，均已在文中以明确方式标明或致谢。本人
        完全意识到本声明的法律结果由本人承担。

        \vspace{\baselineskip}

        \hspace{21.5\ccwd}作者签名:\par
        \hspace{21.5\ccwd}日\quad\quad 期:\par

        \vspace{48pt}

        {\centering\heiti\zihao{4}\textbf{中国科学院大学\\学位论文使用授权声明}\par}

        \songti\zihao{-4}
        \vspace{\baselineskip}
        本人完全了解并同意遵守中国科学院大学有关收集、保存和使用学位论文的规定，
        即中国科学院大学有权按照学术研究公开原则和保护知识产权的原则， 保留并向
        国家指定或中国科学院指定机构送交学位论文的电子版和印刷版文件，且电子版与
        印刷版内容应完全相同，允许该论文被检索、查阅和借阅，公布本学位论文的全部
        或部分内容，可以采用扫描、影印、缩印等复制手段以及其他法律许可的方式保
        存、汇编本学位论文。

        涉密及延迟公开的学位论文在解密或延迟期后适用本声明。

        \vspace{\baselineskip}

        {\centering
            作者签名:\hspace{12\ccwd}导师签名:\\
            日\quad\quad 期:\hspace{12\ccwd}日\quad\quad 期:\par
        }
    \end{spacing}
    \global\let\makeDeclaration\relax % 销毁该命令, 防止重复调用
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (三) 书脊
% TODO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (四) 摘要和关键词
\newcommand{\abstract}[2]{
    \newcommand{\UCAS@abstract@cn}{#1}
    \newcommand{\UCAS@abstract@en}{#2}
}
\newcommand{\keywords}[2]{
    \newcommand{\UCAS@keywords@cn}{#1}
    \newcommand{\UCAS@keywords@en}{#2}
}
\newcommand{\makeAbstract}{
    \currentpdfbookmark{摘要}{摘要} % 添加pdf书签. 前一个参数是书签名, 后一个是内部标识
    \chapter*{
        \markboth{\UCAS@header@cn}{摘\quad 要} % 左右mark都设置为章节名, 使其出现在页眉
        摘\quad 要
    }
    \UCAS@abstract@cn\par
    \vspace{\baselineskip}\par % 关键词与摘要间空一行
    \noindent\textbf{关键词:}\ \UCAS@keywords@cn

    \currentpdfbookmark{Abstract}{Abstract}
    \chapter*{
        \markboth{\UCAS@header@en}{Abstract}
        Abstract
    }
    \UCAS@abstract@en\par
    \vspace{\baselineskip}\par
    \noindent\textbf{Keywords:}\ \UCAS@keywords@en

    \global\let\makeAbstract\relax % 销毁该命令, 防止重复调用
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (五) 目录
\RequirePackage[
    titles % 目录, 图表目录的标题以LaTeX默认方法排版, 此处为\ctexset设置的章节标题的样式
]{tocloft}
% 章目录
\setlength{\cftbeforechapskip}{6pt} % 段前距
\renewcommand{\cftchapfont}{\heiti\zihao{4}\linespread{1.0}} % 黑体四号单倍行距
% 二级标题目录
\setlength{\cftbeforesecskip}{6pt}
\renewcommand{\cftsecfont}{\heiti\zihao{-4}\linespread{1.0}} % 黑体小四号单倍行距
\renewcommand{\cftsecindent}{1\ccwd}
% 三级标题目录
\setlength{\cftbeforesubsecskip}{6pt}
\renewcommand{\cftsubsecfont}{\heiti\zihao{-4}\linespread{1.0}} % 黑体小四号单倍行距
\renewcommand{\cftsubsecindent}{2\ccwd}
% 图表目录
\setlength{\cftbeforefigskip}{6pt}
\setlength{\cftbeforetabskip}{6pt}
\renewcommand{\cftfigfont}{\heiti\zihao{4}\linespread{1.0}} % 黑体四号单倍行距
\renewcommand{\cfttabfont}{\heiti\zihao{4}\linespread{1.0}} % 黑体四号单倍行距

% 修改列出目录命令 --------------------------------------------------------------
% 改\tableofcontents
\let\oldtableofcontents\tableofcontents
\renewcommand{\tableofcontents}{
    \ifUCAS@print\cleardoublepage\else\clearpage\fi
    \currentpdfbookmark{目录}{目录}
    \oldtableofcontents
    \markboth{\UCAS@header@cn}{} % 修改目录命令中设定的左页眉
}
% 四种材料的目录和为\listofmaterials命令
\define@key{listofmaterials}{table}[true]{\def\listTable{#1}}
\define@key{listofmaterials}{figure}[true]{\def\listFigure{#1}}
\define@key{listofmaterials}{code}[true]{\def\listCode{#1}}
\define@key{listofmaterials}{algorithm}[true]{\def\listAlgorithm{#1}}
\newcommand{\listofmaterials}[1][]{ % 图表目录, 列出图, 表, 代码, 算法
    % 处理选项
    \def\listTable{false}
    \def\listFigure{false}
    \def\listCode{false}
    \def\listAlgorithm{false}
    \setkeys{listofmaterials}{#1}

    \ifUCAS@print\cleardoublepage\else\clearpage\fi
    \ctexset{chapter/break={}} % 下面几个章节不另起一页
    \markboth{\UCAS@header@cn}{图表目录}
    \currentpdfbookmark{图表目录}{图表目录}
    \let\oldmarkboth\@mkboth
    \renewcommand{\@mkboth}[2]{}

    \ifthenelse{\equal{\listFigure}{true}}{\listoffigures}{}
    \ifthenelse{\equal{\listTable}{true}}{\listoftables}{}
    \ifthenelse{\equal{\listCode}{true}}{\listoflistings}{}
    \ifthenelse{\equal{\listAlgorithm}{true}}{\listofalgorithms}{}

    \ctexset{chapter/break=\if@openright\cleardoublepage\else\clearpage\fi}
    \let\@mkboth\oldmarkboth
    \global\let\listofmaterials\relax
}
% 改\printunsrtglossary
\newcommand{\listofnotaions}{
  \ifUCAS@print\cleardoublepage\else\clearpage\fi
  \printunsrtglossary[style = indexgroup, title = {术语表}]
  \markboth{\UCAS@header@cn}{}
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (六) 正文
% 标题 -------------------------------------------------------------------------
\ctexset{
    chapter = { % 章标题
      name={第,章},
      nameformat = {}, % 清除标题编号样式
      titleformat = {}, % 清除标题内容样式
      aftername = \quad, % 序号与题名之间空一个汉字符
      format= \heiti\zihao{4}\bfseries\centering\linespread{1.0}, % 黑体四号加粗居中单倍行距
      beforeskip = 24pt, % 段前距
      afterskip = 18pt, % 段后距
      fixskip = true, % 抑制段前段后距以外的多余垂直间距
      afterindent = true, % 标题后首段首行缩进
     },
    section = { % 二级标题
      nameformat = {},
      titleformat = {},
      aftername = \quad,
      format= \heiti\zihao{-4}\linespread{1.0},
      beforeskip = 24pt,
      afterskip = 6pt,
      fixskip = true,
      afterindent = true,
     },
    subsection = { % 三级标题
            nameformat = {},
            titleformat = {},
            aftername = \quad,
            format= \heiti\zihao{-4}\linespread{1.0},
            beforeskip = 12pt,
            afterskip = 6pt,
            fixskip = true,
            afterindent = true,
        },
    subsubsection = { % 四级标题
            nameformat = {},
            titleformat = {},
            aftername = \quad,
            format= \heiti\zihao{-4}\linespread{1.0},
            beforeskip = 12pt,
            afterskip = 6pt,
            fixskip = true,
            afterindent = true,
        },
    paragraph/afterindent = true,
    subparagraph/afterindent = true,
    appendix = {
            name = {附录},
            number = \chinese{chapter},
        },
}
% 文档默认样式即段落文字样式

\ctexset{secnumdepth=subsubsection} % 正文中对最多四级的标题编号, 更深的标题不编号

%列表 --------------------------------------------------------------------------
\RequirePackage{enumitem}
% TODO: 这俩有用吗
% \setlist[enumerate]{wide=\parindent}
% \setlist[itemize]{wide=\parindent}
\setlist{nosep} % 列表上下及列表项间无额外间距

% 图 ---------------------------------------------------------------------------
\RequirePackage{graphicx}
\graphicspath{{./figures}}
% \RequirePackage{subcaption} % TODO: 子图?

% 表 ---------------------------------------------------------------------------
% 行间距1.5倍 (得自word模板实现)
% TODO: 卧排表顶左底右, 即表顶朝左
\RequirePackage{tabularx}
\RequirePackage{booktabs}
% TODO: 表的样式, 封装图表命令

% 图/表序, 题, 注 ---------------------------------------------------------------
\RequirePackage[list=off]{bicaption} % 图表目录中仅显示第一语言的标题
\captionsetup{
    labelsep=quad, % 图/表序与图/表题文字之间空一个汉字符
    skip=0pt,
}
\DeclareCaptionFormat{cn}{\vspace{6pt}\songti\zihao{5}\bfseries\linespread{1.25}#1#2#3\par} % 中文图/表题样式: 宋体五号加粗1.25倍行距, 段前6pt段后0pt
\DeclareCaptionFormat{en}{\zihao{5}\bfseries\linespread{1.25}#1#2#3\vspace{12pt}\par} % 英文图/表题样式: Times New Roman五号加粗1.25倍行距, 段前6pt段后0pt
\captionsetup[bi-first]{format=cn}
\captionsetup[bi-second]{format=en}
\captionsetup[figure][bi-first]{
    name={图},
}
\captionsetup[table][bi-first]{
    name={表},
}
\renewcommand{\thefigure}{\thechapter-\arabic{figure}} % 图序号样式: 章节-序号
\renewcommand{\thetable}{\thechapter-\arabic{table}}
% 表达式 (公式) -----------------------------------------------------------------
\RequirePackage{amsmath}
\renewcommand{\theequation}{\thechapter-\arabic{equation}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (七) 其他

% 参考文献 ----------------------------------------------------------------------
\RequirePackage[
    backend = biber,
    backref = true,
    maxbibnames = 3,
    style = gb7714-2015, % chktex 8 % biblatex-gb7714-2015宏包提供的顺序编码制
    citestyle = gb7714-2015, % chktex 8
    gbnamefmt=lowercase, % 对于bib文件中的作者姓名的大小写不做改变
    gbpub=false % 放弃国标的要求, 不使用"出版地不详"等补充信息
]{biblatex} % TODO: 检查样式是否完全一样, 中英文好像要显示不一样
\addbibresource{bibs/References.bib}

% 附录 -------------------------------------------------------------------------
\let\oldappendix\appendix
\renewcommand{\appendix}{
    \oldappendix
    \fancyhead[CO]{\songti\zihao{-5}附\quad 录} % 附录部分页眉为"附录", 两字间空一个汉字符
}
% 致谢 -------------------------------------------------------------------------

% 算法环境 ---------------------------------------------------------------------
\RequirePackage[
    % chapter % 算法编号包含章节号
]{algorithm}
\RequirePackage{algorithmic}
\makeatletter
\renewcommand{\ALG@name}{算法}
\makeatother
\renewcommand{\listalgorithmname}{算法目录}

% 超链接, pdf元信息及pdf书签 ----------------------------------------------------
\RequirePackage[
    colorlinks = true,
    % linkcolor=blue,anchorcolor=violet,citecolor=magenta
    pdfstartview = FitH,
    % TODO: 这些参数要确认
    % pdfencoding=auto,% allows non-Latin based languages in bookmarks
    % psdextra=true,% extra support for math symbols in bookmarks
    bookmarks = true, % 创建pdf书签
    bookmarksopen = true, % 默认显示书签并展开所有级别
    bookmarksnumbered, % 书签名包含编号
    % bookmarksnumbered=true,% put section numbers in bookmarks
    % pdftitle={testtte},% title
    % pdfauthor={\@author},% author
    % pdfsubject={\@title},% subject
]{hyperref} % 为了不被其他宏包覆盖hyperref对LaTeX内部命令的修改, 尽可能将hyperref置于导言区最后

% 符号说明 (术语表) -----------------------------------------------------------------------
\RequirePackage[ % 需要放在hyperref后
    nogroupskip, % 不在每个分组前添加额外的垂直间距
    record, % 显示术语出现的页码
    toc=false, % 不添加到目录
]{glossaries-extra}
\GlsXtrLoadResources[
    src={bibs/symbols.bib},
    group={符号}, % set this as the group field
    category={symbol}, % set this as the category field
    sort={letter-case}, % sort according to character code
    symbol-sort-fallback={name},
    break-at={none}
]
\GlsXtrLoadResources[
    src={bibs/abbreviations.bib},
    group={缩写}
]

