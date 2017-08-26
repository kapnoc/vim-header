""
"" autoload/header.vim for vim-header
""
"" Made by Karl Toffel
"" Login   <kapnoc@memeware.net>
""
"" Started on  Sat Aug 26 17:56:43 2017 Karl Toffel
"" Last update Sat Aug 26 18:43:28 2017 Karl Toffel
""


"			'filetype' {'comments_start', '_middle', '_end_chars'}
let s:comments = {
			\ 'asm': {'b': ';;;', 'm': ';;;', 'e': ';;;'},
			\ 'c': {'b': '/*', 'm': '**', 'e': '*/'},
			\ 'cpp': {'b': '//', 'm': '//', 'e': '//'},
			\ 'make': {'b': '##', 'm': '##', 'e': '##'},
			\ 'python': {'b': '##', 'm': '##', 'e': '##'},
			\ 'sh': {'b': '##', 'm': '##', 'e': '##'},
			\ 'tex': {'b': '%%', 'm': '%%', 'e': '%%'},
			\ 'vim': {'b': '""', 'm': '""', 'e': '""'},
			\ }


function!	s:get_curr_time()
	return	strftime("%a %b %d %T %Y")
endfunction

function!	s:find_header()
	let	l:pos	= search(' Last update ', 'cnw')
	return	l:pos > 0 && l:pos < 10
endfunction

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

	let l:comm_start	= s:comments[&filetype]['b']
	let l:comm_middle	= s:comments[&filetype]['m']
	let l:comm_end		= s:comments[&filetype]['e']
	let l:header_project_name = system("cat .project.vim | tr -d '\n'")
	let l:header_filename = expand('%:t')
	let l:header_filerelpath = expand("%:h")

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

	:11
endfunction

function!	header#update()
	" Is filetype in s:comments' keys ?
	" 	If not, cannot continue
	if !has_key(s:comments, &filetype)
		echoerr "vim-header: Unsupported filetype: ".&filetype
		return
	endif

	if s:find_header() > 0
		let curr_pos	= getpos(".")
		let curr_time	= s:get_curr_time()

		call setpos('.', curr_pos)
	endif
endfunction
