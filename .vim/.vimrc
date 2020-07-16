set nocompatible " identify platform {{{1
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
" tab will be converted to 4 spaces.
set tabstop=4
"set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
augroup Z_VariousTab
  au!
  au FileType masm set tabstop=8 softtabstop=8 shiftwidth=8
augroup END
" }}}
" other settings {{{1

autocmd TermOpen * startinsert

" enable hide the buffer
set hidden

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

if finddir('.vim/tmp', $HOME) == ''
  call mkdir($HOME . "/.vim/tmp", "p")
endif
set directory=$HOME/.vim/tmp

" }}}

" Vim-plug
call plug#begin('~/.vim/bundle')

" Outlooking {{{
"Plug 'flazz/vim-colorschemes'
Plug 'itchyny/lightline.vim'
"Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
"Plug 'powerline/fonts', { 'do': './install.sh' }
Plug 'ryanoasis/vim-devicons'
Plug 'rakr/vim-one'
"Plug 'altercation/vim-colors-solarized'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'iCyMind/NeoSolarized'

Plug 'kien/rainbow_parentheses.vim', { 'for': 'racket,scheme,lisp'}

Plug 'camspiers/animate.vim' | Plug 'camspiers/lens.vim'
" }}}
" Edit {{{
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
Plug 'sjl/gundo.vim'
Plug 'tmsvg/pear-tree'
"Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdcommenter'
Plug 'godlygeek/tabular'

"Plug 'haya14busa/vim-edgemotion'

" 韩国人写的两个插件
Plug 'junegunn/goyo.vim' | Plug 'junegunn/limelight.vim'

Plug 'terryma/vim-multiple-cursors' | Plug 'terryma/vim-expand-region'
Plug 'terryma/vim-smooth-scroll'
Plug 'yuttie/comfortable-motion.vim'
" }}}
" Other {{{
Plug 'vim-scripts/utl.vim'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'mbbill/fencview'
Plug 'lervag/vimtex', { 'for': 'tex' }
Plug 'dstein64/vim-startuptime'
"Plug 'christoomey/vim-tmux-navigator'
if LINUX()
  "Plug 'majutsushi/tagbar'
  Plug 'mileszs/ack.vim'
endif
" }}}
" Code {{{
Plug 'derekwyatt/vim-fswitch'
"Plug 'w0rp/ale'
"Plug 'octol/vim-cpp-enhanced-highlight'

Plug 'enomsg/vim-haskellConcealPlus'
Plug 'neovimhaskell/haskell-vim'
Plug 'mhinz/vim-startify'
Plug 'dag/vim-fish'

Plug 'Shougo/neoinclude.vim'
Plug 'jsfaint/coc-neoinclude'
Plug 'Shougo/neco-vim'
Plug 'neoclide/coc-neco'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'SirVer/ultisnips'
Plug 'airblade/vim-gitgutter'
" }}}
" Game {{{
Plug 'johngrib/vim-game-code-break'
Plug 'vim-scripts/Nibble'
" Nibble has a dependency
Plug 'vim-scripts/genutils', { 'on': 'GameFlappyVird' }
Plug 'mattn/flappyvird-vim'

Plug 'rbtnn/game_engine.vim' | Plug 'rbtnn/mario.vim' | Plug 'rbtnn/puyo.vim'
" }}}

" My own plugin
Plug 'PascalZh/vim-color-explorer' | Plug 'PascalZh/vim-racket'
Plug 'PascalZh/vim-badapple', { 'on': 'ZBadApple', 'do': './install.sh' } 
Plug '~/.vim/bundle/omniwindow.nvim'
call plug#end()

source ~/.vim/.vimrc.bundle
source ~/.vim/.vimrc.mapping
source ~/.vim/.vimrc.appearance
source ~/.vim/.vimrc.language
