local env = require('config.inject_env')
setmetatable(env, {__index = _G})
setfenv(1, env)

local packer = require('packer')

local packer_config = {
  display = {
    open_fn = require('packer.util').float,
  },
  git = {
    clone_timeout = 5 * 60,
  },
}
local M = packer.startup {
  function(use)
    use {'wbthomason/packer.nvim'}

    -- Library
    use 'nvim-lua/plenary.nvim'

    -- UI
    use 'itchyny/lightline.vim'
    use {'mengelbrecht/lightline-bufferline', requires = {'ryanoasis/vim-devicons'}}

    use 'rakr/vim-one'
    use {'dracula/vim', as = 'dracula'}
    use 'PascalZh/NeoSolarized'

    use {'kien/rainbow_parentheses.vim', config = function()
      vim.cmd[[
      au VimEnter * RainbowParenthesesToggle
      au Syntax * RainbowParenthesesLoadRound
      au Syntax * RainbowParenthesesLoadSquare
      au Syntax * RainbowParenthesesLoadBraces
      ]]
    end}
    --use { 'jose-elias-alvarez/buftabline.nvim', requires = {'kyazdani42/nvim-web-devicons'} }

    -- Editting
    use 'windwp/nvim-autopairs'
    use 'mg979/vim-visual-multi'

    use {'tpope/vim-surround', 'tpope/vim-repeat'}

    use {'preservim/nerdcommenter', config = function () vim.g.NERDDefaultAlign = 'left' end}

    use 'godlygeek/tabular'
    use 'mhinz/vim-grepper'

    use {'junegunn/goyo.vim', 'junegunn/limelight.vim'}
    --use 'junegunn/vim-peekaboo'
    use 'terryma/vim-expand-region'

    use 'chaoren/vim-wordmotion'

    use 'arthurxavierx/vim-caser'

    -- Code
    use {'hrsh7th/vim-vsnip', 'hrsh7th/vim-vsnip-integ', 'rafamadriz/friendly-snippets' }

    use 'neovim/nvim-lspconfig'

    use 'nvim-lua/completion-nvim'

    use 'airblade/vim-gitgutter'

    use 'nvim-treesitter/nvim-treesitter'

    use 'enomsg/vim-haskellConcealPlus'
    use 'neovimhaskell/haskell-vim'

    use 'dag/vim-fish'

    -- Other

    use 'mhinz/vim-startify'

    use {'kyazdani42/nvim-tree.lua', requires = {'kyazdani42/nvim-web-devicons'}}

    use 'mbbill/fencview'

    use {'lervag/vimtex', ft = {'tex', 'latex'}}
    use 'plasticboy/vim-markdown'
    use {'dstein64/vim-startuptime', config = function () vim.g.startuptime_self = 1 end}
    use 'folke/which-key.nvim'

  end,
  config = packer_config
}

local wk = require('which-key')

-- neovim/nvim-lspconfig {{{
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#clangd
require'lspconfig'.clangd.setup{
  cmd = { "clangd-11", "--background-index" },
}
-- }}}

-- nvim-lua/completion-nvim {{{
cmd('autocmd FileType '..
  'haskell,python,vim,cpp,c,javascript,lua,markdown '..
  'lua require"completion".on_attach()')

map('i', '<C-space>', '<Plug>(completion_trigger)', {noremap = false})

opt('completeopt', 'menuone,noinsert,noselect')
--cmd [[set shortmess+=c]]

g.completion_enable_auto_popup = 1
g.completion_enable_snippet = 'vim-vsnip'
g.completion_trigger_on_delete = 1
g.completion_timer_cycle = 200

g.completion_chain_complete_list = {
  default = {
    {complete_items = {'lsp', 'snippet'}},
    {complete_items = {'path'}},
    {mode = 'keyn'},
  }
}

map('i', '<c-j>', '<Plug>(completion_next_source)', {noremap = false})
map('i', '<c-k>', '<Plug>(completion_prev_source)', {noremap = false})
g.completion_auto_change_source = 0
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
local Rule = require('nvim-autopairs.rule')
local cond = require('nvim-autopairs.conds')

npairs.add_rules({
  Rule("$", "$",{"tex", "latex", "markdown"})
    -- don't add a pair if the next character is %
    --:with_pair(cond.not_after_regex_check("%%"))
    -- don't add a pair if  the previous character is xxx
    --:with_pair(cond.not_before_regex_check("xxx", 3))
    :with_move(cond.not_before_text_check('$'))
    -- don't delete if the next character is xx
    --:with_del(cond.not_after_regex_check("xx"))
    -- disable  add newline when press <cr>
    --:with_cr(cond.none())
  }
)

-- skip it, if you use another global object
_G.MUtils = MUtils == nil and {} or MUtils

vim.g.completion_confirm_key = ""

MUtils.completion_confirm=function()
  if vim.fn.pumvisible() ~= 0  then
    if vim.fn.complete_info()["selected"] ~= -1 then
      require'completion'.confirmCompletion()
      return npairs.esc("<c-y>")
    else
      return npairs.esc("<cr><cr>")
      --vim.api.nvim_select_popupmenu_item(0 , false , false ,{})
      --require'completion'.confirmCompletion()
      --return npairs.esc("<c-n><c-y>")
    end
  else
    return npairs.autopairs_cr()
  end
end

map('i', '<cr>','v:lua.MUtils.completion_confirm()', {expr = true})
-- }}}

