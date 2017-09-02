""
"" after/ftplugin/c.vim for vim-header
""
"" Made by Karl Toffel
""         <kapnoc@memeware.net>
""
"" Started on  Tue Aug 29 08:25:25 2017 Karl Toffel
"" Last update Sat Sep 02 22:07:06 2017 Karl Toffel
""

let s:proj_indent = system("grep 'indent=' .project.vim | tr -d '\n'")

filetype plugin indent on

setlocal cindent
if matchstr(s:proj_indent, 'epi') != ""
	setlocal comments=s:/*,m:**,ex:*/
else
	setlocal comments=s:/*,m:*,ex:*/
endif
setlocal noexpandtab
if matchstr(s:proj_indent, 'gnu') != ""
	setlocal shiftwidth=2
else
	setlocal shiftwidth=8
endif
setlocal softtabstop=8
setlocal tabstop=8

if matchstr(s:proj_indent, 'gnu') != ""
	setlocal cinoptions={1s,>2s,e-1s,^-1s,n-1s,:1s,p5,i4,(0,u0,W1s
else
	setlocal cinoptions=(0
endif

let c_space_errors = 0
