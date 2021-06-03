local g = vim.g
local cmd = vim.cmd
local o, wo, bo = vim.o, vim.wo, vim.bo
local execute = vim.api.nvim_command
local fn = vim.fn

local utils = require('config.utils')
local opt = utils.opt
local autocmd = utils.autocmd
local map = utils.map

require('plugins')
g.netrw_browsex_viewer = 'cmd.exe /C start'
g.netrw_suppress_gx_mesg = 0

opt('termguicolors', true)
local color_list = {'one', 'dracula', 'NeoSolarized'}
cmd('colorscheme '..color_list[
  math.floor(fn.localtime() / (7 * 24 * 60 * 60) % #color_list)
])

autocmd('MyTUI', {
  'FileType haskell,python,vim,cpp,c,javascript,lua'..
    ' setlocal colorcolumn=81 | hi ColorColumn ctermbg=Green guibg=Green',
  'TextYankPost *'..
    ' silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=222}',
})

autocmd('MyFoldMethod', {
  [[FileType vim,racket,javascript,lua setlocal foldmethod=marker foldlevel=99 | normal zM]],
})
cmd [[autocmd TermOpen * startinsert]]

local window = {o, wo}
local buffer = {o, bo}

opt('winblend', 15, window)
opt('signcolumn', 'auto:4', window)

opt('cursorline', true, window)
opt('cursorcolumn', true, window)

opt('number', true, window)
opt('relativenumber', true, window)

opt('list', false, window)
opt('listchars', 'tab:  ,eol:$,trail:*,extends:#', window)

opt('scrolloff', 7, window)  -- Minimum lines to keep above and below cursor
opt('winminheight', 0)
opt('cmdheight', 1)

opt('conceallevel', 2, window)

opt('fileencoding', 'utf-8', buffer)

opt('tabstop', 2, buffer)
opt('expandtab', true, buffer)
opt('shiftwidth', 2, buffer)

opt('hidden', true)

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

-- always use yanking to paste in other place
--opt('clipboard', 'unnamed,unnamedplus')

opt('timeoutlen', 666)
opt('updatetime', 500) -- also controls the delay of gitgutter
opt('virtualedit', 'onemore')

-- Spell {{{
opt('spell', false)
cmd [[autocmd FileType markdown,tex setlocal spell]]
opt('spelllang', 'en,cjk', buffer)
-- }}}

opt('splitright', true)
opt('splitbelow', true)

opt('smartindent', true, buffer)

opt('mouse', 'a')
opt('history', 1000)

-- search
opt('ignorecase', true)
opt('smartcase', true)

opt('wildmode', 'list:longest,full')

opt('inccommand', 'split')

cmd [[command! Zenmode execute "Goyo | Limelight"]]
cmd [[command! LightlineToggle call lightline#toggle()]]

local silent = {silent = true}
g.mapleader = " "

map('v', 'X', [[y/\V<C-R>=escape(escape(@",'\'),'/')<CR><CR>]])
map('v', 'x', ':call exchange_selected_text#ExchangeSelectedText()<CR>') -- DO NOT USE <Cmd>...<CR>

map('n', '<leader><space>', '<Cmd>nohlsearch<CR>')
map('n', '<leader>bg', '<Cmd>call ToggleBG()<CR>')

map('n', '<leader>g', '<Cmd>Grepper -tool git<CR>')
map('n', '<leader>G', '<Cmd>Grepper -tool ack<CR>')
map({'n', 'x'}, 'gs', '<Plug>(GrepperOperator)')

map('n', 'q', '<Nop>')
map('n', '<leader>q', 'q')

map('n', '<leader>s', ':%s/')
map('v', '<leader>s', ':s/')

map({'n', 'v'}, '<leader>t', ':Tabularize ')
map({'n', 'v'}, '<leader>tt', ':Tabularize ')
map({'n', 'v'}, '<leader>ta', ':Tabularize argument_list<CR>')

-- Toggle mappings(begin with ,) {{{
map('n', ',e', '<Cmd>:NvimTreeToggle<CR>')
map('n', ',l', '<Cmd>:call quickfix_toggle#QuickfixToggle("ll")<cr>')
map('n', ',q', '<Cmd>:call quickfix_toggle#QuickfixToggle("qf")<cr>')
-- }}}

map('n', ',,', 'za')
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

map('n', '<C-s>',  '<Cmd>wa<CR>')
map('i', '<C-s>',  '<Cmd>:wa<CR>')

map('v', '<', '<gv')
map('v', '>', '>gv')

map({'n', 'x'}, '<C-k>', '<Plug>NERDCommenterToggle', {noremap = false})
