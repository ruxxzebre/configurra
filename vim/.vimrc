set nocompatible

call plug#begin()

Plug 'sheerun/vim-polyglot'
Plug 'dense-analysis/ale'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'unisonweb/unison', { 'branch': 'trunk', 'rtp': 'editor-support/vim' }

call plug#end()
let g:ale_fixers = ['prettier', 'eslint']
let g:ale_fix_on_save = 1

syntax on
set tabstop=2
set shiftwidth=2
set expandtab