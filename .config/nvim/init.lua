local env = require('config.inject_env')
setmetatable(env, {__index = _G})
setfenv(1, env)

-- packer.nvim related {{{
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  MUtils.packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

autocmd('packer_user_config', {
  'BufWritePost plugins.lua echo "packer.nvim is compiling..." | source <afile> | PackerCompile'
})
-- }}}

require('config.plugins')

local wk = require'which-key'

vim.g.netrw_browsex_viewer = 'cmd.exe /C start' -- TODO FIXME
vim.g.netrw_suppress_gx_mesg = 0

autocmd('Term', {'TermOpen * startinsert'})

autocmd('ImSwitch', {
  'InsertEnter * lua MUtils.im_select.insert_enter()',
  'InsertLeavePre * lua MUtils.im_select.insert_leave_pre()'
})

vim.opt.autochdir = true

--------------------------------- Mappings -------------------------------------
local silent = {silent = true}
local expr = {expr = true}
vim.g.mapleader = " "

-- map * to search selected text in visual mode
xmap_key('*', [[y/\V<C-R>=escape(escape(@",'\'),'/')<CR><CR>]])

-- DO NOT USE <Cmd>...<CR>
xmap_key('X', ':call exchange_selected_text#delete()<CR>', silent)
iremap_key('j', 'easy_jk#map_j()', expr)
iremap_key('k', 'easy_jk#map_k()', expr)

imap_key('<C-f>', '<C-g>u<Esc>$[s1z=`]i<C-g>u')  -- Fix previous language mispells

nmap_key('<C-a>', ':%y+ <CR>')

-- Terminal mappings {{{
map_key('t', 'jk', '<C-\\><C-n>')
map_key('t', 'kj', '<C-\\><C-n>')
-- TODO: map JK to hide terminal

-- }}}

-- Common mappings {{{

-- Don't copy the replaced text after pasting in visual mode
vmap_key('p', '"_dP')

-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
-- empty mode is same as using :map
-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
nvomap_key("j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
nvomap_key("k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
nvomap_key("<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
nvomap_key("<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })

nmap_key('<Esc>', '<Cmd>nohlsearch<CR>')

--map_key('n', '<Tab>', '<Cmd>bnext<CR>')
--map_key('n', '<S-Tab>', '<Cmd>bNext<CR>')
--nmap_key(';;', 'za')

nmap_key('<C-s>',  '<Cmd>w<CR>')
imap_key('<C-s>',  '<Cmd>w<CR>')

vmap_key('<', '<gv')
vmap_key('>', '>gv')

-- }}}

-- better f/t/;{{{
vim.cmd [[
nmap ; <Plug>(eft-repeat)
xmap ; <Plug>(eft-repeat)

nmap f <Plug>(eft-f)
xmap f <Plug>(eft-f)
omap f <Plug>(eft-f)
nmap F <Plug>(eft-F)
xmap F <Plug>(eft-F)
omap F <Plug>(eft-F)

nmap t <Plug>(eft-t)
xmap t <Plug>(eft-t)
omap t <Plug>(eft-t)
nmap T <Plug>(eft-T)
xmap T <Plug>(eft-T)
omap T <Plug>(eft-T)
]]
-- }}}

-- leader key mappings {{{
nmap_key('<leader>ev', '<Cmd>lua require"edit_vimrc".start()<CR>')

nmap_key('<leader>G', '<Cmd>Grepper -tool git<CR>')
nvremap_key('<leader>g', '<Plug>(GrepperOperator)')

nmap_key('<leader>s', ':%s/')
vmap_key('<leader>s', ':s/')

nmap_key('<leader>S', '<Cmd>Startify<CR>')

nvmap_key('<leader>t<space>', ':Tabularize ')
nvmap_key('<leader>tt', ':Tabularize /')
nvmap_key('<leader>ta', ':Tabularize argument_list<CR>')
wk.register({t = {name = "Tabularize"}}, {prefix='<leader>'})

nmap_key('<leader>/', '<Plug>NERDCommenterToggle')
wk.register({c = {name = "NERD Commenter"}}, {prefix = '<leader>'})

-- }}}

-- Toggle mappings(begin with ,) {{{
nmap_key(',e', '<Cmd>NvimTreeToggle<CR>')
nmap_key(',l', '<Cmd>call quickfix_toggle#QuickfixToggle("ll")<cr>')
nmap_key(',q', '<Cmd>call quickfix_toggle#QuickfixToggle("qf")<cr>')

nmap_key(',bg', '<Cmd>lua MUtils.toggle_background()<CR>')
wk.register({b = {name = "Toggle Dark/Light Background"}}, {prefix = ','})

nmap_key(',s', '<Cmd>SymbolsOutline<CR>')
-- }}}

-- Scroll {{{
nmap_key('<C-d>', '<Cmd>lua require"animation".scroll_up_half()<CR>')
nmap_key('<C-f>', '<Cmd>lua require"animation".scroll_up()<CR>')
nmap_key('<C-u>', '<Cmd>lua require"animation".scroll_down_half()<CR>')
nmap_key('<C-b>', '<Cmd>lua require"animation".scroll_down()<CR>')
nremap_key('<PageDown>', '<C-f>')
nremap_key('<PageUp>', '<C-b>')
-- }}}

-- Window commands: jump/resize/quit/... {{{
nmap_key('<C-h>', '<C-w>h')
nmap_key('<C-j>', '<C-w>j')
nmap_key('<C-k>', '<C-w>k')
nmap_key('<C-l>', '<C-w>l')

local delta_resize = 6
nmap_key('<C-w><', string.rep('<C-w><', delta_resize * 2))
nmap_key('<C-w>>', string.rep('<C-w>>', delta_resize * 2))
nmap_key('<C-w>+', string.rep('<C-w>+', delta_resize))
nmap_key('<C-w>-', string.rep('<C-w>-', delta_resize))

nmap_key('<C-q>', '<C-w>q')
-- }}}

-- Debug mappings {{{
nmap_key('<F5>', ":lua require'dap'.continue()<CR>")
nmap_key('<F10>', ":lua require'dap'.step_over()<CR>")
nmap_key('<F11>', ":lua require'dap'.step_into()<CR>")
nmap_key('<F12>', ":lua require'dap'.step_out()<CR>")
nmap_key('<leader>db', ":lua require'dap'.toggle_breakpoint()<CR>")
nmap_key('<leader>dB', ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
nmap_key('<leader>dp', ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
nmap_key('<leader>dr', ":lua require'dap'.repl.open()<CR>")
nmap_key('<leader>dl', ":lua require'dap'.run_last()<CR>")

wk.register({d = {name = "Debug Adapter Protocol"}}, {prefix = '<leader>'})
-- }}}

wk.register({h = {name = "Gitsigns"}}, {prefix = '<leader>'})

-- BarBar buffer line mappings {{{
-- Move to previous/next
nremap_key('<leader>[', ':BufferPrevious<CR>')
nremap_key('<leader>]', ':BufferNext<CR>')
-- Re-order to previous/next
nremap_key('<leader><', ':BufferMovePrevious<CR>')
nremap_key('<leader>>', ' :BufferMoveNext<CR>')
-- Goto buffer in position...
nremap_key('<leader>1', ':BufferGoto 1<CR>')
nremap_key('<leader>2', ':BufferGoto 2<CR>')
nremap_key('<leader>3', ':BufferGoto 3<CR>')
nremap_key('<leader>4', ':BufferGoto 4<CR>')
nremap_key('<leader>5', ':BufferGoto 5<CR>')
nremap_key('<leader>6', ':BufferGoto 6<CR>')
nremap_key('<leader>7', ':BufferGoto 7<CR>')
nremap_key('<leader>8', ':BufferGoto 8<CR>')
nremap_key('<leader>9', ':BufferGoto 9<CR>')
nremap_key('<leader>0', ':BufferLast<CR>')
-- Close buffer
nremap_key('<leader>bc', ':BufferClose<CR>')
-- Wipeout buffer
--                 :BufferWipeout<CR>
-- Close commands
--                 :BufferCloseAllButCurrent<CR>
--                 :BufferCloseBuffersLeft<CR>
--                 :BufferCloseBuffersRight<CR>
-- Magic buffer-picking mode
nremap_key('<C-p>', ':BufferPick<CR>')
-- Sort automatically by...
nremap_key('<leader>bb', ':BufferOrderByBufferNumber<CR>')
nremap_key('<leader>bd', ':BufferOrderByDirectory<CR>')
nremap_key('<leader>bl', ':BufferOrderByLanguage<CR>')

-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used

wk.register({b = {name = "BarBar Buffer Operation"}}, {prefix = '<leader>'})
-- }}}

autocmd('LaTex', {'FileType tex,markdown imap ;d $'})

-- UI {{{
vim.opt.termguicolors = true
-- Color Scheme
--cmd[[colorscheme NeoSolarized]]
local color_list = {'dracula', 'NeoSolarized', 'one'}
if not vim.g.vscode then
  vim.cmd('colorscheme '..
    color_list[1 + math.floor(vim.fn.localtime() / (7 * 24 * 60 * 60) % #color_list)])
end
-- Fold
vim.opt.foldtext = "repeat('〇 ',v:foldlevel).printf('%3d',v:foldend-v:foldstart+1).' '.getline(v:foldstart).' ...'"
vim.opt.fillchars = 'fold: '

autocmd('FoldSetting', {
  'FileType vim,racket,javascript,lua '..
    'setlocal foldmethod=marker | normal zM',
})

autocmd('TUI', {
  'FileType haskell,python,vim,cpp,c,javascript,lua '..
    'setlocal colorcolumn=81 | hi ColorColumn ctermbg=Green guibg=Green',
  'TextYankPost * '..
    'lua MUtils.highlight.on_yank {higroup="IncSearch", timeout=222}',
})

-- Common UI settings {{{
vim.opt.showtabline = 2

vim.opt.showmode = false

vim.opt.winblend = 15
vim.opt.signcolumn = 'yes:2'

vim.opt.cursorline = true
vim.opt.cursorcolumn = false

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.list = true
vim.opt.listchars = 'tab:»⋅,nbsp:+,trail:⋅,extends:→,precedes:←'

vim.opt.scrolloff = 7  -- Minimum lines to keep above and below cursor

vim.opt.conceallevel = 2

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.wildmode = 'full'

vim.opt.inccommand = 'split'
vim.opt.mouse = 'a'
-- }}}

-- }}}
-- Format {{{
-- `formatoptions` is set by ftplugin/*.vim in neovim runtime folder and other
-- plugins' folder, I don't know how to override them. TODO
vim.opt.textwidth = 80
-- }}}
-- Tab {{{
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
-- }}}
-- Clipboard {{{
if vim.fn.exists('$WSL_DISTRO_NAME') == 1 then
  vim.g.clipboard = {
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
-- disable the following option because it is slowing down daily commands like
-- s, dd
--opt('clipboard', 'unnamedplus') -- always use yanking to paste in other place
-- }}}
-- Spell {{{
vim.opt.spell = false
autocmd('Spell', {
  [[FileType markdown,tex setlocal spell]]
})
vim.opt.spelllang = 'en,cjk'
-- }}}
-- Miscellaneous {{{
vim.opt.timeoutlen = 500 -- also controls the delay of which-key
vim.opt.updatetime = 500 -- also controls the delay of gitgutter

vim.opt.virtualedit = 'onemore'

vim.opt.wrap = false

vim.opt.smartindent = true

vim.opt.history = 1000

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- }}}

vim.cmd [[command! Zenmode execute "Goyo | Limelight"]]

-------------------------------- for neovide -----------------------------------
vim.cmd[[
let g:neovide_refresh_rate = 90
let g:neovide_remember_window_size = v:true
let g:neovide_cursor_animation_length = 0.15

" possible value: railgun, torpedo, pixiedust, sonicboom, ripple, wireframe
let g:neovide_cursor_vfx_mode = "ripple"

set guifont=:h13
]]

