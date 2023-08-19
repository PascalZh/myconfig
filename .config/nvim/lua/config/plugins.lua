local utils = require('config.utils')

local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  MUtils.packer_bootstrap = vim.fn.system({
    'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path
  })
  vim.cmd [[packadd packer.nvim]]
  print('packer.nvim has been installed.')
end

vim.api.nvim_create_augroup(utils.prefix.autocmd .. 'Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = string.gsub(vim.fn.expand '$HOME/.config/nvim/lua/config/*.lua', '\n', ','),
  callback = function()
    vim.cmd [[source ~/.config/nvim/lua/config/plugins.lua]]
    vim.cmd [[PackerCompile]]
    vim.notify('PackerCompile done!', vim.log.levels.INFO, { title = utils.prefix.notify_title })
  end,
  group = utils.prefix.autocmd .. 'Packer'
})

local packer = require('packer')

local packer_config = {
  -- profile = {
  --   enable = false,
  --   threshold = 1 -- the amount in ms that a plugins load time must be over for it to be included in the profile
  -- },
  display = { open_fn = require('packer.util').float },
  git = {
    clone_timeout = 5 * 60
    -- default_url_format = 'https://hub.fastgit.org/%s'
  }
}

local M = packer.startup {
  function(use)
    use { 'wbthomason/packer.nvim' }

    use 'PascalZh/vim-color-explorer'
    use 'PascalZh/NeoSolarized'

    -- Neovim Library
    use 'nvim-lua/plenary.nvim'
    use { 'rcarriga/nvim-notify', config = function() vim.notify = require 'notify' end }

    package.loaded['config.plugins_ui'] = nil
    for _, plugin in ipairs(require 'config.plugins_ui') do use(plugin) end

    package.loaded['config.plugins_editor'] = nil
    for _, plugin in ipairs(require 'config.plugins_editor') do use(plugin) end

    package.loaded['config.plugins_tool'] = nil
    for _, plugin in ipairs(require 'config.plugins_tool') do use(plugin) end

    package.loaded['config.plugins_ide'] = nil
    for _, plugin in ipairs(require 'config.plugins_ide') do use(plugin) end

    if MUtils.packer_bootstrap then require('packer').sync() end
  end,
  config = packer_config
}

return M
