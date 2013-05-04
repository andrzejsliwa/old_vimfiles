" Must have {{{
command! -bar -nargs=* Rc e $MYVIMRC       " edit ~/.vimrc   (this file)
command! -bar -nargs=* Rl :source $MYVIMRC " reload ~/.vimrc (this file)
set backspace=indent,eol,start             " enable intuitive backspacing
" replace ; with : in normal and visual mode
nno ; :
nno : ;
vno ; :
vno : ;
" }}} Must have

" Prepare for loading plugins {{{
set nocompatible         " disable vi compatybile mode
filetype off
" }}} Prepare for loading plugins

" Handle first runtime {{{
let g:first_time=0
if !isdirectory(expand("~/.vim/bundle/vundle"))
  call mkdir(expand("~/.vim/bundle", "p"))
  silent exec "!git clone git://github.com/gmarik/vundle.git ~/.vim/bundle/vundle"
  let g:first_time=1
endif
" }}} Handle first runtime

" Configure vundle manager {{{
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
" basic help
"   :BundleList          - list configured bundles
"   :BundleInstall(!)    - install(update) bundles
"   :BundleSearch(!) foo - search(or refresh cache first) for foo
"   :BundleClean(!)      - confirm(or auto-approve) removal of unused
" }}} Configure vundle manager

" Bundles definitions {{{
Bundle 'gmarik/vundle'
Bundle 'Lokaltog/vim-powerline'
Bundle 'kien/ctrlp.vim'
Bundle 'mileszs/ack.vim'
Bundle 'vim-scripts/tComment'
Bundle 'davidoc/taskpaper.vim'
Bundle 'vlasar/snipmate'
Bundle 'terryma/vim-multiple-cursors'
Bundle 'sjl/gundo.vim'
Bundle 'scrooloose/nerdtree'
" }}} Bundles definitions

" Triger install when firstime {{{
if g:first_time
  silent exec ":BundleInstall"
endif
" }}} Triger install when firstime

" Renable syntax highlighting and file types detection {{{
syntax enable
filetype plugin indent on
" }}} Renable syntax highlighting and file types detection

" Look & feel {{{
set term=screen-256color " configure 256 colors
set t_Co=256             " same...
set background=dark      " choose dark version of background
colorscheme hemisu         " choose my favorite vim color scheme
" }}} Look & feel

" General {{{
" speedup
set ttyfast
set synmaxcol=800
" title
set title
set titlestring=%f%(\ [%M]%)
" encoding
set encoding=utf-8
set fileformats=unix
" hide buffers when not displayed
set hidden
set ttimeout
set ttimeoutlen=10
set notimeout
" enable status
set laststatus=2
" enable relative numbering
set relativenumber
" configure wrapping
set wrap
set formatoptions+=qrn1
set formatoptions-=o
" configure buffer splits
set splitright
set splitbelow
" display
set display=lastline
set more
" bells
set noerrorbells
set novisualbell
set visualbell t_vb=
set report=2
" scrolling
set scrolloff=3
set sidescrolloff=3
" tabs & indentation
set expandtab
set shiftwidth=2
set tabstop=2
" }}} General

" Backup & Swap {{{
set nobackup
set nowritebackup
set noswapfile
" }}} Backup & Swap

" Search {{{
set gdefault
set incsearch
set hlsearch
" }}} Search

" Strip trainling whitespaces {{{
function! <SID>StripTrailingWhitespaces()
  " Preparation: "ave last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  %s/\s\+$//e
  " Clean up:
  " restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
" }}} Strip trainling whitespaces

" Line number toggle {{{
function! LineNumberToggle()
  if(&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunc
" }}} Line number toggle

" Plugins configs {{{

" Ack {{{
" you need to install https://github.com/ggreer/the_silver_searcher
let g:ackprg = 'ag --nogroup --nocolor --column'
" }}} Ack

" CtrlP {{{
let g:ctrlp_cmd = 'CtrlPBuffer'
let g:ctrlp_cache_dir = $HOME.'/.vim/tmp/.cache/ctrlp'
let g:ctrlp_reuse_window = 1
" }}} CtrlP

" Power line {{{
let g:Powerline_symbols = 'fancy'
" }}} Power line

" Ignores {{{
set wildmenu
set wildmode=list:full
set wildignore+=*.aux,*.out,*.toc
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg
set wildignore+=.git,ebin,*.o,*.DS_Store,*.beam
" }}} Ignores

" }}} Plugins configs

" Custom functions {{{
" Todos {{{
function! s:OpenTodo(toFull)
  if (a:toFull == 1)
    sp | e ~/Dropbox/todo.taskpaper
  else
    e ~/Dropbox/todo.taskpaper
  endif
endfunction
" }}}

" EditSnippet() {{{
function! EditMySnippets()
  execute ":e ~/.vim/snippets/" . &ft . ".snippets"
endfunction

function! ReloadMySnippets()
  execute "silent :w"
  execute "silent :bd"
  execute "silent :call ReloadAllSnippets()"
endfunction
" }}}

" }}} Custom functions

" Commands defs {{{
command! -bar -nargs=* Todo call s:OpenTodo(1)
command! -bar -nargs=* Todof call s:OpenTodo(2)
command! -bar -nargs=* EditMySnippets call s:EditMySnippets()
command! -bar -nargs=* ReloadMySnippets call s:ReloadMySnippets()
command! -bar -nargs=* LineNumberToggle call LineNumberToggle()
" }}} Commands defs

" Auto commands {{{
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
" }}} Auto commands

" Bindings {{{
" search via ack
nno <leader>a :Ack<space>
" search current word
nno <leader>A :Ack <cword><cr>
" search with ignores
nno <leader>a+ :Ack --noignore-dir=
" search via file or buffer
nno <leader>m :CtrlPMixed<cr>
" search file
nno <leader>t :CtrlP<cr>
" search buffer
nno <leader>b :CtrlPBuffer<cr>
" split vertical
nno <leader>v <C-W>v
" split horizontal
nno <leader>h <C-W>s
" switch to previous buffer
nno <leader><leader> <c-^>
" close current pane
nno <leader>x <C-W>c
" close buffer
nno <leader>X :bd<CR>
" copy to system clipboard
vno <leader>y :Pbyank<cr>
" paste from system clipboard
nno <leader>p :Pbpaste<cr>
" reset search
nno <silent> <Leader>/ :nohlsearch<cr>
" reload snippets for current filetype
nno <leader>sr :ReloadMySnippets<cr>
" edit snippets for current filetype
nno <leader>se :EditMySnippets<cr>
" open nerd tree
nno <leader>o :NERDTreeToggle<cr>
" cycle windows
nno <tab> <c-w>
nno <tab><tab> <c-w><c-w>
" }}} Bindings