-- kien/rainbow_parentheses.vim {{{
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
g.startify_files_number = 15
g.startify_change_to_vcs_root = 0
-- g.startify_enable_unsafe = 1
g.startify_lists = {
  { type = 'bookmarks', header = {'   Bookmarks'}      },
  { type = 'files'    , header = {'   MRU'}            },
  { type = 'commands' , header = {'   Commands'}       },
}
g.startify_bookmarks = {}
g.startify_commands = {
  ':help startify',
}
-- {'Vim Reference', 'h ref'},
-- {h = 'h ref'},
-- {m = {'My magical function', 'call Magic()'}},
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
  operator = {
    prompt = 1,
  },
}
cmd [[
let &statusline .= ' %{grepper#statusline()}'
]]
-- }}}
-- nvim-treesitter/nvim-treesitter {{{
-- take about 95ms to load this part
require'nvim-treesitter.configs'.setup {
  --ensure_installed = "all",
  highlight = {
    enable = true,  -- false will disable the whole extension
  },
  indent = {
    enable = true,
  },
}
if vim.fn.has('win32') then
  require'nvim-treesitter.install'.compilers = { "clang" }
end
-- }}}
-- plasticboy/vim-markdown {{{
g.vim_markdown_math = 1
g.vim_markdown_folding_disabled = 1
g.vim_markdown_new_list_item_indent = 2
-- }}}

-- kyazdani42/nvim-tree.lua {{{
g.nvim_tree_auto_close = 1
g.nvim_tree_follow = 1
g.nvim_tree_indent_markers = 1
g.nvim_tree_git_hl = 1
g.nvim_tree_highlight_opened_files = 1
g.nvim_tree_add_trailing = 0
g.nvim_tree_group_empty = 1
g.nvim_tree_hijack_cursor = 1
g.nvim_tree_special_files = {
  ['README.md'] = true, ['Makefile'] = true, ['MAKEFILE'] = true,
  ['CMakeLists.txt'] = true
}

-- }}}

-- mg979/vim-visual-multi {{{
g.VM_theme = 'iceblue'
g.VM_maps = {
  ['Move Right'] = '<M-S-l>',
  ['Move Left'] = '<M-S-h>',
}
-- }}}

-- tpope/vim-surround {{{
g['surround_'..string.byte('m')] = '-- \1\1 {{{\n\r\n-- }}}'
autocmd('Surround', { -- use BufEnter instead of FileType here to allow commentstring to be set
  [[BufEnter * let b:surround_{char2nr("m")} = ]] ..
    utils.prefix.func .. 'SurroundMarker()'
})
cmd('function! ' .. utils.prefix.func .. 'SurroundMarker()\n' ..
[[
  let l:start_marker = " \1comments: \1 {{{"
  let l:end_marker = " }}}"
  if &cms != ""
    let l:start_marker = printf(&cms, l:start_marker)
    let l:end_marker = printf(&cms, l:end_marker)
  endif
  return l:start_marker."\n\r\n".l:end_marker
endfunction
]]
)
-- }}}

-- arthurxavierx/vim-caser {{{
--g.caser_prefix = 'gc'
g.caser_no_mappings = 1
local function make_caser_mappings(prefix, table)
  for _, mapping in ipairs(table) do
    for _, lhs in ipairs(mapping[2]) do
      wk.register({[lhs] = {'<Plug>Caser'..mapping[3], mapping[1]}}, {prefix = prefix, noremap = false})
      wk.register({[lhs] = {'<Plug>CaserV'..mapping[3], mapping[1]}}, {prefix = prefix, mode = 'v', noremap = false})
    end
    wk.register({[string.sub(prefix, 2)] = { '<Nop>', "Case Coercion"}}, {prefix = string.sub(prefix, 1, 1)})
    wk.register({[string.sub(prefix, 2)] = { '<Nop>', "Case Coercion"}}, {prefix = string.sub(prefix, 1, 1), mode = 'v'})
  end
end
local caser_table = {
  {'MixedCase or PascalCase',             {'m', 'p' }, 'MixedCase'     },
  {'camelCase',                           {'c'      }, 'CamelCase'     },
  {'snake_case',                          {'_', 's' }, 'SnakeCase'     },
  {'UPPER_CASE',                          {'u', 'U' }, 'UpperCaser'    },
  {'Title Case',                          {'t'      }, 'TitleCase'     },
  {'Sentence case',                       {'S'      }, 'SentenceCase'  },
  {'space case',                          {'<space>'}, 'SpaceCaser'    },
  {'dash-case or kebab-case',             {'-', 'k' }, 'KebabCase'     },
  {'Title-Dash-Case or Title-Kebab-Case', {'K'      }, 'TitleKebabCase'},
  {'dot.case',                            {'.'      }, 'DotCase'       },
}
make_caser_mappings('<leader>k', caser_table)
-- }}}

-- jose-elias-alvarez/buftabline.nvim (unused) {{{
--require("buftabline").setup {
--  modifier = ":t",
--  index_format = "%d: ",
--  buffer_id_index = false,
--  padding = 1,
--  icons = true,
--  icon_colors = 'normal',
--  start_hidden = false,
--  auto_hide = true,
--  disable_commands = false,
--  go_to_maps = true,
--  kill_maps = false,
--  next_indicator = ">",
--  custom_command = nil,
--  custom_map_prefix = nil,
--  hlgroup_current = "TabLineSel",
--  hlgroup_normal = "TabLineFill",
--}
-- }}}

g.wordmotion_nomap = 1
map({'n', 'x'}, 'w',   '<Plug>WordMotion_w', {noremap = false})
map({'n', 'x'}, 'e',   '<Plug>WordMotion_e', {noremap = false})
map({'n', 'x'}, 'b',   '<Plug>WordMotion_b', {noremap = false})
map({'n', 'x'}, 'ge',  '<Plug>WordMotion_ge', {noremap = false})

wk.setup {
  operators = {},
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { "j", "k", ";" },
    v = { "j", "k" },
  },
}

return M
