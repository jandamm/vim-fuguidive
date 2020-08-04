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
	let g:leaderGuide_map['['] = s:fuguidive['[']
	let g:leaderGuide_map[']'] = s:fuguidive[']']
	let g:leaderGuide_map['c'] = s:fuguidive['c']
	let g:leaderGuide_map['d'] = s:fuguidive['d']
	let g:leaderGuide_map['g'] = s:fuguidive['g']
	let g:leaderGuide_map['r'] = s:fuguidive['r']

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
