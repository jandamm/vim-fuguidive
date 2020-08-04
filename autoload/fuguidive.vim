if exists('g:autoloaded_fuguidive')
	finish
endif
let g:autoloaded_fuguidive = 1

function! fuguidive#init() abort
	augroup fuguidive_buffer
		autocmd! * <buffer=abuf>
		autocmd BufEnter <buffer=abuf> call s:init()
		autocmd BufLeave <buffer=abuf> call s:deinit()
	augroup END
endfunction

function! s:init() abort
	echo 'in fugitive'
endfunction

function! s:deinit() abort
	echo 'not in fugitive'
endfunction
endfunction

" vim:set fdm=marker:
