" Must have {{{
    augroup MyAutoCmd
        autocmd!
    augroup END
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
    let g:first_time = 0
    let g:neo_destination = "/bundle/neobundle.vim"
    if !isdirectory($CONFIG_ROOT . g:neo_destination)
        call mkdir($CONFIG_ROOT . "/.cache", "p")
        call mkdir($CONFIG_ROOT . "/bundle", "p")
        silent exec "!git clone git://github.com/Shougo/neobundle.vim " . $CONFIG_ROOT . g:neo_destination
        let g:first_time = 1
    endif
" }}} Handle first runtime

" Configure NeoBundle manager {{{
    set rtp+=$CONFIG_ROOT/bundle/neobundle.vim/
    call neobundle#rc(expand($CONFIG_ROOT . "/bundle"))
    " basic help
    "   :NeoBundleList          - list configured bundles
    "   :NeoBundleInstall(!)    - install(update) bundles
    "   :NeoBundleClean(!)      - confirm(or auto-approve) removal of unused
" }}} Configure NeoBundle manager

" Bundles definitions {{{
    " plugins manager

    " Let NeoBundle manage self
    NeoBundleFetch 'Shougo/neobundle.vim'

    NeoBundle 'Shougo/vimproc', { 'build': {
        \   'windows': 'make -f make_mingw32.mak',
        \   'cygwin': 'make -f make_cygwin.mak',
        \   'mac': 'make -f make_mac.mak',
        \   'unix': 'make -f make_unix.mak',
        \  } }

    " UNITE !!!
    NeoBundle 'Shougo/unite.vim', { 'depends':
        \ ['tsukkee/unite-tag','Shougo/unite-outline'] } " Unite {{{
        call unite#filters#matcher_default#use(['matcher_fuzzy'])
        call unite#filters#sorter_default#use(['sorter_rank'])
        if executable ('ag')
            let g:unite_source_grep_command = 'ag'
            let g:unite_source_grep_default_opts = '--nocolor --nogroup --hidden'
            let g:unite_source_grep_recursive_opt = ''
        elseif executable('ack')
            let g:unite_source_grep_command='ack'
            let g:unite_source_grep_default_opts='--no-heading --no-color -a'
            let g:unite_source_grep_recursive_opt=''
        endif
        let g:unite_data_directory='~/.vim/.cache/unite'
        let g:unite_source_file_rec_max_cache_files=5000
        let g:unite_enable_start_insert = 1
        let g:unite_prompt='» '
        let g:unite_enable_ignore_case = 1
        let g:unite_enable_smart_case = 1
        nmap <space> [unite]
        nnoremap [unite] <nop>
        nnoremap <silent> [unite]<space> :<C-u>Unite -buffer-name=mixed file_rec/async buffer file_mru bookmark<cr>
        nnoremap <silent> [unite]f :<C-u>Unite -buffer-name=files file_rec/async<cr>
        nnoremap <silent> [unite]l :<C-u>Unite -buffer-name=lines line<cr>
        nnoremap <silent> [unite]b :<C-u>Unite -buffer-name=buffers buffer<cr>
        nnoremap <silent> [unite]p :<C-u>Unite -buffer-name=processes process<cr>
        nnoremap <silent> [unite]n :<C-u>Unite file file/new<cr>
        nnoremap <silent> [unite]/ :<C-u>Unite -buffer-name=search grep:.<cr>
        nnoremap <silent> [unite]? :<C-u>execute 'Unite -buffer-name=search grep:.::' . expand("<cword>")
    " }}} Unite
    NeoBundle 'Shougo/unite-outline' " Unite outline {{{ 
        nnoremap <silent> [unite]o :<C-u>Unite -buffer-name=outline outline<cr>
    " }}} Unite outline
    NeoBundle 'Shougo/unite-help' " Unite help {{{
        nnoremap <silent> [unite]h :<C-u>Unite -buffer-name=help help<CR>
        nnoremap <silent> [unite]H :<C-u>UniteWithCursorWord -buffer-name=help help<CR>
    " }}} Unite help
    NeoBundle 'thinca/vim-unite-history' " Unite history {{{
        let g:unite_source_history_yank_enable=1
        nnoremap <silent> [unite]y :<C-u>Unite -buffer-name=yank history/yank<cr>
    " }}}
    NeoBundle 'Shougo/vimfiler' " {{{
        let g:vimfiler_as_default_explorer = 1
        nnoremap <silent> [unite]e :<C-u>VimFiler<cr>
    " }}}
    NeoBundle 'Shougo/vimshell.vim'
    NeoBundle 'Shougo/neocomplete' " {{{
        " let g:neocomplete#enable_at_startup = 1
    " }}}
    NeoBundle 'Shougo/neosnippet'

    NeoBundle 'mileszs/ack.vim'
    NeoBundle 'andrzejsliwa/vim-hemisu'
    NeoBundle 'tpope/vim-fugitive'
    NeoBundle 'Lokaltog/vim-powerline' " Powerline {{{
        let g:Powerline_symbols = 'compatible'
    " }}}
    NeoBundle 'terryma/vim-multiple-cursors'
    NeoBundle 'troydm/pb.vim'
    NeoBundle 'elixir-lang/vim-elixir'
    NeoBundle 'andrzejsliwa/vimerl' " VimErl {{{
        let g:erlang_highlight_bif = 1
    " }}}
    NeoBundle 'vim-scripts/ZoomWin'

    if g:first_time
        NeoBundleInstall
    endif
