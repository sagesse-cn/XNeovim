" Vim plugin for Xcode.
" Maintainer: SAGESSE <gdmmyzc@163.com>
" Last Change: 2017 Oct 04

" Exit quickly when:
" - this plugin was already loaded
" - when 'compatible' is set
if exists("loaded_xnvim")
  finish
endif
let loaded_xnvim = 1

" In xcode swapfile does not support
set noswapfile

" In xcode tableline does not support
set showtabline=0

" In xcode cannot be written to the file directly
autocmd BufWriteCmd * echom "Can't written"
