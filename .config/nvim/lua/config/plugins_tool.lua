local M = {}
local not_vscode = function() return not vim.g.vscode end

table.insert(M, {
  'mhinz/vim-grepper',
  config = function()
    vim.g.grepper = {
      tools = {'git', 'ack'},
      prompt_text = '$c=> ',
      jump = 0,
      operator = {
        prompt = 1
      }
    }
    vim.cmd [[
    let &statusline .= ' %{grepper#statusline()}'
    ]]
  end
})

table.insert(M, {
  'gelguy/wilder.nvim',
  cond = not_vscode,
  config = function()
    vim.cmd [[call wilder#setup({'modes': [':', '/', '?']})]]
  end
})

table.insert(M, {
  'dstein64/vim-startuptime',
  cond = not_vscode,
  config = function()
    vim.g.startuptime_self = 1
    -- vim.g.startuptime_exe_args = {'-u', 'NONE'}
  end
})

-- use 'mhinz/vim-startify'

table.insert(M, {
  'kyazdani42/nvim-tree.lua',
  cond = not_vscode,
  requires = {'kyazdani42/nvim-web-devicons'},
  cmd = {'NvimTreeFocus', 'NvimTreeToggle'},
  config = function()
    require'nvim-tree'.setup {
      auto_close = true,
      hijack_cursor = true,
      update_focused_file = {
        enable = true,
        update_cwd = false,
        ignore_list = {}
      }
      -- view = {
      --  width = 40
      -- }
    }
    vim.g.nvim_tree_group_empty = 1
    vim.g.nvim_tree_special_files = {
      ['README.md'] = true,
      ['Makefile'] = true,
      ['MAKEFILE'] = true,
      ['CMakeLists.txt'] = true
    }
  end
})

table.insert(M, 'mbbill/fencview')

return M

