set nocompatible
" identify platform {{{1
silent function! OSX()
  return has('macunix')
endfunction
silent function! LINUX()
  return has('unix') && !has('macunix') && !has('win32unix')
endfunction
silent function! WINDOWS()
  return  (has('win32') || has('win64'))
endfunction
" format encoding and tab {{{1
if LINUX()
  set fileformat=unix
elseif WINDOWS()
  set fileformat=dos
endif

set encoding=utf-8
set fileencoding=utf-8
" tab will be converted to 2 spaces.
set tabstop=2
"set softtabstop=2
set shiftwidth=2
set expandtab
set smarttab
augroup VariousTab
  au!
  au FileType masm set tabstop=8 softtabstop=8 shiftwidth=8
augroup END
" }}}
" other settings {{{1

if has('nvim')
  autocmd TermOpen * startinsert
endif
set belloff=all

" enable hide the buffer
set hidden
set linespace=0

" always use yanking to paste in other place
if has('clipboard')
  if has('unnamedplus')  " When possible use + register for copy-paste
    set clipboard=unnamed,unnamedplus
  else         " On mac and Windows, use * register for copy-paste
    set clipboard=unnamed
  endif
endif
set timeoutlen=666
set virtualedit=onemore
set nospell
au FileType markdown setlocal spell
au FileType tex setlocal spell
set spelllang=en,cjk
set iskeyword-=.                    " '.' is an end of word designator
set iskeyword-=#                    " '#' is an end of word designator
set iskeyword-=-

set splitright
set splitbelow

let $LANG='en' " set message language
set langmenu=en

" indentation and syntax
syntax on
set smartindent

set backspace=indent,eol,start
set mouse=a
set mousehide
set history=1000

" search
set magic
set hlsearch
set incsearch
set ignorecase
set smartcase

" fuzzy find
set noautochdir                       "Set the working directories to wherever the open file lives
set wildmenu
set wildmode=list:longest,full

if exists('+inccommand')
  set inccommand=split
endif



" }}}

" Vim-plug
call plug#begin('~/.vim/bundle')

" Outlooking {{{
"Plug 'flazz/vim-colorschemes'
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
Plug 'powerline/fonts', { 'do': './install.sh' }
Plug 'ryanoasis/vim-devicons'
"Plug 'rakr/vim-one'
Plug 'altercation/vim-colors-solarized'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'kien/rainbow_parentheses.vim', { 'for': 'racket,scheme,lisp'}
" }}}
" Edit {{{
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
Plug 'sjl/gundo.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdcommenter'
Plug 'godlygeek/tabular'
Plug 'zhou13/vim-easyescape'

"Plug 'haya14busa/vim-edgemotion'

" 韩国人写的两个插件
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

Plug 'terryma/vim-multiple-cursors'
Plug 'terryma/vim-expand-region'
Plug 'terryma/vim-smooth-scroll'
" }}}
" Other {{{
Plug 'vim-scripts/utl.vim'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'mbbill/fencview'
Plug 'lervag/vimtex', { 'for': 'tex' }
"Plug 'christoomey/vim-tmux-navigator'
if LINUX()
  "Plug 'majutsushi/tagbar'
  Plug 'mileszs/ack.vim'
endif
" }}}
" Code {{{
Plug 'derekwyatt/vim-fswitch'
Plug 'w0rp/ale'
"Plug 'Valloric/YouCompleteMe'
"Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
"Plug 'octol/vim-cpp-enhanced-highlight'

Plug 'mhinz/vim-startify'

if has('nvim')
  " assuming you're using vim-plug: https://github.com/junegunn/vim-plug
  "Plug 'ncm2/ncm2'
  "Plug 'roxma/nvim-yarp'

  " enable ncm2 for all buffers
  "autocmd BufEnter * call ncm2#enable_for_buffer()

  " IMPORTANTE: :help Ncm2PopupOpen for more information
  "set completeopt=noinsert,menuone,noselect

  " NOTE: you need to install completion sources to get completions. Check
  " our wiki page for a list of sources: https://github.com/ncm2/ncm2/wiki
  "Plug 'ncm2/ncm2-bufword'
  "Plug 'ncm2/ncm2-tmux'
  "Plug 'ncm2/ncm2-path'

  "Plug 'neomake/neomake'

  "Plug 'ncm2/ncm2-ultisnips'
endif
Plug 'SirVer/ultisnips'
Plug 'airblade/vim-gitgutter'
" }}}
" Game {{{
Plug 'johngrib/vim-game-code-break'
Plug 'vim-scripts/Nibble'
" Nibble has a dependency
Plug 'vim-scripts/genutils', { 'on': 'GameFlappyVird' }
Plug 'mattn/flappyvird-vim'

Plug 'rbtnn/game_engine.vim'
Plug 'rbtnn/mario.vim'
Plug 'rbtnn/puyo.vim'
" }}}

" My own plugin
Plug 'PascalZh/vim-color-explorer'
Plug 'PascalZh/vim-racket'
Plug 'PascalZh/vim-badapple', { 'on': 'BadApple', 'do': './install.sh' } 
call plug#end()

so ~/.vim/.vimrc.bundle
so ~/.vim/.vimrc.appearance
so ~/.vim/.vimrc.mapping
so ~/.vim/.vimrc.language

" Abbreviate (deleted) {{{1
"iab #date <C-R>=strftime("20%y.%m.%d %X")<CR>
" in the Vim, abbreviations are divided into tree species
" 1: #abc
" 2: #$%a
" 3: abc
" 1: The first place have one special character at the beginning and others are simple
" letter.
" 2: The last cahracter is a simple letter, and others are special characters.
" 3: All characters are simple letters.
" 
" <C-R>register can input the value in the register.
" for example: <C-R>
" This will return the content in the register(this is default clipboard register).
" }}}
