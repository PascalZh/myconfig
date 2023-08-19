local function statusline_encoding()
  local fenc = vim.o.fileencoding
  return fenc == 'utf-8' and '' or fenc
end

require 'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'papercolor_dark',
    component_separators = {
      left = '',
      right = ''
    },
    section_separators = {
      left = '',
      right = ''
    },
    disabled_filetypes = { 'NvimTree', 'Outline' },
    always_divide_middle = true
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { statusline_encoding, 'fileformat', {
      'filetype',
      icon_only = true
    } },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}
