""
"" after/ftplugin/c.vim for vim-header
""
"" Made by Karl Toffel
""         <kapnoc@memeware.net>
""
"" Started on  Tue Aug 29 08:25:25 2017 Karl Toffel
"" Last update Sun May 27 22:35:57 2018 Tanguy Gérôme
""

let s:proj_indent = system("grep 'indent=' .project.vim | tr -d '\n'")

if matchstr(s:proj_indent, 'epi') != ""
	setlocal comments=s:/*,m:**,ex:*/
else
	setlocal comments=s:/*,m:*,ex:*/
endif
