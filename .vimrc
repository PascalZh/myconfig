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
" tab will be converted to 4 spaces.
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
au FileType vimscript set softtabstop=2 |
						\set shiftwidth=2 |
						\set expandtab |
						\set smarttab

" machine-special {{{1
" I don't use NutStore for syncing my vimrc anymore.
" Instead, I use github to do it
"command! SaveVIMRCToNutStore call SaveVIMRCToNutStore()
"command! ReadVIMRCFromNutStore call ReadVIMRCFromNutStore()
if WINDOWS()
    " filetype: asm
    au BufRead *.asm setlocal filetype=masm
        " 上面那个等号不知道为啥两边加了空格后就出问题了

    autocmd VimEnter * cd $HOME\projects
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
    " }}}
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
set spell
set iskeyword-=.                    " '.' is an end of word designator
set iskeyword-=#                    " '#' is an end of word designator
set iskeyword-=-
set foldmethod=marker
set foldcolumn=0

set splitright
set splitbelow

let $LANG='en' " set message language
set langmenu=en

" indentation and syntax
syntax on
set smartindent

" 设置了之后，vim就不会在一行文字超过一定长度后自动按Enter换行
set whichwrap=b,s,h,l,<,>,[,]
set nowrap
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
set list
set listchars=tab:\ \ ,eol:$,trail:*,extends:#

set scrolloff=5                 " Minimum lines to keep above and below cursor

" fuzzy find
set noautochdir                       "Set the working directories to wherever the open file lives
set wildmenu
set wildmode=list:longest,full
" }}}

" Vim-plug

call plug#begin('~/.vim/bundle')

" There are my plugins: ########################
"Plug 'flazz/vim-colorschemes'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'powerline/fonts'
Plug 'altercation/vim-colors-solarized'

" Edit
Plug 'easymotion/vim-easymotion'
Plug 'scrooloose/nerdtree'
"好像并没有什么用
"Plug 'kshenoy/vim-signature'
Plug 'sjl/gundo.vim'
Plug 'terryma/vim-multiple-cursors'

" Window and Buffer
"Plug 'fholgado/minibufexpl.vim'
" Code
Plug 'jiangmiao/auto-pairs'
Plug 'kien/rainbow_parentheses.vim'
" 这个插件效果太差已弃用
"Plug 'nathanaelkane/vim-indent-guides'
Plug 'scrooloose/nerdcommenter'
if LINUX()
Plug 'majutsushi/tagbar'
endif
if has('perl')
Plug 'mileszs/ack.vim'
endif

" C/C++
Plug 'derekwyatt/vim-fswitch'
Plug 'Valloric/YouCompleteMe'
Plug 'octol/vim-cpp-enhanced-highlight'

" Game

" My own plugin
Plug 'PascalZh/vim-color-explorer'
" Other

call plug#end()
source ~/.vimrc.bundles
" }}}

" Appearance
so ~/.vimrc.appearance

" Keys Mappings
so ~/.vimrc.mappings

" Abbreviate {{{1
iab @d <C-R>=strftime("20%y.%m.%d %X")<CR>
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
