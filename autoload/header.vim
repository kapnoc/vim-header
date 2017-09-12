""
"" autoload/header.vim for vim-header
""
"" Made by Karl Toffel
""         <kapnoc@memeware.net>
""
"" Started on  Sat Aug 26 17:56:43 2017 Karl Toffel
"" Last update Tue Sep 12 16:34:43 2017 Tanguy Gerome
""

"	'filetype' {'s': 'comments_start', 'm': '_middle', 'e': '_end_chars'}
let s:comments = {
			\ 'asm': {'s': ';;;', 'm': ';;;', 'e': ';;;'},
			\ 'c': {'s': '/*', 'm': '**', 'e': '*/'},
			\ 'cpp': {'s': '/*', 'm': '**', 'e': '*/'},
			\ 'make': {'s': '##', 'm': '##', 'e': '##'},
			\ 'python': {'s': '##', 'm': '##', 'e': '##'},
			\ 'sh': {'s': '##', 'm': '##', 'e': '##'},
			\ 'dockerfile': {'s': '##', 'm': '##', 'e': '##'},
			\ 'tex': {'s': '%%', 'm': '%%', 'e': '%%'},
			\ 'vim': {'s': '""', 'm': '""', 'e': '""'}
			\ }



" Miscelaneous utils
function!	s:get_curr_time()
	return	strftime("%a %b %d %T %Y")
endfunction

function!	s:find_header()
	let	l:pos	= search(' Last update ', 'cnw')
	return	l:pos > 0 && l:pos < 10
endfunction


function!	s:set_vars()
	let	l:proj_name = system("head -n1 .project.vim | tr -d '\n'")
	let	l:header_type = system("grep 'header=' .project.vim"
				\."| tr -d '\n'")

	%s/\~FILENAME\~/\= expand('%:t')/ge
	%s/\~FILERELPATH\~/\= expand('%:h')/ge
	%s/\~PROJNAME\~/\= l:proj_name/ge
	%s/\~FILERELPATH\~/\= expand('%:t')/ge
	%s/\~MAIL\~/\= g:header_mail/ge
	%s/\~NAME\~/\= g:header_name/ge
	%s/\~TIME\~/\= s:get_curr_time()/ge
endfunction


" Insert new header
function!	header#insert()
	" Is there already a header ?
	" 	If so, do not add one
	if s:find_header() > 0
		return
	endif

	" Is filetype in s:comments' keys ?
	" 	If not, cannot continue
	if !has_key(s:comments, &filetype)
		echoerr "vim-header: Unsupported filetype: ".&filetype
		return
	endif

	" Get infos we need:
	" 	comments, project name, file name/path ...
	let l:comm_start	= s:comments[&filetype]['s']
	let l:comm_middle	= s:comments[&filetype]['m']
	let l:comm_end		= s:comments[&filetype]['e']
	let l:header_type = system("grep 'header=' .project.vim | tr -d '\n'")

	" Write the actual header
	if matchstr(l:header_type, 'kapnoc') != ""
		let l:ret = append(0, l:comm_start)
		let l:ret = append(1, l:comm_middle." ~FILERELPATH~/~FILENAME~"
					\." for ~PROJNAME~")
		let l:ret = append(2, l:comm_middle."")
		let l:ret = append(3, l:comm_middle." Made by ~NAME~")
		let l:ret = append(4, l:comm_middle."         <~MAIL~>")
		let l:ret = append(5, l:comm_middle."")
		let l:ret = append(6, l:comm_middle." Started on  ~TIME~ ~NAME~")
		let l:ret = append(7, l:comm_middle." Last update ~TIME~ ~NAME~")
		let l:ret = append(8, l:comm_end)
		let l:ret = append(9, "")
	elseif matchstr(l:header_type, 'custom') != ""
		let l:header_len = system("wc -l .header.vim")
		let l:header_pattern = system("cat .header.vim")
		let l:header = substitute(l:header_pattern, "\<NL>", '\n'.l:comm_middle, "g")

		let l:ret = append(0, l:comm_start)
		let l:ret = append(1, l:comm_middle . l:header)
		silent! exec "%s/\<CR>/\<CR>/g"
		silent! exec "%s/\<NL>/\<CR>/g"
		let l:ret = setline(l:header_len + 2, l:comm_end)
		let l:ret = append(l:header_len + 2, "")
	else
		let l:ret = append(0, l:comm_start)
		let l:ret = append(1, l:comm_middle . " ~PROJNAME~")
		let l:ret = append(2, l:comm_middle . "")
		let l:ret = append(3, l:comm_middle . " ~FILERELPATH~/~FILENAME~")
		let l:ret = append(4, l:comm_middle . "")
		let l:ret = append(5, l:comm_middle." Started on  ~TIME~ ~NAME~")
		let l:ret = append(6, l:comm_middle." Last update ~TIME~ ~NAME~")
		let l:ret = append(7, l:comm_end)
		let l:ret = append(8, "")
	endif

	call s:set_vars()

	" Move to end of header
	:11
endfunction



" Change 'Last update' time
function!	header#update()
	if !s:find_header()
		return
	endif

	" Is filetype in s:comments' keys ?
	" 	If not, cannot continue
	if !has_key(s:comments, &filetype)
		echoerr "vim-header: Unsupported filetype: " . &filetype
		return
	endif

	let curr_pos	= getpos(".")
	let curr_time	= s:get_curr_time()
	1,10s/\(.*\) Last update .*/\1 Last update µTIMEµ µNAMEµ/ge
	1,10s/µTIMEµ/\= s:get_curr_time()/ge
	1,10s/µNAMEµ/\= g:header_name/ge

	call setpos('.', curr_pos)
endfunction
