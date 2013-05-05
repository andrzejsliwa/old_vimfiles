" Must have {{{
" prepare path for check
let g:vim_server_path=expand("~/.vim-andrzej")
" prepare base path for rest of configs
if isdirectory(vim_server_path)
  let $CONFIG_ROOT=g:vim_server_path
  let $MYVIMRC=g:vim_server_path . "/vimrc"
else
  let $CONFIG_ROOT=expand("~/.vim")
endif

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
if !isdirectory($CONFIG_ROOT . "/bundle/vundle")
  call mkdir($CONFIG_ROOT . "/bundle", "p")
  silent exec "!git clone git://github.com/gmarik/vundle.git " . $CONFIG_ROOT . "/bundle/vundle"
  let g:first_time=1
endif
" }}} Handle first runtime

" Configure vundle manager {{{
set rtp+=$CONFIG_ROOT/bundle/vundle/
call vundle#rc($CONFIG_ROOT . "/bundle")
" basic help
"   :BundleList          - list configured bundles
"   :BundleInstall(!)    - install(update) bundles
"   :BundleSearch(!) foo - search(or refresh cache first) for foo
"   :BundleClean(!)      - confirm(or auto-approve) removal of unused
" }}} Configure vundle manager

" Bundles definitions {{{
" plugins manager
Bundle 'gmarik/vundle'
" my favorite and customized color scheme
Bundle 'andrzejsliwa/vim-hemisu'
" library of usefull functions and and viml development helpers
Bundle 'vim-scripts/L9'
" nice status line
Bundle 'Lokaltog/vim-powerline'
" fuzzy finder for files and buffers
Bundle 'kien/ctrlp.vim'
" search via ack
Bundle 'mileszs/ack.vim'
" easy commenting
Bundle 'vim-scripts/tComment'
" task paper - todos
Bundle 'davidoc/taskpaper.vim'
" snippets support in textmate syntax
Bundle 'vlasar/snipmate'
" changing in multiple places in same time
Bundle 'terryma/vim-multiple-cursors'
" undo tree
Bundle 'sjl/gundo.vim'
" project drawer
Bundle 'scrooloose/nerdtree'
" tmux integration
Bundle 'benmills/vimux'
" running tests via vimux and tmux
Bundle 'jgdavey/vim-turbux'
" native clipboard
Bundle 'troydm/pb.vim'
" git integration
Bundle 'tpope/vim-fugitive'
" rebar integration
Bundle 'mbbx6spp/vim-rebar'
" erlang integration - customised indentation
Bundle 'andrzejsliwa/vimerl'
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
colorscheme hemisu       " choose my favorite vim color scheme
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

" Folding {{{
" don't fold by default
set nofoldenable
" }}}

" Plugins configs {{{

" Ack {{{
" you need to install https://github.com/ggreer/the_silver_searcher
let g:ackprg = 'ag --nogroup --nocolor --column'
" }}} Ack

" CtrlP {{{
let g:ctrlp_cmd = 'CtrlPBuffer'
let g:ctrlp_cache_dir = $CONFIG_ROOT . '/tmp/.cache/ctrlp'
let g:ctrlp_reuse_window = 1
" }}} CtrlP

" Power line {{{
let g:Powerline_symbols = 'fancy'
" }}} Power line

" snipmate {{{
let snippets_dir = $CONFIG_ROOT . "/snippets"
" }}}

" Ignores {{{
set wildmenu
set wildmode=list:full
set wildignore+=*.aux,*.out,*.toc
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg
set wildignore+=.git,ebin,*.o,*.DS_Store,*.beam
" }}} Ignores

" }}} Plugins configs

" Custom functions {{{

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

" Todos {{{
function! s:OpenTodo(toFull)
  if (a:toFull == 1)
    sp | e ~/Dropbox/todo.taskpaper
  else
    e ~/Dropbox/todo.taskpaper
  endif
endfunction
" }}} Todos

" open cheat sheet {{{
function! CheatSheet()
  sp | e $CONFIG_ROOT/cheatsheet
endfunction
" }}} open cheat sheet

" Edit snippet {{{
function! EditMySnippets()
  execute "sp | e " . $CONFIG_ROOT . "/snippets/" . &ft . ".snippets"
endfunction

function! ReloadMySnippets()
  execute "silent :w"
  execute "silent :bd"
  execute "silent :call ReloadAllSnippets()"
endfunction
" }}} Edit snippet

" }}} Custom functions

" Commands defs {{{
command! -bar -nargs=* Todo call s:OpenTodo(1)
command! -bar -nargs=* Todof call s:OpenTodo(2)
command! -bar -nargs=* Cheat call CheatSheet()
command! -bar -nargs=* EditMySnippets call EditMySnippets()
command! -bar -nargs=* ReloadMySnippets call ReloadMySnippets()
command! -bar -nargs=* LineNumberToggle call LineNumberToggle()
" }}} Commands defs

" Auto commands {{{
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
augroup FileTypes
  autocmd!
  autocmd FileType snippet setlocal shiftwidth=4 tabstop=4
  autocmd FileType erlang  setlocal shiftwidth=4 tabstop=4
  autocmd FileType make    setlocal noexpandtab shiftwidth=4 tabstop=4
  autocmd FileType snippet setlocal expandtab shiftwidth=4 tabstop=4
  autocmd BufNewFile,BufRead *.app.src set filetype=erlang
  autocmd BufNewFile,BufRead *.config  set filetype=erlang
augroup END

augroup Other
  autocmd!
  autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
augroup END
" }}} Auto commands

" Bindings {{{
" switch relative/normal numbering
nno <leader>n :LineNumberToggle<cr>
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
" cycle & switch window
nno <tab> <c-w>
nno <tab><tab> <c-w><c-w>
" reformat whole buffer
nno <leader>f gg=G
" run whole test file
nmap <leader>M <Plug>SendTestToTmux
" run test under cursor
nmap <leader>m <Plug>SendFocusedTestToTmux
" edit vimrc
nno <leader>rc :Rc<cr>
" reload vimrc
nno <leader>rl :Rl<cr>
" show cheat sheet
nno <leader>c :Cheat<cr>
no > >>
nno < <<
nmap < <<
nmap > >>
" indent right/left selection with repeat selecting
vmap < <gv
vmap > >gv
" }}} Bindings

