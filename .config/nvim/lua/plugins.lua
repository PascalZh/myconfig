local g = vim.g
local cmd = vim.cmd
local o, wo, bo = vim.o, vim.wo, vim.bo
local execute = vim.api.nvim_command
local fn = vim.fn

local utils = require('config.utils')
local opt = utils.opt
local autocmd = utils.autocmd
local map = utils.map

local packer = require('packer')

local config = {
  display = {
    open_fn = require('packer.util').float,
  },
  git = {
    clone_timeout = 5 * 60,
  },
}
local ret = packer.startup({
  function(use)
    use 'wbthomason/packer.nvim'

    -- UI
    use 'itchyny/lightline.vim'
    use 'rakr/vim-one'
    use {'dracula/vim', as = 'dracula'}
    use 'PascalZh/NeoSolarized'

    use {'kien/rainbow_parentheses.vim', ft = {'racket', 'scheme', 'lisp'}}

    -- Editting
    use 'windwp/nvim-autopairs'
    use 'mg979/vim-visual-multi'

    use 'tpope/vim-surround' use 'tpope/vim-repeat'

    use 'preservim/nerdcommenter'
    use 'godlygeek/tabular'
    use 'mhinz/vim-grepper'

    use 'junegunn/goyo.vim'
    use 'junegunn/limelight.vim'
    --use 'junegunn/vim-peekaboo'
    use 'terryma/vim-expand-region'

    -- Code
    use 'hrsh7th/vim-vsnip'
    use 'hrsh7th/vim-vsnip-integ'
    use "rafamadriz/friendly-snippets"

    use 'neovim/nvim-lspconfig'
    use 'nvim-lua/completion-nvim'

    use 'airblade/vim-gitgutter'

    use 'nvim-treesitter/nvim-treesitter'
    use 'enomsg/vim-haskellConcealPlus'
    use 'neovimhaskell/haskell-vim'
    use 'dag/vim-fish'

    -- Other

    use 'mhinz/vim-startify'

    use 'ryanoasis/vim-devicons'
    use 'kyazdani42/nvim-web-devicons'
    use {'kyazdani42/nvim-tree.lua', opt = true, cmd = 'NvimTreeToggle'}

    use 'mbbill/fencview'

    use {'lervag/vimtex', ft = 'tex'}
    use 'plasticboy/vim-markdown'
    use 'dstein64/vim-startuptime'

  end,
  config = config
})

-- neovim/nvim-lspconfig {{{
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#clangd
require'lspconfig'.clangd.setup{
  cmd = { "clangd-10", "--background-index" },
}
-- }}}

-- nvim-lua/completion-nvim {{{
cmd("autocmd FileType "..
"haskell,python,vim,cpp,c,javascript,lua,markdown "..
[[lua require'completion'.on_attach()]])

map('i', '<C-n>', '<Plug>(completion_trigger)', {noremap = false})

opt('completeopt', 'menuone,noinsert')
--cmd [[set shortmess+=c]]

g.completion_enable_auto_popup = 1
g.completion_enable_snippet = 'vim-vsnip'
g.completion_trigger_on_delete = 1
g.completion_timer_cycle = 200
-- }}}

