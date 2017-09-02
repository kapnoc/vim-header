""
"" plugin/header.vim for vim-header
""
"" Made by Karl Toffel
""         <kapnoc@memeware.net>
""
"" Started on  Sat Aug 26 18:11:51 2017 Karl Toffel
"" Last update Sat Sep 02 22:05:46 2017 Karl Toffel
""

if !exists('g:header_mail')
	let g:header_mail = expand($USER).'@'.expand($HOSTNAME)
endif

if !exists('g:header_name')
	let name = system('getent passwd $USER | cut -d: -f5')
	let g:header_name = substitute(name, '\n$', '', '')
endif

command! InsertHeader call header#insert()

autocmd FileWritePre,BufWritePre * call header#update()

nmap <Leader>h :InsertHeader<CR>
