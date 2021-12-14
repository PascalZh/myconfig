local Animate = require('animation').Animate

local globpath = vim.fn.globpath
local p = vim.fn.stdpath('config')
-- The sequence of this table is hardcoded in the following codes, so don't
-- change the sequence, only appending the table is allowed.
local files = {
  'init.lua', 'lua/config/plugins.lua', 'lua/config/utils.lua',

  'lua/config/plugins_ui.lua', 'lua/config/plugins_editor.lua',
  'lua/config/plugins_ide.lua', 'lua/config/plugins_tool.lua',
  'lua/edit_vimrc.lua',
}
for i, _ in ipairs(files) do
  files[i] = globpath(p, files[i])
end
local edit_all_cmd = ''
for i, key in ipairs(files) do
  edit_all_cmd = edit_all_cmd..'e '..key..'\n'
end

vim.cmd[[
function MyFoldExpr(lnum)
  if getline(a:lnum) =~ "config = function ()" 
    return 'a1'
  elseif getline(a:lnum-1) =~ "end})"
    return 's1
  else
    return '='
endfunction
]]

local set_fold_cmd = [[setlocal foldexpr=MyFoldExpr(v:lnum)
setlocal foldmethod=expr
]]

local function half_width()
  return math.floor(vim.o.columns/2)
end
local function half_height()
  return math.floor(vim.o.lines/2) - 2
end

local delay = 20
local duration = 300
local anim = Animate:new()
  :cmd(edit_all_cmd)

  :cmd('tabedit '..files[1]..'\n'.. '0vsplit '..files[2]..'\n', {delay = 200})
  :resize_vertically_delta(half_width, {delay = delay, duration = duration})

  :cmd('0split '..files[3])
  :resize_delta(half_height, {delay = delay, duration = duration})

  :cmd('tabedit '..files[4]..'\n'.. set_fold_cmd..'0vsplit '..files[5]..'\n'.. set_fold_cmd)
  :resize_vertically_delta(half_width, {delay = delay, duration = duration})

  :cmd('0split '..files[6]..'\n'.. set_fold_cmd)
  :resize_delta(half_height, {delay = delay, duration = duration})

  :cmd('wincmd h\n'..'0split '..files[7]..'\n'.. set_fold_cmd)
  :resize_delta(half_height, {delay = delay, duration = duration})


local function edit_vimrc()
  anim:start()
end

return {
  start = edit_vimrc
}