-- hrsh7th/vim-vsnip {{{
map('i', '<Tab>', [[pumvisible() ? '<C-n>' : vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>']],
  {expr = true, noremap = false})
map('s', '<Tab>', [[vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>']],
  {expr = true, noremap = false})

map('i', '<S-Tab>', [[pumvisible() ? '<C-p>' : vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>']],
  {expr = true, noremap = false})
map('s', '<S-Tab>', [[vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>']],
  {expr = true, noremap = false})
g.vsnip_snippet_dir = '~/.local/share/nvim/site/pack/packer/start/friendly-snippets/snippets/'

-- }}}

-- windwp/nvim-autopairs {{{
local npairs = require('nvim-autopairs')
npairs.setup()

-- skip it, if you use another global object
_G.MUtils= {}

vim.g.completion_confirm_key = ""

MUtils.completion_confirm=function()
  if vim.fn.pumvisible() ~= 0  then
    if vim.fn.complete_info()["selected"] ~= -1 then
      require'completion'.confirmCompletion()
      return npairs.esc("<c-y>")
    else
      vim.api.nvim_select_popupmenu_item(0 , false , false ,{})
      require'completion'.confirmCompletion()
      return npairs.esc("<c-n><c-y>")
    end
  else
    return npairs.autopairs_cr()
  end
end


map('i', '<CR>','v:lua.MUtils.completion_confirm()', {expr = true})
-- }}}

-- rainbow parentheses {{{
g.rbpt_colorpairs = {
  {'brown',       'RoyalBlue3' },
  {'Darkblue',    'SeaGreen3'  },
  {'darkgray',    'DarkOrchid3'},
  {'darkgreen',   'firebrick3' },
  {'darkcyan',    'RoyalBlue3' },
  {'darkred',     'SeaGreen3'  },
  {'brown',       'firebrick3' },
  {'darkmagenta', 'DarkOrchid3'},
  {'Darkblue',    'firebrick3' },
  {'darkgreen',   'RoyalBlue3' },
  {'darkcyan',    'SeaGreen3'  },
  {'darkred',     'DarkOrchid3'},
  {'red',         'firebrick3' },
}

g.rbpt_max = 16
g.rbpt_loadcmd_toggle = 0
-- }}}
-- mhinz/vim-startify {{{
g.startify_fortune_use_unicode = 1
g.startify_files_number = 7
g.startify_change_to_vcs_root = 0
-- g.startify_enable_unsafe = 1
g.startify_lists = {
  {type = 'bookmarks', header = {'   Bookmarks'}      },
  {type = 'files'    , header = {'   MRU'}            },
  {type = 'commands' , header = {'   Commands'}       },
}
g.startify_bookmarks = {'~/.vim/bundle/omniwindow.nvim/lua/omniwindowlib/ui.lua'}
g.startify_commands = {
  ':help startify',
}
-- {'Vim Reference', 'h ref'},
-- {h = 'h ref'},
-- {m = {'My magical function', 'call Magic()'}},
-- }}}
-- preservim/nerdcommenter {{{
g.NERDDefaultAlign = 'left'
-- }}}
-- tmsvg/pear-tree {{{
-- Default rules for matching:
--g.pear_tree_pairs = {
--  ['('] = {closer = ')'},
--  ['['] = {closer = ']'},
--  ['{'] = {closer = '}'},
--  ["'"] = {closer = "'"},
--  ['"'] = {closer = '"'},
--}
--cmd("au FileType markdown let b:pear_tree_pairs = {"..
--  "'(': {'closer': ')', 'not_at': ['lr']},"..
--  "'[': {'closer': ']', 'not_at': ['lr']},"..
--  "'{': {'closer': '}', 'not_at': ['lr']},"..
--  [["'": {'closer': "'"},]]..
--  [['"': {'closer': '"'},]]..
--  "}")

---- Pear Tree is enabled for all filetypes by default:
--g.pear_tree_ft_disabled = {}

---- Pair expansion is dot-repeatable by default:
--g.pear_tree_repeatable_expand = 0

---- Smart pairs are disabled by default:
--g.pear_tree_smart_openers = 1
--g.pear_tree_smart_closers = 1
--g.pear_tree_smart_backspace = 1

---- If enabled, smart pair functions timeout after 60ms:
--g.pear_tree_timeout = 60

---- Automatically map <BS>, <CR>, and <Esc>
--g.pear_tree_map_special_keys = 0
--map('i', '<BS>', '<Plug>(PearTreeBackspace)',{noremap=false})
--map('i', '<CR>', '<Plug>(PearTreeExpand)',{noremap=false})
--map('i', '<Space>', '<Plug>(PearTreeSpace)',{noremap=false})
--map('i', '<C-j>', '<Plug>(PearTreeJump)',{noremap=false})
-- remap of <ESC> will cause some conflicts with other plugins, so it will be
-- integrated in my `easy_jk` plugin.

-- Default mappings:
--imap <BS> <Plug>(PearTreeBackspace)
--imap <CR> <Plug>(PearTreeExpand)
--imap <Esc> <Plug>(PearTreeFinishExpansion)
-- Pear Tree also makes <Plug> mappings for each opening and closing string.
--     :help <Plug>(PearTreeOpener)
--     :help <Plug>(PearTreeCloser)

-- Not mapped by default:
-- <Plug>(PearTreeSpace)
-- <Plug>(PearTreeJump)
-- <Plug>(PearTreeExpandOne)
-- <Plug>(PearTreeJNR)
-- }}}
-- mhinz/vim-grepper {{{
g.grepper = {
  tools = {'git', 'ack'},
  prompt_text = '$c=> ',
  jump = 0,
}
-- }}}
-- nvim-treesitter/nvim-treesitter {{{
-- take about 95ms to load this part
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  highlight = {
    enable = true,  -- false will disable the whole extension
  },
  indent = {
    enable = true,
  },
}
-- }}}
-- plasticboy/vim-markdown {{{
g.vim_markdown_math = 1
g.vim_markdown_folding_disabled = 1
g.vim_markdown_new_list_item_indent = 2
-- }}}

-- dstein64/vim-startuptime {{{
g.startuptime_self = 1
-- }}}

return ret
