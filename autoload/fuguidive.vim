scriptencoding utf-8
if exists('g:autoloaded_fuguidive')
	finish
endif
let g:autoloaded_fuguidive = 1

if !exists('s:fuguidive_is_active')
	let s:fuguidive_is_active = 0
	let s:fuguidive_backup = {}
endif

if !exists('g:fuguidive_map_interactive')
	let g:fuguidive_map_interactive = 0
endif
if exists('g:fuguidive_map_help')
	let g:fuguidive_map_help = ''
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

	if exists('b:fuguidive_is_setup') | return | endif

	nmap <silent> <buffer> <Plug>(fuguidive) :LeaderGuide '<buffer>'<CR>

	if exists('g:fuguidive_map_help') && !empty('g:fuguidive_map_help')
		execute 'nmap <buffer> '.g:fuguidive_map_help.' <Plug>(fuguidive)'
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

" Key definition {{{1

" convert single key:
" >  Ilet s:fuguidive['f i'] = 'lvwh"_xA'

" convert double key:
" >  Ilet s:fuguidive['la']['f i'] = 'lvwh"_xA'

" convert triple key:
" >  Ilet s:fuguidive['la']['la']['f i'] = 'lvwh"_xA'

" Staging/unstaging maps {{{2
let s:fuguidive['s']      = 'Stage (add) the file or hunk under the cursor.'
let s:fuguidive['u']      = 'Unstage (reset) the file or hunk under the cursor.'
let s:fuguidive['-']      = 'Stage or unstage the file or hunk under the cursor.'
let s:fuguidive['U']      = 'Unstage everything.'
let s:fuguidive['X']      = 'Discard the change under the cursor.  This uses'
let s:fuguidive['=']      = 'Toggle an inline diff of the file under the cursor.'
let s:fuguidive['>']      = 'Insert an inline diff of the file under the cursor.'
let s:fuguidive['<']      = 'Remove the inline diff of the file under the cursor.'
let s:fuguidive['g']['I'] = 'Open .git/info/exclude in a split and add the file'
let s:fuguidive['I']      = 'Invoke |:Git| add --patch or reset --patch on the file'
let s:fuguidive['P']      = 'under the cursor. On untracked files, this instead'
" }}}2

" Diff maps {{{2
let s:fuguidive['d']['p'] = 'Invoke |:Git| diff on the file under the cursor.'
let s:fuguidive['d']['d'] = 'Perform a |:Gdiffsplit| on the file under the cursor.'
let s:fuguidive['d']['v'] = 'Perform a |:Gvdiffsplit| on the file under the cursor.'
let s:fuguidive['d']['s'] = 'Perform a |:Ghdiffsplit| on the file under the cursor.'
let s:fuguidive['d']['h'] = 'Perform a |:Ghdiffsplit| on the file under the cursor.'
let s:fuguidive['d']['q'] = 'Close all but one diff buffer, and |:diffoff|! the'
let s:fuguidive['d']['?'] = 'Show this help.'
" }}}2

