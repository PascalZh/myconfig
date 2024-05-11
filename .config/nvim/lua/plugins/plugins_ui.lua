local M = {}

table.insert(M, {
  'nvim-lualine/lualine.nvim',
  cond = MUtils.not_vscode,
  dependencies = { 'kyazdani42/nvim-web-devicons' },
  config = function() require('config.statusline.slanted-gaps') end
})

table.insert(M, {
  'lukas-reineke/indent-blankline.nvim',
  cond = MUtils.not_vscode,
  main = 'ibl',
  opts = {},
  --config = function ()
  --  local highlight = {
  --    "RainbowRed",
  --    "RainbowYellow",
  --    "RainbowBlue",
  --    "RainbowOrange",
  --    "RainbowGreen",
  --    "RainbowViolet",
  --    "RainbowCyan",
  --  }

  --  local hooks = require "ibl.hooks"
  --  -- create the highlight groups in the highlight setup hook, so they are reset
  --  -- every time the colorscheme changes
  --  hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  --    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
  --    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
  --    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
  --    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
  --    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
  --    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
  --    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
  --  end)

  --  require("ibl").setup { indent = { highlight = highlight } }
  --end
})

table.insert(M, {
  'romgrk/barbar.nvim',
  cond = MUtils.not_vscode,
  dependencies = { 'kyazdani42/nvim-web-devicons' }
})

table.insert(M,
  { 'NvChad/nvim-colorizer.lua', config = function() require('colorizer').setup() end })

table.insert(M, { 'rakr/vim-one' })

table.insert(M, { 'dracula/vim', name = 'dracula' })
table.insert(M, { "catppuccin/nvim", name = "catppuccin", priority = 1000 })

table.insert(M, { 'p00f/nvim-ts-rainbow', after = 'nvim-treesitter', event = 'BufRead' })

table.insert(M, { 'junegunn/goyo.vim', cond = MUtils.not_vscode })
table.insert(M, { 'junegunn/limelight.vim', cond = MUtils.not_vscode })

-- use 'itchyny/lightline.vim'
-- use {'mengelbrecht/lightline-bufferline', dependencies = {'ryanoasis/vim-devicons'}}

-- lightline config (unused) {{{
-- g.lightline = {
--  enable = {
--    statusline = 1,
--    tabline = 1,
--  },
--  colorscheme = 'PaperColor',
--  active = {
--    left = {
--      { 'mode', 'paste' },
--      { 'readonly', 'filename', 'modified', 'spell' },
--      { 'treesitter_status' }
--    }
--  },
--  tabline = {
--    left = { {'buffers'} },
--    right = { {'close'}, {'tabpage'} }
--  },

--  component = {
--    lineinfo = ' %l:%v',
--    percent = '%p%%',
--    close = '%999X  ',
--    tabpage = 'Tab %{tabpagenr()}%//%{tabpagenr("$")}% '
--  },
--  component_function = {
--    readonly = 'MyReadonly',
--    cocstatus = 'coc#status',
--    currentfunction = 'CocCurrentFunction',
--    filetype = 'MyFiletype',
--    fileformat = 'MyFileformat',
--    fileencoding = 'MyFenc',
--    treesitter_status = 'MyTreesitter' -- TODO: limiting len
--  },
--  component_expand = {
--    buffers = 'lightline#bufferline#buffers'
--  },
--  component_type = {
--    buffers = 'tabsel'
--  },
--  component_raw = {
--    buffers = 1
--  },
--  separator = { left = '', right = '' },
--  subseparator = { left = '│', right = '│' },
-- }

-- cmd [[
-- function! MyReadonly()
--  return &readonly ? '' : ''
-- endfunction
-- function! MyFiletype()
--  return winwidth(0) > 70 ? (strlen(&filetype) ? WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
-- endfunction
-- function! MyFileformat()
--  return winwidth(0) > 70 ? (WebDevIconsGetFileFormatSymbol()) : ''
-- endfunction
-- function! CocCurrentFunction()
--  return get(b:, 'coc_current_function', '')
-- endfunction
-- function! MyFenc()
--  return &fenc == 'utf-8'?'':&fenc
-- endfunction
-- func! MyTreesitter()
--  let ret=nvim_treesitter#statusline({'indicator_size': float2nr(winwidth(0) * 0.8)})
--  return ret == v:null ? '' : ret
-- endf
-- ]]

-- g['lightline#bufferline#show_number'] = 2
----g['lightline#bufferline#composed_number_map'] = {
---- ['1'] =  '⑴', ['2'] =  '⑵', ['3'] =  '⑶', ['4'] =  '⑷', ['5'] =  '⑸',
---- ['6'] =  '⑹', ['7'] =  '⑺', ['8'] =  '⑻', ['9'] =  '⑼', ['10'] = '⑽',
---- ['11'] = '⑾', ['12'] = '⑿', ['13'] = '⒀', ['14'] = '⒁', ['15'] = '⒂',
---- ['16'] = '⒃', ['17'] = '⒄', ['18'] = '⒅', ['19'] = '⒆', ['20'] = '⒇'
----}
-- g['lightline#bufferline#read_only'] = ' '
-- g['lightline#bufferline#enable_devicons'] = 1
-- g['lightline#bufferline#clickable'] = 1
-- }}}

return M
