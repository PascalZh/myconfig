local M = {}

table.insert(M, {
  'windwp/nvim-autopairs',
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
  end
})

vim.g.loaded_matchit = 1  -- disable matchit
table.insert(M, 'andymass/vim-matchup')

table.insert(M, {'mg979/vim-visual-multi', keys = '<C-n>'})

table.insert(M, {'tpope/vim-surround', 'tpope/vim-repeat'})

table.insert(M, {'preservim/nerdcommenter', config = function () vim.g.NERDDefaultAlign = 'left' end})

table.insert(M, 'godlygeek/tabular')

--use 'junegunn/vim-peekaboo'
table.insert(M, 'terryma/vim-expand-region')

table.insert(M, 'chaoren/vim-wordmotion')

table.insert(M, 'arthurxavierx/vim-caser')

table.insert(M, 'hrsh7th/vim-eft')

table.insert(M, 'notomo/gesture.nvim')

table.insert(M, {'hrsh7th/vim-vsnip', 'rafamadriz/friendly-snippets', cond = not_vscode})

table.insert(M, {
  'folke/which-key.nvim',
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
  end
})

return M

