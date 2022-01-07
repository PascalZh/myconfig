local M = {}
local not_vscode = function() return not vim.g.vscode end

table.insert(M, {
  'nvim-lualine/lualine.nvim',
  cond = not_vscode,
  requires = {'kyazdani42/nvim-web-devicons'},
  config = function()

    local function statusline_encoding()
      local fenc = vim.o.fileencoding
      return fenc == 'utf-8' and '' or fenc
    end

    require'lualine'.setup {
      options = {
        icons_enabled = true,
        theme = 'material',
        component_separators = {
          left = '',
          right = ''
        },
        section_separators = {
          left = '',
          right = ''
        },
        disabled_filetypes = {'NvimTree', 'Outline'},
        always_divide_middle = true
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {statusline_encoding, 'fileformat', {
          'filetype',
          icon_only = true
        }},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      extensions = {}
    }
  end
})

table.insert(M, {
  "lukas-reineke/indent-blankline.nvim",
  cond = not_vscode,
  config = function()
    vim.g.indent_blankline_filetype_exclude = {'help', 'qf', 'NvimTree', 'Outline', 'startuptime', 'packer',
                                               'ColorExplorer'}
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
      char_highlight_list = {"IndentBlanklineIndent1", "IndentBlanklineIndent2", "IndentBlanklineIndent3",
                             "IndentBlanklineIndent4", "IndentBlanklineIndent5", "IndentBlanklineIndent6"}
    }
  end
})

table.insert(M, {
  'romgrk/barbar.nvim',
  cond = not_vscode,
  requires = {'kyazdani42/nvim-web-devicons'}
})

table.insert(M, {'rakr/vim-one'})

table.insert(M, {'dracula/vim', as = 'dracula'})

table.insert(M, {"p00f/nvim-ts-rainbow", after = "nvim-treesitter", event = "BufRead"})

table.insert(M, {'junegunn/goyo.vim', cond = not_vscode})
table.insert(M, {'junegunn/limelight.vim', cond = not_vscode})

-- use 'itchyny/lightline.vim'
-- use {'mengelbrecht/lightline-bufferline', requires = {'ryanoasis/vim-devicons'}}

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

