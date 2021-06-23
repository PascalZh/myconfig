local g = vim.g
local cmd = vim.cmd
local o, wo, bo = vim.o, vim.wo, vim.bo
local execute = vim.api.nvim_command
local fn = vim.fn

local utils = require('config.utils')
local opt = utils.opt
local autocmd = utils.autocmd
local map = utils.map  -- must set noremap = false to map <plug>(..)

-- ensure packer.nvim is installed
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

require('plugins')
require('statusline')
require('highlight')

local wk = require('which-key')
g.netrw_browsex_viewer = 'cmd.exe /C start'
g.netrw_suppress_gx_mesg = 0

-- TUI {{{
opt('termguicolors', true)

-- Color Scheme {{{
local color_list = {'one', 'dracula', 'NeoSolarized'}
cmd('colorscheme '..color_list[
   1 + math.floor(fn.localtime() / (7 * 24 * 60 * 60) % #color_list)
])
-- }}}

autocmd('TUI', {
  'FileType haskell,python,vim,cpp,c,javascript,lua '..
    'setlocal colorcolumn=81 | hi ColorColumn ctermbg=Green guibg=Green',
  'TextYankPost * '..
    'lua MUtils.highlight.on_yank {higroup="IncSearch", timeout=222}',
})

opt('showtabline', 2)

opt('showmode', false)

opt('winblend', 15, window)
opt('signcolumn', 'auto:1-4', window)

opt('cursorline', true, window)
opt('cursorcolumn', false, window)

opt('number', true, window)
opt('relativenumber', true, window)

opt('list', false, window)
opt('listchars', 'tab:  ,eol:$,trail:*,extends:#', window)

opt('scrolloff', 7, window)  -- Minimum lines to keep above and below cursor

opt('conceallevel', 2, window)

opt('splitright', true)
opt('splitbelow', true)

opt('wildmode', 'full')

opt('inccommand', 'split')
opt('mouse', 'a')

-- }}}

cmd [[autocmd TermOpen * startinsert]]

local window = {o, wo}
local buffer = {o, bo}

-- Format {{{
-- `formatoptions` is set by ftplugin/*.vim in neovim runtime folder and other
-- plugins' folder, I don't know how to override them.
opt('textwidth', 80, buffer)
-- }}}

opt('fileencoding', 'utf-8', buffer)

-- Fold {{{
opt('foldtext', "'>-'.printf('%3d',v:foldend-v:foldstart+1).'=>'.getline(v:foldstart)", window)
opt('fillchars', 'fold:>', window)

autocmd('FoldSetting', {
  'FileType vim,racket,javascript,lua '..
    'setlocal foldmethod=marker foldlevel=99 | normal zM',
})
-- }}}

-- Tab {{{
opt('tabstop', 2, buffer)
opt('expandtab', true, buffer)
opt('shiftwidth', 2, buffer)
-- }}}

opt('hidden', true)

-- Clipboard {{{
if fn.exists('$WSL_DISTRO_NAME') then
	g.clipboard = {
		name= 'win32yank',
		copy= {
			['+'] = 'win32yank.exe -i --crlf',
			['*'] = 'win32yank.exe -i --crlf',
		},
		paste= {
			['+'] = 'win32yank.exe -o --lf',
			['*'] = 'win32yank.exe -o --lf',
		},
		cache_enabled = 0,
	}
end
-- }}}

--opt('clipboard', 'unnamed,unnamedplus') -- always use yanking to paste in other place

opt('timeoutlen', 500) -- also controls the delay of which-key
opt('updatetime', 500) -- also controls the delay of gitgutter
opt('virtualedit', 'onemore')

-- Spell {{{
opt('spell', false, window)
autocmd('Spell', {
  [[FileType markdown,tex setlocal spell]]
})
opt('spelllang', 'en,cjk', buffer)
-- }}}

opt('smartindent', true, buffer)

opt('history', 1000)

-- search
opt('ignorecase', true)
opt('smartcase', true)

cmd [[command! Zenmode execute "Goyo | Limelight"]]
cmd [[command! LightlineToggle call lightline#toggle()]]

--------------------------------- Mappings -------------------------------------
local silent = {silent = true}
g.mapleader = " "

map('v', '*', [[y/\V<C-R>=escape(escape(@",'\'),'/')<CR><CR>]])
-- DO NOT USE <Cmd>...<CR>
map('v', 'x', ':call exchange_selected_text#ExchangeSelectedText()<CR>')

map('n', ';<space>', '<Cmd>nohlsearch<CR>')
map('n', '<leader>bg', '<Cmd>call ToggleBG()<CR>')
wk.register({b = {name = "Toggle Dark/Light Background"}}, {prefix = '<leader>'})

map('n', '<leader>G', '<Cmd>Grepper -tool git<CR>')
map({'n', 'x'}, '<leader>g', '<Plug>(GrepperOperator)', {noremap = false})

--map('n', 'q', '<Nop>')
--map('n', '<leader>q', 'q')

map('n', '<leader>s', ':%s/')
map('v', '<leader>s', ':s/')

map({'n', 'v'}, '<leader>t', ':Tabularize ')
map({'n', 'v'}, '<leader>tt', ':Tabularize /')
map({'n', 'v'}, '<leader>ta', ':Tabularize argument_list<CR>')

-- Toggle mappings(begin with ,) {{{
map('n', ',e', '<Cmd>:NvimTreeToggle<CR>')
map('n', ',l', '<Cmd>:call quickfix_toggle#QuickfixToggle("ll")<cr>')
map('n', ',q', '<Cmd>:call quickfix_toggle#QuickfixToggle("qf")<cr>')
-- }}}

--map('n', '<Tab>', '<Cmd>bnext<CR>')
--map('n', '<S-Tab>', '<Cmd>bNext<CR>')
map('n', ';;', 'za')
map('i', 'j', 'easy_jk#map_j()', {noremap = false, expr = true})
map('i', 'k', 'easy_jk#map_k()', {noremap = false, expr = true})

-- Scroll {{{
map('n', '<C-d>', '<Cmd>call animation#scroll_up(winheight(0)/2)<CR>')
map('n', '<C-f>', '<Cmd>call animation#scroll_up(winheight(0))<CR>')
map('n', '<C-u>', '<Cmd>call animation#scroll_down(winheight(0)/2)<CR>')
map('n', '<C-b>', '<Cmd>call animation#scroll_down(winheight(0))<CR>')
map('n', '<PageDown>', '<C-f>', {noremap = false})
map('n', '<PageUp>', '<C-b>', {noremap = false})
-- }}}

-- Window commands: jump/resize/quit/... {{{
map('n', 'H', '<C-w>h')
map('n', 'J', '<C-w>j')
map('n', 'K', '<C-w>k')
map('n', 'L', '<C-w>l')

local delta_resize = 6
map('n', '<C-w><', string.rep('<C-w><', delta_resize * 2))
map('n', '<C-w>>', string.rep('<C-w>>', delta_resize * 2))
map('n', '<C-w>+', string.rep('<C-w>+', delta_resize))
map('n', '<C-w>-', string.rep('<C-w>-', delta_resize))

map('n', '<C-q>', '<C-w>q')
-- }}}

map('n', '<C-l>', 'i<C-g>u<Esc>$[s1z=`]a<C-g>u<Esc>')
map('i', '<C-l>', '<C-g>u<Esc>$[s1z=`]i<C-g>u');

map('n', '<C-s>',  '<Cmd>w<CR>')
map('i', '<C-s>',  '<Cmd>:w<CR>')

map('v', '<', '<gv')
map('v', '>', '>gv')

map({'n', 'x'}, '<C-k>', '<Plug>NERDCommenterToggle', {noremap = false})
wk.register({c = {name = "NERD Commenter"}}, {prefix = '<leader>'})

wk.register({h = {name = "Git Gutter"}}, {prefix = '<leader>'})

-- bufline mappings {{{
cmd [[
nmap <Leader>1 <Plug>lightline#bufferline#go(1)
nmap <Leader>2 <Plug>lightline#bufferline#go(2)
nmap <Leader>3 <Plug>lightline#bufferline#go(3)
nmap <Leader>4 <Plug>lightline#bufferline#go(4)
nmap <Leader>5 <Plug>lightline#bufferline#go(5)
nmap <Leader>6 <Plug>lightline#bufferline#go(6)
nmap <Leader>7 <Plug>lightline#bufferline#go(7)
nmap <Leader>8 <Plug>lightline#bufferline#go(8)
nmap <Leader>9 <Plug>lightline#bufferline#go(9)
nmap <Leader>0 <Plug>lightline#bufferline#go(10)
]]
cmd [[
nmap <Leader>d1 <Plug>lightline#bufferline#delete(1)
nmap <Leader>d2 <Plug>lightline#bufferline#delete(2)
nmap <Leader>d3 <Plug>lightline#bufferline#delete(3)
nmap <Leader>d4 <Plug>lightline#bufferline#delete(4)
nmap <Leader>d5 <Plug>lightline#bufferline#delete(5)
nmap <Leader>d6 <Plug>lightline#bufferline#delete(6)
nmap <Leader>d7 <Plug>lightline#bufferline#delete(7)
nmap <Leader>d8 <Plug>lightline#bufferline#delete(8)
nmap <Leader>d9 <Plug>lightline#bufferline#delete(9)
nmap <Leader>d0 <Plug>lightline#bufferline#delete(10)
]]
wk.register({d = {name = "bufferline: Delete"}}, {prefix = '<leader>'})
-- }}}
