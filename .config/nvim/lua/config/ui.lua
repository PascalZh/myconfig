local function statusline_encoding()
  local fenc = vim.o.fileencoding
  return fenc == 'utf-8' and '' or fenc
end
-- lightline config (unused) {{{
--g.lightline = {
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
--}

--cmd [[
--function! MyReadonly()
--  return &readonly ? '' : ''
--endfunction
--function! MyFiletype()
--  return winwidth(0) > 70 ? (strlen(&filetype) ? WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
--endfunction
--function! MyFileformat()
--  return winwidth(0) > 70 ? (WebDevIconsGetFileFormatSymbol()) : ''
--endfunction
--function! CocCurrentFunction()
--  return get(b:, 'coc_current_function', '')
--endfunction
--function! MyFenc()
--  return &fenc == 'utf-8'?'':&fenc
--endfunction
--func! MyTreesitter()
--  let ret=nvim_treesitter#statusline({'indicator_size': float2nr(winwidth(0) * 0.8)})
--  return ret == v:null ? '' : ret
--endf
--]]

--g['lightline#bufferline#show_number'] = 2
----g['lightline#bufferline#composed_number_map'] = {
---- ['1'] =  '⑴', ['2'] =  '⑵', ['3'] =  '⑶', ['4'] =  '⑷', ['5'] =  '⑸',
---- ['6'] =  '⑹', ['7'] =  '⑺', ['8'] =  '⑻', ['9'] =  '⑼', ['10'] = '⑽',
---- ['11'] = '⑾', ['12'] = '⑿', ['13'] = '⒀', ['14'] = '⒁', ['15'] = '⒂',
---- ['16'] = '⒃', ['17'] = '⒄', ['18'] = '⒅', ['19'] = '⒆', ['20'] = '⒇'
----}
--g['lightline#bufferline#read_only'] = ' '
--g['lightline#bufferline#enable_devicons'] = 1
--g['lightline#bufferline#clickable'] = 1
-- }}}

require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {'NvimTree', 'Outline'},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {statusline_encoding, 'fileformat', {'filetype', icon_only = true}},
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

