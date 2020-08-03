#!/usr/bin/env bash

fugitive_url='https://raw.githubusercontent.com/tpope/vim-fugitive/master/doc/fugitive.txt'
doc_name='fugitive.txt'
doc_path="doc_$doc_name"

wget "$fugitive_url"
rm "$doc_path"
mv "$doc_name" "$doc_path"

# git difftool "$doc_path"
