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
  function (use)
    use {'wbthomason/packer.nvim'}

    -- Library
    use 'nvim-lua/plenary.nvim'

    -- UI
    use 'itchyny/lightline.vim'
    use {'mengelbrecht/lightline-bufferline', requires = {'ryanoasis/vim-devicons'}}

    use 'rakr/vim-one'
    use {'dracula/vim', as = 'dracula'}
    use 'PascalZh/NeoSolarized'

    use {'kien/rainbow_parentheses.vim', config = function ()
      -- TODO not compatible with treesitter
      vim.cmd [[
      au VimEnter * RainbowParenthesesActivate
      au Syntax * RainbowParenthesesLoadRound
      au Syntax * RainbowParenthesesLoadSquare
      au Syntax * RainbowParenthesesLoadBraces
      ]]
      vim.g.rbpt_max = 10
    end}
    --use { 'jose-elias-alvarez/buftabline.nvim', requires = {'kyazdani42/nvim-web-devicons'} }

    -- Editting
    use 'windwp/nvim-autopairs'
    use 'mg979/vim-visual-multi'

    use {'tpope/vim-surround', 'tpope/vim-repeat'}

    use {'preservim/nerdcommenter', config = function () vim.g.NERDDefaultAlign = 'left' end}

    use 'godlygeek/tabular'

    use {'junegunn/goyo.vim', 'junegunn/limelight.vim'}
    --use 'junegunn/vim-peekaboo'
    use 'terryma/vim-expand-region'

    use 'chaoren/vim-wordmotion'

    use 'arthurxavierx/vim-caser'

    -- Code
    use {'hrsh7th/vim-vsnip', 'rafamadriz/friendly-snippets' }

    -- Install nvim-cmp, and buffer source as a dependency
    use {'hrsh7th/nvim-cmp', requires = {
      'hrsh7th/vim-vsnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp'
    }}

    --use {'nvim-lua/completion-nvim', requires = {'hrsh7th/vim-vsnip', 'hrsh7th/vim-vsnip-integ'}}

    use 'neovim/nvim-lspconfig'

    use 'airblade/vim-gitgutter'

    use 'nvim-treesitter/nvim-treesitter'

    use 'enomsg/vim-haskellConcealPlus'
    use 'neovimhaskell/haskell-vim'

    use 'dag/vim-fish'

    -- IDE
    use {'jbyuki/one-small-step-for-vimkind', requires = 'mfussenegger/nvim-dap'}

    -- Other

    use 'mhinz/vim-grepper'

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

