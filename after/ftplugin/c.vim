""
"" after/ftplugin/c.vim for vim-header
""
"" Made by Karl Toffel
""         <kapnoc@memeware.net>
""
"" Started on  Tue Aug 29 08:25:25 2017 Karl Toffel
"" Last update Wed Jan 10 09:33:32 2018 Tanguy Gérôme
""

let s:proj_indent = system("grep 'indent=' .project.vim | tr -d '\n'")

filetype plugin indent on

if matchstr(s:proj_indent, 'epi') != ""
	setlocal comments=s:/*,m:**,ex:*/
else
	setlocal comments=s:/*,m:*,ex:*/
endif

if matchstr(s:proj_indent, 'gnu') != ""
	setlocal shiftwidth=2
else
	setlocal shiftwidth=8
endif

if matchstr(s:proj_indent, 'gnu') != ""
	setlocal cinoptions={1s,>2s,e-1s,^-1s,n-1s,:1s,p5,i4,(0,u0,W1s
else
	setlocal cinoptions=(0
endif
