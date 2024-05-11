return {
  'PascalZh/vim-color-explorer',
  'PascalZh/NeoSolarized',

  -- Neovim Library
  'nvim-lua/plenary.nvim',
  { 'rcarriga/nvim-notify', config = function() vim.notify = require 'notify' end },
}