" Navigation maps {{{2
let s:fuguidive['<CR>']   = 'Open the file or |fugitive-object| under the cursor.'
let s:fuguidive['o']      = 'Open the file or |fugitive-object| under the cursor in a new split.'
let s:fuguidive['g']['O'] = 'Open the file or |fugitive-object| under the cursor in a new vertical split.'
let s:fuguidive['O']      = 'Open the file or |fugitive-object| under the cursor in a new tab.'
let s:fuguidive['p']      = 'Open the file or |fugitive-object| under the cursor in a preview window.'
let s:fuguidive['~']      = 'Open the current file in the [count]th first ancestor.'
let s:fuguidive['P']      = 'Open the current file in the [count]th parent.'
let s:fuguidive['C']      = 'Open the commit containing the current file.'
let s:fuguidive['(']      = 'Jump to the previous file, hunk, or revision.'
let s:fuguidive[')']      = 'Jump to the next file, hunk, or revision.'
let s:fuguidive['[']['c'] = 'Jump to previous hunk, expanding inline diffs'
let s:fuguidive[']']['c'] = 'Jump to next hunk, expanding inline diffs'
let s:fuguidive['[']['/'] = 'Jump to previous file, collapsing inline diffs'
let s:fuguidive['[']['m'] = 'automatically.  (Mnemonic: "/" appears in filenames,'
let s:fuguidive[']']['/'] = 'Jump to next file, collapsing inline diffs'
let s:fuguidive[']']['m'] = 'automatically.  (Mnemonic: "/" appears in filenames,'
let s:fuguidive['i']      = 'Jump to the next file or hunk, expanding inline diffs'
let s:fuguidive['[']['['] = 'Jump [count] sections backward.'
let s:fuguidive[']'][']'] = 'Jump [count] sections forward.'
let s:fuguidive['['][']'] = 'Jump [count] section ends backward.'
let s:fuguidive[']']['['] = 'Jump [count] section ends forward.'
let s:fuguidive['*']      = 'On the first column of a + or - diff line, search for'
let s:fuguidive['#']      = 'Same as "*", but search backward.'
let s:fuguidive['g']['u'] = 'Jump to file [count] in the "Untracked" or "Unstaged"'
let s:fuguidive['g']['U'] = 'Jump to file [count] in the "Unstaged" section.'
let s:fuguidive['g']['s'] = 'Jump to file [count] in the "Staged" section.'
let s:fuguidive['g']['p'] = 'Jump to file [count] in the "Unpushed" section.'
let s:fuguidive['g']['P'] = 'Jump to file [count] in the "Unpulled" section.'
let s:fuguidive['g']['r'] = 'Jump to file [count] in the "Rebasing" section.'
let s:fuguidive['g']['i'] = 'Open .git/info/exclude in a split.  Use a count to'
" }}}2

" Commit maps {{{2
let s:fuguidive['c']['c']            = 'Create a commit.'
let s:fuguidive['c']['a']            = 'Amend the last commit and edit the message.'
let s:fuguidive['c']['e']            = 'Amend the last commit without editing the message.'
let s:fuguidive['c']['w']            = 'Reword the last commit.'
let s:fuguidive['c']['v']['c']       = 'Create a commit with -v.'
let s:fuguidive['c']['v']['a']       = 'Amend the last commit with -v'
let s:fuguidive['c']['f']            = 'Create a `fixup!` commit for the commit under the'
let s:fuguidive['c']['F']            = 'Create a `fixup!` commit for the commit under the'
let s:fuguidive['c']['s']            = 'Create a `squash!` commit for the commit under the'
let s:fuguidive['c']['S']            = 'Create a `squash!` commit for the commit under the'
let s:fuguidive['c']['A']            = 'Create a `squash!` commit for the commit under the'
let s:fuguidive['c'][' ']      = 'Populate command line with ":Git commit ".'
let s:fuguidive['c']['r']['c']       = 'Revert the commit under the cursor.'
let s:fuguidive['c']['r']['n']       = 'Revert the commit under the cursor in the index and'
let s:fuguidive['c']['r'][' '] = 'Populate command line with ":Git revert ".'
let s:fuguidive['c']['m'][' '] = 'Populate command line with ":Git merge ".'
let s:fuguidive['c']['?']            = 'Show this help.'
" }}}2

" Checkout/branch maps {{{2
let s:fuguidive['c']['o']['o']       = 'Check out the commit under the cursor.'
let s:fuguidive['c']['b'][' '] = 'Populate command line with ":Git branch ".'
let s:fuguidive['c']['o'][' '] = 'Populate command line with ":Git checkout ".'
let s:fuguidive['c']['b']['?']       = 'Show this help.'
let s:fuguidive['c']['o']['?']       = 'Show this help.'
" }}}2

