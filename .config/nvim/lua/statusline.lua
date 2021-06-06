local cmd = vim.cmd
local g = vim.g
g.lightline = {
  enable = {
    statusline = 1,
    tabline = 1,
  },
  colorscheme = 'PaperColor',
  active = {
    left = {
      { 'mode', 'paste' },
      { 'readonly', 'filename', 'modified', 'spell' },
      { 'treesitter_status' }
    }
  },
  tabline = {
    left = { {'buffers'} },
    right = { {'close'}, {'tabpage'} }
  },

  component = {
    lineinfo = ' %l:%v',
    percent = '%p%%',
    close = '%999X  ',
    tabpage = 'Tab %{tabpagenr()}%//%{tabpagenr("$")}% '
  },
  component_function = {
    readonly = 'MyReadonly',
    cocstatus = 'coc#status',
    currentfunction = 'CocCurrentFunction',
    filetype = 'MyFiletype',
    fileformat = 'MyFileformat',
    fileencoding = 'MyFenc',
    treesitter_status = 'nvim_treesitter#statusline' -- TODO: limiting len
  },
  component_expand = {
    buffers = 'lightline#bufferline#buffers'
  },
  component_type = {
    buffers = 'tabsel'
  },
  component_raw = {
    buffers = 1
  },
  separator = { left = '', right = '' },
  subseparator = { left = '│', right = '│' },
}

cmd [[
function! MyReadonly()
  return &readonly ? '' : ''
endfunction
function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction
function! MyFileformat()
  return winwidth(0) > 70 ? (WebDevIconsGetFileFormatSymbol()) : ''
endfunction
function! CocCurrentFunction()
  return get(b:, 'coc_current_function', '')
endfunction
function! MyFenc()
  return &fenc == 'utf-8'?'':&fenc
endfunction
]]

g['lightline#bufferline#show_number'] = 2
--g['lightline#bufferline#composed_number_map'] = {
-- ['1'] =  '⑴', ['2'] =  '⑵', ['3'] =  '⑶', ['4'] =  '⑷', ['5'] =  '⑸',
-- ['6'] =  '⑹', ['7'] =  '⑺', ['8'] =  '⑻', ['9'] =  '⑼', ['10'] = '⑽',
-- ['11'] = '⑾', ['12'] = '⑿', ['13'] = '⒀', ['14'] = '⒁', ['15'] = '⒂',
-- ['16'] = '⒃', ['17'] = '⒄', ['18'] = '⒅', ['19'] = '⒆', ['20'] = '⒇'
--}
g['lightline#bufferline#read_only'] = ' '
g['lightline#bufferline#enable_devicons'] = 1
g['lightline#bufferline#clickable'] = 1
