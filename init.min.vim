" nvim -u NONE -s init.min.vim

syntax on

execute printf('set packpath^=%s', expand('~/.config/nvim/pack'))
packadd vim-fugitive
packadd vim-fuguidive
packadd vim-leader-guide

let g:fuguidive_map_help = '<Space>'

Gstatus
only
