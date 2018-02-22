""
"" after/ftplugin/c.vim for vim-header
""
"" Made by Karl Toffel
""         <kapnoc@memeware.net>
""
"" Started on  Tue Aug 29 08:25:25 2017 Karl Toffel
"" Last update Thu Feb 22 14:36:06 2018 Tanguy Gérôme
""

let s:proj_indent = system("grep 'indent=' .project.vim | tr -d '\n'")

setlocal comments=s:/*,m:**,ex:*/
