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
"Bundle 'scrooloose/nerdtree'
" tmux integration
Bundle 'benmills/vimux'
" running tests via vimux and tmux
Bundle 'jgdavey/vim-turbux'
" fuzzy finder for files and buffers
Bundle 'kien/ctrlp.vim'
" native clipboard
Bundle 'troydm/pb.vim'
" git integration
Bundle 'tpope/vim-fugitive'
" rebar integration
Bundle 'mbbx6spp/vim-rebar'
" erlang integration - customised indentation
Bundle 'andrzejsliwa/vimerl'
"
"Bundle 'vim-scripts/sudo.vim'
"
"Bundle 'vim-scripts/ZoomWin'
"
"Bundle 'vim-scripts/YankRing.vim'
"
"Bundle 'vim-scripts/Vim-R-plugin'
"
"Bundle 'vim-scripts/Specky'
"
"Bundle 'vim-scripts/SearchComplete'
"
"Bundle 'vim-scripts/IndexedSearch'
"
"Bundle 'vim-scripts/AutoTag'
"
"Bundle 'vim-ruby/vim-ruby'
"
"Bundle 'tpope/vim-unimpaired'
"
"Bundle 'tpope/vim-surround'
"
"Bundle 'tpope/vim-repeat'
"
"Bundle 'tpope/vim-rake'
"
"Bundle 'tpope/vim-rails'
"
"Bundle 'tpope/vim-haml'
"
"Bundle 'tpope/vim-git'
"
"Bundle 'tpope/vim-fugitive'
"
"Bundle 'tpope/vim-endwise'
"
"Bundle 'tpope/vim-bundler'
"
"Bundle 'tomtom/tcomment_vim'
"
"Bundle 'tjennings/git-grep-vim'
"
"Bundle 'skwp/vim-ruby-conque'
"
"Bundle 'skwp/vim-easymotion'
"
"Bundle 'skwp/vim-conque'
"
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
set synmaxcol=200
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

" NERDTree {{{
let NERDTreeQuitOnOpen = 1
" }}} NERDTree

" Ack {{{
" you need to install https://github.com/ggreer/the_silver_searcher
let g:ackprg = 'ag --nogroup --nocolor --column'
" }}} Ack

" CtrlP {{{
let g:ctrlp_cache_dir = $CONFIG_ROOT . '/tmp/.cache/ctrlp'
"let g:ctrlp_reuse_window = 0
" }}} CtrlP

" Vimerl {{{
let g:erlang_highlight_bif = 1
" }}} Vimerl

" Power line {{{
let g:Powerline_symbols = 'compatible'
" }}} Power line

" Turbux {{{
let g:turbux_command_prefix = 'zeus'
let g:no_turbux_mappings = 1
" }}}

" Snipmate {{{
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

" IndentErlangWithEmacs() {{{
let s:emacs_indenter = expand('~/.vim/emacs_indent.sh')
function! IndentErlangWithEmacs()
  execute 'silent :w'
  execute 'silent !' . s:emacs_indenter . ' ' . expand('%:p')
  execute 'silent :e'
  redraw!
endfunction
" }}}

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
  execute "w"
  execute "bd"
  execute "call ReloadAllSnippets()"
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
command! IndentErl call IndentErlangWithEmacs()
" }}} Commands defs

" Auto commands {{{
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
augroup FileTypes
  au!
  au FileType snippet setlocal shiftwidth=4 tabstop=4
  au FileType erlang  setlocal shiftwidth=4 tabstop=4
  au FileType make    setlocal noexpandtab shiftwidth=4 tabstop=4
  au FileType snippet setlocal expandtab shiftwidth=4 tabstop=4
  au BufNewFile,BufRead *.app.src set filetype=erlang
  au BufNewFile,BufRead *.config  set filetype=erlang
augroup END

augroup Other
  au!
  au BufWritePre * :call <SID>StripTrailingWhitespaces()
  au BufWinEnter * let w:m2=matchadd('ToLong', '\%>80v.\+', -1)
augroup END
" }}} Auto commands

" Handle mouse {{{
if has('mouse')
  set mouse=a
  if &term =~ "xterm" || &term =~ "screen"
    autocmd VimEnter *    set ttymouse=xterm2
    autocmd FocusGained * set ttymouse=xterm2
    autocmd BufEnter *    set ttymouse=xterm2
  endif
endif
" }}}

" Bindings {{{
" enable paste
nno <leader>q :set paste<cr>
" switch to previous buffer
no <leader><leader> <c-^>
" diable paste
nno <leader>Q :set nopaste<cr>
" switch relative/normal nuqmbering
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
nno <leader>s <C-W>s
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
" open current folding and close others
nno <leader><Space> zR
" reset search
nno <silent> <Leader>/ :nohlsearch<cr>
" reload snippets for current filetype
nno <leader>sr :ReloadMySnippets<cr>
" edit snippets for current filetype
nno <leader>se :EditMySnippets<cr>
" open nerd tree
nno <leader>o :NERDTreeToggle<cr>
" open nerd tree
nno <leader>e :Explore<cr>
" cycle & switch window
nno <tab> <c-w><c-w>
" reformat whole buffer
nno <leader>f gg=G
" reformat erlang emacs style
nno <leader>fe :IndentErl<cr>
" run whole test file
nmap <leader>M <Plug>SendTestToTmux
" run test under cursor
nmap <leader>m <Plug>SendFocusedTestToTmux
" edit vimrc
nno <leader>rc :Rc<cr>
" reload vimrc
nno <leader>rl :Rl<cr>
" run custom vimux command
nno <leader>c :VimuxPromptCommand<cr>
" run last vimux command
nno <leader>l :w<cr>:VimuxRunLastCommand<cr>
" move left
nno < <<
nmap < <<
" move right
nno > >>
nmap > >>
" move left selection with repeat selecting
vmap < <gv
" move right selection with repeat selecting
vmap > >gv
" resize window left
nno <leader>h :vertical resize -5<cr>
" resize window right
nno <leader>l :vertical resize +5<cr>
" resize window down
nno <leader>j :resize +5<cr>
" resize window up
nno <leader>k :resize -5<cr>
" }}} Bindings

