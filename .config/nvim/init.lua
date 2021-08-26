-- must set noremap = false to map <plug>(..)
local env = require('config.inject_env')
setmetatable(env, {__index = _G})
setfenv(1, env)

-- ensure packer.nvim is installed {{{
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end
-- }}}

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
opt('foldtext', "repeat('>',v:foldlevel).printf('%3d',v:foldend-v:foldstart+1).' '.getline(v:foldstart).' ...'", window)
opt('fillchars', 'fold: ', window)

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

xmap('*', [[y/\V<C-R>=escape(escape(@",'\'),'/')<CR><CR>]])
-- DO NOT USE <Cmd>...<CR>
xmap('X', ':call exchange_selected_text#delete()<CR>', {silent = true})

nmap(';<space>', '<Cmd>nohlsearch<CR>')

nmap('<leader>bg', '<Cmd>call ToggleBG()<CR>')
wk.register({b = {name = "Toggle Dark/Light Background"}}, {prefix = '<leader>'})

nmap('<leader>ev', '<Cmd>lua require"config.edit_vimrc"()<CR>')

nmap('<leader>G', '<Cmd>Grepper -tool git<CR>')
nvmap('<leader>g', '<Plug>(GrepperOperator)', {noremap = false})

--map('n', 'q', '<Nop>')
--map('n', '<leader>q', 'q')

nmap('<leader>s', ':%s/')
vmap('<leader>s', ':s/')

nmap('<leader>S', '<Cmd>Startify<CR>')

nvmap('<leader>t<space>', ':Tabularize ')
nvmap('<leader>tt', ':Tabularize /')
nvmap('<leader>ta', ':Tabularize argument_list<CR>')
wk.register({t = {name = "Tabularize"}}, {prefix='<leader>'})

-- Toggle mappings(begin with ,) {{{
nmap(',e', '<Cmd>:NvimTreeToggle<CR>')
nmap(',l', '<Cmd>:call quickfix_toggle#QuickfixToggle("ll")<cr>')
nmap(',q', '<Cmd>:call quickfix_toggle#QuickfixToggle("qf")<cr>')
-- }}}

--map('n', '<Tab>', '<Cmd>bnext<CR>')
--map('n', '<S-Tab>', '<Cmd>bNext<CR>')
nmap(';;', 'za')
imap('j', 'easy_jk#map_j()', {noremap = false, expr = true})
imap('k', 'easy_jk#map_k()', {noremap = false, expr = true})

-- Scroll {{{
nmap('<C-d>', '<Cmd>call animation#scroll_up(winheight(0)/2)<CR>')
nmap('<C-f>', '<Cmd>call animation#scroll_up(winheight(0))<CR>')
nmap('<C-u>', '<Cmd>call animation#scroll_down(winheight(0)/2)<CR>')
nmap('<C-b>', '<Cmd>call animation#scroll_down(winheight(0))<CR>')
nmap('<PageDown>', '<C-f>', {noremap = false})
nmap('<PageUp>', '<C-b>', {noremap = false})
-- }}}

-- Window commands: jump/resize/quit/... {{{
nmap('H', '<C-w>h')
nmap('J', '<C-w>j')
nmap('K', '<C-w>k')
nmap('L', '<C-w>l')

local delta_resize = 6
nmap('<C-w><', string.rep('<C-w><', delta_resize * 2))
nmap('<C-w>>', string.rep('<C-w>>', delta_resize * 2))
nmap('<C-w>+', string.rep('<C-w>+', delta_resize))
nmap('<C-w>-', string.rep('<C-w>-', delta_resize))

nmap('<C-q>', '<C-w>q')
-- }}}

nmap('<C-l>', 'i<C-g>u<Esc>$[s1z=`]a<C-g>u<Esc>')
imap('<C-l>', '<C-g>u<Esc>$[s1z=`]i<C-g>u');

nmap('<C-s>',  '<Cmd>w<CR>')
imap('<C-s>',  '<Cmd>w<CR>')

vmap('<', '<gv')
vmap('>', '>gv')

nvmap('<C-/>', '<Plug>NERDCommenterToggle', {noremap = false})

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

imap(';d', '$', {noremap = false})

-- normal 0~9 mappings {{{
--local special_symbol_key = ")!@#$%^&*("
--for i = 0, 9 do
--  map({'n', 'v', 'o'}, tostring(i), special_symbol_key:sub(i+1, i+1))
--  map({'n', 'v', 'o'}, special_symbol_key:sub(i+1, i+1), tostring(i))
--end
-- }}}


-------------------------------- for neovide -----------------------------------
g.neovide_refresh_rate = 90
g.neovide_remember_window_size = true
g.neovide_cursor_animation_length = 0.15

-- possible value: railgun, torpedo, pixiedust, sonicboom, ripple, wireframe
g.neovide_cursor_vfx_mode = "ripple"
opt('guifont', ':h13')