" Stash maps {{{2
let s:fuguidive['c']['z']['z']       = 'Push stash.  Pass a [count] of 1 to add'
let s:fuguidive['c']['z']['w']       = 'Push stash of worktree.  Like `czz` with'
let s:fuguidive['c']['z']['A']       = 'Apply topmost stash, or stash@{count}.'
let s:fuguidive['c']['z']['a']       = 'Apply topmost stash, or stash@{count}, preserving the'
let s:fuguidive['c']['z']['P']       = 'Pop topmost stash, or stash@{count}.'
let s:fuguidive['c']['z']['p']       = 'Pop topmost stash, or stash@{count}, preserving the'
let s:fuguidive['c']['z'][' '] = 'Populate command line with ":Git stash ".'
let s:fuguidive['c']['z']['?']       = 'Show this help.'
" }}}2

" Rebase maps {{{2
let s:fuguidive['r']['i']       = 'Perform an interactive rebase.  Uses ancestor of'
let s:fuguidive['u']            = 'commit under cursor as upstream if available.'
let s:fuguidive['r']['f']       = 'Perform an autosquash rebase without editing the todo'
let s:fuguidive['r']['u']       = 'Perform an interactive rebase against @{upstream}.'
let s:fuguidive['r']['p']       = 'Perform an interactive rebase against @{push}.'
let s:fuguidive['r']['r']       = 'Continue the current rebase.'
let s:fuguidive['r']['s']       = 'Skip the current commit and continue the current'
let s:fuguidive['r']['a']       = 'Abort the current rebase.'
let s:fuguidive['r']['e']       = 'Edit the current rebase todo list.'
let s:fuguidive['r']['w']       = 'Perform an interactive rebase with the commit under'
let s:fuguidive['r']['m']       = 'Perform an interactive rebase with the commit under'
let s:fuguidive['r']['d']       = 'Perform an interactive rebase with the commit under'
let s:fuguidive['r'][' '] = 'Populate command line with ":Git rebase ".'
let s:fuguidive['r']['?']       = 'Show this help.'
" }}}2

" Miscellaneous maps {{{2
let s:fuguidive['g']['q'] = 'Close the status buffer.'
let s:fuguidive['.']      = 'Start a |:| command line with the file under the'
let s:fuguidive['g']['?'] = 'Show help for |fugitive-maps|.'
" }}}2

" Deprecated {{{2
let s:fuguidive['D'] = 'Use dd.'
let s:fuguidive['S'] = 'Use gO.'
let s:fuguidive['q'] = 'Use gq.'
let s:fuguidive['g']['|'] = 'Use X.'
let s:fuguidive['c']['p'] = 'Create a commit.'
" }}}2

" Undocumented {{{2
let s:fuguidive['a']      = 'Stage or unstage the file or hunk under the cursor.'
let s:fuguidive['J'] = 'Jump to next hunk.'
let s:fuguidive['K'] = 'Jump to previous hunk.'
let s:fuguidive['R']      = 'Use :e to force reload.'

let s:fuguidive['g']['f']      = 'Open file under cursor.'
"let s:fuguidive['g']['c']      = 'Open file under cursor.'
"let s:fuguidive['g']['C']      = 'Open file under cursor.'

let s:fuguidive['c']['m']['t'] = 'Open mergetool.'
let s:fuguidive['c']['m']['?'] = 'Show help.'
let s:fuguidive['c']['R']['a'] = 'Amend and reset author.'
let s:fuguidive['c']['R']['e'] = 'Amend whithout editing and reset author.'
let s:fuguidive['c']['R']['w'] = 'Reword commit and reset author.'
let s:fuguidive['c']['r']['?'] = 'Show help.'

let s:fuguidive['r']['k']       = s:fuguidive.r.d
let s:fuguidive['r']['x']       = s:fuguidive.r.d

let s:fuguidive['<C-N>'] = 'Jump to next item.'
let s:fuguidive['<C-P>'] = 'Jump to previous item.'
let s:fuguidive['<F1>'] = 'Mapping help.'

let s:fuguidive['<2-LeftMouse>']   = 'Open the file or |fugitive-object| under the cursor.'
" }}}2

" Global maps {{{2
" <C-R><C-G>              On the command line, recall the path to the current
" ["x]y<C-G>              Yank the path to the current |fugitive-object|.
" }}}2

" }}}1

" vim:set fdm=marker:
