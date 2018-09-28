" When you are using this vimrc in the unix,
" :setlocal fileformat=unix :w
" :e
" Then it works
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

" machine-special {{{1
" I don't use NutStore for syncing my vimrc anymore.
" Instead, I use github to do it
"command! SaveVIMRCToNutStore call SaveVIMRCToNutStore()
"command! ReadVIMRCFromNutStore call ReadVIMRCFromNutStore()
" WINDOWS {{{2
if WINDOWS()
	" filetype: asm
	" 上面那个等号不知道为啥两边加了空格后就出问题了

	au BufRead *.asm setlocal filetype=masm
	"autocmd VimEnter * cd $HOME\projects
	"set shell=git-bash.exe
	"set shellcmdflag=-c

	" sync vimrc file with nutstore(deleted) {{{3
	"    func! SaveVIMRCToNutStore()
	"silent execute "!COPY " . shellescape(expand($MYVIMRC)) . " " . shellescape("C:\\Users\\zsy\\Downloads\\我的坚果云\\.vimrc")
	"endfunc
	"func! ReadVIMRCFromNutStore()
	"silent execute "!COPY " . shellescape("C:\\Users\\zsy\\Downloads\\我的坚果云\\.vimrc") . " " .  shellescape(expand($MYVIMRC))    
	"    endfunc
	"}}}

" LINUX {{{2
elseif LINUX()
	" sync vimrc file with nutstore(deleted) {{{3
	"   func! SaveVIMRCToNutStore()
	"silent execute "!cp ~/.vimrc ~/Desktop/Nutstore/.vimrc"
	"redraw!
	"endfunc
	"func! ReadVIMRCFromNutStore()
	"silent execute "!cp ~/Desktop/Nutstore/.vimrc ~/.vimrc"
	"redraw!
	"   endfunc
  " Here are some bug-fixing things

  " filetype of special file {{{3
  augroup MY_GROUP_FILETYPE
    au!
    au BufRead .myshrc.local set ft=sh
    au BufRead .tmux.conf* set ft=tmux
endif

" other settings {{{1
set belloff=all

" enable hide the buffer
set hidden
set linespace=0
set winminheight=0

" always use yanking to paste in other place
if has('clipboard')
	if has('unnamedplus')  " When possible use + register for copy-paste
		set clipboard=unnamed,unnamedplus
	else         " On mac and Windows, use * register for copy-paste
		set clipboard=unnamed
	endif
endif
set viewoptions=folds,options,cursor,unix,slash
set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
set timeoutlen=666
set virtualedit=onemore
set nospell
set spelllang=en,cjk
set iskeyword-=.                    " '.' is an end of word designator
set iskeyword-=#                    " '#' is an end of word designator
set iskeyword-=-

set foldmethod=marker
augroup FoldMethod_MY_GROUP
	au!
	au FileType python setlocal foldmethod=indent foldlevel=99
augroup END

set splitright
set splitbelow

let $LANG='en' " set message language
set langmenu=en

" indentation and syntax
syntax on
set smartindent

" 设置了之后，vim就不会在一行文字超过一定长度后自动按Enter换行
set whichwrap=b,s,h,l,<,>,[,]
set wrap
set textwidth=0

set cursorline
set nocursorcolumn
set ruler

set cmdheight=2
set showcmd
set laststatus=2
set more

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

" list mode
set nolist
set listchars=tab:\ \ ,eol:$,trail:*,extends:#

set scrolloff=2                 " Minimum lines to keep above and below cursor

" fuzzy find
set noautochdir                       "Set the working directories to wherever the open file lives
set wildmenu
set wildmode=list:longest,full
" }}}

" Vim-plug

call plug#begin('~/.vim/bundle')

" Outlooking
"Plug 'flazz/vim-colorschemes'
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
Plug 'powerline/fonts'
"Plug 'rakr/vim-one'
Plug 'altercation/vim-colors-solarized'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'kien/rainbow_parentheses.vim'


" Edit
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
Plug 'sjl/gundo.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdcommenter'
Plug 'godlygeek/tabular'
Plug 'SirVer/ultisnips'

" Others
Plug 'vim-scripts/utl.vim'
Plug 'scrooloose/nerdtree'
Plug 'mbbill/fencview'
if LINUX()
	"Plug 'majutsushi/tagbar'
	Plug 'mileszs/ack.vim'
endif

" Code
Plug 'derekwyatt/vim-fswitch'
Plug 'Valloric/YouCompleteMe'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
"Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'w0rp/ale'

" Game

" My own plugin
Plug 'PascalZh/vim-color-explorer'
"Plug 'PascalZh/my-syntax'
" Other

call plug#end()
so ~/.vimrc.bundle

" Appearance
so ~/.vimrc.appearance

" Keys Mappings
so ~/.vimrc.mapping

" Abbreviate {{{1
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
