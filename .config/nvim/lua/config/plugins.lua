local env = require('config.inject_env')
setmetatable(env, {__index = _G})
setfenv(1, env)

local packer = require('packer')

local packer_config = {
  profile = {
    enable = true,
    threshold = 1 -- the amount in ms that a plugins load time must be over for it to be included in the profile
  },
  display = {
    open_fn = require('packer.util').float,
  },
  git = {
    clone_timeout = 5 * 60,
    --default_url_format = 'https://hub.fastgit.org/%s'
  },
}

local M = packer.startup {
  function (use)
    use {'wbthomason/packer.nvim'}

    use 'PascalZh/vim-color-explorer'

    -- Neovim Library {{{
    use 'nvim-lua/plenary.nvim'
    -- }}}

    -- UI {{{

    use {"lukas-reineke/indent-blankline.nvim", config = function ()
      vim.g.indent_blankline_filetype_exclude = {
        'help', 'qf', 'NvimTree', 'Outline', 'startuptime', 'packer',
        'ColorExplorer' }
      vim.opt.termguicolors = true
      vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]

      vim.opt.list = true
      -- vim.opt.listchars:append("space:⋅")
      vim.opt.listchars:append("eol:↴")

      require("indent_blankline").setup {
        space_char_blankline = " ",
        char_highlight_list = {
          "IndentBlanklineIndent1",
          "IndentBlanklineIndent2",
          "IndentBlanklineIndent3",
          "IndentBlanklineIndent4",
          "IndentBlanklineIndent5",
          "IndentBlanklineIndent6",
        },
      }
    end}

    use {
      'romgrk/barbar.nvim',
      requires = {'kyazdani42/nvim-web-devicons'}
    }

    --use 'itchyny/lightline.vim'
    --use {'mengelbrecht/lightline-bufferline', requires = {'ryanoasis/vim-devicons'}}

    use {
      'nvim-lualine/lualine.nvim',
      requires = {'kyazdani42/nvim-web-devicons', opt = true}
    }

    use 'rakr/vim-one'
    use {'dracula/vim', as = 'dracula'}
    use 'overcache/NeoSolarized'

    use {"p00f/nvim-ts-rainbow", opt = true,
      after = "nvim-treesitter",
      event = "BufRead"
    }

    --use { 'jose-elias-alvarez/buftabline.nvim', requires = {'kyazdani42/nvim-web-devicons'} }
    -- }}}

    -- Editting/Keyboard {{{
    use 'windwp/nvim-autopairs'
    use {'mg979/vim-visual-multi', keys = '<C-n>'}

    use {'tpope/vim-surround', 'tpope/vim-repeat'}

    use {'preservim/nerdcommenter', config = function () vim.g.NERDDefaultAlign = 'left' end}

    use 'godlygeek/tabular'

    use {'junegunn/goyo.vim', 'junegunn/limelight.vim'}
    --use 'junegunn/vim-peekaboo'
    use 'terryma/vim-expand-region'

    use 'chaoren/vim-wordmotion'

    use 'arthurxavierx/vim-caser'

    use 'hrsh7th/vim-eft'

    use 'notomo/gesture.nvim'

    use {'hrsh7th/vim-vsnip', 'rafamadriz/friendly-snippets' }

    use 'folke/which-key.nvim'

    -- }}}

    -- Code/IDE {{{

    use {'simrat39/symbols-outline.nvim', config = function ()
      vim.cmd('au FileType Outline setlocal nowrap | setlocal nolist | setlocal signcolumn=no')
      vim.g.symbols_outline = { width = 50 }
    end}

    -- Install nvim-cmp, and buffer source as a dependency
    use {'hrsh7th/nvim-cmp', requires = {
      'hrsh7th/vim-vsnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp'
    }}

    --use {'nvim-lua/completion-nvim', requires = {'hrsh7th/vim-vsnip', 'hrsh7th/vim-vsnip-integ'}}

    use 'neovim/nvim-lspconfig'

    use {'airblade/vim-gitgutter', disable = true}
    use {
      'lewis6991/gitsigns.nvim',
      requires = {
        'nvim-lua/plenary.nvim'
      },
      config = function()
        require('gitsigns').setup()
      end
    }

    use {'nvim-treesitter/nvim-treesitter', config = function ()
      require'nvim-treesitter.configs'.setup {
        --ensure_installed = "all",
        highlight = {
          enable = true,  -- false will disable the whole extension
        },
        indent = {
          enable = true,
        },
        autopairs = { enable = true },
          rainbow = {
            enable = true,
            -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
            extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
            max_file_lines = nil, -- Do not enable for files with more than n lines, int
            -- colors = {}, -- table of hex strings
            -- termcolors = {} -- table of colour name strings
          }
      }
      if vim.fn.has('win32') == 1 then
        require'nvim-treesitter.install'.compilers = { "clang" }
      end
    end}

    -- develop nvim plugins
    use {'mfussenegger/nvim-dap', config = function ()
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
    end}
    use {'jbyuki/one-small-step-for-vimkind', requires = 'mfussenegger/nvim-dap'}
    -- }}}

    -- Tools {{{
    use 'mhinz/vim-grepper'

    use {'gelguy/wilder.nvim', config = function ()
      vim.cmd[[call wilder#setup({'modes': [':', '/', '?']})]]
    end}

    use {'dstein64/vim-startuptime', config = function ()
      vim.g.startuptime_self = 1
      --vim.g.startuptime_exe_args = {'-u', 'NONE'}
    end}


    --use 'mhinz/vim-startify'

    use {'kyazdani42/nvim-tree.lua',
      requires = {'kyazdani42/nvim-web-devicons'},
      cmd = {'NvimTreeFocus', 'NvimTreeToggle'},
      config = function()
        require'nvim-tree'.setup {
          auto_close = true,
          hijack_cursor = true,
          update_focused_file = {
            enable      = true,
            update_cwd  = false,
            ignore_list = {}
          },
          --view = {
          --  width = 40
          --}
        }
      end}

    use 'mbbill/fencview'
    -- }}}

    -- Language Support {{{
    use {'lervag/vimtex', ft = {'tex', 'latex'}}
    use 'plasticboy/vim-markdown'
    use 'enomsg/vim-haskellConcealPlus'
    use 'neovimhaskell/haskell-vim'

    use 'dag/vim-fish'

    -- }}}

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

-- autopairs rules {{{
local Rule = require('nvim-autopairs.rule')
local cond = require('nvim-autopairs.conds')

npairs.add_rules(require('nvim-autopairs.rules.endwise-lua'))

npairs.add_rules({
  Rule("$", "$", {"tex", "latex", "markdown"})
    :with_move(cond.not_before_text_check('$'))
    :with_move(function (opts) return opts.char == '$' end)
  }
)

npairs.add_rules {
  Rule(' ', ' ')
    :with_pair(function(opts)
      local pair = opts.line:sub(opts.col - 1, opts.col)
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

-- }}}
-- hrsh7th/nvim-cmp {{{
local cmp = require'cmp'

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn['vsnip#available'](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn['vsnip#jumpable'](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' }
  }
}
-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- you need setup cmp first put this after cmp.setup() {{{

-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))
-- add a lisp filetype (wrap my-function), FYI: Hardcoded = { "clojure", "clojurescript", "fennel", "janet" }
cmp_autopairs.lisp[#cmp_autopairs.lisp+1] = "racket"

-- }}}

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
local sumneko_binary = sumneko_root_path..'/'..system_name..'/lua-language-server'

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

-- mhinz/vim-startify (unused) {{{
--g.startify_fortune_use_unicode = 1
--g.startify_files_number = 15
--g.startify_change_to_vcs_root = 0
---- g.startify_enable_unsafe = 1
--g.startify_lists = {
--  { type = 'bookmarks', header = {'   Bookmarks'}      },
--  { type = 'files'    , header = {'   MRU'}            },
--  { type = 'commands' , header = {'   Commands'}       },
--}
--g.startify_bookmarks = {}
--g.startify_commands = {
--  ':help startify',
--}
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
--g.nvim_tree_width = 40
--g.nvim_tree_indent_markers = 1
--g.nvim_tree_git_hl = 1
--g.nvim_tree_highlight_opened_files = 0
g.nvim_tree_group_empty = 1
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
wk.register({k = {name = 'Caser Coersion'}}, {prefix='<leader>'})
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
nvremap_key('w',   '<Plug>WordMotion_w')
nvremap_key('e',   '<Plug>WordMotion_e')
nvremap_key('b',   '<Plug>WordMotion_b')
nvremap_key('ge',  '<Plug>WordMotion_ge')
-- }}}

wk.setup {
  operators = {},
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { "j", "k", ";" },
    v = { "j", "k" },
    n = { 'v' }
  },
}

cmd [[
" or if you would like to use right click
nnoremap <RightMouse> <Nop>
nnoremap <silent> <RightDrag> <Cmd>lua require("gesture").draw()<CR>
nnoremap <silent> <RightRelease> <Cmd>lua require("gesture").finish()<CR>
]]

return M
