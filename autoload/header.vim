""
"" autoload/header.vim for vim-header
""
"" Made by Karl Toffel
"" Login   <kapnoc@memeware.net>
""
"" Started on  Sat Aug 26 17:56:43 2017 Karl Toffel
"" Last update Sun Aug 27 11:02:22 2017 Karl Toffel
""


"		'filetype' {'s': 'comments_start', 'm': '_middle', 'e': '_end_chars'}
let s:comments = {
			\ 'asm': {'s': ';;;', 'm': ';;;', 'e': ';;;'},
			\ 'c': {'s': '/*', 'm': '**', 'e': '*/'},
			\ 'cpp': {'s': '//', 'm': '//', 'e': '//'},
			\ 'make': {'s': '##', 'm': '##', 'e': '##'},
			\ 'python': {'s': '##', 'm': '##', 'e': '##'},
			\ 'sh': {'s': '##', 'm': '##', 'e': '##'},
			\ 'tex': {'s': '%%', 'm': '%%', 'e': '%%'},
			\ 'vim': {'s': '""', 'm': '""', 'e': '""'},
			\ }



" Miscelaneous utils
function!	s:get_curr_time()
	return	strftime("%a %b %d %T %Y")
endfunction

function!	s:find_header()
	let	l:pos	= search(' Last update ', 'cnw')
	return	l:pos > 0 && l:pos < 10
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
	let l:header_project_name = system("cat .project.vim | tr -d '\n'")
	let l:header_filename = expand('%:t')
	let l:header_filerelpath = expand("%:h")

	" Write the actual header
	let l:ret = append(0, l:comm_start)
	let l:ret = append(1, l:comm_middle . " ".l:header_filerelpath."/"
				\.l:header_filename." ".l:header_project_name)
	let l:ret = append(2, l:comm_middle . "")
	let l:ret = append(3, l:comm_middle . " Made by ".g:header_name)
	let l:ret = append(4, l:comm_middle . " Login   <".g:header_mail.">")
	let l:ret = append(5, l:comm_middle . "")
	let l:ret = append(6, l:comm_middle . " Started on  ".s:get_curr_time()
				\." by ".g:header_name)
	let l:ret = append(7, l:comm_middle . " Last update ".s:get_curr_time()
				\." by ".g:header_name)
	let l:ret = append(8, l:comm_end)
	let l:ret = append(9, "")

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