-- WARNING: the sequence can not changed without looking into all codes
-- windwp/nvim-autopairs {{{
local npairs = require('nvim-autopairs')
npairs.setup {
  fast_wrap = {},
  check_ts = true
}

local Rule = require('nvim-autopairs.rule')
local cond = require('nvim-autopairs.conds')

npairs.add_rules(require('nvim-autopairs.rules.endwise-lua'))

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

npairs.add_rules {
  Rule(' ', ' ')
    :with_pair(function(opts)
      local pair = opts.line:sub(opts.col -1, opts.col)
      return vim.tbl_contains({ '()', '{}', '[]' }, pair)
    end)
    :with_move(cond.none())
    :with_cr(cond.none())
    :with_del(function(opts)
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local context = opts.line:sub(col - 1, col + 2)
      return vim.tbl_contains({ '(  )', '{  }', '[  ]' }, context)
    end),
  Rule('', ' )')
    :with_pair(cond.none())
    :with_move(function(opts) return opts.char == ')' end)
    :with_cr(cond.none())
    :with_del(cond.none())
    :use_key(')'),
  Rule('', ' }')
    :with_pair(cond.none())
    :with_move(function(opts) return opts.char == '}' end)
    :with_cr(cond.none())
    :with_del(cond.none())
    :use_key('}'),
  Rule('', ' ]')
    :with_pair(cond.none())
    :with_move(function(opts) return opts.char == ']' end)
    :with_cr(cond.none())
    :with_del(cond.none())
    :use_key(']'),
}
-- }}}
-- hrsh7th/nvim-cmp {{{
local cmp = require'cmp'

local check_back_space = function()
  local col = vim.fn.col '.' - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match '%s' ~= nil
end

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-u>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(t("<C-n>"), "n")
      elseif vim.fn['vsnip#available'](1) == 1 then
        vim.fn.feedkeys(t("<Plug>(vsnip-expand-or-jump)"), "")
      elseif check_back_space() then
        vim.fn.feedkeys(t("<Tab>"), "n")
      else
        fallback()
      end
    end, {
        "i",
        "s",
      }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(t("<C-p>"), "n")
      elseif vim.fn['vsnip#jumpable'](-1) == 1 then
        vim.fn.feedkeys(t("<Plug>vsnip-jump-prev"), "")
      else
        fallback()
      end
    end, {
        "i",
        "s",
      }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' }
  }
}
-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- you need setup cmp first put this after cmp.setup()
require("nvim-autopairs.completion.cmp").setup({
  map_cr = true, --  map <CR> on insert mode
  map_complete = true, -- it will auto insert `(` after select function or method item
  auto_select = true -- automatically select the first item
})

-- }}}
-- neovim/nvim-lspconfig {{{

-- sumneko lua lsp {{{
local system_name
if vim.fn.has("mac") == 1 then
  system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
  system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
  system_name = "Windows"
else
  print("Unsupported system for sumneko")
end

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local sumneko_root_path = fn.expand('$HOME/Programs/lua-language-server')
local sumneko_binary = sumneko_root_path..'/bin/'..
  system_name..'/lua-language-server'

local lua_globals = {'vim'}
for k, v in pairs(require('config.inject_env')) do
  table.insert(lua_globals, k)
end

require'lspconfig'.sumneko_lua.setup {
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = lua_globals,
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
  capabilities = capabilities
}
-- }}}

-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#clangd
require'lspconfig'.clangd.setup{
  cmd = { "clangd-11", "--background-index" },
  capabilities = capabilities
}
-- }}}
-- nvim-lua/completion-nvim (unused) {{{
--cmd('autocmd FileType '..
--  'haskell,python,vim,cpp,c,javascript,lua,markdown '..
--  'lua require"completion".on_attach()')

--map('i', '<C-space>', '<Plug>(completion_trigger)', {noremap = false})

--opt('completeopt', 'menuone,noinsert,noselect')
----cmd [[set shortmess+=c]]

----g.completion_enable_auto_popup = 1
--g.completion_enable_snippet = 'vim-vsnip'
----g.completion_timer_cycle = 80

--g.completion_trigger_keyword_length = 2
--g.completion_trigger_on_delete = 1
----g.completion_enable_server_trigger = 1

---- sumneko uses triggerCharacters ['\n', '\t', ' ', ...], it will cause
---- completion to trigger on space in VSCode, triggerCharacters are processed
---- differently, so it will not popup on space
--autocmd('CompletionTriggerCharacter', {
--  'BufEnter *.c,*.cpp let g:completion_enable_server_trigger = 1',
--  'BufEnter *.lua let g:completion_trigger_character = [".", ":"]'..
--    '|let g:completion_enable_server_trigger = 0'
--})

--g.completion_chain_complete_list = {
--  default = {
--    default = {
--      {complete_items = {'lsp'}},
--      {complete_items = {'snippet'}},
--      {complete_items = {'path'}, triggered_only = {'/'}},
--      {mode = 'keyn'}
--    },
--    comment = {
--      {mode = 'keyn'}
--    }
--  }
--}
----g.completion_auto_change_source = 0

--map('i', '<c-j>', '<Plug>(completion_next_source)', {noremap = false})
--map('i', '<c-k>', '<Plug>(completion_prev_source)', {noremap = false})
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
  autopairs = { enable = true }
}
if vim.fn.has('win32') then
  require'nvim-treesitter.install'.compilers = { "clang" }
end
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
-- tmsvg/pear-tree (unused) {{{
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
-- plasticboy/vim-markdown {{{
g.vim_markdown_math = 1
g.vim_markdown_folding_disabled = 1
g.vim_markdown_new_list_item_indent = 2
-- }}}

-- kyazdani42/nvim-tree.lua {{{
--g.nvim_tree_follow = 0
g.nvim_tree_width = 40
g.nvim_tree_auto_close = 1
g.nvim_tree_indent_markers = 1
g.nvim_tree_git_hl = 1
--g.nvim_tree_highlight_opened_files = 0
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
-- chaoren/vim-wordmotion {{{
g.wordmotion_nomap = 1
map({'n', 'x'}, 'w',   '<Plug>WordMotion_w', {noremap = false})
map({'n', 'x'}, 'e',   '<Plug>WordMotion_e', {noremap = false})
map({'n', 'x'}, 'b',   '<Plug>WordMotion_b', {noremap = false})
map({'n', 'x'}, 'ge',  '<Plug>WordMotion_ge', {noremap = false})
-- }}}

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

local dap = require"dap"
dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = "Attach to running Neovim instance",
  }
}

dap.adapters.nlua = function(callback, config)
  callback({ type = 'server', host = config.host or '127.0.0.1', port = config.port or 8088 })
end

return M
