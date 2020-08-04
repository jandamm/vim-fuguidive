if exists('g:autoloaded_fuguidive')
	finish
endif
let g:autoloaded_fuguidive = 1

let s:fuguidive_is_active = 0

function! fuguidive#init() abort
	augroup fuguidive_buffer
		autocmd! * <buffer=abuf>
		autocmd BufEnter <buffer=abuf> call s:init()
		autocmd BufLeave <buffer=abuf> call s:deinit()
	augroup END
endfunction

function! s:init() abort
	if s:fuguidive_is_active | return | endif

	" TODO: Store existing
	let g:leaderGuide_map['<buffer>'] = s:fuguidive
	let g:leaderGuide_map['['] = s:fuguidive__SBO
	let g:leaderGuide_map[']'] = s:fuguidive__SBC
	let g:leaderGuide_map['c'] = s:fuguidive_c
	let g:leaderGuide_map['d'] = s:fuguidive_d
	let g:leaderGuide_map['g'] = s:fuguidive_g
	let g:leaderGuide_map['r'] = s:fuguidive_r

	let s:fuguidive_is_active = 1

	if exists('s:fuguidive_is_setup') | return | endif

	nmap <buffer> <Plug>(fuguidive) :LeaderGuide '<buffer>'<CR>

	" TODO: Make configurable
	nmap <buffer> g? <Plug>(fuguidive)

	nmap <buffer> [ :LeaderGuide '['<CR>
	nmap <buffer> ] :LeaderGuide ']'<CR>
	nmap <buffer> c :LeaderGuide 'c'<CR>
	nmap <buffer> d :LeaderGuide 'd'<CR>
	nmap <buffer> g :LeaderGuide 'g'<CR>
	nmap <buffer> r :LeaderGuide 'r'<CR>

	let b:fuguidive_is_setup = 1
endfunction

function! s:deinit() abort
	if !s:fuguidive_is_active | return | endif

	" TODO: Restore existing
	unlet g:leaderGuide_map['<buffer>']
	unlet g:leaderGuide_map['[']
	unlet g:leaderGuide_map[']']
	unlet g:leaderGuide_map['c']
	unlet g:leaderGuide_map['d']
	unlet g:leaderGuide_map['g']
	unlet g:leaderGuide_map['r']

	let s:fuguidive_is_active = 0
endfunction

" Define group names {{{1

let s:fuguidive_keys = [ '[', ']', 'c', 'd', 'g', 'r' ]

let s:fuguidive__SBO = { 'name': 'Jump backward'           }
let s:fuguidive__SBC = { 'name': 'Jump forward'            }
let s:fuguidive__C_W = { 'name': 'C-W'                     }
let s:fuguidive_c    = { 'name': 'Commit, Checkout, Stash' }
let s:fuguidive_c.b  = { 'name': 'Branch'                  }
let s:fuguidive_c.m  = { 'name': 'Merge'                   }
let s:fuguidive_c.o  = { 'name': 'Checkout'                }
let s:fuguidive_c.r  = { 'name': 'Revert'                  }
let s:fuguidive_c.R  = { 'name': 'Reset author'            }
let s:fuguidive_c.v  = { 'name': 'Verbose'                 }
let s:fuguidive_c.z  = { 'name': 'Stash'                   }
let s:fuguidive_d    = { 'name': 'Diff'                    }
let s:fuguidive_g    = { 'name': 'Navigation'              }
let s:fuguidive_r    = { 'name': 'Rebase'                  }

let s:fuguidive = {
			\ 'name'  : 'Fugitive',
			\ '['     : s:fuguidive__SBO,
			\ ']'     : s:fuguidive__SBC,
			\ '<C-W>' : s:fuguidive__C_W,
			\ 'c'     : s:fuguidive_c,
			\ 'd'     : s:fuguidive_d,
			\ 'g'     : s:fuguidive_g,
			\ 'r'     : s:fuguidive_r,
			\ }

" }}}1

" vim:set fdm=marker:
