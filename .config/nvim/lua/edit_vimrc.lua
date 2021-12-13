local Animate = require('animation').Animate

local globpath = vim.fn.globpath
local p = vim.fn.stdpath('config')

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
local anim = Animate:new()
  :cmd('tabedit '..globpath(p, 'init.lua')..'\n'..
    '0vsplit '..globpath(p, 'lua/config/plugins.lua')..'\n')
  :resize_vertically_delta(function () return math.floor(vim.o.columns/2) end, { delay = 200 })
  :cmd('0split '..globpath(p, 'lua/config/utils.lua'))
  :resize_delta(function () return math.floor(vim.o.lines/2 - 2) end, {delay = 200})

  :cmd('tabedit '..globpath(p, 'lua/config/plugins_ui.lua')..'\n'..
    set_fold_cmd..'0vsplit '..globpath(p, 'lua/config/plugins_editor.lua')..'\n'..
    set_fold_cmd)
  :resize_vertically_delta(function () return math.floor(vim.o.columns/2) end, { delay = 200 })
  :cmd('0split '..globpath(p, 'lua/config/plugins_ide.lua')..'\n'..
    set_fold_cmd)
  :resize_delta(function () return math.floor(vim.o.lines/2 - 2) end, {delay = 200})
  :cmd('wincmd h\n'..'0split '..globpath(p, 'lua/config/plugins_tool.lua')..'\n'..
    set_fold_cmd)
  :resize_delta(function () return math.floor(vim.o.lines/2 - 2) end, {delay = 200})


local function edit_vimrc()
  anim:start()
end

return {
  start = edit_vimrc
}

