if exists('g:autoloaded_fuguidive')
	finish
endif
let g:autoloaded_fuguidive = 1

let s:fuguidive_is_active = 0
let s:fuguidive_backup = {}

function! fuguidive#init() abort
	augroup fuguidive_buffer
		autocmd! * <buffer=abuf>
		autocmd BufEnter <buffer=abuf> call s:init()
		autocmd BufLeave <buffer=abuf> call s:deinit()
	augroup END
endfunction

function! s:init() abort
	if s:fuguidive_is_active | return | endif

	call s:set_key('<buffer>', s:fuguidive)
	for key in s:fuguidive_keys
		call s:set_key(key)
	endfor

	let s:fuguidive_is_active = 1

	if exists('s:fuguidive_is_setup') | return | endif

	nmap <silent> <buffer> <Plug>(fuguidive) :LeaderGuide '<buffer>'<CR>

	" TODO: Make configurable
	nmap <buffer> g? <Plug>(fuguidive)

	for key in s:fuguidive_keys
		execute 'nmap <silent> <buffer> '.key.' :LeaderGuide "'.key.'"<CR>'
	endfor

	let b:fuguidive_is_setup = 1
endfunction

function! s:deinit() abort
	if !s:fuguidive_is_active | return | endif

	for key in ['<buffer>'] + s:fuguidive_keys
		call s:restore_key(key)
	endfor

	let s:fuguidive_is_active = 0
	let s:fuguidive_backup = {}
endfunction

function! s:set_key(key, ...) abort
	if has_key(g:leaderGuide_map, a:key)
		let s:fuguidive_backup[a:key] = g:leaderGuide_map[a:key]
	endif
	let g:leaderGuide_map[a:key] = a:0 ? a:1 : s:fuguidive[a:key]
endfunction

function! s:restore_key(key) abort
	if has_key(s:fuguidive_backup, a:key)
		let g:leaderGuide_map[a:key] = s:fuguidive_backup[a:key]
	else
		unlet g:leaderGuide_map[a:key]
	endif
endfunction

" Define group names {{{1

let s:fuguidive_keys = [ '[', ']', 'c', 'd', 'g', 'r' ]

let s:fuguidive          = { 'name'  : 'Fugitive'              }

let s:fuguidive['[']     = { 'name': 'Jump backward'           }

let s:fuguidive[']']     = { 'name': 'Jump forward'            }
let s:fuguidive['<C-w>'] = { 'name': 'C-w'                     }
let s:fuguidive.c        = { 'name': 'Commit, Checkout, Stash' }
let s:fuguidive.c.b      = { 'name': 'Branch'                  }
let s:fuguidive.c.m      = { 'name': 'Merge'                   }
let s:fuguidive.c.o      = { 'name': 'Checkout'                }
let s:fuguidive.c.r      = { 'name': 'Revert'                  }
let s:fuguidive.c.R      = { 'name': 'Reset author'            }
let s:fuguidive.c.v      = { 'name': 'Verbose'                 }
let s:fuguidive.c.z      = { 'name': 'Stash'                   }
let s:fuguidive.d        = { 'name': 'Diff'                    }
let s:fuguidive.g        = { 'name': 'Navigation'              }
let s:fuguidive.r        = { 'name': 'Rebase'                  }

" }}}1

" vim:set fdm=marker:
