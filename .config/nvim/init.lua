local _, utils = xpcall(function() return require('config.utils') end, print)

xpcall(function() require('config.plugins') end, print)
xpcall(function() require('config.mappings') end, print)

vim.g.netrw_browsex_viewer = 'cmd.exe /C start' -- TODO FIXME
vim.g.netrw_suppress_gx_mesg = 0

vim.api.nvim_create_augroup(utils.prefix.autocmd .. 'Init', { clear = true })

vim.api.nvim_create_autocmd('TermOpen', {
  pattern = '*', command = 'startinsert', group = utils.prefix.autocmd .. 'Init'
})

vim.api.nvim_create_autocmd('InsertEnter', {
  pattern = '*', callback = utils.im_select.insert_enter, group = utils.prefix.autocmd .. 'Init'
})
vim.api.nvim_create_autocmd('InsertLeavePre', {
  pattern = '*', callback = utils.im_select.insert_leave_pre, group = utils.prefix.autocmd .. 'Init'
})

vim.opt.autochdir = false

-- UI {{{

vim.opt.termguicolors = true
vim.opt.background = 'light'

-- Color Scheme
--cmd[[colorscheme NeoSolarized]]
vim.opt.laststatus = 3
local color_list = { 'dracula', 'NeoSolarized', 'one' }
if not vim.g.vscode then
  xpcall(function()
    vim.cmd('colorscheme ' ..
      color_list[1 + math.floor(vim.fn.localtime() / (7 * 24 * 60 * 60) % #color_list)])
  end
    , print
  )
end

-- Fold
vim.opt.foldtext = "repeat('〇 ',v:foldlevel).printf('%3d',v:foldend-v:foldstart+1).' '.getline(v:foldstart).' '"
vim.opt.fillchars = 'fold:·'

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'vim,racket,javascript,lua',
  command = 'setlocal foldmethod=marker | normal zM',
  group = utils.prefix.autocmd .. 'Init'
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'haskell,python,vim,cpp,c,javascript,lua',
  command = 'setlocal colorcolumn=81 | hi ColorColumn ctermbg=Green guibg=Green',
  group = utils.prefix.autocmd .. 'Init'
})
vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = '*',
  callback = function() utils.highlight.on_yank { higroup = "IncSearch", timeout = 222 } end,
  group = utils.prefix.autocmd .. 'Init'
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

vim.opt.scrolloff = 7 -- Minimum lines to keep above and below cursor

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
    name = 'win32yank',
    copy = {
      ['+'] = 'win32yank.exe -i --crlf',
      ['*'] = 'win32yank.exe -i --crlf',
    },
    paste = {
      ['+'] = 'win32yank.exe -o --lf',
      ['*'] = 'win32yank.exe -o --lf',
    },
    cache_enabled = 0,
  }
end
-- disable the following option because it is slowing down daily commands like s, dd
--opt('clipboard', 'unnamedplus') -- always use yanking to paste in other place
-- }}}
-- Spell {{{
vim.opt.spell = false
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown,tex',
  callback = function() vim.opt_local.spell = true end,
  group = utils.prefix.autocmd .. 'Init'
})
vim.opt.spelllang = 'en,cjk'
-- }}}
-- Miscellaneous {{{
vim.opt.timeoutlen = 500 -- also controls the delay of which-key
vim.opt.updatetime = 500 -- also controls the delay of gitgutter

vim.opt.virtualedit = 'onemore'

vim.opt.wrap = false

--vim.opt.smartindent = true

vim.opt.history = 1000

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- }}}

vim.cmd [[command! Zenmode execute "Goyo | Limelight"]]
vim.cmd [[command! SP lua require'animation'.split()]]
vim.cmd [[command! VS lua require'animation'.vsplit()]]

-------------------------------- for neovide -----------------------------------
vim.cmd [[
let g:neovide_refresh_rate = 90
let g:neovide_remember_window_size = v:true
let g:neovide_cursor_animation_length = 0.15

" possible value: railgun, torpedo, pixiedust, sonicboom, ripple, wireframe
let g:neovide_cursor_vfx_mode = "ripple"

set guifont=:h13
]]
