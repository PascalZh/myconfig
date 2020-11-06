" identify platform {{{1
function! OSX()
  return has('macunix')
endfunction
function! LINUX()
  return has('unix') && !has('macunix') && !has('win32unix')
endfunction
function! WINDOWS()
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
set tabstop=2
set shiftwidth=2
set expandtab
set smarttab
augroup Z_VariousTab
  au!
  au FileType masm set tabstop=8 shiftwidth=8
augroup END
" }}}
" other settings {{{1

augroup Z_MY_FoldMethod
  au!
  "au FileType python setlocal foldmethod=indent foldlevel=99
  au FileType vim,racket,javascript setlocal foldmethod=marker foldlevel=99 | normal zM
  au FileType lua setlocal foldexpr=getline(v:lnum)=~'^local\ function'?'a1':(getline(v:lnum)=~'^end'?'s1':'=')
  au FileType lua setlocal foldmethod=expr
augroup END

autocmd TermOpen * startinsert

" enable hide the buffer
set hidden

" always use yanking to paste in other place
if exists('$WSL_DISTRO_NAME')
  let g:clipboard = {
        \ 'name': 'win32yank',
        \ 'copy': {
        \    '+': 'win32yank.exe -i --crlf',
        \    '*': 'win32yank.exe -i --crlf',
        \  },
        \ 'paste': {
        \    '+': 'win32yank.exe -o --lf',
        \    '*': 'win32yank.exe -o --lf',
        \ },
        \ 'cache_enabled': 0,
        \ }
endif

set timeoutlen=666
set virtualedit=onemore

set nospell
au FileType markdown setlocal spell
au FileType tex setlocal spell
set spelllang=en,cjk

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
set ignorecase
set smartcase

"set wildmode=list:longest,full

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
Plug 'rakr/vim-one'
"Plug 'altercation/vim-colors-solarized'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'iCyMind/NeoSolarized'

Plug 'kien/rainbow_parentheses.vim', { 'for': 'racket,scheme,lisp'}
" }}}
" Edit {{{
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
Plug 'sjl/gundo.vim'
Plug 'tmsvg/pear-tree'
"Plug 'jiangmiao/auto-pairs'
Plug 'preservim/nerdcommenter'
Plug 'godlygeek/tabular'

"Plug 'haya14busa/vim-edgemotion'

" 韩国人写的两个插件
Plug 'junegunn/goyo.vim' | Plug 'junegunn/limelight.vim'
Plug 'junegunn/vim-peekaboo'

Plug 'terryma/vim-multiple-cursors'
Plug 'terryma/vim-expand-region'
"Plug 'mg979/vim-visual-multi'
" }}}
" Other {{{
"Plug 'vim-scripts/utl.vim'
Plug 'preservim/nerdtree', { 'on':  'NERDTreeToggle' }
"Plug 'zgpio/tree.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua', { 'on': 'LuaTreeToggle' }

Plug 'mbbill/fencview'
Plug 'lervag/vimtex', { 'for': 'tex' }
Plug 'dstein64/vim-startuptime'
Plug 'mhinz/vim-grepper'
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

Plug 'nvim-treesitter/nvim-treesitter'
" }}}
" Game {{{
Plug 'johngrib/vim-game-code-break'

" }}}
Plug 'ryanoasis/vim-devicons'

" My own plugin
Plug 'PascalZh/vim-color-explorer' | Plug 'PascalZh/vim-racket'
Plug 'PascalZh/vim-badapple', { 'on': 'ZBadApple', 'do': './install.sh' } 
Plug 'PascalZh/omniwindow.nvim'
call plug#end()

source ~/.vim/.vimrc.bundle
source ~/.vim/.vimrc.mapping
source ~/.vim/.vimrc.tui
source ~/.vim/.vimrc.file_type
