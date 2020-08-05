if exists('g:autoloaded_fuguidive')
	finish
endif
let g:autoloaded_fuguidive = 1

if !exists('s:fuguidive_is_active')
	let s:fuguidive_is_active = 0
	let s:fuguidive_backup = {}
endif

if !exists('g:fuguidive_map_interactive')
	let g:fuguidive_map_interactive = 1
endif

function! fuguidive#init() abort
	augroup fuguidive_buffer
		autocmd! * <buffer=abuf>
		autocmd BufEnter <buffer=abuf> call s:init()
		autocmd BufLeave <buffer=abuf> call s:deinit()
	augroup END
endfunction

function! s:init() abort
	if s:fuguidive_is_active | return | endif

	call s:set_map('<buffer>', s:fuguidive)
	for key in s:fuguidive_keys
		call s:set_map(key)
	endfor

	let s:fuguidive_is_active = 1

	if exists('s:fuguidive_is_setup') | return | endif

	nmap <silent> <buffer> <Plug>(fuguidive) :LeaderGuide '<buffer>'<CR>

	if exists('g:fuguidive_map') && !empty('g:fuguidive_map')
		execute 'nmap <buffer> '.g:fuguidive_map.' <Plug>(fuguidive)'
	endif

	if g:fuguidive_map_interactive
		for key in s:fuguidive_keys + s:fuguidive_subkeys
			execute 'nmap <silent> <buffer> '.key.' :LeaderGuide "'.key.'"<CR>'
		endfor
		nnoremap <silent> <buffer> gg gg
	endif

	let b:fuguidive_is_setup = 1
endfunction

function! s:deinit() abort
	if !s:fuguidive_is_active | return | endif

	for key in ['<buffer>'] + s:fuguidive_keys
		call s:restore_map(key)
	endfor

	let s:fuguidive_is_active = 0
	let s:fuguidive_backup = {}
endfunction

function! s:set_map(key, ...) abort
	if has_key(g:leaderGuide_map, a:key)
		let s:fuguidive_backup[a:key] = g:leaderGuide_map[a:key]
	endif
	let g:leaderGuide_map[a:key] = a:0 ? a:1 : s:fuguidive[a:key]
endfunction

function! s:restore_map(key) abort
	if has_key(s:fuguidive_backup, a:key)
		let g:leaderGuide_map[a:key] = s:fuguidive_backup[a:key]
	else
		unlet g:leaderGuide_map[a:key]
	endif
endfunction

" Define groups and names {{{1

let s:fuguidive = { 'name': 'Fugitive' }
let s:fuguidive_keys = []
let s:fuguidive_subkeys = []

" Define key helper {{{2
function! s:define_key(key, name) abort
	let s:fuguidive[a:key] = { 'name': a:name }
	call add(s:fuguidive_keys, a:key)
endfunction
function! s:define_subkey(base, key, name) abort
	let s:fuguidive[a:base][a:key] = { 'name': a:name }
	call add(s:fuguidive_subkeys, a:base.a:key)
endfunction
" }}}2

" Add name but ignore from any mappings
let s:fuguidive['<C-W>'] = { 'name': 'C-w' }

call s:define_key('[', 'Jump backward')
call s:define_key(']', 'Jump forward')
call s:define_key('c', 'Commit, Checkout, Stash')
call s:define_key('d', 'Diff')
call s:define_key('g', 'Navigation')
call s:define_key('r', 'Rebase')

call s:define_subkey('c', 'b', 'Branch')
call s:define_subkey('c', 'm', 'Merge')
call s:define_subkey('c', 'o', 'Checkout')
call s:define_subkey('c', 'r', 'Revert')
call s:define_subkey('c', 'R', 'Reset author')
call s:define_subkey('c', 'v', 'Verbose')
call s:define_subkey('c', 'z', 'Stash')

" }}}1

" vim:set fdm=marker:
