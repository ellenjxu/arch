syntax on
set number
set relativenumber
set hlsearch
set ruler
set tabstop=2
set shiftwidth=2
set autoindent
set expandtab
set mouse=a
set clipboard=unnamed
highlight Comment ctermfg=green

" compile c
nnoremap <silent> <F7> :w<cr>:make %< && ./%<<cr>

" plugins
call plug#begin()

Plug 'dylanaraps/wal.vim'
Plug 'lervag/vimtex'

call plug#end()

" vimtex
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_compiler_method = 'latexmk'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'

silent! colorscheme wal
