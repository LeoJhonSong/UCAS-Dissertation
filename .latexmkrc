$out_dir = 'build';
$pdf_mode = 5; # 用xelatex生成pdf
# -synctex=1 生成SyncTex文件
# -interaction=nonstopmode 遇到错误时不等待用户输入而尽可能继续编译
# -shell-escape 编译器调用外部程序
# -file-line-error 编译器报告错误时给出文件名和行号而不是页码
$xelatex = 'xelatex -synctex=1 -interaction=nonstopmode -shell-escape -file-line-error %O %S';
$postscript_mode = $dvi_mode = 0;

push @generated_exts, 'bbl', 'run.xml', 'glstex', 'glg';
$clean_ext .= ' %R.bbl run.xml glstex glg'; # .=是将值添加到原本字符串末尾

################################################################################
# Implementing glossary with bib2gls and glossaries-extra, with the
#  log file (.glg) analyzed to get dependence on a .bib file.
# !!! ONLY WORKS WITH VERSION 4.54 or higher of latexmk
# based on https://ctan.mirror.twds.com.tw/tex-archive/support/latexmk/example_rcfiles/bib2gls_latexmkrc
add_cus_dep('aux', 'glstex', 0, 'run_bib2gls');

sub run_bib2gls {
    my ($base, $path) = fileparse( $_[0] );
    my $silent_command = $silent ? "--silent" : "";
    if ( $path ) {
        my $ret = system("bib2gls $silent_command -d '$path' --group '$base'");
    } else {
        my $ret = system("bib2gls $silent_command --group '$_[0]'");
    };

    # Analyze log file.
    local *LOG;
    $LOG = "$_[0].glg";
    if (!$ret && -e $LOG) {
        open LOG, "<$LOG";
	while (<LOG>) {
            if (/^Reading (.*\.bib)\s$/) {
		rdb_ensure_file( $rule, $1 );
	    }
	}
	close LOG;
    }
    return $ret;
}