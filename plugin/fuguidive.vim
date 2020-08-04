if exists('g:loaded_fuguidive')
	finish
endif
let g:loaded_fuguidive = 1

augroup fuguidive
	autocmd!
	autocmd Filetype fugitive call fuguidive#init()
	autocmd BufNew fugitive://* call fuguidive#init()
augroup END