" }}} Bundles definitions


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
    set tabstop=4
    set shiftwidth=4
    set pastetoggle=<F3>
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
    set ignorecase
    set smartcase
" }}} Search

" Folding {{{
    " don't fold by default
    set nofoldenable
" }}}

 let snippets_dir = $CONFIG_ROOT . "/snippets"

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
    command! -bar -nargs=* Cheat call CheatSheet()
    command! -bar -nargs=* EditMySnippets call EditMySnippets()
    command! -bar -nargs=* ReloadMySnippets call ReloadMySnippets()
    command! -bar -nargs=* LineNumberToggle call LineNumberToggle()
    command! IndentErl call IndentErlangWithEmacs()
" }}} Commands defs

" Auto commands {{{
    "autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
    augroup FileTypes
        "au!
        "au FileType snippet setlocal shiftwidth=4 tabstop=4
        "au FileType erlang  setlocal shiftwidth=4 tabstop=4
        "au FileType make    setlocal noexpandtab shiftwidth=4 tabstop=4
        "au FileType snippet setlocal expandtab shiftwidth=4 tabstop=4
        "au BufNewFile,BufRead *.app.src set filetype=erlang
        "au BufNewFile,BufRead *.config  set filetype=erlang
    augroup END

    augroup Fugitive
        au!
        " Cleanup fugitive buffers
        au BufReadPost fugitive://* set bufhidden=delete
        au BufReadPost fugitive://*
            \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
            \   nnoremap <buffer> .. :edit %:h<CR> |
            \ endif
    augroup END

    augroup Other
        au!
        "au BufWritePre * :call <SID>StripTrailingWhitespaces()
        "au BufWinEnter * let w:m2=matchadd('ToLong', '\%>80v.\+', -1)
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

" Handle cursor shape {{{
    if exists('$TMUX')
        let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
        let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
    else
        let &t_SI = "\<Esc>]50;CursorShape=1\x7"
        let &t_EI = "\<Esc>]50;CursorShape=0\x7"
    endif
" }}}

" Bindings {{{
    " switch to previous buffer
    nno <leader><leader> <c-^>
    " switch relative/normal nuqmbering
    nno <leader>n :LineNumberToggle<cr>
   " split vertical
    nno <leader>v <C-W>v
    " split horizontal
    nno <leader>s <C-W>s
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
    " cycle & switch window
    nno <tab> <c-w><c-w>
    " reformat whole buffer
    nno <leader>f gg=G
    " reformat erlang emacs style
    nno <leader>fe :IndentErl<cr>
    " edit vimrc
    nno <leader>rc :Rc<cr>
    " reload vimrc
    nno <leader>rl :Rl<cr>
    " save shortuct
    nno <silent> <leader>w :w<cr>
    " Fugitive
    nno <leader>gd :Gdiff<cr>
    nno <leader>gs :Gstatus<CR><C-W>15+
    nno <leader>gw :Gwrite<cr>
    nno <leader>ga :Gadd<cr>
    nno <leader>gb :Gblame<cr>
    nno <leader>gco :Gcheckout<cr>
    nno <leader>gci :Gcommit<cr>
    nno <leader>gm :Gmove<cr>
    nno <leader>gr :Gremove<cr>
    nno <leader>gl :Shell git gl -18<cr>:wincmd \|<cr>
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
    " better search
    nno / /\V
    vno / /\V
" }}} Bindings

