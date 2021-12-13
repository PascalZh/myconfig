local M = {}

table.insert(M, {'windwp/nvim-autopairs',
  config = function ()
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
  end})

vim.g.loaded_matchit = 1  -- disable matchit
table.insert(M, 'andymass/vim-matchup')

table.insert(M, {'mg979/vim-visual-multi', keys = '<C-n>',
  config = function ()
    vim.g.VM_theme = 'iceblue'
    vim.g.VM_maps = {
      ['Move Right'] = '<M-S-l>',
      ['Move Left'] = '<M-S-h>',
    }
  end})

table.insert(M, 'tpope/vim-repeat')

table.insert(M, {'tpope/vim-surround',
  config = function ()
    local utils = require'config.utils'
    vim.g['surround_'..string.byte('m')] = '-- \1\1 {{{\n\r\n-- }}}'
    utils.autocmd('Surround', { -- use BufEnter instead of FileType here to allow commentstring to be set
      [[BufEnter * let b:surround_{char2nr("m")} = ]] ..
        utils.prefix.func .. 'SurroundMarker()'
    })
    vim.cmd('function! ' .. utils.prefix.func .. 'SurroundMarker()\n' ..
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
  end})

table.insert(M, {'preservim/nerdcommenter', config = function () vim.g.NERDDefaultAlign = 'left' end})

table.insert(M, 'godlygeek/tabular')

--use 'junegunn/vim-peekaboo'
table.insert(M, 'terryma/vim-expand-region')

table.insert(M, {'chaoren/vim-wordmotion',
  config = function ()
    vim.g.wordmotion_nomap = 1
    local nvremap_key = require'config.inject_env'.nvremap_key
    nvremap_key('w',   '<Plug>WordMotion_w')
    nvremap_key('e',   '<Plug>WordMotion_e')
    nvremap_key('b',   '<Plug>WordMotion_b')
    nvremap_key('ge',  '<Plug>WordMotion_ge')
  end})

table.insert(M, {'arthurxavierx/vim-caser',
  config = function ()
    local wk = MUtils.get_which_key()
    vim.g.caser_no_mappings = 1
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
  end})

table.insert(M, 'hrsh7th/vim-eft')

table.insert(M, 'notomo/gesture.nvim')

table.insert(M, {'hrsh7th/vim-vsnip', 'rafamadriz/friendly-snippets', cond = not_vscode})

table.insert(M, {'folke/which-key.nvim',
  config = function ()
    require'which-key'.setup {
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
  end})

return M

